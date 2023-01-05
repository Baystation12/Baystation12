/datum/map/sierra

	base_floor_type = /turf/simulated/floor/reinforced/airless
	base_floor_area = /area/maintenance/exterior

	post_round_safe_areas = list (
		/area/centcom,
		/area/shuttle/escape/centcom,
		/area/shuttle/escape_pod/escape_pod1/station,
		/area/shuttle/escape_pod/escape_pod2/station,
		/area/shuttle/escape_pod/escape_pod3/station,
		/area/shuttle/escape_pod/escape_pod4/station,
		/area/shuttle/escape_pod/escape_pod5/station,
//		/area/shuttle/escape_pod/escape_pod6/station,
		/area/shuttle/escape_pod/escape_pod7/station,
		/area/shuttle/escape_pod/escape_pod8/station,
		/area/shuttle/escape_pod/escape_pod9/station,
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
	ambience =  list(\
	'sound/ambience/substation/substation1.ogg',\
	'sound/ambience/substation/substation2.ogg',\
	'sound/ambience/substation/substation3.ogg',\
	'sound/ambience/substation/substation4.ogg',\
	'sound/ambience/substation/substation5.ogg',\
	'sound/ambience/substation/substation6.ogg',\
	'sound/ambience/substation/substation7.ogg',\
	'sound/ambience/substation/substation8.ogg'\
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

#include "areas/multideck.dm"
#include "areas/shuttles.dm"
#include "areas/sierra1.dm"
#include "areas/sierra2.dm"
#include "areas/sierra3.dm"
#include "areas/sierra4.dm"
