// Uniform slot
/datum/gear/uniform
	display_name = "black shorts" //kept separate because there aren't any other uniforms that every role could have
	path = /obj/item/clothing/under/shorts/black
	slot = slot_w_uniform
	sort_category = "Uniforms and Casual Dress"

/datum/gear/uniform/jumpsuit
	display_name = "jumpsuit, colour select"
	path = /obj/item/clothing/under/color
	flags = GEAR_HAS_COLOR_SELECTION
	allowed_roles = NON_MILITARY_ROLES

/datum/gear/uniform/jumpsuit_f
	display_name = "feminine jumpsuit, colour select"
	path = /obj/item/clothing/under/fcolor
	flags = GEAR_HAS_COLOR_SELECTION
	allowed_roles = NON_MILITARY_ROLES

/datum/gear/uniform/shortjumpskirt
	display_name = "short jumpskirt, colour select"
	path = /obj/item/clothing/under/shortjumpskirt
	flags = GEAR_HAS_COLOR_SELECTION
	allowed_roles = RESTRICTED_ROLES

/datum/gear/uniform/blackjumpshorts
	display_name = "black jumpsuit shorts"
	path = /obj/item/clothing/under/color/blackjumpshorts
	allowed_roles = RESTRICTED_ROLES

/datum/gear/uniform/roboticist_skirt
	display_name = "skirt, roboticist"
	path = /obj/item/clothing/under/rank/roboticist/skirt
	allowed_roles = list(/datum/job/roboticist)

/datum/gear/uniform/suit
	display_name = "clothes selection"
	path = /obj/item/clothing/under
	allowed_roles = FORMAL_ROLES

/datum/gear/uniform/suit/New()
	..()
	var/suits = list()
	suits += /obj/item/clothing/under/sl_suit
	suits += /obj/item/clothing/under/suit_jacket
	suits += /obj/item/clothing/under/lawyer/blue
	suits += /obj/item/clothing/under/suit_jacket/burgundy
	suits += /obj/item/clothing/under/suit_jacket/charcoal
	suits += /obj/item/clothing/under/suit_jacket/checkered
	suits += /obj/item/clothing/under/suit_jacket/really_black
	suits += /obj/item/clothing/under/suit_jacket/female
	suits += /obj/item/clothing/under/gentlesuit
	suits += /obj/item/clothing/under/suit_jacket/navy
	suits += /obj/item/clothing/under/lawyer/oldman
	suits += /obj/item/clothing/under/lawyer/purpsuit
	suits += /obj/item/clothing/under/suit_jacket/red
	suits += /obj/item/clothing/under/lawyer/red
	suits += /obj/item/clothing/under/lawyer/black
	suits += /obj/item/clothing/under/suit_jacket/tan
	suits += /obj/item/clothing/under/scratch
	suits += /obj/item/clothing/under/lawyer/bluesuit
	suits += /obj/item/clothing/under/rank/internalaffairs/plain
	suits += /obj/item/clothing/under/blazer
	suits += /obj/item/clothing/under/blackjumpskirt
	suits += /obj/item/clothing/under/kilt
	suits += /obj/item/clothing/under/dress/dress_hr
	suits += /obj/item/clothing/under/det
	suits += /obj/item/clothing/under/det/black
	suits += /obj/item/clothing/under/det/grey
	gear_tweaks += new/datum/gear_tweak/path/specified_types_list(suits)

/datum/gear/uniform/scrubs
	display_name = "standard medical scrubs"
	path = /obj/item/clothing/under/rank/medical/scrubs
	allowed_roles = STERILE_ROLES
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/uniform/scrubs/custom
	display_name = "scrubs, colour select"
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/uniform/dress
	display_name = "dress selection"
	path = /obj/item/clothing/under
	allowed_roles = FORMAL_ROLES

/datum/gear/uniform/dress/New()
	..()
	var/dresses = list()
	dresses += /obj/item/clothing/under/sundress_white
	dresses += /obj/item/clothing/under/dress/dress_fire
	dresses += /obj/item/clothing/under/dress/dress_green
	dresses += /obj/item/clothing/under/dress/dress_orange
	dresses += /obj/item/clothing/under/dress/dress_pink
	dresses += /obj/item/clothing/under/dress/dress_purple
	dresses += /obj/item/clothing/under/sundress
	gear_tweaks += new/datum/gear_tweak/path/specified_types_list(dresses)

/datum/gear/uniform/cheongsam
	display_name = "cheongsam, colour select"
	path = /obj/item/clothing/under/cheongsam
	flags = GEAR_HAS_COLOR_SELECTION
	allowed_roles = FORMAL_ROLES

/datum/gear/uniform/abaya
	display_name = "abaya, colour select"
	path = /obj/item/clothing/under/abaya
	flags = GEAR_HAS_COLOR_SELECTION
	allowed_roles = FORMAL_ROLES

/datum/gear/uniform/skirt
	display_name = "skirt selection"
	path = /obj/item/clothing/under/skirt
	allowed_roles = FORMAL_ROLES
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/uniform/skirt_c
	display_name = "short skirt, colour select"
	path = /obj/item/clothing/under/skirt_c
	allowed_roles = FORMAL_ROLES
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/uniform/skirt_c/dress
	display_name = "simple dress, colour select"
	path = /obj/item/clothing/under/skirt_c/dress
	allowed_roles = FORMAL_ROLES
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/uniform/casual_pants
	display_name = "casual pants selection"
	path = /obj/item/clothing/under/casual_pants
	allowed_roles = SEMIFORMAL_ROLES
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/uniform/formal_pants
	display_name = "formal pants selection"
	path = /obj/item/clothing/under/formal_pants
	allowed_roles = FORMAL_ROLES
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/uniform/formal_pants/custom
	display_name = "suit pants, colour select"
	path = /obj/item/clothing/under/formal_pants
	allowed_roles = FORMAL_ROLES
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/uniform/formal_pants/baggycustom
	display_name = "baggy suit pants, colour select"
	path = /obj/item/clothing/under/formal_pants/baggy
	allowed_roles = FORMAL_ROLES
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/uniform/shorts
	display_name = "shorts selection"
	path = /obj/item/clothing/under/shorts/jeans
	allowed_roles = RESTRICTED_ROLES
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/uniform/shorts/custom
	display_name = "athletic shorts, colour select"
	path = /obj/item/clothing/under/shorts/
	allowed_roles = FORMAL_ROLES
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/uniform/turtleneck
	display_name = "sweater, colour select"
	path = /obj/item/clothing/under/rank/psych/turtleneck/sweater
	flags = GEAR_HAS_COLOR_SELECTION
	allowed_roles = FORMAL_ROLES

/datum/gear/uniform/tacticool
	display_name = "tacticool turtleneck"
	path = /obj/item/clothing/under/syndicate/tacticool
	allowed_roles = RESTRICTED_ROLES

/datum/gear/uniform/corporate
	display_name = "corporate uniform selection"
	path = /obj/item/clothing/under
	allowed_roles = list(/datum/job/scientist, /datum/job/mining, /datum/job/guard, /datum/job/scientist_assistant,
						/datum/job/scientist_assistant, /datum/job/engineer_contractor, /datum/job/roboticist, /datum/job/doctor_contractor,
						/datum/job/psychiatrist, /datum/job/cargo_contractor, /datum/job/bartender, /datum/job/merchant, /datum/job/assistant)

/datum/gear/uniform/corporate/New()
	..()
	var/corps = list()
	corps += /obj/item/clothing/under/mbill
	corps += /obj/item/clothing/under/saare
	corps += /obj/item/clothing/under/aether
	corps += /obj/item/clothing/under/hephaestus
	corps += /obj/item/clothing/under/pcrc
	corps += /obj/item/clothing/under/wardt
	corps += /obj/item/clothing/under/grayson
	corps += /obj/item/clothing/under/focal
	corps += /obj/item/clothing/under/rank/ntwork
	gear_tweaks += new/datum/gear_tweak/path/specified_types_list(corps)

/datum/gear/uniform/sterile
	display_name = "sterile jumpsuit"
	path = /obj/item/clothing/under/sterile
	allowed_roles = MEDICAL_ROLES

/datum/gear/uniform/hazard
	display_name = "hazard jumpsuit"
	path = /obj/item/clothing/under/hazard
	allowed_roles = ENGINEERING_ROLES

/datum/gear/uniform/utility
	display_name = "Contractor Utility Uniform"
	path = /obj/item/clothing/under/solgov/utility
	allowed_roles = CONTRACTOR_ROLES

/datum/gear/uniform/frontier
	display_name = "frontier clothes"
	path = /obj/item/clothing/under/frontier
	allowed_roles = NON_MILITARY_ROLES
