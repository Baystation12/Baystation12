/datum/trader/pizzaria
	name = "Pizza Shop Employee"
	name_language = TRADER_DEFAULT_NAME
	origin = "Pizzeria"
	possible_origins = list("Papa Joe's", "Pizza Ship", "Dominator Pizza", "Little Kaezars", "Pizza Planet", "Cheese Louise", "Little Taste o' Neo-Italy", "Pizza Gestapo")
	trade_flags = TRADER_MONEY
	possible_wanted_items = list() //They are a pizza shop, not a bargainer.
	possible_trading_items = list(/obj/item/reagent_containers/food/snacks/sliceable/pizza   = TRADER_SUBTYPES_ONLY)

	speech = list(TRADER_HAIL_GENERIC    = "Hello! Welcome to ORIGIN, may I take your order?",
				TRADER_HAIL_DENY         = "Beeeep... I'm sorry, your connection has been severed.",

				TRADER_TRADE_COMPLETE    = "Thank you for choosing ORIGIN!",
				TRADER_NO_GOODS    = "I'm sorry but we only take cash.",
				TRADER_NO_BLACKLISTED = "Sir that's... highly illegal.",
				TRADER_NOT_ENOUGH  = "Uhh... that's not enough money for pizza.",
				TRADER_HOW_MUCH          = "That pizza will cost you VALUE CURRENCY.",

				TRADER_COMPLEMENT_FAILURE   = "That's a bit forward, don't you think?",
				TRADER_COMPLEMENT_SUCCESS = "Thanks, sir! You're very nice!",
				TRADER_INSULT_GOOD       = "Please stop that, sir.",
				TRADER_INSULT_BAD        = "Sir, just because I'm contractually obligated to keep you on the line for a minute doesn't mean I have to take this.",

				TRADER_BRIBE_FAILURE     = "Uh... thanks for the cash, sir. As long as you're in the area, we'll be here...",
				)

/datum/trader/pizzaria/trade_quantity(quantity, list/offers, num, turf/location)
	. = ..()
	for (var/atom/movable/M in .)
		var/obj/item/pizzabox/box = new(location)
		M.forceMove(box)
		box.pizza = M
		box.boxtag = "A special order from [origin]"

/datum/trader/ship/chinese
	name = "Chinese Restaurant"
	name_language = TRADER_DEFAULT_NAME
	origin = "Captain Panda Bistro"
	possible_origins = list("888 Shanghai Kitchen", "Mr. Lee's Greater Hong Kong", "The House of the Venerable and Inscrutable Colonel", "Lucky Dragon")
	trade_flags = TRADER_MONEY
	possible_wanted_items = list()
	possible_trading_items = list(/obj/item/reagent_containers/food/snacks/meatkabob    	       = TRADER_THIS_TYPE,
							/obj/item/reagent_containers/food/snacks/monkeysdelight             = TRADER_THIS_TYPE,
							/obj/item/reagent_containers/food/snacks/ricepudding                = TRADER_THIS_TYPE,
							/obj/item/reagent_containers/food/snacks/slice/xenomeatbread/filled = TRADER_THIS_TYPE,
							/obj/item/reagent_containers/food/snacks/soydope                    = TRADER_THIS_TYPE,
							/obj/item/reagent_containers/food/snacks/stewedsoymeat              = TRADER_THIS_TYPE,
							/obj/item/reagent_containers/food/drinks/dry_ramen                  = TRADER_THIS_TYPE
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
							"Your ability for accomplishment will follow with success.",
							"Please help me, I'm trapped in a fortune cookie factory!")

	speech = list(TRADER_HAIL_GENERIC     = "There are two things constant in life, death and Chinese food. How may I help you?",
				TRADER_HAIL_DENY          = "We do not take orders from rude customers.",

				TRADER_TRADE_COMPLETE     = "Thank you, sir, for your patronage.",
				TRADER_NO_BLACKLISTED    = "No, that is very odd. Why would you trade that away?",
				TRADER_NO_GOODS     = "I only accept money transfers.",
				TRADER_NOT_ENOUGH   = "No, I am sorry, that is not possible. I need to make a living.",
				TRADER_HOW_MUCH           = "I give you ITEM, for VALUE CURRENCY. No more, no less.",

				TRADER_COMPLEMENT_FAILURE    = "That was an odd thing to say. You are very odd.",
				TRADER_COMPLEMENT_SUCCESS  = "Good philosophy, see good in bad, I like.",
				TRADER_INSULT_GOOD        = "As a man said long ago, \"When anger rises, think of the consequences.\" Think on that.",
				TRADER_INSULT_BAD         = "I do not need to take this from you.",

				TRADER_BRIBE_FAILURE     = "Hm... I'll think about it.",
				TRADER_BRIBE_SUCCESS      = "Oh yes! I think I'll stay a few more minutes, then.",
				)

/datum/trader/ship/chinese/trade_quantity(quantity, list/offers, num, turf/location)
	. = ..()
	quantity = 1
	if(.)
		var/obj/item/reagent_containers/food/snacks/fortunecookie/cookie = new(location)
		var/obj/item/paper/paper = new(cookie)
		cookie.trash = paper
		paper.SetName("Fortune")
		paper.info = pick(fortunes)

/datum/trader/grocery
	name = "Grocer"
	name_language = TRADER_DEFAULT_NAME
	possible_origins = list("HyTee", "Kreugars", "Spaceway", "Privaxs", "FutureValue", "Phyvendyme", "Skreller's Market")
	trade_flags = TRADER_MONEY

	possible_trading_items = list(/obj/item/reagent_containers/food/snacks                      = TRADER_SUBTYPES_ONLY,
							/obj/item/reagent_containers/food/drinks/cans                       = TRADER_SUBTYPES_ONLY,
							/obj/item/reagent_containers/food/drinks/bottle                     = TRADER_SUBTYPES_ONLY,
							/obj/item/reagent_containers/food/drinks/bottle/small               = TRADER_BLACKLIST,
							/obj/item/reagent_containers/food/snacks/boiledslimecore            = TRADER_BLACKLIST,
							/obj/item/reagent_containers/food/snacks/checker                    = TRADER_BLACKLIST_ALL,
							/obj/item/reagent_containers/food/snacks/fruit_slice                = TRADER_BLACKLIST,
							/obj/item/reagent_containers/food/snacks/slice                      = TRADER_BLACKLIST_ALL,
							/obj/item/reagent_containers/food/snacks/grown                      = TRADER_BLACKLIST_ALL,
							/obj/item/reagent_containers/food/snacks/human                      = TRADER_BLACKLIST_ALL,
							/obj/item/reagent_containers/food/snacks/sliceable/braincake        = TRADER_BLACKLIST,
							/obj/item/reagent_containers/food/snacks/meat/human                 = TRADER_BLACKLIST,
							/obj/item/reagent_containers/food/snacks/variable                   = TRADER_BLACKLIST_ALL
							)

	speech = list(TRADER_HAIL_GENERIC     = "Hello, welcome to ORIGIN, grocery store of the future!",
				TRADER_HAIL_DENY          = "I'm sorry, we've blacklisted your communications due to rude behavior.",

				TRADER_TRADE_COMPLETE     = "Thank you for shopping at ORIGIN!",
				TRADER_NO_BLACKLISTED    = "I... wow, that's... no, sir. No.",
				TRADER_NO_GOODS     = "ORIGIN only accepts cash, sir.",
				TRADER_NOT_ENOUGH   = "That is not enough money, sir.",
				TRADER_HOW_MUCH           = "Sir, that'll cost you VALUE CURRENCY. Will that be all?",

				TRADER_COMPLEMENT_FAILURE    = "Sir, this is a professional environment. Please don't make me get my manager.",
				TRADER_COMPLEMENT_SUCCESS  = "Thank you, sir!",
				TRADER_INSULT_GOOD        = "Sir, please do not make a scene.",
				TRADER_INSULT_BAD         = "Sir, I WILL get my manager if you don't calm down.",

				TRADER_BRIBE_FAILURE      = "Of course sir! ORIGIN is always here for you!",
				)

/datum/trader/bakery
	name = "Pastry Chef"
	name_language = TRADER_DEFAULT_NAME
	origin = "Bakery"
	possible_origins = list("Cakes By Design", "Corner Bakery Local", "My Favorite Cake & Pastry Cafe", "Mama Joes Bakery", "Sprinkles and Fun", "Cakestrosity")

	speech = list(TRADER_HAIL_GENERIC     = "Hello, welcome to ORIGIN! We serve baked goods, including pies, cakes, and anything sweet!",
				TRADER_HAIL_DENY          = "Our food is a privilege, not a right. Goodbye.",

				TRADER_TRADE_COMPLETE     = "Thank you for your purchase! Come again if you're hungry for more!",
				TRADER_NO_BLACKLISTED    = "We only accept money. Not... that.",
				TRADER_NO_GOODS     = "Cash for cakes! That's our business!",
				TRADER_NOT_ENOUGH   = "Our dishes are much more expensive than that, sir.",
				TRADER_HOW_MUCH           = "That lovely dish will cost you VALUE CURRENCY.",

				TRADER_COMPLEMENT_FAILURE    = "Oh wow, how nice of you...",
				TRADER_COMPLEMENT_SUCCESS  = "You're almost as sweet as my pies!",
				TRADER_INSULT_GOOD        = "My pies are NOT knockoffs!",
				TRADER_INSULT_BAD         = "Well, aren't you a sour apple?",

				TRADER_BRIBE_FAILURE      = "Oh ho ho! I'd never think of taking ORIGIN on the road!",
				)
	possible_trading_items = list(/obj/item/reagent_containers/food/snacks/slice/birthdaycake/filled     = TRADER_THIS_TYPE,
								/obj/item/reagent_containers/food/snacks/slice/carrotcake/filled         = TRADER_THIS_TYPE,
								/obj/item/reagent_containers/food/snacks/slice/cheesecake/filled         = TRADER_THIS_TYPE,
								/obj/item/reagent_containers/food/snacks/slice/chocolatecake/filled      = TRADER_THIS_TYPE,
								/obj/item/reagent_containers/food/snacks/slice/lemoncake/filled          = TRADER_THIS_TYPE,
								/obj/item/reagent_containers/food/snacks/slice/limecake/filled           = TRADER_THIS_TYPE,
								/obj/item/reagent_containers/food/snacks/slice/orangecake/filled         = TRADER_THIS_TYPE,
								/obj/item/reagent_containers/food/snacks/slice/plaincake/filled          = TRADER_THIS_TYPE,
								/obj/item/reagent_containers/food/snacks/slice/pumpkinpie/filled         = TRADER_THIS_TYPE,
								/obj/item/reagent_containers/food/snacks/slice/bananabread/filled        = TRADER_THIS_TYPE,
								/obj/item/reagent_containers/food/snacks/sliceable                       = TRADER_SUBTYPES_ONLY,
								/obj/item/reagent_containers/food/snacks/sliceable/pizza                 = TRADER_BLACKLIST_ALL,
								/obj/item/reagent_containers/food/snacks/sliceable/xenomeatbread         = TRADER_BLACKLIST,
								/obj/item/reagent_containers/food/snacks/sliceable/flatdough             = TRADER_BLACKLIST,
								/obj/item/reagent_containers/food/snacks/sliceable/braincake             = TRADER_BLACKLIST,
								/obj/item/reagent_containers/food/snacks/pie                             = TRADER_THIS_TYPE,
								/obj/item/reagent_containers/food/snacks/applepie                        = TRADER_THIS_TYPE)
