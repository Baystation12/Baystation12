/datum/gear/eyes
	sort_category = "Glasses and Eyewear"
	category = /datum/gear/eyes
	slot = slot_glasses
	cost = 2


/datum/gear/eyes/glasses
	display_name = "Corrective Eyewear"
	description = "Simply corrects eyesight."
	path = /obj/item/clothing/glasses


/datum/gear/eyes/glasses/New()
	..()
	var/list/options = list()
	options["Basic Glasses"] = /obj/item/clothing/glasses/prescription
	options["Green Glasses"] = /obj/item/clothing/glasses/green
	options["Hipster Glasses"] = /obj/item/clothing/glasses/hipster
	options["Scanning Goggles"] = /obj/item/clothing/glasses/scanners
	gear_tweaks += new /datum/gear_tweak/path (options)


/datum/gear/eyes/science
	display_name = "Science Eyewear"
	description = "Provides research and chemical assessments."
	path = /obj/item/clothing/glasses


/datum/gear/eyes/science/New()
	..()
	var/list/options = list()
	options["Goggles"] = /obj/item/clothing/glasses/science
	options["Goggles, corrective"] = /obj/item/clothing/glasses/science/prescription
	options["HUD"] = /obj/item/clothing/glasses/hud/science
	options["HUD, corrective"] = /obj/item/clothing/glasses/hud/science/prescription
	gear_tweaks += new /datum/gear_tweak/path (options)


/datum/gear/eyes/security
	display_name = "Security Eyewear"
	description = "Provides security vision overlays."
	path = /obj/item/clothing/glasses


/datum/gear/eyes/security/New()
	..()
	var/list/options = list()
	options["HUD"] = /obj/item/clothing/glasses/hud/security
	options["HUD, corrective"] = /obj/item/clothing/glasses/hud/security/prescription
	options["Sunglasses"] = /obj/item/clothing/glasses/sunglasses/sechud
	options["Sunglasses, corrective"] = /obj/item/clothing/glasses/sunglasses/sechud/prescription
	options["Aviators"] = /obj/item/clothing/glasses/sunglasses/sechud/toggle
	options["Aviators, corrective"] = /obj/item/clothing/glasses/sunglasses/sechud/toggle/prescription
	options["Goggles"] = /obj/item/clothing/glasses/sunglasses/sechud/goggles
	options["Goggles, corrective"] = /obj/item/clothing/glasses/sunglasses/sechud/goggles/prescription
	options["Eyepatch"] = /obj/item/clothing/glasses/eyepatch/hud/security
	gear_tweaks += new /datum/gear_tweak/path (options)


/datum/gear/eyes/medical
	display_name = "Medical Eyewear"
	description = "Provides medical vision overlays."
	path = /obj/item/clothing/glasses


/datum/gear/eyes/medical/New()
	..()
	var/list/options = list()
	options["HUD"] = /obj/item/clothing/glasses/hud/health
	options["HUD, corrective"] = /obj/item/clothing/glasses/hud/health/prescription
	options["Visor"] = /obj/item/clothing/glasses/hud/health/visor
	options["Visor, corrective"] = /obj/item/clothing/glasses/hud/health/visor/prescription
	options["Eyepatch"] = /obj/item/clothing/glasses/eyepatch/hud/medical
	gear_tweaks += new /datum/gear_tweak/path (options)


/datum/gear/eyes/meson
	display_name = "Meson Eyewear"
	description = "Provides meson-vision."
	path = /obj/item/clothing/glasses


/datum/gear/eyes/meson/New()
	..()
	var/list/options = list()
	options["Goggles"] = /obj/item/clothing/glasses/meson
	options["Goggles, corrective"] = /obj/item/clothing/glasses/meson/prescription
	options["Eyepatch"] = /obj/item/clothing/glasses/eyepatch/hud/meson
	gear_tweaks += new /datum/gear_tweak/path (options)


/datum/gear/eyes/janitor
	display_name = "Sanitation Eyewear"
	description = "Provides filth-vision."
	path = /obj/item/clothing/glasses


/datum/gear/eyes/janitor/New()
	..()
	var/list/options = list()
	options["HUD"] = /obj/item/clothing/glasses/hud/janitor
	options["HUD, corrective"] = /obj/item/clothing/glasses/hud/janitor/prescription
	gear_tweaks += new /datum/gear_tweak/path (options)


/datum/gear/eyes/sunglasses
	display_name = "Anti-Glare Eyewear"
	description = "Provides basic bright light and flash protection."
	path = /obj/item/clothing/glasses


/datum/gear/eyes/sunglasses/New()
	..()
	var/list/options = list()
	options["Sunglasses"] = /obj/item/clothing/glasses/sunglasses
	options["Sunglasses, corrective"] = /obj/item/clothing/glasses/sunglasses/prescription
	options["Big Sunglasses"] = /obj/item/clothing/glasses/sunglasses/big
	options["Big Sunglasses, corrective"] = /obj/item/clothing/glasses/sunglasses/big/prescription
	options["Black Aviators"] = /obj/item/clothing/glasses/aviators_black
	options["Black Aviators, corrective"] = /obj/item/clothing/glasses/aviators_black/prescription
	options["Silver Aviators"] = /obj/item/clothing/glasses/aviators_silver
	options["Silver Aviators, corrective"] = /obj/item/clothing/glasses/aviators_silver/prescription
	options["Gold Aviators"] = /obj/item/clothing/glasses/aviators_gold
	options["Gold Aviators, corrective"] = /obj/item/clothing/glasses/aviators_gold/prescription
	options["Rose Aviators"] = /obj/item/clothing/glasses/aviators_rose
	options["Rose Aviators, corrective"] = /obj/item/clothing/glasses/aviators_rose/prescription
	gear_tweaks += new /datum/gear_tweak/path (options)


/datum/gear/eyes/eyepatch
	display_name = "Eyepatch Selection"
	description = "Conceals a single eye."
	path = /obj/item/clothing/glasses


/datum/gear/eyes/eyepatch/New()
	..()
	var/list/options = list()
	options["Eyepatch"] = /obj/item/clothing/glasses/eyepatch
	options["iPatch"] = /obj/item/clothing/glasses/eyepatch/hud
	gear_tweaks += new /datum/gear_tweak/path (options)


/datum/gear/eyes/aviators_shutter
	display_name = "Shutter Shades"
	path = /obj/item/clothing/glasses/aviators_shutter
	flags = GEAR_HAS_COLOR_SELECTION


/datum/gear/eyes/welding
	display_name = "Welding Goggles"
	path = /obj/item/clothing/glasses/welding


/datum/gear/eyes/material
	display_name = "Material Goggles"
	path = /obj/item/clothing/glasses/material


/datum/gear/eyes/monocle
	display_name = "Monocle"
	path = /obj/item/clothing/glasses/monocle


/datum/gear/eyes/blindfold
	display_name = "Blindfold"
	path = /obj/item/clothing/glasses/blindfold
	flags = GEAR_HAS_COLOR_SELECTION
