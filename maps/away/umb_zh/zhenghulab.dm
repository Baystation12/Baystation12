/obj/effect/overmap/visitable/sector/umbrellant
	name = "Unknown Research Facility"
	desc = "Sensors detect an orbital station with low energy profile and sporadic life signs. It is emitting an active distress beacon."
	icon_state = "object"
	known = 0

/datum/map_template/ruin/away_site/umbrellant
	name = "NT Research Facility"
	id = "awaysite_umbrellant"
	description = "A bioweapons facility located on a strange planet."
	suffixes = list("umb_zh/zhenghulab-1.dmm", "umb_zh/zhenghulab-2.dmm")
	cost = 1
	area_usage_test_exempted_root_areas = list()

///////////////////////////////////crew and prisoners

////////////////////////////Notes and papers
/obj/item/weapon/paper/lar_maria/note_1
	name = "paper note"
	info = {"
			<center><b><font color='green'>Zeng-Hu Pharmaceuticals</font></b></center>
			<center><b><font color='red'><small>CONFIDENTIAL USE ONLY</small></font></b></center>
			<i>We received the latest batch of subjects this evening. Evening? Is it even evening? The schedule out here is so fucked in terms of sleep-cycles I forget to even check what time it is sometimes. I'm pretty sure it's evening anyway. Anyway, point is, we got the new guys, and thus far they seem like they fit the criteria pretty well. No family histories of diseases or the like, no current illnesses, prime physical condition, perfect subjects for our work. Tomorrow we start testing out the type 008 Serum. Hell if I know where this stuff's coming from, but it's fascinating. Injected into live subjects, it seems like it has a tendancy to not only cure them of ailments, but actually improve their bodily functions...</i>
			"}

///////////////////////////// Elevators

/obj/effect/shuttle_landmark/lift/ntwarehouse_top //////// Lift for the warehouse, located at x26 y70
	name = "Level 1"
	landmark_tag = "nav_ntwarehouse_lift_top"
	base_area = /area/quartermaster/storage/upper
	base_turf = /turf/simulated/open

/obj/effect/shuttle_landmark/lift/ntwarehouse_bottom
	name = "Level 2"
	landmark_tag = "nav_ntwarehouse_lift_bottom"
	flags = SLANDMARK_FLAG_AUTOSET
	base_area = /area/quartermaster/storage
	base_turf = /turf/simulated/floor/plating
	
/obj/effect/shuttle_landmark/lift/nthall_top ///////// Lift for the main hall located at x28 y76
	name = "Level 1 - Research and Development"
	landmark_tag = "nav_nthall_lift_top"
	base_area = /area/quartermaster/storage/upper
	base_turf = /turf/simulated/open

/obj/effect/shuttle_landmark/lift/nthall_bottom
	name = "Level 2 - Research Testing"
	landmark_tag = "nav_nthall_lift_bottom"
	flags = SLANDMARK_FLAG_AUTOSET
	base_area = /area/quartermaster/storage
	base_turf = /turf/simulated/floor/plating
	