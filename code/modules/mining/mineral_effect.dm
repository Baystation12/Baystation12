/obj/effect/mineral
	name = "mineral vein"
	icon = 'icons/obj/mining.dmi'
	desc = "Shiny."
	mouse_opacity = 0
	density = 0
	anchored = 1

/obj/effect/mineral/New(var/newloc, var/mineral/M)
	..(newloc)
	name = "[M.display_name] deposit"
	icon_state = "rock_[M.name]"
	var/turf/T = get_turf(src)
	layer = T.layer+0.1