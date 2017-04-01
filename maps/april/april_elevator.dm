/obj/turbolift_map_holder/exodus
	icon = 'icons/obj/turbolift_preview_2x2.dmi'
	depth = 2
	lift_size_x = 3
	lift_size_y = 3

/obj/turbolift_map_holder/exodus/sec
	name = "Exodus turbolift map placeholder - Securiy"
	dir = EAST

	areas_to_use = list(
		/area/turbolift/security_maintenance,
		/area/turbolift/security_station
		)

/obj/turbolift_map_holder/exodus/research
	name = "Exodus turbolift map placeholder - Research"
	dir = WEST

	areas_to_use = list(
		/area/turbolift/research_maintenance,
		/area/turbolift/research_station
		)

/obj/turbolift_map_holder/exodus/engineering
	name = "Exodus turbolift map placeholder - Engineering"
	icon = 'icons/obj/turbolift_preview_3x3.dmi'
	dir = EAST
	lift_size_x = 4
	lift_size_y = 4

	areas_to_use = list(
		/area/turbolift/engineering_maintenance,
		/area/turbolift/engineering_station
		)

/obj/turbolift_map_holder/exodus/cargo
	name = "Exodus turbolift map placeholder - Cargo"

	areas_to_use = list(
		/area/turbolift/cargo_maintenance,
		/area/turbolift/cargo_station
		)


/obj/turbolift_map_holder/exodus/vault_access
	name = "Exodus turbolift map placeholder - Vault"
	icon = 'icons/obj/turbolift_preview_3x3.dmi'
	dir = SOUTH
	lift_size_x = 4
	lift_size_y = 4

	areas_to_use = list(
		/area/turbolift/vault_station,
		/area/turbolift/vault_entrance
		)