/area/hallway/primary/bridgedeck/center
	name = "Bridge - Hallway - Central"
	icon_state = "hallC3"

/area/hallway/primary/bridgedeck/aft
	name = "Bridge - Hallway - Aft"
	icon_state = "hallA"

/area/hallway/primary/bridgedeck/central_stairwell
	name = "Bridge - Stairwell - Central"
	icon_state = "hallC2"

/area/maintenance/bridgedeck
	name = "Bridge - Maintenance"
	icon_state = "maintcentral"

/area/maintenance/bridgedeck/aft
	name = "Bridge - Maintenance - Aft"
	icon_state = "amaint"

/area/maintenance/bridgedeck/starboard
	name = "Bridge - Maintenance - Starboard "
	icon_state = "smaint"

/area/maintenance/bridgedeck/port
	name = "Bridge - Maintenance - Port"
	icon_state = "pmaint"

/area/maintenance/substation/bridgedeck
	name = "Bridge - Substation"

/area/crew_quarters/sleep/cryo/bridge
	name = "Bridge - Living - Cryogenic Storage"

/* COMMAND AREAS
 * =============
 */
/area/crew_quarters/heads/office/captain
	name = "Bridge - Command - Captain's Office"
	icon_state = "heads_cap"
	sound_env = MEDIUM_SOFTFLOOR
	req_access = list(access_captain)

/area/crew_quarters/heads/captain
	req_access = list(access_captain)
	icon_state = "heads_cap"

/area/crew_quarters/heads/captain/beach
	name = "Bridge - Command - Captain's Recreation Facility"
	icon_state = "heads_cap"
	sound_env = PLAIN
	req_access = list("ACCESS_BRIDGE")

/area/bridge
	name = "Bridge Deck - Bridge"
	icon_state = "bridge"
	req_access = list(access_bridge)
	ambience = list('maps/sierra/sound/ambience/bridge.wav')

/area/bridge/nano
	icon = 'maps/sierra/icons/turf/areas.dmi'
	name = "Bridge Deck - Entrance"
	icon_state = "bridge_room"

/area/bridge/meeting_room
	name = "Bridge - Command - Meeting Room"
	icon_state = "briefing_room"
	ambience = list()
	sound_env = MEDIUM_SOFTFLOOR

/area/bridge/marine_room
	icon = 'maps/sierra/icons/turf/areas.dmi'
	name = "Bridge - Command - Briefing Room"
	icon_state = "bridge_room"

/area/bridge/lobby
	name = "Bridge - Lobby"
	req_access = list()

/area/bridge/hallway
	name = "Bridge - Hallway"

/area/bridge/storage
	name = "Bridge - Storage"
	req_access = list(access_bridge)

/area/teleporter
	name = "Bridge - Teleporter"
	icon_state = "teleporter"
	sound_env = SMALL_ENCLOSED
	req_access = list(access_teleporter)

// AI
/area/turret_protected
	req_access = list(access_ai_upload)
	ambience = list(
		'maps/sierra/sound/ambience/aimalf.ogg',
		'maps/sierra/sound/ambience/aiservers.wav',
		'maps/sierra/sound/ambience/aiporthum.ogg',
		'maps/sierra/sound/ambience/ai1.ogg',
		'maps/sierra/sound/ambience/ai2.ogg',
		'maps/sierra/sound/ambience/ai3.ogg'
	)
	forced_ambience = list('maps/sierra/sound/ambience/ambxerxes_looped.wav')

/area/turret_protected/ai
	name = "AI Chamber"
	icon_state = "ai_chamber"

/area/turret_protected/ai_teleport
	name = "First Deck - AI Upload"
	icon_state = "ai_upload"

/area/turret_protected/ai_upload
	name = "First Deck - AI Upload"
	icon_state = "ai_upload"

// Heads Quarters

/area/crew_quarters/safe_room/bridge
	name = "Bridge - Safe Room"

/area/crew_quarters/heads/office/rd/cobed
	icon_state = "heads_rd"
	name = "Bridge - Command - RD's Quarters"
	req_access = list(access_rd)

/area/crew_quarters/heads/office/cmo/cobed
	icon_state = "heads_cmo"
	name = "Bridge - Command - CMO's Quarters"
	req_access = list(access_cmo)

/area/crew_quarters/heads/office/ce/cobed
	icon_state = "heads_ce"
	name = "Bridge - Command - CE's Quarters"
	req_access = list(access_ce)

/area/crew_quarters/heads/office/hos/cobed
	icon_state = "heads_hos"
	name = "Bridge - Command - HoS's Quarters"
	req_access = list(access_hos)

/area/crew_quarters/heads/office/hop
	name = "Bridge - Command - HoP's Office"
	icon_state = "heads_hop"
	req_access = list(access_hop)

/area/crew_quarters/heads/office/hop/cobed
	name = "Bridge - Command - HoP's Quarters"

/area/crew_quarters/heads/office/iaa
	icon_state = "heads_cl"
	name = "Bridge - Command - IAA's Office"
	req_access = list(access_iaa)

/area/crew_quarters/heads/office/iaa/high_sec
	name = "Bridge - Command - IAA's Communication Relay"

/area/crew_quarters/heads/office/iaa/cobed
	name = "Bridge - Command - IAA's Quarters"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/bridge/adjutants
	name = "Bridge - Adjutants Room"
	icon = 'maps/sierra/icons/turf/areas.dmi'
	icon_state = "bridge_gun"

/area/bridge/adjutants/cobed
	name = "Bridge - Adjutants Dormintories"


/area/crew_quarters/heads/captain/secret_room/level_one
	name = "Second Deck - Captain's restroom"
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/crew_quarters/head_big
	name = "Bridge - Living - Restroom"
	icon_state = "toilet"
	sound_env = SMALL_ENCLOSED
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED

// Solars

/area/maintenance/solar/bridge_port
	name = "Bridge - Solar - Port"
	icon_state = "SolarcontrolP"

/area/maintenance/solar/bridge_starboard
	name = "Bridge - Solar - Starboard"
	icon_state = "SolarcontrolS"

/area/solar/bridge_starboard
	name = "Bridge - Solar - Starboard Array"
	icon_state = "panelsS"

/area/solar/bridge_port
	name = "Bridge - Solar - Port Array"
	icon_state = "panelsP"

/area/engineering/atmos/bridge
	name = "Bridge - Engineering - Atmospherics Suppliment"
	icon_state = "atmos_storage"
	sound_env = SMALL_ENCLOSED
	req_access = list(access_atmospherics)
