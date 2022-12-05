/area/hallway/primary/seconddeck/fore
	name = "Second Deck - Hallway - Fore "
	icon_state = "hallF"

/area/hallway/primary/seconddeck/center
	name = "Second Deck - Hallway - Central"
	icon_state = "hallC3"

/area/hallway/primary/seconddeck/aft
	name = "Second Deck - Hallway - Aft"
	icon_state = "hallA"

/area/hallway/primary/seconddeck/central_stairwell
	name = "Second Deck - Stairwell - Central "
	icon_state = "hallC2"

/area/hallway/primary/seconddeck/fore_stairwell
	name = "Second Deck - Stairwell - Fore "
	icon_state = "hallC2"

/area/maintenance/seconddeck
	name = "Second Deck - Maintenance"
	icon_state = "maintcentral"

/area/maintenance/seconddeck/xenobio
	name = "Second Deck - Maintenance - Xenobio"
	icon_state = "maintcentral"

/area/maintenance/seconddeck/emergency
	name = "Second Deck - Emergency Storage"
	icon_state = "emergencystorage"

/area/maintenance/seconddeck/foreport
	name = "Second Deck - Maintenance - Fore-Port "
	icon_state = "fpmaint"

/area/maintenance/seconddeck/forestarboard
	name = "Second Deck - Maintenance - Fore-Starboard "
	icon_state = "fsmaint"

/area/maintenance/seconddeck/starboard
	name = "Second Deck - Maintenance - Starboard "
	icon_state = "smaint"

/area/maintenance/seconddeck/port
	name = "Second Deck - Maintenance - Port"
	icon_state = "pmaint"

/area/maintenance/seconddeck/aftstarboard
	name = "Second Deck - Maintenance - Aft-Starboard "
	icon_state = "asmaint"

/area/maintenance/seconddeck/aftport
	name = "Second Deck - Maintenance - Aft-Port"
	icon_state = "apmaint"

/area/teleporter/seconddeck
	name = "Second Deck - Teleporter"
	icon_state = "teleporter"

/area/crew_quarters/safe_room/seconddeck
	name = "Second Deck - Safe Room"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED

/area/maintenance/substation/seconddeck
	name = "Second Deck - Substation"

/area/maintenance/compactor
	name = "Second Deck - Compactor"
	icon_state = "disposal"
	sound_env = STANDARD_STATION
	req_access = list(list(access_cargo, access_maint_tunnels))

/area/crew_quarters/laundry
	name = "Second Deck - Laundry Room"
	icon_state = "Sleep"

/area/maintenance/abandoned_compartment
	name = "Second Deck - Abandoned - Bar"
	turf_initializer = /singleton/turf_initializer/maintenance/heavy
	icon_state = "cafeteria"

/area/maintenance/abandoned_hydroponics
	name = "Second Deck - Abandoned - Hydroponics"
	icon_state = "hydro"
	turf_initializer = /singleton/turf_initializer/maintenance/heavy

/area/maintenance/abandoned_common
	name = "Second Deck - Abandoned - Actors Room"
	icon = 'packs/infinity/icons/turf/areas.dmi'
	icon_state = "music_room"
	turf_initializer = /singleton/turf_initializer/maintenance/heavy

/* COMMAND AREAS
 * =============
 */

/area/crew_quarters/heads/cobed
	name = "Second Deck - Command - Captain's Quarters"
	sound_env = MEDIUM_SOFTFLOOR
	icon_state = "captain"
	req_access = list(access_captain)

/area/crew_quarters/heads/office/captain
	name = "Second Deck - Command - Captain's Office"
	icon_state = "heads_cap"
	sound_env = MEDIUM_SOFTFLOOR
	req_access = list(access_captain)

/area/crew_quarters/heads/captain
	req_access = list(access_captain)
	icon_state = "heads_cap"

/area/crew_quarters/heads/captain/office_anteroom
	name = "Second Deck - Command - Captain's Office Anteroom"
	sound_env = MEDIUM_SOFTFLOOR

/area/crew_quarters/heads/captain/beach
	name = "Second Deck - Command - Captain's Recreation Facility"
	icon_state = "heads_cap"
	sound_env = PLAIN
	req_access = list()

/area/crew_quarters/heads/office/ce
	icon_state = "heads_ce"
	name = "Second Deck - Command - CE's Office"
	req_access = list(access_ce)

/area/bridge
	name = "Second Deck - Bridge"
	icon_state = "bridge"
	req_access = list(access_bridge)
	ambience = list('packs/infinity/sound/SS2/ambience/ambbridge.wav')

/area/bridge/nano
	icon = 'packs/infinity/icons/turf/areas.dmi'
	icon_state = "bridge_room"

/area/bridge/meeting_room
	name = "Second Deck - Command - Meeting Room"
	ambience = list()
	sound_env = MEDIUM_SOFTFLOOR

/area/bridge/lobby
	name = "Bridge - Lobby"
	req_access = list()

/area/teleporter
	name = "Second Deck - Teleporter"
	icon_state = "teleporter"
	sound_env = SMALL_ENCLOSED
	req_access = list(access_teleporter)

/* ENGINEERING AREAS
 * =================
 */

/area/engineering/hallway
	name = "Second Deck - Engineering - Hallway"
	icon_state = "engineering_workshop"

/area/engineering/hardstorage
	name = "Second Deck - Engineering - Storage"
	icon_state = "engineering_storage"
	sound_env = SMALL_ENCLOSED

/area/engineering/engine_room
	name = "Second Deck - Engine - Supermatter"
	icon_state = "engine"
	sound_env = LARGE_ENCLOSED
	area_flags = AREA_FLAG_ION_SHIELDED
	ambience = list(\
	'sound/ambience/engineering/engineering1.ogg',\
	'sound/ambience/engineering/engineering2.ogg',\
	'sound/ambience/engineering/engineering3.ogg'\
	)
	req_access = list(access_engine_equip)

/area/engineering/engine_eva
	name = "Second Deck - Engineering - EVA"
	icon_state = "engine_eva"
	req_access = list(list(access_eva, access_external_airlocks), access_engine)

/area/engineering/engine_monitoring
	name = "Second Deck - Engine - Monitoring"
	icon_state = "engine_monitoring"
	ambience = list(\
	'sound/ambience/engineering/engineering1.ogg',\
	'sound/ambience/engineering/engineering2.ogg',\
	'sound/ambience/engineering/engineering3.ogg'\
	)

/area/engineering/engine_smes
	name = "Second Deck - Engine - SMES"
	icon_state = "engine_smes"
	sound_env = SMALL_ENCLOSED

/area/engineering/engineering_monitoring
	name = "Second Deck - Engineering - Monitoring"
	icon_state = "engine_monitoring"

/area/engineering/locker_room
	name = "Second Deck - Engineering - Locker Room"
	icon_state = "engineering_locker"

/area/engineering/materials_storage
	name = "Second Deck - Engineering - Materials Storage"
	icon_state = "engineering_storage"

/area/engineering/atmos
	name = "Second Deck - Engineering - Atmospherics"
	icon_state = "atmos"
	ambience = list(\
	'sound/ambience/engineering/engineering1.ogg',\
	'sound/ambience/engineering/engineering2.ogg',\
	'sound/ambience/engineering/engineering3.ogg',\
	'sound/ambience/engineering/atmospherics1.ogg'\
	)
	sound_env = LARGE_ENCLOSED
	req_access = list(access_atmospherics)

/area/engineering/gravitaional_generator
	name = "Second Deck - Gravitational Generator"
	icon_state = "engine_monitoring"
	req_access = list(list(access_engine_equip, access_heads), list(access_seneng, access_engine_equip))
	sound_env = SMALL_ENCLOSED

/area/engineering/bluespace
	name = "Second Deck - Engineering - BlueSpace Drive"
	icon_state = "engine_monitoring"
	req_access = list(list(access_engine_equip, access_heads), access_engine, access_maint_tunnels)
	sound_env = SMALL_ENCLOSED

/area/engineering/bluespace/chamber
	name = "Second Deck - Engineering - BlueSpace Drive - Chamber"
	icon_state = "engine"
	sound_env = LARGE_ENCLOSED

/area/shield/seconddeck
	name = "Second Deck - Shield Generator"

	// Storage
/area/storage/tech
	name = "Second Deck - Engineering - Technical Storage"
	icon_state = "storage"
	req_access = list(access_tech_storage)

/* VACANT AREAS
 * ============
 */
/*
/area/vacant/mess
	name = "Second Deck - Abandoned - Officer's Mess"
	icon_state = "bar"
*/
/area/vacant/gambling
	name = "Second Deck - Gambling Room"
	icon_state = "restrooms"
	sound_env = MEDIUM_SOFTFLOOR

// Holodecks
/area/holodeck
	name = "Second Deck - Holodeck"
	icon_state = "Holodeck"
	dynamic_lighting = 0
	sound_env = LARGE_ENCLOSED

/area/holocontrol
	name = "Second Deck - Holodeck Control"
	icon_state = "Holodeck"

/* CREW AREAS
 * ==========
 */

/area/hydroponics
	name = "Second Deck - Service - Hydroponics"
	icon_state = "hydro"

/area/hydroponics/storage
	name = "Second Deck - Service - Hydroponics Storage"

/area/crew_quarters/bar
	name = "Second Deck - Service - Bar"
	icon_state = "bar"
	sound_env = SMALL_ENCLOSED
	//req_access = list(list(access_kitchen, access_bar)) TODO: SIERRA PORT
	req_access = list(list(access_kitchen))

/area/crew_quarters/galley
	name = "Second Deck - Service - Galley"
	icon_state = "kitchen"
	//req_access = list(list(access_kitchen, access_bar)) TODO: SIERRA PORT
	req_access = list(list(access_kitchen))

/area/crew_quarters/galley/backroom
	name = "Second Deck - Service - Galley Cold Storage"
	icon_state = "kitchen"
	//req_access = list(list(access_kitchen, access_bar)) TODO: SIERRA PORT
	req_access = list(list(access_kitchen))

/area/crew_quarters/cafe
	name = "Second Deck - Living - Cafe"
	icon_state = "cafeteria"

/area/crew_quarters/sauna
	name = "Second Deck - Living - Sauna"
	icon_state = "sauna"
	sound_env = SMALL_ENCLOSED

/area/grove/theta // /area/ai_abadoned
	name = "Second Deck - Grove - Theta"
	icon_state = "garden"
	sound_env = LARGE_SOFTFLOOR

/area/crew_quarters/head
	name = "Second Deck - Living - Restroom"
	icon_state = "toilet"
	sound_env = SMALL_ENCLOSED

/area/crew_quarters/head_big
	name = "Second Deck - Living - Lounge - Restroom"
	icon_state = "toilet"
	sound_env = SMALL_ENCLOSED
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED

/area/crew_quarters/game_room
	name = "Second deck - living - Lounge - Game room"
	icon_state = "game_room_inf"
	sound_env = SMALL_ENCLOSED
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED
/*
/area/crew_quarters/showers
	name = "Second Deck - Living - Private Showers"
	icon_state = "toilet"
	sound_env = SMALL_ENCLOSED
*/
/area/crew_quarters/gym
	name = "Second Deck - Living - Gym"
	icon_state = "fitness"



/area/crew_quarters/actor
	name = "Second Deck - Service - Actor"
	icon_state = "Theatre"
	sound_env = SMALL_SOFTFLOOR
	req_access = list(access_actor)

/area/crew_quarters/lounge
	name = "Second Deck - Living - Lounge"
	sound_env = MEDIUM_SOFTFLOOR

/area/crew_quarters/lounge_big
	name = "Second Deck - Living - Lounge - North"
	icon_state = "Sleep"
	sound_env = MEDIUM_SOFTFLOOR

/area/crew_quarters/sleep/bunk
	name = "Second Deck - Living - Dormitory"
	icon_state = "Sleep"
	sound_env = SMALL_SOFTFLOOR
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED

/area/crew_quarters/sleep/bunk_big
	name = "Second Deck - Living - Dormitory - Big One"
	icon_state = "Sleep"
	sound_env = SMALL_SOFTFLOOR
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED

/area/crew_quarters/sleep/bunk_big/room_two
	name = "Second Deck - Living - Dormitory - Big Two"
	icon_state = "Sleep"

/area/crew_quarters/sleep/cryo
	name = "Second Deck - Living - Cryogenic Storage"
	icon = 'packs/infinity/icons/turf/areas.dmi'
	icon_state = "cryo"

/area/crew_quarters/sleep/cryo/south
	name = "Second Deck - Living - Cryogenic Storage - South"
	icon_state = "cryo_south"

/area/crew_quarters/adherent
	name = "Second Deck - Living - Adherent Maintenence"
	icon_state = "robotics"

	// CHAPEL AREAS //cut this shit and replace faster
/area/chapel/main
	name = "Second Deck - Chapel"
	icon_state = "chapel"
	ambience = list(\
	'sound/ambience/chapel/chapel1.ogg',\
	'sound/ambience/chapel/chapel2.ogg',\
	'sound/ambience/chapel/chapel3.ogg',\
	'sound/ambience/chapel/chapel4.ogg'\
	)
	sound_env = LARGE_ENCLOSED

/area/chapel/office
	name = "Second Deck - Chapel - Chaplain's Office"
	req_access = list(access_chapel_office)
	color = COLOR_GRAY80
	sound_env = SMALL_SOFTFLOOR

/* MEDBAY AREAS
 * ============
 */
/*
/area/medical/virology
	name = "Second Deck - Abandoned - Virology"
	req_access = list()

/area/medical/virologyaccess
	name = "Second Deck - Abandoned - Virology Access"
	req_access = list()
*/
/area/medical/maintenance_equipstorage
	name = "Second Deck - Infirmary - Lower Storage"
	icon_state = "medbay4"
	req_access = list(access_medical_equip)

/area/turret_protected/ai_cyborg_station
	name = "Second Deck - Cyborg Station"
	icon_state = "ai_cyborg"
	sound_env = SMALL_ENCLOSED
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED
