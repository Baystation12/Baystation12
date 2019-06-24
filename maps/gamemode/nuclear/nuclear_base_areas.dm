/area/map_template/nuclear_base
	name = "mercenary base"
	icon_state = "syndie-ship"
	requires_power = 0
	dynamic_lighting = 1
	req_access = list(access_syndicate)

/area/map_template/syndicate_station/start
	name = "mercenary forward operating base"
	icon_state = "yellow"
	requires_power = 0
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED
	req_access = list(access_syndicate)
