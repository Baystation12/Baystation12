/area/shuttle/offsite_berth_transport
	name = "Offsite Berth"
	icon_state = "shuttle2"
	requires_power = 1
	dynamic_lighting = 0
	luminosity = 1
	base_turf = /turf/simulated/floor/plating

/area/shuttle/innie_berth_transport
	name = "Rabbit Hole Berth"
	icon_state = "shuttle"
	requires_power = 1
	dynamic_lighting = 0
	luminosity = 1
	base_turf = /turf/simulated/floor/plating

/area/shuttle/innie_shuttle_transport
	name = "Rabbit Hole Shuttle"
	icon_state = "shuttle3"
	requires_power = 1
	dynamic_lighting = 0
	luminosity = 1
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/innie_berth_transport
	name = "Rabbit Hole Berth"
	landmark_tag = "innie_berth_transport"
	base_area = /area/shuttle/innie_berth_transport
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/offsite_berth_transport
	name = "Offsite Berth"
	landmark_tag = "offsite_berth_transport"
	base_area = /area/shuttle/offsite_berth_transport
	base_turf = /turf/simulated/floor/plating

/area/planets/Geminus/indoor/npc_factory
	name = "\improper Geminus NPC Factory"
	icon_state = "storage"

/obj/effect/shuttle_instance/innie_quest
	offsite_shuttle_area_type = /area/shuttle/offsite_berth_transport

/area/planets/Geminus/indoor/quest_instance
	name = "Geminus Outskirts"