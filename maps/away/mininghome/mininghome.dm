/obj/effect/overmap/visitable/sector/mininghome
	name = "Asteroid Mining Station"
	desc = "A small mining station. No active lifesigns found on the station. Sensors indicate an abundance of valuable ore."
	icon_state = "object"
	initial_generic_waypoints = list(
		"nav_mininghome_1",
		"nav_mininghome_2",
		"nav_mininghome_3",
		"nav_mininghome_4"
	)

/datum/map_template/ruin/away_site/mininghome
	name = "mininghome"
	id = "awaysite_mininghome"
	description = "A chill asteroid mining station."
	suffixes = list("mininghome/mininghome.dmm")
	spawn_cost = 0.5

/obj/effect/shuttle_landmark/nav_mininghome_1
	name = "Navpoint #1"
	landmark_tag = "nav_mininghome_1"

/obj/effect/shuttle_landmark/nav_mininghome_2
	name = "Navpoint #2"
	landmark_tag = "nav_mininghome_2"

/obj/effect/shuttle_landmark/nav_mininghome_3
	name = "Navpoint #3"
	landmark_tag = "nav_mininghome_3"

/obj/effect/shuttle_landmark/nav_mininghome_4
	name = "Hangar"
	landmark_tag = "nav_mininghome_4"
	base_area = /area/map_template/mininghome_hangar
	base_turf = /turf/simulated/floor/plating

// New turfs!!

/turf/simulated/floor/steel_dirty
	name = "dirty steel floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "steel_dirty"
	initial_flooring = /decl/flooring/tiling

// Lockers

/obj/structure/closet/dilapidated
	name = "dilapidated closet"
	desc = "A dilpidated closet, the paint is flecking off."
	closet_appearance = /decl/closet_appearance/tactical

// Areas

/area/map_template/mininghome_hangar
	name = "\improper Hangar"
	icon_state = "hangar"

/area/map_template/mininghome_lockers
	name = "\improper Break Room"
	icon_state = "locker"

/area/map_template/mininghome_bathroom
	name = "\improper Bathroom"
	icon_state = "toilet"

/area/map_template/mininghome_mess
	name = "\improper Mess Hall"
	icon_state = "kitchen"

/area/map_template/mininghome_hall
	name = "\improper Skybridge Hall"
	icon_state = "Tactical"

/area/map_template/mininghome_power
	name = "\improper Engineering and Atmos"
	icon_state = "disperser"

/area/map_template/mininghome_living_north
	name = "\improper Living Quarters"
	icon_state = "Holodeck"

/area/map_template/mininghome_living_south
	name = "\improper Living Quarters"
	icon_state = "sauna"

/area/map_template/mininghome_robotics
	name = "\improper Robotics"
	icon_state = "bar"

/area/map_template/mininghome_solars
	name = "\improper Solars"
	icon_state = "eva"

// Torch only items off torch

/obj/item/mininghome_passport_iccg
	name = "\improper Old ICCG passport"
	icon = 'icons/obj/passport.dmi'
	icon_state = "passport_iccg"
	w_class = ITEM_SIZE_SMALL
	desc = "A passport from the Gilgamesh Confederation. This one belongs to a man named Ivan Gregorich."

/obj/item/clothing/head/beret/mininghome_iccg
	name = "faded Drop Trooper beret"
	desc = "An old ICCG Navy beret with a drop troopers crest."
	icon = 'maps/away/mininghome/icons.dmi'
	item_icons = list(slot_head_str = 'maps/away/mininghome/onmob_icons.dmi')
	icon_state = "terranberet-grey"
	item_state = "terranberet-grey"

/obj/item/clothing/head/beret/mininghome_scg
	name = "faded Orbital Assault beret"
	desc = "An old SCGDF Fleet beret with an orbital assault crest."
	icon = 'maps/away/mininghome/icons.dmi'
	item_icons = list(slot_head_str = 'maps/away/mininghome/onmob_icons.dmi')
	icon_state = "beret_blue"
	item_state = "beret_blue"
