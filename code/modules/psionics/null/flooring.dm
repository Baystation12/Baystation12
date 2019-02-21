/decl/flooring
	var/psi_null

/decl/flooring/proc/is_psi_null()
	return psi_null

/decl/flooring/tiling/nullglass
	name = "nullglass plating"
	desc = "You can hear the tiles whispering..."
	icon_base = "nullglass"
	has_damage_range = null
	flags = TURF_REMOVE_SCREWDRIVER
	build_type = /obj/item/weapon/stack/tile/floor/nullglass
	psi_null = TRUE

/obj/item/weapon/stack/tile/floor/nullglass
	name = "nullglass floor tile"
	icon_state = "tile_nullglass"
	matter = list(MATERIAL_NULLGLASS = 937.5)
