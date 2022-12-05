/*
/datum/gear/pet_cube
	display_name = "PetCube X"
	description = "Just add a water!"
	path = /obj/item/reagent_containers/food/snacks/monkeycube
	// required_donate_level = 4  // https://github.com/infinitystation/Baystation12/pull/1863 TODO: SIERRA PORT
	cost = 0 // Управлением решено убрать обычную цену с донатерских вещей ~bear1ake

/datum/gear/pet_cube/New()
	. = ..()
	var/cubes = list(
		"Cat PetCube" = /obj/item/reagent_containers/food/snacks/monkeycube/cat,
		"Corgi PetCube" = /obj/item/reagent_containers/food/snacks/monkeycube/corgi,
		"Lizard PetCube" = /obj/item/reagent_containers/food/snacks/monkeycube/lizard,
		"Mouse PetCube" = /obj/item/reagent_containers/food/snacks/monkeycube/mouse,
	)
	gear_tweaks += new /datum/gear_tweak/path(cubes)

/datum/gear/pet_holder
	display_name = "exotic pet"
	description = "Not common pet"
	path = /obj/item/holder
	// https://github.com/infinitystation/Baystation12/pull/1863 TODO: SIERRA PORT required_donate_level = 5
	// price = 20 // Не входит в стандартный набор, так что пусть стоит кое-чего
	cost = 0

/datum/gear/pet_holder/New()
	. = ..()
	var/pets = list(
		"Crab" = /obj/item/holder/crab/prepared,
		"Crow" = /obj/item/holder/crow/prepared,
		"Fox" = /obj/item/holder/fox/prepared,
		"Rabbit" = /obj/item/holder/rabbit/prepared,
		"Snake" = /obj/item/holder/snake/prepared/safe,
		"Kitten" = /obj/item/holder/kitten/prepared,
	)
	gear_tweaks += new /datum/gear_tweak/path(pets)
*/

/datum/gear/tactical/light_pcarrier
	display_name = "light armored plate carrier"
	description = "With additional light armor plate"
	path = /obj/item/clothing/suit/armor/pcarrier/light
	// required_donate_level = 2 // https://github.com/infinitystation/Baystation12/pull/1863 TODO: SIERRA PORT
//	price = 50 // Хоть и слабая, но всё же защита. Она должна быть достаточно дорогой
	cost = 25

/datum/gear/pmp_w_tape
	display_name = "music player"
	description = "With custom tape"
	path = /obj/item/music_player
	//required_donate_level = 3
	cost = 0

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
	// required_donate_level = 5
	// price = 25 // Не входит в стандартный набор и является так-то убийственной штукой
	cost = 0

/datum/gear/bikehorn
	display_name = "bike horn"
	description = "for real aesthetes"
	path = /obj/item/bikehorn
	// required_donate_level = 1
	cost = 0
	// price = 1

/datum/gear/bikehorn/rubberducky
	display_name = "rubber duck"
	description = "QUACK"
	path = /obj/item/bikehorn/rubberducky
	// required_donate_level = 1
	cost = 0
	// price = 1

/datum/gear/premium_alcohol
	display_name = "expensive alcohol"
	description = "sometimes it turns out that the bar is closed, but you want a drink."
	path = /obj/item/reagent_containers/food/drinks/bottle
	// required_donate_level = 1
	cost = 0
	// price = 5

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
//	required_donate_level = 1
	cost = 0
//	price = 5

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
	//required_donate_level = 1
	cost = 0
//	price = 5

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
	//required_donate_level = 5
	cost = 0
	//price = 25  // I don't want to see clown parade ~ SidVeld

/datum/gear/head/kittyears/donate
	display_name = "kitty ears"
	path = /obj/item/clothing/head/kitty/fake
	sort_category = "Earwear"
	allowed_roles = null
	//required_donate_level = 1
	cost = 0
	//price = 1

/datum/gear/mre
	display_name = "MRE"
	path = /obj/item/storage/mre
	//required_donate_level = 1
	cost = 0
	//price = 1

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
	//required_donate_level = 2
	cost = 0
	//price = 5
