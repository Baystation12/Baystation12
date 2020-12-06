//Sidenote; Try to keep a requirement of 5 engineering for each, but keep the rest as similiar to it's original as possible.
/datum/design/item/rig/AssembleDesignName()
	..()
	name = "RIG module ([item_name])"

/datum/design/item/rig/meson
	name = "Meson Scanner"
	desc = "A layered, translucent visor system for a RIG."
	id = "rig_meson"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 5)
	materials = list(MATERIAL_STEEL = 100, MATERIAL_GLASS = 200, MATERIAL_PLASTIC = 300)
	build_path = /obj/item/rig_module/vision/meson
	sort_string = "WCAAA"

/datum/design/item/rig/medhud
	name = "Medical HUD"
	desc = "A simple medical status indicator for a RIG."
	id = "rig_medhud"
	req_tech = list(TECH_MAGNET = 3, TECH_BIO = 2, TECH_ENGINEERING = 5)
	materials = list(MATERIAL_STEEL = 100, MATERIAL_GLASS = 200,  MATERIAL_PLASTIC = 300)
	build_path = /obj/item/rig_module/vision/medhud
	sort_string = "WCAAB"

/datum/design/item/rig/sechud
	name = "Security HUD"
	desc = "A simple security status indicator for a RIG."
	id = "rig_sechud"
	req_tech = list(TECH_MAGNET = 3, TECH_BIO = 2, TECH_ENGINEERING = 5)
	materials = list(MATERIAL_STEEL = 100, MATERIAL_GLASS = 200,  MATERIAL_PLASTIC = 300)
	build_path = /obj/item/rig_module/vision/sechud
	sort_string = "WCAAC"

/datum/design/item/rig/nvg
	name = "Night Vision"
	desc = "A night vision module, mountable on a RIG."
	id = "rig_nvg"
	req_tech = list(TECH_MAGNET = 6, TECH_ENGINEERING = 6)
	materials = list(MATERIAL_PLASTIC = 500, MATERIAL_STEEL = 300, MATERIAL_GLASS = 200, MATERIAL_URANIUM = 200)
	build_path = /obj/item/rig_module/vision/nvg
	sort_string = "WCAAD"

/datum/design/item/rig/healthscanner
	name = "Medical Scanner"
	desc = "A device able to distinguish vital signs of the subject, mountable on a RIG."
	id = "rig_healthscanner"
	req_tech = list(TECH_MAGNET = 3, TECH_BIO = 3, TECH_ENGINEERING = 5)
	materials = list(MATERIAL_PLASTIC = 1000, MATERIAL_STEEL = 700, MATERIAL_GLASS = 500)
	build_path = /obj/item/rig_module/device/healthscanner
	sort_string = "WCBAA"

/datum/design/item/rig/drill
	name = "Mining Drill"
	desc = "A diamond mining drill, mountable on a RIG."
	id = "rig_drill"
	req_tech = list(TECH_MATERIAL = 6, TECH_POWER = 4, TECH_ENGINEERING = 6)
	materials = list(MATERIAL_STEEL = 3500, MATERIAL_GLASS = 1500, MATERIAL_DIAMOND = 2000, MATERIAL_PLASTIC = 1000)
	build_path = /obj/item/rig_module/device/drill
	sort_string = "WCCAA"

/datum/design/item/rig/plasmacutter
	name = "Plasma Cutter"
	desc = "A rock cutter that projects bursts of hot plasma, mountable on a RIG."
	id = "rig_plasmacutter"
	req_tech = list(TECH_MATERIAL = 4, TECH_PHORON = 3, TECH_ENGINEERING = 6, TECH_COMBAT = 4)
	materials = list(MATERIAL_STEEL = 2000, MATERIAL_GLASS = 1000, MATERIAL_PLASTIC = 1000, MATERIAL_GOLD = 700, MATERIAL_PHORON = 500)
	build_path = /obj/item/rig_module/mounted/plasmacutter
	sort_string = "VCCAB"

/datum/design/item/rig/orescanner
	name = "Ore Scanner"
	desc = "A sonar system for detecting large masses of ore, mountable on a RIG."
	id = "rig_orescanner"
	req_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 4, TECH_ENGINEERING = 6)
	materials = list(MATERIAL_PLASTIC = 1000, MATERIAL_STEEL = 800, MATERIAL_GLASS = 500)
	build_path = /obj/item/rig_module/device/orescanner
	sort_string = "WCDAA"

/datum/design/item/rig/anomaly_scanner
	name = "Anomaly Scanner"
	desc = "An exotic particle detector commonly used by xenoarchaeologists, mountable on a RIG."
	id = "rig_anomaly_scanner"
	req_tech = list(TECH_BLUESPACE = 4, TECH_MAGNET = 4, TECH_ENGINEERING = 6)
	materials = list(MATERIAL_PLASTIC = 1000, MATERIAL_STEEL = 800, MATERIAL_GLASS = 500)
	build_path = /obj/item/rig_module/device/anomaly_scanner
	sort_string = "WCDAB"

/datum/design/item/rig/rcd
	name = "RCD"
	desc = "A Rapid Construction Device, mountable on a RIG."
	id = "rig_rcd"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 5, TECH_ENGINEERING = 7)
	materials = list(MATERIAL_STEEL = 2000, MATERIAL_GLASS = 1000, MATERIAL_PLASTIC = 1000,MATERIAL_GOLD = 700, MATERIAL_SILVER = 700)
	build_path = /obj/item/rig_module/device/rcd
	sort_string = "WCEAA"

/datum/design/item/rig/jets
	name = "Maneuvering Jets"
	desc = "A compact gas thruster system, mountable on a RIG."
	id = "rig_jets"
	req_tech = list(TECH_MATERIAL = 6,  TECH_ENGINEERING = 7)
	materials = list(MATERIAL_STEEL = 3000, MATERIAL_PLASTIC = 2000, MATERIAL_GLASS = 1000)
	build_path = /obj/item/rig_module/maneuvering_jets
	sort_string = "WCFAA"

//I think this is like a janitor thing but seems like it could be useful for engis
/datum/design/item/rig/decompiler
	name = "Matter Decompiler"
	desc = "A drone matter decompiler reconfigured to be mounted onto a RIG."
	id = "rig_decompiler"
	req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 5)
	materials = list(MATERIAL_STEEL = 3000, MATERIAL_PLASTIC = 2000, MATERIAL_GLASS = 1000)
	build_path = /obj/item/rig_module/device/decompiler
	sort_string = "WCGAA"

/datum/design/item/rig/powersink
	name = "Power Sink"
	desc = "A RIG module that allows the user to recharge their RIG's power cell without removing it."
	id = "rig_powersink"
	req_tech = list(TECH_POWER = 6, TECH_ENGINEERING = 6)
	materials = list(MATERIAL_STEEL = 2000, MATERIAL_GLASS = 2000, MATERIAL_GOLD = 1000, MATERIAL_PLASTIC = 1000)
	build_path = /obj/item/rig_module/power_sink
	sort_string = "WCHAA"

/datum/design/item/rig/ai_container
	name = "IIS"
	desc = "An integrated intelligence system module suitable for most RIGs."
	id = "rig_ai_container"
	req_tech = list(TECH_DATA = 6, TECH_MATERIAL = 5, TECH_ENGINEERING = 6)
	materials = list(MATERIAL_STEEL = 1000, MATERIAL_GLASS = 1000, MATERIAL_PLASTIC = 1000, MATERIAL_GOLD = 500)
	build_path = /obj/item/rig_module/ai_container
	sort_string = "WCIAA"

/datum/design/item/rig/flash
	name = "Flash"
	desc = "A normal flash, mountable on a RIG."
	id = "rig_flash"
	req_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 3, TECH_ENGINEERING = 5)
	materials = list(MATERIAL_PLASTIC = 1500, MATERIAL_STEEL = 1000, MATERIAL_GLASS = 500)
	build_path = /obj/item/rig_module/device/flash
	sort_string = "WCJAA"

/datum/design/item/rig/taser
	name = "Electrolaser"
	desc = "An electrolaser, mountable on a RIG."
	id = "rig_taser"
	req_tech = list(TECH_POWER = 5, TECH_COMBAT = 5, TECH_ENGINEERING = 6)
	materials = list(MATERIAL_STEEL = 4000, MATERIAL_PLASTIC = 2500, MATERIAL_GLASS = 2000, MATERIAL_GOLD = 1000)
	build_path = /obj/item/rig_module/mounted/taser
	sort_string = "WCKAA"

/datum/design/item/rig/egun
	name = "Energy Gun"
	desc = "An energy gun, mountable on a RIG."
	id = "rig_egun"
	req_tech = list(TECH_POWER = 6, TECH_COMBAT = 6, TECH_ENGINEERING = 6)
	materials = list(MATERIAL_STEEL = 6000, MATERIAL_GLASS = 3000, MATERIAL_PLASTIC = 2500, MATERIAL_GOLD = 2000, MATERIAL_SILVER = 1000)
	build_path = /obj/item/rig_module/mounted/egun
	sort_string = "WCKAB"

/datum/design/item/rig/enet
	name = "Energy Net"
	desc = "An advanced energy-patterning projector used to capture targets, mountable on a RIG."
	id = "rig_enet"
	req_tech = list(TECH_MATERIAL = 5, TECH_POWER = 6, TECH_MAGNET = 5, TECH_ESOTERIC = 4, TECH_ENGINEERING = 6)
	materials = list(MATERIAL_STEEL = 6000, MATERIAL_GLASS = 3000, MATERIAL_DIAMOND = 2000, MATERIAL_PLASTIC = 2000)
	build_path = /obj/item/rig_module/fabricator/energy_net
	sort_string = "WCKAC"

/datum/design/item/rig/stealth
	name = "Active Camouflage"
	desc = "An integrated active camouflage system, mountable on a RIG."
	id = "rig_stealth"
	req_tech = list(TECH_MATERIAL = 5, TECH_POWER = 6, TECH_MAGNET = 6, TECH_ESOTERIC = 6, TECH_ENGINEERING = 7)
	materials = list(MATERIAL_STEEL = 6000, MATERIAL_GLASS = 3000, MATERIAL_DIAMOND = 2000, MATERIAL_SILVER = 2000, MATERIAL_URANIUM = 2000, MATERIAL_GOLD = 2000, MATERIAL_PLASTIC = 2000)
	build_path = /obj/item/rig_module/stealth_field
	sort_string = "WCLAA"

/datum/design/item/rig/cooling_unit
	name = "Cooling Unit"
	desc = "A suit cooling unit, mountable on a RIG."
	id = "rig_cooler"
	req_tech = list(TECH_MATERIAL = 2, TECH_MAGNET = 2, TECH_ENGINEERING = 5)
	materials = list(MATERIAL_STEEL = 3000, MATERIAL_GLASS = 3500, MATERIAL_PLASTIC = 2000)
	build_path = /obj/item/rig_module/cooling_unit
	sort_string = "WCLAB"

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