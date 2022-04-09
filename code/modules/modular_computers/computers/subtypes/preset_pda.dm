/obj/item/modular_computer/pda/install_default_hardware()
	..()
	processor_unit = new/obj/item/stock_parts/computer/processor_unit/small(src)
	tesla_link = new/obj/item/stock_parts/computer/tesla_link(src)
	hard_drive = new/obj/item/stock_parts/computer/hard_drive/small(src)
	network_card = new/obj/item/stock_parts/computer/network_card/(src)
	card_slot = new /obj/item/stock_parts/computer/card_slot/broadcaster(src)
	battery_module = new/obj/item/stock_parts/computer/battery_module(src)
	battery_module.charge_to_full()

/obj/item/modular_computer/pda/install_default_programs()
	..()
	var/datum/extension/interactive/ntos/os = get_extension(src, /datum/extension/interactive/ntos)
	if(os)
		os.create_file(new/datum/computer_file/program/email_client())
		os.create_file(new/datum/computer_file/program/crew_manifest())
		os.create_file(new/datum/computer_file/program/wordprocessor())
		os.create_file(new/datum/computer_file/program/records())
		os.create_file(new/datum/computer_file/program/newscast())
		if(prob(50)) //harmless tax software
			os.create_file(new /datum/computer_file/program/uplink())
		os.set_autorun("emailc")

/obj/item/modular_computer/pda/medical/install_default_hardware()
	..()
	scanner = new /obj/item/stock_parts/computer/scanner/medical(src)

/obj/item/modular_computer/pda/chemistry/install_default_hardware()
	..()
	scanner = new /obj/item/stock_parts/computer/scanner/reagent(src)

/obj/item/modular_computer/pda/engineering/install_default_hardware()
	..()
	scanner = new /obj/item/stock_parts/computer/scanner/atmos(src)

/obj/item/modular_computer/pda/science/install_default_hardware()
	..()
	scanner = new /obj/item/stock_parts/computer/scanner/reagent(src)

/obj/item/modular_computer/pda/forensics/install_default_hardware()
	..()
	scanner = new /obj/item/stock_parts/computer/scanner/reagent(src)

/obj/item/modular_computer/pda/heads/install_default_programs()
	..()
	var/datum/extension/interactive/ntos/os = get_extension(src, /datum/extension/interactive/ntos)
	if(os)
		os.create_file(new/datum/computer_file/program/reports())

/obj/item/modular_computer/pda/heads/hop/install_default_hardware()
	..()
	scanner = new /obj/item/stock_parts/computer/scanner/paper(src)

/obj/item/modular_computer/pda/heads/hos/install_default_hardware()
	..()
	scanner = new /obj/item/stock_parts/computer/scanner/paper(src)

/obj/item/modular_computer/pda/heads/ce/install_default_hardware()
	..()
	scanner = new /obj/item/stock_parts/computer/scanner/atmos(src)

/obj/item/modular_computer/pda/heads/cmo/install_default_hardware()
	..()
	scanner = new /obj/item/stock_parts/computer/scanner/medical(src)

/obj/item/modular_computer/pda/heads/rd/install_default_hardware()
	..()
	scanner = new /obj/item/stock_parts/computer/scanner/paper(src)

/obj/item/modular_computer/pda/cargo/install_default_programs()
	..()
	var/datum/extension/interactive/ntos/os = get_extension(src, /datum/extension/interactive/ntos)
	if(os)
		os.create_file(new/datum/computer_file/program/reports())

/obj/item/modular_computer/pda/cargo/install_default_hardware()
	..()
	scanner = new /obj/item/stock_parts/computer/scanner/paper(src)

/obj/item/modular_computer/pda/mining/install_default_hardware()
	..()
	scanner = new /obj/item/stock_parts/computer/scanner/atmos(src)

/obj/item/modular_computer/pda/explorer/install_default_hardware()
	..()
	scanner = new /obj/item/stock_parts/computer/scanner/atmos(src)

/obj/item/modular_computer/pda/captain/install_default_hardware()
	..()
	scanner = new /obj/item/stock_parts/computer/scanner/paper(src)

/obj/item/modular_computer/pda/roboticist/install_default_hardware()
	..()
	scanner = new /obj/item/stock_parts/computer/scanner/robotic(src)
