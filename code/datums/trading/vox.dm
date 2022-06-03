/datum/trader/ship/vox
	typical_duration = 60
	origin = "UNREGISTERED VESSEL"
	name_language = LANGUAGE_VOX
	compliment_increase = 0
	trade_flags = TRADER_GOODS
	var/hailed_vox = FALSE //Whether we have been hailed by a vox. negatives mean pariah, positives mean regular.
	blacklisted_trade_items = null

	speech = list(TRADER_HAIL_GENERIC    = "SKREEE! We will trade good stuff, yes?",
				TRADER_HAIL_DENY         = "Trade closed, GO AWAY!",

				TRADER_TRADE_COMPLETE    = "Yes, kikikikikiki! You will not regret this trade!",
				TRADER_NO_MONEY    = "Money? Vox no need money. GOODS! Give it GOODS!",
				TRADER_NOT_ENOUGH  = "It wants MORE for that. Give it more.",

				TRADER_HOW_MUCH          = "You give it something worth VALUE, yes?",
				TRADER_WHAT_WANT         = "Vox wants",

				TRADER_COMPLEMENT_FAILURE   = "No.",
				TRADER_COMPLEMENT_SUCCESS = "Kikikikiki! Trade is better than talk, yes?",
				TRADER_INSULT_GOOD       = "Bah! Why does it have to deal with you?",
				TRADER_INSULT_BAD        = "All you meats are the same! Fuck off!",
				)

	var/list/visited_vox_speech = list(
		TRADER_HAIL_GENERIC      = "SKREEEEE! You friend of Vox? You trade with, yes?",
		TRADER_HAIL_DENY         = "Trade gone now. Goodbye.",

		TRADER_TRADE_COMPLETE    = "Yes... this is a good trade for the Shoal!",
		TRADER_NO_MONEY    = "You know as well as it that money is no good.",
		TRADER_NOT_ENOUGH  = "Ech, you insult it with such a trade? Respect it, make it equal.",

		TRADER_HOW_MUCH          = "Hmm.... VALUE. Something like that.",
		TRADER_WHAT_WANT         = "We need",

		TRADER_COMPLEMENT_FAILURE   = "You know better than that!",
		TRADER_COMPLEMENT_SUCCESS = "You butter it up? Should know better than that.",
		TRADER_INSULT_GOOD       = "Where this come from? Is trade no good?",
		TRADER_INSULT_BAD        = "If you say all this at home, you be dead!"
		)
	possible_wanted_items = list(/obj/item/                  = TRADER_SUBTYPES_ONLY,
								/obj/item/stack/material            = TRADER_SUBTYPES_ONLY,
								/obj/item/stack/material/cyborg     = TRADER_BLACKLIST_ALL,
								/obj/item/organ                     = TRADER_SUBTYPES_ONLY,
								)

	possible_trading_items = list(/obj/item/gun/projectile/dartgun/vox           = TRADER_SUBTYPES_ONLY,
								/obj/item/trash                                         = TRADER_SUBTYPES_ONLY,
								/obj/item/remains                                       = TRADER_ALL,
								/obj/item/clothing/accessory                            = TRADER_ALL,
								/obj/item/robot_parts                                   = TRADER_SUBTYPES_ONLY,
								/obj/item/robot_parts/robot_component                   = TRADER_BLACKLIST
								)

	mob_transfer_message = "<span class='danger'>You are transported to the ORIGIN. When the transportation dizziness wears off, you find you are surrounded by cackling Vox...</span>"

/datum/trader/ship/vox/New()
	..()
	speech[TRADER_HAIL_START + "silicon"] = "Hello metal thing! You trade metal for things?"
	speech[TRADER_HAIL_START + SPECIES_HUMAN] = "Hello hueman! Kiikikikiki! MOB trade with us, yes? Good!"

	visited_vox_speech[TRADER_HAIL_START + "silicon"] = "YOU KNOW VOX? Yes is good, yes yes, MOB. Trade GOOD!"
	visited_vox_speech[TRADER_HAIL_START + SPECIES_HUMAN] = "Friend of Vox is friend of all Vox! MOB you trade now!"
	visited_vox_speech[TRADER_HAIL_START + SPECIES_VOX] = "SKREEEE! May the Shoal make this trade good, MOB!"

/datum/trader/ship/vox/hail(var/mob/user)
	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.species)
			switch(H.species.name)
				if(SPECIES_VOX)
					disposition = 1000
					hailed_vox = TRUE
					speech = visited_vox_speech
	. = ..()

/datum/trader/ship/vox/can_hail()
	if(hailed_vox >= 0)
		return ..()
	return FALSE

/datum/trader/ship/vox/get_item_value(var/trading_num)
	. = ..()
	if(!hailed_vox)
		. *= 2
