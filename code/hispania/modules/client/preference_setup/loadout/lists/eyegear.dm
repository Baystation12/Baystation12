/datum/gear/eyes
	sort_category = "Glasses and Eyewear"
	category = /datum/gear/eyes
	slot = slot_glasses
	cost = 2


/datum/gear/eyes/glasses
	display_name = "Gafas correctivas"
	description = "Simplemente corrige la vista.."
	path = /obj/item/clothing/glasses


/datum/gear/eyes/glasses/New()
	..()
	var/list/options = list()
	options["Gafas Basicas"] = /obj/item/clothing/glasses/prescription
	options["Gafas Verdes"] = /obj/item/clothing/glasses/green
	options["Gafas Hipster"] = /obj/item/clothing/glasses/hipster
	options["Gafas de escaneo"] = /obj/item/clothing/glasses/scanners
	gear_tweaks += new /datum/gear_tweak/path (options)


/datum/gear/eyes/science
	display_name = "Science Eyewear"
	description = "Proporciona investigaciones y evaluaciones quimicas."
	path = /obj/item/clothing/glasses
	flags = GEAR_HAS_NO_CUSTOMIZATION


/datum/gear/eyes/science/New()
	..()
	var/list/options = list()
	options["Gafas"] = /obj/item/clothing/glasses/science
	options["Gafas, correctivas"] = /obj/item/clothing/glasses/science/prescription
	options["HUD"] = /obj/item/clothing/glasses/hud/science
	options["HUD, correctivas"] = /obj/item/clothing/glasses/hud/science/prescription
	gear_tweaks += new /datum/gear_tweak/path (options)


/datum/gear/eyes/security
	display_name = "Gafas de seguridad"
	description = "Proporciona superposiciones de vision de seguridad."
	path = /obj/item/clothing/glasses
	flags = GEAR_HAS_NO_CUSTOMIZATION


/datum/gear/eyes/security/New()
	..()
	var/list/options = list()
	options["HUD"] = /obj/item/clothing/glasses/hud/security
	options["HUD, correctivas"] = /obj/item/clothing/glasses/hud/security/prescription
	options["Gafas de sol"] = /obj/item/clothing/glasses/hud/security/prot/sunglasses
	options["Gafas de sol, correctivas"] = /obj/item/clothing/glasses/hud/security/prot/sunglasses/prescription
	options["Aviadores"] = /obj/item/clothing/glasses/hud/security/prot/aviators
	options["Aviadores, correctivas"] = /obj/item/clothing/glasses/hud/security/prot/aviators/prescription
	options["Gafas"] = /obj/item/clothing/glasses/hud/security/prot
	options["Gafas, correctivas"] = /obj/item/clothing/glasses/hud/security/prot/prescription
	options["Parche en el ojo"] = /obj/item/clothing/glasses/eyepatch/hud/security
	gear_tweaks += new /datum/gear_tweak/path (options)


/datum/gear/eyes/medical
	display_name = "Gafas medicas"
	description = "Proporciona superposiciones de vision médica."
	path = /obj/item/clothing/glasses
	flags = GEAR_HAS_NO_CUSTOMIZATION


/datum/gear/eyes/medical/New()
	..()
	var/list/options = list()
	options["HUD"] = /obj/item/clothing/glasses/hud/health
	options["HUD, correctivas"] = /obj/item/clothing/glasses/hud/health/prescription
	options["Gafas"] = /obj/item/clothing/glasses/hud/health/goggle
	options["Gafas, correctivas"] = /obj/item/clothing/glasses/hud/health/goggle/prescription
	options["Parche en el ojo"] = /obj/item/clothing/glasses/eyepatch/hud/medical
	gear_tweaks += new /datum/gear_tweak/path (options)


/datum/gear/eyes/meson
	display_name = "Gafas Meson"
	description = "Proporciona meson-vision."
	path = /obj/item/clothing/glasses
	flags = GEAR_HAS_NO_CUSTOMIZATION


/datum/gear/eyes/meson/New()
	..()
	var/list/options = list()
	options["Gafas"] = /obj/item/clothing/glasses/meson
	options["Gafas, correctivas"] = /obj/item/clothing/glasses/meson/prescription
	options["Parche en el ojo"] = /obj/item/clothing/glasses/eyepatch/hud/meson
	gear_tweaks += new /datum/gear_tweak/path (options)


/datum/gear/eyes/janitor
	display_name = "Gafas sanitarias"
	description = "Proporciona vision de suciedad."
	path = /obj/item/clothing/glasses
	flags = GEAR_HAS_NO_CUSTOMIZATION


/datum/gear/eyes/janitor/New()
	..()
	var/list/options = list()
	options["HUD"] = /obj/item/clothing/glasses/hud/janitor
	options["HUD, correctivas"] = /obj/item/clothing/glasses/hud/janitor/prescription
	gear_tweaks += new /datum/gear_tweak/path (options)


/datum/gear/eyes/sunglasses
	display_name = "Anteojos antideslumbrantes"
	description = "Brinda proteccion básica contra la luz brillante y el flash."
	path = /obj/item/clothing/glasses


/datum/gear/eyes/sunglasses/New()
	..()
	var/list/options = list()
	options["Gafas de sol"] = /obj/item/clothing/glasses/sunglasses
	options["Gafas de sol, corrective"] = /obj/item/clothing/glasses/sunglasses/prescription
	options["Gafas de sol grandes"] = /obj/item/clothing/glasses/sunglasses/big
	options["Gafas de sol grandes, correctivas"] = /obj/item/clothing/glasses/sunglasses/big/prescription
	options["Aviadores negros"] = /obj/item/clothing/glasses/aviators_black
	options["Aviadores negros, correctivas"] = /obj/item/clothing/glasses/aviators_black/prescription
	options["Aviadores de plata"] = /obj/item/clothing/glasses/aviators_silver
	options["Aviadores de plata, correctivas"] = /obj/item/clothing/glasses/aviators_silver/prescription
	options["Aviadores de oro"] = /obj/item/clothing/glasses/aviators_gold
	options["Aviadores de oro, correctivas"] = /obj/item/clothing/glasses/aviators_gold/prescription
	options["aviadores rosas"] = /obj/item/clothing/glasses/aviators_rose
	options["aviadores rosas, correctivas"] = /obj/item/clothing/glasses/aviators_rose/prescription
	gear_tweaks += new /datum/gear_tweak/path (options)


/datum/gear/eyes/eyepatch
	display_name = "Seleccion de parche en el ojo"
	description = "Oculta un solo ojo."
	path = /obj/item/clothing/glasses


/datum/gear/eyes/eyepatch/New()
	..()
	var/list/options = list()
	options["Parche en el ojo"] = /obj/item/clothing/glasses/eyepatch
	options["iPatch"] = /obj/item/clothing/glasses/eyepatch/hud
	gear_tweaks += new /datum/gear_tweak/path (options)


/datum/gear/eyes/aviators_shutter
	display_name = "Gafas de persianas"
	path = /obj/item/clothing/glasses/aviators_shutter
	flags = GEAR_HAS_COLOR_SELECTION


/datum/gear/eyes/welding
	display_name = "Gafas de soldador"
	path = /obj/item/clothing/glasses/welding


/datum/gear/eyes/material
	display_name = "Gafas de materiales"
	path = /obj/item/clothing/glasses/material
	flags = GEAR_HAS_NO_CUSTOMIZATION


/datum/gear/eyes/monocle
	display_name = "Monoculo"
	path = /obj/item/clothing/glasses/monocle


/datum/gear/eyes/blindfold
	display_name = "Venda"
	path = /obj/item/clothing/glasses/blindfold
	flags = GEAR_HAS_COLOR_SELECTION
