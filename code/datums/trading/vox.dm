/datum/trader/ship/vox
	typical_duration = 15
	origin = "UNREGISTERED VESSEL"
	language = "Vox-pidgin"
	trade_goods = 100 //they only deal in goods
	complement_increase = 0
	var/hailed_vox = 0 //Whether we have been hailed by a vox. negatives mean pariah, positives mean regular.
	blacklisted_trade_items = null

	speech = list("hail_generic0"    = "SKREEE! We will trade good stuff, yes?",
				"hail_generic1"      = "SKREEEEE! You friend of Vox? You trade with, yes?",
				"hail_silicon0"      = "Hello metal thing! You trade metal for things?",
				"hail_silicon1"      = "YOU KNOW VOX? Yes is good, yes yes, MOB. Trade GOOD!",
				"hail_human0"        = "Hello hueman! Kiikikikiki! MOB trade with us, yes? Good!",
				"hail_human1"        = "Friend of Vox is friend of all Vox! MOB you trade now!",
				"hail_vox1"          = "SKREEEE! May the Shaol make this trade good, MOB!",
				"hail_resomi0"       = "Hello MOB! You tiny thing, how pilot ship? Maybe come for dinner! KIKIKIKI!",
				"hail_resomi1"       = "Greetings, MOB, be dinner or friend? KIKIKIKIKII!",
				"hail_deny0"         = "Trade closed, GO AWAY!",
				"hail_deny-1"        = "We no trade with shit like you!",
				"hail_deny1"         = "Trade gone now. Goodbye.",

				"trade0"             = "Hmmm.... yes, will trade PROPOSAL for ITEM. Is good trade!",
				"trade1"             = "Yes, that is good ITEM, will trade PROPOSAL for it.",
				"trade_wanted0"      = "Oooh? Is that ITEM? SKREEEE! I WANT THAT! Will trade PROPOSAL!",
				"trade_wanted1"      = "YES! VOX NEED THAT ITEM NOW! GIVE PROPOSAL!",
				"trade_known0"       = "Forgetting already? Already said give PROPOSAL for ITEM.",
				"trade_known1"       = "What is this? We agree to PROPOSAL for ITEM! You break the trade?",
				"trade_complete0"    = "Yes, kikikikikiki! You will not regret this trade!",
				"trade_complete1"    = "Yes... this is a good trade for the Shaol!",
				"trade_refuse0"      = "Vox isn't that stupid.",
				"trade_refuse1"      = "You know as well as it that is not a good trade.",

				"offer_change0"      = "Hmmmm.. alright! We change trade.",
				"offer_change1"      = "You are right, this is better trade!",
				"offer_reject0"      = "No. WE WILL NOT CHANGE TRADE!",
				"offer_reject1"      = "Bah! Why you try to make deal unfair?",
				"offer_out0"         = "Skreee! We don't know what to trade for that...",
				"offer_out1"         = "Sorry, friend, cannot honorably trade for that.",

				"complement_deny0"   = "No.",
				"complement_deny1"   = "You know better than that!",
				"complement_accept0" = "Kikikikiki! Trade is better than talk, yes?",
				"complement_accept1" = "You butter it up? Should know better than that.",
				"insult_good0"       = "Bah! Why does it have to deal with you?",
				"insult_good1"       = "Where this come from? Is trade no good?",
				"insult_bad0"        = "All you meats are the same! Fuck off!",
				"insult_bad1"        = "If you say all this at home, you be dead!",

				"want0"              = "Hmm.... it wants",
				"want1"              = "Yes... Shaol needs",
				"want_deny0"         = "That is Vox business! Not for you!",
				"want_deny1"         = "You should already know what Shaol wants!"
				)

	possible_wanted_items = list(/obj/item/weapon/                  = TRADER_SUBTYPES_ONLY,
								/obj/item/stack/material            = TRADER_SUBTYPES_ONLY,
								/obj/item/stack/material/cyborg     = TRADER_BLACKLIST_ALL,
								/obj/item/organ                     = TRADER_SUBTYPES_ONLY
								)

	possible_trading_items = list(/obj/item/weapon/gun/projectile/dartgun/vox           = TRADER_SUBTYPES_ONLY,
								/obj/item/mecha_parts/mecha_equipment/tool/             = TRADER_SUBTYPES_ONLY,
								/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/ = TRADER_SUBTYPES_ONLY,
								/obj/item/trash                                         = TRADER_SUBTYPES_ONLY,
								/obj/item/remains                                       = TRADER_ALL,
								/obj/item/clothing/accessory                            = TRADER_ALL,
								/obj/item/robot_parts                                   = TRADER_SUBTYPES_ONLY
								)


/datum/trader/ship/vox/hail(var/mob/user)
	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.species)
			switch(H.species.name)
				if("Vox")
					disposition = 1000
					hailed_vox = 1
				if("Vox Pariah")
					hailed_vox = -1
					disposition = -1000
	..()

/datum/trader/ship/vox/can_hail()
	if(hailed_vox >= 0)
		return ..()
	return 0

/datum/trader/ship/vox/get_response(var/text, var/generic)
	return ..("[text][hailed_vox]", generic)