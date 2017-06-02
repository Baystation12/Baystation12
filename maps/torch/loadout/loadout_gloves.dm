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
	display_name = "ring"
	path = /obj/item/clothing/gloves/ring/cti
	cost = 2

/datum/gear/gloves/ring/New()
	..()
	var/ringtype = list()
	ringtype["CTI ring"] = /obj/item/clothing/gloves/ring/cti
	ringtype["Mariner University ring"] = /obj/item/clothing/gloves/ring/mariner
	ringtype["engagement ring"] = /obj/item/clothing/gloves/ring/engagement
	ringtype["signet ring"] = /obj/item/clothing/gloves/ring/seal/signet
	ringtype["masonic ring"] = /obj/item/clothing/gloves/ring/seal/mason
	ringtype["ring, steel"] = /obj/item/clothing/gloves/ring/material/steel
	ringtype["ring, bronze"] = /obj/item/clothing/gloves/ring/material/bronze
	ringtype["ring, silver"] = /obj/item/clothing/gloves/ring/material/silver
	ringtype["ring, gold"] = /obj/item/clothing/gloves/ring/material/gold
	ringtype["ring, platinum"] = /obj/item/clothing/gloves/ring/material/platinum
	ringtype["ring, glass"] = /obj/item/clothing/gloves/ring/material/glass
	ringtype["ring, wood"] = /obj/item/clothing/gloves/ring/material/wood
	ringtype["ring, plastic"] = /obj/item/clothing/gloves/ring/material/plastic
	gear_tweaks += new/datum/gear_tweak/path(ringtype)