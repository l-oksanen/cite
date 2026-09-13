module

meta import Cite
import CiteTests.Errors

/-!
Citations have to survive `import`, which is the whole contract. Asserting it in
the citing module would not test it: the attribute applies after compilation, so
a citation is not yet visible to a later command in its own file.
-/

/-- info: (true, false) -/
#guard_msgs in
run_cmd do
  let env ← Lean.getEnv
  Lean.logInfo m!"{(Cite.isCited env `citeBase, Cite.isCited env `citeOther)}"

/-- info: 1 -/
#guard_msgs in
run_cmd do Lean.logInfo m!"{(Cite.cited (← Lean.getEnv)).size}"
