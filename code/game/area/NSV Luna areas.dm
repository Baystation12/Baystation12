/*

### This file contains a list of all the areas in your station. Format is as follows:

/area/CATEGORY/OR/DESCRIPTOR/NAME 	(you can make as many subdivisions as you want)
	name = "NICE NAME" 				(not required but makes things really nice)
	icon = "ICON FILENAME" 			(defaults to areas.dmi)
	icon_state = "NAME OF ICON" 	(defaults to "unknown" (blank))
	requires_power = 0 				(defaults to 1)
	music = "music/music.ogg"		(defaults to "music/music.ogg")

*/



/area/engine/

/area/bengine/
	name = "Backup Engine"
	icon_state = "engine"

/area/turret_protected/

/area/arrival
	requires_power = 0

/area/arrival/start
	name = "Arrival Area"
	icon_state = "start"

/area/admin
	name = "Admin room"
	icon_state = "start"
	requires_power = 0
	luminosity = 1

/area/adminsafety
	name = "Admin safe zone"
	icon_state = "start"
	requires_power = 0
	luminosity = 1

//These are shuttle areas, they must contain two areas in a subgroup if you want to move a shuttle from one
//place to another. Look at escape shuttle for example.

/area/shuttle //DO NOT TURN THE ul_Lighting STUFF ON FOR SHUTTLES. IT BREAKS THINGS.
	requires_power = 0
	luminosity = 1

/area/shuttle/mining
	name = "Mining Shuttle"
	icon_state = "shuttle1_2"

/area/shuttle/miningsast
	name = "Mining Shuttle Asteroid"
	icon_state = "shuttle1_2"

/area/shuttle/arrival
	name = "Arrival Shuttle"

/area/shuttle/arrival/pre_game
	icon_state = "shuttle1_2"

/area/shuttle/arrival/station
	icon_state = "shuttle1_1"

/area/shuttle/escape
	name = "Escape Pod"
	music = "music/escape.ogg"

/area/shuttle/escape/transit
	icon_state = "shuttle2"

/area/shuttle/escape/transit/pod1
	name = "Escape Pod B"
	icon_state = "shuttle1_2"

/area/shuttle/escape/transit/pod2
	name = "Escape Pod A"
	icon_state = "shuttle2_2"

/area/shuttle/escape/station/pod1
	name = "Escape Pod B"
	icon_state = "shuttle1_1"

/area/shuttle/escape/station/pod2
	name = "Escape Pod A"
	icon_state = "shuttle2_1"

/area/shuttle/escape/centcom/pod1
	name = "Escape Pod B"
	icon_state = "shuttle1_3"

/area/shuttle/escape/centcom/pod2
	name = "Escape Pod A"
	icon_state = "shuttle2_3"

/area/shuttle/escape/station
	icon_state = "shuttle2"

/area/shuttle/escape/centcom
	icon_state = "shuttle"

/area/shuttle/prison/
	name = "Prison Shuttle"

/area/shuttle/prison/station
	icon_state = "shuttle1_1"

/area/shuttle/prison/prison
	icon_state = "shuttle1_2"

/area/shuttle/prison/transit
	icon_state = "shuttle1_2"

/area/shuttle/prison/holding
	icon_state = "shuttle1_1"


// === Trying to remove these areas:

/area/airtunnel1/      // referenced in airtunnel.dm:759

/area/dummy/           // Referenced in engine.dm:261

/area/start            // will be unused once kurper gets his login interface patch done
	name = "start area"
	icon_state = "start"

// === end remove

/area/prison


/area/prison/arrival_airlock
	name = "Prison Station Airlock"
	icon_state = "green"
	requires_power = 0

/area/prison/control
	name = "Prison Security Checkpoint"
	icon_state = "security"

/area/prison/crew_quarters
	name = "Prison Security Quarters"
	icon_state = "security"

/area/prison/closet
	name = "Prison Supply Closet"
	icon_state = "dk_yellow"

/area/prison/hallway/fore
	name = "Prison Fore Hallway"
	icon_state = "yellow"

/area/prison/hallway/aft
	name = "Prison Aft Hallway"
	icon_state = "yellow"

/area/prison/hallway/port
	name = "Prison Port Hallway"
	icon_state = "yellow"

/area/prison/hallway/starboard
	name = "Prison Starboard Hallway"
	icon_state = "yellow"

/area/prison/morgue
	name = "Prison Morgue"
	icon_state = "morgue"

/area/prison/medical_research
	name = "Prison Genetic Research"
	icon_state = "medresearch"

/area/prison/medical
	name = "Prison Medbay"
	icon_state = "medbay"

/area/medical/robotics
	name = "Robotics"
	icon_state = "robotics"

/area/medical/robotics/office
	name = "Roboticist's Office"
	icon_state = "roboffice"

/area/medical/cryo
	name = "Cryogenics"
	icon_state = "cryogenics"

/area/medical/intensivecare
	name = "Intensive Care Unit"
	icon_state = "intensivecare"

/area/prison/solar
	name = "Prison Solar Array"
	icon_state = "storage"
	requires_power = 0

/area/prison/podbay
	name = "Prison Podbay"
	icon_state = "dk_yellow"

/area/prison/solar_control
	name = "Prison Solar Array Control"
	icon_state = "dk_yellow"

/area/prison/solitary
	name = "Solitary Confinement"
	icon_state = "brig"

/area/prison/cell_block/A
	name = "Prison Cell Block A"
	icon_state = "brig"

/area/prison/cell_block/B
	name = "Prison Cell Block B"
	icon_state = "brig"

/area/prison/cell_block/C
	name = "Prison Cell Block C"
	icon_state = "brig"

//

/area/centcom
	name = "Centcom"
	icon_state = "purple"
	requires_power = 0


/area/atmos
 	name = "Atmospherics"
 	icon_state = "atmos"
 	music = list('sound/ambience/ambiatm1.ogg')


/area/maintenance/fpmaint1
	name = "Sub Deck Fore Port Maintenance"
	icon_state = "fpmaint"

/area/maintenance/fpmaint2
	name = "Main Deck Fore Port Maintenance"
	icon_state = "fpmaint"

/area/maintenance/fpmaint3
	name = "Engineering Deck Fore Port Maintenance"
	icon_state = "fpmaint"

/area/maintenance/fpmaint4
	name = "Bridge Deck Fore Port Maintenance"
	icon_state = "fpmaint"


/area/maintenance/fsmaint1
	name = "Sub Deck Fore Starboard Maintenance"
	icon_state = "fsmaint"

/area/maintenance/fsmaint2
	name = "Main Deck Fore Starboard Maintenance"
	icon_state = "fsmaint"

/area/maintenance/fsmaint3
	name = "Engineering Deck Fore Starboard Maintenance"
	icon_state = "fsmaint"

/area/maintenance/fsmaint4
	name = "Bridge Deck Fore Starboard Maintenance"
	icon_state = "fsmaint"


/area/maintenance/asmaint1
	name = "Sub Deck Aft Starboard Maintenance"
	icon_state = "asmaint"

/area/maintenance/asmaint2
	name = "Main Deck Aft Starboard Maintenance"
	icon_state = "asmaint"

/area/maintenance/asmaint3
	name = "Engineering Deck Aft Starboard Maintenance"
	icon_state = "asmaint"

/area/maintenance/asmaint4
	name = "Bridge Deck Aft Starboard Maintenance"
	icon_state = "asmaint"


/area/maintenance/apmaint1
	name = "Sub Deck Aft Port Maintenance"
	icon_state = "apmaint"

/area/maintenance/apmaint2
	name = "Main Deck Aft Port Maintenance"
	icon_state = "apmaint"

/area/maintenance/apmaint3
	name = "Engineering Deck Aft Port Maintenance"
	icon_state = "apmaint"

/area/maintenance/apmaint4
	name = "Bridge Deck Aft Port Maintenance"
	icon_state = "apmaint"


/area/maintenance/maintcentral1
	name = "Sub Deck Central Maintenance"
	icon_state = "maintcentral"

/area/maintenance/maintcentral2
	name = "Main Deck Central Maintenance"
	icon_state = "maintcentral"

/area/maintenance/maintcentral3
	name = "Engineering Deck Central Maintenance"
	icon_state = "maintcentral"

/area/maintenance/maintcentral4
	name = "Bridge Deck Central Maintenance"
	icon_state = "maintcentral"


/area/maintenance/fmaintcentral1
	name = "Sub Deck Fore Central Maintenance"
	icon_state = "maintcentral"

/area/maintenance/fmaintcentral2
	name = "Main Deck Fore Central Maintenance"
	icon_state = "maintcentral"

/area/maintenance/fmaintcentral3
	name = "Engineering Deck Fore Central Maintenance"
	icon_state = "maintcentral"

/area/maintenance/fmaintcentral4
	name = "Bridge Deck Fore Central Maintenance"
	icon_state = "maintcentral"


/area/maintenance/pmaintcentral1
	name = "Sub Deck Port Central Maintenance"
	icon_state = "maintcentral"

/area/maintenance/pmaintcentral2
	name = "Main Deck Port Central Maintenance"
	icon_state = "maintcentral"

/area/maintenance/pmaintcentral3
	name = "Engineering Port Central Maintenance"
	icon_state = "maintcentral"

/area/maintenance/pmaintcentral4
	name = "Bridge Deck Port Central Maintenance"
	icon_state = "maintcentral"


/area/maintenance/fore1
	name = "Sub Deck Fore Maintenance"
	icon_state = "fmaint"

/area/maintenance/fore2
	name = "Main Deck Fore Maintenance"
	icon_state = "fmaint"

/area/maintenance/fore3
	name = "Engineering Deck Fore Maintenance"
	icon_state = "fmaint"

/area/maintenance/fore4
	name = "Bridge Deck Fore Maintenance"
	icon_state = "fmaint"


/area/maintenance/starboard1
	name = "Sub Deck Starboard Maintenance"
	icon_state = "smaint"

/area/maintenance/starboard2
	name = "Main Deck Starboard Maintenance"
	icon_state = "smaint"

/area/maintenance/starboard3
	name = "Engineering Deck Starboard Maintenance"
	icon_state = "smaint"

/area/maintenance/starboard4
	name = "Bridge Deck Starboard Maintenance"
	icon_state = "smaint"


/area/maintenance/hangarequip
	name = "Hangar Equipment Room"
	icon_state = "smaint"


/area/maintenance/port1
	name = "Sub Deck Port Maintenance"
	icon_state = "pmaint"

/area/maintenance/port2
	name = "Main Deck Port Maintenance"
	icon_state = "pmaint"

/area/maintenance/port3
	name = "Engineering Deck Port Maintenance"
	icon_state = "pmaint"

/area/maintenance/port4
	name = "Bridge Deck Port Maintenance"
	icon_state = "pmaint"


/area/maintenance/aft1
	name = "Sub Deck Aft Maintenance"
	icon_state = "amaint"

/area/maintenance/aft2
	name = "Main Deck Aft Maintenance"
	icon_state = "amaint"

/area/maintenance/aft3
	name = "Engineering Deck Aft Maintenance"
	icon_state = "amaint"

/*/area/maintenance/aft4					// Moved under ai_monitored
	name = "Bridge Deck Aft Maintenance"
	icon_state = "amaint"*/


/area/maintenance/starboardsolar
	name = "Starboard Solar Maintenance"
	icon_state = "SolarcontrolS"

/area/maintenance/portsolar
	name = "Port Solar Maintenance"
	icon_state = "SolarcontrolP"


/area/maintenance/storage
	name = "Atmospherics"
	icon_state = "green"


/area/maintenance/disposal
	name = "Waste Disposal"
	icon_state = "disposal"


/area/hallway/primary/admin
	name = "Administrative Block Hallway"
	icon_state = "hallAdmin"

/area/hallway/primary/aftadmin
	name = "Administrative Block Hallway Aft"
	icon_state = "hallaftAdmin"

/area/hallway/primary/fore
	name = "Fore Primary Hallway"
	icon_state = "hallF"

/area/hallway/primary/services
	name = "Vessel Services Hallway"
	icon_state = "hallV"

/area/hallway/primary/starboard
	name = "Starboard Primary Hallway"
	icon_state = "hallS"


/area/hallway/primary/aft
	name = "Aft Primary Hallway"
	icon_state = "hallA"

/area/hallway/primary/forestarboard
	name = "Fore Starboard Primary Hallway"
	icon_state = "hallS"


/area/hallway/primary/port
	name = "Port Primary Hallway"
	icon_state = "hallP"


/area/hallway/primary/central
	name = "Central Primary Hallway"
	icon_state = "hallC"

/area/hallway/primary/aftportcentral
	name = "Central Primary Hallway"
	icon_state = "hallC"

/area/hallway/primary/aftstarboardcentral
	name = "Central Primary Hallway"
	icon_state = "hallC"

/area/hallway/primary/portcentral
	name = "Central Primary Hallway"
	icon_state = "hallC"

/area/hallway/primary/starboardcentral
	name = "Central Primary Hallway"
	icon_state = "hallC"


/area/hallway/secondary/exit
	name = "Escape Shuttle Hallway"
	icon_state = "escape"

/area/hallway/secondary/construction
	name = "Construction Area"
	icon_state = "construction"


/area/hallway/secondary/entry
	name = "Arrival Shuttle Hallway"
	icon_state = "entry"

/area/hallway/secondary/research
	name = "Research Hallway"
	icon_state = "research"

/area/shieldgen
	name = "Shield Generation"
	icon_state = "shield"
	music = 'sound/machines/hiss.ogg'


/area/bridge
	name = "Bridge"
	icon_state = "bridge"
	music = 'sound/machines/signal.ogg'


/area/crew_quarters/locker
	name = "locker Room"
	icon_state = "locker"

/area/crew_quarters/laundry
	name = "Laundry Room"
	icon_state = "laundry"

/area/crew_quarters/sleeping/
	icon_state = "bedroom"

/area/crew_quarters/sleeping/A
	name = "Dormitory A"

/area/crew_quarters/sleeping/B
	name = "Dormitory B"

/area/crew_quarters/sleeping/C
	name = "Dormitory C"

/area/crew_quarters/fitness
	name = "Fitness Room"
	icon_state = "fitness"

/area/crew_quarters/laundromat
	name = "Laundromat"
	icon_state = "fitness"

/area/crew_quarters/lounge
	name = "Crew Lounge"
	icon_state = "crewlounge"

/area/crew_quarters/captain
	name = "Captain's Quarters"
	icon_state = "captain"

/area/crew_quarters/cafeteria
	name = "Cafeteria"
	icon_state = "cafeteria"

/area/crew_quarters/theater
	name = "Theater"
	icon_state = "cafeteria"


/area/crew_quarters/kitchen
	name = "Kitchen"
	icon_state = "kitchen"


/area/crew_quarters/bar
	name= "Bar"
	icon_state = "bar"


/area/crew_quarters/hop
	name = "Head of Personnel's Quarters"
	icon_state = "head_quarters"


/area/crew_quarters/hor
	name = "Research Director's Office"
	icon_state = "head_quarters"


/area/crew_quarters/chief
	name = "Chief Engineer's Office"
	icon_state = "head_quarters"



/area/crew_quarters/courtlobby
	name = "Courtroom Lobby"
	icon_state = "courtroom"

/area/crew_quarters/courtroom
	name = "Courtroom"
	icon_state = "courtroom"


/area/engine/engine_smes
	name = "Engine SMES Room"
	icon_state = "engine"


/area/engine/engine_walls
	name = "Engine Walls"
	icon_state = "engine"

/area/engine/engine_gas_storage
	name = "Engine Storage"
	icon_state = "engine_gas_storage"


/area/engine/engine_hallway
	name = "Engine Hallway"
	icon_state = "engine_hallway"


/area/engine/engine_mon
	name = "Engine Monitoring"
	icon_state = "engine_monitoring"


/area/engine/combustion
	name = "Engine Combustion Chamber"
	icon_state = "engine"
	music = "signal"


/area/engine/engine_control
	name = "Engine Control"
	icon_state = "engine_control"
	music = list('sound/ambience/ambieng1.ogg')

/area/engine/launcher
	name = "Engine Launcher Room"
	icon_state = "engine_monitoring"


/area/AIsattele
	name = "AI Satellite Teleporter Room"
	icon_state = "teleporter"
	music = "signal"



/area/tdome
	name = "Thunderdome"
	icon_state = "medbay"
	requires_power = 1

/area/tdome


/area/tdome/tdome1
	name = "Thunderdome (Team 1)"
	icon_state = "green"

/area/tdome/tdome2
	name = "Thunderdome (Team 2)"
	icon_state = "yellow"

/area/tdome/tdomea
	name = "Thunderdome (Admin.)"
	icon_state = "purple"

/area/medical/medbay
	name = "Medbay"
	icon_state = "medbay"
	music = 'sound/machines/signal.ogg'

/area/medical/medbay/office
	name = "Medbay Office"
	icon_state = "medbayoffice"

/area/medical/medbay/waiting
	name = "Medbay Waiting Room"
	icon_state = "medbaywait"

/area/medical/medbay/surgery
	name = "Medbay Surgery Room"
	icon_state = "medbaysurg"

/area/medical/medbay/storage
	name = "Medical Storage"
	icon_state = "medbaystorage"

/area/medical/patientA
	name = "In-Patient Room A"
	icon_state = "medbaypatient"

/area/medical/patientB
	name = "In-Patient Room B"
	icon_state = "medbaypatient"

/area/medical/patientC // For the crazies
	name = "Unstable Patient Room"
	icon_state = "medbaypatient"

/area/medical/research
	name = "Medical Research"
	icon_state = "medresearch"

/area/medical/medbay_hall
	name = "Medical Hallway"
	icon_state = "medbay_hall"

/area/medical/medbay_restricted_hall
	name = "Restricted Medical Hallway"
	icon_state = "medbay_restricted_hall"

/area/anomalist
	name = "Anomaly lab"
	icon_state = "medresearch"

/area/anomalist/storage
	name = "Anomaly Storage"
	icon_state = "medresearch"

/area/medical/virology
	name = "Virology"
	icon_state = "medbay"


/area/medical/morgue
	name = "Morgue"
	icon_state = "morgue"
	music = list('sound/ambience/ambimo1.ogg','sound/ambience/ambimo2.ogg')
/area/medical/morgue/autopsy
	name = "Autopsy"
	icon_state = "morgue"
	music = list('sound/ambience/ambimo1.ogg','sound/ambience/ambimo2.ogg')


/area/security/main
	name = "Security"
	icon_state = "security"

/area/security/security_lobby
	name = "Security Lobby"
	icon_state = "security_lobby"

/area/security/security_check_lobby
	name = "Security Check Lobby"
	icon_state = "security_lobby"

/area/security/stair_lobby
	name = "Security Stair Lobby"
	icon_state = "security_lobby"

/area/security/security_hallway
	name = "Security Hallway"
	icon_state = "security_lobby"

/area/security/security_dormitory
	name = "Security Dormitory"
	icon_state = "security_lobby"

/area/security/security_range
	name = "Security Range"
	icon_state = "security_lobby"

/area/security/checkpoint
	name = "Arrivals Checkpoint"
	icon_state = "checkpoint1"


/area/security/checkpoint2
	name = "Laboratories Security Checkpoint"
	icon_state = "security"

/area/security/checkpoint3
	name = "Docking Checkpoint"
	icon_state = "security"


/area/security/brig
	name = "Brig"
	icon_state = "brig"

/area/security/questingr
	name = "Questing Room"
	icon_state = "brig"

/area/security/prison
	name = "Prison"
	icon_state = "brig"

/area/security/checkpointp
	name = "Prison Checkpoint"
	icon_state = "security"


/area/security/detectives_office
	name = "Forensic Technician's Office"
	icon_state = "detective"

/area/security/head_of_security_office
	name = "Head of Security's Office"
	icon_state = "hos"

/area/security/warden_office
	name = "Warden's Office"
	icon_state = "hos"

/area/security/officer_lounge
	name = "Security Lounge"
	icon_state = "officer_lounge"

/area/security/forensics
	name = "Forensics"
	icon_state = "forensics"

/area/security/interrogation
	name = "Interrogation Room"
	icon_state = "interrogation"

/area/solar
	requires_power = 0
	luminosity = 1


/area/solar/fore
	name = "Fore Solar Array"
	icon_state = "yellow"


/area/solar/
	name = "Mining Base Solar Array"
	icon_state = "yellow"


/area/solar/aft
	name = "Aft Solar Array"
	icon_state = "aft"


/area/solar/asteroid
	name = "Mining Base Solar Array"
	icon_state = "yellow"


/area/solar/starboard
	name = "Starboard Solar Array"
	icon_state = "panelsS"


/area/solar/port
	name = "Port Solar Array"
	icon_state = "panelsP"

/area/solar/derelict_starboard
	name = "Derelict Starboard Solar Array"
	icon_state = "panelsS"

/area/solar/derelict_aft
	name = "Derelict Aft Solar Array"
	icon_state = "aft"

/area/syndicate_station
	name = "Syndicate Station"
	icon_state = "yellow"
	requires_power = 0

/area/syndicate_station/deck1
	name = "\improper NSV Luna's first deck"
	icon_state = "southeast"

/area/syndicate_station/deck2
	name = "\improper NSV Luna's second deck"
	icon_state = "southeast"

/area/syndicate_station/deck3
	name = "\improper NSV Luna's third deck"
	icon_state = "southeast"

/area/syndicate_station/deck4
	name = "\improper NSV Luna's fourth deck"
	icon_state = "southeast"

/area/wizard_station
	name = "Wizard's Den"
	icon_state = "yellow"
	requires_power = 0

/area/quartermaster/office
	name = "Quartermaster's Office"
	icon_state = "quartoffice"


/area/quartermaster/storage
	name = "Quartermaster's Storage"
	icon_state = "quartstorage"

/area/quartermaster/miningshut
	name = "Mining Shuttle Room"
	icon_state = "quartstorage"

/area/quartermaster/quart_med
	name = "Quatermaster's Medical Storage"
	icon_state = "quart_med"

/area/quartermaster/quart_eng
	name = "Quartermaster's Engineering Storage"
	icon_state = "quart_eng"

/area/quartermaster/quart_gen
	name = "Quartermaster's General Storage"
	icon_state = "quart_gen"

/area/quartermaster/quart_sec
	name = "Quartermaster's Security Storage"
	icon_state = "quart_sec"

/area/quartermaster/quart_pub_access
	name = "Quartermaster's Public Access Hallway"
	icon_state = "quart_pub_access"

/area/quartermaster/
	name = "Quartermaster's"
	icon_state = "quart"

/area/network/
	name = "Network Centre"
	icon_state = "networkcenter"

/area/janitor/
	name = "Janitor's Closet"
	icon_state = "janitor"

/area/firefighting
	name = "Fire Station"
	icon_state = "fire"

/area/hangar
	name = "Hangar"
	icon_state = "hangar"

/area/hangar/derelict
	icon_state = "hangar"
	name = "DERELICT HANGAR OBJECT TEMPLATE"

/area/hangar/supply
	name = "Supply Shuttle Hangar"
	icon_state = "hangar"

/area/hangar/exposed
	name = "Hangar"
	icon_state = "hangar"

/area/hangar/escape
	name = "Escape Hangar"
	icon_state = "hangar"

/area/hangar/escape/crew //TODO more after I place them



/area/chemistry
	name = "Chemistry"
	icon_state = "chem"


/area/toxins/lab
	name = "Toxin Lab"
	icon_state = "toxlab"


/area/toxins/storage
	name = "Toxin Storage"
	icon_state = "toxstorage"


/area/toxins/test_area
	name = "Toxin Test Area"
	icon_state = "toxtest"


/area/chapel/main
	name = "Chapel"
	icon_state = "chapel"
	music = list('sound/ambience/ambicha1.ogg','sound/ambience/ambicha2.ogg','sound/ambience/ambicha3.ogg','sound/ambience/ambicha4.ogg')


/area/chapel/office
	name = "Counselor's Office"
	icon_state = "chapeloffice"

/area/rnd/hall
	name = "Research hallway"

/area/rnd/server
	name = "Server room"

/area/rnd/rnd
	name = "Research and Development"

/area/storage/tools
	name = "Tool Storage"
	icon_state = "storage"

/area/storage/fire
	name = "Fire Station"
	icon_state = "storage"

/area/storage/primary
	name = "Primary Tool Storage"
	icon_state = "primarystorage"

/area/storage/network
	name = "Network Equipment Storage"
	icon_state = "networkstorage"

/area/storage/autolathe
	name = "Autolathe Storage"
	icon_state = "storage"

/area/storage/electrical
	name = "Electrical Storage"
	icon_state = "elecstorage"

/area/storage/auxillary
	name = "Auxillary Storage"
	icon_state = "auxstorage"

/area/storage/eva
	name = "EVA Storage"
	icon_state = "eva"

/area/storage/library
	name = "Library"
	icon_state = "library"

/area/storage/secure
	name = "Secure Storage"
	icon_state = "storage"

/area/storage/northspare
	icon_state = "storage"
	name = "North Spare Storage"

/area/storage/southspare
	icon_state = "storage"
	name = "South Spare Storage"

/area/storage/emergency
	name = "Emergency Storage A"
	icon_state = "emergencystorage"

/area/storage/emergency2
	name = "Emergency Storage B"
	icon_state = "emergencystorage"

/area/storage/tech
	name = "Technical Storage"
	icon_state = "auxstorage"

/area/storage/testroom
	requires_power = 0
	name = "Test Room"
	icon_state = "storage"

/area/derelict
	name = "Derelict Station"
	icon_state = "storage"


/area/derelict/hallway/primary
	name = "Derelict Primary Hallway"
	icon_state = "hallP"

/area/derelict/hallway/secondary
	name = "Derelict Secondary Hallway"
	icon_state = "hallS"

/area/derelict/arrival
	name = "Arrival Centre"
	icon_state = "yellow"

/area/derelict/storage/equipment
	name = "Derelict Equipment Storage"

/area/derelict/storage/storage_access
	name = "Derelict Storage Access"

/area/derelict/storage/engine_storage
	name = "Derelict Engine Storage"
	icon_state = "green"

/area/derelict/bridge
	name = "Control Room"
	icon_state = "bridge"

/area/derelict/bridge/access
	name = "Control Room Access"
	icon_state = "auxstorage"

/area/derelict/bridge/ai_upload
	name = "Ruined Computer Core"
	icon_state = "ai"

/area/derelict/solar_control
	name = "Solar Control"
	icon_state = "engine"

/area/derelict/crew_quarters
	name = "Derelict Crew Quarters"
	icon_state = "fitness"

/area/derelict/medical
	name = "Derelict Medbay"
	icon_state = "medbay"

/area/derelict/medical/morgue
	name = "Derelict Morgue"
	icon_state = "morgue"

/area/derelict/medical/chapel
	name = "Derelict Chapel"
	icon_state = "chapel"

/area/derelict/teleporter
	name = "Derelict Teleporter"
	icon_state = "teleporter"

/area/derelict/eva
	name = "Derelict EVA Storage"
	icon_state = "eva"

/area/derelict/ship
	name = "Abandoned ship"
	icon_state = "yellow"


/area/ai_monitored/teleporter
	name = "Teleporter"
	icon_state = "teleporter"
	music = "signal"

/area/ai_monitored/maintenance/aft4
	name = "Bridge Deck Aft Maintenance"
	icon_state = "amaint"

/area/ai_monitored/storage/eva
	name = "EVA Storage"
	icon_state = "eva"

/area/ai_monitored/storage/secure
	name = "Secure Storage"
	icon_state = "storage"

/area/ai_monitored/storage/emergency
	name = "Emergency Storage"
	icon_state = "storage"


/area/turret_protected/ai_upload
	name = "AI Upload Chamber"
	icon_state = "ai_upload"
	var/obj/machinery/camera/motion/motioncamera = null

/area/turret_protected/ai_upload/New()
	..()
	// locate and store the motioncamera
	spawn (20) // spawn on a delay to let turfs/objs load
		for (var/obj/machinery/camera/motion/M in src)
			motioncamera = M
			return
	return

/area/turret_protected/ai_upload/Entered(atom/movable/O)
	..()
	if (istype(O, /mob) && motioncamera)
		motioncamera.newTarget(O)

/area/turret_protected/ai_upload/Exited(atom/movable/O)
	..()
	if (istype(O, /mob) && motioncamera)
		motioncamera.lostTarget(O)

/area/turret_protected/ai_upload_foyer
	name = "AI Upload Foyer"
	icon_state = "ai_foyer"

/area/turret_protected/ai_behind
	name = "AI Space Extension"
	icon_state = "ai_foyer"

/area/turret_protected/ai
	name = "AI Chamber"
	icon_state = "ai_chamber"

/area/turret_protected/aisat
	name = "AI Satellite"
	icon_state = "ai"

/area/turret_protected/aisat_interior
	name = "AI Satellite"
	icon_state = "ai"

/area/turret_protected/AIsatextFP
	name = "AI Sat Ext"
	icon_state = "storage"

/area/turret_protected/AIsatextFS
	name = "AI Sat Ext"
	icon_state = "storage"

/area/turret_protected/AIsatextAS
	name = "AI Sat Ext"
	icon_state = "storage"

/area/turret_protected/AIsatextAP
	name = "AI Sat Ext"
	icon_state = "storage"

/area/dockingbay/admin
	name = "Docking Bay D"
	icon_state = "ai_chamber"
	var/shuttle = ""

/area/dockingbay/main
	name = "External Airlocks"


/area/syndicateshuttle
	name = "Syndicate shuttle"
	icon_state = "ai_chamber"
/area/nanotrasenshuttle
	name = "NanoTrasen shuttle"
	icon_state = "nt_shuttle"
/area/alienshuttle
	name = "Alien shuttle"
	icon_state = "ai_chamber"

//Luna

/area/luna/
	icon = 'icons/turf/areas_luna.dmi'

/area/luna/hangar
	name = "Hangar"
	icon_state = "hangar"

/area/luna/hangar/derelict
	icon_state = "hangar"
	name = "DERELICT HANGAR OBJECT TEMPLATE"

/area/luna/hangar/supply
	name = "Supply Shuttle Hangar"
	icon_state = "hangar"

/area/luna/hangar/exposed
	name = "Hangar"
	icon_state = "hangar"

/area/luna/hangar/escape
	name = "Escape Hangar"
	icon_state = "hangar"

/area/luna/hangar/escape/crew
	name = "Escape Hangar"
	icon_state = "hangar"

/area/luna/hallway/primary/admin
	name = "Administrative Block Hallway"
	icon_state = "hallAdmin"

/area/luna/hallway/primary/aftadmin
	name = "Administrative Block Hallway Aft"
	icon_state = "hallaftAdmin"

/area/luna/hallway/primary/fore
	name = "Fore Primary Hallway"
	icon_state = "hallF"

/area/luna/hallway/primary/services
	name = "Vessel Services Hallway"
	icon_state = "hallV"

/area/luna/hallway/primary/starboard
	name = "Starboard Primary Hallway"
	icon_state = "hallS"


/area/luna/hallway/primary/aft
	name = "Aft Primary Hallway"
	icon_state = "hallA"

/area/luna/hallway/primary/forestarboard
	name = "Fore Starboard Primary Hallway"
	icon_state = "hallS"


/area/luna/hallway/primary/port
	name = "Port Primary Hallway"
	icon_state = "hallP"


/area/luna/hallway/primary/central
	name = "Central Primary Hallway"
	icon_state = "hallC"

/area/luna/hallway/primary/aftportcentral
	name = "Central Primary Hallway"
	icon_state = "hallC"

/area/luna/hallway/primary/aftstarboardcentral
	name = "Central Primary Hallway"
	icon_state = "hallC"

/area/luna/hallway/primary/portcentral
	name = "Central Primary Hallway"
	icon_state = "hallC"

/area/luna/hallway/primary/starboardcentral
	name = "Central Primary Hallway"
	icon_state = "hallC"


/area/luna/hallway/secondary/exit
	name = "Escape Shuttle Hallway"
	icon_state = "escape"

/area/luna/hallway/secondary/construction
	name = "Construction Area"
	icon_state = "construction"


/area/luna/hallway/secondary/entry
	name = "Arrival Shuttle Hallway"
	icon_state = "entry"

/area/luna/hallway/secondary/research
	name = "Research Hallway"
	icon_state = "research"

//Luna Maint

/area/luna/maintenance/fpmaint1
	name = "Sub Deck Fore Port Maintenance"
	icon_state = "fpmaint"

/area/luna/maintenance/fpmaint2
	name = "Main Deck Fore Port Maintenance"
	icon_state = "fpmaint"

/area/luna/maintenance/fpmaint3
	name = "Engineering Deck Fore Port Maintenance"
	icon_state = "fpmaint"

/area/luna/maintenance/fpmaint4
	name = "Bridge Deck Fore Port Maintenance"
	icon_state = "fpmaint"


/area/luna/maintenance/fsmaint1
	name = "Sub Deck Fore Starboard Maintenance"
	icon_state = "fsmaint"

/area/luna/maintenance/fsmaint2
	name = "Main Deck Fore Starboard Maintenance"
	icon_state = "fsmaint"

/area/luna/maintenance/fsmaint3
	name = "Engineering Deck Fore Starboard Maintenance"
	icon_state = "fsmaint"

/area/luna/maintenance/fsmaint4
	name = "Bridge Deck Fore Starboard Maintenance"
	icon_state = "fsmaint"


/area/luna/maintenance/asmaint1
	name = "Sub Deck Aft Starboard Maintenance"
	icon_state = "asmaint"

/area/luna/maintenance/asmaint2
	name = "Main Deck Aft Starboard Maintenance"
	icon_state = "asmaint"

/area/luna/maintenance/asmaint3
	name = "Engineering Deck Aft Starboard Maintenance"
	icon_state = "asmaint"

/area/luna/maintenance/asmaint4
	name = "Bridge Deck Aft Starboard Maintenance"
	icon_state = "asmaint"


/area/luna/maintenance/apmaint1
	name = "Sub Deck Aft Port Maintenance"
	icon_state = "apmaint"

/area/luna/maintenance/apmaint2
	name = "Main Deck Aft Port Maintenance"
	icon_state = "apmaint"

/area/luna/maintenance/apmaint3
	name = "Engineering Deck Aft Port Maintenance"
	icon_state = "apmaint"

/area/luna/maintenance/apmaint4
	name = "Bridge Deck Aft Port Maintenance"
	icon_state = "apmaint"


/area/maintenance/aft4
	name = "Bridge Deck Aft Maintenance"
	icon_state = "amaint"

/area/luna/maintenance/maintcentral1
	name = "Sub Deck Central Maintenance"
	icon_state = "maintcentral"

/area/luna/maintenance/maintcentral2
	name = "Main Deck Central Maintenance"
	icon_state = "maintcentral"

/area/luna/maintenance/maintcentral3
	name = "Engineering Deck Central Maintenance"
	icon_state = "maintcentral"

/area/luna/maintenance/maintcentral4
	name = "Bridge Deck Central Maintenance"
	icon_state = "maintcentral"


/area/luna/maintenance/fmaintcentral1
	name = "Sub Deck Fore Central Maintenance"
	icon_state = "maintcentral"

/area/luna/maintenance/fmaintcentral2
	name = "Main Deck Fore Central Maintenance"
	icon_state = "maintcentral"

/area/luna/maintenance/fmaintcentral3
	name = "Engineering Deck Fore Central Maintenance"
	icon_state = "maintcentral"

/area/luna/maintenance/fmaintcentral4
	name = "Bridge Deck Fore Central Maintenance"
	icon_state = "maintcentral"


/area/luna/maintenance/pmaintcentral1
	name = "Sub Deck Port Central Maintenance"
	icon_state = "maintcentral"

/area/luna/maintenance/pmaintcentral2
	name = "Main Deck Port Central Maintenance"
	icon_state = "maintcentral"

/area/luna/maintenance/pmaintcentral3
	name = "Engineering Port Central Maintenance"
	icon_state = "maintcentral"

/area/luna/maintenance/pmaintcentral4
	name = "Bridge Deck Port Central Maintenance"
	icon_state = "maintcentral"


/area/luna/maintenance/fore1
	name = "Sub Deck Fore Maintenance"
	icon_state = "fmaint"

/area/luna/maintenance/fore2
	name = "Main Deck Fore Maintenance"
	icon_state = "fmaint"

/area/luna/maintenance/fore3
	name = "Engineering Deck Fore Maintenance"
	icon_state = "fmaint"

/area/luna/maintenance/fore4
	name = "Bridge Deck Fore Maintenance"
	icon_state = "fmaint"


/area/luna/maintenance/starboard1
	name = "Sub Deck Starboard Maintenance"
	icon_state = "smaint"

/area/luna/maintenance/starboard2
	name = "Main Deck Starboard Maintenance"
	icon_state = "smaint"

/area/luna/maintenance/starboard3
	name = "Engineering Deck Starboard Maintenance"
	icon_state = "smaint"

/area/luna/maintenance/starboard4
	name = "Bridge Deck Starboard Maintenance"
	icon_state = "smaint"


/area/luna/maintenance/hangarequip
	name = "Hangar Equipment Room"
	icon_state = "smaint"


/area/luna/maintenance/port1
	name = "Sub Deck Port Maintenance"
	icon_state = "pmaint"

/area/luna/maintenance/port2
	name = "Main Deck Port Maintenance"
	icon_state = "pmaint"

/area/luna/maintenance/port3
	name = "Engineering Deck Port Maintenance"
	icon_state = "pmaint"

/area/luna/maintenance/port4
	name = "Bridge Deck Port Maintenance"
	icon_state = "pmaint"


/area/luna/maintenance/aft1
	name = "Sub Deck Aft Maintenance"
	icon_state = "amaint"

/area/luna/maintenance/aft2
	name = "Main Deck Aft Maintenance"
	icon_state = "amaint"

/area/luna/maintenance/aft3
	name = "Engineering Deck Aft Maintenance"
	icon_state = "amaint"

/*/area/luna/maintenance/aft4					// Moved under ai_monitored
	name = "Bridge Deck Aft Maintenance"
	icon_state = "amaint"*/


/area/luna/maintenance/starboardsolar
	name = "Starboard Solar Maintenance"
	icon_state = "SolarcontrolS"

/area/luna/maintenance/portsolar
	name = "Port Solar Maintenance"
	icon_state = "SolarcontrolP"


/area/luna/maintenance/storage
	name = "Atmospherics"
	icon_state = "green"


/area/luna/maintenance/disposal
	name = "Waste Disposal"
	icon_state = "disposal"
