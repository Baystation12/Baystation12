//Sidenote; Try to keep a requirement of 5 engineering for each, but keep the rest as similiar to it's original as possible.
/datum/design/item/rig/AssembleDesignName()
	..()
	name = "RIG module ([item_name])"

/datum/design/item/integrated_printer
	name = "Integrated Circuit Printer"
	desc = "This machine provides all the necessary things for circuitry."
	id = "icprinter"
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 1)
	materials = list(MATERIAL_STEEL = 10000, MATERIAL_GLASS = 5000)
	build_path = /obj/item/device/integrated_circuit_printer
	sort_string = "WCLAC"

/datum/design/item/integrated_printer_upgrade_advanced
	name = "Integrated Circuit Printer Upgrade Disk"
	desc = "This disk allows for integrated circuit printers to print advanced circuitry designs."
	id = "icupgradv"
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 3)
	materials = list(MATERIAL_STEEL = 10000, MATERIAL_GLASS = 10000)
	build_path = /obj/item/disk/integrated_circuit/upgrade/advanced
	sort_string = "WCLAD"

/datum/design/item/integrated_printer_upgrade_clone
	name = "Integrated Circuit Printer Clone Disk"
	desc = "This disk allows for integrated circuit printers to copy and clone designs instantaneously."
	id = "icupclo"
	req_tech = list(TECH_DATA = 3, TECH_MATERIAL = 5)
	materials = list(MATERIAL_STEEL = 10000, MATERIAL_GLASS = 10000)
	build_path = /obj/item/disk/integrated_circuit/upgrade/clone
	sort_string = "WCLAE"