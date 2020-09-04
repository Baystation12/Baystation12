
/obj/item/modular_computer/console/covenant
	icon = 'code/modules/halo/covenant/structures_machines/consoles.dmi'
	icon_state = "covie_console_off"
	icon_state_unpowered = "covie_console_off"
	icon_state_screensaver = "covie_console_overlay_on"
	icon_state_menu = "covie_console_overlay"

/obj/item/modular_computer/console/covenant/install_default_hardware()
	..()
	processor_unit = new/obj/item/weapon/computer_hardware/processor_unit(src)
	tesla_link = new/obj/item/weapon/computer_hardware/tesla_link(src)
	hard_drive = new/obj/item/weapon/computer_hardware/hard_drive(src)
	network_card = new/obj/item/weapon/computer_hardware/network_card/wired(src)

/obj/item/modular_computer/console/covenant/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/chatclient())
	//hard_drive.store_file(new/datum/computer_file/program/nttransfer())
	//hard_drive.store_file(new/datum/computer_file/program/email_client())
