/datum/map/sierra

	base_floor_type = /turf/simulated/floor/reinforced
	base_floor_area = /area/maintenance/exterior

	post_round_safe_areas = list (
		/area/centcom,
		/area/shuttle/escape/centcom,
		/area/shuttle/escape_pod/escape_pod1/station,
		/area/shuttle/escape_pod/escape_pod2/station,
		/area/shuttle/escape_pod/escape_pod3/station,
		/area/shuttle/escape_pod/escape_pod4/station,
		/area/shuttle/escape_pod/escape_pod5/station,
		/area/shuttle/escape_pod/escape_pod6/station,
		/area/shuttle/escape_pod/escape_pod7/station,
		/area/shuttle/escape_pod/escape_pod8/station,
		/area/shuttle/escape_pod/escape_pod9/station,
		/area/shuttle/escape_pod/escape_pod10/station,
		/area/shuttle/escape_pod/escape_pod11/station,
		/area/shuttle/transport1/centcom,
		/area/shuttle/administration/centcom,
		/area/shuttle/specops/centcom,
	)

/area/medical
	icon_state = "medbay"

/area/maintenance/substation
	name = "Substation"
	icon_state = "substation"
	sound_env = SMALL_ENCLOSED
	req_access = list(access_engine)
	// Sounds for Substation rooms. Just electrical sounds, really.
	ambience =  list(
		'maps/sierra/sound/ambience/substation1.ogg',
		'maps/sierra/sound/ambience/substation2.ogg',
		'maps/sierra/sound/ambience/substation3.ogg',
		'maps/sierra/sound/ambience/substation4.ogg',
		'maps/sierra/sound/ambience/substation5.ogg',
		'maps/sierra/sound/ambience/substation6.ogg',
		'maps/sierra/sound/ambience/substation7.ogg',
		'maps/sierra/sound/ambience/substation8.ogg'
	)

/area/crew_quarters
	icon_state = "crew_quarters"

/area/crew_quarters/heads
	icon_state = "heads"

/area/engineering
	req_access = list(access_engine)
	icon_state = "engineering"

/area/shield
	name = "Engineering - Shield Generator"
	icon_state = "engineering"
	sound_env = SMALL_ENCLOSED
	req_access = list(access_engine, access_atmospherics)

/area/security/sierra/
	icon_state = "security"

/area/thruster
	icon_state = "thruster"
	req_access = list(access_engine)

/area/crew_quarters/safe_room
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED
	holomap_color = HOLOMAP_AREACOLOR_ESCAPE

#include "areas/shuttles.dm"
#include "areas/z1_sierra_deck4.dm"
#include "areas/z2_sierra_deck3.dm"
#include "areas/z3_sierra_deck2.dm"
#include "areas/z4_sierra_deck1.dm"
#include "areas/z5_sierra_bridge.dm"
#include "areas/z6_admin.dm"
