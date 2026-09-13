# `cite` — a blueprint citation attribute for Lean

The attribute is intended to be used with a blueprint system that pairs a LaTeX 
document with a Lean library. The library holds one file per node, that is, 
a natural language definition or claim in the LaTeX document. The citation 
attribute says that a declaration *elsewhere* formalises such node or its part:

```lean
module
import Cite
import Mathlib.Analysis.InnerProductSpace.l2Space

attribute [cite] exists_hilbertBasis
attribute [cite] HilbertBasis.hasSum_repr
```

The attribute itself knows nothing about the LaTeX document. 

The library has no dependencies and pins no toolchain.

## Errors

Citing one declaration from two nodes is refused — the second citation would be
lost, and its node would look formalised while contributing nothing:

```
error: exists_hilbertBasis is already cited by a blueprint node
```

`scoped` and `local` are refused too. A citation is a global fact, so a form
that quietly limited its visibility would produce a blueprint that is right in
one file and wrong everywhere else.

## Requirements

Lean's module system. These files begin with `module`, because Lean will not
import a non-`module` package from one that does, and Mathlib is module-based.
They are also `meta`: attribute registration runs at elaboration time, and
without `meta` the import succeeds while every use fails with `Unknown attribute
[citeAttr]`.

## Adding it to a project

`lakefile.toml`:

```toml
[[require]]
name = "cite"
git = "https://github.com/l-oksanen/cite"
```

## For tool authors

Citations are stored in a persistent environment extension, so they survive
`import`. `Cite.isCited` and `Cite.cited` read the state, and
`PersistentEnvExtension.getModuleEntries Cite.citeExt` gives the citation site.

The attribute applies after compilation, so a citation is not visible to a later
command in the file that wrote it. `CiteTests/Imported.lean` asserts the
property that matters — visibility across `import` — from a second module.

## Developing

```sh
lake test
```

`CiteTests/Errors.lean` asserts each diagnostic against its exact text with
`#guard_msgs`, so a reworded error fails here rather than silently changing what
users read.
