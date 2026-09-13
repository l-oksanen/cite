module

meta import Cite

/-!
Each diagnostic, asserted against its exact text.
-/

public theorem citeBase : True := trivial

attribute [cite] citeBase

/-- error: citeBase is already cited by a blueprint node -/
#guard_msgs in
attribute [cite] citeBase

public theorem citeOther : True := trivial

/-- error: invalid attribute 'cite': must be global (not `scoped` or `local`) -/
#guard_msgs in
attribute [local cite] citeOther
