/datum/gear/tactical/light_pcarrier
	display_name = "light armored plate carrier"
	description = "With additional light armor plate"
	path = /obj/item/clothing/suit/armor/pcarrier/light
	cost = 25
	// donation_tier = DONATION_TIER_TWO // Не открывать до Рождества

/datum/gear/pmp_w_tape
	display_name = "music player"
	description = "With custom tape"
	path = /obj/item/music_player
	cost = 0
	// donation_tier = DONATION_TIER_TWO // Не открывать до Рождества

/datum/gear/pmp_w_tape/New()
	. = ..()
	var/players = list(
		"Radio" = /obj/item/music_player/radio/custom_tape,
		"Cassett" = /obj/item/music_player/csplayer/custom_tape,
		"Dusty" = /obj/item/music_player/dusty/custom_tape,
	)
	gear_tweaks += new /datum/gear_tweak/path(players)

/datum/gear/boombox_w_tape
	display_name = "boombox"
	description = "With custom tape"
	path = /obj/item/music_player/boombox/custom_tape
	cost = 0
	// donation_tier = DONATION_TIER_FOUR // Не открывать до Рождества

/datum/gear/bikehorn
	display_name = "bike horn"
	description = "for real aesthetes"
	path = /obj/item/bikehorn
	cost = 0
	// donation_tier = DONATION_TIER_ONE // Не открывать до Рождества

/datum/gear/bikehorn/rubberducky
	display_name = "rubber duck"
	description = "QUACK"
	path = /obj/item/bikehorn/rubberducky
	cost = 0
	// donation_tier = DONATION_TIER_ONE // Не открывать до Рождества

/datum/gear/premium_alcohol
	display_name = "expensive alcohol"
	description = "sometimes it turns out that the bar is closed, but you want a drink."
	path = /obj/item/reagent_containers/food/drinks/bottle
	cost = 0
	// donation_tier = DONATION_TIER_ONE // Не открывать до Рождества

/datum/gear/premium_alcohol/New()
	. = ..()
	var/list/premium_alcohol_list = list(
		"Vodka" = /obj/item/reagent_containers/food/drinks/bottle/premiumvodka,
		"Vine" = /obj/item/reagent_containers/food/drinks/bottle/premiumwine,
		"Whiskey" = /obj/item/reagent_containers/food/drinks/bottle/specialwhiskey,
		"Nothing" = /obj/item/reagent_containers/food/drinks/bottle/bottleofnothing,
		"Vermouth" = /obj/item/reagent_containers/food/drinks/bottle/vermouth,
	)
	gear_tweaks += new /datum/gear_tweak/path(premium_alcohol_list)

/datum/gear/pizzabox
	display_name = "pizza box"
	description = "pizza time"
	path = /obj/item/pizzabox
	cost = 0
	// donation_tier = DONATION_TIER_ONE // Не открывать до Рождества

/datum/gear/pizzabox/New()
	. = ..()
	var/list/pizza_box_list = list(
		"Margherita" = /obj/item/pizzabox/margherita,
		"Mushroom" = /obj/item/pizzabox/mushroom,
		"Meat" = /obj/item/pizzabox/meat,
		"Vegetable" = /obj/item/pizzabox/vegetable,
	)
	gear_tweaks += new /datum/gear_tweak/path(pizza_box_list)

/datum/gear/musical_instruments
	display_name = "musical instruments"
	description = "let's DOOT"
	path = /obj/item/device/synthesized_instrument
	cost = 0
	// donation_tier = DONATION_TIER_ONE // Не открывать до Рождества

/datum/gear/musical_instruments/New()
	. = ..()
	var/list/musical_instruments_list = list(
		"Synthesizer" = /obj/item/device/synthesized_instrument/synthesizer,
		"Polyguitar" = /obj/item/device/synthesized_instrument/guitar/multi,
		"Guitar" = /obj/item/device/synthesized_instrument/guitar,
		"Trumpet" = /obj/item/device/synthesized_instrument/trumpet,
	)
	gear_tweaks += new /datum/gear_tweak/path(musical_instruments_list)




/datum/gear/costume_clown
	display_name = "clown costume"
	description = "Admit it, you invested so much money just for one clown costume."
	path = /obj/item/clothing/mask/gas/sexyclown
	cost = 0
	// donation_tier = DONATION_TIER_THREE // Не открывать до Рождества

/datum/gear/head/kittyears
	display_name = "kitty ears"
	path = /obj/item/clothing/head/kitty/fake
	sort_category = "Earwear"
	allowed_roles = null
	cost = 0
	// donation_tier = DONATION_TIER_TWO // Не открывать до Рождества

/datum/gear/mre
	display_name = "MRE"
	path = /obj/item/storage/mre
	cost = 0
	// donation_tier = DONATION_TIER_ONE // Не открывать до Рождества

/datum/gear/mre/New()
	. = ..()
	var/list/mre_list = list(
		"Menu 1" = /obj/item/storage/mre,
		"Menu 2" = /obj/item/storage/mre/menu2,
		"Menu 3" = /obj/item/storage/mre/menu3,
		"Menu 4" = /obj/item/storage/mre/menu4,
		"Menu 5" = /obj/item/storage/mre/menu5,
		"Menu 6" = /obj/item/storage/mre/menu6,
		"Menu 7" = /obj/item/storage/mre/menu7,
		"Menu 8" = /obj/item/storage/mre/menu8,
		"Menu 9" = /obj/item/storage/mre/menu9,
		"Menu 10" = /obj/item/storage/mre/menu10)
	gear_tweaks += new /datum/gear_tweak/path(mre_list)

/datum/gear/replica_katana
	display_name = "replica katana"
	description = "Ah, I see you're a man of culture as well."
	path = /obj/item/material/sword/katana/replica
	cost = 0
	// donation_tier = DONATION_TIER_TWO // Не открывать до Рождества
