// Gloves
/datum/gear/gloves
	cost = 2
	slot = slot_gloves
	sort_category = "Gloves and Handwear"
	category = /datum/gear/gloves

/datum/gear/gloves/colored
	allowed_roles = FORMAL_ROLES

/datum/gear/gloves/latex
	cost = 3
	allowed_roles = ALL_MEDICAL_ROLES

/datum/gear/gloves/nitrile
	cost = 3
	allowed_roles = ALL_MEDICAL_ROLES

/datum/gear/gloves/rainbow
	allowed_roles = RESTRICTED_ROLES

/datum/gear/gloves/botany
	display_name = "gloves, botany"
	path = /obj/item/clothing/gloves/thick/botany
	cost = 3
	allowed_roles = list("Research Director", "Scientist", "Research Assistant", "Merchant")

/datum/gear/gloves/evening
	allowed_roles = FORMAL_ROLES

/datum/gear/gloves/dress
	display_name = "gloves, dress"
	path = /obj/item/clothing/gloves/color/white
	allowed_roles = MILITARY_ROLES

/datum/gear/gloves/duty
	display_name = "gloves, duty"
	path = /obj/item/clothing/gloves/duty
	cost = 3
	allowed_roles = MILITARY_ROLES

/datum/gear/gloves/work
	display_name = "gloves, work"
	path = /obj/item/clothing/gloves/thick
	cost = 3