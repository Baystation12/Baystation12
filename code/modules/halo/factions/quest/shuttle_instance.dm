
/obj/effect/shuttle_instance/proc/clear_instance()
	GLOB.factions_controller.loaded_quest_instance = null
	var/area/instance_area = get_area(src)
	if(!offsite_shuttle_area_type)
		to_debug_listeners("ERROR: null offsite_shuttle_area_type")
		return
	var/area/shuttle_area = locate(offsite_shuttle_area_type) in world
	for(var/area/cur_area in list(instance_area, shuttle_area))
		for(var/atom/movable/A in cur_area)
			if(istype(A, /obj/effect/shuttle_instance))
				continue
			qdel(A)

/obj/effect/shuttle_instance/proc/load_instance(var/datum/npc_quest/quest)
	clear_instance()
	if(quest && quest.map_path)
		maploader.load_map(quest.map_path, src.z, src.x - 1, src.y - 1)

		var/area/instance_area = get_area(src)
		//
		var/list/defender_locs = list()
		for(var/obj/effect/landmark/instance_defender/D in instance_area)
			defender_locs.Add(get_turf(D))

		quest.spawn_initial_defenders(defender_locs, quest.difficulty)

		var/list/loot_locs = list()
		for(var/obj/effect/landmark/instance_loot/D in instance_area)
			loot_locs.Add(get_turf(D))

		quest.spawn_loot(loot_locs)
		quest.instance_area = instance_area
		GLOB.factions_controller.loaded_quest_instance = quest
		quest.instance_loaded = 1

//this is very naughty but im pulling my hair out trying to avoid changes to bs12 code so we stay compatible --Cael 26.8.19
/*
/obj/effect/shuttle_landmark
	var/distance = 0
	var/datum/npc_quest/instance_quest
	*/

/obj/effect/shuttle_instance
	icon = 'icons/effects/effects.dmi'
	icon_state = "energynet"
	anchored = 1
	unacidable = 1
	simulated = 0
	invisibility = 101
	var/offsite_shuttle_area_type

//important! uncomment this when you need it
/*
/area/planets/Geminus/indoor/quest_instance
	name = "Geminus Outskirts"

/obj/effect/shuttle_instance/innie_quest
	offsite_shuttle_area_type = /area/shuttle/offsite_berth_transport
*/

/obj/effect/landmark/instance_defender
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"
	anchored = 1.0
	unacidable = 1
	simulated = 0
	invisibility = 101

/obj/effect/landmark/instance_boss
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x3"
	anchored = 1.0
	unacidable = 1
	simulated = 0
	invisibility = 101

/obj/effect/landmark/instance_loot
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x4"
	anchored = 1.0
	unacidable = 1
	simulated = 0
	invisibility = 101
