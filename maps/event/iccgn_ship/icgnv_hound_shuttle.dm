/datum/shuttle/autodock/overmap/icgnv_hound
	name = "ICGNV Hound"
	warmup_time = 5
	shuttle_area = list(/area/map_template/icgnv_hound)
	current_location = "nav_icgnv_hound_start"
	range = 1
	fuel_consumption = 0
	ceiling_type = /turf/simulated/floor/shuttle_ceiling
	flags = SHUTTLE_FLAGS_PROCESS
	defer_initialisation = TRUE
	knockdown = FALSE

/turf/simulated/floor/shuttle_ceiling/iccgn
	color = COLOR_DARK_GUNMETAL

/obj/effect/paint/iccgn
	color = COLOR_DARK_GUNMETAL

/obj/effect/shuttle_landmark/icgnv_hound/start
	landmark_tag = "nav_icgnv_hound_start"
	name = "Start Point"

/obj/effect/shuttle_landmark/icgnv_hound/nav1
	landmark_tag = "nav_icgnv_hound_1"

/obj/effect/shuttle_landmark/icgnv_hound/nav2
	landmark_tag = "nav_icgnv_hound_2"

/obj/effect/shuttle_landmark/icgnv_hound/nav3
	landmark_tag = "nav_icgnv_hound_3"

/obj/effect/shuttle_landmark/icgnv_hound/nav4
	landmark_tag = "nav_icgnv_hound_4"

/obj/effect/shuttle_landmark/icgnv_hound/dock //gotta actually make a proper docking point at the torch i think
	name = "4th Deck, Fore Airlock"
	landmark_tag = "nav_icgnv_hound_dock"

/obj/effect/shuttle_landmark/transit/iccgn
	name = "In transit"
	landmark_tag = "nav_transit_iccgn"


//Machinery
/obj/machinery/computer/shuttle_control/explore/icgnv_hound_shuttle
	name = "ICGNV Hound Control Console"
	req_access = list(access_syndicate)
	shuttle_tag = "ICGNV Hound"

/obj/machinery/power/apc/debug/iccgn
	cell_type = /obj/item/cell/infinite
	req_access = list(access_syndicate)
