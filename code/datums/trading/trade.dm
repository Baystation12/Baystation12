/datum/trader
	var/name = "unsuspicious trader"                            //The name of the trader in question
	var/origin = "some place"                                   //The place that they are trading from
	var/list/possible_origins                                   //Possible names of the trader origin
	var/disposition = 0                                         //The current disposition of them to us.
	var/trade_flags = TRADER_MONEY                              //Flags
	var/name_language                                                //If this is set to a language name this will generate a name from the language
	var/icon/portrait                                           //The icon that shows up in the menu @TODO

	var/list/wanted_items = list()                              //What items they enjoy trading for. Structure is (type = known/unknown)
	var/list/possible_wanted_items                              //List of all possible wanted items. Structure is (type = mode)
	var/list/possible_trading_items                             //List of all possible trading items. Structure is (type = mode)
	var/list/trading_items = list()                             //What items they are currently trading away.
	var/list/blacklisted_trade_items = list(/mob/living/carbon/human)
	                                                            //Things they will automatically refuse

	var/list/speech = list()                                    //The list of all their replies and messages. Structure is (id = talk)
	/*SPEECH IDS:
	hail_generic		When merchants hail a person
	hail_[race]			Race specific hails
	hail_deny			When merchant denies a hail

	insult_good			When the player insults a merchant while they are on good disposition
	insult_bad			When a player insults a merchatn when they are not on good disposition
	complement_accept	When the merchant accepts a complement
	complement_deny		When the merchant refuses a complement

	how_much			When a merchant tells the player how much something is.
	trade_complete		When a trade is made

	what_want			What the person says when they are asked if they want something

	*/
	var/want_multiplier = 2                                     //How much wanted items are multiplied by when traded for
	var/margin = 1.2											//Multiplier to price when selling to player
	var/price_rng = 10                                          //Percentage max variance in sell prices.
	var/insult_drop = 5                                         //How far disposition drops on insult
	var/compliment_increase = 5                                 //How far compliments increase disposition
	var/refuse_comms = 0                                        //Whether they refuse further communication

	var/mob_transfer_message = "You are transported to ORIGIN." //What message gets sent to mobs that get sold.

/datum/trader/New()
	..()
	if(name_language)
		if(name_language == TRADER_DEFAULT_NAME)
			name = capitalize(pick(GLOB.first_names_female + GLOB.first_names_male)) + " " + capitalize(pick(GLOB.last_names))
		else
			var/datum/language/L = all_languages[name_language]
			if(L)
				name = L.get_random_name(pick(MALE,FEMALE))
	if(possible_origins && possible_origins.len)
		origin = pick(possible_origins)

	//Generate the
	if(possible_wanted_items)
		possible_wanted_items = generate_pool(possible_wanted_items)
	if(possible_trading_items)
		possible_trading_items = generate_pool(possible_trading_items)

	for(var/i in 3 to 6)
		add_to_pool(trading_items, possible_trading_items, force = 1)
		add_to_pool(wanted_items, possible_wanted_items, force = 1)

/datum/trader/proc/generate_pool(var/list/trading_pool)
	. = list()
	for(var/type in trading_pool)
		var/status = trading_pool[type]
		if(status & TRADER_THIS_TYPE)
			. += type
		if(status & TRADER_SUBTYPES_ONLY)
			. += subtypesof(type)
		if(status & TRADER_BLACKLIST)
			. -= type
		if(status & TRADER_BLACKLIST_SUB)
			. -= subtypesof(type)


//If this hits 0 then they decide to up and leave.
/datum/trader/proc/tick()
	add_to_pool(trading_items, possible_trading_items, 200)
	add_to_pool(wanted_items, possible_wanted_items, 50)
	remove_from_pool(possible_trading_items, 9) //We want the stock to change every so often, so we make it so that they have roughly 10~11 ish items max
	return 1

/datum/trader/proc/remove_from_pool(var/list/pool, var/chance_per_item)
	if(pool && prob(chance_per_item * pool.len))
		var/i = rand(1,pool.len)
		pool[pool[i]] = null
		pool -= pool[i]

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
	var/picked = pick(trading_pool)
	var/atom/A = picked
	if(initial(A.name) in list("object", "item","weapon", "structure", "machinery", "exosuit", "organ", "snack")) //weed out a few of the common bad types. Reason we don't check types specifically is that (hopefully) further bad subtypes don't set their name up and are similar.
		return null
	if(initial(A.trade_blacklisted) == TRUE)
		return null
	return picked

/datum/trader/proc/get_response(var/key, var/default)
	if(speech && speech[key])
		. = speech[key]
	else
		. = default
	. = replacetext_char(., "MERCHANT", name)
	. = replacetext_char(., "ORIGIN", origin)
	. = replacetext_char(.,"CURRENCY_SINGULAR", GLOB.using_map.local_currency_name_singular)
	. = replacetext_char(.,"CURRENCY", GLOB.using_map.local_currency_name)

/datum/trader/proc/print_trading_items(var/num)
	num = clamp(num,1,trading_items.len)
	if(trading_items[num])
		var/atom/movable/M = trading_items[num]
		return "<b>[initial(M.name)]</b>"

/datum/trader/proc/skill_curve(skill)
	switch(skill)
		if(SKILL_EXPERT)
			. = 1
		if(SKILL_EXPERT to SKILL_MAX)
			. = 1 + (SKILL_EXPERT - skill) * 0.2
		else
			. = 1 + (SKILL_EXPERT - skill) ** 2
	//This condition ensures that the buy price is higher than the sell price on generic goods, i.e. the merchant can't be exploited
	. = max(., price_rng/((margin - 1)*(200 - price_rng)))

/datum/trader/proc/get_item_value(var/trading_num, skill = SKILL_MAX)
	if(!trading_items[trading_items[trading_num]])
		var/type = trading_items[trading_num]
		var/value = get_value(type)
		value = round(rand(100 - price_rng,100 + price_rng)/100 * value) //For some reason rand doesn't like decimals.
		trading_items[type] = value
	. = trading_items[trading_items[trading_num]]
	. *= 1 + (margin - 1) * skill_curve(skill) //Trader will overcharge at lower skill.

/datum/trader/proc/get_buy_price(item, is_wanted, skill = SKILL_MAX)
	. = get_value(item)
	if(is_wanted)
		. *= want_multiplier
	. *= max(1 - (margin - 1) * skill_curve(skill), 0.1) //Trader will underpay at lower skill.

/datum/trader/proc/make_response(var/response_type, var/response_default, var/delta = 0, var/success = TRUE)
	. = new /datum/trade_response(get_response(response_type, response_default), delta, success)

/datum/trader/proc/offer_money_for_bulk(quantity, trade_num, money_amount, turf/location, skill = SKILL_MAX)
	if(!(trade_flags & TRADER_MONEY))
		return make_response(TRADER_NO_MONEY, "I don't like money.", 0, FALSE)
	var/value = get_item_value(trade_num, skill) * quantity
	if(money_amount < value)
		return make_response(TRADER_NOT_ENOUGH, "I need more money!", 0, FALSE)
	trade_quantity(quantity, list(), trade_num, location)
	return make_response(TRADER_TRADE_COMPLETE, "Thank you for your patronage!", -value, TRUE)

/datum/trader/proc/offer_items_for_bulk(quantity, list/offers, num, turf/location, skill = SKILL_MAX)
	if(!offers?.len)
		return make_response(TRADER_NOT_ENOUGH, "That's not enough.", 0, FALSE)
	num = clamp(num, 1, trading_items.len)
	var/offer_worth = 0
	for(var/item in offers)
		var/atom/movable/offer = item
		var/is_wanted = 0
		if((trade_flags & TRADER_WANTED_ONLY) && is_type_in_list(offer, wanted_items))
			is_wanted = 2
		if((trade_flags & TRADER_WANTED_ALL) && is_type_in_list(offer, possible_wanted_items))
			is_wanted = 1
		if(blacklisted_trade_items?.len && is_type_in_list(offer ,blacklisted_trade_items))
			return make_response(TRADER_NO_BLACKLISTED, "I refuse to take one of those items.", 0, FALSE)

		if(istype(offer, /obj/item/spacecash))
			if(!(trade_flags & TRADER_MONEY))
				return make_response(TRADER_NO_MONEY, "I don't take money.", 0, FALSE)
		else
			if(!(trade_flags & TRADER_GOODS))
				return make_response(TRADER_NO_GOODS, "I don't take goods.", 0, FALSE)
			else if((trade_flags & TRADER_WANTED_ONLY|TRADER_WANTED_ALL) && !is_wanted)
				return make_response(TRADER_FOUND_UNWANTED, "I don't want one of those items", 0, FALSE)

		offer_worth += get_buy_price(offer, is_wanted - 1, skill) * quantity
	if(!offer_worth)
		return make_response(TRADER_NOT_ENOUGH, "Everything you gave me is worthless!", 0, FALSE)
	var/trading_worth = get_item_value(num, skill)
	if(!trading_worth)
		return make_response(TRADER_NOT_ENOUGH, "That's not enough.", 0, FALSE)
	var/percent = offer_worth/trading_worth
	if(percent > max(0.9, 0.9-disposition / 100))
		trade_quantity(quantity, offers, num, location)
		return make_response(TRADER_TRADE_COMPLETE, "Thank you for your patronage!", 0, TRUE)
	return make_response(TRADER_NOT_ENOUGH, "That's not enough.", 0, FALSE)

/datum/trader/proc/hail(var/mob/user)
	if(!can_hail())
		return make_response(TRADER_HAIL_DENY, "No, go away.", 0, FALSE)
	var/specific
	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.species)
			specific = H.species.name
	else if(istype(user, /mob/living/silicon))
		specific = "silicon"
	if(!speech[TRADER_HAIL_START + specific])
		specific = "generic"
	var/datum/trade_response/tr = make_response(TRADER_HAIL_START + specific, "Greetings, MOB!", 0, TRUE)
	tr.text = replacetext_char(tr.text, "MOB", user.name)
	return tr

/datum/trader/proc/can_hail()
	if(!refuse_comms && prob(-disposition))
		refuse_comms = 1
	return !refuse_comms

/datum/trader/proc/insult()
	disposition -= rand(insult_drop, insult_drop * 2)
	if(prob(-disposition/10))
		refuse_comms = 1
	if(disposition > 50)
		return make_response(TRADER_INSULT_GOOD,"What? I thought we were cool!", 0, TRUE)
	else
		return make_response(TRADER_INSULT_BAD, "Right back at you asshole!", 0, FALSE)

/datum/trader/proc/compliment()
	if(prob(-disposition))
		return make_response(TRADER_COMPLEMENT_FAILURE, "Fuck you!", 0, FALSE)
	if(prob(100-disposition))
		disposition += rand(compliment_increase, compliment_increase * 2)
	return make_response(TRADER_COMPLEMENT_SUCCESS, "Thank you!", 0, TRUE)

/datum/trader/proc/trade_quantity(quantity, list/offers, num, turf/location)
	for(var/offer in offers)
		if(istype(offer, /mob))
			var/text = mob_transfer_message
			to_chat(offer, replacetext_char(text, "ORIGIN", origin))
		qdel(offer)

	num = clamp(num, 1, trading_items.len)
	var/type = trading_items[num]

	var/list/M = list()
	for (var/i = 1 to quantity)
		M += new type(location)

	playsound(location, 'sound/effects/teleport.ogg', 50, 1)
	disposition += quantity * (rand(compliment_increase, compliment_increase * 3))

	return M

/datum/trader/proc/how_much_do_you_want(var/num, skill = SKILL_MAX)
	num = clamp(num, 1, trading_items.len)
	var/atom/movable/M = trading_items[num]
	var/datum/trade_response/tr = make_response(TRADER_HOW_MUCH, "Hmm.... how about VALUE CURRENCY?", 0, FALSE)
	tr.text = replacetext_char(replacetext_char(tr.text, "ITEM", initial(M.name)), "VALUE", get_item_value(num, skill))
	return tr

/datum/trader/proc/what_do_you_want()
	if(!(trade_flags & TRADER_GOODS))
		return make_response(TRADER_NO_GOODS, "I don't deal in goods.", 0, FALSE)

	var/datum/trade_response/tr = make_response(TRADER_WHAT_WANT, "Hm, I want", 0, TRUE)
	var/list/want_english = list()
	for(var/type in wanted_items)
		var/atom/a = type
		want_english += initial(a.name)
	tr.text += " [english_list(want_english)]"
	return tr

/datum/trader/proc/sell_items(var/list/offers, skill = SKILL_MAX)
	if(!(trade_flags & TRADER_GOODS))
		return make_response(TRADER_GOODS, "I'm not buying.", 0, FALSE)
	if(!offers || !offers.len)
		return make_response(TRADER_NOT_ENOUGH, "I'm not buying that.", 0, FALSE)

	var/wanted
	var/total = 0
	for(var/offer in offers)
		if((trade_flags & TRADER_WANTED_ONLY) && is_type_in_list(offer,wanted_items))
			wanted = 1
		else if((trade_flags & TRADER_WANTED_ALL) && is_type_in_list(offer,possible_wanted_items))
			wanted = 0
		else
			return make_response(TRADER_FOUND_UNWANTED, "I don't want one of those items", 0, FALSE)
		total += get_buy_price(offer, wanted, skill)

	playsound(get_turf(offers[1]), 'sound/effects/teleport.ogg', 50, 1)
	for(var/offer in offers)
		qdel(offer)
	return make_response(TRADER_TRADE_COMPLETE, "Thanks for the goods!", total, TRUE)

/datum/trader/proc/bribe_to_stay_longer(var/amt)
	return make_response(TRADER_BRIBE_FAILURE, "How about no?", 0, FALSE)
