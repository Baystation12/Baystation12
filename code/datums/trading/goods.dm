/datum/trader/ship/toyshop
	name = "Toy Shop Employee"
	name_language = TRADER_DEFAULT_NAME
	origin = "Toy Shop"
	trade_flags = TRADER_GOODS|TRADER_MONEY|TRADER_WANTED_ONLY
	possible_origins = list("Toys R Ours", "LEGS GO", "Kay-Cee Toys", "Build-a-Cat", "Magic Box", "The Positronic's Dungeon and Baseball Card Shop")
	speech = list("hail_generic"    = "Uuhh... hello? Welcome to ORIGIN, I hope you have a uh.... good shoping trip.",
				"hail_deny"         = "Nah, you're not allowed here. At all",

				"trade_complete"    = "Thanks for shopping... here.... at ORIGIN.",
				"trade_refuse"      = "Uhhhh.... no? No.",
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
				"trade_refuse"      = "I'm sorry sir, I can't accept that.",
				"how_much"          = "Your total comes out to VALUE thalers.",

				"compliment_deny"   = "Hahaha! Yeah... funny...",
				"compliment_accept" = "That's very nice of you!",
				"insult_good"       = "That was uncalled for, sir. Don't make me get my manager.",
				"insult_bad"        = "Sir, I am allowed to hang up the phone if you continue, sir.",
				)

	possible_trading_items = list(/obj/item/weapon/computer_hardware/battery_module      = TRADER_SUBTYPES_ONLY,
								/obj/item/weapon/circuitboard                            = TRADER_SUBTYPES_ONLY,
								/obj/item/stack/cable_coil                               = TRADER_SUBTYPES_ONLY,
								/obj/item/stack/cable_coil/cyborg                        = TRADER_BLACKLIST,
								/obj/item/stack/cable_coil/heavyduty                     = TRADER_BLACKLIST,
								/obj/item/stack/cable_coil/random                        = TRADER_BLACKLIST,
								/obj/item/weapon/airalarm_electronics                    = TRADER_THIS_TYPE,
								/obj/item/weapon/airlock_electronics                     = TRADER_ALL,
								/obj/item/weapon/cell                                    = TRADER_ALL,
								/obj/item/weapon/cell/infinite                           = TRADER_BLACKLIST,
								/obj/item/weapon/cell/slime                              = TRADER_BLACKLIST,
								/obj/item/weapon/cell/secborg                            = TRADER_BLACKLIST_ALL,
								/obj/item/weapon/cell/device                             = TRADER_BLACKLIST_ALL,
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
				"trade_refuse"      = "I'm sorry sir, ORIGIN policy says not to accept that.",
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
	possible_trading_items = list(/obj/item/device                         = TRADER_SUBTYPES_ONLY,
								/obj/item/device/assembly                  = TRADER_BLACKLIST_ALL,
								/obj/item/device/assembly_holder           = TRADER_BLACKLIST_ALL,
								/obj/item/device/camera/siliconcam         = TRADER_BLACKLIST_ALL,
								/obj/item/device/encryptionkey             = TRADER_BLACKLIST_ALL,
								/obj/item/device/flashlight/drone          = TRADER_BLACKLIST,
								/obj/item/device/flashlight/slime          = TRADER_BLACKLIST,
								/obj/item/device/onetankbomb               = TRADER_BLACKLIST,
								/obj/item/device/pda                       = TRADER_BLACKLIST_ALL,
								/obj/item/device/powersink                 = TRADER_BLACKLIST,
								/obj/item/device/radio                     = TRADER_BLACKLIST_ALL,
								/obj/item/device/soulstone                 = TRADER_BLACKLIST,
								/obj/item/device/spy_bug                   = TRADER_BLACKLIST,
								/obj/item/device/spy_monitor               = TRADER_BLACKLIST,
								/obj/item/device/uplink                    = TRADER_BLACKLIST,
								/obj/item/stack/medical                    = TRADER_SUBTYPES_ONLY,
								/obj/item/stack/medical/advanced           = TRADER_BLACKLIST)
	speech = list("hail_generic"    = "Hello hello! Bits and bobs and everything in between, I hope you find what you're looking for!",
				"hail_silicon"      = "Ah! Hello, robot. We only sell things that hm.... people can hold in their hands, unfortunately. You are still allowed to buy, though!",
				"hail_deny"         = "Oh no. I don't want to deal with YOU.",

				"trade_complete"    = "Thank you! Now remember, there isn't any return policy here, so be careful with that!",
				"trade_refuse"      = "Oh no, I have to make a living.",
				"how_much"          = "Well... I bought it for a lot, but I'll give it to you for VALUE.",

				"compliment_deny"   = "Uh... did you say something?",
				"compliment_accept" = "Mhm! I can agree to that!",
				"insult_good"       = "Wow, where was that coming from?",
				"insult_bad"        = "Don't make me blacklist your connection.",
				)