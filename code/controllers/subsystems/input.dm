SUBSYSTEM_DEF(input)
	name = "Input"
	wait = 1 //SS_TICKER means this runs every tick
	init_order = SS_INIT_INPUT
	flags = SS_TICKER
	priority = SS_PRIORITY_INPUT
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY

	var/list/macro_set

/datum/controller/subsystem/input/Initialize()
	setup_default_macro_sets()
	refresh_client_macro_sets()
	return ..()

// This is for when macro sets are eventualy datumized
/datum/controller/subsystem/input/proc/setup_default_macro_sets()
	macro_set = list(
	"Any" = "\"KeyDown \[\[*\]\]\"",
	"Any+UP" = "\"KeyUp \[\[*\]\]\"",
	"Back" = "\".winset \\\"outputwindow.input.text=\\\"\\\"\\\"\"",
	"Tab" = "\".winset \\\"outputwindow.input.focus=true?mapwindow.map.focus=true:outputwindow.input.focus=true\\\"\"",
	"Escape" = "Reset-Held-Keys",
	)

// Badmins just wanna have fun ♪
/datum/controller/subsystem/input/proc/refresh_client_macro_sets()
	for(var/client/C in GLOB.clients)
		C.set_macros()

/datum/controller/subsystem/input/fire()
	for(var/client/C in GLOB.clients)
		C.keyLoop()
