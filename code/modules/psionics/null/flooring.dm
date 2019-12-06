/decl/flooring
	var/psi_null

/decl/flooring/proc/is_psi_null()
	return psi_null

/decl/flooring/tiling/nullglass
	name = "nullglass plating"
	desc = "You can hear the tiles whispering..."
	icon_base = "nullglass"
	color = COLOR_NULLGLASS
	has_damage_range = null
	flags = TURF_REMOVE_SCREWDRIVER
	build_type = /obj/item/stack/tile/floor_nullglass
	psi_null = TRUE

/obj/item/stack/tile/floor_nullglass
	name = "nullglass floor tile"
	icon_state = "tile_nullglass"
	matter = list(MATERIAL_NULLGLASS = 937.5)
