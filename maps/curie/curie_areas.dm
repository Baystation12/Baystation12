/datum/map/curie
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


/area/curie/laundry
	name = "\improper Laundry Room"
	icon_state = "toilet"
	sound_env = SMALL_SOFTFLOOR

/area/curie/freezer
	name = "\improper Freezer"
	sound_env = SMALL_ENCLOSED

/area/curie/medbay
	name = "\improper Medbay"
	icon_state = "medbay"
	ambience = list('sound/ambience/signal.ogg')

/area/curie/parc
	name = "\improper Petit parc"
	icon_state = "garden"
	sound_env = MEDIUM_SOFTFLOOR

/area/curie/escape/lobby
	name = "\improper Escape Shuttle Lobby"
	icon_state = "escape"

/area/curie/common_room
	name = "\improper Common Room"
	icon_state = "garden"
	sound_env = MEDIUM_SOFTFLOOR

/area/curie/escape/exit
	name = "\improper Escape Shuttle Access"
	icon_state = "escape"

/area/curie/maintenance/hop
	name = "Lieutenant's Office Maintenance"
	icon_state = "maint_security_port"

/area/curie/atmos/access
	name = "\improper Atmospherics Access"
	icon_state = "atmos"
	sound_env = SMALL_ENCLOSED

/area/curie/engineering/workshop_starboard
	name = "\improper Engineering Workshop - Starboard"
	icon_state = "engineering_workshop"
	sound_env = LARGE_ENCLOSED

/area/curie/engineering/workshop_port
	name = "\improper Engineering Workshop - Port"
	icon_state = "engineering_workshop"
	sound_env = LARGE_ENCLOSED

/area/curie/engineering/eva
	name = "\improper EVA Storage"
	icon_state = "mining"

/area/curie/engineering/engine/maintenance
	name = "\improper Engine Maintenance"
	icon_state = "engine"

/area/curie/engineering/passage
	name = "\improper Engine Passage"
	icon_state = "engine"

/area/curie/arrivals/docks
	name = "\improper Station Docking Area"
	icon_state = "entry_1"

/area/curie/arrivals/lobby
	name = "\improper Station Arrivals"
	icon_state = "entry_2"

/area/curie/maintenance/substation
	name = "Substation"
	icon_state = "substation"
	sound_env = SMALL_ENCLOSED

/area/curie/maintenance/substation/civilian
	name = "Civilian Substation"

/area/curie/maintenance/substation/commandsupply
	name = "Command & Supply Substation"

/area/curie/maintenance/substation/research
	name = "Research Substation"

/area/curie/maintenance/substation/derelict
	name = "Derelict Substation"

/area/curie/maintenance/civilian
	name = "Civilian Maintenance"

/area/curie/shelter
	name = "Emergency Shelter"

/area/curie/medical/lockers
	name = "\improper Medbay Equipment"
	icon_state = "exam_room"

/area/curie/bridge_access
	name = "\improper Bridge Access"
	icon_state = "bridge"

/area/curie/chemistryaux
	name = "\improper Auxilliary Chemistry"
	icon_state = "chem"

/area/curie/derelict/old_bridge
	name = "\improper Old Bridge"
	icon_state = "bridge"

/area/curie/derelict/mining_access
	name = "\improper Mining Access"
	icon_state = "outpost_mine_main"

/area/curie/derelict/main_hallway
	name = "\improper Derelict Main Hallway"
	icon_state = "hallF"

/area/curie/derelict/starboard_hallway
	name = "\improper Derelict Starboard Hallway"
	icon_state = "hallS"

/area/curie/derelict/old_speech
	name = "\improper Old Speech Room"
	icon_state = "bridge"

/area/curie/derelict/old_office
	name = "\improper Old Office"
	icon_state = "chapeloffice"

/area/curie/derelict/breakroom
	name = "\improper 'Hidden' Break Room"
	icon_state = "crew_quarters"
	sound_env = MEDIUM_SOFTFLOOR

/area/curie/derelict/central_hallway
	name = "\improper Derelict Central Hallway"
	icon_state = "hallS"

/area/curie/derelict/garbagedump
	name = "\improper Garbage Dump"
	icon_state = "janitor"
