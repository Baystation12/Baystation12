// Shoelocker
/datum/gear/shoes
	display_name = "sandals"
	path = /obj/item/clothing/shoes/sandal
	slot = slot_shoes
	sort_category = "Shoes and Footwear"

/datum/gear/shoes/color
	display_name = "shoe selection"
	path = /obj/item/clothing/shoes/black

/datum/gear/shoes/color/New()
	..()
	var/shoes = list()
	shoes["black shoes"] = /obj/item/clothing/shoes/black
	shoes["blue shoes"] = /obj/item/clothing/shoes/blue
	shoes["brown shoes"] = /obj/item/clothing/shoes/brown
	shoes["dress shoes"] = /obj/item/clothing/shoes/laceup
	shoes["green shoes"] = /obj/item/clothing/shoes/green
	shoes["leather shoes"] = /obj/item/clothing/shoes/leather
	shoes["orange shoes"] = /obj/item/clothing/shoes/orange
	shoes["purple shoes"] = /obj/item/clothing/shoes/purple
	shoes["rainbow shoes"] = /obj/item/clothing/shoes/rainbow
	shoes["red shoes"] = /obj/item/clothing/shoes/red
	shoes["white shoes"] = /obj/item/clothing/shoes/white
	shoes["yellow shoes"] = /obj/item/clothing/shoes/yellow
	gear_tweaks += new/datum/gear_tweak/path(shoes)

/datum/gear/shoes/boots
	display_name = "boot selection"
	path = /obj/item/clothing/shoes/jackboots

/datum/gear/shoes/boots/New()
	..()
	var/boots = list()
	boots["jackboots"] = /obj/item/clothing/shoes/jackboots
	boots["jackboots, white"] = /obj/item/clothing/shoes/jackboots/white
	boots["workboots"] = /obj/item/clothing/shoes/workboots
	boots["workboots, alt"] = /obj/item/clothing/shoes/workbootsalt
	boots["cowboy boots"] = /obj/item/clothing/shoes/cowboy
	boots["winterboots"] = /obj/item/clothing/shoes/winterboots
	boots["fancy boots"] = /obj/item/clothing/shoes/fancyboots
	boots["jungle boots"] = /obj/item/clothing/shoes/jungleboots
	boots["duty boots"] = /obj/item/clothing/shoes/dutyboots
	gear_tweaks += new/datum/gear_tweak/path(boots)

//EROS START

/datum/gear/shoes/flats
	display_name = "flats selection"
	path = /obj/item/clothing/shoes/flats

/datum/gear/shoes/flats/New()
	..()
	var/flats = list()
	flats["flats, black"] = /obj/item/clothing/shoes/flats
	flats["flats, white"] = /obj/item/clothing/shoes/flats/white
	flats["flats, red"] = /obj/item/clothing/shoes/flats/red
	flats["flats, purple"] = /obj/item/clothing/shoes/flats/purple
	flats["flats, blue"] = /obj/item/clothing/shoes/flats/blue
	flats["flats, brown"] = /obj/item/clothing/shoes/flats/brown
	flats["flats, orange"] = /obj/item/clothing/shoes/flats/orange

	gear_tweaks += new/datum/gear_tweak/path(flats)

/datum/gear/shoes/flipflops
	display_name = "flip flops"
	flags = GEAR_HAS_COLOR_SELECTION
	path = /obj/item/clothing/shoes/flipflop

//EROS END