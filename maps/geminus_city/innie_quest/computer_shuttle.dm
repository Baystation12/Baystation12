
/obj/item/modular_computer/console/preset/innie_shuttle
	name = "Shuttle Control Computer"

/obj/item/modular_computer/console/preset/innie_shuttle/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/innie_shuttle())
	hard_drive.store_file(new/datum/computer_file/program/chatclient())
	hard_drive.store_file(new/datum/computer_file/program/nttransfer())
	hard_drive.store_file(new/datum/computer_file/program/email_client())

	//generate a fake quest file so we have coords to go home
	/*
	var/datum/computer_file/data/coord/coords = new()
	var/datum/npc_quest/fake_quest = new()
	fake_quest.location_name = "Rabbit Hole Base"
	coords.generate_data(fake_quest)
	hard_drive.store_file(coords)
	*/

	set_autorun("shuttle_control")
