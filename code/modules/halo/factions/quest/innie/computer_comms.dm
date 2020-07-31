
/obj/item/modular_computer/console/preset/innie_comms
	name = "Rabbit Hole Base Comms Computer"

/obj/item/modular_computer/console/preset/innie_comms/install_default_hardware()
	..()
	nano_printer = new/obj/item/weapon/computer_hardware/nano_printer(src)
	portable_drive = new/obj/item/weapon/computer_hardware/hard_drive/portable/(src)

/obj/item/modular_computer/console/preset/innie_comms/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/innie_comms())
	hard_drive.store_file(new/datum/computer_file/program/chatclient())
	hard_drive.store_file(new/datum/computer_file/program/nttransfer())
	hard_drive.store_file(new/datum/computer_file/program/email_client())

	set_autorun("base_comms")
/*
/obj/item/modular_computer/console/preset/innie_comms/Initialize()
	. = ..()

	for(var/datum/faction/F in GLOB.innie_factions)

		//add our pregenerated file
		hard_drive.store_file(F.faction_contact_data)
		*/
