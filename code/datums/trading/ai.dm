/*

TRADING BEACON

Trading beacons are generic AI driven trading outposts.
They sell generic supplies and ask for generic supplies.
*/

/datum/trader/trading_beacon
	name = "AI"
	origin = "Trading Beacon"
	language = LANGUAGE_EAL

	trade_goods = 25
	speech = list("hail_generic"    = "Greetings, I am MERCHANT, Artifical Intelligence onboard ORIGIN, tasked with trading goods in return for thalers and supplies.",
				"hail_resomi"       = "Greetings, I am MERCHANT, Artifical Intelligence onboard ORIGIN. We wish to trade with you, no more.",
				"hail_deny"         = "We are sorry, your connection has been blacklisted. Have a nice day.",

				"trade"             = "We have calculated the following trade offer: PROPOSAL for ITEM. Will that suffice?",
				"trade_wanted"      = "Our priority trade database shows need of ITEM, will PROPOSAL be sufficient payment?",
				"trade_known"       = "ITEM for PROPOSAL has already been logged in our systems.",
				"trade_complete"    = "Thank you for your patronage.",
				"trade_refuse"      = "I'm sorry, I do not recognize that as a trade item.",
				"trade_out"         = "I'm sorry, we are out of suitable trading options.",

				"offer_change"      = "This is within our established parameters. Trade changed.",
				"offer_reject"      = "I am sorry, my trading algorithms indicate that changing this trade is a bad idea.",

				"complement_deny"   = "I'm sorry, I am not allowed to let complements affect the trade.",
				"complement_accept" = "Thank you, but that will not not change our business interactions.",
				"insult_good"       = "I do not understand, are we not on good terms?",
				"insult_bad"        = "I do not understand, are you insulting me?",

				"want"              = "My database shows need for",
				"want_deny"         = "I'm sorry, but security protocal dictate I cannot tell you that."
				)
	possible_wanted_items = list(/obj/item/weapon/         = TRADER_SUBTYPES_ONLY)
	possible_trading_items = list(/obj/item/weapon/        = TRADER_SUBTYPES_ONLY)

	insult_drop = 0
	complement_increase = 0

/datum/trader/trading_beacon/New()
	..()
	origin = "[origin] #[rand(100,999)]"

/datum/trader/trading_beacon/mine
	origin = "Mining Beacon"

	possible_trading_items = list(/obj/item/weapon/ore              = TRADER_SUBTYPES_ONLY,
								/obj/item/stack/material/           = TRADER_SUBTYPES_ONLY,
								/obj/item/stack/material/animalhide = TRADER_BLACKLIST_ALL,
								/obj/item/stack/material/cyborg     = TRADER_BLACKLIST_ALL,
								/obj/item/stack/material/leather    = TRADER_BLACKLIST,
								/obj/item/stack/material/wetleather = TRADER_BLACKLIST,
								/obj/item/stack/material/wood       = TRADER_BLACKLIST,
								/obj/item/stack/material/xenochitin = TRADER_BLACKLIST,
								/obj/machinery/mining               = TRADER_SUBTYPES_ONLY
								)

/datum/trader/trading_beacon/manufacturing
	origin = "Manifacturing Beacon"

	possible_trading_items = list(/obj/structure/AIcore             = TRADER_THIS_TYPE,
								/obj/structure/bed                  = TRADER_ALL,
								/obj/structure/bed/chair/e_chair    = TRADER_BLACKLIST,
								/obj/structure/bed/nest             = TRADER_BLACKLIST,
								/obj/structure/dispenser            = TRADER_SUBTYPES_ONLY,
								/obj/structure/filingcabinet        = TRADER_THIS_TYPE,
								/obj/structure/showcase             = TRADER_THIS_TYPE,
								/obj/structure/safe                 = TRADER_THIS_TYPE,
								/obj/structure/plushie              = TRADER_SUBTYPES_ONLY,
								/obj/structure/sign                 = TRADER_SUBTYPES_ONLY,
								/obj/structure/sign/double          = TRADER_BLACKLIST_ALL,
								/obj/structure/sign/poster           = TRADER_BLACKLIST
								)