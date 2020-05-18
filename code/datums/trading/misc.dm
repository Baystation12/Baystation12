/datum/trader/ship/pet_shop
	name = "Pet Shop Owner"
	name_language = LANGUAGE_SKRELLIAN
	origin = "Pet Shop"
	trade_flags = TRADER_GOODS|TRADER_MONEY|TRADER_WANTED_ONLY
	possible_origins = list("Paws-Out", "Pets-R-Smart", "Tentacle Companions", "Xeno-Pets and Assorted Goods", "Barks and Drools")
	speech = list("hail_generic"    = "Welcome to my xeno-pet shop! Here you will find many wonderful companions. Some a bit more... aggressive than others. But companions none the less. I also buy pets, or trade them.",
				"hail_Skrell"       = "Ah! A fellow Skrell. How wonderful, I may have a few pets imported from back home. Take a look.",
				"hail_deny"         = "I no longer wish to speak to you.",

				"trade_complete"    = "Remember to give them attention and food. They are living beings, and you should treat them like so.",
				"trade_blacklist"   = "Legally I can' do that. Morally, I refuse to do that.",
				"trade_found_unwanted" = "I only want animals. I don't need food or shiny things. I'm looking for specific ones at that. Ones I already have the cage and food for.",
				"trade_not_enough"   = "I'd give you the animal for free, but I need the money to feed the others. So you must pay in full.",
				"how_much"          = "This is a fine specimen. I believe it will cost you VALUE CURRENCY.",
				"what_want"         = "I have the facilities, currently, to support",

				"compliment_deny"   = "That was almost charming.",
				"compliment_accept" = "Thank you. I needed that.",
				"insult_good"       = "I ask you to stop. We can be peaceful. I know we can.",
				"insult_bad"        = "My interactions with you are becoming less than fruitful.",

				"bribe_refusal"     = "I'm not going to do that. I have places to be.",
				"bribe_accept"      = "Hm. It'll be good for the animals, so sure.",
				)

	possible_wanted_items = list(/mob/living/simple_animal/corgi      = TRADER_THIS_TYPE,
								/mob/living/simple_animal/cat         = TRADER_THIS_TYPE,
								/mob/living/simple_animal/crab        = TRADER_THIS_TYPE,
								/mob/living/simple_animal/lizard      = TRADER_THIS_TYPE,
								/mob/living/simple_animal/mouse       = TRADER_THIS_TYPE,
								/mob/living/simple_animal/mushroom    = TRADER_THIS_TYPE,
								/mob/living/simple_animal/tindalos    = TRADER_THIS_TYPE,
								/mob/living/simple_animal/tomato      = TRADER_THIS_TYPE,
								/mob/living/simple_animal/cow         = TRADER_THIS_TYPE,
								/mob/living/simple_animal/chick       = TRADER_THIS_TYPE,
								/mob/living/simple_animal/chicken     = TRADER_THIS_TYPE,
								/mob/living/simple_animal/yithian     = TRADER_THIS_TYPE,
								/mob/living/simple_animal/hostile/retaliate/beast/diyaab = TRADER_THIS_TYPE,
								/mob/living/simple_animal/hostile/bear= TRADER_THIS_TYPE,
								/mob/living/simple_animal/hostile/retaliate/beast/shantak= TRADER_THIS_TYPE,
								/mob/living/simple_animal/hostile/retaliate/parrot      = TRADER_THIS_TYPE,
								/mob/living/simple_animal/hostile/retaliate/beast/samak= TRADER_THIS_TYPE,
								/mob/living/simple_animal/hostile/retaliate/goat = TRADER_THIS_TYPE,
								/mob/living/simple_animal/hostile/carp = TRADER_THIS_TYPE)

	possible_trading_items = list(/mob/living/simple_animal/corgi     = TRADER_THIS_TYPE,
								/mob/living/simple_animal/cat         = TRADER_THIS_TYPE,
								/mob/living/simple_animal/crab        = TRADER_THIS_TYPE,
								/mob/living/simple_animal/lizard      = TRADER_THIS_TYPE,
								/mob/living/simple_animal/mouse       = TRADER_THIS_TYPE,
								/mob/living/simple_animal/mushroom    = TRADER_THIS_TYPE,
								/mob/living/simple_animal/tindalos    = TRADER_THIS_TYPE,
								/mob/living/simple_animal/tomato      = TRADER_THIS_TYPE,
								/mob/living/simple_animal/cow         = TRADER_THIS_TYPE,
								/mob/living/simple_animal/chick       = TRADER_THIS_TYPE,
								/mob/living/simple_animal/chicken     = TRADER_THIS_TYPE,
								/mob/living/simple_animal/yithian     = TRADER_THIS_TYPE,
								/mob/living/simple_animal/hostile/retaliate/beast/diyaab = TRADER_THIS_TYPE,
								/mob/living/simple_animal/hostile/bear= TRADER_THIS_TYPE,
								/mob/living/simple_animal/hostile/retaliate/beast/shantak= TRADER_THIS_TYPE,
								/mob/living/simple_animal/hostile/retaliate/parrot      = TRADER_THIS_TYPE,
								/mob/living/simple_animal/hostile/retaliate/beast/samak= TRADER_THIS_TYPE,
								/mob/living/simple_animal/hostile/retaliate/goat = TRADER_THIS_TYPE,
								/mob/living/simple_animal/hostile/carp= TRADER_THIS_TYPE,
								/obj/item/device/dociler              = TRADER_THIS_TYPE,
								/obj/structure/dogbed                 = TRADER_THIS_TYPE)

/datum/trader/ship/prank_shop
	name = "Prank Shop Owner"
	name_language = LANGUAGE_ROOTLOCAL
	origin = "Prank Shop"
	compliment_increase = 0
	insult_drop = 0
	possible_origins = list("Yacks and Yucks Shop", "The Shop From Which I Sell Humorous Items", "The Prank Gestalt", "The Clown's Armory", "Uncle Knuckle's Chuckle Bunker", "A Place from Which to do Humorous Business")
	speech = list("hail_generic" = "We welcome you to our shop of humorous items. We invite you to partake in the divine experience of being pranked, and pranking someone else.",
				"hail_Diona"     = "Welcome, other gestalt. We invite you to learn of our experiences, and teach us of your own.",
				"hail_deny"      = "We cannot do business with you. We are sorry.",

				"trade_complete" = "We thank you for purchasing something. We enjoyed the experience of you doing so and we hope to learn from it.",
				"trade_blacklist"= "We are not allowed to do such. We are sorry.",
				"trade_not_enough"="We have sufficiently experienced giving away goods for free. We wish to experience getting money in return.",
				"how_much"       = "We believe that is worth VALUE CURRENCY.",
				"what_want"      = "We wish only for the experiences you give us, in all else we want",

				"compliment_deny"= "You are attempting to compliment us.",
				"compliment_accept"="You are attempting to compliment us.",
				"insult_good"    = "You are attempting to insult us, correct?",
				"insult_bad"     = "We do not understand.",

				"bribe_refusal"  = "We are sorry, but we cannot accept.",
				"bribe_accept"   = "We are happy to say that we accept this bribe.",
				)
	possible_trading_items = list(/obj/item/clothing/mask/gas/clown_hat = TRADER_THIS_TYPE,
								/obj/item/clothing/mask/gas/mime        = TRADER_THIS_TYPE,
								/obj/item/clothing/shoes/clown_shoes    = TRADER_THIS_TYPE,
								/obj/item/clothing/under/rank/clown     = TRADER_THIS_TYPE,
								/obj/item/weapon/stamp/clown            = TRADER_THIS_TYPE,
								/obj/item/weapon/storage/backpack/clown = TRADER_THIS_TYPE,
								/obj/item/weapon/bananapeel             = TRADER_THIS_TYPE,
								/obj/item/weapon/gun/launcher/money     = TRADER_THIS_TYPE,
								/obj/item/weapon/reagent_containers/food/snacks/pie = TRADER_THIS_TYPE,
								/obj/item/weapon/bikehorn               = TRADER_THIS_TYPE,
								/obj/item/weapon/reagent_containers/spray/waterflower = TRADER_THIS_TYPE,
								/obj/item/weapon/gun/launcher/pneumatic/small = TRADER_THIS_TYPE,
								/obj/item/weapon/gun/projectile/revolver/capgun = TRADER_THIS_TYPE,
								/obj/item/clothing/mask/fakemoustache   = TRADER_THIS_TYPE,
								/obj/item/weapon/grenade/spawnergrenade/fake_carp = TRADER_THIS_TYPE)

/datum/trader/ship/replica_shop
	name = "Replica Store Owner"
	name_language = TRADER_DEFAULT_NAME
	origin = "Replica Store"
	possible_origins = list("Ye-Old Armory", "Knights and Knaves", "The Blacksmith", "Historical Human Apparel and Items", "The Pointy End", "Fight Knight's Knightly Nightly Knight Fights", "Elminster's Fine Steel", "The Arms of King Duordan", "Queen's Edict")
	speech = list("hail_generic" = "Greetings, traveler! You've the look of one with a keen hunger for human history. Come in, and learn! Mayhaps even... buy?",
				"hail_Unathi"    = "Ah, you've the look of a lizard who knows his way around martial combat. Come in! We can only hope our steel meets the formidable Moghedi standards.",
				"hail_deny"      = "I shan't palaver with a man who thumbs his nose at the annals of history. Goodbye.",

				"trade_complete" = "Thank you, mighty warrior. And remember - these may be replicas, but their edges are honed to razor sharpness!",
				"trade_blacklist"= "Nay, we accept only the CURRENCY_SINGULAR. Or sovereigns of the king's mint, of course.",
				"trade_not_enough"="Alas, traveler, my fine wares cost more than that.",
				"how_much"       = "For VALUE CURRENCY, I can part with this finest of goods.",
				"what_want"      = "I have ever longed for",

				"compliment_deny"= "Oh ho ho! Aren't you quite the jester.",
				"compliment_accept"="Why, thank you, traveler! Long have I slaved over the anvil to produce these goods.",
				"insult_good"    = "Hey, bro, I'm just tryin' to make a living here, okay? The Camelot schtick is part of my brand.",
				"insult_bad"     = "Man, fuck you, then.",

				"bribe_refusal"  = "Alas, traveler - I could stay all eve, but I've an Unathi client in waiting, and they are not known for patience.",
				"bribe_accept"   = "Mayhaps I could set a spell longer, and rest my weary feet.",
				)
	possible_trading_items = list(/obj/item/clothing/head/wizard/magus = TRADER_THIS_TYPE,
								/obj/item/weapon/shield/buckler        = TRADER_THIS_TYPE,
								/obj/item/clothing/head/redcoat        = TRADER_THIS_TYPE,
								/obj/item/clothing/head/powdered_wig   = TRADER_THIS_TYPE,
								/obj/item/clothing/head/hasturhood     = TRADER_THIS_TYPE,
								/obj/item/clothing/head/helmet/gladiator=TRADER_THIS_TYPE,
								/obj/item/clothing/head/plaguedoctorhat= TRADER_THIS_TYPE,
								/obj/item/clothing/glasses/monocle     = TRADER_THIS_TYPE,
								/obj/item/clothing/mask/smokable/pipe  = TRADER_THIS_TYPE,
								/obj/item/clothing/mask/gas/plaguedoctor=TRADER_THIS_TYPE,
								/obj/item/clothing/suit/hastur         = TRADER_THIS_TYPE,
								/obj/item/clothing/suit/imperium_monk  = TRADER_THIS_TYPE,
								/obj/item/clothing/suit/judgerobe      = TRADER_THIS_TYPE,
								/obj/item/clothing/suit/wizrobe/magusred=TRADER_THIS_TYPE,
								/obj/item/clothing/suit/wizrobe/magusblue=TRADER_THIS_TYPE,
								/obj/item/clothing/under/gladiator     = TRADER_THIS_TYPE,
								/obj/item/clothing/under/kilt          = TRADER_THIS_TYPE,
								/obj/item/clothing/under/redcoat       = TRADER_THIS_TYPE,
								/obj/item/clothing/under/soviet        = TRADER_THIS_TYPE,
								/obj/item/weapon/material/harpoon      = TRADER_THIS_TYPE,
								/obj/item/weapon/material/sword        = TRADER_ALL,
								/obj/item/weapon/material/scythe       = TRADER_THIS_TYPE,
								/obj/item/weapon/material/star         = TRADER_THIS_TYPE,
								/obj/item/weapon/material/twohanded/baseballbat = TRADER_THIS_TYPE)