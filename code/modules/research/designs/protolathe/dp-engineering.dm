/datum/design/item/powercell
	build_type = PROTOLATHE | MECHFAB
	category = "Misc"
	category_items = "Engineering"

/datum/design/item/powercell/AssembleDesignDesc()
	if(build_path)
		var/obj/item/weapon/cell/C = build_path
		desc = "Allows the construction of power cells that can hold [initial(C.maxcharge)] units of energy."

/datum/design/item/powercell/Fabricate()
	var/obj/item/weapon/cell/C = ..()
	C.charge = 0 //shouldn't produce power out of thin air.
	return C

/datum/design/item/powercell/basic
	name = "basic cell"
	id = "basic_cell"
	req_tech = list(TECH_POWER = 1)
	materials = list(DEFAULT_WALL_MATERIAL = 700, "glass" = 50)
	build_path = /obj/item/weapon/cell
	sort_string = "DAAAA"

/datum/design/item/powercell/high
	name = "high-capacity cell"
	id = "high_cell"
	req_tech = list(TECH_POWER = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 700, "glass" = 60)
	build_path = /obj/item/weapon/cell/high
	sort_string = "DAAAB"

/datum/design/item/powercell/super
	name = "super-capacity cell"
	id = "super_cell"
	req_tech = list(TECH_POWER = 3, TECH_MATERIAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 700, "glass" = 70)
	build_path = /obj/item/weapon/cell/super
	sort_string = "DAAAC"

/datum/design/item/powercell/hyper
	name = "hyper-capacity cell"
	id = "hyper_cell"
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 400, "gold" = 150, "silver" = 150, "glass" = 70)
	build_path = /obj/item/weapon/cell/hyper
	sort_string = "DAAAD"

/datum/design/item/tool/airlock_brace
	name = "airlock brace"
	desc = "Special door attachment that can be used to provide extra security."
	id = "brace"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 50)
	build_path = /obj/item/weapon/airlock_brace
	sort_string = "VAGAD"
	category_items = "Engineering"

/datum/design/item/tool/brace_jack
	name = "maintenance jack"
	desc = "A special maintenance tool that can be used to remove airlock braces."
	id = "bracejack"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 120)
	build_path = /obj/item/weapon/crowbar/brace_jack
	sort_string = "VAGAE"
	category_items = "Engineering"

/datum/design/item/tool/clamp
	name = "stasis clamp"
	desc = "A magnetic clamp which can halt the flow of gas in a pipe, via a localised stasis field."
	id = "stasis_clamp"
	req_tech = list(TECH_ENGINEERING = 4, TECH_MAGNET = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 500, "glass" = 500)
	build_path = /obj/item/clamp
	sort_string = "VAGAF"
	category_items = "Engineering"

/datum/design/item/tool/experimental_welder
	name = "experimental welding tool"
	desc = "This welding tool feels heavier in your possession than is normal. There appears to be no external fuel port."
	id = "experimental_welder"
	req_tech = list(TECH_ENGINEERING = 5, TECH_PHORON = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 120, "glass" = 50)
	build_path = /obj/item/weapon/weldingtool/experimental
	sort_string = "VAGAH"
	category_items = "Engineering"

/datum/design/item/tool/shield_diffuser
	name = "portable shield diffuser"
	desc = "A small handheld device designed to disrupt energy barriers."
	id = "portable_shield_diffuser"
	req_tech = list(TECH_MAGNET = 5, TECH_POWER = 5, TECH_ILLEGAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 5000, "gold" = 2000, "silver" = 2000)
	build_path = /obj/item/weapon/shield_diffuser
	sort_string = "VAGAI"
	category_items = "Engineering"

// Superconductive magnetic coils
/datum/design/item/smes_coil
	category_items = "Engineering"

/datum/design/item/smes_coil
	desc = "A superconductive magnetic coil used to store power in magnetic fields."
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 2000, "gold" = 1000, "silver" = 1000)

/datum/design/item/smes_coil/standard
	id = "smes_coil_standard"
	req_tech = list(TECH_MATERIAL = 7, TECH_POWER = 7, TECH_ENGINEERING = 5)
	build_path = /obj/item/weapon/smes_coil
	sort_string = "VAXAA"

/datum/design/item/smes_coil/super_capacity
	id = "smes_coil_super_capacity"
	req_tech = list(TECH_MATERIAL = 7, TECH_POWER = 8, TECH_ENGINEERING = 6)
	build_path = /obj/item/weapon/smes_coil/super_capacity
	sort_string = "VAXAB"

/datum/design/item/smes_coil/super_io
	id = "smes_coil_super_io"
	req_tech = list(TECH_MATERIAL = 7, TECH_POWER = 8, TECH_ENGINEERING = 6)
	build_path = /obj/item/weapon/smes_coil/super_io
	sort_string = "VAXAC"