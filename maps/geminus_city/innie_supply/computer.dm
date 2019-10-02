
/obj/item/modular_computer/console/preset/innie_supply
	name = "Rabbit Hole Base Supply Computer"

/obj/item/modular_computer/console/preset/innie_supply/install_default_hardware()
	..()
	nano_printer = new/obj/item/weapon/computer_hardware/nano_printer(src)

/obj/item/modular_computer/console/preset/innie_supply/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/innie_supply())
	hard_drive.store_file(new/datum/computer_file/program/chatclient())
	hard_drive.store_file(new/datum/computer_file/program/nttransfer())
	hard_drive.store_file(new/datum/computer_file/program/email_client())

	set_autorun("base_supply")