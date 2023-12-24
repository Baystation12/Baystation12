/datum/gear/uniform/pmc //Some of that is duplicate of standart Torch uniforms selection. But who cares.
	display_name = "PMC uniform selection"
	allowed_roles = list(/datum/job/detective, /datum/job/officer, /datum/job/hos)
	path = /obj/item/clothing/under

/datum/gear/uniform/pmc/New()
	..()
	var/pmc = list()
	pmc["SAARE utility uniform"]= /obj/item/clothing/under/saare
	pmc["SAARE combat uniform"]= /obj/item/clothing/under/rank/security/saarecombat
	pmc["PCRC utility uniform"]	= /obj/item/clothing/under/pcrc
	pmc["PCRC formal uniform"]	= /obj/item/clothing/under/pcrcsuit
	pmc["SCP utility uniform"]	= /obj/item/clothing/under/scp_uniform
	pmc["ZPCI utility uniform"]	= /obj/item/clothing/under/zpci_uniform
	gear_tweaks += new/datum/gear_tweak/path(pmc)

/datum/gear/tactical/colorable_camo
	display_name = "camo uniform - colorable"
	path = /obj/item/clothing/under/gray_camo
	slot = slot_w_uniform
	flags = GEAR_HAS_COLOR_SELECTION
