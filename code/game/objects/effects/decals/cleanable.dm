/obj/effect/decal/cleanable
	var/list/random_icon_states
	var/image/hud_overlay/hud_overlay

/obj/effect/decal/cleanable/Initialize()
	. = ..()
	hud_overlay = new /image/hud_overlay('icons/obj/hud_tile.dmi', src, "caution")
	hud_overlay.plane = EFFECTS_ABOVE_LIGHTING_PLANE

/obj/effect/decal/cleanable/clean_blood(var/ignore = 0)
	if(!ignore)
		qdel(src)
		return
	..()

/obj/effect/decal/cleanable/Initialize()
	if (random_icon_states && length(src.random_icon_states) > 0)
		src.icon_state = pick(src.random_icon_states)
	. = ..()
