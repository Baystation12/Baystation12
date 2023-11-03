/area/hallway/primary/fourthdeck/fore
	name = "Fourth Deck - Hallway - Fore"
	icon_state = "hallF"
	req_access = list(access_external_airlocks)
	holomap_color = HOLOMAP_AREACOLOR_HALLWAYS

/area/hallway/primary/fourthdeck/center
	name = "Fourth Deck - Hallway - Central"
	icon_state = "hallC3"
	holomap_color = HOLOMAP_AREACOLOR_HALLWAYS

/area/hallway/primary/fourthdeck/aft
	name = "Fourth Deck - Hallway - Aft"
	icon_state = "hallA"
	holomap_color = HOLOMAP_AREACOLOR_HALLWAYS

/area/hallway/primary/fourthdeck/central_stairwell
	name = "Fourth Deck - Stairwell - Central"
	icon_state = "hallC2"
	holomap_color = HOLOMAP_AREACOLOR_HALLWAYS

/area/hallway/primary/fourthdeck/aft_stairwell
	name = "Fourth Deck - Stairwell - Fore "
	icon_state = "hallA"
	holomap_color = HOLOMAP_AREACOLOR_HALLWAYS

/area/maintenance/fourthdeck
	name = "Fourth Deck - Maintenance"
	icon_state = "maintcentral"

/area/maintenance/fourthdeck/aft
	name = "Fourth Deck - Maintenance - Aft"
	icon_state = "amaint"

/area/maintenance/fourthdeck/foreport
	name = "Fourth Deck - Maintenance - Fore-Port "
	icon_state = "fpmaint"

/area/maintenance/fourthdeck/forestarboard
	name = "Fourth Deck - Maintenance - Fore-Starboard "
	icon_state = "fsmaint"

/area/maintenance/fourthdeck/starboard
	name = "Fourth Deck - Maintenance - Starboard "
	icon_state = "smaint"

/area/maintenance/fourthdeck/port
	name = "Fourth Deck - Maintenance - Port"
	icon_state = "pmaint"

/area/maintenance/substation/fourthdeck
	name = "Fourth Deck - Substation"

/area/maintenance/waterstore
	name = "Fourth Deck - Water Cistern"
	icon_state = "disposal"
	req_access = list(list(access_cargo, access_engine, access_el))

/area/crew_quarters/visitors
	name = "Fourth Deck - Visitors"
	holomap_color = HOLOMAP_AREACOLOR_CREW

/area/crew_quarters/commissary
	name = "Fourth Deck - Commissary"
	icon_state = "crew_quarters"
	req_access = list(access_commissary)
	holomap_color = HOLOMAP_AREACOLOR_CREW

/area/crew_quarters/docking
	name = "Fourth Deck - Docking Bay"
	icon_state = "crew_quarters"
	lighting_tone = AREA_LIGHTING_COOL
	holomap_color = HOLOMAP_AREACOLOR_CREW

/* COMMAND AREAS
 * =============
 */
/area/command/exploration_leader
	name = "Fourth Deck - Expedition - Leader's Office"
	icon_state = "heads_sea"
	req_access = list(access_el)
	holomap_color = HOLOMAP_AREACOLOR_EXPLORATION

/* ENGINEERING AREAS
 * =================
 */
// Storage
/area/storage/primary
	name = "Fourth Deck - Primary Tool Storage"
	icon_state = "primarystorage"
	holomap_color = HOLOMAP_AREACOLOR_CARGO

/area/storage/auxillary/port
	name = "Fourth Deck - Supply - Auxillary Warehouse"
	icon_state = "auxstorage"
	req_access = list(access_cargo)
	holomap_color = HOLOMAP_AREACOLOR_CARGO
/area/storage/airlock_canisters
	name = "Fourth Deck - Supply - Central Airlock's Canisters"
	req_access = list(list(access_cargo, access_engine))
	holomap_color = HOLOMAP_AREACOLOR_CARGO

// Thusters
/area/thruster/d3port
	name = "Fourth Deck - Nacelle - Port"
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/thruster/d3starboard
	name = "Fourth Deck - Nacelle - Starboard"
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/* VACANT AREAS
 * ============
 */
/area/vacant
	name = "Vacant Area"
	icon_state = "construction"
	area_flags = AREA_FLAG_RAD_SHIELDED
	req_access = list(access_maint_tunnels)

/area/vacant/infirmary
	name = "Fourth Deck - Abandoned - Infirmary"
	icon_state = "medbay"

/area/vacant/monitoring
	name = "Fourth Deck - Abandoned - Monitoring"
	icon_state = "engine_monitoring"

/area/vacant/storage
	name = "Fourth Deck - Abandoned - Storage"
	icon_state = "engine_monitoring"

/area/vacant/cargo
	name = "Fourth Deck - Abandoned - Requisition"
	icon_state = "quart"

/* RND AREAS
 * =========
 */

/area/rnd/canister
	name = "Fourth Deck - Hangar - Canister Storage"
	icon_state = "toxstorage"
	sound_env = SMALL_ENCLOSED
	req_access = list(access_tox_storage)
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE

/* SUPPLY AREAS
 * ============
 */
/area/quartermaster
	req_access = list(access_cargo)
	holomap_color = HOLOMAP_AREACOLOR_CARGO

/area/quartermaster/office
	name = "Fourth Deck - Supply"
	icon_state = "quartoffice"
	req_access = list(access_mailsorting, access_cargo)

/area/quartermaster/office/post
	name = "Fourth Deck - Supply - Mail Delivery"

/area/quartermaster/suplocker_room
	name = "Fourth Deck - Supply - Locker room"
	icon_state = "quartoffice"
	req_access = list(access_mailsorting, access_cargo)

/area/quartermaster/storage
	name = "Fourth Deck - Supply - Warehouse"
	icon_state = "quartstorage"
	sound_env = LARGE_ENCLOSED

/area/quartermaster/deckofficer
	name = "Fourth Deck - Supply - Quartermaster"
	icon_state = "quart"
	req_access = list(access_qm)

/area/quartermaster/expedition
	name = "Fourth Deck - Exploration - Locker Room"
	icon_state = "mining"
	req_access = list(list(access_mining, access_xenoarch))

/area/quartermaster/expedition/eva
	name = "Fourth Deck - Exploration - EVA"
	icon_state = "mining"

/area/quartermaster/expedition/storage
	name = "Fourth Deck - Exploration - Storage"
	icon_state = "mining"

/area/quartermaster/exploration
	name = "Fourth Deck - Expedition - Locker Room"
	icon_state = "exploration"
	req_access = list(access_explorer)
	holomap_color = HOLOMAP_AREACOLOR_EXPLORATION

/area/quartermaster/exploration/eva
	name = "Fourth Deck - Expedition - EVA"

/area/quartermaster/exploration/storage
	name = "Fourth Deck - Expedition - Storage"

/area/quartermaster/exploration/briefing_room
	name = "Fourth Deck - Expedition - Briefing Room"

/area/quartermaster/shuttlefuel
	name = "Fourth Deck - Hangar - Fuel Bay"
	icon_state = "toxstorage"
	sound_env = SMALL_ENCLOSED
	req_access = list(list(access_cargo, access_expedition_shuttle_helm, access_guppy_helm))

/area/quartermaster/hangar
	name = "Fourth Deck - Hangar"
	icon_state = "hangar"
	sound_env = LARGE_ENCLOSED
	req_access = list(access_hangar)
	ambience = list(
		'maps/sierra/sound/ambience/hangar1.ogg',
		'maps/sierra/sound/ambience/hangar2.ogg',
		'maps/sierra/sound/ambience/hangar3.ogg',
		'maps/sierra/sound/ambience/hangar4.ogg',
		'maps/sierra/sound/ambience/hangar5.ogg',
		'maps/sierra/sound/ambience/hangar6.ogg'
	)

/area/quartermaster/hangar_atmos
	name = "Fourth Deck - Hangar - Atmospherics Storage"
	icon_state = "auxstorage"

/area/quartermaster/hangar_stairs
	name = "Fourth Deck - Hangar - Stairs"
	icon_state = "auxstorage"

/* SECURITY AREAS
 *
 */
/area/security/sierra/dockcheck
	name = "Fourth Deck - Security - Fore Docks Checkpoint"
	icon_state = "checkpoint1"
	req_access = list(list(access_security, access_forensics_lockers))
