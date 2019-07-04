#define using_map_DATUM /datum/map/ishimura
/datum/map/ishimura
	/*
	base_floor_type = /turf/simulated/floor/reinforced/airless
	base_floor_area = /area/maintenance/exterior

	post_round_safe_areas = list (
		/area/centcom,
		/area/shuttle/escape/centcom,
		/area/shuttle/escape_pod1/centcom,
		/area/shuttle/escape_pod2/centcom,
		/area/shuttle/escape_pod3/centcom,
		/area/shuttle/escape_pod5/centcom,
		/area/shuttle/transport1/centcom,
		/area/shuttle/administration/centcom,
		/area/shuttle/specops/centcom,
	)
	*/
	//Todo: Find good values for these

	lobby_icon = 'maps/torch/icons/lobby.dmi'
	lobby_screens = list("title","title2")
	lobby_tracks = list(
		/music_track/chasing_time,
		/music_track/torch,
		/music_track/human,
		/music_track/marhaba,
		/music_track/treacherous_voyage,
		/music_track/comet_haley,
		/music_track/lysendraa,
		/music_track/lasers)
