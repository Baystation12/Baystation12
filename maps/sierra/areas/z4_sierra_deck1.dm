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

/area/hallway/primary/firstdeck/aft_stairwell
	name = "First Deck - Stairwell - Fore"
	icon_state = "hallA"

/area/maintenance/substation/firstdeck
	name = "First Deck - Substation"

/* COMMAND AREAS
 * =============
 */

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

/area/command/bsa
	name = "Fourth Deck - Obstruction Field Disperser"
	icon = 'maps/sierra/icons/turf/areas.dmi'
	icon_state = "bridge_gun"
	req_access = list(access_gun)

/* ENGINEERING AREAS
 * =================
 */
/area/engineering/auxpower
	name = "First Deck - Engineering - Auxiliary Power Storage"
	icon_state = "engine_smes"
	sound_env = SMALL_ENCLOSED

// Tcomm
/area/tcommsat/
	ambience = list(
		'sound/ambience/ambisin2.ogg',
		'sound/ambience/signal.ogg',
		'sound/ambience/ambigen10.ogg',
		'maps/sierra/sound/ambience/aiservers.wav'
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

// Thusters
/area/thruster/d1port
	name = "First Deck - Nacelle - Port "

/area/thruster/d1starboard
	name = "First Deck - Nacelle - Starboard"

/area/storage/eva
	name = "First Deck - EVA"
	icon_state = "eva"
	req_access = list(access_eva)



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

/area/rnd/containment
	name = "First Deck - RND - Containment Zone"
	icon_state = "decontamination"

/area/rnd/locker
	name = "First Deck - RND - Locker Room"
	icon_state = "locker"

/area/rnd/office
	name = "First Deck - RND - Research Office"
	icon_state = "locker"

/area/rnd/servers
	name = "First Deck - RND - Servers"
	icon_state = "tcomsatcham"
	area_flags = AREA_FLAG_RAD_SHIELDED
	sound_env = SMALL_ENCLOSED
	req_access = list(access_rd)

/area/assembly
	req_access = list(access_robotics)

/area/assembly/office
	name = "First Deck - RND - Robotics Office"
	icon_state = "mechbay"



/* CREW AREAS
 * ==========
 */
/area/crew_quarters/sleep/cryo/firstdeck
	name = "First Deck - Living - Cryogenic Storage"
	icon_state = "cryo_up"

/area/crew_quarters/dungeon_master_lounge
	name = "First Deck - Living Room"
	sound_env = MEDIUM_SOFTFLOOR

/area/crew_quarters/lounge/upper
	name = "First Deck - Living - Library"

/area/crew_quarters/safe_room
	name = "First Deck - Citadel"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED

/* SECURITY AREAS
 * ==============
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

/area/security/sierra/interrogation/second

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

/area/security/opscheck
	name = "First Deck - RND - Security Checkpoint"
	icon_state = "checkpoint"

/* MEDBAY AREAS
 * ============
 */
/area/medical/equipstorage
	name = "First Deck - Infirmary - Storage"
	icon_state = "medbay4"

/area/hallway/infirmary
	name = "First Deck - Infirmary - Hallway"
	icon_state = "medbay"

/area/medical/infirmreception
	name = "First Deck - Infirmary - Reception"
	icon_state = "medbay2"

/area/medical/locker
	name = "First Deck - Infirmary - Locker Room"
	icon_state = "locker"
	req_access = list(access_medical_equip)

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

/area/medical/morgue/autopsy
	name = "First Deck - Infirmary - Autopsy"
	icon_state = "autopsy"

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

/* VACANT AREAS
 * ============
 */
/area/vacant/dormintories
	name = "First Deck - Cabin"
	icon_state = "restrooms"
	sound_env = MEDIUM_SOFTFLOOR

/area/vacant/utility
	name = "First Deck - Utility Room"
	icon_state = "restrooms"
