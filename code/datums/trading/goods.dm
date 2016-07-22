/datum/trader/ship/toyshop
	name = "Toy Shop Employee"
	name_language = TRADER_DEFAULT_NAME
	origin = "Toy Shop"
	trade_flags = TRADER_GOODS|TRADER_MONEY|TRADER_WANTED_ONLY
	possible_origins = list("Toys R Ours", "LEGS GO", "Kay-Cee Toys", "Build-a-Cat", "Magic Box", "The Positronic's Dungeon and Baseball Card Shop")
	speech = list("hail_generic"    = "Uuhh... hello? Welcome to ORIGIN, I hope you have a uh.... good shoping trip.",
				"hail_deny"         = "Nah, you're not allowed here. At all",

				"trade_complete"       = "Thanks for shopping... here.... at ORIGIN.",
				"trade_blacklist"      = "Uuuuuuuuuuuuuuuuuuuh.... no.",
				"trade_found_unwanted" = "Nah! That's not what I'm looking for. Something rarer.",
				"trade_not_enough"   = "Just cause they're made of cardboard doesn't mean they don't cost money...",
				"how_much"          = "Uuuuuuuh... I'm thinking like... VALUE. Right? Or something rare that complements my interest.",

				"compliment_deny"   = "Ha! Very funny! You should write your own television show.",
				"compliment_accept" = "Why yes, I do work out.",
				"insult_good"       = "Well well well. Guess we learned who was the troll here.",
				"insult_bad"        = "I've already written a nasty spacebook post in my mind about you.",
				)

	possible_wanted_items = list(/obj/item/toy/figure       = TRADER_THIS_TYPE,
								/obj/item/toy/figure/ert    = TRADER_THIS_TYPE,
								/obj/item/toy/prize/honk    = TRADER_THIS_TYPE)

	possible_trading_items = list(/obj/item/toy/prize                 = TRADER_SUBTYPES_ONLY,
								/obj/item/toy/prize/honk              = TRADER_BLACKLIST,
								/obj/item/toy/figure                  = TRADER_SUBTYPES_ONLY,
								/obj/item/toy/figure/ert              = TRADER_BLACKLIST,
								/obj/item/toy/plushie                 = TRADER_SUBTYPES_ONLY,
								/obj/item/toy/katana                  = TRADER_THIS_TYPE,
								/obj/item/toy/sword                   = TRADER_THIS_TYPE,
								/obj/item/toy/bosunwhistle            = TRADER_THIS_TYPE,
								/obj/item/weapon/board                = TRADER_THIS_TYPE,
								/obj/item/weapon/storage/box/checkers = TRADER_ALL,
								/obj/item/weapon/deck                 = TRADER_SUBTYPES_ONLY,
								/obj/item/weapon/pack                 = TRADER_SUBTYPES_ONLY,
								/obj/item/weapon/dice                 = TRADER_ALL,
								/obj/item/weapon/dice/d20/cursed      = TRADER_BLACKLIST)

/datum/trader/ship/electronics
	name = "Electronic Shop Employee"
	name_language = TRADER_DEFAULT_NAME
	origin = "Electronic Shop"
	possible_origins = list("Best Sale", "Overstore", "Oldegg", "Circuit Citadel")

	speech = list("hail_generic"    = "Hello sir! Welcome to ORIGIN, I hope you find what you are looking for.",
				"hail_deny"         = "Your call has been disconnected.",

				"trade_complete"    = "Thank you for shopping at ORIGIN, would you like to put a warranty on that?",
				"trade_blacklist"   = "Sir, this is a /electronics/ store.",
				"trade_no_goods"    = "As much as I'd love to buy that from you, I'm not.",
				"trade_not_enough"  = "Your offer isn't adequete to the item you've selected, sir.",
				"how_much"          = "Your total comes out to VALUE thalers.",

				"compliment_deny"   = "Hahaha! Yeah... funny...",
				"compliment_accept" = "That's very nice of you!",
				"insult_good"       = "That was uncalled for, sir. Don't make me get my manager.",
				"insult_bad"        = "Sir, I am allowed to hang up the phone if you continue, sir.",
				)

	possible_trading_items = list(/obj/item/weapon/computer_hardware/battery_module      = TRADER_SUBTYPES_ONLY,
								/obj/item/weapon/circuitboard                            = TRADER_SUBTYPES_ONLY,
								/obj/item/weapon/circuitboard/telecomms                  = TRADER_BLACKLIST,
								/obj/item/weapon/circuitboard/unary_atmos                = TRADER_BLACKLIST,
								/obj/item/weapon/circuitboard/arcade                     = TRADER_BLACKLIST,
								/obj/item/weapon/circuitboard/mecha                      = TRADER_BLACKLIST,
								/obj/item/weapon/circuitboard/mecha/odysseus             = TRADER_BLACKLIST,
								/obj/item/weapon/circuitboard/mecha/honker               = TRADER_BLACKLIST,
								/obj/item/weapon/circuitboard/mecha/durand               = TRADER_BLACKLIST,
								/obj/item/weapon/circuitboard/mecha/gygax                = TRADER_BLACKLIST,
								/obj/item/weapon/circuitboard/mecha/ripley               = TRADER_BLACKLIST,
								/obj/item/weapon/circuitboard/broken                     = TRADER_BLACKLIST,
								/obj/item/stack/cable_coil                               = TRADER_SUBTYPES_ONLY,
								/obj/item/stack/cable_coil/cyborg                        = TRADER_BLACKLIST,
								/obj/item/stack/cable_coil/heavyduty                     = TRADER_BLACKLIST,
								/obj/item/stack/cable_coil/random                        = TRADER_BLACKLIST,
								/obj/item/stack/cable_coil/cut                           = TRADER_BLACKLIST,
								/obj/item/weapon/airalarm_electronics                    = TRADER_THIS_TYPE,
								/obj/item/weapon/airlock_electronics                     = TRADER_ALL,
								/obj/item/weapon/cell                                    = TRADER_THIS_TYPE,
								/obj/item/weapon/cell/crap                               = TRADER_THIS_TYPE,
								/obj/item/weapon/cell/high                               = TRADER_THIS_TYPE,
								/obj/item/weapon/cell/super                              = TRADER_THIS_TYPE,
								/obj/item/weapon/cell/hyper                              = TRADER_THIS_TYPE,
								/obj/item/weapon/module                                  = TRADER_SUBTYPES_ONLY,
								/obj/item/weapon/tracker_electronics                     = TRADER_THIS_TYPE)


/* Clothing stores: each a different type. A hat/glove store, a shoe store, and a jumpsuit store. */

/datum/trader/ship/clothingshop
	name = "Clothing Store Employee"
	name_language = TRADER_DEFAULT_NAME
	origin = "Clothing Store"
	possible_origins = list("Space Eagle", "Banana Democracy", "Forever 22", "Textiles Factory Warehouse Outlet", "Blocks Brothers")
	speech = list("hail_generic"    = "Hello sir! Welcome to ORIGIN!",
				"hail_Vox"          = "Well hello sir! I don't believe we have any clothes that fit you... but you can still look!",
				"hail_deny"         = "We do not trade with rude customers. Consider yourself blacklisted.",

				"trade_complete"    = "Thank you for shopping at ORIGIN, remember: you can return after the first day if you still have the tags on!",
				"trade_blacklist"   = "Hm, how about no?",
				"trade_no_goods"    = "We don't buy, sir. Only sell.",
				"trade_not_enough"  = "Sorry, ORIGIN policy to not accept trades below our marked prices.",
				"how_much"          = "Your total comes out to VALUE thalers.",

				"compliment_deny"   = "Excuse me?",
				"compliment_accept" = "Aw, you're so nice!",
				"insult_good"       = "Sir.",
				"insult_bad"        = "Wow. I don't have to take this.",
				)

	possible_trading_items = list(/obj/item/clothing/under                = TRADER_SUBTYPES_ONLY,
								/obj/item/clothing/under/acj              = TRADER_BLACKLIST,
								/obj/item/clothing/under/chameleon        = TRADER_BLACKLIST,
								/obj/item/clothing/under/cloud            = TRADER_BLACKLIST,
								/obj/item/clothing/under/color            = TRADER_BLACKLIST,
								/obj/item/clothing/under/dress            = TRADER_BLACKLIST,
								/obj/item/clothing/under/ert              = TRADER_BLACKLIST,
								/obj/item/clothing/under/gimmick          = TRADER_BLACKLIST_ALL,
								/obj/item/clothing/under/lawyer           = TRADER_BLACKLIST,
								/obj/item/clothing/under/pj               = TRADER_BLACKLIST,
								/obj/item/clothing/under/rank             = TRADER_BLACKLIST,
								/obj/item/clothing/under/shorts           = TRADER_BLACKLIST,
								/obj/item/clothing/under/stripper         = TRADER_BLACKLIST_ALL,
								/obj/item/clothing/under/swimsuit         = TRADER_BLACKLIST,
								/obj/item/clothing/under/syndicate        = TRADER_BLACKLIST_ALL,
								/obj/item/clothing/under/tactical         = TRADER_BLACKLIST,
								/obj/item/clothing/under/vox              = TRADER_BLACKLIST_ALL,
								/obj/item/clothing/under/wedding          = TRADER_BLACKLIST,
								/obj/item/clothing/under/punpun           = TRADER_BLACKLIST)

/datum/trader/ship/clothingshop/shoes
	possible_origins = list("Foot Safe", "Paysmall", "Popular Footwear", "Grimbly's Shoes", "Right Steps")
	possible_trading_items = list(/obj/item/clothing/shoes                = TRADER_SUBTYPES_ONLY,
								/obj/item/clothing/shoes/chameleon        = TRADER_BLACKLIST,
								/obj/item/clothing/shoes/combat           = TRADER_BLACKLIST,
								/obj/item/clothing/shoes/clown_shoes      = TRADER_BLACKLIST,
								/obj/item/clothing/shoes/cult             = TRADER_BLACKLIST,
								/obj/item/clothing/shoes/cyborg           = TRADER_BLACKLIST,
								/obj/item/clothing/shoes/lightrig         = TRADER_BLACKLIST_ALL,
								/obj/item/clothing/shoes/magboots         = TRADER_BLACKLIST_ALL,
								/obj/item/clothing/shoes/swat             = TRADER_BLACKLIST,
								/obj/item/clothing/shoes/syndigaloshes    = TRADER_BLACKLIST)

/datum/trader/ship/clothingshop/hatglovesaccessories
	possible_origins = list("Baldie's Hats and Accessories", "The Right Fit", "Like a Glove", "Space Fashion")
	possible_trading_items = list(/obj/item/clothing/accessory            = TRADER_ALL,
								/obj/item/clothing/accessory/badge        = TRADER_BLACKLIST_ALL,
								/obj/item/clothing/accessory/holster      = TRADER_BLACKLIST_ALL,
								/obj/item/clothing/accessory/medal        = TRADER_BLACKLIST_ALL,
								/obj/item/clothing/accessory/storage      = TRADER_BLACKLIST_ALL,
								/obj/item/clothing/gloves                 = TRADER_SUBTYPES_ONLY,
								/obj/item/clothing/gloves/lightrig        = TRADER_BLACKLIST_ALL,
								/obj/item/clothing/gloves/rig             = TRADER_BLACKLIST_ALL,
								/obj/item/clothing/gloves/swat            = TRADER_BLACKLIST,
								/obj/item/clothing/gloves/chameleon       = TRADER_BLACKLIST,
								/obj/item/clothing/head                   = TRADER_SUBTYPES_ONLY,
								/obj/item/clothing/head/HoS               = TRADER_BLACKLIST_ALL,
								/obj/item/clothing/head/beret/centcom     = TRADER_BLACKLIST_ALL,
								/obj/item/clothing/head/bio_hood          = TRADER_BLACKLIST_ALL,
								/obj/item/clothing/head/bomb_hood         = TRADER_BLACKLIST_ALL,
								/obj/item/clothing/head/caphat            = TRADER_BLACKLIST_ALL,
								/obj/item/clothing/head/centhat           = TRADER_BLACKLIST,
								/obj/item/clothing/head/chameleon         = TRADER_BLACKLIST,
								/obj/item/clothing/head/collectable       = TRADER_BLACKLIST,
								/obj/item/clothing/head/culthood          = TRADER_BLACKLIST_ALL,
								/obj/item/clothing/head/helmet            = TRADER_BLACKLIST_ALL,
								/obj/item/clothing/head/lightrig          = TRADER_BLACKLIST_ALL,
								/obj/item/clothing/head/radiation         = TRADER_BLACKLIST,
								/obj/item/clothing/head/tajaran           = TRADER_BLACKLIST,
								/obj/item/clothing/head/warden            = TRADER_BLACKLIST,
								/obj/item/clothing/head/welding           = TRADER_BLACKLIST)



/*
Sells devices, odds and ends, and medical stuff
*/
/datum/trader/devices
	name = "Drugstore Employee"
	name_language = TRADER_DEFAULT_NAME
	origin = "Drugstore"
	possible_origins = list("Buy 'n Save", "Drug Carnival", "C&B", "Fentles", "Dr. Goods", "Beevees")
	possible_trading_items = list(/obj/item/device/flashlight              = TRADER_ALL,
								/obj/item/device/kit/paint                 = TRADER_SUBTYPES_ONLY,
								/obj/item/device/aicard                    = TRADER_THIS_TYPE,
								/obj/item/device/binoculars                = TRADER_THIS_TYPE,
								/obj/item/device/cable_painter             = TRADER_THIS_TYPE,
								/obj/item/device/flash                     = TRADER_THIS_TYPE,
								/obj/item/device/floor_painter             = TRADER_THIS_TYPE,
								/obj/item/device/multitool                 = TRADER_THIS_TYPE,
								/obj/item/device/lightreplacer             = TRADER_THIS_TYPE,
								/obj/item/device/megaphone                 = TRADER_THIS_TYPE,
								/obj/item/device/paicard                   = TRADER_THIS_TYPE,
								/obj/item/device/pipe_painter              = TRADER_THIS_TYPE,
								/obj/item/device/healthanalyzer            = TRADER_THIS_TYPE,
								/obj/item/device/analyzer                  = TRADER_ALL,
								/obj/item/device/mass_spectrometer         = TRADER_ALL,
								/obj/item/device/reagent_scanner           = TRADER_ALL,
								/obj/item/device/slime_scanner             = TRADER_THIS_TYPE,
								/obj/item/device/suit_cooling_unit         = TRADER_THIS_TYPE,
								/obj/item/device/t_scanner                 = TRADER_THIS_TYPE,
								/obj/item/device/taperecorder              = TRADER_THIS_TYPE,
								/obj/item/device/batterer                  = TRADER_THIS_TYPE,
								/obj/item/device/violin                    = TRADER_THIS_TYPE,
								/obj/item/device/hailer                    = TRADER_THIS_TYPE,
								/obj/item/device/uv_light                  = TRADER_THIS_TYPE,
								/obj/item/device/mmi                       = TRADER_ALL,
								/obj/item/device/robotanalyzer             = TRADER_THIS_TYPE,
								/obj/item/device/toner                     = TRADER_THIS_TYPE,
								/obj/item/device/camera_film               = TRADER_THIS_TYPE,
								/obj/item/device/camera                    = TRADER_THIS_TYPE,
								/obj/item/device/destTagger                = TRADER_THIS_TYPE,
								/obj/item/device/gps                       = TRADER_THIS_TYPE,
								/obj/item/device/measuring_tape            = TRADER_THIS_TYPE,
								/obj/item/device/ano_scanner               = TRADER_THIS_TYPE,
								/obj/item/device/core_sampler              = TRADER_THIS_TYPE,
								/obj/item/device/depth_scanner             = TRADER_THIS_TYPE,
								/obj/item/device/beacon_locator            = TRADER_THIS_TYPE,
								/obj/item/device/antibody_scanner          = TRADER_THIS_TYPE,
								/obj/item/stack/medical/advanced           = TRADER_BLACKLIST)
	speech = list("hail_generic"    = "Hello hello! Bits and bobs and everything in between, I hope you find what you're looking for!",
				"hail_silicon"      = "Ah! Hello, robot. We only sell things that hm.... people can hold in their hands, unfortunately. You are still allowed to buy, though!",
				"hail_deny"         = "Oh no. I don't want to deal with YOU.",

				"trade_complete"    = "Thank you! Now remember, there isn't any return policy here, so be careful with that!",
				"trade_blacklist"   = "Hm. Well that would be illegal, so no.",
				"trade_no_goods"    = "I'm sorry, I only sell goods.",
				"trade_not_enough"  = "Gotta pay more than that to get that!",
				"how_much"          = "Well... I bought it for a lot, but I'll give it to you for VALUE.",

				"compliment_deny"   = "Uh... did you say something?",
				"compliment_accept" = "Mhm! I can agree to that!",
				"insult_good"       = "Wow, where was that coming from?",
				"insult_bad"        = "Don't make me blacklist your connection.",
				)