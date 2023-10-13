/obj/decal
	layer = DECAL_LAYER


/obj/decal/fall_damage()
	return 0

/obj/decal/is_burnable()
	return TRUE

/obj/decal/lava_act()
	. = !throwing ? ..() : FALSE
