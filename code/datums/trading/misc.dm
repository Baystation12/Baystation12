/datum/trader/ship/pet_shop
	name = "Pet Shop Owner"
	name_language = LANGUAGE_SKRELLIAN
	origin = "Pet Shop"
	trade_flags = TRADER_GOODS|TRADER_MONEY|TRADER_WANTED_ONLY
	possible_origins = list("Paws-Out", "Pets-R-Smart", "Tentacle Companions", "Xeno-Pets and Assorted Goods", "Barks and Drools")
	speech = list(TRADER_HAIL_GENERIC    = "Welcome to my xeno-pet shop! Here you will find many wonderful companions. Some a bit more... aggressive than others. But companions none the less. I also buy pets, or trade them.",
				TRADER_HAIL_DENY         = "I no longer wish to speak to you.",

				TRADER_TRADE_COMPLETE    = "Remember to give them attention and food. They are living beings, and you should treat them like so.",
				TRADER_NO_BLACKLISTED   = "Legally I can' do that. Morally, I refuse to do that.",
				TRADER_FOUND_UNWANTED = "I only want animals. I don't need food or shiny things. I'm looking for specific ones at that. Ones I already have the cage and food for.",
				TRADER_NOT_ENOUGH   = "I'd give you the animal for free, but I need the money to feed the others. So you must pay in full.",
				TRADER_HOW_MUCH          = "This is a fine specimen. I believe it will cost you VALUE CURRENCY.",
				TRADER_WHAT_WANT         = "I have the facilities, currently, to support",

				TRADER_COMPLEMENT_FAILURE   = "That was almost charming.",
				TRADER_COMPLEMENT_SUCCESS = "Thank you. I needed that.",
				TRADER_INSULT_GOOD       = "I ask you to stop. We can be peaceful. I know we can.",
				TRADER_INSULT_BAD        = "My interactions with you are becoming less than fruitful.",

				TRADER_BRIBE_FAILURE     = "I'm not going to do that. I have places to be.",
				TRADER_BRIBE_SUCCESS      = "Hm. It'll be good for the animals, so sure.",
				)

	possible_wanted_items = list(/mob/living/simple_animal/passive/corgi      = TRADER_THIS_TYPE,
								/mob/living/simple_animal/passive/cat         = TRADER_THIS_TYPE,
								/mob/living/simple_animal/crab        = TRADER_THIS_TYPE,
								/mob/living/simple_animal/passive/lizard      = TRADER_THIS_TYPE,
								/mob/living/simple_animal/passive/mouse       = TRADER_THIS_TYPE,
								/mob/living/simple_animal/passive/mushroom    = TRADER_THIS_TYPE,
								/mob/living/simple_animal/tindalos    = TRADER_THIS_TYPE,
								/mob/living/simple_animal/passive/tomato      = TRADER_THIS_TYPE,
								/mob/living/simple_animal/passive/cow         = TRADER_THIS_TYPE,
								/mob/living/simple_animal/passive/chick       = TRADER_THIS_TYPE,
								/mob/living/simple_animal/passive/chicken     = TRADER_THIS_TYPE,
								/mob/living/simple_animal/yithian     = TRADER_THIS_TYPE,
								/mob/living/simple_animal/hostile/retaliate/beast/diyaab = TRADER_THIS_TYPE,
								/mob/living/simple_animal/hostile/bear = TRADER_THIS_TYPE,
								/mob/living/simple_animal/hostile/retaliate/beast/shantak= TRADER_THIS_TYPE,
								/mob/living/simple_animal/hostile/retaliate/parrot      = TRADER_THIS_TYPE,
								/mob/living/simple_animal/hostile/retaliate/beast/samak= TRADER_THIS_TYPE,
								/mob/living/simple_animal/hostile/retaliate/goat = TRADER_THIS_TYPE,
								/mob/living/simple_animal/hostile/carp = TRADER_THIS_TYPE)

	possible_trading_items = list(/mob/living/simple_animal/passive/corgi     = TRADER_THIS_TYPE,
								/mob/living/simple_animal/passive/cat         = TRADER_THIS_TYPE,
								/mob/living/simple_animal/crab        = TRADER_THIS_TYPE,
								/mob/living/simple_animal/passive/lizard      = TRADER_THIS_TYPE,
								/mob/living/simple_animal/passive/mouse       = TRADER_THIS_TYPE,
								/mob/living/simple_animal/passive/mushroom    = TRADER_THIS_TYPE,
								/mob/living/simple_animal/tindalos    = TRADER_THIS_TYPE,
								/mob/living/simple_animal/passive/tomato      = TRADER_THIS_TYPE,
								/mob/living/simple_animal/passive/cow         = TRADER_THIS_TYPE,
								/mob/living/simple_animal/passive/chick       = TRADER_THIS_TYPE,
								/mob/living/simple_animal/passive/chicken     = TRADER_THIS_TYPE,
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

/datum/trader/ship/pet_shop/New()
	..()
	speech[TRADER_HAIL_START + SPECIES_SKRELL] = "Ah! A fellow Skrell. How wonderful, I may have a few pets imported from back home. Take a look."

/datum/trader/ship/prank_shop
	name = "Prank Shop Owner"
	name_language = LANGUAGE_ROOTLOCAL
	origin = "Prank Shop"
	compliment_increase = 0
	insult_drop = 0
	possible_origins = list("Yacks and Yucks Shop", "The Shop From Which I Sell Humorous Items", "The Prank Gestalt", "The Clown's Armory", "Uncle Knuckle's Chuckle Bunker", "A Place from Which to do Humorous Business")
	speech = list(TRADER_HAIL_GENERIC = "We welcome you to our shop of humorous items. We invite you to partake in the divine experience of being pranked, and pranking someone else.",
				TRADER_HAIL_DENY      = "We cannot do business with you. We are sorry.",

				TRADER_TRADE_COMPLETE = "We thank you for purchasing something. We enjoyed the experience of you doing so and we hope to learn from it.",
				TRADER_NO_BLACKLISTED= "We are not allowed to do such. We are sorry.",
				TRADER_NOT_ENOUGH="We have sufficiently experienced giving away goods for free. We wish to experience getting money in return.",
				TRADER_HOW_MUCH       = "We believe that is worth VALUE CURRENCY.",
				TRADER_WHAT_WANT      = "We wish only for the experiences you give us, in all else we want",

				TRADER_COMPLEMENT_FAILURE= "You are attempting to compliment us.",
				TRADER_COMPLEMENT_SUCCESS="You are attempting to compliment us.",
				TRADER_INSULT_GOOD    = "You are attempting to insult us, correct?",
				TRADER_INSULT_BAD     = "We do not understand.",

				TRADER_BRIBE_FAILURE  = "We are sorry, but we cannot accept.",
				TRADER_BRIBE_SUCCESS   = "We are happy to say that we accept this bribe.",
				)
	possible_trading_items = list(/obj/item/clothing/mask/gas/clown_hat = TRADER_THIS_TYPE,
								/obj/item/clothing/mask/gas/mime        = TRADER_THIS_TYPE,
								/obj/item/clothing/shoes/clown_shoes    = TRADER_THIS_TYPE,
								/obj/item/clothing/under/rank/clown     = TRADER_THIS_TYPE,
								/obj/item/stamp/clown            = TRADER_THIS_TYPE,
								/obj/item/storage/backpack/clown = TRADER_THIS_TYPE,
								/obj/item/bananapeel             = TRADER_THIS_TYPE,
								/obj/item/gun/launcher/money     = TRADER_THIS_TYPE,
								/obj/item/reagent_containers/food/snacks/pie = TRADER_THIS_TYPE,
								/obj/item/bikehorn               = TRADER_THIS_TYPE,
								/obj/item/reagent_containers/spray/waterflower = TRADER_THIS_TYPE,
								/obj/item/gun/launcher/pneumatic/small = TRADER_THIS_TYPE,
								/obj/item/gun/projectile/revolver/capgun = TRADER_THIS_TYPE,
								/obj/item/clothing/mask/fakemoustache   = TRADER_THIS_TYPE,
								/obj/item/grenade/spawnergrenade/fake_carp = TRADER_THIS_TYPE)

/datum/trader/ship/pet_shop/New()
	..()
	speech[TRADER_HAIL_START + SPECIES_DIONA] = "Welcome, other gestalt. We invite you to learn of our experiences, and teach us of your own."


/datum/trader/ship/replica_shop
	name = "Replica Store Owner"
	name_language = TRADER_DEFAULT_NAME
	origin = "Replica Store"
	possible_origins = list("Ye-Old Armory", "Knights and Knaves", "The Blacksmith", "Historical Human Apparel and Items", "The Pointy End", "Fight Knight's Knightly Nightly Knight Fights", "Elminster's Fine Steel", "The Arms of King Duordan", "Queen's Edict")
	speech = list(TRADER_HAIL_GENERIC = "Greetings, traveler! You've the look of one with a keen hunger for human history. Come in, and learn! Mayhaps even... buy?",
				TRADER_HAIL_DENY      = "I shan't palaver with a man who thumbs his nose at the annals of history. Goodbye.",

				TRADER_TRADE_COMPLETE = "Thank you, mighty warrior. And remember - these may be replicas, but their edges are honed to razor sharpness!",
				TRADER_NO_BLACKLISTED= "Nay, we accept only the CURRENCY_SINGULAR. Or sovereigns of the king's mint, of course.",
				TRADER_NOT_ENOUGH="Alas, traveler, my fine wares cost more than that.",
				TRADER_HOW_MUCH       = "For VALUE CURRENCY, I can part with this finest of goods.",
				TRADER_WHAT_WANT      = "I have ever longed for",

				TRADER_COMPLEMENT_FAILURE= "Oh ho ho! Aren't you quite the jester.",
				TRADER_COMPLEMENT_SUCCESS="Why, thank you, traveler! Long have I slaved over the anvil to produce these goods.",
				TRADER_INSULT_GOOD    = "Hey, bro, I'm just tryin' to make a living here, okay? The Camelot schtick is part of my brand.",
				TRADER_INSULT_BAD     = "Man, fuck you, then.",

				TRADER_BRIBE_FAILURE  = "Alas, traveler - I could stay all eve, but I've an Unathi client in waiting, and they are not known for patience.",
				TRADER_BRIBE_SUCCESS   = "Mayhaps I could set a spell longer, and rest my weary feet.",
				)
	possible_trading_items = list(/obj/item/clothing/head/wizard/magus = TRADER_THIS_TYPE,
								/obj/item/shield/buckler        = TRADER_THIS_TYPE,
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
								/obj/item/material/harpoon      = TRADER_THIS_TYPE,
								/obj/item/material/sword        = TRADER_ALL,
								/obj/item/material/scythe       = TRADER_THIS_TYPE,
								/obj/item/material/star         = TRADER_THIS_TYPE,
								/obj/item/material/twohanded/baseballbat = TRADER_THIS_TYPE)

/datum/trader/ship/pet_shop/New()
	..()
	speech[TRADER_HAIL_START + SPECIES_UNATHI] = "Ah, you've the look of a lizard who knows his way around martial combat. Come in! We can only hope our steel meets the formidable Moghedi standards."
