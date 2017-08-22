

/////////
//AREAS//
/////////


//engineering
/area/asteroid_base/tcomms
	name = "\improper Telecommunications Server Room"
	icon_state = "tcomsatcham"

/area/asteroid_base/engine
	name = "\improper Base Power Generators"
	icon_state = "engine"

/area/asteroid_base/atmos
	name = "\improper Atmospherics Processing"
	icon_state = "atmos"

/area/asteroid_base/storage_atmos
	name = "\improper Atmospherics Storage"
	icon_state = "atmos_storage"

/area/asteroid_base/storage_eng
	name = "\improper Atmospherics Storage"
	icon_state = "engineering_storage"


//civilian
/area/asteroid_base/west_dorms
	name = "\improper Dormitories"
	icon_state = "Sleep"

/area/asteroid_base/east_dorms
	name = "\improper Dormitories"
	icon_state = "Sleep"

/area/asteroid_base/mess_hall
	name = "\improper Cafeteria"
	icon_state = "cafeteria"

/area/asteroid_base/kitchen
	name = "\improper Kitchen"
	icon_state = "kitchen"

/area/asteroid_base/medbay
	name = "\improper Medbay"
	icon_state = "medbay"

/area/asteroid_base/storage_medbay
	name = "\improper Medbay Storage"
	icon_state = "medbay2"


//misc
/area/asteroid_base/storage_primary
	name = "\improper Primary Storage"
	icon_state = "primarystorage"

/area/asteroid_base/armoury_1
	name = "\improper Armoury 1"
	icon_state = "armory"

/area/asteroid_base/armoury_2
	name = "\improper Armoury 2"
	icon_state = "armory"

/area/asteroid_base/armoury_3
	name = "\improper Armoury 3"
	icon_state = "armory"

/area/asteroid_base/armoury_4
	name = "\improper Armoury 4"
	icon_state = "armory"

/area/asteroid_base/vault
	name = "\improper Secure Storage Vault"
	icon_state = "firingrange"

/area/asteroid_base/main_hangar
	name = "\improper Main Hangar"
	icon_state = "hangar"

/area/asteroid_base/shuttle_dock
	name = "\improper Shuttle Dock"
	icon_state = "aux_hangar"


//hallways
/area/asteroid_base/central_hallway_1
	name = "\improper Main Hallway Deck 1"
	icon_state = "hallC1"


//hangars airlocks
/area/asteroid_base/north_airlock_1
	name = "\improper North Airlock Deck 1"
	icon_state = "eva"

/area/asteroid_base/south_airlock_1
	name = "\improper South Airlock Deck 1"
	icon_state = "eva"


/////////////////////
//TELECOMMS PRESETS//
/////////////////////
//todo: check for the actual define and the headets used

/*
/obj/machinery/telecomms/hub/preset_innie
	id = "Hub"
	network = "innie_base"
	autolinkers = list("hub_innie","broadcaster_innie","receiver_innie",\
	"processor_innie_private","processor_innie_public",\
	"server_innie_private","server_innie_public",\
	)

/obj/machinery/telecomms/receiver/preset_innie
	id = "Public Comms Receiver"
	network = "innie_base"
	autolinkers = list("receiver_innie")
	freq_listening = list(SYND_FREQ)

	//Common and other radio frequencies for people to freely use
	New()
		for(var/i = PUBLIC_LOW_FREQ, i < PUBLIC_HIGH_FREQ, i += 2)
			freq_listening |= i
		..()

/obj/machinery/telecomms/bus/preset_innie_private
	id = "Encrypted Comms Bus"
	network = "innie_base"
	freq_listening = list(SYND_FREQ)
	autolinkers = list("processor_innie_private","server_innie_private")

/obj/machinery/telecomms/bus/preset_innie_public
	id = "Public Comms Bus"
	network = "innie_base"
	freq_listening = list()
	autolinkers = list("processor_innie_public","server_innie_public")

/obj/machinery/telecomms/bus/preset_innie_public/New()
	for(var/i = PUBLIC_LOW_FREQ, i < PUBLIC_HIGH_FREQ, i += 2)
		freq_listening |= i
	..()

/obj/machinery/telecomms/processor/preset_innie_private
	id = "Encrypted Comms Processor"
	network = "innie_base"
	autolinkers = list("processor_innie_private")

/obj/machinery/telecomms/processor/preset_innie_public
	id = "Public Comms Processor"
	network = "innie_base"
	autolinkers = list("processor_innie_public")

/obj/machinery/telecomms/server/preset_innie_private
	id = "Encrypted Comms Server"
	network = "innie_base"
	freq_listening = list(SYND_FREQ)
	autolinkers = list("server_innie_private")

/obj/machinery/telecomms/server/preset_innie_public
	id = "Public Comms Server"
	network = "innie_base"
	freq_listening = list()
	autolinkers = list("server_innie_public")

/obj/machinery/telecomms/server/preset_innie_public/New()
	for(var/i = PUBLIC_LOW_FREQ, i < PUBLIC_HIGH_FREQ, i += 2)
		freq_listening |= i
	..()

/obj/machinery/telecomms/broadcaster/preset_innie
	id = "Broadcaster"
	network = "innie_base"
	autolinkers = list("broadcaster_innie")
*/

///////////////////
//TELECOMMS COMPS//
///////////////////

/*
/obj/machinery/computer/telecomms/traffic/innie
	network = "innie_base"
	req_access = list(access_innie_boss)

/obj/machinery/computer/telecomms/monitor/innie
	network = "innie_base"
	req_access = list(access_innie_boss)

/obj/machinery/computer/telecomms/server/innie
	network = "innie_base"
	req_access = list(access_innie)
*/

///////////////////
//RANDOM SPAWNERS//
///////////////////

/obj/effect/roundstart_innie_shuttle_spawner
	name = "Innsurrectionist random shuttle spawn"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"
	dir = SOUTH			//set this to the direction you want the shuttle to spawn in
	var/berth_tag = ""		//set this the same for all viable spawnpoints in each berth
						//if there is only 1 viable spawnpoint, leave this blank
						//eg if there were 2 separate docking hatches for berth 1 each should have a separate instance of this spawner but both have the berth_tag "berth1"

/*
var/list/shuttle_types = list(\
/obj/machinery/overmap_vehicle/shuttle,\
/obj/machinery/overmap_vehicle/shuttle/med1,\
/obj/machinery/overmap_vehicle/shuttle/per1,\
/obj/machinery/overmap_vehicle/shuttle/per2,\
/obj/machinery/overmap_vehicle/shuttle/sal1,\
/obj/machinery/overmap_vehicle/shuttle/sec1,\
)
*/

/obj/effect/roundstart_innie_shuttle_spawner/proc/spawnme()
	//due to different shuttle dimensions and layouts this code handles them individually
	//i'd like to genericize and split it into the shuttle code itself it but that feels like a QOL thing at this point
	var/spawntype
	var/turf/spawnturf

	//shuttles with airlocks on the south side all have similar enough dimensions and airlock placement that they can be treated the same
	if(dir == NORTH)
		spawntype = pick(\
		/obj/machinery/overmap_vehicle/shuttle/sal1,\
		/obj/machinery/overmap_vehicle/shuttle/sec1,\
		/obj/machinery/overmap_vehicle/shuttle/med1,\
		)

		spawnturf = locate(src.x - 6, src.y, src.z)

	//shuttles with airlocks on the east or west side require unique handling due to differing dimensions and airlock placement
	else if(dir == EAST)
		if(prob(33))
			spawntype = /obj/machinery/overmap_vehicle/shuttle
			spawnturf = locate(src.x, src.y - 5, src.z)
		else if(prob(50))
			spawntype = /obj/machinery/overmap_vehicle/shuttle/per1
			spawnturf = locate(src.x, src.y - 2, src.z)
		else
			spawntype = /obj/machinery/overmap_vehicle/shuttle/per2
			spawnturf = locate(src.x, src.y - 6, src.z)

	else if(dir == WEST)
		if(prob(33))
			spawntype = /obj/machinery/overmap_vehicle/shuttle
			spawnturf = locate(src.x - 5, src.y - 3, src.z)
		else if(prob(50))
			spawntype = /obj/machinery/overmap_vehicle/shuttle/per1
			spawnturf = locate(src.x - 5, src.y - 2, src.z)
		else
			spawntype = /obj/machinery/overmap_vehicle/shuttle/per2
			spawnturf = locate(src.x - 8, src.y - 6, src.z)

	//todo: manually rotate some shuttles if dir==SOUTH
	//

	if(spawntype && spawnturf)
		//success, so spawn the shuttle
		var/obj/machinery/overmap_vehicle/shuttle/S = new spawntype(spawnturf)

		//we want to maglock it straight away but we're at the awkward point of loading where stuff has already been initialised and wont be auto initialised again until the round starts
		//manually call initialize
		S.maglocked_at_spawn = 1
		S.initialize()

		//
		//S.init_maglock()
	else
		log_admin("Warning: spawn failed for /obj/effect/roundstart_innie_shuttle_spawner at ([src.x],[src.y],[src.z])")
	qdel(src)

///////////////
//RADIO FREQS//
///////////////
/*
14157 fighter hangar airlocks (both port and starboard)
1385 port dock personnel airlock
1386 starboard dock personnel airlock
1386 starboard dock personnel airlock
1387 aft hangar personnel airlock
1388 fore deck1 personnel airlocks (both)
1389 aft deck1 personnel airlocks (both)
*/
