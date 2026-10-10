module

public meta import Cite.Basic

public meta section

/-!
`@[cite]` marks a declaration as part of what a blueprint node states.

    attribute [cite] exists_hilbertBasis

It is declared here, in the library's root, so that `import Cite` is the
import that names the module a citation uses, which is what `lake shake` asks
for. The environment extension it records into is `Cite.Basic`'s.
-/

open Lean Elab

namespace Cite

/-- Cites this declaration for the blueprint node this file formalizes. -/
syntax (name := citeAttr) "cite" : attr

initialize registerBuiltinAttribute {
  name := `citeAttr
  descr := "Cite this declaration for the blueprint node this file formalizes"
  applicationTime := .afterCompilation
  add := fun decl _ kind => do
    -- A citation is a global fact, so `scoped` and `local` must not succeed.
    unless kind == AttributeKind.global do
      throwError "invalid attribute 'cite': must be global (not `scoped` or `local`)"
    -- A second citation would be lost, leaving its node looking formalized
    -- while contributing nothing.
    if isCited (← getEnv) decl then
      throwError "{.ofConstName decl} is already cited by a blueprint node"
    modifyEnv fun env => citeExt.addEntry env decl
    trace[cite] "cited {.ofConstName decl}"
}

end Cite
