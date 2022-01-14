/datum/computer_file/program/merchant
	filename = "mlist"
	filedesc = "Merchant's List"
	extended_desc = "Allows communication and trade between passing vessels, even while jumping."
	program_icon_state = "comm"
	program_menu_icon = "cart"
	nanomodule_path = /datum/nano_module/program/merchant
	size = 12
	usage_flags = PROGRAM_CONSOLE
	required_access = access_merchant
	var/obj/machinery/merchant_pad/pad = null
	var/current_merchant = 0
	var/show_trades = FALSE
	var/hailed_merchant = FALSE
	var/last_comms = null
	var/temp = null
	/// Stores the money deposited into the merchant program
	var/bank = 0

/datum/nano_module/program/merchant
	name = "Merchant's List"

/datum/computer_file/program/merchant/proc/get_merchant(index)
	if (!index)
		return
	var/count = GLOB.trader_types.len
	if (!count)
		return
	var/trader_type = GLOB.trader_types[clamp(index, 1, count)]
	return GLOB.traders[trader_type]

/datum/nano_module/program/merchant/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()
	var/show_trade = 0
	var/hailed = 0
	var/datum/trader/T
	if(program)
		var/datum/computer_file/program/merchant/P = program
		data["temp"] = P.temp
		data["mode"] = !!P.current_merchant
		data["last_comms"] = P.last_comms
		data["pad"] = !!P.pad
		data["bank"] = P.bank
		show_trade = P.show_trades
		hailed = P.hailed_merchant
		T = P.get_merchant(P.current_merchant)
	data["mode"] = !!T
	if(T)
		data["traderName"] = T.name
		data["origin"]     = T.origin
		data["hailed"]     = hailed
		if(show_trade)
			var/list/trades = list()
			if(T.trading_items.len)
				for(var/i in 1 to T.trading_items.len)
					trades += T.print_trading_items(i)
			data["trades"] = trades
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "merchant.tmpl", "Merchant List", 575, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/computer_file/program/merchant/proc/connect_pad()
	for(var/obj/machinery/merchant_pad/P in orange(1,get_turf(computer)))
		pad = P
		return

/datum/computer_file/program/merchant/proc/test_fire()
	if(pad && pad.get_target())
		return TRUE
	return FALSE

/datum/computer_file/program/merchant/proc/get_response(var/datum/trade_response/tr)
	last_comms = tr.text
	bank += tr.money_delta
	return tr.success

/datum/computer_file/program/merchant/proc/offer_money(var/datum/trader/T, var/num, skill)
	var/quantity = 1
	if(pad)
		get_response(T.offer_money_for_bulk(quantity, num, bank, get_turf(pad), skill))
	else
		last_comms = "PAD NOT CONNECTED"

/datum/computer_file/program/merchant/proc/offer_bulk(datum/trader/T, num, skill)
	var/quantity = input("How many do you wish to buy? (1-30)") as num | null //limiting to max 30 per purchase to reduce flooding of the server with spawned items.
	if(!isnum(quantity))
		last_comms = "ERROR #417 - NUMBER EXPECTED"
		return
	if(quantity < 1 || quantity > 30)
		last_comms = "ERROR #415 - BLUESPACE ALIGNMENT TERMINATED DUE TO UNEXPECTED VALUE."
		return
	if(pad)
		get_response(T.offer_money_for_bulk(quantity, num, bank, get_turf(pad), skill))
	else
		last_comms = "PAD NOT CONNECTED"

/datum/computer_file/program/merchant/proc/bribe(var/datum/trader/T, var/amt)
	if(bank < amt)
		last_comms = "ERROR: NOT ENOUGH FUNDS."
		return
	get_response(T.bribe_to_stay_longer(amt))

/datum/computer_file/program/merchant/proc/offer_item(var/datum/trader/T, var/num, skill)
	var/quantity = 1
	if(pad)
		var/list/targets = pad.get_targets()
		for(var/target in targets)
			if(!computer.emagged() && istype(target,/mob/living/carbon/human))
				last_comms = "SAFETY LOCK ENABLED: SENTIENT MATTER UNTRANSMITTABLE"
				return
		get_response(T.offer_items_for_bulk(quantity, targets, num, get_turf(pad), skill))
	else
		last_comms = "PAD NOT CONNECTED"

/datum/computer_file/program/merchant/proc/offer_item_bulk(datum/trader/T, num, skill)
	var/quantity = input("How many do you wish to buy? (1-30)") as num //limiting to max 30 per purchase to reduce flooding of the server with spawned items
	if(!isnum(quantity))
		last_comms = "ERROR #417 - NUMBER EXPECTED"
		return
	if(quantity < 1 || quantity > 30)
		last_comms = "ERROR #415 - TELEPAD OVERFLOW OVERRIDE ACTIVATED"
		return
	if(pad)
		var/list/targets = pad.get_targets()
		for(var/target in targets)
			if(!computer.emagged() && istype(target,/mob/living/carbon/human))
				last_comms = "SAFETY LOCK ENABLED: SENTIENT MATTER UNTRANSMITTABLE"
				return
		get_response(T.offer_items_for_bulk(quantity, targets, num, get_turf(pad), skill))
	else
		last_comms = "PAD NOT CONNECTED"

/datum/computer_file/program/merchant/proc/sell_items(var/datum/trader/T, skill)
	if(pad)
		var/list/targets = pad.get_targets()
		get_response(T.sell_items(targets, skill))
	else
		last_comms = "PAD NOT CONNECTED"

/datum/computer_file/program/merchant/proc/transfer_to_bank()
	if(pad)
		var/list/targets = pad.get_targets()
		for(var/target in targets)
			if(istype(target, /obj/item/spacecash))
				var/obj/item/spacecash/cash = target
				bank += cash.worth
				qdel(target)
		last_comms = "ALL MONEY DETECTED ON PAD TRANSFERED"
		return
	last_comms = "PAD NOT CONNECTED"

/datum/computer_file/program/merchant/proc/get_money()
	if(!pad)
		last_comms = "PAD NOT CONNECTED. CANNOT TRANSFER"
		return
	var/turf/T = get_turf(pad)
	var/obj/item/spacecash/bundle/B = new(T)
	B.worth = bank
	bank = 0
	B.update_icon()

/datum/computer_file/program/merchant/Topic(href, href_list)
	if(..())
		return TOPIC_HANDLED
	var/mob/user = usr
	if(href_list["PRG_connect_pad"])
		. = TOPIC_HANDLED
		connect_pad()
	if(href_list["PRG_continue"])
		. = TOPIC_HANDLED
		temp = null
	if(href_list["PRG_transfer_to_bank"])
		. = TOPIC_HANDLED
		transfer_to_bank()
	if(href_list["PRG_get_money"])
		. = TOPIC_HANDLED
		get_money()
	if(href_list["PRG_main_menu"])
		. = TOPIC_HANDLED
		current_merchant = 0
	if(href_list["PRG_merchant_list"])
		if (!GLOB.trader_types.len)
			. = TOPIC_NOACTION
			temp = "Cannot find any traders within broadcasting range."
		else
			. = TOPIC_HANDLED
			current_merchant = 1
			hailed_merchant = FALSE
			last_comms = null
	if(href_list["PRG_test_fire"])
		. = TOPIC_HANDLED
		if(test_fire())
			temp = "Test Fire Successful"
		else
			temp = "Test Fire Unsuccessful"
	if(href_list["PRG_scroll"])
		. = TOPIC_HANDLED
		var/scrolled = 0
		switch(href_list["PRG_scroll"])
			if("right")
				scrolled = 1
			if("left")
				scrolled = -1
		var/new_merchant  = clamp(current_merchant + scrolled, 1, GLOB.trader_types.len)
		if(new_merchant != current_merchant)
			hailed_merchant = FALSE
			last_comms = null
		current_merchant = new_merchant
	if(current_merchant)
		var/datum/trader/T = get_merchant(current_merchant)
		if(!hailed_merchant)
			if(href_list["PRG_hail"])
				. = TOPIC_HANDLED
				hailed_merchant = get_response(T.hail(user))
				show_trades = FALSE
			. = TOPIC_HANDLED
		else
			if(href_list["PRG_show_trades"])
				. = TOPIC_HANDLED
				show_trades = !show_trades
			if(href_list["PRG_insult"])
				. = TOPIC_HANDLED
				get_response(T.insult())
			if(href_list["PRG_compliment"])
				. = TOPIC_HANDLED
				get_response(T.compliment())
			if(href_list["PRG_offer_item"])
				. = TOPIC_HANDLED
				offer_item(T,text2num(href_list["PRG_offer_item"]) + 1, user.get_skill_value(SKILL_FINANCE))
			if(href_list["PRG_offer_item_for_bulk"])
				. = TOPIC_HANDLED
				offer_item_bulk(T,text2num(href_list["PRG_offer_item_for_bulk"]) + 1, user.get_skill_value(SKILL_FINANCE))
			if(href_list["PRG_how_much_do_you_want"])
				. = TOPIC_HANDLED
				get_response(T.how_much_do_you_want(text2num(href_list["PRG_how_much_do_you_want"]) + 1, user.get_skill_value(SKILL_FINANCE)))
			if(href_list["PRG_offer_money_for_item"])
				. = TOPIC_HANDLED
				offer_money(T, text2num(href_list["PRG_offer_money_for_item"])+1, user.get_skill_value(SKILL_FINANCE))
			if(href_list["PRG_offer_money_for_bulk"])
				. = TOPIC_HANDLED
				offer_bulk(T, text2num(href_list["PRG_offer_money_for_bulk"])+1, user.get_skill_value(SKILL_FINANCE))
			if(href_list["PRG_what_do_you_want"])
				. = TOPIC_HANDLED
				get_response(T.what_do_you_want())
			if(href_list["PRG_sell_items"])
				. = TOPIC_HANDLED
				sell_items(T, user.get_skill_value(SKILL_FINANCE))
			if(href_list["PRG_bribe"])
				. = TOPIC_HANDLED
				bribe(T, text2num(href_list["PRG_bribe"]))
