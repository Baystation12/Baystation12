
/obj/overlay/bmark
	name = "bullet hole"
	desc = "Well someone shot something."
	icon = 'icons/effects/effects.dmi'
	layer = DECAL_LAYER
	icon_state = "scorch"
	anchored = TRUE


/obj/overlay/bmark/use_grab(obj/item/grab/grab, list/click_params)
	if (istype(loc, /turf/simulated/wall))
		var/turf/simulated/wall/wall = loc
		return wall.use_weapon(grab, click_params)

	return ..()


/obj/overlay/bmark/use_weapon(obj/item/weapon, mob/living/user, list/click_params)
	if (istype(loc, /turf/simulated/wall))
		var/turf/simulated/wall/wall = loc
		return wall.use_weapon(weapon, user, click_params)

	return ..()


/obj/overlay/bmark/use_tool(obj/item/tool, mob/living/user, list/click_params)
	if (istype(loc, /turf/simulated/wall))
		var/turf/simulated/wall/wall = loc
		return wall.use_tool(tool, user, click_params)

	return ..()
