/datum/trader/pizzaria
	name = "Pizza Shop Employee"
	language = "Common"
	origin = "Pizzeria"
	trade_goods = 0
	possible_wanted_items = list() //They are a pizza shop, not a bargainer.
	possible_trading_items = list(/obj/item/pizzabox/   = TRADER_SUBTYPES_ONLY)

	speech = list("hail_generic"    = "Hello! Welcome to ORIGIN, may I take your order?",
				"hail_deny"         = "Beeeep... I'm sorry, your connection has been severed.",

				"trade"             = "Alright, the PROPOSAL will cost you ITEM. Will that be all?",
				"trade_wanted"      = "My manager says I'm allowed to give you PROPOSAL for ITEM, is that alright?",
				"trade_known"       = "Yeah, thats correct.",
				"trade_complete"    = "Thank you for choosing ORIGIN!",
				"trade_refuse"      = "Uhh... I don't think we can do that.",
				"trade_out"         = "Uuuh... My manager says we're out of pizza...",

				"offer_change"      = "Yeah sure, my manager says we can do that.",
				"offer_reject"      = "Sorry sir, I'm not allowed to accept that change.",

				"complement_deny"   = "That's a bit forward, don't you think?",
				"complement_accept" = "Thanks, sir! You're very nice!",
				"insult_good"       = "Please stop that, sir.",
				"insult_bad"        = "Sir, just because I'm contractually obligated to keep you on the line for a minute doesn't mean I have to take this.",

				"want"              = "My manager says we need",
				"want_deny"         = "My manager says not to tell you that."
				)


/datum/trader/pizzaria/New()
	..()
	origin = pick("Papa Joes", "Pizza Ship", "Dominator Pizza", "Little Kaezars", "Pizza Planet")

/datum/trader/ship/chinese
	name = "Chinese Restaurant"
	language = "Common"
	origin = "Captain Panda Bistro"
	trade_goods = 0
	possible_wanted_items = list()
	possible_trading_items = list(/obj/item/weapon/reagent_containers/food/snacks/monkeykabob          = TRADER_THIS_TYPE,
							/obj/item/weapon/reagent_containers/food/snacks/monkeysdelight             = TRADER_THIS_TYPE,
							/obj/item/weapon/reagent_containers/food/snacks/ricepudding                = TRADER_THIS_TYPE,
							/obj/item/weapon/reagent_containers/food/snacks/slice/xenomeatbread/filled = TRADER_THIS_TYPE,
							/obj/item/weapon/reagent_containers/food/snacks/soydope                    = TRADER_THIS_TYPE,
							/obj/item/weapon/reagent_containers/food/snacks/stewedsoymeat              = TRADER_THIS_TYPE,
							/obj/item/weapon/reagent_containers/food/snacks/wingfangchu                = TRADER_THIS_TYPE,
							/obj/item/weapon/reagent_containers/food/drinks/dry_ramen                  = TRADER_THIS_TYPE
							)

	var/list/fortunes = list("Today it's up to you to create the peacefulness you long for.",
							"If you refuse to accept anything but the best, you very often get it.",
							"A smile is your passport into the hearts of others.",
							"Hard work pays off in the future, laziness pays off now.",
							"Change can hurt, but it leads a path to something better.",
							"Hidden in a valley beside an open stream- This will be the type of place where you will find your dream.",
							"Never give up. You're not a failure if you don't give up.",
							"Love can last a lifetime, if you want it to.",
							"The love of your life is stepping into your planet this summer.",
							"Your ability for accomplishment will follow with success.")

	speech = list("hail_generic"     = "There are two things constant in life, death and Chinese food. How may I help you?",
				"hail_deny"          = "We do not take orders from rude customers.",

				"trade"              = "Yes, PROPOSAL will cost you ITEM, is that all you want?",
				"trade_wanted"       = "Aaaah! I always wanted ITEM. I will give you PROPOSAL for it.",
				"trade_known"        = "Yes, as we agreed previously.",
				"trade_complete"     = "Thank you sir for your patronage.",
				"trade_refuse"       = "No, I am sorry that is not possible.",
				"trade_out"          = "Hmm... I'm sorry, I don't know what to give you for that.",


				"offer_change"       = "Hmmmm... yes, I'll allow that.",
				"offer_deny"         = "You are not the only one who needs to eat, I cannot accept that.",

				"complement_deny"    = "That was an odd thing to say, you are very odd.",
				"complement_accept"  = "Good philosophy, see good in bad, I like.",
				"insult_good"        = "As a man said long ago, \"When anger rises, think of the consequences.\" Think on that.",
				"insult_bad"         = "I do not need to take this from you.",

				"want"               = "I require",
				"want_deny"          = "I'm sorry, but that is not your business."
				)

/datum/trader/ship/chinese/trade(var/atom/movable/offer)
	var/turf/T = get_turf(offer)
	. = ..()
	if(.)
		var/obj/item/weapon/reagent_containers/food/snacks/fortunecookie/cookie = new(T)
		var/obj/item/weapon/paper/paper = new(cookie)
		cookie.trash = paper
		paper.name = "Fortune"
		paper.info = pick(fortunes)

/datum/trader/grocery
	name = "Grocer"
	origin = "Grocery Store"
	language = "Common"
	trade_goods = 0

	possible_trading_items = list(/obj/item/weapon/reagent_containers/food/snacks                      = TRADER_SUBTYPES_ONLY,
							/obj/item/weapon/reagent_containers/food/drinks/cans                       = TRADER_SUBTYPES_ONLY,
							/obj/item/weapon/reagent_containers/food/drinks/bottle                     = TRADER_SUBTYPES_ONLY,
							/obj/item/weapon/reagent_containers/food/drinks/bottle/small               = TRADER_BLACKLIST,
							/obj/item/weapon/reagent_containers/food/snacks/boiledslimecore            = TRADER_BLACKLIST,
							/obj/item/weapon/reagent_containers/food/snacks/checker                    = TRADER_BLACKLIST_ALL,
							/obj/item/weapon/reagent_containers/food/snacks/fruit_slice                = TRADER_BLACKLIST,
							/obj/item/weapon/reagent_containers/food/snacks/grown                      = TRADER_BLACKLIST_ALL,
							/obj/item/weapon/reagent_containers/food/snacks/human                      = TRADER_BLACKLIST_ALL
							)

	speech = list("hail_generic"     = "Hello, welcome to ORIGIN, grocery store of the future!",
				"hail_deny"          = "I'm sorry, we've blacklisted your communications due to rude behavior.",

				"trade"              = "PROPOSAL will cost you a total of ITEM, is that all?",
				"trade_wanted"       = "Well, we at ORIGIN do need ITEM. We'll give you PROPOSAL for it.",
				"trade_known"        = "Mhm!",
				"trade_complete"     = "Thank you for shopping at ORIGIN!",
				"trade_refuse"       = "I'm sorry, ORIGIN doesn't take that as payment.",
				"trade_out"          = "I'm very sorry, we currently don't have anything to trade for that.",


				"offer_change"       = "Very well!",
				"offer_deny"         = "I'm afraid I'm going to have to deny that.",

				"complement_deny"    = "Sir, this is a professional environment. Please don't make me get my manager.",
				"complement_accept"  = "Thank you, sir!",
				"insult_good"        = "Sir, please do not make a scene.",
				"insult_bad"         = "Sir, I WILL get my manager if you don't calm down.",

				"want"               = "ORIGIN needs",
				"want_deny"          = "I'm sorry, but its company policy to not tell you that."
				)

/datum/trader/grocery/New()
	..()
	origin = pick("HyTee", "Kreugars", "Spaceway", "Privaxs", "FutureValue")