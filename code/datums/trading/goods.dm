/datum/trader/ship/toyshop
	name = "Toy Shop Employee"
	name_language = TRADER_DEFAULT_NAME
	origin = "Toy Shop"
	trade_flags = TRADER_GOODS|TRADER_MONEY|TRADER_WANTED_ONLY
	possible_origins = list("Toys R Ours", "LEGS GO", "Kay-Cee Toys", "Build-a-Cat", "Magic Box", "The Positronic's Dungeon and Baseball Card Shop")
	speech = list(TRADER_HAIL_GENERIC    = "Uhh... hello? Welcome to ORIGIN, I hope you have a, uhh.... good shopping trip.",
				TRADER_HAIL_DENY         = "Nah, you're not allowed here. At all",

				TRADER_TRADE_COMPLETE       = "Thanks for shopping... here... at ORIGIN.",
				TRADER_NO_BLACKLISTED      = "Uuuhhh.... no.",
				TRADER_FOUND_UNWANTED = "Nah! That's not what I'm looking for. Something rarer.",
				TRADER_NOT_ENOUGH   = "Just 'cause they're made of cardboard doesn't mean they don't cost money...",
				TRADER_HOW_MUCH          = "Uhh... I'm thinking like... VALUE. Right? Or something rare that complements my interest.",
				TRADER_WHAT_WANT         = "Ummmm..... I guess I want",

				TRADER_COMPLEMENT_FAILURE   = "Ha! Very funny! You should write your own television show.",
				TRADER_COMPLEMENT_SUCCESS = "Why yes, I do work out.",
				TRADER_INSULT_GOOD       = "Well, well, well. Guess we learned who was the troll here.",
				TRADER_INSULT_BAD        = "I've already written a nasty Spacebook post in my mind about you.",

				TRADER_BRIBE_FAILURE     = "Nah. I need to get moving as soon as uhh... possible.",
				TRADER_BRIBE_SUCCESS      = "You know what, I wasn't doing anything for TIME minutes anyways.",
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
								/obj/item/board                = TRADER_THIS_TYPE,
								/obj/item/storage/box/checkers = TRADER_ALL,
								/obj/item/deck                 = TRADER_SUBTYPES_ONLY,
								/obj/item/pack                 = TRADER_SUBTYPES_ONLY,
								/obj/item/dice                 = TRADER_ALL,
								/obj/item/dice/d20/cursed      = TRADER_BLACKLIST,
								/obj/item/gun/launcher/money   = TRADER_THIS_TYPE)

/datum/trader/ship/electronics
	name = "Electronic Shop Employee"
	name_language = TRADER_DEFAULT_NAME
	origin = "Electronic Shop"
	possible_origins = list("Best Sale", "Overstore", "Oldegg", "Circuit Citadel", "Silicon Village", "Positronic Solutions LLC", "Sunvolt Inc.")

	speech = list(TRADER_HAIL_GENERIC    = "Hello, sir! Welcome to ORIGIN, I hope you find what you are looking for.",
				TRADER_HAIL_DENY         = "Your call has been disconnected.",

				TRADER_TRADE_COMPLETE    = "Thank you for shopping at ORIGIN, would you like to get the extended warranty as well?",
				TRADER_NO_BLACKLISTED   = "Sir, this is a /electronics/ store.",
				TRADER_NO_GOODS    = "As much as I'd love to buy that from you, I can't.",
				TRADER_NOT_ENOUGH  = "Your offer isn't adequate, sir.",
				TRADER_HOW_MUCH          = "Your total comes out to VALUE CURRENCY.",

				TRADER_COMPLEMENT_FAILURE   = "Hahaha! Yeah... funny...",
				TRADER_COMPLEMENT_SUCCESS = "That's very nice of you!",
				TRADER_INSULT_GOOD       = "That was uncalled for, sir. Don't make me get my manager.",
				TRADER_INSULT_BAD        = "Sir, I am allowed to hang up the phone if you continue, sir.",

				TRADER_BRIBE_FAILURE     = "Sorry, sir, but I can't really do that.",
				TRADER_BRIBE_SUCCESS      = "Why not! Glad to be here for a few more minutes.",
				)

	possible_trading_items = list(/obj/item/stock_parts/computer/battery_module      = TRADER_SUBTYPES_ONLY,
								/obj/item/stock_parts/circuitboard                            = TRADER_SUBTYPES_ONLY,
								/obj/item/stock_parts/circuitboard/telecomms                  = TRADER_BLACKLIST,
								/obj/item/stock_parts/circuitboard/unary_atmos                = TRADER_BLACKLIST,
								/obj/item/stock_parts/circuitboard/arcade                     = TRADER_BLACKLIST,
								/obj/item/stock_parts/circuitboard/broken                     = TRADER_BLACKLIST,
								/obj/item/stack/cable_coil                               = TRADER_SUBTYPES_ONLY,
								/obj/item/stack/cable_coil/cyborg                        = TRADER_BLACKLIST,
								/obj/item/stack/cable_coil/random                        = TRADER_BLACKLIST,
								/obj/item/stack/cable_coil/cut                           = TRADER_BLACKLIST,
								/obj/item/airalarm_electronics                    = TRADER_THIS_TYPE,
								/obj/item/airlock_electronics                     = TRADER_ALL,
								/obj/item/cell/standard                           = TRADER_THIS_TYPE,
								/obj/item/cell/crap                               = TRADER_THIS_TYPE,
								/obj/item/cell/high                               = TRADER_THIS_TYPE,
								/obj/item/cell/super                              = TRADER_THIS_TYPE,
								/obj/item/cell/hyper                              = TRADER_THIS_TYPE,
								/obj/item/module                                  = TRADER_SUBTYPES_ONLY,
								/obj/item/tracker_electronics                     = TRADER_THIS_TYPE)


/* Clothing stores: each a different type. A hat/glove store, a shoe store, and a jumpsuit store. */

/datum/trader/ship/clothingshop
	name = "Clothing Store Employee"
	name_language = TRADER_DEFAULT_NAME
	origin = "Clothing Store"
	possible_origins = list("Space Eagle", "Banana Democracy", "Forever 22", "Textiles Factory Warehouse Outlet", "Blocks Brothers")
	speech = list(TRADER_HAIL_GENERIC    = "Hello, sir! Welcome to ORIGIN!",
				TRADER_HAIL_DENY         = "We do not trade with rude customers. Consider yourself blacklisted.",

				TRADER_TRADE_COMPLETE    = "Thank you for shopping at ORIGIN. Remember: We cannot accept returns without the original tags!",
				TRADER_NO_BLACKLISTED   = "Hm, how about no?",
				TRADER_NO_GOODS    = "We don't buy, sir. Only sell.",
				TRADER_NOT_ENOUGH  = "Sorry, ORIGIN policy to not accept trades below our marked prices.",
				TRADER_HOW_MUCH          = "Your total comes out to VALUE CURRENCY.",

				TRADER_COMPLEMENT_FAILURE   = "Excuse me?",
				TRADER_COMPLEMENT_SUCCESS = "Aw, you're so nice!",
				TRADER_INSULT_GOOD       = "Sir.",
				TRADER_INSULT_BAD        = "Wow. I don't have to take this.",

				TRADER_BRIBE_FAILURE     = "ORIGIN policy clearly states we cannot stay for more than the designated time.",
				TRADER_BRIBE_SUCCESS      = "Hm.... sure! We'll have a few minutes of 'engine troubles'.",
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


/datum/trader/ship/clothingshop/New()
	..()
	speech[TRADER_HAIL_START + SPECIES_VOX] = "Well hello, sir! I don't believe we have any clothes that fit you... but you can still look!"

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
								/obj/item/clothing/accessory/storage/holster      = TRADER_BLACKLIST_ALL,
								/obj/item/clothing/accessory/medal        = TRADER_BLACKLIST_ALL,
								/obj/item/clothing/accessory/storage      = TRADER_BLACKLIST_ALL,
								/obj/item/clothing/gloves                 = TRADER_SUBTYPES_ONLY,
								/obj/item/clothing/gloves/lightrig        = TRADER_BLACKLIST_ALL,
								/obj/item/clothing/gloves/rig             = TRADER_BLACKLIST_ALL,
								/obj/item/clothing/gloves/thick/swat            = TRADER_BLACKLIST,
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
								/obj/item/clothing/head/warden            = TRADER_BLACKLIST,
								/obj/item/clothing/head/welding           = TRADER_BLACKLIST)



/*
Sells devices, odds and ends, and medical stuff
*/
/datum/trader/devices
	name = "Drugstore Employee"
	name_language = TRADER_DEFAULT_NAME
	origin = "Drugstore"
	possible_origins = list("Buy 'n Save", "Drug Carnival", "C&B", "Fentles", "Dr. Goods", "Beevees", "McGillicuddy's")
	possible_trading_items = list(/obj/item/device/flashlight              = TRADER_ALL,
								/obj/item/device/kit/paint                 = TRADER_SUBTYPES_ONLY,
								/obj/item/aicard                    = TRADER_THIS_TYPE,
								/obj/item/device/binoculars                = TRADER_THIS_TYPE,
								/obj/item/device/cable_painter             = TRADER_THIS_TYPE,
								/obj/item/device/flash                     = TRADER_THIS_TYPE,
								/obj/item/device/paint_sprayer             = TRADER_THIS_TYPE,
								/obj/item/device/multitool                 = TRADER_THIS_TYPE,
								/obj/item/device/lightreplacer             = TRADER_THIS_TYPE,
								/obj/item/device/megaphone                 = TRADER_THIS_TYPE,
								/obj/item/device/paicard                   = TRADER_THIS_TYPE,
								/obj/item/device/scanner/health            = TRADER_THIS_TYPE,
								/obj/item/device/scanner/gas                  = TRADER_ALL,
								/obj/item/device/scanner/spectrometer         = TRADER_ALL,
								/obj/item/device/scanner/reagent           = TRADER_ALL,
								/obj/item/device/scanner/xenobio             = TRADER_THIS_TYPE,
								/obj/item/device/suit_cooling_unit         = TRADER_THIS_TYPE,
								/obj/item/device/t_scanner                 = TRADER_THIS_TYPE,
								/obj/item/device/taperecorder              = TRADER_THIS_TYPE,
								/obj/item/device/batterer                  = TRADER_THIS_TYPE,
								/obj/item/device/synthesized_instrument/violin                    = TRADER_THIS_TYPE,
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
								/obj/item/pinpointer/radio            = TRADER_THIS_TYPE,
								/obj/item/stack/medical/advanced           = TRADER_BLACKLIST)
	speech = list(TRADER_HAIL_GENERIC    = "Hello, hello! Bits and bobs and everything in between, I hope you find what you're looking for!",
				TRADER_HAIL_DENY         = "Oh no. I don't want to deal with YOU.",

				TRADER_TRADE_COMPLETE    = "Thank you! Now remember, there isn't any return policy here, so be careful with that!",
				TRADER_NO_BLACKLISTED   = "Hm. Well that would be illegal, so no.",
				TRADER_NO_GOODS    = "I'm sorry, I only sell goods.",
				TRADER_NOT_ENOUGH  = "Gotta pay more than that to get that!",
				TRADER_HOW_MUCH          = "Well... I bought it for a lot, but I'll give it to you for VALUE.",

				TRADER_COMPLEMENT_FAILURE   = "Uh... did you say something?",
				TRADER_COMPLEMENT_SUCCESS = "Mhm! I can agree to that!",
				TRADER_INSULT_GOOD       = "Wow, where was that coming from?",
				TRADER_INSULT_BAD        = "Don't make me blacklist your connection.",

				TRADER_BRIBE_FAILURE     = "Well, as much as I'd love to say 'yes', you realize I operate on a station, correct?",
				)


/datum/trader/devices/New()
	..()
	speech[TRADER_HAIL_START + "silicon"] = "Ah! Hello, robot. We only sell things that, ah.... people can hold in their hands, unfortunately. You are still allowed to buy, though!"

/datum/trader/ship/robots
	name = "Robot Seller"
	name_language = TRADER_DEFAULT_NAME
	origin = "Robot Store"
	possible_origins = list("AI for the Straight Guy", "Mechanical Buddies", "Bot Chop Shop", "Omni Consumer Projects")
	possible_trading_items = list(
								/obj/item/device/bot_kit                          = TRADER_THIS_TYPE,
								/obj/item/device/paicard                          = TRADER_THIS_TYPE,
								/obj/item/aicard                           = TRADER_THIS_TYPE,
								/mob/living/bot                                   = TRADER_SUBTYPES_ONLY)
	speech = list(TRADER_HAIL_GENERIC = "Welcome to ORIGIN! Let me walk you through our fine robotic selection!",
				TRADER_HAIL_DENY      = "ORIGIN no longer wants to speak to you.",

				TRADER_TRADE_COMPLETE = "I hope you enjoy your new robot!",
				TRADER_NO_BLACKLISTED= "I work with robots, sir. Not that.",
				TRADER_NO_GOODS = "You gotta buy the robots, sir. I don't do trades.",
				TRADER_NOT_ENOUGH = "You're coming up short on cash.",
				TRADER_HOW_MUCH       = "My fine selection of robots will cost you VALUE!",

				TRADER_COMPLEMENT_FAILURE= "Well, I almost believed that.",
				TRADER_COMPLEMENT_SUCCESS= "Thank you! My craftsmanship is my life.",
				TRADER_INSULT_GOOD    = "Uncalled for.... uncalled for.",
				TRADER_INSULT_BAD     = "I've programmed AI better at insulting than you!",

				TRADER_BRIBE_FAILURE  = "I've got too many customers waiting in other sectors, sorry.",
				TRADER_BRIBE_SUCCESS   = "Hm. Don't keep me waiting too long, though.",
				)

/datum/trader/ship/robots/New()
	..()
	speech[TRADER_HAIL_START + "silicon"] = "Welcome to ORIGIN! Let- oh, you're a synth! Well, your money is good anyway. Welcome, welcome!"

/datum/trader/xeno_shop
	name = "Xenolife Collector"
	origin = "CSV Not a Poacher"
	trade_flags = TRADER_GOODS|TRADER_MONEY|TRADER_WANTED_ONLY|TRADER_WANTED_ALL
	possible_origins = list("XenoHugs", "Xynergy Specimen Acquisition", "Skinner Catering Reseller", "NanoTrasen Companionship Division", "Lonely Pete's Exotic Companionship","Space Wei's Exotic Cuisine")
	speech = list(TRADER_HAIL_GENERIC    = "Welcome! We are always looking to acquire more exotic life forms.",
				TRADER_HAIL_DENY         = "We no longer wish to speak to you. Please contact our legal representative if you wish to rectify this.",

				TRADER_TRADE_COMPLETE    = "Remember to give them attention and food. They are living beings, and you should treat them like so.",
				TRADER_NO_BLACKLISTED   = "Legally I can't do that. Morally... well, I refuse to do that.",
				TRADER_FOUND_UNWANTED = "I only want animals. I don't need food or shiny things. I'm looking for specific ones, at that. Ones I already have the cage and food for.",
				TRADER_NOT_ENOUGH   = "I'd give you this for free, but I need the money to feed the specimens. So you must pay in full.",
				TRADER_HOW_MUCH          = "This is a good choice. I believe it will cost you VALUE CURRENCY.",
				TRADER_WHAT_WANT         = "I have the facilities, currently, to support",

				TRADER_COMPLEMENT_FAILURE   = "According to customs on 34 planets I traded with, this constitutes sexual harrasment.",
				TRADER_COMPLEMENT_SUCCESS = "Thank you. I needed that.",
				TRADER_INSULT_GOOD       = "No need to be upset, I believe we can do business.",
				TRADER_INSULT_BAD        = "I have traded dogs with more bark than that.",
				)

	possible_wanted_items = list(/mob/living/simple_animal/tindalos    = TRADER_THIS_TYPE,
								/mob/living/simple_animal/passive/tomato      = TRADER_THIS_TYPE,
								/mob/living/simple_animal/yithian     = TRADER_THIS_TYPE,
								/mob/living/simple_animal/hostile/retaliate/beast/diyaab = TRADER_THIS_TYPE,
								/mob/living/simple_animal/hostile/retaliate/beast/shantak= TRADER_THIS_TYPE,
								/mob/living/simple_animal/hostile/retaliate/beast/samak= TRADER_THIS_TYPE,
								/mob/living/simple_animal/hostile/carp = TRADER_THIS_TYPE)

	possible_trading_items = list(/mob/living/simple_animal/hostile/carp= TRADER_THIS_TYPE,
								/obj/item/device/dociler              = TRADER_THIS_TYPE,
								/obj/item/beartrap			  = TRADER_THIS_TYPE,
								/obj/item/device/scanner/xenobio = TRADER_THIS_TYPE)

/datum/trader/medical
	name = "Medical Supplier"
	origin = "Infirmary of CSV Iniquity"
	trade_flags = TRADER_GOODS|TRADER_MONEY|TRADER_WANTED_ONLY
	want_multiplier = 1.2
	margin = 2
	possible_origins = list("Dr.Krieger's Practice", "Legit Medical Supplies (No Refund)", "Mom's & Pop's Addictive Opoids", "Legitimate Pharmaceutical Firm", "Designer Drugs by Lil Xanny")
	speech = list(TRADER_HAIL_GENERIC    = "Huh? How'd you get this number?! Oh well, if you wanna talk biz, I'm listening.",
				TRADER_HAIL_DENY         = "This is an automated message. Feel free to fuck the right off after the buzzer. *buzz*",

				TRADER_TRADE_COMPLETE    = "Good to have business with ya. Remember, no refunds.",
				TRADER_NO_BLACKLISTED   = "Whoa whoa, I don't want this shit, put it away.",
				TRADER_FOUND_UNWANTED = "What the hell do you expect me to do with this junk?",
				TRADER_NOT_ENOUGH   = "Sorry, pal, full payment upfront, I don't write the rules. Well, I do, but that's beside the point.",
				TRADER_HOW_MUCH          = "Hmm, this is one damn fine item, but I'll part with it for VALUE CURRENCY.",
				TRADER_WHAT_WANT         = "I could always use some fucking",

				TRADER_COMPLEMENT_FAILURE   = "Haha, how nice of you. Why don't you go fall in an elevator shaft.",
				TRADER_COMPLEMENT_SUCCESS = "Damn right I'm awesome, tell me more.",
				TRADER_INSULT_GOOD       = "Damn, pal, no need to get snippy.",
				TRADER_INSULT_BAD        = "*muffled laughter* Sorry, was that you trying to talk shit? Adorable.",
				)

	possible_wanted_items = list(/obj/item/reagent_containers/food/drinks/bottle = TRADER_THIS_TYPE,
								/obj/item/organ/internal/liver = TRADER_THIS_TYPE,
								/obj/item/organ/internal/kidneys = TRADER_THIS_TYPE,
								/obj/item/organ/internal/lungs = TRADER_THIS_TYPE,
								/obj/item/organ/internal/heart = TRADER_THIS_TYPE,
								/obj/item/storage/fancy/cigarettes = TRADER_ALL
								)

	possible_trading_items = list(/obj/item/storage/pill_bottle = TRADER_SUBTYPES_ONLY,
								  /obj/item/storage/firstaid/fire  = TRADER_THIS_TYPE,
								  /obj/item/storage/firstaid/toxin  = TRADER_THIS_TYPE,
								  /obj/item/storage/firstaid/adv  = TRADER_THIS_TYPE,
								  /obj/item/storage/box/bloodpacks  = TRADER_THIS_TYPE,
								  /obj/item/reagent_containers/ivbag  = TRADER_SUBTYPES_ONLY,
								  /obj/item/retractor = TRADER_THIS_TYPE,
								  /obj/item/hemostat = TRADER_THIS_TYPE,
								  /obj/item/cautery = TRADER_THIS_TYPE,
								  /obj/item/surgicaldrill = TRADER_THIS_TYPE,
								  /obj/item/scalpel = TRADER_THIS_TYPE,
								  /obj/item/scalpel/manager = TRADER_THIS_TYPE,
								  /obj/item/circular_saw = TRADER_THIS_TYPE,
								  /obj/item/bonegel = TRADER_THIS_TYPE,
								  /obj/item/bonesetter = TRADER_THIS_TYPE,
								  /obj/item/reagent_containers/glass/bottle/inaprovaline = TRADER_THIS_TYPE,
								  /obj/item/reagent_containers/glass/bottle/stoxin = TRADER_THIS_TYPE,
								  /obj/item/reagent_containers/glass/bottle/antitoxin = TRADER_THIS_TYPE,
								  /obj/item/reagent_containers/glass/bottle/inaprovaline = TRADER_THIS_TYPE,
								  /obj/item/bodybag/cryobag = TRADER_THIS_TYPE,
								  /obj/item/reagent_containers/chem_disp_cartridge/small/dexalin = TRADER_THIS_TYPE,
								  /obj/item/sign/medipolma = TRADER_THIS_TYPE
								)

/datum/trader/mining
	name = "Rock'n'Drill Mining Inc"
	origin = "Automated Smelter AH-532"
	trade_flags = TRADER_GOODS|TRADER_MONEY|TRADER_WANTED_ONLY|TRADER_WANTED_ALL
	want_multiplier = 1.5
	margin = 2
	possible_origins = list("Automated Smelter AH-532", "CMV Locust", "The Galactic Foundry Company", "Crucible LLC")
	speech = list(TRADER_HAIL_GENERIC    = "Welcome to R'n'D Mining. Please place your order.",
				TRADER_HAIL_DENY         = "There is no response on the line.",

				TRADER_TRADE_COMPLETE    = "Transaction complete. Please use our services again",
				TRADER_NO_BLACKLISTED   = "Whoa whoa, I don't want this shit, put it away.",
				TRADER_FOUND_UNWANTED = "Sorry, we are currently not looking to purchase these items.",
				TRADER_NOT_ENOUGH   = "Sorry, this is an insufficient sum for this purchase.",
				TRADER_HOW_MUCH          = "For ONE entry of ITEM the price would be VALUE CURRENCY.",
				TRADER_WHAT_WANT         = "We are currently looking to procure",

				TRADER_COMPLEMENT_FAILURE   = "I am afraid this is beyond my competency.",
				TRADER_COMPLEMENT_SUCCESS = "Thank you.",
				TRADER_INSULT_GOOD       = "Alright, we will reconsider the terms.",
				TRADER_INSULT_BAD        = "This is not acceptable, please cease.",
				)

	possible_wanted_items = list(/obj/item/ore/ = TRADER_SUBTYPES_ONLY,
								/obj/item/disk/survey = TRADER_THIS_TYPE,
								/obj/item/ore/slag = TRADER_BLACKLIST)

	possible_trading_items = list(/obj/machinery/mining/drill = TRADER_THIS_TYPE,
								  /obj/machinery/mining/brace = TRADER_THIS_TYPE,
								  /obj/machinery/floodlight = TRADER_THIS_TYPE,
								  /obj/machinery/floodlight = TRADER_THIS_TYPE,
								  /obj/item/storage/box/greenglowsticks = TRADER_THIS_TYPE,
								  /obj/item/clothing/suit/space/void/engineering/salvage/prepared  = TRADER_THIS_TYPE,
								  /obj/item/stack/material/uranium/ten = TRADER_THIS_TYPE,
								  /obj/item/stack/material/plasteel/fifty = TRADER_THIS_TYPE,
								  /obj/item/stack/material/steel/fifty = TRADER_THIS_TYPE
								)
