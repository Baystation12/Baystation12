
/datum/gear/shoes
	sort_category = "Shoes and Footwear"
	slot = slot_shoes
	category = /datum/gear/shoes

/datum/gear/shoes/athletic
	display_name = "athletic shoes, colour select"
	path = /obj/item/clothing/shoes/athletic
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/shoes/boots
	display_name = "boot selection"
	path = /obj/item/clothing/shoes
	cost = 2

/datum/gear/shoes/boots/New()
	..()
	var/boots = list()
	boots += /obj/item/clothing/shoes/jackboots
	boots += /obj/item/clothing/shoes/workboots
	boots += /obj/item/clothing/shoes/dutyboots
	boots += /obj/item/clothing/shoes/jungleboots
	boots += /obj/item/clothing/shoes/desertboots
	gear_tweaks += new/datum/gear_tweak/path/specified_types_list(boots)

/datum/gear/shoes/color
	display_name = "shoe selection"
	path = /obj/item/clothing/shoes

/datum/gear/shoes/color/New()
	..()
	var/shoes = list()
	shoes += /obj/item/clothing/shoes/black
	shoes += /obj/item/clothing/shoes/blue
	shoes += /obj/item/clothing/shoes/brown
	shoes += /obj/item/clothing/shoes/laceup
	shoes += /obj/item/clothing/shoes/dress/white
	shoes += /obj/item/clothing/shoes/green
	shoes += /obj/item/clothing/shoes/leather
	shoes += /obj/item/clothing/shoes/orange
	shoes += /obj/item/clothing/shoes/purple
	shoes += /obj/item/clothing/shoes/rainbow
	shoes += /obj/item/clothing/shoes/red
	shoes += /obj/item/clothing/shoes/white
	shoes += /obj/item/clothing/shoes/yellow
	gear_tweaks += new/datum/gear_tweak/path/specified_types_list(shoes)

/datum/gear/shoes/flats
	display_name = "flats, colour select"
	path = /obj/item/clothing/shoes/flats
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/shoes/high
	display_name = "high tops selection"
	path = /obj/item/clothing/shoes/hightops
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/shoes/sandal
	display_name = "wooden sandals"
	path = /obj/item/clothing/shoes/sandal

/datum/gear/shoes/heels
	display_name = "high heels, colour select"
	path = /obj/item/clothing/shoes/heels
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/shoes/foamclog
	display_name = "foam clogs"
	path = /obj/item/clothing/shoes/foamclog
	flags = GEAR_HAS_COLOR_SELECTION