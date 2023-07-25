/area/ship/patrol
	name = "\improper Patrol Ship"
	icon_state = "shuttle2"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED

/area/ship/patrol/crew
	name = "\improper Crew Section"
	icon_state = "crew_quarters"
	req_access = list(access_away_cavalry)

/area/ship/patrol/crew/hallway/lower
	name = "\improper Lower Hallway - Center"
	req_access = list(access_away_cavalry)

/area/ship/patrol/crew/hallway/lower/fore
	name = "\improper Lower Hallway - Fore"
	req_access = list(access_away_cavalry)

/area/ship/patrol/crew/hallway/lower/aft
	name = "\improper Lower Hallway - Aft"
	req_access = list(access_away_cavalry)

/area/ship/patrol/crew/hallway/lower/port
	name = "\improper Lower Hallway - Port"
	req_access = list(access_away_cavalry)

/area/ship/patrol/crew/hallway/lower/starboard
	name = "\improper Lower Hallway - Starboard"
	req_access = list(access_away_cavalry)

/area/ship/patrol/crew/hallway/upper/starboard
	name = "\improper Upper Hallway - Center"
	req_access = list(access_away_cavalry)

/area/ship/patrol/crew/hallway/upper/starboard
	name = "\improper Upper Hallway - Starboard"
	req_access = list(access_away_cavalry)


/area/ship/patrol/crew/kitchen
	name = "\improper Galley"
	icon_state = "kitchen"
	req_access = list(access_away_cavalry)

/area/ship/patrol/crew/cryo
	name = "Cryo Storage"
	icon_state = "cryo"
	req_access = list(access_away_cavalry)

/area/ship/patrol/crew/comms
	name = "Communication Relay"
	req_access = list(access_away_cavalry, access_away_cavalry_commander)

/area/ship/patrol/crew/toilet
	name = "\improper Head"
	icon_state = "locker"
	req_access = list(access_away_cavalry)

/area/ship/patrol/crew/cargo
	name = "\improper Cargo Hold"
	icon_state = "quartstorage"
	req_access = list(access_away_cavalry)

/area/ship/patrol/crew/fitness
	name = "\improper Fitness Bay"
	icon_state = "green"
	req_access = list(access_away_cavalry)

/area/ship/patrol/crew/brig
	name = "\improper Brig Section"
	icon_state = "locker"
	req_access = list(access_away_cavalry)

/area/ship/patrol/crew/brig/office
	name = "\improper Brig Office"
	icon_state = "locker"
	req_access = list(access_away_cavalry)

/area/ship/patrol/crew/brig/emergency_armory
	name = "Emergency Armory"
	icon_state = "locker"
	req_access = list(access_away_cavalry, access_away_cavalry_fleet_armory)

/area/ship/patrol/engineering/hallway
	name = "\improper Engineering Hallway"
	icon_state = "green"
	req_access = list(access_away_cavalry)

/area/ship/patrol/engineering/equipment
	name = "\improper Engineering Equipment"
	icon_state = "green"
	req_access = list(access_away_cavalry)

/area/ship/patrol/engineering/storage
	name = "\improper Engineering Storage"
	icon_state = "green"
	req_access = list(access_away_cavalry)

/area/ship/patrol/engineering/shield
	name = "\improper Shield Generator"
	icon_state = "green"
	req_access = list(access_away_cavalry)

/area/ship/patrol/engineering/fussion
	name = "\improper Fussion Zone"
	icon_state = "red"
	req_access = list(access_away_cavalry)

/area/ship/patrol/engineering/fussion/control
	name = "\improper Fussion Control"
	icon_state = "green"
	req_access = list(access_away_cavalry)




/area/ship/patrol/barracks
	name = "\improper Troops Section"
	icon_state = "locker"
	req_access = list(access_away_cavalry, access_away_cavalry_ops)

/area/ship/patrol/barracks/armory
	name = "\improper Troops Armory"
	icon_state = "locker"
	req_access = list(access_away_cavalry, access_away_cavalry_ops, access_away_cavalry_captain)




/area/ship/patrol/medbay
	name = "\improper Medical Bay"
	icon_state = "medbay"
	req_access = list(access_away_cavalry)

/area/ship/patrol/medbay/lobby
	name = "\improper Medical Bay Lobby"
	icon_state = "medbay"
	req_access = list(access_away_cavalry)





/area/ship/patrol/maintenance/lower
	name = "\improper Maintenance Lower Fore"
	icon_state = "amaint"
	req_access = list(access_away_cavalry)

/area/ship/patrol/maintenance/lower/starboard
	name = "\improper Maintenance Lower Starboard"
	icon_state = "amaint"
	req_access = list(access_away_cavalry)

/area/ship/patrol/maintenance/lower/port
	name = "\improper Maintenance Lower Port"
	icon_state = "amaint"
	req_access = list(access_away_cavalry)

/area/ship/patrol/maintenance/upper
	name = "\improper Maintenance Upper Fore"
	icon_state = "amaint"
	req_access = list(access_away_cavalry)

/area/ship/patrol/maintenance/upper/aft
	name = "\improper Maintenance Upper Aft"
	icon_state = "amaint"
	req_access = list(access_away_cavalry)

/area/ship/patrol/maintenance/upper/port
	name = "\improper Maintenance Upper Port"
	icon_state = "amaint"
	req_access = list(access_away_cavalry)

/area/ship/patrol/maintenance/upper/starboard
	name = "\improper Maintenance Upper Starboard"
	icon_state = "amaint"
	req_access = list(access_away_cavalry)

/area/ship/patrol/maintenance/upper/munition
	name = "\improper Ammunition Storage"
	req_access = list(access_away_cavalry)

/area/ship/patrol/maintenance/upper/waste
	name = "\improper Waste Disposal"
	req_access = list(access_away_cavalry)

#define PATROL_ENG_AMBIENCE list('sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambigen5.ogg','sound/ambience/ambigen6.ogg','sound/ambience/ambigen7.ogg','sound/ambience/ambigen8.ogg','sound/ambience/ambigen9.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen11.ogg','sound/ambience/ambieng1.ogg')
/area/ship/patrol/maintenance/atmos
	name = "\improper Atmospherics Comparment"
	icon_state = "atmos"
	ambience = PATROL_ENG_AMBIENCE
	req_access = list(access_away_cavalry)

/area/ship/patrol/maintenance/engine
	icon_state = "engine"
	ambience = PATROL_ENG_AMBIENCE
	req_access = list(access_away_cavalry)
#undef PATROL_ENG_AMBIENCE

/area/ship/patrol/maintenance/engine/port
	name = "\improper Port Thruster"
	req_access = list(access_away_cavalry)

/area/ship/patrol/maintenance/engine/starboard
	name = "\improper Starboard Thruster"
	req_access = list(access_away_cavalry)



/area/ship/patrol/command/bridge
	name = "\improper Bridge"
	icon_state = "bridge"
	req_access = list(access_away_cavalry)

/area/ship/patrol/command/eva
	name = "\improper Fleet EVA"
	req_access = list(access_away_cavalry)

/area/ship/patrol/command/equipment
	name = "\improper Fleet Equipment"
	req_access = list(access_away_cavalry)

/area/ship/patrol/command/hangar
	name = "\improper Hangar"
	icon_state = "purple"
	req_access = list(access_away_cavalry)

/area/ship/patrol/command/cannon
	name = "\improper Impulse Cannon"
	icon_state = "yellow"
	req_access = list(access_away_cavalry)



/area/ship/patrol/dock
	name = "\improper Docking Bay"
	icon_state = "entry_1"
	req_access = list(access_away_cavalry)
