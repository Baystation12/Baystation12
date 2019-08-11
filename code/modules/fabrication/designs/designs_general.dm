/datum/fabricator_recipe/bucket
	name = "bucket"
	path = /obj/item/weapon/reagent_containers/glass/bucket

/datum/fabricator_recipe/drinkingglass
	name = "drinking glass"
	path = /obj/item/weapon/reagent_containers/food/drinks/glass2/square

/datum/fabricator_recipe/drinkingglass/New()
	..()
	var/obj/O = path
	name = initial(O.name)

/datum/fabricator_recipe/drinkingglass/rocks
	path = /obj/item/weapon/reagent_containers/food/drinks/glass2/rocks

/datum/fabricator_recipe/drinkingglass/shake
	path = /obj/item/weapon/reagent_containers/food/drinks/glass2/shake

/datum/fabricator_recipe/drinkingglass/cocktail
	path = /obj/item/weapon/reagent_containers/food/drinks/glass2/cocktail

/datum/fabricator_recipe/drinkingglass/shot
	path = /obj/item/weapon/reagent_containers/food/drinks/glass2/shot

/datum/fabricator_recipe/drinkingglass/pint
	path = /obj/item/weapon/reagent_containers/food/drinks/glass2/pint

/datum/fabricator_recipe/drinkingglass/mug
	path = /obj/item/weapon/reagent_containers/food/drinks/glass2/mug

/datum/fabricator_recipe/drinkingglass/wine
	path = /obj/item/weapon/reagent_containers/food/drinks/glass2/wine

/datum/fabricator_recipe/drinkingglass/wine
	path = /obj/item/weapon/reagent_containers/food/drinks/glass2/carafe

/datum/fabricator_recipe/flashlight
	name = "flashlight"
	path = /obj/item/device/flashlight

/datum/fabricator_recipe/floor_light
	name = "floor light"
	path = /obj/machinery/floor_light

/datum/fabricator_recipe/extinguisher
	name = "extinguisher"
	path = /obj/item/weapon/extinguisher

/datum/fabricator_recipe/jar
	name = "jar"
	path = /obj/item/glass_jar

/datum/fabricator_recipe/radio_headset
	name = "radio headset"
	path = /obj/item/device/radio/headset

/datum/fabricator_recipe/radio_bounced
	name = "shortwave radio"
	path = /obj/item/device/radio/off

/datum/fabricator_recipe/suit_cooler
	name = "suit cooling unit"
	path = /obj/item/device/suit_cooling_unit

/datum/fabricator_recipe/weldermask
	name = "welding mask"
	path = /obj/item/clothing/head/welding

/datum/fabricator_recipe/metal
	name = "steel sheets"
	path = /obj/item/stack/material/steel
	is_stack = TRUE
	resources = list(MATERIAL_STEEL = SHEET_MATERIAL_AMOUNT * FABRICATOR_EXTRA_COST_FACTOR)

/datum/fabricator_recipe/glass
	name = "glass sheets"
	path = /obj/item/stack/material/glass
	is_stack = TRUE
	resources = list(MATERIAL_GLASS = SHEET_MATERIAL_AMOUNT * FABRICATOR_EXTRA_COST_FACTOR)

/datum/fabricator_recipe/aluminium
	name = "aluminium sheets"
	path = /obj/item/stack/material/aluminium
	is_stack = TRUE
	resources = list(MATERIAL_ALUMINIUM = SHEET_MATERIAL_AMOUNT * FABRICATOR_EXTRA_COST_FACTOR)

/datum/fabricator_recipe/rglass
	name = "reinforced glass sheets"
	path = /obj/item/stack/material/glass/reinforced
	is_stack = TRUE
	resources = list(MATERIAL_GLASS = (SHEET_MATERIAL_AMOUNT/2) * FABRICATOR_EXTRA_COST_FACTOR, MATERIAL_STEEL = (SHEET_MATERIAL_AMOUNT/2) * FABRICATOR_EXTRA_COST_FACTOR)

/datum/fabricator_recipe/plastic
	name = "plastic sheets"
	path = /obj/item/stack/material/plastic
	is_stack = TRUE
	resources = list(MATERIAL_PLASTIC = SHEET_MATERIAL_AMOUNT * FABRICATOR_EXTRA_COST_FACTOR)

/datum/fabricator_recipe/rods
	name = "metal rods"
	path = /obj/item/stack/material/rods
	is_stack = TRUE

/datum/fabricator_recipe/knife
	name = "kitchen knife"
	path = /obj/item/weapon/material/knife/kitchen

/datum/fabricator_recipe/taperecorder
	name = "tape recorder"
	path = /obj/item/device/taperecorder/empty

/datum/fabricator_recipe/tape
	name = "tape"
	path = /obj/item/device/tape

/datum/fabricator_recipe/tube/large
	name = "spotlight tube"
	path = /obj/item/weapon/light/tube/large

/datum/fabricator_recipe/tube
	name = "light tube"
	path = /obj/item/weapon/light/tube

/datum/fabricator_recipe/bulb
	name = "light bulb"
	path = /obj/item/weapon/light/bulb

/datum/fabricator_recipe/ashtray_glass
	name = "glass ashtray"
	path = /obj/item/weapon/material/ashtray/glass

/datum/fabricator_recipe/weldinggoggles
	name = "welding goggles"
	path = /obj/item/clothing/glasses/welding

/datum/fabricator_recipe/blackpen
	name = "black ink pen"
	path = /obj/item/weapon/pen

/datum/fabricator_recipe/bluepen
	name = "blue ink pen"
	path = /obj/item/weapon/pen/blue

/datum/fabricator_recipe/redpen
	name = "red ink pen"
	path = /obj/item/weapon/pen/red

/datum/fabricator_recipe/greenpen
	name = "green ink pen"
	path = /obj/item/weapon/pen/green

/datum/fabricator_recipe/clipboard_steel
	name = "clipboard, steel"
	path = /obj/item/weapon/material/clipboard/steel

/datum/fabricator_recipe/clipboard_alum
	name = "clipboard, aluminium"
	path = /obj/item/weapon/material/clipboard/aluminium

/datum/fabricator_recipe/clipboard_glass
	name = "clipboard, glass"
	path = /obj/item/weapon/material/clipboard/glass

/datum/fabricator_recipe/clipboard_alum
	name = "clipboard, plastic"
	path = /obj/item/weapon/material/clipboard/plastic

/datum/fabricator_recipe/destTagger
	name = "destination tagger"
	path = /obj/item/device/destTagger

/datum/fabricator_recipe/labeler
	name = "hand labeler"
	path = /obj/item/weapon/hand_labeler

/datum/fabricator_recipe/handcuffs
	name = "handcuffs"
	path = /obj/item/weapon/handcuffs
	hidden = TRUE

/datum/fabricator_recipe/plunger
	name = "plunger"
	path = /obj/item/clothing/mask/plunger
