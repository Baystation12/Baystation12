// Shoelocker
/datum/gear/shoes
	display_name = "duty boots"
	path = /obj/item/clothing/shoes/dutyboots
	slot = slot_shoes
	sort_category = "Shoes and Footwear"

/datum/gear/shoes/dress
	allowed_roles = MILITARY_ROLES

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
	boots["desert boots"] = /obj/item/clothing/shoes/desertboots
	gear_tweaks += new/datum/gear_tweak/path(boots)

/datum/gear/shoes/color
	display_name = "shoe selection"
	path = /obj/item/clothing/shoes
	allowed_roles = NON_MILITARY_ROLES

/datum/gear/shoes/athletic
	allowed_roles = SEMIFORMAL_ROLES

/datum/gear/shoes/flats
	allowed_roles = SEMIANDFORMAL_ROLES

/datum/gear/shoes/high

	display_name = "high tops selection"
	path = /obj/item/clothing/shoes/hightops
	allowed_roles = FORMAL_ROLES
	flags = GEAR_HAS_TYPE_SELECTION
