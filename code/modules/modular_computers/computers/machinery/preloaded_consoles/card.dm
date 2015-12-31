/obj/machinery/modular_computer/console/card
	console_department = "command"

/obj/machinery/modular_computer/console/card/New()
	..()
	var/obj/item/weapon/computer_hardware/hard_drive/HDD = cpu.hard_drive
	var/datum/computer_file/program/prog = ntnet_global.find_ntnet_file_by_name("cardmod")
	HDD.store_file(prog.clone())
	cpu.card_slot = new/obj/item/weapon/computer_hardware/card_slot(src)