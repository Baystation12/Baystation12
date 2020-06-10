


// Decls

/decl/flooring/tiling/tech
	name = "steel floor"
	desc = "Proof against the vacuum of space."
	icon = 'code/modules/halo/turfs/floor_tech.dmi'
	icon_base = "techfloor_gray"
	build_type = /obj/item/stack/tile/floor_tech

/decl/flooring/tiling/tech/white
	icon_base = "techfloor_white"
	build_type = /obj/item/stack/tile/floor_tech_white

/decl/flooring/tiling/tech/grid
	icon_base = "techfloor_grid"
	build_type = /obj/item/stack/tile/floor_tech_grid

/decl/flooring/tiling/tech/maint
	icon_base = "techmaint"
	build_type = /obj/item/stack/tile/floor_tech_maint

/decl/flooring/tiling/tech/steel
	icon_base = "steel_grid"
	build_type = /obj/item/stack/tile/floor_tech_steel

/decl/flooring/tiling/tech/ridged
	icon_base = "steel_ridged"
	build_type = /obj/item/stack/tile/floor_tech_ridged



// Tiles

/obj/item/stack/tile/floor_tech
	name = "dark traction steel tile"
	icon = 'code/modules/halo/turfs/tile.dmi'
	icon_state = "tech_tile_gray"
/obj/item/stack/tile/floor_tech/fifty
	amount = 50

/obj/item/stack/tile/floor_tech_white
	name = "light traction steel tile"
	icon = 'code/modules/halo/turfs/tile.dmi'
	icon_state = "tech_tile_white"
/obj/item/stack/tile/floor_tech_white/fifty
	icon_state = "tech_tile_white"
	amount = 50

/obj/item/stack/tile/floor_tech_grid
	name = "dark grid steel tile"
	icon = 'code/modules/halo/turfs/tile.dmi'
	icon_state = "tech_tile_grid"
/obj/item/stack/tile/floor_tech_grid/fifty
	amount = 50

/obj/item/stack/tile/floor_tech_maint
	name = "light grid steel tile"
	icon = 'code/modules/halo/turfs/tile.dmi'
	icon_state = "tech_tile_maint"
/obj/item/stack/tile/floor_tech_maint/fifty
	amount = 50

/obj/item/stack/tile/floor_tech_steel
	name = "traction steel tile"
	icon = 'code/modules/halo/turfs/tile.dmi'
	icon_state = "tech_tile_steel"
/obj/item/stack/tile/floor_tech_steel/fifty
	amount = 50

/obj/item/stack/tile/floor_tech_ridged
	name = "ridged steel tile"
	icon = 'code/modules/halo/turfs/tile.dmi'
	icon_state = "tech_tile_ridges"
/obj/item/stack/tile/floor_tech_ridged/fifty
	amount = 50



// Turfs

/turf/simulated/floor/tech
	name = "steel floor"
	icon = 'code/modules/halo/turfs/floor_tech.dmi'
	icon_state = "techfloor_gray"
	flooring = /decl/flooring/tiling/tech

/turf/simulated/floor/tech/white
	icon_state = "techfloor_white"
	flooring = /decl/flooring/tiling/tech/white

/turf/simulated/floor/tech/gray
	icon_state = "techfloor_grid"
	flooring = /decl/flooring/tiling/tech/grid

/turf/simulated/floor/tech/steel
	icon_state = "steel_grid"
	flooring = /decl/flooring/tiling/tech/steel

/turf/simulated/floor/tech/ridged
	icon_state = "steel_ridged"
	flooring = /decl/flooring/tiling/tech/ridged

/turf/simulated/floor/tech/maint
	icon_state = "techmaint"
	flooring = /decl/flooring/tiling/tech/maint

//not buildable ingame

/turf/simulated/floor/tech/orange
	icon_state = "techfloor_orangefulltwogrid"

/turf/simulated/floor/light/tech_neon
	name = "lit steel floor"
	icon = 'code/modules/halo/turfs/floor_tech.dmi'
	icon_state = "techfloor_neon"
	luminosity = 2
	New()
		..()
		update_icon()

/turf/simulated/floor/light/tech_neon/tech_white
	icon_state = "techfloor_neonwhte"

/turf/simulated/floor/light/tech_neon/side
	icon_state = "techfloor_lightedcorner"

/turf/simulated/floor/light/tech_neon/side_grid
	icon_state = "techfloor_lightedcorner_grid"
