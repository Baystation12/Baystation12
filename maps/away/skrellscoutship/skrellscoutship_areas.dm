/area/ship/skrellscoutship
	name = "\improper Skrellian Ship"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED
	base_turf = /turf/space
	req_access = list(access_skrellscoutship)

/area/ship/skrellscoutship/solars
	name = "\improper Solar Area"
	
/area/ship/skrellscoutship/crew/quarters
	name = "\improper Quarters"
	icon_state = "crew_quarters"

/area/ship/skrellscoutship/crew/hallway/d1
	name = "\improper Hallway - Deck 1"

/area/ship/skrellscoutship/crew/hallway/d2
	name = "\improper Hallway - Deck 2"

/area/ship/skrellscoutship/crew/kitchen
	name = "\improper Galley"
	icon_state = "kitchen"

/area/ship/skrellscoutship/crew/rec
	name = "\improper Recreational Area"
	icon_state = "green"
	
/area/ship/skrellscoutship/crew/fit
	name = "\improper Exercise Area"
	icon_state = "green"

/area/ship/skrellscoutship/crew/toilets
	name = "\improper Bathroom"
	icon_state = "toilet"

/area/ship/skrellscoutship/crew/medbay
	name = "\improper Medical Bay"
	icon_state = "medbay"

/area/ship/skrellscoutship/dock
	name = "\improper Docking Bay 1"
	icon_state = "entry_1"
	
/area/ship/skrellscoutship/dock/alt
	name = "\improper Docking Bay 2"
	icon_state = "entry_1"

/area/ship/skrellscoutship/hangar
	name = "\improper Shuttle Dock"
	icon_state = "auxstorage"

/area/ship/skrellscoutship/robotics
	name = "\improper Maintenance"
	icon_state = "green"
	
/area/ship/skrellscoutship/maintenance/atmos
	name = "\improper Atmospherics"
	icon_state = "atmos"
	ambience = list('sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambigen5.ogg','sound/ambience/ambigen6.ogg','sound/ambience/ambigen7.ogg','sound/ambience/ambigen8.ogg','sound/ambience/ambigen9.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen11.ogg','sound/ambience/ambiatm1.ogg')

/area/ship/skrellscoutship/maintenance/power
	name = "\improper Engineering"
	icon_state = "engine_smes"
	ambience = list('sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambigen5.ogg','sound/ambience/ambigen6.ogg','sound/ambience/ambigen7.ogg','sound/ambience/ambigen8.ogg','sound/ambience/ambigen9.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen11.ogg','sound/ambience/ambieng1.ogg')

/area/ship/skrellscoutship/command/bridge
	name = "\improper Helm"
	icon_state = "bridge"
	
/area/ship/skrellscoutship/command/armory
	name = "\improper Armory"
	icon_state = "shuttlered"
	
/area/ship/skrellscoutshuttle
	name = "\improper Skrellian Shuttle"
	icon_state = "bridge"
	base_turf = /turf/simulated/floor/plating
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED
	req_access = list(access_skrellscoutship)