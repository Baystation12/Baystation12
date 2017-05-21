// Uniform slot
/datum/gear/uniform
	display_name = "blazer, blue"
	path = /obj/item/clothing/under/blazer
	slot = slot_w_uniform
	sort_category = "Uniforms and Casual Dress"

/datum/gear/uniform/cheongsam
	display_name = "cheongsam"
	path = /obj/item/clothing/under/cheongsam
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/uniform/kilt
	display_name = "kilt"
	path = /obj/item/clothing/under/kilt

/datum/gear/uniform/jumpskirt
	display_name = "jumpskirt, black"
	path = /obj/item/clothing/under/blackjumpskirt

/datum/gear/uniform/shortjumpskirt
    display_name = "short jumpskirt"
    path = /obj/item/clothing/under/shortjumpskirt
    flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/uniform/jumpsuit
	display_name = "generic jumpsuits"
	path = /obj/item/clothing/under/color/grey

/datum/gear/uniform/jumpsuit/New()
	..()
	gear_tweaks += new/datum/gear_tweak/path(/obj/item/clothing/under/color)

/datum/gear/uniform/roboticist_skirt
	display_name = "skirt, roboticist"
	path = /obj/item/clothing/under/rank/roboticist/skirt
	allowed_roles = list("Roboticist")

/datum/gear/uniform/suit
	display_name = "suit selection"
	path = /obj/item/clothing/under/lawyer/bluesuit

/datum/gear/uniform/suit/New()
	..()
	var/suits = list()
	suits["amish suit"] = /obj/item/clothing/under/sl_suit
	suits["black suit"] = /obj/item/clothing/under/suit_jacket
	suits["blue suit"] = /obj/item/clothing/under/lawyer/blue
	suits["burgundy suit"] = /obj/item/clothing/under/suit_jacket/burgundy
	suits["charcoal suit"] = /obj/item/clothing/under/suit_jacket/charcoal
	suits["checkered suit"] = /obj/item/clothing/under/suit_jacket/checkered
	suits["executive suit"] = /obj/item/clothing/under/suit_jacket/really_black
	suits["female executive suit"] = /obj/item/clothing/under/suit_jacket/female
	suits["gentleman suit"] = /obj/item/clothing/under/gentlesuit
	suits["navy suit"] = /obj/item/clothing/under/suit_jacket/navy
	suits["old man suit"] = /obj/item/clothing/under/lawyer/oldman
	suits["purple suit"] = /obj/item/clothing/under/lawyer/purpsuit
	suits["red suit"] = /obj/item/clothing/under/suit_jacket/red
	suits["red lawyer suit"] = /obj/item/clothing/under/lawyer/red
	suits["shiny black suit"] = /obj/item/clothing/under/lawyer/black
	suits["tan suit"] = /obj/item/clothing/under/suit_jacket/tan
	suits["white suit"] = /obj/item/clothing/under/scratch
	suits["white-blue suit"] = /obj/item/clothing/under/lawyer/bluesuit
	suits["formal outfit"] = /obj/item/clothing/under/rank/internalaffairs/plain
	gear_tweaks += new/datum/gear_tweak/path(suits)

/datum/gear/uniform/scrubs
	display_name = "medical scrubs"
	path = /obj/item/clothing/under/rank/medical/black
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist")

/datum/gear/uniform/scrubs/New()
	..()
	var/scrubcolor = list()
	scrubcolor["black scrubs"] = /obj/item/clothing/under/rank/medical/black
	scrubcolor["blue scrubs"] = /obj/item/clothing/under/rank/medical/blue
	scrubcolor["green scrubs"] = /obj/item/clothing/under/rank/medical/green
	scrubcolor["navy blue scrubs"] = /obj/item/clothing/under/rank/medical/navyblue
	scrubcolor["purple scrubs"] = /obj/item/clothing/under/rank/medical/purple
	gear_tweaks += new/datum/gear_tweak/path(scrubcolor)

/datum/gear/uniform/dress
	display_name = "dress selection"
	path = /obj/item/clothing/under/dress

/datum/gear/uniform/dress/New()
	..()
	var/dresses = list()
	dresses["flame dress"] = /obj/item/clothing/under/dress/dress_fire
	dresses["green dress"] = /obj/item/clothing/under/dress/dress_green
	dresses["orange dress"] = /obj/item/clothing/under/dress/dress_orange
	dresses["pink dress"] = /obj/item/clothing/under/dress/dress_pink
	dresses["purple dress"] = /obj/item/clothing/under/dress/dress_purple
	dresses["sundress"] = /obj/item/clothing/under/sundress
	dresses["white sundress"] = /obj/item/clothing/under/sundress_white
	gear_tweaks += new/datum/gear_tweak/path(dresses)

/datum/gear/uniform/uniform_captain
	display_name = "uniform, captain's dress"
	path = /obj/item/clothing/under/dress/dress_cap
	allowed_roles = list("Captain")

/datum/gear/uniform/corpsecsuit
	display_name = "uniform, corporate (Security)"
	path = /obj/item/clothing/under/rank/security/corp
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/uniform/uniform_hop
	display_name = "uniform, HoP's dress"
	path = /obj/item/clothing/under/dress/dress_hop
	allowed_roles = list("Head of Personnel")

/datum/gear/uniform/uniform_hr
	display_name = "uniform, HR director (HoP)"
	path = /obj/item/clothing/under/dress/dress_hr
	allowed_roles = list("Head of Personnel")

/datum/gear/uniform/navysecsuit
	display_name = "uniform, navyblue (Security)"
	path = /obj/item/clothing/under/rank/security/navyblue
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/uniform/skirt
	display_name = "skirt selection"
	path = /obj/item/clothing/under/skirt

/datum/gear/uniform/skirt/New()
	..()
	var/list/skirts = list()
	for(var/skirt in (typesof(/obj/item/clothing/under/skirt)))
		var/obj/item/clothing/under/skirt/skirt_type = skirt
		skirts[initial(skirt_type.name)] = skirt_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(skirts))

/datum/gear/uniform/tacticool
	display_name = "tacticool turtleneck"
	path = /obj/item/clothing/under/syndicate/tacticool

/datum/gear/uniform/turtleneck
	display_name = "sweater"
	path = /obj/item/clothing/under/rank/psych/turtleneck/sweater
	flags = GEAR_HAS_COLOR_SELECTION
