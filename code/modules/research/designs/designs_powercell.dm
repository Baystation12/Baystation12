/datum/design/item/powercell
	build_type = PROTOLATHE | MECHFAB
	category = "Misc"
	materials = list(MATERIAL_STEEL = 700, MATERIAL_GLASS = 50, MATERIAL_PLASTIC = 20)

/datum/design/item/powercell/AssembleDesignName()
	name = "Power cell model ([item_name])"

/datum/design/item/powercell/device/AssembleDesignName()
	name = "Device cell model ([item_name])"

/datum/design/item/powercell/AssembleDesignDesc()
	if(build_path)
		var/obj/item/weapon/cell/C = build_path
		desc = "Allows the construction of power cells that can hold [initial(C.maxcharge)] units of energy."

/datum/design/item/powercell/Fabricate()
	var/obj/item/weapon/cell/C = ..()
	C.charge = 0 //shouldn't produce power out of thin air.
	return C

/datum/design/item/powercell/basic
	name = "basic"
	id = "basic_cell"
	req_tech = list(TECH_POWER = 1)
	build_path = /obj/item/weapon/cell
	sort_string = "DAAAA"

/datum/design/item/powercell/high
	name = "high-capacity"
	id = "high_cell"
	req_tech = list(TECH_POWER = 2)
	build_path = /obj/item/weapon/cell/high
	sort_string = "DAAAB"

/datum/design/item/powercell/super
	name = "super-capacity"
	id = "super_cell"
	req_tech = list(TECH_POWER = 3, TECH_MATERIAL = 2)
	build_path = /obj/item/weapon/cell/super
	sort_string = "DAAAC"

/datum/design/item/powercell/hyper
	name = "hyper-capacity"
	id = "hyper_cell"
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	materials = list(MATERIAL_STEEL = 400, MATERIAL_GOLD = 150, MATERIAL_SILVER = 150, MATERIAL_GLASS = 70, MATERIAL_ALUMINIUM = 25)
	build_path = /obj/item/weapon/cell/hyper
	sort_string = "DAAAD"

/datum/design/item/powercell/device/standard
	name = "basic"
	id = "device_cell_standard"
	req_tech = list(TECH_POWER = 1)
	materials = list(MATERIAL_STEEL = 70, MATERIAL_GLASS = 5)
	build_path = /obj/item/weapon/cell/device/standard
	sort_string = "DAAAE"

/datum/design/item/powercell/device/high
	name = "high-capacity"
	build_type = PROTOLATHE | MECHFAB
	id = "device_cell_high"
	req_tech = list(TECH_POWER = 2)
	materials = list(MATERIAL_STEEL = 70, MATERIAL_GLASS = 6)
	build_path = /obj/item/weapon/cell/device/high
	sort_string = "DAAAF"