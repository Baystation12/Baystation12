/datum/design/item/hud/security
	name = "HUD security records"
	id = "security_hud"
	req_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 2)
	build_path = /obj/item/clothing/glasses/hud/security
	sort_string = "GAAAB"

/datum/design/item/optical
	materials = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)
	category_items = "Misc"

/datum/design/item/optical/mesons
	name = "optical mesons scanner"
	desc = "Using the meson-scanning technology those glasses allow you to see through walls, floor or anything else."
	id = "mesons"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/clothing/glasses/meson
	sort_string = "GBAAA"

/datum/design/item/optical/material
	name = "optical material scanner"
	id = "mesons_material"
	req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/clothing/glasses/material
	sort_string = "GBAAB"

/datum/design/item/optical/tactical
	name = "optical tactical scanner"
	id = "tactical_goggles"
	req_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50, "silver" = 50, "gold" = 50)
	build_path = /obj/item/clothing/glasses/tacgoggles
	sort_string = "GBAAC"

/datum/design/item/synthstorage/paicard
	name = "pAI"
	desc = "Personal Artificial Intelligence device."
	id = "paicard"
	req_tech = list(TECH_DATA = 2)
	materials = list("glass" = 500, DEFAULT_WALL_MATERIAL = 500)
	build_path = /obj/item/device/paicard
	sort_string = "VABAI"
	category_items = "Misc"

/datum/design/item/tool/light_replacer
	name = "light leplacer"
	desc = "A device to automatically replace lights. Refill with working lightbulbs."
	id = "light_replacer"
	req_tech = list(TECH_MAGNET = 3, TECH_MATERIAL = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 1500, "silver" = 150, "glass" = 3000)
	build_path = /obj/item/device/lightreplacer
	sort_string = "VAGAB"

/datum/design/item/advanced_light_replacer
	name = "advanced light replacer"
	desc = "A specialised light replacer which stores more lights and refills faster from boxes."
	id = "advanced_light_replacer"
	req_tech = list(TECH_MAGNET = 4, TECH_MATERIAL = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 1500, "silver" = 300, "glass" = 3000, "gold" = 100, "uranium" = 250)
	build_path =/obj/item/device/lightreplacer/advanced
	sort_string = "VAGAC"

/datum/design/item/tool/price_scanner
	name = "price scanner"
	desc = "Using an up-to-date database of various costs and prices, this device estimates the market price of an item up to 0.001% accuracy."
	id = "price_scanner"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 3000, "glass" = 3000, "silver" = 250)
	build_path = /obj/item/device/price_scanner
	sort_string = "VAGAG"

/datum/design/item/encryptionkey/AssembleDesignName()
	..()
	name = "Encryption [item_name] key"

/datum/design/item/encryptionkey/binary
	name = "binary"
	desc = "Allows for deciphering the binary channel on-the-fly."
	id = "binaryencrypt"
	req_tech = list(TECH_ILLEGAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 300, "glass" = 300)
	build_path = /obj/item/device/encryptionkey/binary
	sort_string = "VASAA"

/datum/design/item/camouflage/chameleon
	name = "holographic equipment kit"
	desc = "A kit of dangerous, high-tech equipment with changeable looks."
	id = "chameleon"
	req_tech = list(TECH_ILLEGAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 500)
	build_path = /obj/item/weapon/storage/backpack/chameleon/sydie_kit
	sort_string = "VASBA"