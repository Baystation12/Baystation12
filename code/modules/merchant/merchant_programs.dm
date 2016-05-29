/datum/computer_file/program/merchant
	filename = "mlist"
	filedesc = "Merchant's List"
	extended_desc = "Allows communication and trade between passing vessels, even while jumping."
	program_icon_state = "comm"
	nanomodule_path = /datum/nano_module/program/merchant
	requires_ntnet = 0
	available_on_ntnet = 1
	size = 12
	usage_flags = PROGRAM_CONSOLE
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
			for(var/i in 1 to T.trade_proposals.len)
				trades += T.print_trade(i)
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

/datum/computer_file/program/merchant/proc/accept_trade(var/trade_num)
	if(pad)
		var/datum/trader/T = get_merchant(current_merchant)
		if(T)
			var/type = T.trade_proposals[trade_num]
			var/atom/movable/M = locate(type) in get_turf(pad)
			if(M)
				T.trade(M)

/datum/computer_file/program/merchant/proc/test_fire()
	if(pad)
		var/turf/T = get_turf(pad)
		for(var/atom/movable/M in T)
			if(M == pad || (!istype(M,/obj) && !istype(M,/mob)))
				continue
			return 1
	return 0

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
		current_merchant = Clamp(current_merchant + scrolled, 1, traders.len)
		hailed_merchant = 0
	if(current_merchant)
		var/datum/trader/T = get_merchant(current_merchant)
		if(href_list["PRG_hail"])
			. = 1
			last_comms = T.hail(user)
			show_trades = 0
			hailed_merchant = 1
		if(href_list["PRG_insult"])
			. = 1
			last_comms = T.insult()
		if(href_list["complement"])
			. = 1
			last_comms = T.complement()
		if(href_list["PRG_what_do_you_want"])
			. = 1
			last_comms = T.what_do_you_want()
		if(href_list["PRG_accept_trade"])
			. = 1
			accept_trade(text2num(href_list["PRG_accept_trade"]))
	if(.)
		nanomanager.update_uis(NM)