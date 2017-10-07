// Shoelocker
/datum/gear/shoes
	display_name = "duty boots"
	path = /obj/item/clothing/shoes/dutyboots
	slot = slot_shoes
	sort_category = "Shoes and Footwear"

/datum/gear/shoes/whitedress
	display_name = "dress shoes, white"
	path = /obj/item/clothing/shoes/dress/white
	allowed_roles = MILITARY_ROLES

/datum/gear/shoes/athletic
	display_name = "athletic shoes"
	path = /obj/item/clothing/shoes/athletic
	flags = GEAR_HAS_COLOR_SELECTION
	allowed_roles = SEMIFORMAL_ROLES

/datum/gear/shoes/boots
	display_name = "boot selection"
	path = /obj/item/clothing/shoes
	cost = 2

/datum/gear/shoes/boots/New()
	..()
	var/boots = list()
	boots["jackboots"] = /obj/item/clothing/shoes/jackboots
	boots["workboots"] = /obj/item/clothing/shoes/workboots
	boots["duty boots"] = /obj/item/clothing/shoes/dutyboots
	boots["jungle boots"] = /obj/item/clothing/shoes/jungleboots
	gear_tweaks += new/datum/gear_tweak/path(boots)

/datum/gear/shoes/color
	display_name = "shoe selection"
	path = /obj/item/clothing/shoes
	allowed_roles = NON_MILITARY_ROLES

/datum/gear/shoes/color/New()
	..()
	var/shoes = list()
	shoes["black shoes"] = /obj/item/clothing/shoes/black
	shoes["blue shoes"] = /obj/item/clothing/shoes/blue
	shoes["brown shoes"] = /obj/item/clothing/shoes/brown
	shoes["laceup shoes"] = /obj/item/clothing/shoes/laceup
	shoes["green shoes"] = /obj/item/clothing/shoes/green
	shoes["leather shoes"] = /obj/item/clothing/shoes/leather
	shoes["orange shoes"] = /obj/item/clothing/shoes/orange
	shoes["purple shoes"] = /obj/item/clothing/shoes/purple
	shoes["rainbow shoes"] = /obj/item/clothing/shoes/rainbow
	shoes["red shoes"] = /obj/item/clothing/shoes/red
	shoes["white shoes"] = /obj/item/clothing/shoes/white
	shoes["yellow shoes"] = /obj/item/clothing/shoes/yellow
	gear_tweaks += new/datum/gear_tweak/path(shoes)

/datum/gear/shoes/dress
	display_name = "dress shoes"
	path = /obj/item/clothing/shoes/dress
	allowed_roles = MILITARY_ROLES

/datum/gear/shoes/flats
	display_name = "flats"
	path = /obj/item/clothing/shoes/flats
	flags = GEAR_HAS_COLOR_SELECTION
	allowed_roles = SEMIANDFORMAL_ROLES

/datum/gear/shoes/high
	display_name = "high tops selection"
	path = /obj/item/clothing/shoes/hightops
	allowed_roles = FORMAL_ROLES
	flags = GEAR_HAS_TYPE_SELECTION
