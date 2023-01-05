/area/hallway/primary/thirddeck/fore
	name = "Third Deck - Hallway - Fore"
	icon_state = "hallF"

/area/hallway/primary/thirddeck/center
	name = "Third Deck - Hallway - Central"
	icon_state = "hallC3"

/area/hallway/primary/thirddeck/aft
	name = "Third Deck - Hallway - Aft"
	icon_state = "hallA"

/area/hallway/primary/thirddeck/central_stairwell
	name = "Third Deck - Stairwell - Central"
	icon_state = "hallC2"

/area/maintenance/thirddeck
	name = "Third Deck - Maintenance"
	icon_state = "maintcentral"

/area/maintenance/thirddeck/aft
	name = "Third Deck - Maintenance - Aft"
	icon_state = "amaint"

/area/maintenance/thirddeck/foreport
	name = "Third Deck - Maintenance - Fore-Port "
	icon_state = "fpmaint"

/area/maintenance/thirddeck/forestarboard
	name = "Third Deck - Maintenance - Fore-Starboard "
	icon_state = "fsmaint"

/area/maintenance/thirddeck/starboard
	name = "Third Deck - Maintenance - Starboard "
	icon_state = "smaint"

/area/maintenance/thirddeck/port
	name = "Third Deck - Maintenance - Port"
	icon_state = "pmaint"

/area/maintenance/substation/thirddeck
	name = "Third Deck - Substation"

/area/maintenance/waterstore
	name = "Third Deck - Water Cistern"
	icon_state = "disposal"
	req_access = list(list(access_cargo, access_engine, access_el))

/area/crew_quarters/commissary
	name = "Third Deck - Commissary"
	req_access = list(access_commissary)

/* COMMAND AREAS
 * =============
 */
/area/command/exploration_leader
	name = "Third Deck - Expedition - Leader's Office"
	icon_state = "heads_sea"
	req_access = list(access_el)

/area/command/bsa
	name = "Third Deck - Obstruction Field Disperser"
	icon_state = "firingrange"
	req_access = list(access_gun)

/* ENGINEERING AREAS
 * =================
 */

	// Storage
/area/storage/primary
	name = "Third Deck - Primary Tool Storage"
	icon_state = "primarystorage"

/area/storage/auxillary/port
	name = "Third Deck - Supply - Auxillary Warehouse"
	icon_state = "auxstorage"
	req_access = list(access_cargo)
/area/storage/airlock_canisters
	name = "Third Deck - Supply - Central Airlock's Canisters"
	req_access = list(list(access_cargo, access_engine))

	//thusters
/area/thruster/d3port
	name = "Third Deck - Nacelle - Port"

/area/thruster/d3starboard
	name = "Third Deck - Nacelle - Starboard"
/* VACANT AREAS
 * ============
 */

/area/vacant
	name = "Vacant Area"
	icon_state = "construction"
	area_flags = AREA_FLAG_RAD_SHIELDED
	req_access = list(access_maint_tunnels)

/area/vacant/infirmary
	name = "Third Deck - Abandoned - Infirmary"
	icon_state = "medbay"

/area/vacant/monitoring
	name = "Third Deck - Abandoned - Monitoring"
	icon_state = "engine_monitoring"

/area/vacant/cargo
	name = "Third Deck - Abandoned - Requisition"
	icon_state = "quart"

/* SUPPLY AREAS
 * ============
 */

/area/quartermaster
	req_access = list(access_cargo)

/area/quartermaster/office
	name = "Third Deck - Supply"
	icon_state = "quartoffice"
	req_access = list(access_mailsorting, access_cargo)

/area/quartermaster/suplocker_room
	name = "Third Deck - Supply - Locker room"
	icon_state = "quartoffice"
	req_access = list(access_mailsorting, access_cargo)

/area/quartermaster/storage
	name = "Third Deck - Supply - Warehouse"
	icon_state = "quartstorage"
	sound_env = LARGE_ENCLOSED

/area/quartermaster/deckofficer
	name = "Third Deck - Supply - Quartermaster"
	icon_state = "quart"
	req_access = list(access_qm)

/area/quartermaster/expedition
	name = "Third Deck - Exploration - Locker Room"
	icon_state = "mining"
	req_access = list(list(access_mining, access_xenoarch))

/area/quartermaster/expedition/eva
	name = "Third Deck - Exploration - EVA"
	icon_state = "mining"

/area/quartermaster/expedition/storage
	name = "Third Deck - Exploration - Storage"
	icon_state = "mining"

/area/quartermaster/exploration
	name = "Third Deck - Expedition - Equipment"
	icon_state = "exploration"
	req_access = list(access_explorer)

/area/quartermaster/shuttlefuel
	name = "Third Deck - Hangar - Fuel Bay"
	icon_state = "toxstorage"
	sound_env = SMALL_ENCLOSED
	req_access = list(list(access_cargo, access_expedition_shuttle_helm, access_guppy_helm))

/area/quartermaster/hangar
	name = "Third Deck - Hangar"
	icon_state = "hangar"
	sound_env = LARGE_ENCLOSED
	req_access = list(access_hangar)
	ambience = list(\
	'sound/ambience/hangar/hangar1.ogg',\
	'sound/ambience/hangar/hangar2.ogg',\
	'sound/ambience/hangar/hangar3.ogg',\
	'sound/ambience/hangar/hangar4.ogg',\
	'sound/ambience/hangar/hangar5.ogg',\
	'sound/ambience/hangar/hangar6.ogg'\
	)

/area/quartermaster/hangar_atmos
	name = "Third Deck - Hangar - Atmospherics Storage"
	icon_state = "auxstorage"

/* CREW AREAS
 * ==========
 */

/area/janitor
	name = "Third Deck - Service - Custodial Closet"
	icon_state = "janitor"
	req_access = list(access_janitor)

/* SECURITY AREAS
 *
 */

/area/security/sierra/dockcheck
	name = "Third Deck - Security - Fore Docks Checkpoint"
	icon_state = "checkpoint1"
	req_access = list(list(access_security, access_forensics_lockers))
