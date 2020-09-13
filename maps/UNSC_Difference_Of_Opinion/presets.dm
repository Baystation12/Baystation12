
//Doors!//

/obj/machinery/door/airlock/halo/maint/DoO_general
	name = "Maintenance Access"
	req_access = list(access_unsc)

/obj/machinery/door/airlock/halo/maint/DoO_odst
	name = "ODST Pods"
	req_access = list(access_unsc_odst)

/obj/machinery/door/airlock/halo/DoO_general
	req_access = list(access_unsc)

/obj/machinery/door/firedoor/unsc_DoO
	req_access = list(access_unsc)

/obj/machinery/door/airlock/halo/maint/DoO_general/escape
	name = "Escape Pod"

/obj/machinery/door/airlock/halo/DoO_general/thrusters
	name = "Thrusters"

/obj/machinery/door/airlock/halo/DoO_general/aicore
	name = "AI Core"

/obj/machinery/door/airlock/halo/DoO_general/comms
	name = "Communications Equipment"

/obj/machinery/door/airlock/halo/DoO_general/atmos
	name = "Atmospherics"

/obj/machinery/door/airlock/halo/DoO_general/hangar
	name = "Hangar"

/obj/machinery/door/airlock/halo/DoO_general/morgue
	name = "Morgue"

/obj/machinery/door/airlock/halo/DoO_general/MAC
	name = "MAC Cannon Fire Controls"

/obj/machinery/door/airlock/halo/DoO_general/brigcell
	name = "Brig Cells"

//Multi Tile//

/obj/machinery/door/airlock/multi_tile/halo/DoO_general
	req_access = list(access_unsc)

/obj/machinery/door/airlock/multi_tile/halo/DoO_general/hallway
	name = "Hallway"

/obj/machinery/door/airlock/multi_tile/halo/DoO_general/umbilical
	name = "Umbilical Access"

/obj/machinery/door/airlock/multi_tile/halo/DoO_general/storage_room
	name = "Storage Room"

/obj/machinery/door/airlock/multi_tile/halo/DoO_general/engineering
	name = "Engineering"

/obj/machinery/door/airlock/multi_tile/halo/DoO_general/armory
	name = "Armory"

/obj/machinery/door/airlock/multi_tile/halo/DoO_general/odst_armory
	name = "ODST Armory"
	req_access = list(access_unsc_odst)

/obj/machinery/door/airlock/multi_tile/halo/DoO_general/hangar
	name = "Hangar"

/obj/machinery/door/airlock/multi_tile/halo/DoO_general/briefing
	name = "Briefing"

/obj/machinery/door/airlock/multi_tile/halo/DoO_general/cryo
	name = "Cryogenics"

/obj/machinery/door/airlock/multi_tile/halo/DoO_general/gym
	name = "Gym"

/obj/machinery/door/airlock/multi_tile/halo/DoO_general/brig
	name = "Brig"

/obj/machinery/door/airlock/multi_tile/halo/DoO_general/lounge
	name = "Lounge"

/obj/machinery/door/airlock/multi_tile/halo/DoO_general/medbay
	name = "Medbay"

//MULTI TILE BLAST//

/obj/machinery/door/airlock/multi_tile/halo/blast_normal_triple/DoO_general
	req_access = list(access_unsc)

/obj/machinery/door/airlock/multi_tile/halo/blast_normal_triple/DoO_general/hangar_store
	name = "Hangar Vehicle Storage"

/obj/machinery/door/airlock/multi_tile/halo/blast_normal_triple/DoO_general/umbilical
	name = "Umbilical Access"

/obj/machinery/door/airlock/multi_tile/halo/blast_normal_triple/DoO_general/Bridge
	name = "Bridge"

//AI STUFF//

/obj/machinery/camera/autoname/invis/unscDoO
	network = "unscDoO"

/obj/structure/ai_terminal/unsc/unscDoO
	inherent_network = "unscDoO"

/obj/structure/ai_terminal/spawn_terminal/unsc/unscDoO
	inherent_network = "unscDoO"
	area_nodescan = /area/unscDoO