/**
  * A "panic button" verb to close all UIs on current mob.
  * Use it when the bug with UI not opening (because the server still considers it open despite it being closed on client) pops up.
  * Feel free to remove it once the bug is confirmed to be fixed.
  *
  * INF-PORT
  *
  * @return nothing
  */
/client/verb/resetnano()
	set name = "Reset NanoUI"
	set category = "OOC"

	var/ui_amt = length(mob.open_uis)
	SSnano.close_user_uis(mob)
	to_chat(src, "[ui_amt] UI windows reset.")