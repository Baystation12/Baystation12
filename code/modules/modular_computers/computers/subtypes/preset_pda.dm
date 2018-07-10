/obj/item/modular_computer/pda/install_default_hardware()
	..()

	network_card = new /obj/item/weapon/computer_hardware/network_card/(src)
	hard_drive = new /obj/item/weapon/computer_hardware/hard_drive/small(src)
	processor_unit = new /obj/item/weapon/computer_hardware/processor_unit/small(src)
	card_slot = new /obj/item/weapon/computer_hardware/card_slot/broadcaster(src)
	battery_module = new /obj/item/weapon/computer_hardware/battery_module(src)
	battery_module.charge_to_full()

	tesla_link = new /obj/item/weapon/computer_hardware/tesla_link(src)

/obj/item/modular_computer/pda/install_default_programs()
	..()

	hard_drive.store_file(new /datum/computer_file/program/chatclient())
	hard_drive.store_file(new /datum/computer_file/program/email_client())
	hard_drive.store_file(new /datum/computer_file/program/crew_manifest())
	hard_drive.store_file(new /datum/computer_file/program/wordprocessor())
	hard_drive.store_file(new /datum/computer_file/program/records())
	if(prob(50)) //harmless tax software
		hard_drive.store_file(new /datum/computer_file/program/uplink())
	set_autorun("emailc")

/obj/item/modular_computer/pda/medical/install_default_hardware()
	..()
	scanner = new /obj/item/weapon/computer_hardware/scanner/medical(src)

/obj/item/modular_computer/pda/chemistry/install_default_hardware()
	..()
	scanner = new /obj/item/weapon/computer_hardware/scanner/reagent(src)

/obj/item/modular_computer/pda/engineering/install_default_hardware()
	..()
	scanner = new /obj/item/weapon/computer_hardware/scanner/atmos(src)

/obj/item/modular_computer/pda/science/install_default_hardware()
	..()
	scanner = new /obj/item/weapon/computer_hardware/scanner/reagent(src)

/obj/item/modular_computer/pda/forensics/install_default_hardware()
	..()
	scanner = new /obj/item/weapon/computer_hardware/scanner/reagent(src)

/obj/item/modular_computer/pda/heads/hop/install_default_hardware()
	..()
	scanner = new /obj/item/weapon/computer_hardware/scanner/paper(src)

/obj/item/modular_computer/pda/heads/hos/install_default_hardware()
	..()
	scanner = new /obj/item/weapon/computer_hardware/scanner/paper(src)

/obj/item/modular_computer/pda/heads/ce/install_default_hardware()
	..()
	scanner = new /obj/item/weapon/computer_hardware/scanner/atmos(src)

/obj/item/modular_computer/pda/heads/cmo/install_default_hardware()
	..()
	scanner = new /obj/item/weapon/computer_hardware/scanner/medical(src)

/obj/item/modular_computer/pda/heads/rd/install_default_hardware()
	..()
	scanner = new /obj/item/weapon/computer_hardware/scanner/paper(src)

/obj/item/modular_computer/pda/cargo/install_default_hardware()
	..()
	scanner = new /obj/item/weapon/computer_hardware/scanner/paper(src)

/obj/item/modular_computer/pda/captain/install_default_hardware()
	..()
	scanner = new /obj/item/weapon/computer_hardware/scanner/paper(src)