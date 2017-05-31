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
	allowed_roles = STERILE_ROLES

/datum/gear/gloves/nitrile
	cost = 3
	allowed_roles = STERILE_ROLES

/datum/gear/gloves/rainbow
	allowed_roles = RESTRICTED_ROLES

/datum/gear/gloves/botany
	display_name = "gloves, botany"
	path = /obj/item/clothing/gloves/thick/botany
	cost = 3
	allowed_roles = list("Research Director", "Scientist", "Research Assistant", "Cook", "Bartender", "Passenger", "Merchant")

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

/datum/gear/gloves/ring
	display_name = "ring, gold"
	path = /obj/item/clothing/gloves/ring/gold
	cost = 2

/datum/gear/gloves/ring/New()
	..()
	var/ringtype = list()
	ringtype["ring, gold"] = /obj/item/clothing/gloves/ring/gold
	ringtype["ring, silver"] = /obj/item/clothing/gloves/ring/silver
	ringtype["ring, platinum"] = /obj/item/clothing/gloves/ring/platinum
	ringtype["ring, diamond"] = /obj/item/clothing/gloves/ring/diamond
	gear_tweaks += new/datum/gear_tweak/path(ringtype)
