/datum/design/item/hud
	materials = list(MATERIAL_ALUMINIUM = 50, MATERIAL_GLASS = 50)

/datum/design/item/hud/AssembleDesignName()
	..()
	name = "HUD glasses design ([item_name])"

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

/datum/design/item/hud/janitor
	name = "filth scanner"
	id = "janitor_hud"
	req_tech = list(TECH_BIO = 1, TECH_MAGNET = 3)
	build_path = /obj/item/clothing/glasses/hud/janitor
	sort_string = "GAAAC"

/datum/design/item/optical/AssembleDesignName()
	..()
	name = "Optical glasses design ([item_name])"
	materials = list(MATERIAL_STEEL = 50, MATERIAL_GLASS = 50)

/datum/design/item/optical/mesons
	name = "mesons"
	desc = "Using the meson-scanning technology those glasses allow you to see through walls, floor or anything else."
	id = "mesons"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/clothing/glasses/meson
	sort_string = "GBAAA"

/datum/design/item/optical/material
	name = "material"
	id = "mesons_material"
	req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/clothing/glasses/material
	sort_string = "GAAAB"

/datum/design/item/optical/tactical
	name = "tactical"
	id = "tactical_goggles"
	req_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 5)
	materials = list(MATERIAL_STEEL = 50, MATERIAL_GLASS = 50, MATERIAL_SILVER = 50, MATERIAL_GOLD = 50)
	build_path = /obj/item/clothing/glasses/tacgoggles
	sort_string = "GAAAC"