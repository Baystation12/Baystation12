/datum/design/item/biostorage/AssembleDesignName()
	..()
	name = "Biological intelligence storage ([item_name])"

/datum/design/item/biostorage/mmi
	name = "man-machine interface"
	id = "mmi"
	req_tech = list(TECH_BIO = 4, TECH_ENGINEERING = 4, TECH_DATA = 4)
	build_type = PROTOLATHE | MECHFAB
	materials = list(MATERIAL_STEEL = 1000, MATERIAL_GLASS = 500)
	build_path = /obj/item/organ/internal/mmi
	category = "Misc"
	sort_string = "VACCA"

/datum/design/item/biostorage/mmi_radio
	name = "radio-enabled man-machine interface"
	id = "mmi_radio"
	req_tech = list(TECH_BIO = 4, TECH_ENGINEERING = 4, TECH_DATA = 4)
	build_type = PROTOLATHE | MECHFAB
	materials = list(MATERIAL_ALUMINIUM = 1200, MATERIAL_GLASS = 500)
	build_path = /obj/item/organ/internal/mmi/radio
	category = "Misc"
	sort_string = "VACCB"