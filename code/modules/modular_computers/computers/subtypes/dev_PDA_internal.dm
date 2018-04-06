//An internal modular computer for the PDA.

/obj/item/modular_computer/PDA_internal
	name = "integrated PDA computer"
	desc = "A computer integrated into a PDA."
	hardware_flag = PROGRAM_TABLET
	max_hardware_size = 1
	
	var/obj/item/device/pda/pda = null

/obj/item/modular_computer/PDA_internal/install_default_hardware()
	..()
	processor_unit = new/obj/item/weapon/computer_hardware/processor_unit/small(src)
	tesla_link = new/obj/item/weapon/computer_hardware/tesla_link(src)
	hard_drive = new/obj/item/weapon/computer_hardware/hard_drive/micro(src)
	network_card = new/obj/item/weapon/computer_hardware/network_card(src)
	battery_module = new/obj/item/weapon/computer_hardware/battery_module/nano(src)
	battery_module.charge_to_full()

/obj/item/modular_computer/PDA_internal/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/records())

/obj/item/modular_computer/PDA_internal/New(obj/item/device/pda/parent_pda)
	pda = parent_pda
	forceMove(pda)
	..()

/obj/item/modular_computer/PDA_internal/Destroy()
	pda = null
	. = ..()

/obj/item/modular_computer/PDA_internal/nano_host()
	return pda
