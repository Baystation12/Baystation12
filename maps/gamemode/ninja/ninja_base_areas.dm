/area/map_template/ninja_dojo
	name = "ninja base"
	icon_state = "green"
	requires_power = 0
	dynamic_lighting = 0
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED
	req_access = list(access_syndicate)

/area/map_template/ninja_dojo/dojo
	name = "clan dojo"
	dynamic_lighting = 1

/area/map_template/ninja_dojo/start
	name = "ninja shtutle"
	icon_state = "shuttlered"
	dynamic_lighting = 1
	base_turf = /turf/simulated/floor/plating
