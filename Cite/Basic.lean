module

public meta import Lean

public meta section

/-!
The environment extension behind `@[cite]`.

Persistent, necessarily: a cited declaration is never in the module that cites
it, so the citations are only ever read through `import`.
-/

open Lean

namespace Cite

initialize registerTraceClass `cite

/-- The cited declarations.

`PersistentEnvExtension.getModuleEntries` on this gives a citation's *site*: the
module that applied the attribute, which is the blueprint node. -/
initialize citeExt : SimplePersistentEnvExtension Name NameSet ←
  registerSimplePersistentEnvExtension {
    addEntryFn := fun s n => s.insert n
    addImportedFn := fun es => mkStateFromImportedEntries (fun s n => s.insert n) {} es
  }

/-- Is this declaration cited by a blueprint node? -/
def isCited (env : Environment) (n : Name) : Bool :=
  (citeExt.getState env).contains n

/-- Every cited declaration. -/
def cited (env : Environment) : NameSet :=
  citeExt.getState env

end Cite
