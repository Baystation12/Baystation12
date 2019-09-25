/obj/item/modular_computer/pda/install_default_hardware()
	..()

	network_card = new /obj/item/weapon/stock_parts/computer/network_card/(src)
	hard_drive = new /obj/item/weapon/stock_parts/computer/hard_drive/small(src)
	processor_unit = new /obj/item/weapon/stock_parts/computer/processor_unit/small(src)
	card_slot = new /obj/item/weapon/stock_parts/computer/card_slot/broadcaster(src)
	battery_module = new /obj/item/weapon/stock_parts/computer/battery_module(src)
	battery_module.charge_to_full()

	tesla_link = new /obj/item/weapon/stock_parts/computer/tesla_link(src)

/obj/item/modular_computer/pda/install_default_programs()
	..()

	hard_drive.store_file(new /datum/computer_file/program/email_client())
	hard_drive.store_file(new /datum/computer_file/program/crew_manifest())
	hard_drive.store_file(new /datum/computer_file/program/wordprocessor())
	hard_drive.store_file(new /datum/computer_file/program/records())
	if(prob(50)) //harmless tax software
		hard_drive.store_file(new /datum/computer_file/program/uplink())
	var/datum/extension/interactive/ntos/os = get_extension(src, /datum/extension/interactive/ntos)
	if(os)
		os.set_autorun("emailc")

/obj/item/modular_computer/pda/medical/install_default_hardware()
	..()
	scanner = new /obj/item/weapon/stock_parts/computer/scanner/medical(src)

/obj/item/modular_computer/pda/chemistry/install_default_hardware()
	..()
	scanner = new /obj/item/weapon/stock_parts/computer/scanner/reagent(src)

/obj/item/modular_computer/pda/engineering/install_default_hardware()
	..()
	scanner = new /obj/item/weapon/stock_parts/computer/scanner/atmos(src)

/obj/item/modular_computer/pda/science/install_default_hardware()
	..()
	scanner = new /obj/item/weapon/stock_parts/computer/scanner/reagent(src)

/obj/item/modular_computer/pda/forensics/install_default_hardware()
	..()
	scanner = new /obj/item/weapon/stock_parts/computer/scanner/reagent(src)

/obj/item/modular_computer/pda/heads/install_default_programs()
	..()
	hard_drive.store_file(new /datum/computer_file/program/reports())

/obj/item/modular_computer/pda/heads/hop/install_default_hardware()
	..()
	scanner = new /obj/item/weapon/stock_parts/computer/scanner/paper(src)

/obj/item/modular_computer/pda/heads/hos/install_default_hardware()
	..()
	scanner = new /obj/item/weapon/stock_parts/computer/scanner/paper(src)

/obj/item/modular_computer/pda/heads/ce/install_default_hardware()
	..()
	scanner = new /obj/item/weapon/stock_parts/computer/scanner/atmos(src)

/obj/item/modular_computer/pda/heads/cmo/install_default_hardware()
	..()
	scanner = new /obj/item/weapon/stock_parts/computer/scanner/medical(src)

/obj/item/modular_computer/pda/heads/rd/install_default_hardware()
	..()
	scanner = new /obj/item/weapon/stock_parts/computer/scanner/paper(src)

/obj/item/modular_computer/pda/cargo/install_default_programs()
	..()
	hard_drive.store_file(new /datum/computer_file/program/reports())

/obj/item/modular_computer/pda/cargo/install_default_hardware()
	..()
	scanner = new /obj/item/weapon/stock_parts/computer/scanner/paper(src)

/obj/item/modular_computer/pda/mining/install_default_hardware()
	..()
	scanner = new /obj/item/weapon/stock_parts/computer/scanner/atmos(src)

/obj/item/modular_computer/pda/explorer/install_default_hardware()
	..()
	scanner = new /obj/item/weapon/stock_parts/computer/scanner/atmos(src)

/obj/item/modular_computer/pda/captain/install_default_hardware()
	..()
	scanner = new /obj/item/weapon/stock_parts/computer/scanner/paper(src)