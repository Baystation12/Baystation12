/*
 *
 *  Map Unit Tests.
 *  Zone checks / APC / Scrubber / Vent.
 *  
 *
 */

#define FAILURE 0
#define SUCCESS 1


datum/unit_test/apc_area_test
	name = "MAP: Area Test APC / Scrubbers / Vents Z level 1"

datum/unit_test/apc_area_test/start_test()
	var/list/bad_areas = list()
	var/area_test_count = 0
	var/list/exempt_areas = typesof(/area/space, \
					/area/syndicate_station, \
					/area/skipjack_station,  \
					/area/solar, \
					/area/shuttle, \
					/area/holodeck, \
					/area/supply/station \
					)

	var/list/exempt_from_atmos = typesof(   /area/maintenance, \
						/area/storage, \
						/area/engineering/atmos/storage, \
						/area/rnd/test_area, \
						/area/construction, \
						/area/server
						)

	var/list/exempt_from_apc = typesof(	/area/construction, \
						/area/medical/genetics
						)

	for(var/area/A in world)
		if(A.z == 1 && !(A.type in exempt_areas))
			area_test_count++
			var/area_good = 1
			var/bad_msg = "[ascii_red]--------------- [A.name]([A.type])"


			if(isnull(A.apc) && !(A.type in exempt_from_apc))
				log_unit_test("[bad_msg] lacks an APC.[ascii_reset]")
				area_good = 0

			if(!A.air_scrub_info.len && !(A.type in exempt_from_atmos))
				log_unit_test("[bad_msg] lacks an Air scrubber.[ascii_reset]")
				area_good = 0

			if(!A.air_vent_info.len && !(A.type in exempt_from_atmos))
				log_unit_test("[bad_msg] lacks an Air vent.[ascii_reset]")
				area_good = 0
		
			if(!area_good)
				bad_areas.Add(A)

	if(bad_areas.len)
		fail("\[[bad_areas.len]/[area_test_count]\]Some areas lacked APCs, Air Scrubbers, or Air vents.")
	else			
		pass("All \[[area_test_count]\] areas contained APCs, Air scrubbers, and Air vents.")

	return 1

#undef SUCCESS
#undef FAILURE
