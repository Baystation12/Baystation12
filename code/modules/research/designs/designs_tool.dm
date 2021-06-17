/datum/design/item/tool/AssembleDesignName()
	..()
	name = "Tool design ([item_name])"

/datum/design/item/tool/light_replacer
	name = "light replacer"
	desc = "A device to automatically replace lights. Refill with working lightbulbs."
	id = "light_replacer"
	req_tech = list(TECH_MAGNET = 3, TECH_MATERIAL = 4)
	materials = list(MATERIAL_STEEL = 1500, MATERIAL_SILVER = 150, MATERIAL_GLASS = 3000)
	build_path = /obj/item/device/lightreplacer
	sort_string = "VAGAB"

/datum/design/item/tool/airlock_brace
	name = "airlock brace"
	desc = "Special door attachment that can be used to provide extra security."
	id = "brace"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 2)
	materials = list(MATERIAL_STEEL = 2000, MATERIAL_GLASS = 50)
	build_path = /obj/item/airlock_brace
	sort_string = "VAGAC"

/datum/design/item/tool/brace_jack
	name = "maintenance jack"
	desc = "A special maintenance tool that can be used to remove airlock braces."
	id = "bracejack"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 2)
	materials = list(MATERIAL_STEEL = 120)
	build_path = /obj/item/crowbar/brace_jack
	sort_string = "VAGAD"

/datum/design/item/tool/clamp
	name = "stasis clamp"
	desc = "A magnetic clamp which can halt the flow of gas in a pipe, via a localised stasis field."
	id = "stasis_clamp"
	req_tech = list(TECH_ENGINEERING = 4, TECH_MAGNET = 4)
	materials = list(MATERIAL_STEEL = 500, MATERIAL_GLASS = 500)
	build_path = /obj/item/clamp
	sort_string = "VAGAE"

/datum/design/item/tool/inducer
	name = "inducer"
	desc = "An electromagnetic inducer that can transfer power from one cell into another."
	id = "inducer"
	req_tech = list(TECH_POWER = 6, TECH_ENGINEERING = 4)
	materials = list(MATERIAL_STEEL = 2000, MATERIAL_GLASS = 100)
	build_path = /obj/item/inducer

/datum/design/item/tool/price_scanner
	name = "price scanner"
	desc = "Using an up-to-date database of various costs and prices, this device estimates the market price of an item up to 0.001% accuracy."
	id = "price_scanner"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 4)
	materials = list(MATERIAL_STEEL = 3000, MATERIAL_GLASS = 3000, MATERIAL_SILVER = 250)
	build_path = /obj/item/device/scanner/price
	sort_string = "VAGAF"

/datum/design/item/tool/experimental_welder
	name = "experimental welding tool"
	desc = "This welding tool feels heavier in your possession than is normal. There appears to be no external fuel port."
	id = "experimental_welder"
	req_tech = list(TECH_ENGINEERING = 5, TECH_PHORON = 4)
	materials = list(MATERIAL_STEEL = 120, MATERIAL_GLASS = 50)
	build_path = /obj/item/weldingtool/experimental
	sort_string = "VAGAG"

/datum/design/item/tool/shield_diffuser
	name = "portable shield diffuser"
	desc = "A small handheld device designed to disrupt energy barriers."
	id = "portable_shield_diffuser"
	req_tech = list(TECH_MAGNET = 5, TECH_POWER = 5, TECH_ESOTERIC = 2)
	materials = list(MATERIAL_STEEL = 5000, MATERIAL_GLASS = 5000, MATERIAL_GOLD = 2000, MATERIAL_SILVER = 2000)
	build_path = /obj/item/shield_diffuser
	sort_string = "VAGAH"

/datum/design/item/tool/rpd
	name = "rapid piping device"
	desc = "A compacted and complicated device, that relies on compressed matter to dispense piping on the move."
	id = "rpd"
	req_tech = list(TECH_ENGINEERING = 6, TECH_MATERIAL = 6)
	materials = list(MATERIAL_STEEL = 15000, MATERIAL_GLASS = 10000, MATERIAL_SILVER = 2000)
	build_path = /obj/item/rpd
	sort_string = "VAGAI"

/datum/design/item/tool/oxycandle
	name = "oxycandle"
	desc = "a device which, via a chemical reaction, can pressurise small areas."
	id="oxycandle"
	req_tech = list(TECH_ENGINEERING = 2)
	materials = list(MATERIAL_STEEL = 3000)
	chemicals = list(/datum/reagent/sodiumchloride = 20, /datum/reagent/acetone = 20)
	build_path = /obj/item/device/oxycandle
	sort_string = "VAGAJ"