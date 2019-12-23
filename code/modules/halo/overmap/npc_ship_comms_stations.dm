/obj/effect/overmap/ship/npc_ship/comms_station
	name = "Communications Jamming Station"
	desc = "\
Jams communications across the sector.\
Boarding one of these allows you to obtain an override token."
	anchored = 1
	ship_datums = list(/datum/npc_ship/comms_outpost)
	ship_name_list = list("Communications Jamming Station")

/obj/effect/overmap/ship/npc_ship/comms_station/can_board()
	return 1

/obj/effect/overmap/ship/npc_ship/comms_station/pick_target_loc()
	return loc

/obj/effect/overmap/ship/npc_ship/comms_station/take_projectiles()
	return

/datum/npc_ship/comms_outpost
	mapfile_links = list('maps/npc_ships/comms_station.dmm')
