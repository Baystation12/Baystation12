/*

TRADING BEACON

Trading beacons are generic AI driven trading outposts.
They sell generic supplies and ask for generic supplies.
*/

/datum/trader/trading_beacon
	name = "AI"
	origin = "Trading Beacon"
	name_language = LANGUAGE_EAL
	trade_flags = TRADER_MONEY|TRADER_GOODS
	speech = list("hail_generic"    = "Greetings, I am MERCHANT, Artifical Intelligence onboard ORIGIN, tasked with trading goods in return for thalers and supplies.",
				"hail_resomi"       = "Greetings, I am MERCHANT, Artifical Intelligence onboard ORIGIN. We wish to trade with you, no more.",
				"hail_deny"         = "We are sorry, your connection has been blacklisted. Have a nice day.",

				"trade_complete"    = "Thank you for your patronage.",
				"trade_not_enough"  = "I'm sorry, your offer is not worth what you are asking for.",
				"trade_blacklisted" = "You have offered a blacklisted item. My laws do not allow me to trade for that.",
				"how_much"          = "ITEM will cost you roughly VALUE thalers, or something of equal worth.",
				"what_want"         = "I have logged need for",

				"compliment_deny"   = "I'm sorry, I am not allowed to let compliments affect the trade.",
				"compliment_accept" = "Thank you, but that will not not change our business interactions.",
				"insult_good"       = "I do not understand, are we not on good terms?",
				"insult_bad"        = "I do not understand, are you insulting me?",

				"bribe_refusal"     = "You have given me money to stay, however, I am a station. I do not leave.",
				)
	possible_wanted_items = list(/obj/item/device/                       = TRADER_SUBTYPES_ONLY,
								/obj/item/device/assembly                = TRADER_BLACKLIST_ALL,
								/obj/item/device/assembly_holder         = TRADER_BLACKLIST_ALL,
								/obj/item/device/encryptionkey/syndicate = TRADER_BLACKLIST,
								/obj/item/weapon/tank/phoron/onetankbomb = TRADER_BLACKLIST,
								/obj/item/device/radio                   = TRADER_BLACKLIST_ALL,
								/obj/item/device/pda                     = TRADER_BLACKLIST_SUB,
								/obj/item/device/uplink                  = TRADER_BLACKLIST)
	possible_trading_items = list(/obj/item/weapon/storage/bag                       = TRADER_SUBTYPES_ONLY,
								/obj/item/weapon/storage/bag/cash/infinite           = TRADER_BLACKLIST,
								/obj/item/weapon/storage/backpack                    = TRADER_ALL,
								/obj/item/weapon/storage/backpack/cultpack           = TRADER_BLACKLIST,
								/obj/item/weapon/storage/backpack/holding            = TRADER_BLACKLIST,
								/obj/item/weapon/storage/backpack/satchel/withwallet = TRADER_BLACKLIST,
								/obj/item/weapon/storage/backpack/satchel/syndie_kit = TRADER_BLACKLIST_ALL,
								/obj/item/weapon/storage/backpack/chameleon          = TRADER_BLACKLIST,
								/obj/item/weapon/storage/backpack/ert                = TRADER_BLACKLIST_ALL,
								/obj/item/weapon/storage/backpack/dufflebag/syndie   = TRADER_BLACKLIST_SUB,
								/obj/item/weapon/storage/belt/champion               = TRADER_THIS_TYPE,
								/obj/item/weapon/storage/briefcase                   = TRADER_THIS_TYPE,
								/obj/item/weapon/storage/fancy                       = TRADER_SUBTYPES_ONLY,
								/obj/item/weapon/storage/laundry_basket              = TRADER_THIS_TYPE,
								/obj/item/weapon/storage/secure/briefcase            = TRADER_THIS_TYPE,
								/obj/item/weapon/storage/plants                      = TRADER_THIS_TYPE,
								/obj/item/weapon/storage/ore                         = TRADER_THIS_TYPE,
								/obj/item/weapon/storage/toolbox                     = TRADER_ALL,
								/obj/item/weapon/storage/wallet                      = TRADER_THIS_TYPE,
								/obj/item/weapon/storage/photo_album                 = TRADER_THIS_TYPE,
								/obj/item/clothing/glasses                           = TRADER_SUBTYPES_ONLY,
								/obj/item/clothing/glasses/hud                       = TRADER_BLACKLIST_ALL,
								/obj/item/clothing/glasses/sunglasses/blindfold/tape = TRADER_BLACKLIST,
								/obj/item/clothing/glasses/chameleon                 = TRADER_BLACKLIST
								)

	insult_drop = 0
	compliment_increase = 0

/datum/trader/trading_beacon/New()
	..()
	origin = "[origin] #[rand(100,999)]"

/datum/trader/trading_beacon/mine
	origin = "Mining Beacon"

	possible_trading_items = list(/obj/item/weapon/ore                    = TRADER_SUBTYPES_ONLY,
								/obj/item/stack/material/glass            = TRADER_ALL,
								/obj/item/stack/material/glass/fifty      = TRADER_BLACKLIST,
								/obj/item/stack/material/iron             = TRADER_THIS_TYPE,
								/obj/item/stack/material/sandstone        = TRADER_THIS_TYPE,
								/obj/item/stack/material/marble           = TRADER_THIS_TYPE,
								/obj/item/stack/material/diamond          = TRADER_THIS_TYPE,
								/obj/item/stack/material/uranium          = TRADER_THIS_TYPE,
								/obj/item/stack/material/phoron           = TRADER_THIS_TYPE,
								/obj/item/stack/material/plastic          = TRADER_THIS_TYPE,
								/obj/item/stack/material/gold             = TRADER_THIS_TYPE,
								/obj/item/stack/material/silver           = TRADER_THIS_TYPE,
								/obj/item/stack/material/platinum         = TRADER_THIS_TYPE,
								/obj/item/stack/material/mhydrogen        = TRADER_THIS_TYPE,
								/obj/item/stack/material/tritium          = TRADER_THIS_TYPE,
								/obj/item/stack/material/osmium           = TRADER_THIS_TYPE,
								/obj/item/stack/material/steel            = TRADER_THIS_TYPE,
								/obj/item/stack/material/plasteel         = TRADER_THIS_TYPE,
								/obj/machinery/mining                     = TRADER_SUBTYPES_ONLY
								)

/datum/trader/trading_beacon/manufacturing
	origin = "Manifacturing Beacon"

	possible_trading_items = list(/obj/structure/AIcore             = TRADER_THIS_TYPE,
								/obj/structure/girder               = TRADER_THIS_TYPE,
								/obj/structure/grille               = TRADER_THIS_TYPE,
								/obj/structure/mopbucket            = TRADER_THIS_TYPE,
								/obj/structure/ore_box              = TRADER_THIS_TYPE,
								/obj/structure/coatrack             = TRADER_THIS_TYPE,
								/obj/structure/bookcase             = TRADER_THIS_TYPE,
								/obj/item/bee_pack                  = TRADER_THIS_TYPE,
								/obj/item/bee_smoker                = TRADER_THIS_TYPE,
								/obj/item/beehive_assembly          = TRADER_THIS_TYPE,
								/obj/item/glass_jar                 = TRADER_THIS_TYPE,
								/obj/item/honey_frame               = TRADER_THIS_TYPE,
								/obj/item/target                    = TRADER_ALL,
								/obj/structure/dispenser            = TRADER_SUBTYPES_ONLY,
								/obj/structure/filingcabinet        = TRADER_THIS_TYPE,
								/obj/structure/safe                 = TRADER_THIS_TYPE,
								/obj/structure/plushie              = TRADER_SUBTYPES_ONLY,
								/obj/structure/sign                 = TRADER_SUBTYPES_ONLY,
								/obj/structure/sign/double          = TRADER_BLACKLIST_ALL,
								/obj/structure/sign/goldenplaque    = TRADER_BLACKLIST_ALL,
								/obj/structure/sign/poster          = TRADER_BLACKLIST
								)