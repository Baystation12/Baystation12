/area/map_template/raider_base
	name = "raider base"
	req_access = list(access_syndicate)
	dynamic_lighting = 1
	requires_power = 0

/area/map_template/skipjack_station
	name = "raider outpost"
	icon_state = "yellow"
	requires_power = 0
	req_access = list(access_syndicate)

/area/map_template/skipjack_station/start
	name = "skipjack"
	icon_state = "yellow"
	req_access = list(access_syndicate)
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED
