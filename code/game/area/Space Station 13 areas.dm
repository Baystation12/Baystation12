/*

### This file contains a list of all the areas in your station. Format is as follows:

/area/CATEGORY/OR/DESCRIPTOR/NAME 	(you can make as many subdivisions as you want)
	name = "NICE NAME" 				(not required but makes things really nice)
	icon = "ICON FILENAME" 			(defaults to areas.dmi)
	icon_state = "NAME OF ICON" 	(defaults to "unknown" (blank))
	requires_power = 0 				(defaults to 1)
	music = "music/music.ogg"		(defaults to "music/music.ogg")

NOTE: there are two lists of areas in the end of this file: centcom and station itself. Please maintain these lists valid. --rastaf0

*/



/area
	var/fire = null
	var/atmos = 1
	var/atmosalm = 0
	var/poweralm = 1
	var/party = null
	level = null
	name = "Unknown"
	icon = 'icons/turf/areas.dmi'
	icon_state = "unknown"
	layer = 10
	mouse_opacity = 0
	invisibility = INVISIBILITY_LIGHTING
	var/lightswitch = 1

	var/eject = null

	var/debug = 0
	var/powerupdate = 10		//We give everything 10 ticks to settle out it's power usage.
	var/requires_power = 1
	var/unlimited_power = 0
	var/always_unpowered = 0	//this gets overriden to 1 for space in area/New()

	var/power_equip = 1
	var/power_light = 1
	var/power_environ = 1
	var/music = null
	var/used_equip = 0
	var/used_light = 0
	var/used_environ = 0

	var/has_gravity = 1
	var/list/apc = list()
	var/no_air = null
	var/area/master				// master area used for power calcluations
								// (original area before splitting due to sd_DAL)
	var/list/related			// the other areas of the same type as this
//	var/list/lights				// list of all lights on this area
	var/list/all_doors = list()		//Added by Strumpetplaya - Alarm Change - Contains a list of doors adjacent to this area
	var/air_doors_activated = 0
	var/list/ambience = list('sound/ambience/ambigen1.ogg','sound/ambience/ambigen3.ogg','sound/ambience/ambigen4.ogg','sound/ambience/ambigen5.ogg','sound/ambience/ambigen6.ogg','sound/ambience/ambigen7.ogg','sound/ambience/ambigen8.ogg','sound/ambience/ambigen9.ogg','sound/ambience/ambigen10.ogg','sound/ambience/ambigen11.ogg','sound/ambience/ambigen12.ogg','sound/ambience/ambigen14.ogg')

/*Adding a wizard area teleport list because motherfucking lag -- Urist*/
/*I am far too lazy to make it a proper list of areas so I'll just make it run the usual telepot routine at the start of the game*/
var/list/teleportlocs = list()

/hook/startup/proc/setupTeleportLocs()
	for(var/area/AR in world)
		if(istype(AR, /area/shuttle) || istype(AR, /area/syndicate_station) || istype(AR, /area/wizard_station)) continue
		if(teleportlocs.Find(AR.name)) continue
		var/turf/picked = pick(get_area_turfs(AR.type))
		if (picked.z == 1|| picked.z==7 || picked.z==8) // For multi-z teleports!
			teleportlocs += AR.name
			teleportlocs[AR.name] = AR

	teleportlocs = sortAssoc(teleportlocs)

	return 1

var/list/ghostteleportlocs = list()

/hook/startup/proc/setupGhostTeleportLocs()
	for(var/area/AR in world)
		if(ghostteleportlocs.Find(AR.name)) continue
		if(istype(AR, /area/turret_protected/aisat) || istype(AR, /area/derelict) || istype(AR, /area/tdome) || istype(AR, /area/shuttle/specops/centcom))
			ghostteleportlocs += AR.name
			ghostteleportlocs[AR.name] = AR
		var/turf/picked = pick(get_area_turfs(AR.type))
		if (picked.z == 1 || picked.z == 3 || picked.z == 4 || picked.z == 5)
			ghostteleportlocs += AR.name
			ghostteleportlocs[AR.name] = AR

	ghostteleportlocs = sortAssoc(ghostteleportlocs)

	return 1

/*-----------------------------------------------------------------------------*/
/area/space
	name = "Space"
	requires_power = 1
	always_unpowered = 1
	lighting_use_dynamic = 1
	power_light = 0
	power_equip = 0
	power_environ = 0
	ambience = list('sound/ambience/ambispace.ogg','sound/music/title2.ogg','sound/music/space.ogg','sound/music/main.ogg','sound/music/traitor.ogg')

/area/space/readyalert()
	return

/area/space/partyalert()
	return
/area/engine/
	ambience = list('sound/ambience/ambisin1.ogg','sound/ambience/ambisin2.ogg','sound/ambience/ambisin3.ogg','sound/ambience/ambisin4.ogg')
/area/turret_protected/

/area/arrival
	requires_power = 0

/area/arrival/start
	name = "Arrival Area"
	icon_state = "start"

/area/admin
	name = "Admin room"
	icon_state = "start"



//These are shuttle areas, they must contain two areas in a subgroup if you want to move a shuttle from one
//place to another. Look at escape shuttle for example.
//All shuttles show now be under shuttle since we have smooth-wall code.

/area/shuttle //DO NOT TURN THE lighting_use_dynamic STUFF ON FOR SHUTTLES. IT BREAKS THINGS.
	requires_power = 0
	luminosity = 1
	lighting_use_dynamic = 0

/area/shuttle/arrival
	name = "Arrival Shuttle"

/area/shuttle/arrival/pre_game
	icon_state = "shuttle2"

/area/shuttle/arrival/station
	icon_state = "shuttle"

/area/shuttle/escape
	name = "Emergency Shuttle"
	music = "music/escape.ogg"

/area/shuttle/escape/station
	name = "Emergency Shuttle Station"
	icon_state = "shuttle2"

/area/shuttle/escape/centcom
	name = "Emergency Shuttle Centcom"
	icon_state = "shuttle"

/area/shuttle/escape/transit // the area to pass through for 3 minute transit
	name = "Emergency Shuttle Transit"
	icon_state = "shuttle"

/area/shuttle/escape_pod1
	name = "Escape Pod One"
	music = "music/escape.ogg"

/area/shuttle/escape_pod1/station
	icon_state = "shuttle2"

/area/shuttle/escape_pod1/centcom
	icon_state = "shuttle"

/area/shuttle/escape_pod1/transit
	icon_state = "shuttle"

/area/shuttle/escape_pod2
	name = "Escape Pod Two"
	music = "music/escape.ogg"

/area/shuttle/escape_pod2/station
	icon_state = "shuttle2"

/area/shuttle/escape_pod2/centcom
	icon_state = "shuttle"

/area/shuttle/escape_pod2/transit
	icon_state = "shuttle"

/area/shuttle/escape_pod3
	name = "Escape Pod Three"
	music = "music/escape.ogg"

/area/shuttle/escape_pod3/station
	icon_state = "shuttle2"

/area/shuttle/escape_pod3/centcom
	icon_state = "shuttle"

/area/shuttle/escape_pod3/transit
	icon_state = "shuttle"

/area/shuttle/escape_pod5 //Pod 4 was lost to meteors
	name = "Escape Pod Five"
	music = "music/escape.ogg"

/area/shuttle/escape_pod5/station
	icon_state = "shuttle2"

/area/shuttle/escape_pod5/centcom
	icon_state = "shuttle"

/area/shuttle/escape_pod5/transit
	icon_state = "shuttle"

/area/shuttle/escape_pod_medical //Pod 4 was lost to meteors
	name = "Medical Escape Pod"
	music = "music/escape.ogg"

/area/shuttle/escape_pod_medical/station
	icon_state = "shuttle2"

/area/shuttle/escape_pod_medical/centcom
	icon_state = "shuttle"

/area/shuttle/escape_pod_medical/transit
	icon_state = "shuttle"

/area/shuttle/escape_pod_arrivals //Pod 4 was lost to meteors
	name = "Medical Escape Pod"
	music = "music/escape.ogg"

/area/shuttle/escape_pod_arrivals/station
	icon_state = "shuttle2"

/area/shuttle/escape_pod_arrivals/centcom
	icon_state = "shuttle"

/area/shuttle/escape_pod_arrivals/transit
	icon_state = "shuttle"



/area/shuttle/mining
	name = "Mining Shuttle"
	music = "music/escape.ogg"

/area/shuttle/mining/station
	icon_state = "shuttle2"

/area/shuttle/mining/outpost
	icon_state = "shuttle"

/area/shuttle/transport1/centcom
	icon_state = "shuttle"
	name = "Transport Shuttle Centcom"

/area/shuttle/transport1/station
	icon_state = "shuttle"
	name = "Transport Shuttle"

/area/shuttle/alien/base
	icon_state = "shuttle"
	name = "Alien Shuttle Base"
	requires_power = 1
	luminosity = 0
	lighting_use_dynamic = 1

/area/shuttle/alien/mine
	icon_state = "shuttle"
	name = "Alien Shuttle Mine"
	requires_power = 1
	luminosity = 0
	lighting_use_dynamic = 1

/area/shuttle/prison/
	name = "Prison Shuttle"

/area/shuttle/prison/station
	icon_state = "shuttle"

/area/shuttle/prison/prison
	icon_state = "shuttle2"

/area/shuttle/specops/centcom
	name = "Special Ops Shuttle"
	icon_state = "shuttlered"

/area/shuttle/specops/station
	name = "Special Ops Shuttle"
	icon_state = "shuttlered2"

/area/shuttle/syndicate_elite/mothership
	name = "Syndicate Elite Shuttle"
	icon_state = "shuttlered"

/area/shuttle/syndicate_elite/station
	name = "Syndicate Elite Shuttle"
	icon_state = "shuttlered2"

/area/shuttle/administration/centcom
	name = "Administration Shuttle Centcom"
	icon_state = "shuttlered"

/area/shuttle/administration/station
	name = "Administration Shuttle"
	icon_state = "shuttlered2"

/area/shuttle/thunderdome
	name = "honk"

/area/shuttle/thunderdome/grnshuttle
	name = "Thunderdome GRN Shuttle"
	icon_state = "green"

/area/shuttle/thunderdome/grnshuttle/dome
	name = "GRN Shuttle"
	icon_state = "shuttlegrn"

/area/shuttle/thunderdome/grnshuttle/station
	name = "GRN Station"
	icon_state = "shuttlegrn2"

/area/shuttle/thunderdome/redshuttle
	name = "Thunderdome RED Shuttle"
	icon_state = "red"

/area/shuttle/thunderdome/redshuttle/dome
	name = "RED Shuttle"
	icon_state = "shuttlered"

/area/shuttle/thunderdome/redshuttle/station
	name = "RED Station"
	icon_state = "shuttlered2"
// === Trying to remove these areas:

/area/shuttle/research
	name = "Research Shuttle"
	music = "music/escape.ogg"

/area/shuttle/research/station
	icon_state = "shuttle2"

/area/shuttle/research/outpost
	icon_state = "shuttle"

/area/shuttle/vox/station
	name = "Vox Skipjack"
	icon_state = "yellow"
	requires_power = 0

/area/airtunnel1/      // referenced in airtunnel.dm:759

/area/dummy/           // Referenced in engine.dm:261

/area/start            // will be unused once kurper gets his login interface patch done
	name = "start area"
	icon_state = "start"
	requires_power = 0
	luminosity = 1
	lighting_use_dynamic = 0
	has_gravity = 1

// === end remove

/area/alien
	name = "Alien base"
	icon_state = "yellow"
	requires_power = 0

// CENTCOM

/area/centcom
	name = "Centcom"
	icon_state = "centcom"
	requires_power = 0

/area/centcom/control
	name = "Centcom Control"

/area/centcom/evac
	name = "Centcom Emergency Shuttle"

/area/centcom/suppy
	name = "Centcom Supply Shuttle"

/area/centcom/ferry
	name = "Centcom Transport Shuttle"

/area/centcom/shuttle
	name = "Centcom Administration Shuttle"

/area/centcom/test
	name = "Centcom Testing Facility"

/area/centcom/living
	name = "Centcom Living Quarters"

/area/centcom/specops
	name = "Centcom Special Ops"

/area/centcom/creed
	name = "Creed's Office"

/area/centcom/holding
	name = "Holding Facility"

//SYNDICATES

/area/syndicate_mothership
	name = "Syndicate Base"
	icon_state = "syndie-ship"
	requires_power = 0
	unlimited_power = 1

/area/syndicate_mothership/control
	name = "Syndicate Control Room"
	icon_state = "syndie-control"

/area/syndicate_mothership/elite_squad
	name = "Syndicate Elite Squad"
	icon_state = "syndie-elite"

//EXTRA

/area/asteroid					// -- TLE
	name = "Asteroid"
	icon_state = "asteroid"
	requires_power = 0

/area/asteroid/cave				// -- TLE
	name = "Asteroid - Underground"
	icon_state = "cave"
	requires_power = 0

/area/asteroid/artifactroom
	name = "Asteroid - Artifact"
	icon_state = "cave"















/area/planet/clown
	name = "Clown Planet"
	icon_state = "honk"
	requires_power = 0

/area/tdome
	name = "Thunderdome"
	icon_state = "thunder"
	requires_power = 0

/area/tdome/tdome1
	name = "Thunderdome (Team 1)"
	icon_state = "green"

/area/tdome/tdome2
	name = "Thunderdome (Team 2)"
	icon_state = "yellow"

/area/tdome/tdomeadmin
	name = "Thunderdome (Admin.)"
	icon_state = "purple"

/area/tdome/tdomeobserve
	name = "Thunderdome (Observer.)"
	icon_state = "purple"

//ENEMY

//names are used
/area/syndicate_station
	name = "Syndicate Station"
	icon_state = "yellow"
	requires_power = 0
	unlimited_power = 1

/area/syndicate_station/start
	name = "Syndicate Forward Operating Base"
	icon_state = "yellow"

/area/syndicate_station/southwest
	name = "south-west of SS13"
	icon_state = "southwest"

/area/syndicate_station/northwest
	name = "north-west of SS13"
	icon_state = "northwest"

/area/syndicate_station/northeast
	name = "north-east of SS13"
	icon_state = "northeast"

/area/syndicate_station/southeast
	name = "south-east of SS13"
	icon_state = "southeast"

/area/syndicate_station/north
	name = "north of SS13"
	icon_state = "north"

/area/syndicate_station/south
	name = "south of SS13"
	icon_state = "south"

/area/syndicate_station/commssat
	name = "south of the communication satellite"
	icon_state = "south"

/area/syndicate_station/mining
	name = "north east of the mining asteroid"
	icon_state = "north"

/area/syndicate_station/transit
	name = "hyperspace"
	icon_state = "shuttle"

/area/syndicate_station/arrivals_dock
	name = "Arrivals Dock"
	icon_state = "south"

/area/wizard_station
	name = "Wizard's Den"
	icon_state = "yellow"
	requires_power = 0

/area/vox_station/transit
	name = "hyperspace"
	icon_state = "shuttle"
	requires_power = 0

/area/vox_station/southwest_solars
	name = "aft port solars"
	icon_state = "southwest"
	requires_power = 0

/area/vox_station/northwest_solars
	name = "fore port solars"
	icon_state = "northwest"
	requires_power = 0

/area/vox_station/northeast_solars
	name = "fore starboard solars"
	icon_state = "northeast"
	requires_power = 0

/area/vox_station/southeast_solars
	name = "aft starboard solars"
	icon_state = "southeast"
	requires_power = 0

/area/vox_station/mining
	name = "nearby mining asteroid"
	icon_state = "north"
	requires_power = 0

//PRISON
/area/prison
	name = "Prison Station"
	icon_state = "brig"

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

/area/prison/rec_room
	name = "Prison Rec Room"
	icon_state = "green"

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

//STATION13

/area/atmos
 	name = "Atmospherics"
 	icon_state = "atmos"

//Maintenance

/area/maintenance/aft
	name = "Aft Maintenance"
	icon_state = "amaint"

/area/maintenance/sub
	name = "Sub-Level Maintenance"
	icon_state = "amaint"

/area/maintenance/up
	name = "Upper-Level Maintenance"
	icon_state = "fmaint"

/area/maintenance/up1
	name = "Upper Sci-Med Maintenance"
	icon_state = "fmaint"

/area/maintenance/up2
	name = "Upper Bridge Maintenance"
	icon_state = "fmaint"

/area/maintenance/up3
	name = "Upper Civilian Maintenance"
	icon_state = "fmaint"

/area/maintenance/up4
	name = "Upper Security Maintenance"
	icon_state = "fmaint"

/area/maintenance/fore
	name = "Fore Maintenance"
	icon_state = "fmaint"

/area/maintenance/starboard
	name = "Starboard Maintenance"
	icon_state = "smaint"

/area/maintenance/port
	name = "Port Maintenance"
	icon_state = "pmaint"

/area/maintenance/atmos_control
	name = "Atmospherics Maintenance"
	icon_state = "fpmaint"

/area/maintenance/fpmaint
	name = "Fore Port Maintenance - 1"
	icon_state = "fpmaint"

/area/maintenance/fpmaint2
	name = "Fore Port Maintenance - 2"
	icon_state = "fpmaint"

/area/maintenance/fsmaint
	name = "Fore Starboard Maintenance - 1"
	icon_state = "fsmaint"

/area/maintenance/fsmaint2
	name = "Fore Starboard Maintenance - 2"
	icon_state = "fsmaint"

/area/maintenance/asmaint
	name = "Aft Starboard Maintenance"
	icon_state = "asmaint"

/area/maintenance/engi_shuttle
	name = "Engineering Shuttle Access"
	icon_state = "maint_e_shuttle"

/area/maintenance/engi_engine
	name = "Engine Maintenance"
	icon_state = "maint_engine"

/area/maintenance/asmaint2
	name = "Science Maintenance"
	icon_state = "asmaint"

/area/maintenance/apmaint
	name = "Cargo Maintenance"
	icon_state = "apmaint"

/area/maintenance/maintcentral
	name = "Bridge Maintenance"
	icon_state = "maintcentral"

/area/maintenance/arrivals
	name = "Arrivals Maintenance"
	icon_state = "maint_arrivals"

/area/maintenance/bar
	name = "Bar Maintenance"
	icon_state = "maint_bar"

/area/maintenance/cargo
	name = "Cargo Maintenance"
	icon_state = "maint_cargo"

/area/maintenance/disposal
	name = "Waste Disposal"
	icon_state = "disposal"

/area/maintenance/engineering
	name = "Engineering Maintenance"
	icon_state = "maint_engineering"

/area/maintenance/evahallway
	name = "EVA Maintenance"
	icon_state = "maint_eva"

/area/maintenance/dormitory
	name = "Dormitory Maintenance"
	icon_state = "maint_dormitory"

/area/maintenance/incinerator
	name = "Incinerator"
	icon_state = "disposal"

/area/maintenance/locker
	name = "Locker Room Maintenance"
	icon_state = "maint_locker"

/area/maintenance/medbay
	name = "Medbay Maintenance"
	icon_state = "maint_medbay"

/area/maintenance/research_port
	name = "Port Research Maintenance"
	icon_state = "maint_research_port"

/area/maintenance/research_starboard
	name = "Starboard Research Maintenance"
	icon_state = "maint_research_starboard"

/area/maintenance/research_shuttle
	name = "Research Shuttle Dock Maintenance"
	icon_state = "maint_research_shuttle"

/area/maintenance/security_port
	name = "Port Security Maintenance"
	icon_state = "maint_security_port"

/area/maintenance/security_starboard
	name = "Starboard Security Maintenance"
	icon_state = "maint_security_starboard"

/area/maintenance/storage
	name = "Atmospherics"
	icon_state = "green"

// SUBSTATIONS (Subtype of maint, that should let them serve as shielded area during radstorm)

/area/maintenance/substation
	name = "Substation"
	icon_state = "substation"

/area/maintenance/substation/engineering // Probably will be connected to engineering SMES room, as wires cannot be crossed properly without them sharing powernets.
	name = "Engineering Substation"

/area/maintenance/substation/medical_science // Medbay and Science. Each has it's own separated machinery, but it originates from the same room.
	name = "Medical Research Substation"

/area/maintenance/substation/civilian_east // Bar, kitchen, dorms, ...
	name = "Civilian East Substation"

/area/maintenance/substation/civilian_west // Cargo, PTS, locker room, probably arrivals, ...)
	name = "Civilian West Substation"

/area/maintenance/substation/command //
	name = "Lower Command Substation"

/area/maintenance/substation/command2 //
	name = "Upper Command Substation"

/area/maintenance/substation/security // Security, Brig, Permabrig, etc.
	name = "Security Substation"




//Hallway

/area/hallway/primary/fore
	name = "Fore Primary Hallway"
	icon_state = "hallF"

/area/hallway/primary/starboard
	name = "Starboard Primary Hallway"
	icon_state = "hallS"

/area/hallway/primary/aft
	name = "Aft Primary Hallway"
	icon_state = "hallA"

/area/hallway/primary/port
	name = "Port Primary Hallway"
	icon_state = "hallP"

/area/hallway/primary/central_one
	name = "Central Primary Hallway North"
	icon_state = "hallC1"

/area/hallway/primary/central_two
	name = "Central Primary Hallway West"
	icon_state = "hallC2"

/area/hallway/primary/central_three
	name = "Central Primary Hallway East"
	icon_state = "hallC3"

/area/hallway/primary/central_four
	name = "Central Primary Hallway South"
	icon_state = "hallC4"

/area/hallway/primary/command_one
	name = "Command Hallway North"
	icon_state = "hallC1"

/area/hallway/primary/command_two
	name = "Command Hallway West"
	icon_state = "hallC2"

/area/hallway/primary/command_three
	name = "Command Hallway East"
	icon_state = "hallC3"

/area/hallway/primary/command_four
	name = "Command Hallway South"
	icon_state = "hallC4"

/area/hallway/secondary/exit
	name = "Escape Shuttle Hallway"
	icon_state = "escape"

/area/hallway/secondary/construction
	name = "Construction Area"
	icon_state = "construction"

/area/hallway/secondary/entry
	name = "Arrival Shuttle Hallway"
	icon_state = "entry"

//Command

/area/bridge
	name = "Bridge"
	icon_state = "bridge"
	music = "signal"

/area/bridge/crewbrief
	name = "Crew Briefing Area"
	icon_state = "bridge"

/area/bridge/commandhallway
	name = "Lower Command Hallway"
	icon_state = "bridge"

/area/bridge/commandhallway2
	name = "Upper Command Hallway"
	icon_state = "bridge"

/area/bridge/bridgeoffice
	name = "Upper Command Offices"
	icon_state = "bridge"

/area/bridge/meeting_room
	name = "Heads of Staff Meeting Room"
	icon_state = "bridge"
	music = null

/area/crew_quarters/captain
	name = "Captain's Office"
	icon_state = "captain"

/area/crew_quarters/heads/hop
	name = "Head of Personnel's Office"
	icon_state = "head_quarters"

/area/crew_quarters/heads/hor
	name = "Research Director's Office"
	icon_state = "head_quarters"

/area/engine/heads/chief
	name = "Chief Engineer's Office"
	icon_state = "head_quarters"

/area/security/heads/hos
	name = "Head of Security's Office"
	icon_state = "head_quarters"

/area/medical/heads/cmo
	name = "Chief Medical Officer's Office"
	icon_state = "head_quarters"

/area/rnd/heads/rd
	name = "Research Director's Office"
	icon_state = "head_quarters"

/area/rnd/breakroom
	name = "Courtroom"
	icon_state = "courtroom"

/area/mint
	name = "Mint"
	icon_state = "green"

/area/comms
	name = "Communications Relay"
	icon_state = "tcomsatcham"

/area/rnd/server
	name = "Messaging Server Room"
	icon_state = "server"

//Crew

/area/crew_quarters
	name = "Dormitories"
	icon_state = "Sleep"

/area/crew_quarters/toilet
	name = "Dormitory Toilets"
	icon_state = "toilet"

/area/crew_quarters/sleep
	name = "Dormitories"
	icon_state = "Sleep"

/area/engine/sleep/engi
	name = "Engineering Dormitories"
	icon_state = "Sleep"

/area/engine/sleep/engi_wash
	name = "Engineering Washroom"
	icon_state = "toilet"

/area/crew_quarters/sleep/sec
	name = "Security Dormitories"
	icon_state = "Sleep"

/area/crew_quarters/sleep/bedrooms
	name = "Dormitory Bedroom"
	icon_state = "Sleep"

/area/crew_quarters/sleep/cryo
	name = "Cryogenic Storage"
	icon_state = "Sleep"

/area/crew_quarters/sleep_male
	name = "Male Dorm"
	icon_state = "Sleep"

/area/crew_quarters/sleep_male/toilet_male
	name = "Male Toilets"
	icon_state = "toilet"

/area/crew_quarters/sleep_female
	name = "Female Dorm"
	icon_state = "Sleep"

/area/crew_quarters/sleep_female/toilet_female
	name = "Female Toilets"
	icon_state = "toilet"

/area/crew_quarters/locker
	name = "Locker Room"
	icon_state = "locker"

/area/crew_quarters/locker/locker_toilet
	name = "Locker Toilets"
	icon_state = "toilet"

/area/crew_quarters/fitness
	name = "Fitness Room"
	icon_state = "fitness"

/area/crew_quarters/cafeteria
	name = "Cafeteria"
	icon_state = "cafeteria"

/area/crew_quarters/kitchen
	name = "Kitchen"
	icon_state = "kitchen"

/area/crew_quarters/bar
	name = "Bar"
	icon_state = "bar"

/area/crew_quarters/bar_upper
	name = "Bar 2nd Level"
	icon_state = "bar"

/area/crew_quarters/bar_lower
	name = "Bar basement"
	icon_state = "bar"

/area/crew_quarters/stardeck
	name = "Stardeck and Hallway"
	icon_state = "bar"

/area/crew_quarters/theatre
	name = "Theatre"
	icon_state = "Theatre"

/area/library
 	name = "Library"
 	icon_state = "library"

/area/chapel/main
	name = "Chapel"
	icon_state = "chapel"
	ambience = list('sound/ambience/ambicha1.ogg','sound/ambience/ambicha2.ogg','sound/ambience/ambicha3.ogg','sound/ambience/ambicha4.ogg','sound/music/traitor.ogg')

/area/chapel/office
	name = "Chapel Office"
	icon_state = "chapeloffice"

/area/lawoffice
	name = "Internal Affairs"
	icon_state = "law"

/area/lawoffice2
	name = "Bridge Secretary"
	icon_state = "law"






/area/holodeck
	name = "Holodeck"
	icon_state = "Holodeck"
	luminosity = 1
	lighting_use_dynamic = 0

/area/holodeck/alphadeck
	name = "Holodeck Alpha"


/area/holodeck/source_plating
	name = "Holodeck - Off"
	icon_state = "Holodeck"

/area/holodeck/source_emptycourt
	name = "Holodeck - Empty Court"

/area/holodeck/source_boxingcourt
	name = "Holodeck - Boxing Court"

/area/holodeck/source_basketball
	name = "Holodeck - Basketball Court"

/area/holodeck/source_thunderdomecourt
	name = "Holodeck - Thunderdome Court"

/area/holodeck/source_beach
	name = "Holodeck - Beach"
	icon_state = "Holodeck" // Lazy.

/area/holodeck/source_burntest
	name = "Holodeck - Atmospheric Burn Test"

/area/holodeck/source_wildlife
	name = "Holodeck - Wildlife Simulation"

/area/holodeck/source_meetinghall
	name = "Holodeck - Meeting Hall"

/area/holodeck/source_theatre
	name = "Holodeck - Theatre"

/area/holodeck/source_picnicarea
	name = "Holodeck - Picnic Area"

/area/holodeck/source_snowfield
	name = "Holodeck - Snow Field"

/area/holodeck/source_desert
	name = "Holodeck - Desert"

/area/holodeck/source_courtroom
	name = "Holodeck - Courtroom"

/area/holodeck/source_space
	name = "Holodeck - Space"




/area/centralpark
		name = "Central Park"
		icon_state = "blue2"






//Engineering

/area/engine

	drone_fabrication
		name = "Drone Fabrication"
		icon_state = "engine"

	engine_smes
		name = "Engineering SMES"
		icon_state = "engine_smes"
//		requires_power = 0//This area only covers the batteries and they deal with their own power

	engine_room
		name = "Singularity Engine"
		icon_state = "engine"

	engine_airlock
		name = "Engine Room Airlock"
		icon_state = "engine"

	engine_monitoring
		name = "Singularity Engine Monitoring Room"
		icon_state = "engine_monitoring"

	engine_waste
		name = "Engine Waste Handling"
		icon_state = "engine_waste"

	engineering_monitoring
		name = "Engineering Monitoring Room"
		icon_state = "engine_monitoring"

	atmos_monitoring
		name = "Atmospherics Monitoring Room"
		icon_state = "engine_monitoring"

	engineering
		name = "Engineering"
		icon_state = "engine_smes"

	engineering_foyer
		name = "Engineering Foyer"
		icon_state = "engine"

	break_room
		name = "Engineering Break Room"
		icon_state = "engine"

	hallway
		name = "Engineering Hallway"
		icon_state = "engine_hallway"

	engine_hallway
		name = "Engine Room Hallway"
		icon_state = "engine_hallway"

	engine_eva
		name = "Engine EVA"
		icon_state = "engine_eva"

	engine_eva_maintenance
		name = "Engine EVA Maintenance"
		icon_state = "engine_eva"

	workshop
		name = "Engineering Workshop"
		icon_state = "engine_storage"

	locker_room
		name = "Engineering Locker Room"
		icon_state = "engine_storage"


//Solars

/area/solar
	requires_power = 1
	always_unpowered = 1
	luminosity = 1
	lighting_use_dynamic = 0

	auxport
		name = "Fore Port Solar Array"
		icon_state = "panelsA"

	auxstarboard
		name = "Fore Starboard Solar Array"
		icon_state = "panelsA"

	fore
		name = "Fore Solar Array"
		icon_state = "yellow"

	aft
		name = "Aft Solar Array"
		icon_state = "aft"

	starboard
		name = "Aft Starboard Solar Array"
		icon_state = "panelsS"

	port
		name = "Aft Port Solar Array"
		icon_state = "panelsP"

/area/maintenance/auxsolarport
	name = "Fore Port Solar Maintenance"
	icon_state = "SolarcontrolP"

/area/maintenance/starboardsolar
	name = "Aft Starboard Solar Maintenance"
	icon_state = "SolarcontrolS"

/area/maintenance/portsolar
	name = "Aft Port Solar Maintenance"
	icon_state = "SolarcontrolP"

/area/maintenance/auxsolarstarboard
	name = "Fore Starboard Solar Maintenance"
	icon_state = "SolarcontrolS"

/area/maintenance/foresolar
	name = "Fore Solar Maintenance"
	icon_state = "SolarcontrolA"

/area/rnd/chargebay
	name = "Mech Bay"
	icon_state = "mechbay"

/area/rnd/showroom
	name = "Robotics Showroom"
	icon_state = "showroom"

/area/rnd/robotics
	name = "Robotics Lab"
	icon_state = "ass_line"

/area/assembly/assembly_line //Derelict Assembly Line
	name = "Assembly Line"
	icon_state = "ass_line"
	power_equip = 0
	power_light = 0
	power_environ = 0

//Teleporter

/area/teleporter
	name = "Teleporter"
	icon_state = "teleporter"
	music = "signal"

/area/gateway
	name = "Gateway"
	icon_state = "teleporter"
	music = "signal"

/area/AIsattele
	name = "AI Satellite Teleporter Room"
	icon_state = "teleporter"
	music = "signal"
	ambience = list('sound/ambience/ambimalf.ogg')

//MedBay

/area/medical/medbay
	name = "Medbay"
	icon_state = "medbay"
	music = 'sound/ambience/signal.ogg'

//Medbay is a large area, these additional areas help level out APC load.
/area/medical/medbay2
	name = "Medbay CMO Hallway"
	icon_state = "medbay2"
	music = 'sound/ambience/signal.ogg'

/area/medical/medbay3
	name = "Medbay South Hallway"
	icon_state = "medbay3"
	music = 'sound/ambience/signal.ogg'

/area/medical/guard
	name = "Medbay Guard Post"
	icon_state = "security"
	music = 'sound/ambience/signal.ogg'

/area/medical/biostorage
	name = "Secondary Storage"
	icon_state = "medbay2"
	music = 'sound/ambience/signal.ogg'

/area/medical/reception
	name = "Medbay Reception"
	icon_state = "medbay"
	music = 'sound/ambience/signal.ogg'

/area/medical/psych
	name = "Psych Room"
	icon_state = "medbay3"
	music = 'sound/ambience/signal.ogg'

/area/medical/medbreak
	name = "Break Room"
	icon_state = "medbay3"
	music = 'sound/ambience/signal.ogg'

/area/medical/patients_rooms
	name = "Patient's Rooms"
	icon_state = "patients"

/area/medical/ward
	name = "Recovery Ward"
	icon_state = "patients"

/area/medical/patient_a
	name = "Isolation A"
	icon_state = "patients"

/area/medical/patient_b
	name = "Isolation B"
	icon_state = "patients"

/area/medical/patient_c
	name = "Isolation C"
	icon_state = "patients"

/area/medical/patient_wing
	name = "Patient Wing"
	icon_state = "patients"

/area/medical/cmostore
	name = "Secure Storage"
	icon_state = "CMO"

/area/medical/robotics
	name = "Robotics"
	icon_state = "medresearch"

/area/medical/virology
	name = "Virology"
	icon_state = "virology"

/area/medical/virologyaccess
	name = "Virology Access"
	icon_state = "virology"

/area/medical/morgue
	name = "Morgue"
	icon_state = "morgue"
	ambience = list('sound/ambience/ambimo1.ogg','sound/ambience/ambimo2.ogg','sound/music/main.ogg')

/area/medical/chemistry
	name = "Chemistry"
	icon_state = "chem"

/area/medical/surgery
	name = "Operating Theatre 1"
	icon_state = "surgery"

/area/medical/surgery2
	name = "Operating Theatre 2"
	icon_state = "surgery"

/area/medical/surgeryobs
	name = "Operation Observation Room"
	icon_state = "surgery"

/area/medical/surgeryprep
	name = "Pre-Op Prep Room"
	icon_state = "surgery"

/area/medical/cryo
	name = "Cryogenics"
	icon_state = "cryo"

/area/medical/exam_room
	name = "Exam Room"
	icon_state = "exam_room"

/area/medical/genetics
	name = "Genetics Lab"
	icon_state = "genetics"

/area/medical/genetics_cloning
	name = "Cloning Lab"
	icon_state = "cloning"

/area/medical/sleeper
	name = "Emergency Treatment Centre"
	icon_state = "exam_room"

//Security

/area/security/main
	name = "Security Office"
	icon_state = "security"

/area/security/interrogation
	name = "Interrogation Room"
	icon_state = "secinterrogation"

/area/security/lobby
	name = "Security lobby"
	icon_state = "security"

/area/security/brig
	name = "Brig"
	icon_state = "brig"

/area/security/perma
	name = "PermaBrig"
	icon_state = "brig"

/area/security/permaobservation
	name = "Perma Brig Observation"
	icon_state = "brig"

/area/security/permaisolation
	name = "Perma Brig Isolation"
	icon_state = "brig"

/area/security/prison
	name = "Prison Wing"
	icon_state = "sec_prison"

/area/security/warden
	name = "Warden"
	icon_state = "Warden"

/area/security/armoury
	name = "Armory"
	icon_state = "Warden"

/area/security/detectives_office
	name = "Detective's Office"
	icon_state = "detective"

/area/security/range
	name = "Firing Range"
	icon_state = "firingrange"

/area/security/tactical
	name = "Tactical Equipment"
	icon_state = "Tactical"

/area/security/execution
	name = "Execution Room"
	icon_state = "Tactical"

/*
	New()
		..()

		spawn(10) //let objects set up first
			for(var/turf/turfToGrayscale in src)
				if(turfToGrayscale.icon)
					var/icon/newIcon = icon(turfToGrayscale.icon)
					newIcon.GrayScale()
					turfToGrayscale.icon = newIcon
				for(var/obj/objectToGrayscale in turfToGrayscale) //1 level deep, means tables, apcs, locker, etc, but not locker contents
					if(objectToGrayscale.icon)
						var/icon/newIcon = icon(objectToGrayscale.icon)
						newIcon.GrayScale()
						objectToGrayscale.icon = newIcon
*/

/area/security/nuke_storage
	name = "Vault"
	icon_state = "nuke_storage"

/area/security/checkpoint
	name = "Security Checkpoint"
	icon_state = "checkpoint1"

/area/security/checkpoint2
	name = "Security Checkpoint"
	icon_state = "security"

/area/security/checkpoint/supply
	name = "Security Post - Cargo Bay"
	icon_state = "checkpoint1"

/area/security/checkpoint/engineering
	name = "Security Post - Engineering"
	icon_state = "checkpoint1"

/area/security/checkpoint/medical
	name = "Security Post - Medbay"
	icon_state = "checkpoint1"

/area/security/checkpoint/science
	name = "Security Post - Science"
	icon_state = "checkpoint1"

/area/security/vacantoffice
	name = "Vacant Office"
	icon_state = "security"

/area/security/vacantoffice2
	name = "Blueshield's Office"
	icon_state = "security"

/area/quartermaster
	name = "Quartermasters"
	icon_state = "quart"

///////////WORK IN PROGRESS//////////

/area/quartermaster/sorting
	name = "Delivery Office"
	icon_state = "quartstorage"

////////////WORK IN PROGRESS//////////

/area/quartermaster/office
	name = "Cargo Office"
	icon_state = "quartoffice"

/area/quartermaster/storage
	name = "Cargo Bay"
	icon_state = "quartstorage"

/area/quartermaster/qm
	name = "Quartermaster's Office"
	icon_state = "quart"

/area/quartermaster/miningdock
	name = "Mining Dock"
	icon_state = "mining"

/area/quartermaster/miningstorage
	name = "Mining Storage"
	icon_state = "green"

/area/quartermaster/mechbay
	name = "Mech Bay"
	icon_state = "yellow"

/area/janitor/
	name = "Custodial Closet"
	icon_state = "janitor"

/area/hydroponics
	name = "Hydroponics"
	icon_state = "hydro"

/area/hydroponics/garden
	name = "Garden"
	icon_state = "garden"

//rnd (Research and Development
/area/rnd/research
	name = "Research and Development"
	icon_state = "research"

/area/rnd/docking
	name = "Research Dock"
	icon_state = "research_dock"

/area/rnd/lab
	name = "Research Lab"
	icon_state = "toxlab"

/area/rnd/guard
	name = "Research Guard Post"
	icon_state = "security"

/area/rnd/rdoffice
	name = "Research Director's Office"
	icon_state = "head_quarters"

/area/rnd/supermatter
	name = "Supermatter Lab"
	icon_state = "toxlab"

/area/rnd/xenobiology
	name = "Xenobiology Lab"
	icon_state = "xeno_lab"

/area/rnd/xenobiology/xenoflora_storage
	name = "Xenoflora Storage"
	icon_state = "xeno_f_store"

/area/rnd/xenobiology/xenoflora
	name = "Xenoflora Lab"
	icon_state = "xeno_f_lab"

/area/rnd/storage
	name = "Toxins Storage"
	icon_state = "toxstorage"

/area/rnd/test_area
	name = "Toxins Test Area"
	icon_state = "toxtest"

/area/rnd/mixing
	name = "Toxins Mixing Room"
	icon_state = "toxmix"

/area/rnd/misc_lab
	name = "Miscellaneous Research"
	icon_state = "toxmisc"

/area/toxins/server
	name = "Server Room"
	icon_state = "server"

//Lift

/area/lift
	name = "Lift Shaft"
	icon_state = "lift"
	requires_power = 0
	luminosity = 1

/area/lift/ground
	name = "Civlian Level"

/area/lift/upper
	name = "Command Level"

/area/lift/lower
	name = "Basement Level"


//Storage

/area/storage/tools
	name = "Auxiliary Tool Storage"
	icon_state = "storage"

/area/storage/primary
	name = "Primary Tool Storage"
	icon_state = "primarystorage"

/area/storage/autolathe
	name = "Autolathe Storage"
	icon_state = "storage"

/area/storage/art
	name = "Art Supply Storage"
	icon_state = "storage"

/area/storage/auxillary
	name = "Auxillary Storage"
	icon_state = "auxstorage"

/area/storage/eva
	name = "EVA Storage"
	icon_state = "eva"

/area/storage/secure
	name = "Secure Storage"
	icon_state = "storage"

/area/storage/emergency
	name = "Starboard Emergency Storage"
	icon_state = "emergencystorage"

/area/storage/emergency2
	name = "Port Emergency Storage"
	icon_state = "emergencystorage"

/area/storage/emergency3
	name = "Central Emergency Storage"
	icon_state = "emergencystorage"

/area/storage/tech
	name = "Technical Storage"
	icon_state = "auxstorage"

/area/storage/testroom
	requires_power = 0
	name = "Test Room"
	icon_state = "storage"

//DJSTATION

/area/djstation
	name = "Listening Post"
	icon_state = "LP"

/area/djstation/solars
	name = "Listening Post Solars"
	icon_state = "LPS"

//DERELICT

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
	name = "Derelict Arrival Centre"
	icon_state = "yellow"

/area/derelict/storage/equipment
	name = "Derelict Equipment Storage"

/area/derelict/storage/storage_access
	name = "Derelict Storage Access"

/area/derelict/storage/engine_storage
	name = "Derelict Engine Storage"
	icon_state = "green"

/area/derelict/bridge
	name = "Derelict Control Room"
	icon_state = "bridge"

/area/derelict/secret
	name = "Derelict Secret Room"
	icon_state = "library"

/area/derelict/bridge/access
	name = "Derelict Control Room Access"
	icon_state = "auxstorage"

/area/derelict/bridge/ai_upload
	name = "Derelict Computer Core"
	icon_state = "ai"

/area/derelict/solar_control
	name = "Derelict Solar Control"
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
	name = "Abandoned Ship"
	icon_state = "yellow"

/area/solar/derelict_starboard
	name = "Derelict Starboard Solar Array"
	icon_state = "panelsS"

/area/solar/derelict_aft
	name = "Derelict Aft Solar Array"
	icon_state = "aft"

/area/derelict/singularity_engine
	name = "Derelict Singularity Engine"
	icon_state = "engine"

//HALF-BUILT STATION (REPLACES DERELICT IN BAYCODE, ABOVE IS LEFT FOR DOWNSTREAM)

/area/shuttle/constructionsite
	name = "Construction Site Shuttle"
	icon_state = "yellow"

/area/shuttle/constructionsite/station
	name = "Construction Site Shuttle"

/area/shuttle/constructionsite/site
	name = "Construction Site Shuttle"

/area/constructionsite
	name = "Construction Site"
	icon_state = "storage"

/area/constructionsite/storage
	name = "Construction Site Storage Area"

/area/constructionsite/science
	name = "Construction Site Research"

/area/constructionsite/bridge
	name = "Construction Site Bridge"
	icon_state = "bridge"

/area/constructionsite/maintenance
	name = "Construction Site Maintenance"
	icon_state = "yellow"

/area/constructionsite/hallway/aft
	name = "Construction Site Aft Hallway"
	icon_state = "hallP"

/area/constructionsite/hallway/fore
	name = "Construction Site Fore Hallway"
	icon_state = "hallS"

/area/constructionsite/atmospherics
	name = "Construction Site Atmospherics"
	icon_state = "green"

/area/constructionsite/medical
	name = "Construction Site Medbay"
	icon_state = "medbay"

/area/constructionsite/ai
	name = "Construction Computer Core"
	icon_state = "ai"

/area/constructionsite/engineering
	name = "Construction Site Engine Bay"
	icon_state = "engine"

/area/solar/constructionsite
	name = "Construction Site Solars"
	icon_state = "aft"

//area/constructionsite
//	name = "Construction Site Shuttle"

//area/constructionsite
//	name = "Construction Site Shuttle"


//Construction

/area/construction
	name = "Construction Area"
	icon_state = "yellow"

/area/construction/supplyshuttle
	name = "Supply Shuttle"
	icon_state = "yellow"

/area/construction/quarters
	name = "Engineer's Quarters"
	icon_state = "yellow"

/area/construction/qmaint
	name = "Maintenance"
	icon_state = "yellow"

/area/construction/hallway
	name = "Hallway"
	icon_state = "yellow"

/area/construction/solars
	name = "Solar Panels"
	icon_state = "yellow"

/area/construction/solarscontrol
	name = "Solar Panel Control"
	icon_state = "yellow"

/area/construction/Storage
	name = "Construction Site Storage"
	icon_state = "yellow"

//AI

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
	ambience = list('sound/ambience/ambimalf.ogg')

/area/turret_protected/ai_upload_foyer
	name = "AI Upload Access"
	icon_state = "ai_foyer"
	ambience = list('sound/ambience/ambimalf.ogg')

/area/turret_protected/ai_server_room
	name = "AI Server Room"
	icon_state = "ai_server"

/area/turret_protected/ai
	name = "AI Chamber"
	icon_state = "ai_chamber"
	ambience = list('sound/ambience/ambimalf.ogg')

/area/turret_protected/ai_cyborg_station
	name = "Cyborg Station"
	icon_state = "ai_cyborg"

/area/turret_protected/aisat
	name = "AI Satellite"
	icon_state = "ai"

/area/turret_protected/aisat_interior
	name = "AI Satellite"
	icon_state = "ai"

/area/turret_protected/AIsatextFP
	name = "AI Sat Ext"
	icon_state = "storage"
	luminosity = 1
	lighting_use_dynamic = 0

/area/turret_protected/AIsatextFS
	name = "AI Sat Ext"
	icon_state = "storage"
	luminosity = 1
	lighting_use_dynamic = 0

/area/turret_protected/AIsatextAS
	name = "AI Sat Ext"
	icon_state = "storage"
	luminosity = 1
	lighting_use_dynamic = 0

/area/turret_protected/AIsatextAP
	name = "AI Sat Ext"
	icon_state = "storage"
	luminosity = 1
	lighting_use_dynamic = 0

/area/turret_protected/NewAIMain
	name = "AI Main New"
	icon_state = "storage"



//Misc



/area/wreck/ai
	name = "AI Chamber"
	icon_state = "ai"

/area/wreck/main
	name = "Wreck"
	icon_state = "storage"

/area/wreck/engineering
	name = "Power Room"
	icon_state = "engine"

/area/wreck/bridge
	name = "Bridge"
	icon_state = "bridge"

/area/generic
	name = "Unknown"
	icon_state = "storage"



// Telecommunications Satellite
/area/tcommsat/
	ambience = list('sound/ambience/ambisin2.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/ambigen10.ogg')

/area/tcommsat/entrance
	name = "Telecoms Teleporter"
	icon_state = "tcomsatentrance"

/area/tcommsat/chamber
	name = "Telecoms Central Compartment"
	icon_state = "tcomsatcham"

/area/turret_protected/tcomsat
	name = "Telecoms Satellite"
	icon_state = "tcomsatlob"
	ambience = list('sound/ambience/ambisin2.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/ambigen10.ogg')

/area/turret_protected/tcomfoyer
	name = "Telecoms Foyer"
	icon_state = "tcomsatentrance"
	ambience = list('sound/ambience/ambisin2.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/ambigen10.ogg')

/area/turret_protected/tcomwest
	name = "Telecommunications Satellite West Wing"
	icon_state = "tcomsatwest"
	ambience = list('sound/ambience/ambisin2.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/ambigen10.ogg')

/area/turret_protected/tcomeast
	name = "Telecommunications Satellite East Wing"
	icon_state = "tcomsateast"
	ambience = list('sound/ambience/ambisin2.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/signal.ogg', 'sound/ambience/ambigen10.ogg')

/area/tcommsat/computer
	name = "Telecoms Control Room"
	icon_state = "tcomsatcomp"

/area/tcommsat/lounge
	name = "Telecommunications Satellite Lounge"
	icon_state = "tcomsatlounge"



// Away Missions
/area/awaymission
	name = "Strange Location"
	icon_state = "away"

/area/awaymission/example
	name = "Strange Station"
	icon_state = "away"

/area/awaymission/wwmines
	name = "Wild West Mines"
	icon_state = "away1"
	luminosity = 1
	requires_power = 0

/area/awaymission/wwgov
	name = "Wild West Mansion"
	icon_state = "away2"
	luminosity = 1
	requires_power = 0

/area/awaymission/wwrefine
	name = "Wild West Refinery"
	icon_state = "away3"
	luminosity = 1
	requires_power = 0

/area/awaymission/wwvault
	name = "Wild West Vault"
	icon_state = "away3"
	luminosity = 0

/area/awaymission/wwvaultdoors
	name = "Wild West Vault Doors"  // this is to keep the vault area being entirely lit because of requires_power
	icon_state = "away2"
	requires_power = 0
	luminosity = 0

/area/awaymission/desert
	name = "Mars"
	icon_state = "away"

/area/awaymission/BMPship1
	name = "Aft Block"
	icon_state = "away1"

/area/awaymission/BMPship2
	name = "Midship Block"
	icon_state = "away2"

/area/awaymission/BMPship3
	name = "Fore Block"
	icon_state = "away3"

/area/awaymission/spacebattle
	name = "Space Battle"
	icon_state = "away"
	requires_power = 0

/area/awaymission/spacebattle/cruiser
	name = "Nanotrasen Cruiser"

/area/awaymission/spacebattle/syndicate1
	name = "Syndicate Assault Ship 1"

/area/awaymission/spacebattle/syndicate2
	name = "Syndicate Assault Ship 2"

/area/awaymission/spacebattle/syndicate3
	name = "Syndicate Assault Ship 3"

/area/awaymission/spacebattle/syndicate4
	name = "Syndicate War Sphere 1"

/area/awaymission/spacebattle/syndicate5
	name = "Syndicate War Sphere 2"

/area/awaymission/spacebattle/syndicate6
	name = "Syndicate War Sphere 3"

/area/awaymission/spacebattle/syndicate7
	name = "Syndicate Fighter"

/area/awaymission/spacebattle/secret
	name = "Hidden Chamber"

/area/awaymission/listeningpost
	name = "Listening Post"
	icon_state = "away"
	requires_power = 0

/area/awaymission/beach
	name = "Beach"
	icon_state = "null"
	luminosity = 1
	lighting_use_dynamic = 0
	requires_power = 0
	var/sound/mysound = null

	New()
		..()
		var/sound/S = new/sound()
		mysound = S
		S.file = 'sound/ambience/shore.ogg'
		S.repeat = 1
		S.wait = 0
		S.channel = 123
		S.volume = 100
		S.priority = 255
		S.status = SOUND_UPDATE
		process()

	Entered(atom/movable/Obj,atom/OldLoc)
		if(ismob(Obj))
			if(Obj:client)
				mysound.status = SOUND_UPDATE
				Obj << mysound
		return

	Exited(atom/movable/Obj)
		if(ismob(Obj))
			if(Obj:client)
				mysound.status = SOUND_PAUSED | SOUND_UPDATE
				Obj << mysound

	proc/process()
		set background = 1

		var/sound/S = null
		var/sound_delay = 0
		if(prob(25))
			S = sound(file=pick('sound/ambience/seag1.ogg','sound/ambience/seag2.ogg','sound/ambience/seag3.ogg'), volume=100)
			sound_delay = rand(0, 50)

		for(var/mob/living/carbon/human/H in src)
			if(H.s_tone > -55)
				H.s_tone--
				H.update_body()
			if(H.client)
				mysound.status = SOUND_UPDATE
				H << mysound
				if(S)
					spawn(sound_delay)
						H << S

		spawn(60) .()

/////////////////////////////////////////////////////////////////////
/*
 Lists of areas to be used with is_type_in_list.
 Used in gamemodes code at the moment. --rastaf0
*/

// CENTCOM
var/list/centcom_areas = list (
	/area/centcom,
	/area/shuttle/escape/centcom,
	/area/shuttle/escape_pod1/centcom,
	/area/shuttle/escape_pod2/centcom,
	/area/shuttle/escape_pod3/centcom,
	/area/shuttle/escape_pod5/centcom,
	/area/shuttle/escape_pod_medical/centcom,
	/area/shuttle/escape_pod_arrivals/centcom,
	/area/shuttle/transport1/centcom,
	/area/shuttle/administration/centcom,
	/area/shuttle/specops/centcom,
)

//SPACE STATION 13
var/list/the_station_areas = list (
	/area/shuttle/arrival,
	/area/shuttle/escape/station,
	/area/shuttle/escape_pod1/station,
	/area/shuttle/escape_pod2/station,
	/area/shuttle/escape_pod3/station,
	/area/shuttle/escape_pod5/station,
	/area/shuttle/escape_pod_medical/station,
	/area/shuttle/mining/station,
	/area/shuttle/transport1/station,
	// /area/shuttle/transport2/station,
	/area/shuttle/prison/station,
	/area/shuttle/administration/station,
	/area/shuttle/specops/station,
	/area/atmos,
	/area/maintenance,
	/area/hallway,
	/area/bridge,
	/area/crew_quarters,
	/area/holodeck,
	/area/mint,
	/area/library,
	/area/chapel,
	/area/lawoffice,
	/area/engine,
	/area/solar,
	/area/assembly,
	/area/teleporter,
	/area/medical,
	/area/security,
	/area/quartermaster,
	/area/janitor,
	/area/hydroponics,
	/area/rnd,
	/area/storage,
	/area/construction,
	/area/ai_monitored/storage/eva, //do not try to simplify to "/area/ai_monitored" --rastaf0
	/area/ai_monitored/storage/secure,
	/area/ai_monitored/storage/emergency,
	/area/turret_protected/ai_upload, //do not try to simplify to "/area/turret_protected" --rastaf0
	/area/turret_protected/ai_upload_foyer,
	/area/turret_protected/ai,
)




/area/beach
	name = "Keelin's private beach"
	icon_state = "null"
	luminosity = 1
	lighting_use_dynamic = 0
	requires_power = 0
	var/sound/mysound = null

	New()
		..()
		var/sound/S = new/sound()
		mysound = S
		S.file = 'sound/ambience/shore.ogg'
		S.repeat = 1
		S.wait = 0
		S.channel = 123
		S.volume = 100
		S.priority = 255
		S.status = SOUND_UPDATE
		process()

	Entered(atom/movable/Obj,atom/OldLoc)
		if(ismob(Obj))
			if(Obj:client)
				mysound.status = SOUND_UPDATE
				Obj << mysound
		return

	Exited(atom/movable/Obj)
		if(ismob(Obj))
			if(Obj:client)
				mysound.status = SOUND_PAUSED | SOUND_UPDATE
				Obj << mysound

	proc/process()
		set background = 1

		var/sound/S = null
		var/sound_delay = 0
		if(prob(25))
			S = sound(file=pick('sound/ambience/seag1.ogg','sound/ambience/seag2.ogg','sound/ambience/seag3.ogg'), volume=100)
			sound_delay = rand(0, 50)

		for(var/mob/living/carbon/human/H in src)
//			if(H.s_tone > -55)	//ugh...nice/novel idea but please no.
//				H.s_tone--
//				H.update_body()
			if(H.client)
				mysound.status = SOUND_UPDATE
				H << mysound
				if(S)
					spawn(sound_delay)
						H << S

		spawn(60) .()
