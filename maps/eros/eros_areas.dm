//Centcomm

//Command

//Maintenance
/area/maintenance/engineering_east
	name = "East Engineering Maintenance"
	icon_state = "maint_eng_e"

/area/maintenance/engineering_west
	name = "West Engineering Maintenance"
	icon_state = "maint_eng_w"

/area/maintenance/engineering_north
	name = "North Engineering Maintenance"
	icon_state = "maint_eng_n"


//Substations
/area/maintenance/substation
	name = "Substation"
	icon_state = "substation"
	sound_env = SMALL_ENCLOSED

///area/maintenance/substation/example
//	name = "Example Substation"

/area/maintenance/substation/atmos
	name = "Atmospherics Substation"

/area/maintenance/substation/engineering
	name = "Engineering Substation"

//Solars
/area/solar
	requires_power = 1
	always_unpowered = 1
	lighting_use_dynamic = 0
	base_turf = /turf/snow

///area/maintenance/solar_example
//	name = "Solar Example"
//	icon_state = "SolarcontrolA"
//	sound_env = SMALL_ENCLOSED
//
///area/solar/example
//	name = "Example Solar Array"
//	icon_state = "panelsA"

//Engineering
/area/engineering/
	name = "\improper Engineering"
	icon_state = "engineering"

/area/engineering/engine_monitoring
	name = "\improper Engine Monitoring Room"
	icon_state = "engine_monitoring"

/area/engineering/engine_room
	name = "\improper Engine Room"
	icon_state = "engine"

/area/engineering/engine_smes
	name = "\improper Engineering SMES"
	icon_state = "engine_smes"

/area/engineering/hallway
	name = "\improper Engineering Hallway"
	icon_state = "engineering"

/area/engineering/hallway/engine
	name = "\improper Engine Hallway"
	icon_state = "engine"

/area/engineering/hallway/north
	name = "\improper Engineering North Hallway"
	icon_state = "engineering_n_hall"

/area/engineering/lobby
	name = "\improper Engineering Lobby"
	icon_state = "engineering_lobby"

/area/engineering/quarter
	name = "\improper Engineering Quarters"
	icon_state = "engineering_break"

/area/engineering/washroom
	name = "\improper Engineering Washroom"
	icon_state = "engineering_locker"

/area/engineering/foyer
	name = "\improper Engineering Foyer"
	icon_state = "engineering_foyer"

/area/engineering/engineering_monitor
	name = "\improper Engineering Monitoring Room"
	icon_state = "engine_monitoring"

/area/engineering/CE
	name = "\improper Engineering - CE's Office"
	icon_state = "head_quarters"

/area/engineering/CE/quarters
	name = "\improper Engineering - CE's Quarters"
	icon_state = "Sleep"

/area/engineering/storage
	name = "\improper Engineering Equipment Storage"
	icon_state = "engineering_supply"

/area/engineering/storage/hard
	name = "\improper Engineering Hard Storage"
	icon_state = "engineering_storage"

/area/engineering/atmos
	name = "\improper Atmospherics"
	icon_state = "atmos"

/area/engineering/tech_storage
	name = "\improper Technical Storage"
	icon_state = "auxstorage"

//Replaced with a shared monitoring room - more social that way.
///area/engineering/atmos/monitor
//	name = "\improper Atmospherics Monitoring Room"
//	icon_state = "atmos_monitoring"

/area/engineering/atmos/storage
	name = "\improper Atmospherics Storage"
	icon_state = "atmos_storage"
	sound_env = SMALL_ENCLOSED

/area/engineering/dronefab
	name = "\improper Drone Fabricator"
	icon_state = "drone_fab"

//Research

//Medical

//Security

//Cargo

//Civilian

//Misc.
