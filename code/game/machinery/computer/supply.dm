////////////////////////////////////////////////////////////////////////
//
//SUPPLY COMPUTER
//
////////////////////////////////////////////////////////////////////////
/obj/machinery/computer/supply
	name = "cargo supply console"
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "tech_key"
	icon_screen = "request"
	light_color = "#b88b2e"
	req_access = list(access_cargo)
	circuit = /obj/item/weapon/circuitboard/supplycomp
	var/can_order_contraband = 0
	var/activeterminal = 0

	var/lastprint = 0
	var/printdelay = 100 // 10 second delay between prints

	var/lastorder = 0
	var/orderdelay = 100 // 5 second delay between orders.


	var/list/supplylist

/obj/machinery/computer/supply/initialize()
	..()
	generateSupplyList()


/obj/machinery/computer/supply/proc/generateSupplyList()

	supplylist = list()

	for(var/decl/hierarchy/supply_pack/sp in cargo_supply_pack_root.children)
		if(sp.is_category())
			supplylist[sp.name] = list(
				"name" = sp.name,
				"pack" = list()
				)
			for(var/decl/hierarchy/supply_pack/spc in sp.children)
				if(spc.hidden && !emagged || spc.contraband && !can_order_contraband)
					continue
				supplylist[sp.name]["pack"] += list(list(
					"name" = spc.name,
					"cost" = spc.cost,
					"id" = "\ref[spc]"
					))

/obj/machinery/computer/supply/proc/isActiveTerminal()
	if(supply_controller.primaryterminal == src)
		return TRUE
	return FALSE

/obj/machinery/computer/supply/proc/servicesActive()
	if(supply_controller.primaryterminal)
		return TRUE
	return FALSE

/obj/machinery/computer/supply/proc/login()
	if(supply_controller.primaryterminal)
		supply_controller.primaryterminal.logout()
	supply_controller.primaryterminal = src
	activeterminal = TRUE
	icon_screen = "supply"
	update_icon()

/obj/machinery/computer/supply/proc/logout()
	activeterminal = FALSE
	supply_controller.primaryterminal = null
	icon_screen = "request"
	update_icon()

/obj/machinery/computer/supply/attack_ai(var/mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/supply/attack_hand(var/mob/user as mob)
	tg_ui_interact(user)

/obj/machinery/computer/supply/ui_data(mob/user)
	var/list/data = list()
	var/datum/shuttle/ferry/supply/shuttle = supply_controller.shuttle
	var/shuttlestatus = ""
	var/canlaunch = 0

	if (shuttle.has_arrive_time())
		shuttlestatus = "In transit ([shuttle.eta_minutes()] Mins.)"
	else
		if (shuttle.at_station())
			if (shuttle.docking_controller)
				switch(shuttle.docking_controller.get_docking_status())
					if ("docked")
						shuttlestatus = "Docked"
					if ("undocked") shuttlestatus = "Undocked"
					if ("docking") shuttlestatus = "Docking"
					if ("undocking") shuttlestatus = "Undocking"
		else
			shuttlestatus = "Docked at remote location"


	if(activeterminal)
		data["cart"] = list()
		for(var/datum/supply_order/SO in supply_controller.shoppinglist)
			data["cart"] += list(list(
				"id" = SO.ordernum,
				"object" = SO.object.name,
				"orderer" = SO.orderedby,
				"cost" = SO.object.cost,
				"reason" = SO.reason
				))

	data["requests"] = list()
	for(var/datum/supply_order/SO in supply_controller.requestlist)
		data["requests"] += list(list(
			"id" = SO.ordernum,
			"object" = SO.object.name,
			"orderer" = SO.orderedby,
			"cost" = SO.object.cost,
			"reason" = SO.reason
			))

	if(shuttle.can_launch())
		canlaunch = 1
	data["location"] = shuttlestatus
	data["canlaunch"] = canlaunch
	data["points"] = supply_controller.points
	data["pointstotalsum"] = supply_controller.point_sources["total"]
	data["supplies"] = supplylist
	data["active"] = isActiveTerminal() //merchant terminal
	data["canorder"] = servicesActive()
	return data


/obj/machinery/computer/supply/tg_ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, datum/tgui/master_ui = null, datum/ui_state/state = default_state)
	ui = tgui_process.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "cargo", name , 1000, 800, master_ui, state)
		ui.open()



/obj/machinery/computer/supply/ui_act(action,params)
	if(..())
		return

	var/datum/shuttle/ferry/supply/shuttle = supply_controller.shuttle


	switch(action)
		if("send")
			if(shuttle.at_station())
				if (shuttle.forbidden_atoms_check())
					to_chat(usr, "<span class='warning'>For safety reasons the automated supply shuttle cannot transport live organisms, classified nuclear weaponry or homing beacons.</span>")
				else
					shuttle.launch(src)
			else
				shuttle.launch(src)
				post_signal("supply")
		if("add")
			if(lastorder > world.time) return TRUE
			lastorder = world.time + orderdelay
			var/notenoughpoints = 0
			var/decl/hierarchy/supply_pack/P = locate(params["id"]) in supply_controller.master_supply_list
			if(!istype(P) || P.is_category())	return TRUE

			if(P.hidden && !emagged) return TRUE

			if(P.cost > supply_controller.points && activeterminal)
				to_chat(usr, "<span class='notice'>Not enough points to add to cart. Adding to request list.</span>")
				notenoughpoints = 1

			var/timeout = world.time + 1 MINUTE
			var/reason = sanitize(input(usr,"Reason:","Why do you require this item?","") as null|text,,0)
			if(world.time > timeout)	return TRUE
			if(!reason)	return TRUE

			var/idname = "*None Provided*"
			var/idrank = "*None Provided*"
			if(ishuman(usr))
				var/mob/living/carbon/human/H = usr
				idname = H.get_authentification_name()
				idrank = H.get_assignment()
			else if(issilicon(usr))
				idname = usr.real_name

			supply_controller.ordernum++

			//make our supply_order datum
			var/datum/supply_order/O = new /datum/supply_order()
			O.ordernum = supply_controller.ordernum
			O.object = P
			O.orderedby = idname
			O.reason = reason
			O.orderedrank = idrank
			O.comment = "#[O.ordernum]" // crates will be labeled with this.

			//We're going to print the main supply request.
			if(supply_controller.primaryterminal)
				printOrder(O,0,supply_controller.primaryterminal) // print hard copy at terminal
			else
				printOrder(O,0,src) // print hard copy at station due to no defined primary terminal yet.


			//request consoles can only add to the request list
			if(!activeterminal || notenoughpoints)
				supply_controller.requestlist += O
			else
				supply_controller.shoppinglist += O
				supply_controller.points -= P.cost // purchase immediately

			. = TRUE

		if("remove")
			var/id = text2num(params["id"])
			for(var/datum/supply_order/SO in supply_controller.shoppinglist)
				if(SO.ordernum == id)
					supply_controller.points += SO.object.cost //refund
					supply_controller.shoppinglist -= SO
					supply_controller.requestlist += SO
					. = TRUE
					break

		if("clear")
			switch(alert("Are you sure you want to clear the shopping cart?",, "Yes", "No"))
				if("Yes")
					for(var/datum/supply_order/SO in supply_controller.shoppinglist)
						supply_controller.points += SO.object.cost //refund all
						supply_controller.shoppinglist -= SO
						supply_controller.requestlist += SO
			. = TRUE

		if("approve")
			var/id = text2num(params["id"])
			for(var/datum/supply_order/SO in supply_controller.requestlist)
				if(SO.ordernum == id)
					if(SO.object.cost > supply_controller.points)
						to_chat(usr, "<span class='warning'>Not enough points to purchase \the [SO.object.name]!</span>")
						return TRUE
					supply_controller.requestlist -= SO
					supply_controller.shoppinglist += SO
					supply_controller.points -= SO.object.cost // purchase
					. = TRUE
					break

		if("deny")
			switch(alert("Are you sure you want to deny the entry? this will permanently delete the request",, "Yes", "No"))
				if("Yes")
					var/id = text2num(params["id"])
					for(var/datum/supply_order/SO in supply_controller.requestlist)
						if(SO.ordernum == id)
							supply_controller.requestlist -= SO
							. = TRUE
							break

		if("denyall")
			switch(alert("Are you sure you want to deny the entry? this will permanently delete ALL requests",, "Yes", "No"))
				if("Yes")
					switch(alert("Final warning: Selecting continue will delete all request entries not currently in the cart.",, "Continue", "Stop"))
						if("Continue")
							supply_controller.requestlist.Cut()
			. = TRUE

		if("edit")
			var/id = text2num(params["id"])
			for(var/datum/supply_order/SO in supply_controller.shoppinglist)
				if(SO.ordernum == id)
					var/comment = sanitize(input(usr,"Comment: ","How do you want the delivery to be labeled?", SO.comment) as null|text,,0)
					if(comment)
						SO.comment = comment
					break
			. = TRUE

		if("print")
			if(lastprint < world.time)
				var/id = text2num(params["id"])
				for(var/datum/supply_order/SO in supply_controller.requestlist)
					if(SO.ordernum == id)
						printOrder(SO, 1, src)
						lastprint = world.time + printdelay
						break
			. = TRUE
		if("printtotal")
			if(lastprint < world.time)
				var/obj/item/weapon/paper/overview
				overview = new /obj/item/weapon/paper(src.loc)
				overview.name = "Export overview"
				var/info = list()
				info += "<center><BR><b><large>[using_map.station_name]</large></b><BR><i>[station_date]</i><BR><i>Export overview<field></i></center><hr>"
				for(var/source in point_source_descriptions)
					info += "[point_source_descriptions[source]]: [supply_controller.point_sources[source] || 0]<br/>"
				overview.info = jointext(info, null)

				overview.update_icon()	//Fix for appearing blank when printed.
				playsound(usr.loc,'sound/machines/dotprinter.ogg', 40, 1)
				return 1
				. = TRUE
		if("login") //sign in as merchant
			if(!src.allowed(usr))
				return TRUE
			login()
			. = TRUE

		if("logout")
			logout()
			. = TRUE

	return TRUE

/obj/machinery/computer/supply/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		to_chat(user, "<span class='notice'>Special supplies unlocked.</span>")
		emagged = 1 // why this wasn't set before is beyond me
		generateSupplyList()
		return 1

/obj/machinery/computer/supply/proc/printOrder(var/datum/supply_order/O, var/isreciept = 0, var/atom/printloc = src)
	if(O)
		var/obj/item/weapon/paper/reqform
		if(printloc)
			reqform = new /obj/item/weapon/paper(printloc.loc)
		else
			reqform = new /obj/item/weapon/paper(src.loc)

		if(isreciept)
			reqform.name = "Cargo Reciept - [O.object.name]"
			reqform.info += "<h3>[using_map.station_name] Supply Requisition Reciept</h3><hr>"
		else
			reqform.name = "Requisition Form - [O.object.name]"
			reqform.info += "<h3>[using_map.station_name] Supply Requisition Form</h3><hr>"

		reqform.info += "INDEX: #[O.ordernum]<br>"
		reqform.info += "REQUESTED BY: [O.orderedby]<br>"
		reqform.info += "RANK: [O.orderedrank]<br>"
		reqform.info += "REASON: [O.reason]<br>"
		reqform.info += "SUPPLY CRATE TYPE: [O.object.name]<br>"
		reqform.info += "ACCESS RESTRICTION: [get_access_desc(O.object.access)]<br>"
		reqform.info += "CONTENTS:<br>"
		reqform.info += O.object.manifest
		reqform.info += "<hr>"
		if(!isreciept)
			reqform.info += "STAMP BELOW IF REQUISITION APPROVED:<br>"

		reqform.update_icon()	//Fix for appearing blank when printed.
		playsound(printloc,'sound/machines/dotprinter.ogg', 40, 1)

/obj/machinery/computer/supply/proc/post_signal(var/command)

	var/datum/radio_frequency/frequency = radio_controller.return_frequency(1435)

	if(!frequency) return

	var/datum/signal/status_signal = new
	status_signal.source = src
	status_signal.transmission_method = 1
	status_signal.data["command"] = command

	frequency.post_signal(src, status_signal)
