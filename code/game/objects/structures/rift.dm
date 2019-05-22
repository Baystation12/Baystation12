/obj/effect/rift
	name = "rift"
	desc = "a tear in space and time."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "rift"
	unacidable = 1
	anchored = 1
	density = 0

/obj/effect/rift/Destroy()
	for(var/o in contents)
		var/atom/movable/M = o
		M.dropInto(loc)
	. = ..()