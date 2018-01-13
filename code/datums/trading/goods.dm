/datum/trader/ship/toyshop
	name = "Toy Shop Employee"
	name_language = TRADER_DEFAULT_NAME
	origin = "Toy Shop"
	trade_flags = TRADER_GOODS|TRADER_MONEY|TRADER_WANTED_ONLY
	possible_origins = list("Toys R Ours", "LEGS GO", "Kay-Cee Toys", "Build-a-Cat", "Magic Box", "The Positronic's Dungeon and Baseball Card Shop")
	speech = list("hail_generic"    = "Uhh... hello? Welcome to ORIGIN, I hope you have a, uhh.... good shopping trip.",
				"hail_deny"         = "Nah, you're not allowed here. At all",

				"trade_complete"       = "Thanks for shopping... here... at ORIGIN.",
				"trade_blacklist"      = "Uuuhhh.... no.",
				"trade_found_unwanted" = "Nah! That's not what I'm looking for. Something rarer.",
				"trade_not_enough"   = "Just 'cause they're made of cardboard doesn't mean they don't cost money...",
				"how_much"          = "Uhh... I'm thinking like... VALUE. Right? Or something rare that complements my interest.",
				"what_want"         = "Ummmm..... I guess I want",

				"compliment_deny"   = "Ha! Very funny! You should write your own television show.",
				"compliment_accept" = "Why yes, I do work out.",
				"insult_good"       = "Well, well, well. Guess we learned who was the troll here.",
				"insult_bad"        = "I've already written a nasty Spacebook post in my mind about you.",

				"bribe_refusal"     = "Nah. I need to get moving as soon as uhh... possible.",
				"bribe_accept"      = "You know what, I wasn't doing anything for TIME minutes anyways.",
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
	possible_origins = list("Best Sale", "Overstore", "Oldegg", "Circuit Citadel", "Silicon Village", "Positronic Solutions LLC", "Sunvolt Inc.")

	speech = list("hail_generic"    = "Hello, sir! Welcome to ORIGIN, I hope you find what you are looking for.",
				"hail_deny"         = "Your call has been disconnected.",

				"trade_complete"    = "Thank you for shopping at ORIGIN, would you like to get the extended warranty as well?",
				"trade_blacklist"   = "Sir, this is a /electronics/ store.",
				"trade_no_goods"    = "As much as I'd love to buy that from you, I'm can't.",
				"trade_not_enough"  = "Your offer isn't adequate, sir.",
				"how_much"          = "Your total comes out to VALUE thalers.",

				"compliment_deny"   = "Hahaha! Yeah... funny...",
				"compliment_accept" = "That's very nice of you!",
				"insult_good"       = "That was uncalled for, sir. Don't make me get my manager.",
				"insult_bad"        = "Sir, I am allowed to hang up the phone if you continue, sir.",

				"bribe_refusal"     = "Sorry, sir, but I can't really do that.",
				"bribe_accept"      = "Why not! Glad to be here for a few more minutes.",
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
	speech = list("hail_generic"    = "Hello, sir! Welcome to ORIGIN!",
				"hail_Vox"          = "Well hello, sir! I don't believe we have any clothes that fit you... but you can still look!",
				"hail_deny"         = "We do not trade with rude customers. Consider yourself blacklisted.",

				"trade_complete"    = "Thank you for shopping at ORIGIN. Remember: We cannot accept returns without the original tags!",
				"trade_blacklist"   = "Hm, how about no?",
				"trade_no_goods"    = "We don't buy, sir. Only sell.",
				"trade_not_enough"  = "Sorry, ORIGIN policy to not accept trades below our marked prices.",
				"how_much"          = "Your total comes out to VALUE thalers.",

				"compliment_deny"   = "Excuse me?",
				"compliment_accept" = "Aw, you're so nice!",
				"insult_good"       = "Sir.",
				"insult_bad"        = "Wow. I don't have to take this.",

				"bribe_refusal"     = "ORIGIN policy clearly states we cannot stay for more than the designated time.",
				"bribe_accept"      = "Hm.... sure! We'll have a few minutes of 'engine troubles'.",
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
	possible_origins = list("Buy 'n Save", "Drug Carnival", "C&B", "Fentles", "Dr. Goods", "Beevees", "McGillicuddy's")
	possible_trading_items = list(/obj/item/device/flashlight              = TRADER_ALL,
								/obj/item/device/kit/paint                 = TRADER_SUBTYPES_ONLY,
								/obj/item/weapon/aicard                    = TRADER_THIS_TYPE,
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
	speech = list("hail_generic"    = "Hello, hello! Bits and bobs and everything in between, I hope you find what you're looking for!",
				"hail_silicon"      = "Ah! Hello, robot. We only sell things that, ah.... people can hold in their hands, unfortunately. You are still allowed to buy, though!",
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

				"bribe_refusal"     = "Well, as much as I'd love to say 'yes', you realize I operate on a station, correct?",
				)

/datum/trader/ship/robots
	name = "Robot Seller"
	name_language = TRADER_DEFAULT_NAME
	origin = "Robot Store"
	possible_origins = list("AI for the Straight Guy", "Mechanical Buddies", "Bot Chop Shop", "Omni Consumer Projects")
	possible_trading_items = list(/obj/item/weapon/secbot_assembly/ed209_assembly = TRADER_THIS_TYPE,
								/obj/item/weapon/toolbox_tiles                    = TRADER_THIS_TYPE,
								/obj/item/weapon/toolbox_tiles_sensor             = TRADER_THIS_TYPE,
								/obj/item/weapon/secbot_assembly                  = TRADER_ALL,
								/obj/item/weapon/farmbot_arm_assembly             = TRADER_THIS_TYPE,
								/obj/item/weapon/firstaid_arm_assembly            = TRADER_THIS_TYPE,
								/obj/item/weapon/bucket_sensor                    = TRADER_THIS_TYPE,
								/obj/item/device/bot_kit                          = TRADER_THIS_TYPE,
								/obj/item/device/paicard                          = TRADER_THIS_TYPE,
								/obj/item/weapon/aicard                           = TRADER_THIS_TYPE,
								/mob/living/bot                                   = TRADER_SUBTYPES_ONLY)
	speech = list("hail_generic" = "Welcome to ORIGIN! Let me walk you through our fine robotic selection!",
				"hail_silicon"   = "Welcome to ORIGIN! Let- oh, you're a synth! Well, your money is good anyway. Welcome, welcome!",
				"hail_deny"      = "ORIGIN no longer wants to speak to you.",

				"trade_complete" = "I hope you enjoy your new robot!",
				"trade_blacklist"= "I work with robots, sir. Not that.",
				"trade_no_goods" = "You gotta buy the robots, sir. I don't do trades.",
				"trade_not_enough" = "You're coming up short on cash.",
				"how_much"       = "My fine selection of robots will cost you VALUE!",

				"compliment_deny"= "Well, I almost believed that.",
				"compliment_accept"= "Thank you! My craftsmanship is my life.",
				"insult_good"    = "Uncalled for.... uncalled for.",
				"insult_bad"     = "I've programmed AI better at insulting than you!",

				"bribe_refusal"  = "I've got too many customers waiting in other sectors, sorry.",
				"bribe_accept"   = "Hm. Don't keep me waiting too long, though.",
				)

/datum/trader/xeno_shop
	name = "Xenolife Collector"
	origin = "CSV Not a Poacher"
	trade_flags = TRADER_GOODS|TRADER_MONEY|TRADER_WANTED_ONLY|TRADER_WANTED_ALL
	possible_origins = list("XenoHugs","NT Specimen Acquisition","Lonely Pete's Exotic Companionship","Space Wei's Exotic Cuisine")
	speech = list("hail_generic"    = "Welcome! We are always looking to acquire more exotic life forms.",
				"hail_deny"         = "We no longer wish to speak to you. Please contact our legal representative if you wish to rectify this.",

				"trade_complete"    = "Remember to give them attention and food. They are living beings, and you should treat them like so.",
				"trade_blacklist"   = "Legally I can't do that. Morally... well, I refuse to do that.",
				"trade_found_unwanted" = "I only want animals. I don't need food or shiny things. I'm looking for specific ones, at that. Ones I already have the cage and food for.",
				"trade_not_enough"   = "I'd give you this for free, but I need the money to feed the specimens. So you must pay in full.",
				"how_much"          = "This is a good choice. I believe it will cost you VALUE thalers.",
				"what_want"         = "I have the facilities, currently, to support",

				"compliment_deny"   = "According to customs on 34 planets I traded with, this constitutes sexual harrasment.",
				"compliment_accept" = "Thank you. I needed that.",
				"insult_good"       = "No need to be upset, I believe we can do business.",
				"insult_bad"        = "I have traded dogs with more bark than that.",
				)

	possible_wanted_items = list(/mob/living/simple_animal/tindalos    = TRADER_THIS_TYPE,
								/mob/living/simple_animal/tomato      = TRADER_THIS_TYPE,
								/mob/living/simple_animal/yithian     = TRADER_THIS_TYPE,
								/mob/living/simple_animal/hostile/retaliate/beast/diyaab = TRADER_THIS_TYPE,
								/mob/living/simple_animal/hostile/retaliate/beast/shantak= TRADER_THIS_TYPE,
								/mob/living/simple_animal/hostile/retaliate/beast/samak= TRADER_THIS_TYPE,
								/mob/living/simple_animal/hostile/carp = TRADER_THIS_TYPE)

	possible_trading_items = list(/mob/living/simple_animal/hostile/carp= TRADER_THIS_TYPE,
								/obj/item/device/dociler              = TRADER_THIS_TYPE,
								/obj/item/weapon/beartrap			  = TRADER_THIS_TYPE,
								/obj/item/device/slime_scanner = TRADER_THIS_TYPE)

/datum/trader/medical
	name = "Medical Supplier"
	origin = "Infirmary of CSV Iniquity"
	trade_flags = TRADER_GOODS|TRADER_MONEY|TRADER_WANTED_ONLY
	want_multiplier = 1.2
	margin = 2
	possible_origins = list("Dr.Krieger's Practice", "Legit Medical Supplies (No Refund)", "Mom's & Pop's Addictive Opoids", "Legitimate Pharmaceutical Firm", "Designer Drugs by Lil Xanny")
	speech = list("hail_generic"    = "Huh? How'd you get this number?! Oh well, if you wanna talk biz, I'm listening.",
				"hail_deny"         = "This is an automated message. Feel free to fuck the right off after the buzzer. *buzz*",

				"trade_complete"    = "Good to have business with ya. Remember, no refunds.",
				"trade_blacklist"   = "Whoa whoa, I don't want this shit, put it away.",
				"trade_found_unwanted" = "What the hell do you expect me to do with this junk?",
				"trade_not_enough"   = "Sorry, pal, full payment upfront, I don't write the rules. Well, I do, but that's beside the point.",
				"how_much"          = "Hmm, this is one damn fine item, but I'll part with it for VALUE thalers.",
				"what_want"         = "I could always use some fucking",

				"compliment_deny"   = "Haha, how nice of you. Why don't you go fall in an elevator shaft.",
				"compliment_accept" = "Damn right I'm awesome, tell me more.",
				"insult_good"       = "Damn, pal, no need to get snippy.",
				"insult_bad"        = "*muffled laughter* Sorry, was that you trying to talk shit? Adorable.",
				)

	possible_wanted_items = list(/obj/item/weapon/reagent_containers/food/drinks/bottle = TRADER_THIS_TYPE,
								/obj/item/organ/internal/liver = TRADER_THIS_TYPE,
								/obj/item/organ/internal/kidneys = TRADER_THIS_TYPE,
								/obj/item/organ/internal/lungs = TRADER_THIS_TYPE,
								/obj/item/organ/internal/heart = TRADER_THIS_TYPE,
								/obj/item/weapon/storage/fancy/cigarettes = TRADER_ALL
								)

	possible_trading_items = list(/obj/item/weapon/storage/pill_bottle = TRADER_SUBTYPES_ONLY,
								  /obj/item/weapon/storage/firstaid/fire  = TRADER_THIS_TYPE,
								  /obj/item/weapon/storage/firstaid/toxin  = TRADER_THIS_TYPE,
								  /obj/item/weapon/storage/firstaid/adv  = TRADER_THIS_TYPE,
								  /obj/item/weapon/storage/box/bloodpacks  = TRADER_THIS_TYPE,
								  /obj/item/weapon/reagent_containers/blood  = TRADER_SUBTYPES_ONLY,
								  /obj/item/weapon/retractor = TRADER_THIS_TYPE,
								  /obj/item/weapon/hemostat = TRADER_THIS_TYPE,
								  /obj/item/weapon/cautery = TRADER_THIS_TYPE,
								  /obj/item/weapon/surgicaldrill = TRADER_THIS_TYPE,
								  /obj/item/weapon/scalpel = TRADER_THIS_TYPE,
								  /obj/item/weapon/scalpel/manager = TRADER_THIS_TYPE,
								  /obj/item/weapon/circular_saw = TRADER_THIS_TYPE,
								  /obj/item/weapon/bonegel = TRADER_THIS_TYPE,
								  /obj/item/weapon/bonesetter = TRADER_THIS_TYPE,
								  /obj/item/weapon/reagent_containers/glass/bottle/inaprovaline = TRADER_THIS_TYPE,
								  /obj/item/weapon/reagent_containers/glass/bottle/stoxin = TRADER_THIS_TYPE,
								  /obj/item/weapon/reagent_containers/glass/bottle/antitoxin = TRADER_THIS_TYPE,
								  /obj/item/weapon/reagent_containers/glass/bottle/inaprovaline = TRADER_THIS_TYPE,
								  /obj/item/bodybag/cryobag = TRADER_THIS_TYPE,
								  /obj/item/weapon/reagent_containers/chem_disp_cartridge/dexalin/small = TRADER_THIS_TYPE,
								  /obj/item/sign/medipolma = TRADER_THIS_TYPE
								)

/datum/trader/mining
	name = "Rock'n'Drill Mining Inc"
	origin = "Automated Smelter AH-532"
	trade_flags = TRADER_GOODS|TRADER_MONEY|TRADER_WANTED_ONLY|TRADER_WANTED_ALL
	want_multiplier = 1.5
	margin = 2
	possible_origins = list("Automated Smelter AH-532", "CMV Locust", "The Galactic Foundry Company", "Crucible LLC")
	speech = list("hail_generic"    = "Welcome to R'n'D Mining. Please place your order.",
				"hail_deny"         = "There is no response on the line.",

				"trade_complete"    = "Transaction complete. Please use our services again",
				"trade_blacklist"   = "Whoa whoa, I don't want this shit, put it away.",
				"trade_found_unwanted" = "Sorry, we are currently not looking to purchase these items.",
				"trade_not_enough"   = "Sorry, this is an insufficient sum for this purchase.",
				"how_much"          = "For ONE entry of ITEM the price would be VALUE thalers.",
				"what_want"         = "We are currently looking to procure",

				"compliment_deny"   = "I am afraid this is beyond my competency.",
				"compliment_accept" = "Thank you.",
				"insult_good"       = "Alright, we will reconsider the terms.",
				"insult_bad"        = "This is not acceptable, please cease.",
				)

	possible_wanted_items = list(/obj/item/weapon/ore/ = TRADER_SUBTYPES_ONLY,
								/obj/item/weapon/disk/survey = TRADER_THIS_TYPE,
								/obj/item/weapon/ore/slag = TRADER_BLACKLIST)

	possible_trading_items = list(/obj/machinery/mining/drill = TRADER_THIS_TYPE,
								  /obj/machinery/mining/brace = TRADER_THIS_TYPE,
								  /obj/machinery/floodlight = TRADER_THIS_TYPE,
								  /obj/machinery/floodlight = TRADER_THIS_TYPE,
								  /obj/item/weapon/storage/box/greenglowsticks = TRADER_THIS_TYPE,
								  /obj/item/clothing/suit/space/void/engineering/salvage/prepared  = TRADER_THIS_TYPE,
								  /obj/item/stack/material/uranium/ten = TRADER_THIS_TYPE,
								  /obj/item/stack/material/plasteel/fifty = TRADER_THIS_TYPE,
								  /obj/item/stack/material/steel/fifty = TRADER_THIS_TYPE
								)