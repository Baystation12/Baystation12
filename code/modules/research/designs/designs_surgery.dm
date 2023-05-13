/datum/design/item/surgery/AssembleDesignName()
	..()
	name = "Surgical tool design ([item_name])"


/datum/design/item/surgery/scalpel_laser
	name = "Laser Scalpel"
	desc = "An advanced scalpel augmented with a directed laser, for more precise cutting without blood entering the field."
	id = "scalpel_laser"
	req_tech = list(TECH_BIO = 5, TECH_MATERIAL = 6, TECH_MAGNET = 4)
	materials = list(MATERIAL_STEEL = 12500, MATERIAL_GLASS = 7500, MATERIAL_SILVER = 2000, MATERIAL_GOLD = 1500)
	build_path = /obj/item/scalpel/laser
	sort_string = "MBEAA"

/datum/design/item/surgery/scalpel_ims
	name = "Incision Management System"
	desc = "A true extension of the surgeon's body, this marvel instantly and completely prepares an incision allowing for the immediate commencement of therapeutic steps."
	id = "scalpel_ims"
	req_tech = list(TECH_BIO = 6, TECH_MATERIAL = 7, TECH_MAGNET = 5, TECH_DATA = 5)
	materials = list (MATERIAL_STEEL = 12500, MATERIAL_GLASS = 7500, MATERIAL_SILVER = 1500, MATERIAL_GOLD = 1500, MATERIAL_DIAMOND = 750)
	build_path = /obj/item/scalpel/ims
	sort_string = "MBEAB"
