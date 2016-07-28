/datum/computer_file/program/merchant
	filename = "mlist"
	filedesc = "Merchant's List"
	extended_desc = "Allows communication and trade between passing vessels, even while jumping."
	program_icon_state = "comm"
	nanomodule_path = /datum/nano_module/program/merchant
	requires_ntnet = 1
	available_on_ntnet = 1
	size = 12
	usage_flags = PROGRAM_CONSOLE
	required_access = access_merchant
	var/obj/machinery/merchant_pad/pad = null
	var/current_merchant = 0
	var/show_trades = 0
	var/hailed_merchant = 0
	var/last_comms = null
	var/temp = null

/datum/nano_module/program/merchant
	name = "Merchant's List"
	available_to_ai = 1


/datum/computer_file/program/merchant/proc/get_merchant(var/num)
	if(num > traders.len)
		num = traders.len
	if(num)
		return traders[num]

/datum/nano_module/program/merchant/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
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
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
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
		return 1
	return 0

/datum/computer_file/program/merchant/proc/offer_item(var/datum/trader/T, var/num)
	if(pad)
		var/list/targets = pad.get_targets()
		for(var/target in targets)
			if(!computer_emagged && istype(target,/mob/living/carbon/human))
				last_comms = "SAFETY LOCK ENABLED: SENTIENT MATTER UNTRANSMITTABLE"
				return
		var/response = T.offer_items_for_trade(targets,num)
		if(istext(response))
			last_comms = T.get_response(response,"No, a million times no.")
		else
			last_comms = T.get_response("trade_complete","Thanks for your business!")

		return
	last_comms = "PAD NOT CONNECTED"

/datum/computer_file/program/merchant/Topic(href, href_list)
	if(..())
		return 1
	var/mob/user = usr
	if(href_list["PRG_connect_pad"])
		. = 1
		connect_pad()
	if(href_list["PRG_continue"])
		. = 1
		temp = null
	if(href_list["PRG_main_menu"])
		. = 1
		current_merchant = 0
	if(href_list["PRG_merchant_list"])
		if(traders.len == 0)
			. = 0
			temp = "Cannot find any traders within broadcasting range."
		else
			. = 1
			current_merchant = 1
			hailed_merchant = 0
			last_comms = null
	if(href_list["PRG_test_fire"])
		. = 1
		if(test_fire())
			temp = "Test Fire Successful"
		else
			temp = "Test Fire Unsuccessful"
	if(href_list["PRG_scroll"])
		. = 1
		var/scrolled = 0
		switch(href_list["PRG_scroll"])
			if("right")
				scrolled = 1
			if("left")
				scrolled = -1
		var/new_merchant  = Clamp(current_merchant + scrolled, 1, traders.len)
		if(new_merchant != current_merchant)
			hailed_merchant = 0
			last_comms = null
		current_merchant = new_merchant
	if(current_merchant)
		var/datum/trader/T = get_merchant(current_merchant)
		if(!T.can_hail())
			last_comms = T.get_response("hail_deny", "No, I'm not speaking with you.")
			. = 1
		else
			if(href_list["PRG_hail"])
				. = 1
				last_comms = T.hail(user)
				show_trades = 0
				hailed_merchant = 1
			if(href_list["PRG_show_trades"])
				. = 1
				show_trades = !show_trades
			if(href_list["PRG_insult"])
				. = 1
				last_comms = T.insult()
			if(href_list["PRG_compliment"])
				. = 1
				last_comms = T.compliment()
			if(href_list["PRG_offer_item"])
				. = 1
				offer_item(T,text2num(href_list["PRG_offer_item"]) + 1)
			if(href_list["PRG_how_much_do_you_want"])
				. = 1
				last_comms = T.how_much_do_you_want(text2num(href_list["PRG_how_much_do_you_want"]) + 1)