// Shoelocker
/datum/gear/shoes/duty
	display_name = "duty boots"
	path = /obj/item/clothing/shoes/dutyboots

/datum/gear/shoes/whitedress
	display_name = "dress shoes, white"
	path = /obj/item/clothing/shoes/dress/white

/datum/gear/shoes/whitedress/color
	display_name = "dress shoes, color select"
	path = /obj/item/clothing/shoes/dress/white
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/shoes/dress
	display_name = "dress shoes"
	path = /obj/item/clothing/shoes/dress

/datum/gear/shoes/lowworkboots
	display_name = "low workboots"
	path = /obj/item/clothing/shoes/workboots

/datum/gear/shoes/cowboy_selection
	display_name = "cowboy boots selection"
	path = /obj/item/clothing/shoes/cowboy

/datum/gear/shoes/cowboy_selection/New()
	..()
	var/cowboy_selection_type = list()
	cowboy_selection_type["cowboy boots"] = /obj/item/clothing/shoes/cowboy
	cowboy_selection_type["classic cowboy boots"] = /obj/item/clothing/shoes/cowboy/classic
	cowboy_selection_type["snakeskin cowboy boots"] = /obj/item/clothing/shoes/cowboy/snakeskin
	gear_tweaks += new/datum/gear_tweak/path(cowboy_selection_type)

/datum/gear/shoes/brand_shoes
	display_name = "brand shoes selection"
	path = /obj/item/clothing/shoes/brand_shoes

/datum/gear/shoes/brand_shoes/New()
	..()
	var/b_shoes = list()
	b_shoes["white yellow shoes"] = /obj/item/clothing/shoes/brand_shoes
	b_shoes["black red shoes"] = /obj/item/clothing/shoes/brand_shoes/two
	b_shoes["black shoes"] = /obj/item/clothing/shoes/brand_shoes/three
	b_shoes["faln shoes"] = /obj/item/clothing/shoes/brand_shoes/faln
	gear_tweaks += new/datum/gear_tweak/path(b_shoes)

/datum/gear/shoes/antiquated
	display_name = "antiquated shoes"
	path = /obj/item/clothing/shoes/brand_shoes/antiquated

/datum/gear/shoes/noble_boots
	display_name = "noble boots"
	path = /obj/item/clothing/shoes/noble_boots

/datum/gear/shoes/geta
	display_name = "geta shoes selection"
	path = /obj/item/clothing/shoes/red_geta

/datum/gear/shoes/geta/New()
	..()
	var/get = list()
	get["red geta"] = /obj/item/clothing/shoes/red_geta
	get["black geta"] = /obj/item/clothing/shoes/black_geta
	gear_tweaks += new/datum/gear_tweak/path(get)
