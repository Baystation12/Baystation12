// Drives
/datum/design/item/modularcomponent/disk/AssembleDesignName()
	..()
	name = "Hard drive design ([item_name])"

/datum/design/item/modularcomponent/disk/normal
	name = "basic hard drive"
	id = "hdd_basic"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_type = PROTOLATHE
	materials = list(MATERIAL_STEEL = 400, MATERIAL_GLASS = 100)
	build_path = /obj/item/stock_parts/computer/hard_drive/
	sort_string = "VBAAA"

/datum/design/item/modularcomponent/disk/advanced
	name = "advanced hard drive"
	id = "hdd_advanced"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_STEEL = 800, MATERIAL_GLASS = 200)
	build_path = /obj/item/stock_parts/computer/hard_drive/advanced
	sort_string = "VBAAB"

/datum/design/item/modularcomponent/disk/super
	name = "super hard drive"
	id = "hdd_super"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_STEEL = 1600, MATERIAL_GLASS = 400)
	build_path = /obj/item/stock_parts/computer/hard_drive/super
	sort_string = "VBAAC"

/datum/design/item/modularcomponent/disk/cluster
	name = "cluster hard drive"
	id = "hdd_cluster"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)
	build_type = PROTOLATHE
	materials = list(MATERIAL_STEEL = 3200, MATERIAL_GLASS = 800)
	build_path = /obj/item/stock_parts/computer/hard_drive/cluster
	sort_string = "VBAAD"

/datum/design/item/modularcomponent/disk/micro
	name = "micro hard drive"
	id = "hdd_micro"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_type = PROTOLATHE
	materials = list(MATERIAL_STEEL = 400, MATERIAL_GLASS = 100)
	build_path = /obj/item/stock_parts/computer/hard_drive/micro
	sort_string = "VBAAE"

/datum/design/item/modularcomponent/disk/small
	name = "small hard drive"
	id = "hdd_small"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_STEEL = 800, MATERIAL_GLASS = 200)
	build_path = /obj/item/stock_parts/computer/hard_drive/small
	sort_string = "VBAAF"

// Network cards
/datum/design/item/modularcomponent/netcard/AssembleDesignName()
	..()
	name = "Network card design ([item_name])"

/datum/design/item/modularcomponent/netcard/basic
	name = "basic network card"
	id = "netcard_basic"
	req_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	build_type = IMPRINTER
	materials = list(MATERIAL_STEEL = 250, MATERIAL_GLASS = 100)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/stock_parts/computer/network_card
	sort_string = "VBABA"

/datum/design/item/modularcomponent/netcard/advanced
	name = "advanced network card"
	id = "netcard_advanced"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 2)
	build_type = IMPRINTER
	materials = list(MATERIAL_STEEL = 500, MATERIAL_GLASS = 200)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/stock_parts/computer/network_card/advanced
	sort_string = "VBABB"

/datum/design/item/modularcomponent/netcard/wired
	name = "wired network card"
	id = "netcard_wired"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 3)
	build_type = IMPRINTER
	materials = list(MATERIAL_STEEL = 2500, MATERIAL_GLASS = 400)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/stock_parts/computer/network_card/wired
	sort_string = "VBABC"

// Data crystals (USB flash drives)
/datum/design/item/modularcomponent/portabledrive/AssembleDesignName()
	..()
	name = "Portable drive design ([item_name])"

/datum/design/item/modularcomponent/portabledrive/basic
	name = "basic data crystal"
	id = "portadrive_basic"
	req_tech = list(TECH_DATA = 1)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 800)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/stock_parts/computer/hard_drive/portable
	sort_string = "VBACA"

/datum/design/item/modularcomponent/portabledrive/advanced
	name = "advanced data crystal"
	id = "portadrive_advanced"
	req_tech = list(TECH_DATA = 2)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 1600)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/stock_parts/computer/hard_drive/portable/advanced
	sort_string = "VBACB"

/datum/design/item/modularcomponent/portabledrive/super
	name = "super data crystal"
	id = "portadrive_super"
	req_tech = list(TECH_DATA = 4)
	build_type = IMPRINTER
	materials = list(MATERIAL_GLASS = 3200)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/stock_parts/computer/hard_drive/portable/super
	sort_string = "VBACC"

// Card slot
/datum/design/item/modularcomponent/accessory/AssembleDesignName()
	..()
	name = "Computer accessory ([item_name])"

/datum/design/item/modularcomponent/accessory/cardslot
	name = "RFID card slot"
	id = "cardslot"
	req_tech = list(TECH_DATA = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_STEEL = 600)
	build_path = /obj/item/stock_parts/computer/card_slot
	sort_string = "VBADA"

// Card Broadcaster
/datum/design/item/modularcomponent/accessory/cardbroadcaster
	name = "RFID card broadcaster"
	id = "cardbroadcaster"
	req_tech = list(TECH_DATA = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_STEEL = 600)
	build_path = /obj/item/stock_parts/computer/card_slot/broadcaster
	sort_string = "VBADB"

// inteliCard Slot
/datum/design/item/modularcomponent/accessory/aislot
	name = "inteliCard slot"
	id = "aislot"
	req_tech = list(TECH_POWER = 2, TECH_DATA = 3)
	build_type = IMPRINTER
	materials = list(MATERIAL_STEEL = 2000)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/stock_parts/computer/ai_slot
	sort_string = "VBADC"

// Nano printer
/datum/design/item/modularcomponent/accessory/nanoprinter
	name = "nano printer"
	id = "nanoprinter"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_STEEL = 600)
	build_path = /obj/item/stock_parts/computer/nano_printer
	sort_string = "VBADD"

// Tesla Link
/datum/design/item/modularcomponent/accessory/teslalink
	name = "tesla link"
	id = "teslalink"
	req_tech = list(TECH_DATA = 2, TECH_POWER = 3, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_STEEL = 2000)
	build_path = /obj/item/stock_parts/computer/tesla_link
	sort_string = "VBADE"

//Scanners
/datum/design/item/modularcomponent/accessory/reagent_scanner
	name = "reagent scanner module"
	id = "scan_reagent"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2, TECH_BIO = 2, TECH_MAGNET = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_STEEL = 600, MATERIAL_GLASS = 200)
	build_path = /obj/item/stock_parts/computer/scanner/reagent
	sort_string = "VBADF"

/datum/design/item/modularcomponent/accessory/paper_scanner
	name = "paper scanner module"
	id = "scan_paper"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_STEEL = 600, MATERIAL_GLASS = 200)
	build_path = /obj/item/stock_parts/computer/scanner/paper
	sort_string = "VBADG"

/datum/design/item/modularcomponent/accessory/atmos_scanner
	name = "atmospheric scanner module"
	id = "scan_atmos"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2, TECH_MAGNET = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_STEEL = 600, MATERIAL_GLASS = 200)
	build_path = /obj/item/stock_parts/computer/scanner/atmos
	sort_string = "VBADH"

/datum/design/item/modularcomponent/accessory/medical_scanner
	name = "medical scanner module"
	id = "scan_medical"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2, TECH_MAGNET = 2, TECH_BIO = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_STEEL = 600, MATERIAL_GLASS = 200)
	build_path = /obj/item/stock_parts/computer/scanner/medical
	sort_string = "VBADI"

// Batteries
/datum/design/item/modularcomponent/battery/AssembleDesignName()
	..()
	name = "Battery design ([item_name])"

/datum/design/item/modularcomponent/battery/normal
	name = "standard battery module"
	id = "bat_normal"
	req_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	build_type = PROTOLATHE
	materials = list(MATERIAL_STEEL = 400)
	build_path = /obj/item/stock_parts/computer/battery_module
	sort_string = "VBAEA"

/datum/design/item/modularcomponent/battery/advanced
	name = "advanced battery module"
	id = "bat_advanced"
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_STEEL = 800)
	build_path = /obj/item/stock_parts/computer/battery_module/advanced
	sort_string = "VBAEB"

/datum/design/item/modularcomponent/battery/super
	name = "super battery module"
	id = "bat_super"
	req_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 3)
	build_type = PROTOLATHE
	materials = list(MATERIAL_STEEL = 1600)
	build_path = /obj/item/stock_parts/computer/battery_module/super
	sort_string = "VBAEC"

/datum/design/item/modularcomponent/battery/ultra
	name = "ultra battery module"
	id = "bat_ultra"
	req_tech = list(TECH_POWER = 5, TECH_ENGINEERING = 4)
	build_type = PROTOLATHE
	materials = list(MATERIAL_STEEL = 3200)
	build_path = /obj/item/stock_parts/computer/battery_module/ultra
	sort_string = "VBAED"

/datum/design/item/modularcomponent/battery/nano
	name = "nano battery module"
	id = "bat_nano"
	req_tech = list(TECH_POWER = 1, TECH_ENGINEERING = 1)
	build_type = PROTOLATHE
	materials = list(MATERIAL_STEEL = 200)
	build_path = /obj/item/stock_parts/computer/battery_module/nano
	sort_string = "VBAEE"

/datum/design/item/modularcomponent/battery/micro
	name = "micro battery module"
	id = "bat_micro"
	req_tech = list(TECH_POWER = 2, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	materials = list(MATERIAL_STEEL = 400)
	build_path = /obj/item/stock_parts/computer/battery_module/micro
	sort_string = "VBAEF"

// Processor unit
/datum/design/item/modularcomponent/cpu/AssembleDesignName()
	..()
	name = "CPU design ([item_name])"

/datum/design/item/modularcomponent/cpu/
	name = "computer processor unit"
	id = "cpu_normal"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 2)
	build_type = IMPRINTER
	materials = list(MATERIAL_STEEL = 1600)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/stock_parts/computer/processor_unit
	sort_string = "VBAFA"

/datum/design/item/modularcomponent/cpu/small
	name = "computer microprocessor unit"
	id = "cpu_small"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_type = IMPRINTER
	materials = list(MATERIAL_STEEL = 800)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/stock_parts/computer/processor_unit/small
	sort_string = "VBAFB"

/datum/design/item/modularcomponent/cpu/photonic
	name = "computer photonic processor unit"
	id = "pcpu_normal"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 4)
	build_type = IMPRINTER
	materials = list(MATERIAL_STEEL = 6400, glass = 2000)
	chemicals = list(/datum/reagent/acid = 40)
	build_path = /obj/item/stock_parts/computer/processor_unit/photonic
	sort_string = "VBAFC"

/datum/design/item/modularcomponent/cpu/photonic/small
	name = "computer photonic microprocessor unit"
	id = "pcpu_small"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3)
	build_type = IMPRINTER
	materials = list(MATERIAL_STEEL = 3200, glass = 1000)
	chemicals = list(/datum/reagent/acid = 20)
	build_path = /obj/item/stock_parts/computer/processor_unit/photonic/small
	sort_string = "VBAFD"