/datum/design/item/medical
	materials = list(MATERIAL_STEEL = 30, MATERIAL_GLASS = 20)

/datum/design/item/medical/AssembleDesignName()
	..()
	name = "Biotech device prototype ([item_name])"

/datum/design/item/medical/slime_scanner
	desc = "Multipurpose organic life scanner."
	id = "slime_scanner"
	req_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	materials = list(MATERIAL_STEEL = 200, MATERIAL_GLASS = 100, MATERIAL_PLASTIC = 150)
	build_path = /obj/item/device/slime_scanner
	sort_string = "MACFA"

/datum/design/item/medical/robot_scanner
	desc = "A hand-held scanner able to diagnose robotic injuries."
	id = "robot_scanner"
	req_tech = list(TECH_MAGNET = 3, TECH_BIO = 2, TECH_ENGINEERING = 3)
	materials = list(MATERIAL_STEEL = 500, MATERIAL_GLASS = 200, MATERIAL_PLASTIC = 150)
	build_path = /obj/item/device/robotanalyzer
	sort_string = "MACFB"

/datum/design/item/medical/mass_spectrometer
	desc = "A device for analyzing chemicals in blood."
	id = "mass_spectrometer"
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 2)
	build_path = /obj/item/device/mass_spectrometer
	sort_string = "MACAA"

/datum/design/item/medical/adv_mass_spectrometer
	desc = "A device for analyzing chemicals in blood and their quantities."
	id = "adv_mass_spectrometer"
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 4)
	build_path = /obj/item/device/mass_spectrometer/adv
	sort_string = "MACAB"

/datum/design/item/medical/reagent_scanner
	desc = "A device for identifying chemicals."
	id = "reagent_scanner"
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 2)
	build_path = /obj/item/device/reagent_scanner
	sort_string = "MACBA"

/datum/design/item/medical/adv_reagent_scanner
	desc = "A device for identifying chemicals and their proportions."
	id = "adv_reagent_scanner"
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 4)
	build_path = /obj/item/device/reagent_scanner/adv
	sort_string = "MACBB"

/datum/design/item/medical/nanopaste
	desc = "A tube of paste containing swarms of repair nanites. Very effective in repairing robotic machinery."
	id = "nanopaste"
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3)
	materials = list(MATERIAL_STEEL = 7000, MATERIAL_GLASS = 7000)
	build_path = /obj/item/stack/nanopaste
	sort_string = "MADAA"

/datum/design/item/medical/hypospray
	desc = "A sterile, air-needle autoinjector for rapid administration of drugs"
	id = "hypospray"
	req_tech = list(TECH_MATERIAL = 4, TECH_BIO = 5)
	materials = list(MATERIAL_STEEL = 8000, MATERIAL_GLASS = 8000, MATERIAL_SILVER = 2000)
	build_path = /obj/item/weapon/reagent_containers/hypospray/vial
	sort_string = "MAEAA"