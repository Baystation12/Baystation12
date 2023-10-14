
	///////////
	//OVERMAP//
	///////////

/obj/overmap/visitable/ship/farfleet
	name = "Pioneer Corps Gunboat"
	desc = "ICGNV Garibaldi-class Gunboat. This craft bears markings of Pioneer Corps"
	color = "#fc7a00"
	fore_dir = WEST
	vessel_mass = 1000
	known_ships = list(/obj/overmap/visitable/ship/landable/snz)
	vessel_size = SHIP_SIZE_SMALL
	hide_from_reports = TRUE
	start_x = 39
	start_y = 39

	initial_generic_waypoints = list(
		"nav_farfleet_1",
		"nav_farfleet_2",
		"nav_farfleet_3",
		"nav_farfleet_4",
		"nav_hangar_snz"
		)

	initial_restricted_waypoints = list(
	"SNZ" = list("nav_hangar_snz")
		)

#define RECON_SHIP_PREFIX pick("Admiral Sobolev","Ivan Kozhedub","Sevastopol","Zirkel","Kurchatov","Gomel","Admiral Kolchak","Udaloi","Omsk","Krondstatt","Admiral Nakhimov","Iron Dmitry","Simbirsk","Apostle Peter","Admiral Chernavin","Proryv","Triumph","Besstrashnyi","Elisarov","Magnitogorsk")
/obj/overmap/visitable/ship/farfleet/New()
	name = "ICCGN PC [RECON_SHIP_PREFIX], \a [name]"
	for(var/area/ship/farfleet/A)
		A.name = "\improper [name] - [A.name]"
		GLOB.using_map.area_purity_test_exempt_areas += A.type
	..()
#undef RECON_SHIP_PREFIX

/datum/map_template/ruin/away_site/farfleet
	name = "Pioneer Corps Gunboat (ICGNV)"
	id = "awaysite_recon_ship"
	description = "Garibaldi-class Gunboat, ICCG Pioneer Corps Reconnaissance Craft."
	prefix = "mods/_maps/farfleet/maps/"
	suffixes = list("farfleet-1.dmm", "farfleet-2.dmm")
	spawn_cost = 50 // Temporary disabled
	player_cost = 50
	spawn_weight = 1
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/snz)

	area_usage_test_exempted_areas = list(
		/area/turbolift/farfleet_first,
		/area/turbolift/farfleet_second
	)

/obj/shuttle_landmark/nav_farfleet/nav1
	name = "Pioneer Corps Ship Fore"
	landmark_tag = "nav_farfleet_1"

/obj/shuttle_landmark/nav_farfleet/nav2
	name = "Pioneer Corps Ship Aft"
	landmark_tag = "nav_farfleet_2"

/obj/shuttle_landmark/nav_farfleet/nav3
	name = "Pioneer Corps Ship Port"
	landmark_tag = "nav_farfleet_3"

/obj/shuttle_landmark/nav_farfleet/nav4
	name = "Pioneer Corps Ship Starboard"
	landmark_tag = "nav_farfleet_4"

/obj/submap_landmark/joinable_submap/farfleet
	name = "ICCGN PC Ship"
	archetype = /singleton/submap_archetype/away_iccgn_farfleet

/* TCOMMS
 * ======
 */

/obj/machinery/telecomms/allinone/iccgn
	listening_freqs = list(ICCGN_FREQ)
	channel_color = COMMS_COLOR_ICCG
	channel_name = "Pioneer"
	circuitboard = /obj/item/stock_parts/circuitboard/telecomms/allinone/iccgn


//Items
/obj/item/device/radio/headset/iccgn
	name = "iccgn headset"
	desc = "Headset belonging to an ICCGN operative."
	icon_state = "syndie_headset"
	item_state = "headset"
	ks1type = /obj/item/device/encryptionkey/iccgn

/obj/item/device/radio/headset/iccgn/Initialize()
	. = ..()
	set_frequency(ICCGN_FREQ)

/obj/item/device/encryptionkey/iccgn
	name = "\improper ICCGN radio encryption key"
	channels = list("ICGN Ship" = 1)

/obj/item/stock_parts/circuitboard/telecomms/allinone/iccgn
	build_path = /obj/machinery/telecomms/allinone/iccgn
