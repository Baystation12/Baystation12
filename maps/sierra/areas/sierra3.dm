/area/maintenance/exterior
	name = "Exterior Reinforcements"
	icon_state = "maint_security_starboard"
	area_flags = AREA_FLAG_EXTERNAL
	has_gravity = FALSE
	turf_initializer = /singleton/turf_initializer/maintenance/space
	sound_env = SPACE

/area/maintenance/firstdeck
	name = "First Deck - Maintenance"
	icon_state = "maintcentral"

/area/maintenance/firstdeck/aftstarboard
	name = "First Deck - Maintenance - Aft-Starboard"
	icon_state = "asmaint"

/area/maintenance/firstdeck/aftport
	name = "First Deck - Maintenance - Aft-Port"
	icon_state = "apmaint"

/area/maintenance/firstdeck/forestarboard
	name = "First Deck - Maintenance - Fore-Starboard"
	icon_state = "fsmaint"
/*
/area/maintenance/firstdeck/fore
	name = "First Deck - Maintenance - Fore"
	icon_state = "fmaint"
*/
/area/maintenance/firstdeck/foreport
	name = "First Deck - Maintenance - Fore-Port"
	icon_state = "fpmaint"

/area/maintenance/firstdeck/centralstarboard
	name = "First Deck - Maintenance - Starboard"
	icon_state = "smaint"

/area/maintenance/firstdeck/centralport
	name = "First Deck - Maintenance - Port"
	icon_state = "pmaint"

/area/hallway/primary/firstdeck/fore
	name = "First Deck - Hallway - Fore"
	icon_state = "hallF"

/area/hallway/primary/firstdeck/center
	name = "First Deck - Hallway - Central"
	icon_state = "hallC1"

/area/hallway/primary/firstdeck/aft
	name = "First Deck - Hallway - Aft"
	icon_state = "hallA"

/area/hallway/primary/firstdeck/central_stairwell
	name = "First Deck - Stairwell - Central"
	icon_state = "hallC2"

/area/hallway/primary/firstdeck/fore_stairwell
	name = "First Deck - Stairwell - Fore"
	icon_state = "hallC2"
/*
/area/crew_quarters/safe_room/firstdeck
	name = "First Deck - Safe Room"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED
*/
/area/maintenance/substation/firstdeck
	name = "First Deck - Substation"

/* COMMAND AREAS
 * =============
 */

/area/crew_quarters/heads/office/hop
	name = "First Deck - Command - HoP's Office"
	icon_state = "heads_hop"
	req_access = list(access_hop)

/area/crew_quarters/heads/office/hop/cobed
	name = "First Deck - Command - HoP's Quarters"

/area/crew_quarters/heads/office/rd
	icon_state = "heads_rd"
	name = "First Deck - Command - RD's Office"
	req_access = list(access_rd)

/area/crew_quarters/heads/office/cmo
	icon_state = "heads_cmo"
	name = "First Deck - Command - CMO's Office"
	req_access = list(access_cmo)

/area/crew_quarters/heads/office/hos
	icon_state = "heads_hos"
	name = "First Deck - Command - HoS' Office"
	req_access = list(access_hos)

/area/crew_quarters/heads/office/iaa
	icon_state = "heads_cl"
	name = "First Deck - Command - IAA's Office"
	req_access = list(access_iaa)

/area/bridge/adjutants
	name = "First Deck - Adjutants Room"
	icon = 'packs/infinity/icons/turf/areas.dmi'
	icon_state = "bridge_gun"

/* ENGINEERING AREAS
 * =================
 */

/area/engineering/auxpower
	name = "First Deck - Engineering - Auxiliary Power Storage"
	icon_state = "engine_smes"
	sound_env = SMALL_ENCLOSED

/area/engineering/drone_fabrication
	name = "First Deck - Engineering - Drone Fabrication"
	icon_state = "drone_fab"
	sound_env = SMALL_ENCLOSED
	req_access = list(access_ai_upload)

	// Solars
/area/maintenance/solar
	name = "First Deck - Solar - Port"
	icon_state = "SolarcontrolP"
	sound_env = SMALL_ENCLOSED
	req_access = list(access_engine)

/area/maintenance/solar/starboard
	name = "First Deck - Solar - Starboard"
	icon_state = "SolarcontrolS"

/area/solar
	area_flags = AREA_FLAG_EXTERNAL
	requires_power = 1
	always_unpowered = 1
	has_gravity = FALSE
	base_turf = /turf/space
	sound_env = SPACE

/area/solar/starboard
	name = "First Deck - Solar - Starboard Array"
	icon_state = "panelsS"

/area/solar/port
	name = "First Deck - Solar - Port Array"
	icon_state = "panelsP"

	// Storage
/area/storage/bridge
	name = "First Deck - Bridge - Storage"
	icon_state = "bridge"
	sound_env = SMALL_ENCLOSED
	req_access = list(access_bridge)

	// Tcomm
/area/tcommsat/
	ambience = list(
			'sound/ambience/ambisin2.ogg',
			'sound/ambience/signal.ogg',
			'sound/ambience/ambigen10.ogg',
			'sound/ambience/ai/ambservers.wav'
		)
	req_access = list(access_tcomsat)

/area/tcommsat/chamber
	name = "First Deck - Telecoms"
	icon_state = "tcomsatcham"

/area/tcommsat/computer
	name = "First Deck - Telecoms - Monitoring"
	icon_state = "tcomsatcomp"

/area/tcommsat/storage
	name = "First Deck - Telecoms - Storage"
	icon_state = "tcomsatstore"

	//thusters

/area/thruster/d1port
	name = "First Deck - Nacelle - Port "

/area/thruster/d1starboard
	name = "First Deck - Nacelle - Starboard"

// AI
/*
/area/maintenance/battle_data_servers
	name = "First Deck - Battle Data Servers"
	req_access = list(access_maint_tunnels)

/area/ai_monitored
	name = "AI Monitored Area"
*/
/area/storage/eva
	name = "First Deck - EVA"
	icon_state = "eva"
	req_access = list(access_eva)

/area/turret_protected
	req_access = list(access_ai_upload)
	ambience = list(\
		'sound/ambience/ai/ambimalf.ogg',\
		'sound/ambience/ai/ambservers.wav',\
		'packs/infinity/sound/ambience/ai_port_hum.ogg',\
		'sound/ambience/ai/ai2.ogg',\
		'sound/ambience/ai/ai3.ogg'\
		)
	forced_ambience = list('sound/ambience/ai/ambxerxes_looped.wav')

/area/turret_protected/ai
	name = "AI Chamber"
	icon_state = "ai_chamber"

/area/turret_protected/ai_upload
	name = "First Deck - AI Upload"
	icon_state = "ai_upload"


/* RND AREAS
 * =========
 */

/area/rnd/misc_lab
	name = "First Deck - RND - Miscellaneous Lab"
	icon_state = "misclab"
	req_access = list(access_research)

/area/rnd/research
	name = "First Deck - RND - Research Lab"
	icon_state = "research"
	req_access = list(access_research)

/area/rnd/storage
	name = "First Deck - RND - Storage"
	icon_state = "toxstorage"
	req_access = list(access_tox_storage)

/area/rnd/development
	name = "First Deck - RND - Fabricator Lab"
	icon_state = "devlab"
	req_access = list(access_tox)

/area/rnd/entry
	name = "First Deck - RND - Lobby"
	icon_state = "decontamination"

/area/rnd/locker
	name = "First Deck - RND - Locker Room"
	icon_state = "locker"

/area/rnd/servers
	name = "First Deck - RND - Servers"
	icon_state = "tcomsatcham"
	area_flags = AREA_FLAG_RAD_SHIELDED
	sound_env = SMALL_ENCLOSED
	req_access = list(access_rd)

/area/assembly
	req_access = list(access_robotics)

/area/assembly/chargebay
	name = "First Deck - RND - Mech Bay"
	icon_state = "mechbay"

/area/assembly/robotics
	name = "First Deck - RND - Robotics Lab"
	icon_state = "robotics"

/* not found on Sierra
/area/assembly/robotics_surgery
	name = "Robotics Operating Theatre"
	icon_state = "robotics"
*/

/* CREW AREAS
 * ==========
 */
/area/crew_quarters/sleep/cryo/upper
	name = "First Deck - Living - Cryogenic Storage - Upper"
	icon_state = "cryo_up"

/area/crew_quarters/unused_office
	name = "First Deck - Living - Unused Office"
	icon_state = "Sleep"

/area/crew_quarters/dungeon_master_lounge
	name = "First Deck - Living Room"
	sound_env = MEDIUM_SOFTFLOOR

/area/crew_quarters/lounge/upper
	name = "First Deck - Living - Library"
/*
/area/crew_quarters/sleep/cryo/first_deck
	name = "First Deck - Cryogenic Storage"
*/
/* SECURITY AREAS
 *
 */

/area/security/sierra/hallway
	name = "First Deck - Security - Hallway - Fore"
	sound_env = LARGE_ENCLOSED

/area/security/sierra/hallway/aft
	name = "First Deck - Security - Hallway - Aft"

/area/security/sierra/hallway/port
	name = "First Deck - Security - Hallway - Port"

/area/security/sierra/sergeant
	name = "First Deck - Security - Warden"
	icon_state = "Warden"
	req_access = list(access_warden)

/area/security/sierra/armory
	name = "First Deck - Security - Armory"
	icon_state = "armory"
	req_access = list(access_armory)

/area/security/sierra/armory/lobby
	name = "First Deck - Security - Armory Lobby"

/area/security/sierra/suits
	name = "First Deck - Security - Suits Storage"
	req_access = list(access_seceva)

/area/security/sierra/breakroom
	name = "First Deck - Security - Break Room"

/area/security/sierra/hosbed
	name = "First Deck - Security - HOS Bedroom"
	icon_state = "sec_hos"
	req_access = list(access_hos)

/area/security/sierra/forensic
	name = "First Deck - Security - Forensic"
	icon_state = "detective"
	req_access = list(access_forensics_lockers)

/area/security/sierra/forensic/lab
	name = "First Deck - Security - Forensic Laboratory"

/area/security/sierra/equipment
	name = "First Deck - Security - Equipment"
	req_access = list(access_security)

/area/security/sierra/interrogation
	name = "First Deck - Security - Interrogation"
	icon_state = "detective"
	req_access = list(list(access_forensics_lockers, access_security))

/area/security/sierra/evidence
	name = "First Deck - Security - Evidence Storage"
	icon_state = "detective"
	req_access = list(list(access_forensics_lockers, access_security))

/area/security/range
	name = "First Deck - Security - Cadets"
	icon_state = "security"

/area/security/nuke_storage
	name = "First Deck - Vault"
	icon_state = "nuke_storage"
	req_access = list(access_heads_vault)

/* MEDBAY AREAS
 * ============
 */

/area/medical/equipstorage
	name = "First Deck - Infirmary - Storage"
	icon_state = "medbay4"

/area/hallway/infirmary
	name = "First Deck - Infirmary - Hallway"
	icon_state = "medbay"
/*
/area/medical/starboard_hallway
	name = "First Deck - Infirmary - Hallway - Starboard"
	icon_state = "medbay2"
*/
/area/medical/infirmreception
	name = "First Deck - Infirmary - Reception"
	icon_state = "medbay2"

/area/medical/locker
	name = "First Deck - Infirmary - Locker Room"
	icon_state = "locker"
	req_access = list(access_medical_equip)
/*
/area/medical/subacute
	name = "First Deck - Infirmary - Sub-Acute Ward"
	icon_state = "patients"
*/
/area/medical/mentalhealth
	name = "First Deck - Infirmary - Mental Health"
	icon_state = "medbay3"
	ambience = list('sound/ambience/signal.ogg')
	req_access = list(access_psychiatrist)

/area/medical/mentalhealth/therapyroom
	name = "First Deck - Infirmary - Therapy Room"
	icon_state = "medbay3"
	ambience = list('sound/ambience/signal.ogg')
	req_access = list(access_psychiatrist)

/area/medical/chemistry
	name = "First Deck - Infirmary - Chemistry"
	icon_state = "chem"
	req_access = list(access_chemistry)

/area/medical/morgue
	name = "First Deck - Infirmary - Morgue"
	icon_state = "morgue"
	ambience = list(
		'sound/ambience/ambimo1.ogg',
		'sound/ambience/ambimo2.ogg',
		'sound/music/main.ogg'
	)
	req_access = list(access_morgue)

/area/medical/sleeper
	name = "First Deck - Infirmary - Emergency Treatment Center"
	icon_state = "exam_room"
	req_access = list(list(access_medical_equip, access_field_med))

/area/medical/surgery
	name = "First Deck - Infirmary - Operating Theatre"
	icon_state = "surgery"
	req_access = list(access_surgery)

/area/medical/surgery/second
	name = "First Deck - Infirmary - Operating Theatre 2"

/area/medical/staging
	name = "First Deck - Infirmary Staging"
	icon_state = "patients"
	req_access = list(list(access_medical, access_research))

/area/medical/office
	name = "First Deck - Infirmary - Office"
	icon_state = "medbay4"

/area/medical/backstorage
	name = "First Deck - Infirmary - Auxiliary Storage"
	icon_state = "auxstorage"
