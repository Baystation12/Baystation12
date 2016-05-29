/datum/trader
	var/name = "unsuspicious trader"                            //The name of the trader in question
	var/origin = "some place"                                   //The place that they are trading from
	var/disposition = 0                                         //The current disposition of them to us.
	var/trade_wanted_only = 0                                   //Whether they will only trade for wanted items.
	var/trade_goods = 50                                        //Probability they will trade money or valuables
	var/language                                                //If this is set to a language name this will generate a name from the language
	var/icon/portrait                                           //The icon that shows up in the menu @TODO

	var/list/wanted_items = list()                              //What items they enjoy trading for.
	var/list/possible_wanted_items                              //List of all possible wanted items. Structure is (type = mode)
	var/list/possible_trading_items                             //List of all possible trading items. Structure is (type = mode)
	var/list/trading_items = list()                             //What items they are currently trading away. Structure is (type = value I want for it)
	var/list/trade_proposals = list()                           //A log of what they will (current) trade something for
	var/list/blacklisted_trade_items = list(/mob/living/carbon/human)
	                                                            //Things they will automatically refuse

	var/list/speech = list()                                    //The list of all their replies and messages. Structure is (id = talk)
	var/insult_drop = 5                                         //How far disposition drops on insult
	var/complement_increase = 5                                 //How far complements increase disposition
	var/refuse_comms = 0                                        //Whether they refuse further communication

	var/mob_transfer_message = "You are transported to ORIGIN." //What message gets sent to mobs that get sold.

/datum/trader/New()
	..()
	if(language)
		var/datum/language/L = all_languages[language]
		if(L)
			name = L.get_random_name(pick(MALE,FEMALE))

	for(var/i in 1 to 3)
		add_to_pool(trading_items, possible_trading_items, force = 1)
		add_to_pool(wanted_items, possible_wanted_items, force = 1)

//If this hits 0 then they decide to up and leave.
/datum/trader/proc/tick()
	spawn(0)
		add_to_pool(trading_items, possible_trading_items)
		add_to_pool(wanted_items, possible_wanted_items, 50)
	return 1

/datum/trader/proc/add_to_pool(var/list/pool, var/list/possible, var/base_chance = 100, var/force = 0)
	var/divisor = 1
	if(pool && pool.len)
		divisor = pool.len
	if(force || prob(base_chance/divisor))
		var/new_item = get_possible_item(possible)
		if(new_item)
			pool |= new_item

/datum/trader/proc/get_possible_item(var/list/trading_pool)
	if(!trading_pool || !trading_pool.len)
		return
	var/i = rand(1,trading_pool.len)
	var/list/possible = list()
	switch(trading_pool[trading_pool[i]])
		if(TRADER_THIS_TYPE)
			possible += trading_pool[i]
		if(TRADER_SUBTYPES_ONLY)
			possible += subtypesof(trading_pool[i])
		if(TRADER_ALL)
			possible += typesof(trading_pool[i])
		if(TRADER_BLACKLIST)
			possible -= trading_pool[i]
		if(TRADER_BLACKLIST_SUB)
			possible -= subtypesof(trading_pool[i])
		if(TRADER_BLACKLIST_ALL)
			possible -= typesof(trading_pool[i])
	if(possible.len)
		var/picked = pick(possible)
		var/atom/A = picked
		if(initial(A.name) in list("object", "item","weapon", "structure", "machinery", "Mecha", "organ", "snack")) //weed out a few of the common bad types. Reason we don't check types specifically is that (hopefully) further bad subtypes don't set their name up and are similar.
			return
		return picked

/datum/trader/proc/get_response(var/key, var/default)
	var/text
	if(speech && speech[key])
		text = speech[key]
	else
		text = default
	text = replacetext(text, "MERCHANT", name)
	return replacetext(text, "ORIGIN", origin)

/datum/trader/proc/print_trade(var/num)
	if(trade_proposals && trade_proposals.len)
		num = Clamp(num,1,trade_proposals.len)
		var/text
		var/atom/movable/A = trade_proposals[num]
		text = initial(A.name)
		A = trade_proposals[trade_proposals[A]]
		return "<b>[text]</b> for <b>[initial(A.name)]</b>"

/datum/trader/proc/hail(var/mob/user)
	var/specific
	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.species)
			specific = H.species.name
	else if(istype(user, /mob/living/silicon))
		specific = "silicon"
	if(!speech["hail_[specific]"])
		specific = "generic"
	var/text = get_response("hail_[specific]", "Greetings, MOB!")
	return replacetext(text, "MOB", user.name)

/datum/trader/proc/can_hail()
	return refuse_comms || prob(-disposition)

/datum/trader/proc/what_do_you_want()
	if(prob(100+disposition) && wanted_items && wanted_items.len)
		var/tell_num_of_items = 1
		while(prob(50+disposition-tell_num_of_items*10) && tell_num_of_items < wanted_items.len)
			tell_num_of_items++
		var/list/output = list()
		var/list/possible = list()
		possible += wanted_items
		for(var/i in 1 to tell_num_of_items)
			var/picked = pick(possible)
			var/atom/A = picked
			output += initial(A.name)
			possible -= picked

		return "[get_response("want","I want")] [english_list(output)]"

	disposition -= rand(insult_drop, insult_drop*2)
	return get_response("want_deny","Why should I tell you? You're the trader!")

/datum/trader/proc/insult()
	disposition -= rand(insult_drop, insult_drop * 2)
	if(disposition > 50)
		return get_response("insult_good","What? I thought we were cool!")
	else if(disposition < 0)
		return get_response("insult_bad", "Right back at you asshole!")

/datum/trader/proc/complement()
	if(prob(-disposition))
		return get_response("complement_deny", "Fuck you!")
	if(prob(100-disposition))
		disposition += rand(complement_increase, complement_increase * 2)
	return get_response("complement_accept", "Thank you!")

/datum/trader/proc/get_item_near_value(var/value)
	if(!trading_items || !trading_items.len)
		return
	var/list/possible = list()
	for(var/a in trading_items)
		var/percent = trading_items[a]/value
		if(percent > 0.9 && percent < 1.1)
			possible |= a
	if(possible.len)
		return pick(possible)
	return null

/datum/trader/proc/judge_item(var/atom/movable/A)
	var/text
	var/value
	if(trade_proposals[A.type]) //if we already know what we want to give for this
		text = get_response("trade_known", "I already said I'd give you PROPOSAL for that ITEM!")
		value = trade_proposals[A.type]
		if(isnum(value))
			value = "[value] thalers"
		else
			var/atom/movable/M = trade_proposals[A.type]
			value = initial(M.name)
	else //otherwise we generate a log of it, and tell them.
		var/multiplier = 1
		if(is_type_in_list(A,wanted_items))
			multiplier = 2
			text = get_response("trade_wanted", "Oh wow! I really want that ITEM! I'll give you PROPOSAL for it!")
		else if(trade_wanted_only || (blacklisted_trade_items && is_type_in_list(A,blacklisted_trade_items)))
			return get_response("trade_refuse", "I don't want that. At all.")
		else
			text = get_response("trade", "Hmm.... I'll give you PROPOSAL for the ITEM")
		value = round(A.item_worth * multiplier * rand(0.9, 1.1))
		if(prob(trade_goods))
			var/type = get_item_near_value(value)
			var/atom/movable/M = type
			if(M)
				trade_proposals[type] = value
				value = initial(M.name)
			else
				text = get_response("trade_out", "I'm sorry, I don't have anything to trade for that.")
		else
			trade_proposals[A.type] = value
			value = "[value] thalers"
	text = replacetext(text,"ITEM","[A.name]")
	return replacetext(text, "PROPOSAL","[value]")

/datum/trader/proc/trade_you_this_for_that(var/atom/movable/offer, var/target_trade)
	if(trade_proposals[target_trade])
		if(isnum(trade_proposals[target_trade]) && istype(offer,/obj/item/weapon/spacecash)) //money
			if(offer.item_worth == trade_proposals[target_trade])
				return TRADER_OFFER_MATCH
		else
			if(prob(10+disposition))
				var/atom/movable/M = trade_proposals[target_trade]
				var/percent = initial(M.item_worth)/offer.item_worth
				if(percent > 0.95)
					trade_proposals[target_trade] = M.type
					disposition -= insult_drop //We don't like changing our offer.
					return TRADER_OFFER_CHANGE //offer changed.
	else
		if(!ispath(trade_proposals[target_trade], /obj/item/weapon/spacecash) || prob(trade_goods) && (!blacklisted_trade_items || !is_type_in_list(offer,blacklisted_trade_items)))
			var/atom/movable/M = trade_proposals[target_trade]
			var/percent = initial(M.item_worth)/offer.item_worth
			var/min_perc = min(0.9, 0.9+disposition/100)
			if(percent > min_perc)
				trade_proposals[target_trade] = M.type
				return TRADER_OFFER_ACCEPT
	disposition -= insult_drop
	return TRADER_OFFER_REJECT

/datum/trader/proc/trade(var/atom/movable/offer)
	var/type
	for(var/a in trade_proposals)
		if(istype(offer,trade_proposals[a]))
			type = a
			break
	if(!type)
		return 0
	var/turf/T = get_turf(offer)
	new type(T)
	if(istype(offer,/mob))
		var/text = mob_transfer_message
		offer << replacetext(text, "ORIGIN", origin)
	qdel(offer)
	return 1