/datum/trader/ship/unique/what_do_you_want()
	if(prob(disposition))
		return get_response("want")
	return get_response("want_deny")

/datum/trader/ship/unique/severance
	name = "Unknown"
	origin = "SGS Severance"

	trade_wanted_only = 1
	trade_goods = 50

	possible_wanted_items = list(
							/obj/item/weapon/reagent_containers/food/snacks/human                      = TRADER_SUBTYPES_ONLY,
							/obj/item/weapon/reagent_containers/food/snacks/meat/human                 = TRADER_THIS_TYPE,
							/mob/living/carbon/human                                                   = TRADER_ALL
							)

	possible_trading_items = list(/obj/mecha/combat                                                    = TRADER_SUBTYPES_ONLY,
							/obj/item/weapon/gun/projectile/automatic                                  = TRADER_SUBTYPES_ONLY
							)

	blacklisted_trade_items = null

	speech = list("hail_generic"     = "H-hello. Can you hear me? G-good... I have... specific needs... I have a lot to t-trade with you in return of course.",
				"hail_deny"          = "--CONNECTION SEVERED--",

				"trade"              = "Yes... I suppose that will do... I'll give you PROPOSAL for ITEM.",
				"trade_wanted"       = "YES! You understand, then. W-what I need. I'll give you PROPOSAL for that.",
				"trade_known"        = "Yes... thats what we a-agreed on, yes?",
				"trade_complete"     = "Hahahahahahaha! Thankyouthankyouthankyou!",
				"trade_refuse"       = "No! T-that isn't even close...",
				"trade_out"          = "I... don't have en-nough... how is this possible? I always.... have enough..",


				"offer_change"       = "I-I suppose I can do that.",
				"offer_deny"         = "No! Not even... THAT, is worth that much.",

				"complement_deny"    = "Your lies won't c-change what I did.",
				"complement_accept"  = "Yes... I suppose you're right.",
				"insult_good"        = "I... probably deserve that.",
				"insult_bad"         = "Maybe you should c-come here and say that. You'd be worth s-something then.",

				"want"               = "I... need... I just... food. The kind that they don't serve you, if you u-understand.",
				"want_deny"          = "N-no... that's my shame to bear."
				)


/datum/trader/ship/unique/rock
	name = "Bobo"
	origin = "Floating Rock"

	trade_wanted_only = 1
	trade_goods = 100
	possible_wanted_items  = list(/obj/item/weapon/ore                        = TRADER_ALL)
	possible_trading_items = list(/obj/machinery/power/supermatter            = TRADER_ALL)

	speech = list("hail_generic"     = "Blub am MERCHANT. Blub hunger for things. Boo bring them to blub, yes?",
				"hail_deny"          = "Blub does not want to speak to boo.",

				"trade"              = "Blub like this! Boo will get PROPOSAL for ITEM. Bood change.",
				"trade_wanted"       = "Blub wants ITEM a lot. Bood ITEM, Breat ITEM! Boo give it for PROPOSAL?",
				"trade_known"        = "Blub knows about this already.",
				"trade_complete"     = "Blub likes to trade!",
				"trade_refuse"       = "No, Blub will not do that.",
				"trade_out"          = "Blub does not know what to give for that.",


				"offer_change"       = "Blub am bood with this change.",
				"offer_deny"         = "Blub don't like this change.",

				"complement_deny"    = "Blub is just MERCHANT. What do bou mean?",
				"complement_accept"  = "Boo are a bood berson!",
				"insult_good"        = "Blub do not understand. Blub thought we were briends.",
				"insult_bad"         = "Blub feels bad now.",

				"want"               = "Blub has many thing. Want more bock. Boo bring bock, will trade.",
				"want_deny"          = "No, Blub does not think we are briends enough to tell boo that.."
				)

//probably could stick soem Howl references in here but like, eh. Haven't seen it in years.
/datum/trader/ship/unique/wizard
	name = "Wizard"
	origin = "A Moving Castle"
	language = "Common"

	trade_wanted_only = 1
	trade_goods = 100
	possible_wanted_items = list(/mob/living/simple_animal/construct            = TRADER_SUBTYPES_ONLY,
								/obj/item/weapon/melee/cultblade                = TRADER_THIS_TYPE,
								/obj/item/clothing/head/culthood                = TRADER_ALL,
								/obj/item/clothing/suit/space/cult              = TRADER_ALL,
								/obj/item/clothing/suit/cultrobes               = TRADER_ALL,
								/obj/item/clothing/head/helmet/space/cult       = TRADER_ALL,
								/obj/structure/cult                             = TRADER_SUBTYPES_ONLY,
								/obj/structure/constructshell                   = TRADER_ALL,
								/mob/living/simple_animal/familiar              = TRADER_SUBTYPES_ONLY,
								/mob/living/simple_animal/familiar/pet          = TRADER_BLACKLIST,
								/mob/living/simple_animal/hostile/mimic         = TRADER_ALL)

	possible_trading_items = list(/obj/item/clothing/gloves/purple/wizard        = TRADER_THIS_TYPE,
								/obj/item/clothing/head/helmet/space/void/wizard = TRADER_THIS_TYPE,
								/obj/item/clothing/head/wizard                   = TRADER_ALL,
								/obj/item/clothing/suit/space/void/wizard        = TRADER_THIS_TYPE,
								/obj/item/toy/figure/wizard                      = TRADER_THIS_TYPE
								) //Probably see about getting some more wizard based shit

	speech = list("hail_generic"     = "Hello! Are you here on pleasure or business?",
				"hail_deny"          = "I'm sorry, but I REALLY don't want to speak to you.",

				"trade"              = "Hmm. an oddity for sure, I'll trade you PROPOSAL for ITEM.",
				"trade_wanted"       = "Finally! Something good! I'll send you PROPOSAL for that ITEM.",
				"trade_known"        = "Yes yes yes, we've already discussed this.",
				"trade_complete"     = "Pleasure doing business with you! Just don't feed it after midnight!",
				"trade_refuse"       = "Absolutely not.",
				"trade_out"          = "I'm afraid I don't have enough to trade for that.",


				"offer_change"       = "Hm. I liked it better before but.... yes.",
				"offer_deny"         = "How insulting. The answer is no.",

				"complement_deny"    = "Like I haven't heard that one before!",
				"complement_accept"  = "Haha! Aren't you nice.",
				"insult_good"        = "Naughty naughty.",
				"insult_bad"         = "Now where do you get off talking to me like that?",

				"want"               = "Hmmm... I want oddities. Things of that nature. Something... dark, demonic, perhaps?",
				"want_deny"          = "Oh no no no. Where would the mystery be, then?"
				)