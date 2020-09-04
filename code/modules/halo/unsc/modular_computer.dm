
/obj/item/modular_computer/console/unsc
	icon = 'code/modules/halo/icons/machinery/modular_computer.dmi'

/obj/item/modular_computer/console/unsc/install_default_hardware()
	..()
	processor_unit = new/obj/item/weapon/computer_hardware/processor_unit(src)
	tesla_link = new/obj/item/weapon/computer_hardware/tesla_link(src)
	hard_drive = new/obj/item/weapon/computer_hardware/hard_drive(src)
	network_card = new/obj/item/weapon/computer_hardware/network_card/wired(src)

/obj/item/modular_computer/console/unsc/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/chatclient())
	hard_drive.store_file(new/datum/computer_file/program/nttransfer())
	hard_drive.store_file(new/datum/computer_file/program/email_client())
