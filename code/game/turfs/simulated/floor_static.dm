// This type of flooring cannot be altered short of being destroyed and rebuilt.
// Use this to bypass the flooring system entirely ie. event areas, holodeck, etc.

/turf/simulated/floor/fixed
	name = "floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "steel"
	initial_flooring = null

/turf/simulated/floor/fixed/attackby(var/obj/item/C, var/mob/user)
	if(istype(C, /obj/item/stack) && !istype(C, /obj/item/stack/cable_coil))
		return
	return ..()

/turf/simulated/floor/fixed/update_icon()
	return

/turf/simulated/floor/fixed/is_plating()
	return 0

/turf/simulated/floor/fixed/set_flooring()
	return

/turf/simulated/floor/fixed/alium
	name = "alien plating"
	desc = "This obviously wasn't made for your feet."
	icon = 'icons/turf/flooring/alium.dmi'
	icon_state = "jaggy"

/turf/simulated/floor/fixed/alium/attackby(var/obj/item/C, var/mob/user)
	if(istype(C, /obj/item/weapon/crowbar))
		to_chat(user, "<span class='notice'>There isn't any openings big enough to pry it away...</span>")
		return
	return ..()

/turf/simulated/floor/fixed/alium/New()
	..()
	var/material/A = get_material_by_name("alien alloy")
	if(!A)
		return
	color = A.icon_colour
	icon_state = "[A.icon_base][(x*y) % 7]"

/turf/simulated/floor/fixed/alium/curves
	icon_state = "curvy"
/turf/simulated/floor/fixed/alium/ex_act(severity)
	var/material/A = get_material_by_name("alien alloy")
	if(prob(A.explosion_resistance))
		return
	if(severity == 1)
		ChangeTurf(get_base_turf_by_area(src))