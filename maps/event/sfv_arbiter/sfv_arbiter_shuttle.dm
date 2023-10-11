/datum/shuttle/autodock/overmap/sfv_arbiter
	name = "SFV Arbiter"
	warmup_time = 5
	shuttle_area = list(/area/map_template/sfv_arbiter)
	current_location = "nav_sfv_arbiter_start"
	dock_target = "sfv_arbiter_shuttle"
	range = 1
	ceiling_type = /turf/simulated/floor/shuttle_ceiling
	flags = SHUTTLE_FLAGS_PROCESS
	defer_initialisation = TRUE
	knockdown = FALSE

/turf/simulated/floor/shuttle_ceiling/sfv_arbiter
	color = COLOR_DARK_GUNMETAL

/obj/paint/sfv_arbiter
	color = COLOR_DARK_GUNMETAL

/obj/shuttle_landmark/sfv_arbiter/start
	landmark_tag = "nav_sfv_arbiter_start"
	name = "Start Point"

/obj/shuttle_landmark/sfv_arbiter/nav1
	landmark_tag = "nav_sfv_arbiter_1"

/obj/shuttle_landmark/sfv_arbiter/nav2
	landmark_tag = "nav_sfv_arbiter_2"

/obj/shuttle_landmark/sfv_arbiter/nav3
	landmark_tag = "nav_sfv_arbiter_3"

/obj/shuttle_landmark/sfv_arbiter/nav4
	landmark_tag = "nav_sfv_arbiter_4"

/obj/shuttle_landmark/sfv_arbiter/dock
	name = "4th Deck, Aft-Starboard (SFV Arbiter)"
	landmark_tag = "nav_sfv_arbiter_dock"
	docking_controller = "admin_shuttle_dock_airlock"

/obj/shuttle_landmark/transit/sfv_arbiter
	name = "In transit"
	landmark_tag = "nav_transit_arbiter"


//Machinery
/obj/machinery/computer/shuttle_control/explore/sfv_arbiter_shuttle
	name = "SFV Arbiter Control Console"
	req_access = list(access_syndicate)
	shuttle_tag = "SFV Arbiter"

/obj/machinery/power/apc/debug/sfv_arbiter
	cell_type = /obj/item/cell/infinite
	req_access = list(access_syndicate)

/obj/machinery/telecomms/allinone/sfv_arbiter
	listening_freqs = list(SFV_FREQ)
	channel_color = COMMS_COLOR_CENTCOMM
	channel_name = "SFV Arbiter"
	circuitboard = /obj/item/stock_parts/circuitboard/telecomms/allinone/sfv_arbiter


//Items
/obj/item/device/radio/headset/sfv_arbiter
	name = "fleet headset"
	icon_state = "syndie_headset"
	item_state = "headset"
	ks1type = /obj/item/device/encryptionkey/sfv_arbiter

/obj/item/device/radio/headset/sfv_arbiter/Initialize()
	. = ..()
	set_frequency(SFV_FREQ)

/obj/item/device/encryptionkey/sfv_arbiter
	name = "\improper sfv arbiter radio encryption key"
	channels = list("SFV Arbiter" = 1)

/obj/item/stock_parts/circuitboard/telecomms/allinone/sfv_arbiter
	build_path = /obj/machinery/telecomms/allinone/sfv_arbiter
