// Uniform slot
/datum/gear/uniform
	display_name = "blazer, blue"
	path = /obj/item/clothing/under/blazer
	slot = slot_w_uniform
	sort_category = "Uniforms and Casual Dress"

/datum/gear/uniform/cheongsam
	display_name = "cheongsam, white"
	path = /obj/item/clothing/under/cheongsam

/datum/gear/uniform/kilt
	display_name = "kilt"
	path = /obj/item/clothing/under/kilt

/datum/gear/uniform/jumpskirt
	display_name = "jumpskirt, black"
	path = /obj/item/clothing/under/blackjumpskirt

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

/datum/gear/uniform/suit  //amish
	display_name = "suit, amish"
	path = /obj/item/clothing/under/sl_suit

/datum/gear/uniform/suit/black
	display_name = "suit, black"
	path = /obj/item/clothing/under/suit_jacket

/datum/gear/uniform/suit/shinyblack
	display_name = "suit, shiny-black"
	path = /obj/item/clothing/under/lawyer/black

/datum/gear/uniform/suit/blue
	display_name = "suit, blue"
	path = /obj/item/clothing/under/lawyer/blue

/datum/gear/uniform/suit/burgundy
	display_name = "suit, burgundy"
	path = /obj/item/clothing/under/suit_jacket/burgundy

/datum/gear/uniform/suit/checkered
	display_name = "suit, checkered"
	path = /obj/item/clothing/under/suit_jacket/checkered

/datum/gear/uniform/suit/charcoal
	display_name = "suit, charcoal"
	path = /obj/item/clothing/under/suit_jacket/charcoal

/datum/gear/uniform/suit/exec
	display_name = "suit, executive"
	path = /obj/item/clothing/under/suit_jacket/really_black

/datum/gear/uniform/suit/femaleexec
	display_name = "suit, female-executive"
	path = /obj/item/clothing/under/suit_jacket/female

/datum/gear/uniform/suit/gentle
	display_name = "suit, gentlemen"
	path = /obj/item/clothing/under/gentlesuit

/datum/gear/uniform/suit/navy
	display_name = "suit, navy"
	path = /obj/item/clothing/under/suit_jacket/navy

/datum/gear/uniform/suit/red
	display_name = "suit, red"
	path = /obj/item/clothing/under/suit_jacket/red

/datum/gear/uniform/suit/redlawyer
	display_name = "suit, lawyer-red"
	path = /obj/item/clothing/under/lawyer/red

/datum/gear/uniform/suit/oldman
	display_name = "suit, old-man"
	path = /obj/item/clothing/under/lawyer/oldman

/datum/gear/uniform/suit/purple
	display_name = "suit, purple"
	path = /obj/item/clothing/under/lawyer/purpsuit

/datum/gear/uniform/suit/tan
	display_name = "suit, tan"
	path = /obj/item/clothing/under/suit_jacket/tan

/datum/gear/uniform/suit/white
	display_name = "suit, white"
	path = /obj/item/clothing/under/scratch

/datum/gear/uniform/suit/whiteblue
	display_name = "suit, white-blue"
	path = /obj/item/clothing/under/lawyer/bluesuit

/datum/gear/uniform/scrubs
	display_name = "scrubs, black"
	path = /obj/item/clothing/under/rank/medical/black
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist")

/datum/gear/uniform/scrubs/blue
	display_name = "scrubs, blue"
	path = /obj/item/clothing/under/rank/medical/blue

/datum/gear/uniform/scrubs/purple
	display_name = "scrubs, purple"
	path = /obj/item/clothing/under/rank/medical/purple

/datum/gear/uniform/scrubs/green
	display_name = "scrubs, green"
	path = /obj/item/clothing/under/rank/medical/green

/datum/gear/uniform/scrubs/navyblue
	display_name = "scrubs, navy blue"
	path = /obj/item/clothing/under/rank/medical/navyblue

/datum/gear/uniform/sundress
	display_name = "sundress"
	path = /obj/item/clothing/under/sundress

/datum/gear/uniform/sundress/white
	display_name = "sundress, white"
	path = /obj/item/clothing/under/sundress_white

/datum/gear/uniform/dress_fire
	display_name = "flame dress"
	path = /obj/item/clothing/under/dress/dress_fire

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

/datum/gear/uniform/pants
	display_name = "pants selection"
	path = /obj/item/clothing/under/pants/white

/datum/gear/uniform/pants/New()
	..()
	var/list/pants = list()
	for(var/pant in typesof(/obj/item/clothing/under/pants))
		var/obj/item/clothing/under/pants/pant_type = pant
		pants[initial(pant_type.name)] = pant_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(pants))

/datum/gear/uniform/shorts
	display_name = "shorts selection"
	path = /obj/item/clothing/under/shorts/jeans

/datum/gear/uniform/shorts/New()
	..()
	var/list/shorts = list()
	for(var/short in typesof(/obj/item/clothing/under/shorts))
		var/obj/item/clothing/under/pants/short_type = short
		shorts[initial(short_type.name)] = short_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(shorts))