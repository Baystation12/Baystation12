
/datum/nano_module/program/faction_supply/Topic(href, href_list)
	var/mob/user = usr
	if(..())
		return 1

	if(href_list["select_category"])
		selected_category = href_list["select_category"]
		return 1

	if(href_list["set_screen"])
		screen = text2num(href_list["set_screen"])
		return 1

	if(href_list["login"])
		var/obj/item/modular_computer/MC = nano_host()
		if(check_access(user, req_access))
			screen = SCREEN_BROWSE
			MC.visible_message("<span class='notice'>[src] flashes a message: Access Granted. Welcome, [user.name]</span>")
		else
			MC.visible_message("<span class='warning'>[src] flashes a warning: Access Denied.</span>")

	if(href_list["order"])
		var/decl/hierarchy/supply_pack/P = locate(href_list["order"]) in supply_controller.master_supply_list
		if(!istype(P) || P.is_category())
			return 1

		if(P.hidden && !emagged)
			return 1

		var/reason = sanitize(input(user,"Reason:","Why do you require this item?","") as null|text,,0)
		if(!reason)
			return 1

		var/idname = "*None Provided*"
		var/idrank = "*None Provided*"
		var/mob/living/carbon/human/H = user
		idname = H.get_authentification_name()
		idrank = H.get_assignment()

		supply_controller.ordernum++

		var/datum/supply_order/O = new /datum/supply_order()
		O.ordernum = supply_controller.ordernum
		O.object = P
		O.orderedby = idname
		O.reason = reason
		O.orderedrank = idrank
		O.comment = "#[O.ordernum]"
		my_shuttle.requestlist += O

		if(can_print() && alert(user, "Would you like to print a confirmation receipt?", "Print receipt?", "Yes", "No") == "Yes")
			print_order(O, user)
		return 1

	if(href_list["print_summary"])
		if(!can_print())
			return
		print_summary(user)

	if(href_list["launch_shuttle"])
		if(my_shuttle.at_station())
			if (my_shuttle.forbidden_atoms_check())
				to_chat(usr, "<span class='warning'>For safety reasons the automated supply shuttle cannot transport [my_shuttle.forbidden_atoms_string()].</span>")
			else
				my_shuttle.launch(user)

		else
			my_shuttle.launch(user)
			/*
			var/datum/radio_frequency/frequency = radio_controller.return_frequency(1435)
			if(!frequency)
				return

			var/datum/signal/status_signal = new
			status_signal.source = src
			status_signal.transmission_method = 1
			status_signal.data["command"] = "supply"
			frequency.post_signal(src, status_signal)
			*/

			my_shuttle.shuttle_buy()

		return 1

	if(href_list["approve_order"])
		var/id = text2num(href_list["approve_order"])
		for(var/datum/supply_order/SO in my_shuttle.requestlist)
			if(SO.ordernum != id)
				continue
			if(SO.object.cost * CARGO_CRATE_COST_MULTI > my_shuttle.money_account.money)
				to_chat(usr, "<span class='warning'>Not enough credits to purchase \the [SO.object.name]!</span>")
				return 1
			my_shuttle.requestlist -= SO
			my_shuttle.shoppinglist += SO
			my_shuttle.money_account.money -= SO.object.cost * CARGO_CRATE_COST_MULTI
			break
		return 1

	if(href_list["deny_order"])
		var/id = text2num(href_list["deny_order"])
		for(var/datum/supply_order/SO in my_shuttle.requestlist)
			if(SO.ordernum == id)
				my_shuttle.requestlist -= SO
				break
		return 1

	if(href_list["withdraw_credits"])
		if(program && program.computer)
			var/amount = input("How much do you want to withdraw?","Make withdrawal",0) as num
			if(amount > 0)
				amount = min(amount, my_shuttle.money_account.money)
				my_shuttle.money_account.money -= amount
				spawn_money(amount, program.computer.loc, user)
				playsound(program.computer, 'sound/machines/chime.ogg', 50, 1)
				program.computer.visible_message("\icon[program.computer] [user] withdraws a [amount >= 10000 ? "thick " : ""]wad of cash from [program.computer].")
		else
			to_chat(user,"<span class='warning'>You cannot do that right now.</span>")

	if(href_list["deposit_credits"])
		if(program && program.computer)
			var/obj/item/weapon/spacecash/S = user.get_active_hand()
			if(istype(S))
				user.drop_item(S)
				S.loc = program.computer
				my_shuttle.money_account.money += S.worth
				program.computer.visible_message("\icon[program.computer] [user] deposits a [S.worth >= 10000 ? "thick " : ""]wad of cash into [program.computer].")
				qdel(S)
		else
			to_chat(user,"<span class='warning'>You cannot do that right now.</span>")

	if(href_list["cancel_order"])
		var/id = text2num(href_list["cancel_order"])
		for(var/datum/supply_order/SO in my_shuttle.shoppinglist)
			if(SO.ordernum == id)
				my_shuttle.shoppinglist -= SO
				my_shuttle.money_account.money += SO.object.cost * CARGO_CRATE_COST_MULTI
				break
		return 1
