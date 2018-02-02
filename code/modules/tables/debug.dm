
// Mostly for debugging table connections
// This file is not #included in the .dme.

/obj/structure/table/debug
	Initialize
		material = get_material_by_name("debugium")
		.=..()

/material/debug
	name = "debugium"
	stack_type = /obj/item/stack/material/debug
	icon_base = "debug"
	icon_reinf = "rdebug"
	icon_colour = "#ffffff"

/obj/item/stack/material/debug
	name = "debugium"
	icon = 'icons/obj/tables.dmi'
	icon_state = "debugium"
	default_type = "debugium"

