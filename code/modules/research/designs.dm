/***************************************************************
**						Design Datums						  **
**	All the data for building stuff and tracking reliability. **
***************************************************************/
/*
For the materials datum, it assumes you need reagents unless specified otherwise. To designate a material that isn't a reagent,
you use one of the material IDs below. These are NOT ids in the usual sense (they aren't defined in the object or part of a datum),
they are simply references used as part of a "has materials?" type proc. They all start with a  to denote that they aren't reagents.
The currently supporting non-reagent materials:

Don't add new keyword/IDs if they are made from an existing one (such as rods which are made from metal). Only add raw materials.

Design Guidlines
- When adding new designs, check rdreadme.dm to see what kind of things have already been made and where new stuff is needed.
- A single sheet of anything is 2000 units of material. Materials besides metal/glass require help from other jobs (mining for
other types of metals and chemistry for reagents).

*/
//Note: More then one of these can be added to a design.

/datum/design						//Datum for object designs, used in construction
	var/name = null					//Name of the created object. If null it will be 'guessed' from build_path if possible.
	var/desc = null					//Description of the created object. If null it will use group_desc and name where applicable.
	var/item_name = null			//An item name before it is modified by various name-modifying procs
	var/id = "id"					//ID of the created object for easy refernece. Alphanumeric, lower-case, no symbols.
	var/list/req_tech = list()		//IDs of that techs the object originated from and the minimum level requirements.
	var/build_type = null			//Flag as to what kind machine the design is built in. See defines.
	var/list/materials = list()		//List of materials. Format: "id" = amount.
	var/list/chemicals = list()		//List of chemicals.
	var/build_path = null			//The path of the object that gets created.
	var/time = 10					//How many ticks it requires to build
	var/category = null 			//Primarily used for Mech Fabricators, but can be used for anything.
	var/sort_string = "ZZZZZ"		//Sorting order

/datum/design/New()
	..()
	item_name = name
	AssembleDesignInfo()

//These procs are used in subtypes for assigning names and descriptions dynamically
/datum/design/proc/AssembleDesignInfo()
	AssembleDesignName()
	AssembleDesignDesc()
	return

/datum/design/proc/AssembleDesignName()
	if(!name && build_path)					//Get name from build path if posible
		var/atom/movable/A = build_path
		name = initial(A.name)
		item_name = name
	return

/datum/design/proc/AssembleDesignDesc()
	if(!desc)								//Try to make up a nice description if we don't have one
		desc = "Allows for the construction of \a [item_name]."
	return

/datum/design/item
	build_type = PROTOLATHE

/datum/design/item/design_disk
	name = "Design Storage Disk"
	desc = "Produce additional disks for storing device designs."
	id = "design_disk"
	req_tech = list(TECH_DATA = 1)
	materials = list("metal" = 30, "glass" = 10)
	build_path = /obj/item/weapon/disk/design_disk
	sort_string = "GAAAA"

/datum/design/item/tech_disk
	name = "Technology Data Storage Disk"
	desc = "Produce additional disks for storing technology data."
	id = "tech_disk"
	req_tech = list(TECH_DATA = 1)
	materials = list("metal" = 30, "glass" = 10)
	build_path = /obj/item/weapon/disk/tech_disk
	sort_string = "GAAAB"

/datum/design/item/stock_part
	build_type = PROTOLATHE

/datum/design/item/stock_part/AssembleDesignName()
	..()
	name = "Component design ([item_name])"

/datum/design/item/stock_part/AssembleDesignDesc()
	if(!desc)
		desc = "A stock part used in the construction of various devices."

/datum/design/item/stock_part/basic_capacitor
	id = "basic_capacitor"
	req_tech = list(TECH_POWER = 1)
	materials = list("metal" = 50, "glass" = 50)
	build_path = /obj/item/weapon/stock_parts/capacitor
	sort_string = "CAAAA"

/datum/design/item/stock_part/adv_capacitor
	id = "adv_capacitor"
	req_tech = list(TECH_POWER = 3)
	materials = list("metal" = 50, "glass" = 50)
	build_path = /obj/item/weapon/stock_parts/capacitor/adv
	sort_string = "CAAAB"

/datum/design/item/stock_part/super_capacitor
	id = "super_capacitor"
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	materials = list("metal" = 50, "glass" = 50, "gold" = 20)
	build_path = /obj/item/weapon/stock_parts/capacitor/super
	sort_string = "CAAAC"

/datum/design/item/stock_part/micro_mani
	id = "micro_mani"
	req_tech = list(TECH_MATERIAL = 1, TECH_DATA = 1)
	materials = list("metal" = 30)
	build_path = /obj/item/weapon/stock_parts/manipulator
	sort_string = "CAABA"

/datum/design/item/stock_part/nano_mani
	id = "nano_mani"
	req_tech = list(TECH_MATERIAL = 3, TECH_DATA = 2)
	materials = list("metal" = 30)
	build_path = /obj/item/weapon/stock_parts/manipulator/nano
	sort_string = "CAABB"

/datum/design/item/stock_part/pico_mani
	id = "pico_mani"
	req_tech = list(TECH_MATERIAL = 5, TECH_DATA = 2)
	materials = list("metal" = 30)
	build_path = /obj/item/weapon/stock_parts/manipulator/pico
	sort_string = "CAABC"

/datum/design/item/stock_part/basic_matter_bin
	id = "basic_matter_bin"
	req_tech = list(TECH_MATERIAL = 1)
	materials = list("metal" = 80)
	build_path = /obj/item/weapon/stock_parts/matter_bin
	sort_string = "CAACA"

/datum/design/item/stock_part/adv_matter_bin
	id = "adv_matter_bin"
	req_tech = list(TECH_MATERIAL = 3)
	materials = list("metal" = 80)
	build_path = /obj/item/weapon/stock_parts/matter_bin/adv
	sort_string = "CAACB"

/datum/design/item/stock_part/super_matter_bin
	id = "super_matter_bin"
	req_tech = list(TECH_MATERIAL = 5)
	materials = list("metal" = 80)
	build_path = /obj/item/weapon/stock_parts/matter_bin/super
	sort_string = "CAACC"

/datum/design/item/stock_part/basic_micro_laser
	id = "basic_micro_laser"
	req_tech = list(TECH_MAGNET = 1)
	materials = list("metal" = 10, "glass" = 20)
	build_path = /obj/item/weapon/stock_parts/micro_laser
	sort_string = "CAADA"

/datum/design/item/stock_part/high_micro_laser
	id = "high_micro_laser"
	req_tech = list(TECH_MAGNET = 3)
	materials = list("metal" = 10, "glass" = 20)
	build_path = /obj/item/weapon/stock_parts/micro_laser/high
	sort_string = "CAADB"

/datum/design/item/stock_part/ultra_micro_laser
	id = "ultra_micro_laser"
	req_tech = list(TECH_MAGNET = 5, TECH_MATERIAL = 5)
	materials = list("metal" = 10, "glass" = 20, "uranium" = 10)
	build_path = /obj/item/weapon/stock_parts/micro_laser/ultra
	sort_string = "CAADC"

/datum/design/item/stock_part/basic_sensor
	id = "basic_sensor"
	req_tech = list(TECH_MAGNET = 1)
	materials = list("metal" = 50, "glass" = 20)
	build_path = /obj/item/weapon/stock_parts/scanning_module
	sort_string = "CAAEA"

/datum/design/item/stock_part/adv_sensor
	id = "adv_sensor"
	req_tech = list(TECH_MAGNET = 3)
	materials = list("metal" = 50, "glass" = 20)
	build_path = /obj/item/weapon/stock_parts/scanning_module/adv
	sort_string = "CAAEB"

/datum/design/item/stock_part/phasic_sensor
	id = "phasic_sensor"
	req_tech = list(TECH_MAGNET = 5, TECH_MATERIAL = 3)
	materials = list("metal" = 50, "glass" = 20, "silver" = 10)
	build_path = /obj/item/weapon/stock_parts/scanning_module/phasic
	sort_string = "CAAEC"

/datum/design/item/stock_part/RPED
	name = "Rapid Part Exchange Device"
	desc = "Special mechanical module made to store, sort, and apply standard machine parts."
	id = "rped"
	req_tech = list(TECH_ENGINERING = 3, TECH_MATERIAL = 3)
	materials = list("metal" = 15000, "glass" = 5000)
	build_path = /obj/item/weapon/storage/part_replacer
	sort_string = "CBAAA"

/datum/design/item/powercell
	build_type = PROTOLATHE | MECHFAB

/datum/design/item/powercell/AssembleDesignName()
	name = "Power cell model ([item_name])"

/datum/design/item/powercell/AssembleDesignDesc()
	if(build_path)
		var/obj/item/weapon/cell/C = build_path
		desc = "Allows the construction of power cells that can hold [initial(C.maxcharge)] units of energy."

/datum/design/item/powercell/basic
	name = "basic"
	build_type = PROTOLATHE | MECHFAB
	id = "basic_cell"
	req_tech = list(TECH_POWER = 1)
	materials = list("metal" = 700, "glass" = 50)
	build_path = /obj/item/weapon/cell
	category = "Misc"
	sort_string = "DAAAA"

/datum/design/item/powercell/high
	name = "high-capacity"
	build_type = PROTOLATHE | MECHFAB
	id = "high_cell"
	req_tech = list(TECH_POWER = 2)
	materials = list("metal" = 700, "glass" = 60)
	build_path = /obj/item/weapon/cell/high
	category = "Misc"
	sort_string = "DAAAB"

/datum/design/item/powercell/super
	name = "super-capacity"
	id = "super_cell"
	req_tech = list(TECH_POWER = 3, TECH_MATERIAL = 2)
	materials = list("metal" = 700, "glass" = 70)
	build_path = /obj/item/weapon/cell/super
	category = "Misc"
	sort_string = "DAAAC"

/datum/design/item/powercell/hyper
	name = "hyper-capacity"
	id = "hyper_cell"
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	materials = list("metal" = 400, "gold" = 150, "silver" = 150, "glass" = 70)
	build_path = /obj/item/weapon/cell/hyper
	category = "Misc"
	sort_string = "DAAAD"

/datum/design/item/hud
	materials = list("metal" = 50, "glass" = 50)

/datum/design/item/hud/AssembleDesignName()
	..()
	name = "HUD glasses prototype ([item_name])"

/datum/design/item/hud/AssembleDesignDesc()
	desc = "Allows for the construction of \a [item_name] HUD glasses."

/datum/design/item/hud/health
	name = "health scanner"
	id = "health_hud"
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 3)
	build_path = /obj/item/clothing/glasses/hud/health
	sort_string = "GAAAA"

/datum/design/item/hud/security
	name = "security records"
	id = "security_hud"
	req_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 2)
	build_path = /obj/item/clothing/glasses/hud/security
	sort_string = "GAAAB"

/datum/design/item/mesons
	name = "Optical meson scanners design"
	desc = "Using the meson-scanning technology those glasses allow you to see through walls, floor or anything else."
	id = "mesons"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINERING = 2)
	materials = list("metal" = 50, "glass" = 50)
	build_path = /obj/item/clothing/glasses/meson
	sort_string = "GAAAC"

/datum/design/item/weapon/mining/AssembleDesignName()
	..()
	name = "Mining equipment design ([item_name])"

/datum/design/item/weapon/mining/jackhammer
	id = "jackhammer"
	req_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_ENGINERING = 2)
	materials = list("metal" = 2000, "glass" = 500, "silver" = 500)
	build_path = /obj/item/weapon/pickaxe/jackhammer
	sort_string = "KAAAA"

/datum/design/item/weapon/mining/drill
	id = "drill"
	req_tech = list(TECH_MATERIAL = 2, TECH_POWER = 3, TECH_ENGINERING = 2)
	materials = list("metal" = 6000, "glass" = 1000) //expensive, but no need for miners.
	build_path = /obj/item/weapon/pickaxe/drill
	sort_string = "KAAAB"

/datum/design/item/weapon/mining/plasmacutter
	id = "plasmacutter"
	req_tech = list(TECH_MATERIAL = 4, TECH_PHORON = 3, TECH_ENGINERING = 3)
	materials = list("metal" = 1500, "glass" = 500, "gold" = 500, "phoron" = 500)
	build_path = /obj/item/weapon/pickaxe/plasmacutter
	sort_string = "KAAAC"

/datum/design/item/weapon/mining/pick_diamond
	id = "pick_diamond"
	req_tech = list(TECH_MATERIAL = 6)
	materials = list("diamond" = 3000)
	build_path = /obj/item/weapon/pickaxe/diamond
	sort_string = "KAAAD"

/datum/design/item/weapon/mining/drill_diamond
	id = "drill_diamond"
	req_tech = list(TECH_MATERIAL = 6, TECH_POWER = 4, TECH_ENGINERING = 4)
	materials = list("metal" = 3000, "glass" = 1000, "diamond" = 2000)
	build_path = /obj/item/weapon/pickaxe/diamonddrill
	sort_string = "KAAAE"
///////////////////////////////////
/////////Shield Generators/////////
///////////////////////////////////
datum/design/circuit/shield
	req_tech = list("bluespace" = 4, "phorontech" = 3)
	materials = list("$glass" = 2000, "sacid" = 20, "$phoron" = 10000, "$diamond" = 5000, "$gold" = 10000)

/datum/design/item/medical
	materials = list("metal" = 30, "glass" = 20)

/datum/design/item/medical/AssembleDesignName()
	..()
	name = "Biotech device prototype ([item_name])"

/datum/design/item/medical/robot_scanner
	desc = "A hand-held scanner able to diagnose robotic injuries."
	id = "robot_scanner"
	req_tech = list(TECH_MAGNET = 3, TECH_BIO = 2, TECH_ENGINERING = 3)
	materials = list("metal" = 500, "glass" = 200)
	build_path = /obj/item/device/robotanalyzer
	sort_string = "MACFA"

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

/datum/design/item/beaker/AssembleDesignName()
	name = "Beaker prototype ([item_name])"

/datum/design/item/beaker/noreact
	name = "cryostasis"
	desc = "A cryostasis beaker that allows for chemical storage without reactions. Can hold up to 50 units."
	id = "splitbeaker"
	req_tech = list(TECH_MATERIAL = 2)
	materials = list("metal" = 3000)
	build_path = /obj/item/weapon/reagent_containers/glass/beaker/noreact
	sort_string = "MADAA"

/datum/design/item/beaker/bluespace
	name = TECH_BLUESPACE
	desc = "A bluespace beaker, powered by experimental bluespace technology and Element Cuban combined with the Compound Pete. Can hold up to 300 units."
	id = "bluespacebeaker"
	req_tech = list(TECH_BLUESPACE = 2, TECH_MATERIAL = 6)
	materials = list("metal" = 3000, "phoron" = 3000, "diamond" = 500)
	build_path = /obj/item/weapon/reagent_containers/glass/beaker/bluespace
	sort_string = "MADAB"

/datum/design/item/medical/nanopaste
	desc = "A tube of paste containing swarms of repair nanites. Very effective in repairing robotic machinery."
	id = "nanopaste"
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINERING = 3)
	materials = list("metal" = 7000, "glass" = 7000)
	build_path = /obj/item/stack/nanopaste
	sort_string = "MBAAA"

/datum/design/item/scalpel_laser1
	name = "Basic Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. This one looks basic and could be improved."
	id = "scalpel_laser1"
	req_tech = list(TECH_BIO = 2, TECH_MATERIAL = 2, TECH_MAGNET = 2)
	materials = list("metal" = 12500, "glass" = 7500)
	build_path = /obj/item/weapon/scalpel/laser1
	sort_string = "MBBAA"

/datum/design/item/scalpel_laser2
	name = "Improved Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. This one looks somewhat advanced."
	id = "scalpel_laser2"
	req_tech = list(TECH_BIO = 3, TECH_MATERIAL = 4, TECH_MAGNET = 4)
	materials = list("metal" = 12500, "glass" = 7500, "silver" = 2500)
	build_path = /obj/item/weapon/scalpel/laser2
	sort_string = "MBBAB"

/datum/design/item/scalpel_laser3
	name = "Advanced Laser Scalpel"
	desc = "A scalpel augmented with a directed laser, for more precise cutting without blood entering the field. This one looks to be the pinnacle of precision energy cutlery!"
	id = "scalpel_laser3"
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 6, TECH_MAGNET = 5)
	materials = list("metal" = 12500, "glass" = 7500, "silver" = 2000, "gold" = 1500)
	build_path = /obj/item/weapon/scalpel/laser3
	sort_string = "MBBAC"

/datum/design/item/scalpel_manager
	name = "Incision Management System"
	desc = "A true extension of the surgeon's body, this marvel instantly and completely prepares an incision allowing for the immediate commencement of therapeutic steps."
	id = "scalpel_manager"
	req_tech = list(TECH_BIO = 4, TECH_MATERIAL = 7, TECH_MAGNET = 5, TECH_DATA = 4)
	materials = list ("metal" = 12500, "glass" = 7500, "silver" = 1500, "gold" = 1500, "diamond" = 750)
	build_path = /obj/item/weapon/scalpel/manager
	sort_string = "MBBAD"

/datum/design/item/implant
	materials = list("metal" = 50, "glass" = 50)

/datum/design/item/implant/AssembleDesignName()
	..()
	name = "Implantable biocircuit design ([item_name])"

/datum/design/item/implant/chemical
	name = "chemical"
	id = "implant_chem"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3)
	build_path = /obj/item/weapon/implantcase/chem
	sort_string = "MFAAA"

/datum/design/item/implant/freedom
	name = "freedom"
	id = "implant_free"
	req_tech = list(TECH_ILLEGAL = 2, TECH_BIO = 3)
	build_path = /obj/item/weapon/implantcase/freedom
	sort_string = "MFAAB"

/datum/design/item/weapon/AssembleDesignName()
	..()
	name = "Weapon prototype ([item_name])"

/datum/design/item/weapon/AssembleDesignDesc()
	if(!desc)
		if(build_path)
			var/obj/item/I = build_path
			desc = initial(I.desc)
		..()

/datum/design/item/weapon/stunrevolver
	id = "stunrevolver"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list("metal" = 4000)
	build_path = /obj/item/weapon/gun/energy/stunrevolver
	sort_string = "TAAAA"

/datum/design/item/weapon/nuclear_gun
	id = "nuclear_gun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_POWER = 3)
	materials = list("metal" = 5000, "glass" = 1000, "uranium" = 500)
	build_path = /obj/item/weapon/gun/energy/gun/nuclear
	sort_string = "TAAAB"

/datum/design/item/weapon/lasercannon
	desc = "The lasing medium of this prototype is enclosed in a tube lined with uranium-235 and subjected to high neutron flux in a nuclear reactor core."
	id = "lasercannon"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_POWER = 3)
	materials = list("metal" = 10000, "glass" = 1000, "diamond" = 2000)
	build_path = /obj/item/weapon/gun/energy/lasercannon
	sort_string = "TAAAC"

/datum/design/item/weapon/phoronpistol
	id = "ppistol"
	req_tech = list(TECH_COMBAT = 5, TECH_PHORON = 4)
	materials = list("metal" = 5000, "glass" = 1000, "phoron" = 3000)
	build_path = /obj/item/weapon/gun/energy/toxgun
	sort_string = "TAAAD"

/datum/design/item/weapon/decloner
	id = "decloner"
	req_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 7, TECH_BIO = 5, TECH_POWER = 6)
	materials = list("gold" = 5000,"uranium" = 10000, "mutagen" = 40)
	build_path = /obj/item/weapon/gun/energy/decloner
	sort_string = "TAAAE"

/datum/design/item/weapon/smg
	id = "smg"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3)
	materials = list("metal" = 8000, "silver" = 2000, "diamond" = 1000)
	build_path = /obj/item/weapon/gun/projectile/automatic
	sort_string = "TAABA"

/datum/design/item/weapon/ammo_9mm
	id = "ammo_9mm"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3)
	materials = list("metal" = 3750, "silver" = 100)
	build_path = /obj/item/ammo_magazine/c9mm
	sort_string = "TAACA"

/datum/design/item/weapon/stunshell
	desc = "A stunning shell for a shotgun."
	id = "stunshell"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	materials = list("metal" = 4000)
	build_path = /obj/item/ammo_casing/shotgun/stunshell
	sort_string = "TAACB"

/datum/design/item/weapon/chemsprayer
	desc = "An advanced chem spraying device."
	id = "chemsprayer"
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINERING = 3, TECH_BIO = 2)
	materials = list("metal" = 5000, "glass" = 1000)
	build_path = /obj/item/weapon/reagent_containers/spray/chemsprayer
	sort_string = "TABAA"

/datum/design/item/weapon/rapidsyringe
	id = "rapidsyringe"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_ENGINERING = 3, TECH_BIO = 2)
	materials = list("metal" = 5000, "glass" = 1000)
	build_path = /obj/item/weapon/gun/launcher/syringe/rapid
	sort_string = "TABAB"

/datum/design/item/weapon/temp_gun
	desc = "A gun that shoots high-powered glass-encased energy temperature bullets."
	id = "temp_gun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 4, TECH_POWER = 3, TECH_MAGNET = 2)
	materials = list("metal" = 5000, "glass" = 500, "silver" = 3000)
	build_path = /obj/item/weapon/gun/energy/temperature
	sort_string = "TABAC"

/datum/design/item/weapon/large_grenade
	id = "large_Grenade"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	materials = list("metal" = 3000)
	build_path = /obj/item/weapon/grenade/chem_grenade/large
	sort_string = "TACAA"

/datum/design/item/weapon/flora_gun
	id = "flora_gun"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_POWER = 3)
	materials = list("metal" = 2000, "glass" = 500, "uranium" = 500)
	build_path = /obj/item/weapon/gun/energy/floragun
	sort_string = "TBAAA"

/datum/design/item/stock_part/subspace_ansible
	id = "s-ansible"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list("metal" = 80, "silver" = 20)
	build_path = /obj/item/weapon/stock_parts/subspace/ansible
	sort_string = "UAAAA"

/datum/design/item/stock_part/hyperwave_filter
	id = "s-filter"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 3)
	materials = list("metal" = 40, "silver" = 10)
	build_path = /obj/item/weapon/stock_parts/subspace/filter
	sort_string = "UAAAB"

/datum/design/item/stock_part/subspace_amplifier
	id = "s-amplifier"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list("metal" = 10, "gold" = 30, "uranium" = 15)
	build_path = /obj/item/weapon/stock_parts/subspace/amplifier
	sort_string = "UAAAC"

/datum/design/item/stock_part/subspace_treatment
	id = "s-treatment"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 2, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list("metal" = 10, "silver" = 20)
	build_path = /obj/item/weapon/stock_parts/subspace/treatment
	sort_string = "UAAAD"

/datum/design/item/stock_part/subspace_analyzer
	id = "s-analyzer"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list("metal" = 10, "gold" = 15)
	build_path = /obj/item/weapon/stock_parts/subspace/analyzer
	sort_string = "UAAAE"

/datum/design/item/stock_part/subspace_crystal
	id = "s-crystal"
	req_tech = list(TECH_MAGNET = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2)
	materials = list("glass" = 1000, "silver" = 20, "gold" = 20)
	build_path = /obj/item/weapon/stock_parts/subspace/crystal
	sort_string = "UAAAF"

/datum/design/item/stock_part/subspace_transmitter
	id = "s-transmitter"
	req_tech = list(TECH_MAGNET = 5, TECH_MATERIAL = 5, TECH_BLUESPACE = 3)
	materials = list("glass" = 100, "silver" = 10, "uranium" = 15)
	build_path = /obj/item/weapon/stock_parts/subspace/transmitter
	sort_string = "UAAAG"

/datum/design/item/light_replacer
	name = "Light replacer"
	desc = "A device to automatically replace lights. Refill with working lightbulbs."
	id = "light_replacer"
	req_tech = list(TECH_MAGNET = 3, TECH_MATERIAL = 4)
	materials = list("metal" = 1500, "silver" = 150, "glass" = 3000)
	build_path = /obj/item/device/lightreplacer
	sort_string = "VAAAH"

/datum/design/item/paicard
	name = "'pAI', personal artificial intelligence device"
	id = "paicard"
	req_tech = list(TECH_DATA = 2)
	materials = list("glass" = 500, "metal" = 500)
	build_path = /obj/item/device/paicard
	sort_string = "VABAI"

/datum/design/item/intellicard
	name = "'intelliCard', AI preservation and transportation system"
	desc = "Allows for the construction of an intelliCard."
	id = "intellicard"
	req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 4)
	materials = list("glass" = 1000, "gold" = 200)
	build_path = /obj/item/device/aicard
	sort_string = "VACAA"

/datum/design/item/posibrain
	id = "posibrain"
	req_tech = list(TECH_ENGINERING = 4, TECH_MATERIAL = 6, TECH_BLUESPACE = 2, TECH_DATA = 4)
	materials = list("metal" = 2000, "glass" = 1000, "silver" = 1000, "gold" = 500, "phoron" = 500, "diamond" = 100)
	build_path = /obj/item/device/mmi/digital/posibrain
	sort_string = "VACAB"

/datum/design/item/medical/mmi
	id = "mmi"
	req_tech = list(TECH_DATA = 2, TECH_BIO = 3)
	build_type = PROTOLATHE | MECHFAB
	materials = list("metal" = 1000, "glass" = 500)
	build_path = /obj/item/device/mmi
	category = "Misc"
	sort_string = "VACBA"

/datum/design/item/medical/mmi_radio
	id = "mmi_radio"
	req_tech = list(TECH_DATA = 2, TECH_BIO = 4)
	build_type = PROTOLATHE | MECHFAB
	materials = list("metal" = 1200, "glass" = 500)
	build_path = /obj/item/device/mmi/radio_enabled
	category = "Misc"
	sort_string = "VACBB"

/datum/design/item/beacon
	name = "Bluespace tracking beacon design"
	id = "beacon"
	req_tech = list(TECH_BLUESPACE = 1)
	materials = list ("metal" = 20, "glass" = 10)
	build_path = /obj/item/device/radio/beacon
	sort_string = "VADAA"

/datum/design/item/bag_holding
	name = "'Bag of Holding', an infinite capacity bag prototype"
	desc = "Using localized pockets of bluespace this bag prototype offers incredible storage capacity with the contents weighting nothing. It's a shame the bag itself is pretty heavy."
	id = "bag_holding"
	req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 6)
	materials = list("gold" = 3000, "diamond" = 1500, "uranium" = 250)
	build_path = /obj/item/weapon/storage/backpack/holding
	sort_string = "VAEAA"

/datum/design/item/binaryencrypt
	name = "Binary encryption key"
	desc = "Allows for deciphering the binary channel on-the-fly."
	id = "binaryencrypt"
	req_tech = list(TECH_ILLEGAL = 2)
	materials = list("metal" = 300, "glass" = 300)
	build_path = /obj/item/device/encryptionkey/binary
	sort_string = "VASAA"

/datum/design/item/chameleon
	name = "Holographic equipment kit"
	desc = "A kit of dangerous, high-tech equipment with changeable looks."
	id = "chameleon"
	req_tech = list(TECH_ILLEGAL = 2)
	materials = list("metal" = 500)
	build_path = /obj/item/weapon/storage/box/syndie_kit/chameleon
	sort_string = "VASBA"

/*
CIRCUITS BELOW
*/

/datum/design/circuit
	build_type = IMPRINTER
	req_tech = list(TECH_DATA = 2)
	materials = list("glass" = 2000)
	chemicals = list("sacid" = 20)
	time = 5

/datum/design/circuit/AssembleDesignName()
	..()
	if(build_path)
		var/obj/item/weapon/circuitboard/C = new build_path()
		if(C && istype(C))
			if(C.board_type == "machine")
				name = "Machine circuit design ([item_name])"
				qdel(C)
				return
			else if(C.board_type == "computer")
				name = "Computer circuit design ([item_name])"
				qdel(C)
				return
	name = "Circuit design ([item_name])"

/datum/design/circuit/AssembleDesignDesc()
	if(!desc)
		desc = "Allows for the construction of \a [item_name] circuit board."

/datum/design/circuit/arcademachine
	name = "arcade machine"
	id = "arcademachine"
	req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/weapon/circuitboard/arcade
	sort_string = "MAAAA"

/datum/design/circuit/seccamera
	name = "security camera monitor"
	id = "seccamera"
	build_path = /obj/item/weapon/circuitboard/security
	sort_string = "DAAAA"

/datum/design/circuit/secdata
	name = "security records console"
	id = "sec_data"
	build_path = /obj/item/weapon/circuitboard/secure_data
	sort_string = "DABAA"

/datum/design/circuit/prisonmanage
	name = "prisoner management console"
	id = "prisonmanage"
	build_path = /obj/item/weapon/circuitboard/prisoner
	sort_string = "DACAA"

/datum/design/circuit/med_data
	name = "medical records console"
	id = "med_data"
	build_path = /obj/item/weapon/circuitboard/med_data
	sort_string = "FAAAA"

/datum/design/circuit/operating
	name = "patient monitoring console"
	id = "operating"
	build_path = /obj/item/weapon/circuitboard/operating
	sort_string = "FACAA"

/datum/design/circuit/pandemic
	name = "PanD.E.M.I.C. 2200"
	id = "pandemic"
	build_path = /obj/item/weapon/circuitboard/pandemic
	sort_string = "FAEAA"

/datum/design/circuit/scan_console
	name = "DNA machine"
	id = "scan_console"
	build_path = /obj/item/weapon/circuitboard/scan_consolenew
	sort_string = "FAGAA"

/datum/design/circuit/clonecontrol
	name = "cloning control console"
	id = "clonecontrol"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/weapon/circuitboard/cloning
	sort_string = "FAGAC"

/datum/design/circuit/clonepod
	name = "clone pod"
	id = "clonepod"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/weapon/circuitboard/clonepod
	sort_string = "FAGAE"

/datum/design/circuit/clonescanner
	name = "cloning scanner"
	id = "clonescanner"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/weapon/circuitboard/clonescanner
	sort_string = "FAGAG"

/datum/design/circuit/crewconsole
	name = "crew monitoring console"
	id = "crewconsole"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 2, TECH_BIO = 2)
	build_path = /obj/item/weapon/circuitboard/crew
	sort_string = "FAGAI"

/datum/design/circuit/teleconsole
	name = "teleporter control console"
	id = "teleconsole"
	req_tech = list(TECH_DATA = 3, TECH_BLUESPACE = 2)
	build_path = /obj/item/weapon/circuitboard/teleporter
	sort_string = "HAAAA"

/datum/design/circuit/robocontrol
	name = "robotics control console"
	id = "robocontrol"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/weapon/circuitboard/robotics
	sort_string = "HAAAB"

/datum/design/circuit/mechacontrol
	name = "exosuit control console"
	id = "mechacontrol"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/weapon/circuitboard/mecha_control
	sort_string = "HAAAC"

/datum/design/circuit/mechapower
	name = "mech bay power control console"
	id = "mechapower"
	build_path = /obj/item/weapon/circuitboard/mech_bay_power_console
	sort_string = "HAAAD"

/datum/design/circuit/rdconsole
	name = "R&D control console"
	id = "rdconsole"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/weapon/circuitboard/rdconsole
	sort_string = "HAAAE"

/datum/design/circuit/aifixer
	name = "AI integrity restorer"
	id = "aifixer"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 2)
	build_path = /obj/item/weapon/circuitboard/aifixer
	sort_string = "HAAAF"

/datum/design/circuit/comm_monitor
	name = "telecommunications monitoring console"
	id = "comm_monitor"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/weapon/circuitboard/comm_monitor
	sort_string = "HAACA"

/datum/design/circuit/comm_server
	name = "telecommunications server monitoring console"
	id = "comm_server"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/weapon/circuitboard/comm_server
	sort_string = "HAACB"

/datum/design/circuit/message_monitor
	name = "messaging monitor console"
	id = "message_monitor"
	req_tech = list(TECH_DATA = 5)
	build_path = /obj/item/weapon/circuitboard/message_monitor
	sort_string = "HAACC"

/datum/design/circuit/aiupload
	name = "AI upload console"
	id = "aiupload"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/weapon/circuitboard/aiupload
	sort_string = "HAABA"

/datum/design/circuit/borgupload
	name = "cyborg upload console"
	id = "borgupload"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/weapon/circuitboard/borgupload
	sort_string = "HAABB"

/datum/design/circuit/destructive_analyzer
	name = "destructive analyzer"
	id = "destructive_analyzer"
	req_tech = list(TECH_DATA = 2, TECH_MAGNET = 2, TECH_ENGINERING = 2)
	build_path = /obj/item/weapon/circuitboard/destructive_analyzer
	sort_string = "HABAA"

/datum/design/circuit/protolathe
	name = "protolathe"
	id = "protolathe"
	req_tech = list(TECH_DATA = 2, TECH_ENGINERING = 2)
	build_path = /obj/item/weapon/circuitboard/protolathe
	sort_string = "HABAB"

/datum/design/circuit/circuit_imprinter
	name = "circuit imprinter"
	id = "circuit_imprinter"
	req_tech = list(TECH_DATA = 2, TECH_ENGINERING = 2)
	build_path = /obj/item/weapon/circuitboard/circuit_imprinter
	sort_string = "HABAC"

/datum/design/circuit/autolathe
	name = "autolathe board"
	id = "autolathe"
	req_tech = list(TECH_DATA = 2, TECH_ENGINERING = 2)
	build_path = /obj/item/weapon/circuitboard/autolathe
	sort_string = "HABAD"

/datum/design/circuit/rdservercontrol
	name = "R&D server control console"
	id = "rdservercontrol"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/weapon/circuitboard/rdservercontrol
	sort_string = "HABBA"

/datum/design/circuit/rdserver
	name = "R&D server"
	id = "rdserver"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/weapon/circuitboard/rdserver
	sort_string = "HABBB"

/datum/design/circuit/mechfab
	name = "exosuit fabricator"
	id = "mechfab"
	req_tech = list(TECH_DATA = 3, TECH_ENGINERING = 3)
	build_path = /obj/item/weapon/circuitboard/mechfab
	sort_string = "HABAE"

/datum/design/circuit/recharge_station
	name = "cyborg recharge station"
	id = "recharge_station"
	req_tech = list(TECH_DATA = 3, TECH_ENGINERING = 2)
	build_path = /obj/item/weapon/circuitboard/recharge_station
	sort_string = "HACAA"

/datum/design/circuit/atmosalerts
	name = "atmosphere alert console"
	id = "atmosalerts"
	build_path = /obj/item/weapon/circuitboard/atmos_alert
	sort_string = "JAAAA"

/datum/design/circuit/air_management
	name = "atmosphere monitoring console"
	id = "air_management"
	build_path = /obj/item/weapon/circuitboard/air_management
	sort_string = "JAAAB"

/datum/design/circuit/rcon_console
	name = "RCON remote control console"
	id = "rcon_console"
	req_tech = list(TECH_DATA = 4, TECH_ENGINERING = 3, TECH_POWER = 5)
	build_path = /obj/item/weapon/circuitboard/rcon_console
	sort_string = "JAAAC"

/datum/design/circuit/dronecontrol
	name = "drone control console"
	id = "dronecontrol"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/weapon/circuitboard/drone_control
	sort_string = "JAAAD"

/datum/design/circuit/powermonitor
	name = "power monitoring console"
	id = "powermonitor"
	build_path = /obj/item/weapon/circuitboard/powermonitor
	sort_string = "JAAAE"

/datum/design/circuit/solarcontrol
	name = "solar control console"
	id = "solarcontrol"
	build_path = /obj/item/weapon/circuitboard/solar_control
	sort_string = "JAAAF"

/datum/design/circuit/pacman
	name = "PACMAN-type generator"
	id = "pacman"
	req_tech = list(TECH_DATA = 3, TECH_PHORON = 3, TECH_POWER = 3, TECH_ENGINERING = 3)
	build_path = /obj/item/weapon/circuitboard/pacman
	sort_string = "JBAAA"

/datum/design/circuit/superpacman
	name = "SUPERPACMAN-type generator"
	id = "superpacman"
	req_tech = list(TECH_DATA = 3, TECH_POWER = 4, TECH_ENGINERING = 4)
	build_path = /obj/item/weapon/circuitboard/pacman/super
	sort_string = "JBAAB"

/datum/design/circuit/mrspacman
	name = "MRSPACMAN-type generator"
	id = "mrspacman"
	req_tech = list(TECH_DATA = 3, TECH_POWER = 5, TECH_ENGINERING = 5)
	build_path = /obj/item/weapon/circuitboard/pacman/mrs
	sort_string = "JBAAC"

/datum/design/circuit/batteryrack
	name = "cell rack PSU"
	id = "batteryrack"
	req_tech = list(TECH_POWER = 3, TECH_ENGINERING = 2)
	build_path = /obj/item/weapon/circuitboard/batteryrack
	sort_string = "JBABA"

/datum/design/circuit/smes_cell
	name = "'SMES' superconductive magnetic energy storage"
	desc = "Allows for the construction of circuit boards used to build a SMES."
	id = "smes_cell"
	req_tech = list(TECH_POWER = 7, TECH_ENGINERING = 5)
	build_path = /obj/item/weapon/circuitboard/smes
	sort_string = "JBABB"

/datum/design/circuit/gas_heater
	name = "gas heating system"
	id = "gasheater"
	req_tech = list(TECH_POWER = 2, TECH_ENGINERING = 1)
	build_path = /obj/item/weapon/circuitboard/unary_atmos/heater
	sort_string = "JCAAA"

/datum/design/circuit/gas_cooler
	name = "gas cooling system"
	id = "gascooler"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINERING = 2)
	build_path = /obj/item/weapon/circuitboard/unary_atmos/cooler
	sort_string = "JCAAB"

/datum/design/circuit/secure_airlock
	name = "secure airlock electronics"
	desc =  "Allows for the construction of a tamper-resistant airlock electronics."
	id = "securedoor"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/weapon/airlock_electronics/secure
	sort_string = "JDAAA"

/datum/design/circuit/ordercomp
	name = "supply ordering console"
	id = "ordercomp"
	build_path = /obj/item/weapon/circuitboard/ordercomp
	sort_string = "KAAAA"

/datum/design/circuit/supplycomp
	name = "supply control console"
	id = "supplycomp"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/weapon/circuitboard/supplycomp
	sort_string = "KAAAB"

/datum/design/circuit/biogenerator
	name = "biogenerator"
	id = "biogenerator"
	req_tech = list(TECH_DATA = 2)
	build_path = /obj/item/weapon/circuitboard/biogenerator
	sort_string = "KBAAA"

/datum/design/circuit/comconsole
	name = "communications console"
	id = "comconsole"
	build_path = /obj/item/weapon/circuitboard/communications
	sort_string = "LAAAA"

/datum/design/circuit/idcardconsole
	name = "ID card modification console"
	id = "idcardconsole"
	build_path = /obj/item/weapon/circuitboard/card
	sort_string = "LAAAB"

/datum/design/circuit/emp_data
	name = "employment records console"
	id = "emp_data"
	build_path = /obj/item/weapon/circuitboard/skills
	sort_string = "LAAAC"

/datum/design/circuit/mecha
	req_tech = list(TECH_DATA = 3)

/datum/design/circuit/mecha/AssembleDesignName()
	name = "Exosuit module circuit design ([name])"
/datum/design/circuit/mecha/AssembleDesignDesc()
	desc = "Allows for the construction of \a [name] module."

/datum/design/circuit/mecha/ripley_main
	name = "APLU 'Ripley' central control"
	id = "ripley_main"
	build_path = /obj/item/weapon/circuitboard/mecha/ripley/main
	sort_string = "NAAAA"

/datum/design/circuit/mecha/ripley_peri
	name = "APLU 'Ripley' peripherals control"
	id = "ripley_peri"
	build_path = /obj/item/weapon/circuitboard/mecha/ripley/peripherals
	sort_string = "NAAAB"

/datum/design/circuit/mecha/odysseus_main
	name = "'Odysseus' central control"
	id = "odysseus_main"
	req_tech = list(TECH_DATA = 3,TECH_BIO = 2)
	build_path = /obj/item/weapon/circuitboard/mecha/odysseus/main
	sort_string = "NAABA"

/datum/design/circuit/mecha/odysseus_peri
	name = "'Odysseus' peripherals control"
	id = "odysseus_peri"
	req_tech = list(TECH_DATA = 3,TECH_BIO = 2)
	build_path = /obj/item/weapon/circuitboard/mecha/odysseus/peripherals
	sort_string = "NAABB"

/datum/design/circuit/mecha/gygax_main
	name = "'Gygax' central control"
	id = "gygax_main"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/weapon/circuitboard/mecha/gygax/main
	sort_string = "NAACA"

/datum/design/circuit/mecha/gygax_peri
	name = "'Gygax' peripherals control"
	id = "gygax_peri"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/weapon/circuitboard/mecha/gygax/peripherals
	sort_string = "NAACB"

/datum/design/circuit/mecha/gygax_targ
	name = "'Gygax' weapon control and targeting"
	id = "gygax_targ"
	req_tech = list(TECH_DATA = 4, TECH_COMBAT = 2)
	build_path = /obj/item/weapon/circuitboard/mecha/gygax/targeting
	sort_string = "NAACC"

/datum/design/circuit/mecha/durand_main
	name = "'Durand' central control"
	id = "durand_main"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/weapon/circuitboard/mecha/durand/main
	sort_string = "NAADA"

/datum/design/circuit/mecha/durand_peri
	name = "'Durand' peripherals control"
	id = "durand_peri"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/weapon/circuitboard/mecha/durand/peripherals
	sort_string = "NAADB"

/datum/design/circuit/mecha/durand_targ
	name = "'Durand' weapon control and targeting"
	id = "durand_targ"
	req_tech = list(TECH_DATA = 4, TECH_COMBAT = 2)
	build_path = /obj/item/weapon/circuitboard/mecha/durand/targeting
	sort_string = "NAADC"

/datum/design/circuit/tcom
	req_tech = list(TECH_DATA = 4, TECH_ENGINERING = 4)

/datum/design/circuit/tcom/AssembleDesignName()
	name = "Telecommunications machinery circuit design ([name])"
/datum/design/circuit/tcom/AssembleDesignDesc()
	desc = "Allows for the construction of a telecommunications [name] circuit board."

/datum/design/circuit/tcom/server
	name = "server mainframe"
	id = "tcom-server"
	build_path = /obj/item/weapon/circuitboard/telecomms/server
	sort_string = "PAAAA"

/datum/design/circuit/tcom/processor
	name = "processor unit"
	id = "tcom-processor"
	build_path = /obj/item/weapon/circuitboard/telecomms/processor
	sort_string = "PAAAB"

/datum/design/circuit/tcom/bus
	name = "bus mainframe"
	id = "tcom-bus"
	build_path = /obj/item/weapon/circuitboard/telecomms/bus
	sort_string = "PAAAC"

/datum/design/circuit/tcom/hub
	name = "hub mainframe"
	id = "tcom-hub"
	build_path = /obj/item/weapon/circuitboard/telecomms/hub
	sort_string = "PAAAD"

/datum/design/circuit/tcom/relay
	name = "relay mainframe"
	id = "tcom-relay"
	req_tech = list(TECH_DATA = 3, TECH_ENGINERING = 4, TECH_BLUESPACE = 3)
	build_path = /obj/item/weapon/circuitboard/telecomms/relay
	sort_string = "PAAAE"

/datum/design/circuit/tcom/broadcaster
	name = "subspace broadcaster"
	id = "tcom-broadcaster"
	req_tech = list(TECH_DATA = 4, TECH_ENGINERING = 4, TECH_BLUESPACE = 2)
	build_path = /obj/item/weapon/circuitboard/telecomms/broadcaster
	sort_string = "PAAAF"

/datum/design/circuit/tcom/receiver
	name = "subspace receiver"
	id = "tcom-receiver"
	req_tech = list(TECH_DATA = 4, TECH_ENGINERING = 3, TECH_BLUESPACE = 2)
	build_path = /obj/item/weapon/circuitboard/telecomms/receiver
	sort_string = "PAAAG"

/datum/design/circuit/shield
	req_tech = list(TECH_BLUESPACE = 4, TECH_PHORON = 3)
	materials = list("glass" = 2000, "gold" = 1000)

/datum/design/circuit/shield/AssembleDesignName()
	name = "Shield generator circuit design ([name])"
/datum/design/circuit/shield/AssembleDesignDesc()
	if(!desc)
		desc = "Allows for the construction of \a [name] shield generator."

/datum/design/circuit/shield/bubble
	name = "bubble"
	id = "shield_gen"
	build_path = /obj/item/weapon/circuitboard/shield_gen
	sort_string = "VAAAA"

/datum/design/circuit/shield/hull
	name = "hull"
	id = "shield_gen_ex"
	build_path = /obj/item/weapon/circuitboard/shield_gen_ex
	sort_string = "VAAAB"

/datum/design/circuit/shield/capacitor
	name = "capacitor"
	desc = "Allows for the construction of a shield capacitor circuit board."
	id = "shield_cap"
	req_tech = list(TECH_MAGNET = 3, TECH_POWER = 4)
	build_path = /obj/item/weapon/circuitboard/shield_cap
	sort_string = "VAAAC"

/datum/design/circuit/aicore
	name = "AI core"
	id = "aicore"
	req_tech = list(TECH_DATA = 4, TECH_BIO = 3)
	build_path = /obj/item/weapon/circuitboard/aicore
	sort_string = "XAAAA"

/datum/design/aimodule
	build_type = IMPRINTER
	materials = list("glass" = 2000, "gold" = 100)

/datum/design/aimodule/AssembleDesignName()
	name = "AI module design ([name])"

/datum/design/aimodule/AssembleDesignDesc()
	desc = "Allows for the construction of \a '[name]' AI module."

/datum/design/aimodule/safeguard
	name = "Safeguard"
	id = "safeguard"
	req_tech = list(TECH_DATA = 3, TECH_MATERIAL = 4)
	build_path = /obj/item/weapon/aiModule/safeguard
	sort_string = "XABAA"

/datum/design/aimodule/onehuman
	name = "OneCrewMember"
	id = "onehuman"
	req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 6)
	build_path = /obj/item/weapon/aiModule/oneHuman
	sort_string = "XABAB"

/datum/design/aimodule/protectstation
	name = "ProtectStation"
	id = "protectstation"
	req_tech = list(TECH_DATA = 3, TECH_MATERIAL = 6)
	build_path = /obj/item/weapon/aiModule/protectStation
	sort_string = "XABAC"

/datum/design/aimodule/notele
	name = "TeleporterOffline"
	id = "notele"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/weapon/aiModule/teleporterOffline
	sort_string = "XABAD"

/datum/design/aimodule/quarantine
	name = "Quarantine"
	id = "quarantine"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 2, TECH_MATERIAL = 4)
	build_path = /obj/item/weapon/aiModule/quarantine
	sort_string = "XABAE"

/datum/design/aimodule/oxygen
	name = "OxygenIsToxicToHumans"
	id = "oxygen"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 2, TECH_MATERIAL = 4)
	build_path = /obj/item/weapon/aiModule/oxygen
	sort_string = "XABAF"

/datum/design/aimodule/freeform
	name = "Freeform"
	id = "freeform"
	req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 4)
	build_path = /obj/item/weapon/aiModule/freeform
	sort_string = "XABAG"

/datum/design/aimodule/reset
	name = "Reset"
	id = "reset"
	req_tech = list(TECH_DATA = 3, TECH_MATERIAL = 6)
	build_path = /obj/item/weapon/aiModule/reset
	sort_string = "XAAAA"

/datum/design/aimodule/purge
	name = "Purge"
	id = "purge"
	req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 6)
	build_path = /obj/item/weapon/aiModule/purge
	sort_string = "XAAAB"

// Core modules
/datum/design/aimodule/core
	req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 6)

/datum/design/aimodule/core/AssembleDesignName()
	name = "AI core module design ([name])"

/datum/design/aimodule/core/AssembleDesignDesc()
	desc = "Allows for the construction of \a '[name]' AI core module."

/datum/design/aimodule/core/freeformcore
	name = "Freeform"
	id = "freeformcore"
	build_path = /obj/item/weapon/aiModule/freeformcore
	sort_string = "XACAA"

/datum/design/aimodule/core/asimov
	name = "Asimov"
	id = "asimov"
	build_path = /obj/item/weapon/aiModule/asimov
	sort_string = "XACAB"

/datum/design/aimodule/core/paladin
	name = "P.A.L.A.D.I.N."
	id = "paladin"
	build_path = /obj/item/weapon/aiModule/paladin
	sort_string = "XACAC"

/datum/design/aimodule/core/tyrant
	name = "T.Y.R.A.N.T."
	id = "tyrant"
	req_tech = list(TECH_DATA = 4, TECH_ILLEGAL = 2, TECH_MATERIAL = 6)
	build_path = /obj/item/weapon/aiModule/tyrant
	sort_string = "XACAD"

/datum/design/item/pda
	name = "PDA design"
	desc = "Cheaper than whiny non-digital assistants."
	id = "pda"
	req_tech = list(TECH_ENGINERING = 2, TECH_POWER = 3)
	materials = list("metal" = 50, "glass" = 50)
	build_path = /obj/item/device/pda
	sort_string = "VAAAA"

// Cartridges
/datum/design/item/pda_cartridge
	req_tech = list(TECH_ENGINERING = 2, TECH_POWER = 3)
	materials = list("metal" = 50, "glass" = 50)

/datum/design/item/pda_cartridge/AssembleDesignName()
	..()
	name = "PDA accessory ([item_name])"

/datum/design/item/pda_cartridge/cart_basic
	id = "cart_basic"
	build_path = /obj/item/weapon/cartridge
	sort_string = "VBAAA"

/datum/design/item/pda_cartridge/engineering
	id = "cart_engineering"
	build_path = /obj/item/weapon/cartridge/engineering
	sort_string = "VBAAB"

/datum/design/item/pda_cartridge/atmos
	id = "cart_atmos"
	build_path = /obj/item/weapon/cartridge/atmos
	sort_string = "VBAAC"

/datum/design/item/pda_cartridge/medical
	id = "cart_medical"
	build_path = /obj/item/weapon/cartridge/medical
	sort_string = "VBAAD"

/datum/design/item/pda_cartridge/chemistry
	id = "cart_chemistry"
	build_path = /obj/item/weapon/cartridge/chemistry
	sort_string = "VBAAE"

/datum/design/item/pda_cartridge/security
	id = "cart_security"
	build_path = /obj/item/weapon/cartridge/security
	sort_string = "VBAAF"

/datum/design/item/pda_cartridge/janitor
	id = "cart_janitor"
	build_path = /obj/item/weapon/cartridge/janitor
	sort_string = "VBAAG"

/datum/design/item/pda_cartridge/science
	id = "cart_science"
	build_path = /obj/item/weapon/cartridge/signal/science
	sort_string = "VBAAH"

/datum/design/item/pda_cartridge/quartermaster
	id = "cart_quartermaster"
	build_path = /obj/item/weapon/cartridge/quartermaster
	sort_string = "VBAAI"

/datum/design/item/pda_cartridge/hop
	id = "cart_hop"
	build_path = /obj/item/weapon/cartridge/hop
	sort_string = "VBAAJ"

/datum/design/item/pda_cartridge/hos
	id = "cart_hos"
	build_path = /obj/item/weapon/cartridge/hos
	sort_string = "VBAAK"

/datum/design/item/pda_cartridge/ce
	id = "cart_ce"
	build_path = /obj/item/weapon/cartridge/ce
	sort_string = "VBAAL"

/datum/design/item/pda_cartridge/cmo
	id = "cart_cmo"
	build_path = /obj/item/weapon/cartridge/cmo
	sort_string = "VBAAM"

/datum/design/item/pda_cartridge/rd
	id = "cart_rd"
	build_path = /obj/item/weapon/cartridge/rd
	sort_string = "VBAAN"

/datum/design/item/pda_cartridge/captain
	id = "cart_captain"
	build_path = /obj/item/weapon/cartridge/captain
	sort_string = "VBAAO"

/*
MECHAS BELOW
*/

/datum/design/item/mecha
	build_type = MECHFAB
	req_tech = list(TECH_COMBAT = 3)
	category = "Exosuit Equipment"

/datum/design/item/mecha/AssembleDesignName()
	..()
	name = "Exosuit module design ([item_name])"

/datum/design/item/mecha/weapon/AssembleDesignName()
	..()
	name = "Exosuit weapon design ([item_name])"

/datum/design/item/mecha/AssembleDesignDesc()
	if(!desc)
		desc = "Allows for the construction of \a '[item_name]' exosuit module."

// *** Weapon modules
/datum/design/item/mecha/weapon/scattershot
	id = "mech_scattershot"
	req_tech = list(TECH_COMBAT = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/scattershot

/datum/design/item/mecha/weapon/laser
	id = "mech_laser"
	req_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser

/datum/design/item/mecha/weapon/laser_rigged
	desc = "Allows for the construction of a welder-laser assembly package for non-combat exosuits."
	id = "mech_laser_rigged"
	req_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 2)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/riggedlaser

/datum/design/item/mecha/weapon/laser_heavy
	id = "mech_laser_heavy"
	req_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/heavy

/datum/design/item/mecha/weapon/ion
	id = "mech_ion"
	req_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/ion

/datum/design/item/mecha/weapon/grenade_launcher
	id = "mech_grenade_launcher"
	req_tech = list(TECH_COMBAT = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/flashbang

/datum/design/item/mecha/weapon/clusterbang_launcher
	desc = "A weapon that violates the Geneva Convention at 6 rounds per minute."
	id = "clusterbang_launcher"
	req_tech = list(TECH_COMBAT= 5, TECH_MATERIAL = 5, TECH_ILLEGAL = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/flashbang/clusterbang/limited

// *** Nonweapon modules
/datum/design/item/mecha/wormhole_gen
	desc = "An exosuit module that can generate small quasi-stable wormholes."
	id = "mech_wormhole_gen"
	req_tech = list(TECH_BLUESPACE = 3, TECH_MAGNET = 2)
	build_path = /obj/item/mecha_parts/mecha_equipment/wormhole_generator

/datum/design/item/mecha/teleporter
	desc = "An exosuit module that allows teleportation to any position in view."
	id = "mech_teleporter"
	req_tech = list(TECH_BLUESPACE = 10, TECH_MAGNET = 5)
	build_path = /obj/item/mecha_parts/mecha_equipment/teleporter

/datum/design/item/mecha/rcd
	desc = "An exosuit-mounted rapid construction device."
	id = "mech_rcd"
	req_tech = list(TECH_MATERIAL = 4, TECH_BLUESPACE = 3, TECH_MAGNET = 4, TECH_POWER=4, TECH_ENGINERING = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/rcd

/datum/design/item/mecha/gravcatapult
	desc = "An exosuit-mounted gravitational catapult."
	id = "mech_gravcatapult"
	req_tech = list(TECH_BLUESPACE = 2, TECH_MAGNET = 3, TECH_ENGINERING = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/gravcatapult

/datum/design/item/mecha/repair_droid
	desc = "Automated repair droid, exosuits' best companion. BEEP BOOP"
	id = "mech_repair_droid"
	req_tech = list(TECH_MAGNET = 3, TECH_DATA = 3, TECH_ENGINERING = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/repair_droid

/datum/design/item/mecha/phoron_generator
	desc = "Exosuit-mounted phoron generator."
	id = "mech_phoron_generator"
	req_tech = list(TECH_PHORON = 2, TECH_POWER= 2, TECH_ENGINERING = 2)
	build_path = /obj/item/mecha_parts/mecha_equipment/generator

/datum/design/item/mecha/energy_relay
	id = "mech_energy_relay"
	req_tech = list(TECH_MAGNET = 4, TECH_POWER = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/tesla_energy_relay

/datum/design/item/mecha/ccw_armor
	desc = "Exosuit close-combat armor booster."
	id = "mech_ccw_armor"
	req_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 4)
	build_path = /obj/item/mecha_parts/mecha_equipment/anticcw_armor_booster

/datum/design/item/mecha/proj_armor
	desc = "Exosuit projectile armor booster."
	id = "mech_proj_armor"
	req_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 5, TECH_ENGINERING=3)
	build_path = /obj/item/mecha_parts/mecha_equipment/antiproj_armor_booster

/datum/design/item/mecha/syringe_gun
	desc = "Exosuit-mounted syringe gun and chemical synthesizer."
	id = "mech_syringe_gun"
	req_tech = list(TECH_MATERIAL = 3, TECH_BIO=4, TECH_MAGNET=4, TECH_DATA=3)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/syringe_gun

/datum/design/item/mecha/diamond_drill
	desc = "A diamond version of the exosuit drill. It's harder, better, faster, stronger."
	id = "mech_diamond_drill"
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINERING = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/tool/drill/diamonddrill

/datum/design/item/mecha/generator_nuclear
	desc = "Exosuit-held nuclear reactor. Converts uranium and everyone's health to energy."
	id = "mech_generator_nuclear"
	req_tech = list(TECH_POWER= 3, TECH_ENGINERING = 3, TECH_MATERIAL = 3)
	build_path = /obj/item/mecha_parts/mecha_equipment/generator/nuclear

/datum/design/item/synthetic_flash
	id = "sflash"
	req_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 2)
	build_type = MECHFAB
	materials = list("metal" = 750, "glass" = 750)
	build_path = /obj/item/device/flash/synthetic
	category = "Misc"

/datum/design/item/borg_syndicate_module
	name = "Cyborg lethal weapons upgrade"
	desc = "Allows for the construction of lethal upgrades for cyborgs."
	id = "borg_syndicate_module"
	build_type = MECHFAB
	req_tech = list(TECH_COMBAT = 4, TECH_ILLEGAL = 3)
	build_path = /obj/item/borg/upgrade/syndicate
	category = "Cyborg Upgrade Modules"

/* Uncomment if someone makes these buildable
/datum/design/circuit/general_alert
	name = "general alert console"
	id = "general_alert"
	build_path = /obj/item/weapon/circuitboard/general_alert

// Removal of loyalty implants. Can't think of a way to add this to the config option.
/datum/design/item/implant/loyalty
	name = "loyalty"
	id = "implant_loyal"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3)
	materials = list("metal" = 7000, "glass" = 7000)
	build_path = /obj/item/weapon/implantcase/loyalty"

/datum/design/rust_core_control
	name = "Circuit Design (RUST core controller)"
	desc = "Allows for the construction of circuit boards used to build a core control console for the RUST fusion engine."
	id = "rust_core_control"
	req_tech = list("programming" = 4, "engineering" = 4)
	build_type = IMPRINTER
	materials = list("glass" = 2000, "sacid" = 20)
	build_path = "/obj/item/weapon/circuitboard/rust_core_control"

datum/design/rust_fuel_control
	name = "Circuit Design (RUST fuel controller)"
	desc = "Allows for the construction of circuit boards used to build a fuel injector control console for the RUST fusion engine."
	id = "rust_fuel_control"
	req_tech = list("programming" = 4, "engineering" = 4)
	build_type = IMPRINTER
	materials = list("glass" = 2000, "sacid" = 20)
	build_path = "/obj/item/weapon/circuitboard/rust_fuel_control"

datum/design/rust_fuel_port
	name = "Internal circuitry (RUST fuel port)"
	desc = "Allows for the construction of circuit boards used to build a fuel injection port for the RUST fusion engine."
	id = "rust_fuel_port"
	req_tech = list("engineering" = 4, "materials" = 5)
	build_type = IMPRINTER
	materials = list("glass" = 2000, "sacid" = 20, "uranium" = 3000)
	build_path = "/obj/item/weapon/module/rust_fuel_port"

datum/design/rust_fuel_compressor
	name = "Circuit Design (RUST fuel compressor)"
	desc = "Allows for the construction of circuit boards used to build a fuel compressor of the RUST fusion engine."
	id = "rust_fuel_compressor"
	req_tech = list("materials" = 6, "phorontech" = 4)
	build_type = IMPRINTER
	materials = list("glass" = 2000, "sacid" = 20, "phoron" = 3000, "diamond" = 1000)
	build_path = "/obj/item/weapon/module/rust_fuel_compressor"

datum/design/rust_core
	name = "Internal circuitry (RUST tokamak core)"
	desc = "The circuit board that for a RUST-pattern tokamak fusion core."
	id = "pacman"
	req_tech = list(bluespace = 3, phorontech = 4, magnets = 5, powerstorage = 6)
	build_type = IMPRINTER
	materials = list("glass" = 2000, "sacid" = 20, "phoron" = 3000, "diamond" = 2000)
	build_path = "/obj/item/weapon/circuitboard/rust_core"

datum/design/rust_injector
	name = "Internal circuitry (RUST tokamak core)"
	desc = "The circuit board that for a RUST-pattern particle accelerator."
	id = "pacman"
	req_tech = list(powerstorage = 3, engineering = 4, phorontech = 4, materials = 6)
	build_type = IMPRINTER
	materials = list("glass" = 2000, "sacid" = 20, "phoron" = 3000, "uranium" = 2000)
	build_path = "/obj/item/weapon/circuitboard/rust_core"
*/
