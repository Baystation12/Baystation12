
/area/admin/testing
	name = "dev planet testing"
	icon_state = "security_sub"

/area/admin/testing_control
	name = "dev planet control centre"
	icon_state = "crew_quarters"

/datum/map/dev_planet
	name = "Dev Planet"
	full_name = "Dev Planet"
	system_name = "Sol Sector"
	path = "dev_planet"
	use_overmap = 1
	overmap_size = 100
	lobby_icon = 'code/modules/halo/splashworks/title6.jpg'
	id_hud_icons = 'maps/geminus_city/geminus_hud_icons.dmi'

/obj/effect/overmap/sector/dev_planet
	name = "Dev Planet"
	icon = 'maps/Exoplanet Mining/sector_icon.dmi'
	icon_state = "mining_asteroid"
	overmap_spawn_near_me = list(/obj/effect/overmap/ship/dev_testing)

/area/admin/test_ship
	name = "dev ship testing"
	icon_state = "thruster"

/area/admin/test_ship_bridge
	name = "dev ship bridge"
	icon_state = "bridge"

/obj/effect/overmap/ship/dev_testing
	name = "HMS Sea Shanty"
	desc = "A standard contruction-model dev ship."

	icon = 'maps/UNSC_Bertels/Heavycorvette.dmi'
	icon_state = "ship"
	fore_dir = WEST
	vessel_mass = 4
	faction = "UNSC"
	flagship = 1

	parent_area_type = /area/admin/test_ship

/datum/job/test_job
	title = "Test Job"
	latejoin_at_spawnpoints = 1
	spawnpoint_override = "Test Job"
	outfit_type = /decl/hierarchy/outfit/job/test_outfit

/decl/hierarchy/outfit/job/test_outfit
	name = "Test Outfit"
	l_ear = /obj/item/device/radio/headset
	uniform = /obj/item/clothing/under/blazer
	shoes = /obj/item/clothing/shoes/black
