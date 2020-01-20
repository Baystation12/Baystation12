
/obj/item/modular_computer/console/preset/auto_mac
	name = "MAC Automated Fire Control"
	icon = 'code/modules/halo/structures/AI Stuff.dmi'
	icon_state= "console"

/obj/item/modular_computer/console/preset/auto_mac/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/auto_mac())
	hard_drive.store_file(new/datum/computer_file/program/chatclient())
	hard_drive.store_file(new/datum/computer_file/program/nttransfer())
	hard_drive.store_file(new/datum/computer_file/program/email_client())

	//have the mac automation program auto run when the computer starts up
	set_autorun("mac_control_automated")

/obj/item/modular_computer/console/preset/auto_mac/Initialize()
	. = ..()

	//start up the computer
	turn_on()

	//enable the mac autofire program
	var/datum/computer_file/program/auto_mac/auto_mac_program = src.active_program
	var/datum/nano_module/auto_mac/auto_mac_nano_module = auto_mac_program.NM
	auto_mac_nano_module.start_targetting()
