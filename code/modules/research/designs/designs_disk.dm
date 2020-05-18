/datum/design/item/disk/AssembleDesignName()
	..()
	name = "Storage disk ([item_name])"
	materials = list(MATERIAL_PLASTIC = 30, MATERIAL_STEEL = 30, MATERIAL_GLASS = 10)

/datum/design/item/disk/design
	name = "research design"
	desc = "Produce additional disks for storing device designs."
	id = "design_disk"
	req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/weapon/disk/design_disk
	sort_string = "AAAAA"

/datum/design/item/disk/tech
	name = "technology data"
	desc = "Produce additional disks for storing technology data."
	id = "tech_disk"
	req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/weapon/disk/tech_disk
	sort_string = "AAAAB"