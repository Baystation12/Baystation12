/datum/trader/ship/vox
	typical_duration = 15
	origin = "UNREGISTERED VESSEL"
	name_language = "Vox-pidgin"
	compliment_increase = 0
	trade_flags = TRADER_GOODS
	var/hailed_vox = 0 //Whether we have been hailed by a vox. negatives mean pariah, positives mean regular.
	blacklisted_trade_items = null

	speech = list("hail_generic0"    = "SKREEE! We will trade good stuff, yes?",
				"hail_generic1"      = "SKREEEEE! You friend of Vox? You trade with, yes?",
				"hail_silicon0"      = "Hello metal thing! You trade metal for things?",
				"hail_silicon1"      = "YOU KNOW VOX? Yes is good, yes yes, MOB. Trade GOOD!",
				"hail_Human0"        = "Hello hueman! Kiikikikiki! MOB trade with us, yes? Good!",
				"hail_Human1"        = "Friend of Vox is friend of all Vox! MOB you trade now!",
				"hail_Vox1"          = "SKREEEE! May the Shoal make this trade good, MOB!",
				"hail_deny0"         = "Trade closed, GO AWAY!",
				"hail_deny-1"        = "We no trade with shit like you!",
				"hail_deny1"         = "Trade gone now. Goodbye.",

				"trade_complete0"    = "Yes, kikikikikiki! You will not regret this trade!",
				"trade_complete1"    = "Yes... this is a good trade for the Shaol!",
				"trade_no_money0"    = "Money? Vox no need money. GOODS! Give it GOODS!",
				"trade_no_money1"    = "You know as well as it that money is no good.",
				"trade_not_enough0"  = "It wants MORE for that. Give it more.",
				"trade_not_enough1"  = "Ech, you insult it with such a trade? Respect it, make it equal.",

				"trade_refuse1"      = "You know as well as it that is not a good trade.",
				"how_much0"          = "You give it something worth VALUE, yes?",
				"how_much1"          = "Hmm.... VALUE. Something like that.",
				"what_want0"         = "Vox wants",
				"what_want1"         = "Shoal wants",

				"compliment_deny0"   = "No.",
				"compliment_deny1"   = "You know better than that!",
				"compliment_accept0" = "Kikikikiki! Trade is better than talk, yes?",
				"compliment_accept1" = "You butter it up? Should know better than that.",
				"insult_good0"       = "Bah! Why does it have to deal with you?",
				"insult_good1"       = "Where this come from? Is trade no good?",
				"insult_bad0"        = "All you meats are the same! Fuck off!",
				"insult_bad1"        = "If you say all this at home, you be dead!",
				)

	possible_wanted_items = list(/obj/item/weapon/                  = TRADER_SUBTYPES_ONLY,
								/obj/item/stack/material            = TRADER_SUBTYPES_ONLY,
								/obj/item/stack/material/cyborg     = TRADER_BLACKLIST_ALL,
								/obj/item/organ                     = TRADER_SUBTYPES_ONLY,
								)

	possible_trading_items = list(/obj/item/weapon/gun/projectile/dartgun/vox           = TRADER_SUBTYPES_ONLY,
								/obj/item/mecha_parts/mecha_equipment/tool/             = TRADER_SUBTYPES_ONLY,
								/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/ = TRADER_SUBTYPES_ONLY,
								/obj/item/trash                                         = TRADER_SUBTYPES_ONLY,
								/obj/item/remains                                       = TRADER_ALL,
								/obj/item/clothing/accessory                            = TRADER_ALL,
								/obj/item/robot_parts                                   = TRADER_SUBTYPES_ONLY,
								/obj/item/robot_parts/robot_component                   = TRADER_BLACKLIST
								)

	mob_transfer_message = "<span class='danger'>You are transported to the ORIGIN, when the transportation dizziness wears off, you find you are surrounded by cackling Vox...</span>"


/datum/trader/ship/vox/hail(var/mob/user)
	var/specific
	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.species)
			switch(H.species.name)
				if(SPECIES_VOX)
					disposition = 1000
					hailed_vox = 1
			specific = H.species.name
	else if(istype(user, /mob/living/silicon))
		specific = "silicon"
	if(!speech["hail_[specific][hailed_vox]"])
		specific = "generic"
	. = get_response("hail_[specific][hailed_vox]", "Greetings, MOB!")
	. = replacetext(., "MOB", user.name)

/datum/trader/ship/vox/can_hail()
	if(hailed_vox >= 0)
		return ..()
	return 0

/datum/trader/ship/vox/get_response(var/text, var/generic)
	return ..("[text][hailed_vox]", generic)

/datum/trader/ship/vox/get_item_value(var/trading_num)
	. = ..()
	if(!hailed_vox)
		. *= 2