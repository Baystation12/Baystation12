/area/shuttle/innie_offsite_transport
	name = "Offsite Berth"
	icon_state = "shuttle2"
	dynamic_lighting = 0
	luminosity = 1
	base_turf = /turf/simulated/floor/plating

/area/shuttle/innie_base_transport
	name = "Rabbit Hole Base Transport Berth"
	icon_state = "shuttle"
	dynamic_lighting = 0
	luminosity = 1
	base_turf = /turf/simulated/floor/plating

/area/shuttle/innie_shuttle_transport
	name = "Rabbit Hole Base Transport Shuttle"
	icon_state = "shuttle3"
	dynamic_lighting = 0
	luminosity = 1
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/innie_base_transport
	name = "Rabbit Hole Base"
	landmark_tag = "geminus_innie_transport"
	base_area = /area/shuttle/innie_base_transport
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/innie_offsite_transport
	name = "Geminus Innie Offsite Berth"
	landmark_tag = "offsite_innie_transport"
	base_area = /area/shuttle/innie_offsite_transport
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/innie_offsite_transport/is_valid(var/datum/shuttle/shuttle)
	return TRUE

/area/planets/Geminus/indoor/npc_factory
	name = "\improper Geminus NPC Factory"
	icon_state = "storage"
