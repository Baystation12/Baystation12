/area/hallway/primary/thirddeck/fore
	name = "Third Deck - Hallway - Fore"
	icon_state = "hallF"
	holomap_color = HOLOMAP_AREACOLOR_HALLWAYS

/area/hallway/primary/thirddeck/center
	name = "Third Deck - Hallway - Central"
	icon_state = "hallC3"
	holomap_color = HOLOMAP_AREACOLOR_HALLWAYS

/area/hallway/primary/thirddeck/central_stairwell
	name = "Third Deck - Stairwell - Central"
	icon_state = "hallC2"
	holomap_color = HOLOMAP_AREACOLOR_HALLWAYS

/area/hallway/primary/thirddeck/aft_stairwell
	name = "Third Deck - Stairwell - Fore "
	icon_state = "hallA"
	holomap_color = HOLOMAP_AREACOLOR_HALLWAYS

/area/maintenance/thirddeck
	name = "Third Deck - Maintenance"
	icon_state = "maintcentral"

/area/maintenance/thirddeck/aftstarboard
	name = "Second Deck - Maintenance - Aft-Starboard "
	icon_state = "asmaint"

/area/maintenance/thirddeck/aftport
	name = "Second Deck - Maintenance - Aft-Port"
	icon_state = "apmaint"

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

/area/maintenance/cistern
	name = "Third Deck - Water Cistern"
	icon_state = "disposal"
	req_access = list(list(access_cargo, access_engine, access_el))

/area/hydroponics/third_deck_storage
	name = "Third Deck - Service - Hydroponics Storage"
	holomap_color = HOLOMAP_AREACOLOR_CREW

/area/crew_quarters/sleep/cryo/thirddeck
	name = "Third Deck - Living - Cryogenic Storage"
	holomap_color = HOLOMAP_AREACOLOR_CREW

/area/crew_quarters/head/deck3
	name = "Third Deck - Head"
	holomap_color = HOLOMAP_AREACOLOR_CREW

/area/crew_quarters/bar
	name = "Third Deck - Service - Bar"
	icon_state = "bar"
	sound_env = SMALL_ENCLOSED
	req_access = list(list(access_kitchen, access_bar))
	holomap_color = HOLOMAP_AREACOLOR_CREW

/area/crew_quarters/bar/cobed
	name = "Third Deck - Service - Bartender's Room"
	holomap_color = HOLOMAP_AREACOLOR_CREW

/area/crew_quarters/cafe
	name = "Third Deck - Living - Cafe"
	icon_state = "cafeteria"
	holomap_color = HOLOMAP_AREACOLOR_CREW

/area/command/chief_steward
	name = "Third Deck - Service - Chief Steward's Office"
	icon_state = "kitchen"
	sound_env = SMALL_ENCLOSED
	lighting_tone = AREA_LIGHTING_WARM
	req_access = list(access_chief_steward)
	holomap_color = HOLOMAP_AREACOLOR_CREW

/* ENGINEERING AREAS
 * =================
 */
/area/engineering/hardstorage
	name = "Third Deck - Engineering - Storage"
	icon_state = "engineering_storage"
	sound_env = SMALL_ENCLOSED
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/engineering/engine_room
	name = "Third Deck - Engine - Supermatter"
	icon_state = "engine"
	sound_env = LARGE_ENCLOSED
	area_flags = AREA_FLAG_ION_SHIELDED
	ambience = list(
		'maps/sierra/sound/ambience/engineering1.ogg',
		'maps/sierra/sound/ambience/engineering2.ogg',
		'maps/sierra/sound/ambience/engineering3.ogg'
	)
	req_access = list(access_engine_equip)
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/engineering/engine_eva
	name = "Third Deck - Engineering - EVA"
	icon_state = "engine_eva"
	req_access = list(list(access_eva, access_external_airlocks), access_engine)
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/engineering/engine_monitoring
	name = "Third Deck - Engine - Monitoring"
	icon_state = "engine_monitoring"
	ambience = list(
		'maps/sierra/sound/ambience/engineering1.ogg',
		'maps/sierra/sound/ambience/engineering2.ogg',
		'maps/sierra/sound/ambience/engineering3.ogg'
	)
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/engineering/engine_smes
	name = "Third Deck - Engine - SMES"
	icon_state = "engine_smes"
	sound_env = SMALL_ENCLOSED
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/engineering/engineering_monitoring
	name = "Third Deck - Engineering - Monitoring"
	icon_state = "engine_monitoring"
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/engineering/locker_room
	name = "Third Deck - Engineering - Locker Room"
	icon_state = "engineering_locker"
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/engineering/materials_storage
	name = "Third Deck - Engineering - Materials Storage"
	icon_state = "engineering_storage"
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/engineering/atmos
	name = "Third Deck - Engineering - Atmospherics"
	icon_state = "atmos"
	ambience = list(
		'maps/sierra/sound/ambience/engineering1.ogg',
		'maps/sierra/sound/ambience/engineering2.ogg',
		'maps/sierra/sound/ambience/engineering3.ogg',
		'maps/sierra/sound/ambience/atmospherics1.ogg'
	)
	sound_env = LARGE_ENCLOSED
	req_access = list(access_atmospherics)
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/engineering/gravitaional_generator
	name = "Third Deck - Gravitational Generator"
	icon_state = "engine_monitoring"
	req_access = list(list(access_engine_equip, access_heads), list(access_seneng, access_engine_equip))
	sound_env = SMALL_ENCLOSED
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/engineering/bluespace
	name = "Third Deck - Engineering - BlueSpace Drive"
	icon_state = "engine_monitoring"
	req_access = list(list(access_engine_equip, access_heads), access_engine, access_maint_tunnels)
	sound_env = SMALL_ENCLOSED
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/engineering/bluespace/chamber
	name = "Third Deck - Engineering - BlueSpace Drive - Chamber"
	icon_state = "engine"
	sound_env = LARGE_ENCLOSED
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/engineering/fuelbay
	name = "Third Deck - Engineering - Fuel Bay"
	icon_state = "engineering"
	req_access = list(access_construction)
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/engineering/atmos/storage
	name = "Third Deck - Engineering - Atmospherics Storage"
	icon_state = "atmos_storage"
	sound_env = SMALL_ENCLOSED
	req_access = list(access_atmospherics)
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/turret_protected/ai_cyborg_station
	name = "Third Deck - Cyborg Station"
	icon_state = "ai_cyborg"
	sound_env = SMALL_ENCLOSED
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/turret_protected/ai_cyborg_upload
	name = "Third Deck - Cyborg Upload"
	icon_state = "ai_cyborg"
	sound_env = SMALL_ENCLOSED
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED
	holomap_color = HOLOMAP_AREACOLOR_COMMAND

/area/shield/thirddeck
	name = "Third Deck - Shield Generator"

// Chief Engineer

/area/crew_quarters/heads/office/ce
	icon_state = "heads_ce"
	name = "Bridge - Command - CE's Office"
	req_access = list(access_ce)
	holomap_color = HOLOMAP_AREACOLOR_COMMAND

// Tcomm
/area/tcommsat/
	ambience = list(
		'sound/ambience/ambisin2.ogg',
		'sound/ambience/signal.ogg',
		'sound/ambience/ambigen10.ogg',
		'maps/sierra/sound/ambience/aiservers.wav'
	)
	req_access = list(access_tcomsat)
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/tcommsat/chamber
	name = "Third Deck - Telecoms"
	icon_state = "tcomsatcham"

/area/tcommsat/computer
	name = "Third Deck - Telecoms - Monitoring"
	icon_state = "tcomsatcomp"

/area/tcommsat/storage
	name = "Third Deck - Telecoms - Storage"
	icon_state = "tcomsatstore"

/* RUST
 * =================
 */

/area/vacant/prototype
	req_access = list(access_engine)
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/vacant/prototype/control
	name = "\improper Prototype Fusion Reactor Control Room"
	icon_state = "engine_monitoring"

/area/vacant/prototype/engine
	name = "\improper Prototype Fusion Reactor Chamber"
	icon_state = "rust_reactor"

// Solars
/area/maintenance/solar
	name = "First Deck - Solar - Port"
	icon_state = "SolarcontrolP"
	sound_env = SMALL_ENCLOSED
	req_access = list(access_engine)
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/maintenance/solar/starboard
	name = "First Deck - Solar - Starboard"
	icon_state = "SolarcontrolS"
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/solar
	area_flags = AREA_FLAG_EXTERNAL
	requires_power = 1
	always_unpowered = 1
	has_gravity = FALSE
	base_turf = /turf/space
	sound_env = SPACE

/area/solar/starboard
	name = "Third Deck - Solar - Starboard Array"
	icon_state = "panelsS"

/area/solar/port
	name = "Third Deck - Solar - Port Array"
	icon_state = "panelsP"

// Storage
/area/storage/tech
	name = "Third Deck - Engineering - Technical Storage"
	icon_state = "storage"
	req_access = list(access_tech_storage)
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/storage/tech/high_risk
	name = "Third Deck - Engineering - High Security Storage"
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

// Hangar
/area/quartermaster/hangar/upper
	name = "Third Deck - Hangar"

/area/quartermaster/hangar_stairs/upper
	name = "Third Deck - Hangar - Stairs"

// Compactor
/area/maintenance/compactor
	name = "Third Deck - Compactor"
	icon_state = "disposal"
	sound_env = STANDARD_STATION
	req_access = list(list(access_cargo, access_maint_tunnels))

/area/maintenance/incinerator
	name = "Third Deck - Incinerator"
	icon_state = "disposal"
	req_access = list(list(access_engine, access_medical, access_cargo))

//Vacant

/area/vacant/mess
	name = "Third Deck - Old Mess"
	icon_state = "bar"
	lighting_tone = AREA_LIGHTING_WARM

/area/vacant/bar
	name = "Third Deck - Hidden Bar"
	icon_state = "bar"
	lighting_tone = AREA_LIGHTING_WARM

/* RND AREAS
 * =========
 */
/area/rnd/xenobiology/entry2
	name = "Xenobiology Access"
	icon_state = "xeno_lab"
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE

/area/rnd/xenobiology/level2
	name = "Xenobiology Level Two"
	icon_state = "xeno_lab"
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE

// EVA

/area/storage/eva
	name = "Third Deck - EVA"
	icon_state = "eva"
	req_access = list(access_eva)
