/datum/trader/pizzaria
	name = "Pizza Shop Employee"
	name_language = TRADER_DEFAULT_NAME
	origin = "Pizzeria"
	possible_origins = list("Papa Joes", "Pizza Ship", "Dominator Pizza", "Little Kaezars", "Pizza Planet", "Cheese Louise")
	trade_flags = TRADER_MONEY
	possible_wanted_items = list() //They are a pizza shop, not a bargainer.
	possible_trading_items = list(/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza   = TRADER_SUBTYPES_ONLY)

	speech = list("hail_generic"    = "Hello! Welcome to ORIGIN, may I take your order?",
				"hail_deny"         = "Beeeep... I'm sorry, your connection has been severed.",

				"trade_complete"    = "Thank you for choosing ORIGIN!",
				"trade_no_goods"    = "I'm sorry but we only take cash.",
				"trade_blacklisted" = "Sir thats... highly illegal.",
				"trade_not_enough"  = "Uhh... thats not enough money for pizza.",
				"how_much"          = "That pizza will cost you VALUE thalers.",

				"compliment_deny"   = "That's a bit forward, don't you think?",
				"compliment_accept" = "Thanks, sir! You're very nice!",
				"insult_good"       = "Please stop that, sir.",
				"insult_bad"        = "Sir, just because I'm contractually obligated to keep you on the line for a minute doesn't mean I have to take this.",

				"bribe_refusal"     = "Uh... thanks for the cash, sir. As long as you're in the area, we'll be here...",
				)

/datum/trader/pizzaria/trade(var/list/offers, var/num, var/turf/location)
	. = ..()
	if(.)
		var/atom/movable/M = .
		var/obj/item/pizzabox/box = new(location)
		M.forceMove(box)
		box.pizza = M
		box.boxtag = "A special order from [origin]"

/datum/trader/ship/chinese
	name = "Chinese Restaurant"
	name_language = TRADER_DEFAULT_NAME
	origin = "Captain Panda Bistro"
	trade_flags = TRADER_MONEY
	possible_wanted_items = list()
	possible_trading_items = list(/obj/item/weapon/reagent_containers/food/snacks/meatkabob    	       = TRADER_THIS_TYPE,
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

				"trade_complete"     = "Thank you sir for your patronage.",
				"trade_blacklist"    = "No, that is very odd. Why would you trade that away?",
				"trade_no_goods"     = "I only accept money transfers.",
				"trade_not_enough"   = "No, I am sorry that is not possible. I need to make a living.",
				"how_much"           = "I give you ITEM for VALUE thalers. No more, no less.",

				"compliment_deny"    = "That was an odd thing to say, you are very odd.",
				"compliment_accept"  = "Good philosophy, see good in bad, I like.",
				"insult_good"        = "As a man said long ago, \"When anger rises, think of the consequences.\" Think on that.",
				"insult_bad"         = "I do not need to take this from you.",

				"bribe_refusal"     = "Hm... I'll think about it.",
				"bribe_accept"      = "Oh yes! I think I'll stay a few more minutes, then.",
				)

/datum/trader/ship/chinese/trade(var/list/offers, var/num, var/turf/location)
	. = ..()
	if(.)
		var/obj/item/weapon/reagent_containers/food/snacks/fortunecookie/cookie = new(location)
		var/obj/item/weapon/paper/paper = new(cookie)
		cookie.trash = paper
		paper.name = "Fortune"
		paper.info = pick(fortunes)

/datum/trader/grocery
	name = "Grocer"
	name_language = TRADER_DEFAULT_NAME
	possible_origins = list("HyTee", "Kreugars", "Spaceway", "Privaxs", "FutureValue")
	trade_flags = TRADER_MONEY

	possible_trading_items = list(/obj/item/weapon/reagent_containers/food/snacks                      = TRADER_SUBTYPES_ONLY,
							/obj/item/weapon/reagent_containers/food/drinks/cans                       = TRADER_SUBTYPES_ONLY,
							/obj/item/weapon/reagent_containers/food/drinks/bottle                     = TRADER_SUBTYPES_ONLY,
							/obj/item/weapon/reagent_containers/food/drinks/bottle/small               = TRADER_BLACKLIST,
							/obj/item/weapon/reagent_containers/food/snacks/boiledslimecore            = TRADER_BLACKLIST,
							/obj/item/weapon/reagent_containers/food/snacks/checker                    = TRADER_BLACKLIST_ALL,
							/obj/item/weapon/reagent_containers/food/snacks/fruit_slice                = TRADER_BLACKLIST,
							/obj/item/weapon/reagent_containers/food/snacks/slice                      = TRADER_BLACKLIST_ALL,
							/obj/item/weapon/reagent_containers/food/snacks/grown                      = TRADER_BLACKLIST_ALL,
							/obj/item/weapon/reagent_containers/food/snacks/human                      = TRADER_BLACKLIST_ALL,
							/obj/item/weapon/reagent_containers/food/snacks/sliceable/braincake        = TRADER_BLACKLIST,
							/obj/item/weapon/reagent_containers/food/snacks/meat/human                 = TRADER_BLACKLIST,
							/obj/item/weapon/reagent_containers/food/snacks/variable                   = TRADER_BLACKLIST_ALL
							)

	speech = list("hail_generic"     = "Hello, welcome to ORIGIN, grocery store of the future!",
				"hail_deny"          = "I'm sorry, we've blacklisted your communications due to rude behavior.",

				"trade_complete"     = "Thank you for shopping at ORIGIN!",
				"trade_blacklist"    = "I... wow that's... no, sir. No.",
				"trade_no_goods"     = "ORIGIN only accepts cash, sir.",
				"trade_not_enough"   = "That is not enough money, sir.",
				"how_much"           = "Sir, that'll cost you VALUE thalers. Will that be all?",

				"compliment_deny"    = "Sir, this is a professional environment. Please don't make me get my manager.",
				"compliment_accept"  = "Thank you, sir!",
				"insult_good"        = "Sir, please do not make a scene.",
				"insult_bad"         = "Sir, I WILL get my manager if you don't calm down.",

				"bribe_refusal"      = "Of course sir! ORIGIN is always here for you!",
				)

/datum/trader/bakery
	name = "Pastry Chef"
	name_language = TRADER_DEFAULT_NAME
	origin = "Bakery"
	possible_origins = list("Cakes By Design", "Corner Bakery Local", "My Favorite Cake & Pastry Cafe", "Mama Joes Bakery", "Sprinkles and Fun")

	speech = list("hail_generic"     = "Hello, welcome to ORIGIN, we serve baked goods, including pies and cakes and anything sweet!",
				"hail_deny"          = "Our food is a privelege, not a right. Goodbye.",

				"trade_complete"     = "Thank you for your purchase! Come again if you're hungry for more!",
				"trade_blacklist"    = "We only accept money. Not... that.",
				"trade_no_goods"     = "Cash for Cakes! That's our business!",
				"trade_not_enough"   = "Our dishes are much more expensive than that, sir.",
				"how_much"           = "That lovely dish will cost you VALUE thalers.",

				"compliment_deny"    = "Oh wow, how nice of you...",
				"compliment_accept"  = "You're almost as sweet as my pies!",
				"insult_good"        = "My pie are NOT knockoffs!",
				"insult_bad"         = "Well, aren't you a sour apple?",

				"bribe_refusal"      = "Oh ho ho! I'd never think of taking ORIGIN on the road!",
				)
	possible_trading_items = list(/obj/item/weapon/reagent_containers/food/snacks/slice/birthdaycake/filled     = TRADER_THIS_TYPE,
								/obj/item/weapon/reagent_containers/food/snacks/slice/carrotcake/filled         = TRADER_THIS_TYPE,
								/obj/item/weapon/reagent_containers/food/snacks/slice/cheesecake/filled         = TRADER_THIS_TYPE,
								/obj/item/weapon/reagent_containers/food/snacks/slice/chocolatecake/filled      = TRADER_THIS_TYPE,
								/obj/item/weapon/reagent_containers/food/snacks/slice/lemoncake/filled          = TRADER_THIS_TYPE,
								/obj/item/weapon/reagent_containers/food/snacks/slice/limecake/filled           = TRADER_THIS_TYPE,
								/obj/item/weapon/reagent_containers/food/snacks/slice/orangecake/filled         = TRADER_THIS_TYPE,
								/obj/item/weapon/reagent_containers/food/snacks/slice/plaincake/filled          = TRADER_THIS_TYPE,
								/obj/item/weapon/reagent_containers/food/snacks/slice/pumpkinpie/filled         = TRADER_THIS_TYPE,
								/obj/item/weapon/reagent_containers/food/snacks/slice/bananabread/filled        = TRADER_THIS_TYPE,
								/obj/item/weapon/reagent_containers/food/snacks/sliceable                       = TRADER_SUBTYPES_ONLY,
								/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza                 = TRADER_BLACKLIST_ALL,
								/obj/item/weapon/reagent_containers/food/snacks/sliceable/xenomeatbread         = TRADER_BLACKLIST,
								/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough             = TRADER_BLACKLIST,
								/obj/item/weapon/reagent_containers/food/snacks/sliceable/braincake             = TRADER_BLACKLIST,
								/obj/item/weapon/reagent_containers/food/snacks/pie                             = TRADER_THIS_TYPE,
								/obj/item/weapon/reagent_containers/food/snacks/applepie                        = TRADER_THIS_TYPE)