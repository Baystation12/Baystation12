/obj/machinery/cash_register
	name = "cash register"
	desc = "Swipe your ID card to make purchases electronically."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "register_idle"
	flags = NOBLUDGEON
	req_access = list(access_heads)
	anchored = 1

	var/locked = 1
	var/cash_locked = 1
	var/cash_open = 0
	var/machine_id = ""
	var/transaction_amount = 0 // cumulatd amount of money to pay in a single purchase
	var/transaction_purpose = null // text that gets used in ATM transaction logs
	var/list/transaction_logs = list() // list of strings using html code to visualise data
	var/list/item_list = list()  // entities and according
	var/list/price_list = list() // prices for each purchase
	var/manipulating = 0

	var/cash_stored = 0
	var/obj/item/confirm_item
	var/datum/money_account/linked_account


// Claim machine ID
/obj/machinery/cash_register/New()
	machine_id = "[station_name()] RETAIL #[num_financial_terminals++]"
	cash_stored = rand(10, 70)*10


/obj/machinery/cash_register/examine(mob/user as mob)
	..(user)
	if(cash_open)
		if(cash_stored)
			user << "It holds [cash_stored] Thaler\s of money."
		else
			user << "It's completely empty."


/obj/machinery/cash_register/attack_hand(mob/user as mob)
	if(cash_open)
		if(cash_stored)
			spawn_money(cash_stored, loc, user)
			cash_stored = 0
			overlays -= "register_cash"
		else
			open_cash_box()
	// Reset if necessary
	else if(transaction_amount)
		reset_memory()
		user << "<span class='notice'>You reset the machine's memory.</span>"
	else
		custom_interface(user)


/obj/machinery/cash_register/AltClick(mob/user)
	if(Adjacent(user))
		open_cash_box()


/obj/machinery/cash_register/proc/custom_interface(mob/user as mob)
	var/dat = "<h2>Retail Scanner<hr></h2>"
	if (locked)
		dat += "<a href='?src=\ref[src];choice=toggle_lock'>Unlock</a><br>"
		dat += "Linked account: <b>[linked_account ? linked_account.owner_name : "None"]</b><br>"
		dat += "<b>[cash_locked? "Unlock" : "Lock"] Cash Box</b> | "
	else
		dat += "<a href='?src=\ref[src];choice=toggle_lock'>Lock</a><br>"
		dat += "Linked account: <a href='?src=\ref[src];choice=link_account'>[linked_account ? linked_account.owner_name : "None"]</a><br>"
		dat += "<a href='?src=\ref[src];choice=toggle_cash_lock'>[cash_locked? "Unlock" : "Lock"] Cash Box</a> | "
	dat += "<a href='?src=\ref[src];choice=custom_order'>Custom Order</a><hr>"
	for(var/i=1, i<=transaction_logs.len, i++)
		dat += "[transaction_logs[i]]<br>"

	if(transaction_logs.len)
		dat += locked ? "<br>" : "<a href='?src=\ref[src];choice=reset_log'>Reset Log</a><br>"
		dat += "<br>"
	dat += "<i>Device ID:</i> [machine_id]"
	user << browse(dat, "window=retail;size=350x500")


/obj/machinery/cash_register/Topic(var/href, var/href_list)
	if(href_list["choice"])
		switch(href_list["choice"])
			if("toggle_lock")
				if(allowed(usr))
					locked = !locked
				else
					usr << "\icon[src]<span class='warning'>Insufficient access.</span>"
			if("toggle_cash_lock")
				cash_locked = !cash_locked
			if("link_account")
				var/attempt_account_num = input("Enter account number", "New account number") as num
				var/attempt_pin = input("Enter PIN", "Account PIN") as num
				linked_account = attempt_account_access(attempt_account_num, attempt_pin, 1)
				if(linked_account)
					if(linked_account.suspended)
						linked_account = null
						src.visible_message("\icon[src]<span class='warning'>Account has been suspended.</span>")
				else
					usr << "\icon[src]<span class='warning'>Account not found.</span>"
			if("custom_order")
				var/t_purpose = sanitize(input("Enter purpose", "New purpose") as text)
				if (!t_purpose || !Adjacent(usr)) return
				transaction_purpose = t_purpose
				item_list += t_purpose
				var/t_amount = input("Enter price", "New price") as num
				if (!t_amount || !Adjacent(usr)) return
				transaction_amount += t_amount
				price_list += t_amount
				playsound(src, 'sound/machines/twobeep.ogg', 25)
				src.visible_message("\icon[src][transaction_purpose]: [transaction_amount] Thaler\s.")
			if("reset_log")
				transaction_logs.Cut()
				usr << "\icon[src]<span class='notice'>Transaction log reset.</span>"
	custom_interface(usr)



/obj/machinery/cash_register/attackby(obj/O as obj, user as mob)
	// Check for a method of paying (ID, PDA, e-wallet, cash, ect.)
	var/obj/item/weapon/card/id/I = O.GetIdCard()
	if(I)
		scan_card(I, O)
	else if (istype(O, /obj/item/weapon/spacecash/ewallet))
		var/obj/item/weapon/spacecash/ewallet/E = O
		scan_wallet(E)
	else if (istype(O, /obj/item/weapon/spacecash))
		var/obj/item/weapon/spacecash/SC = O
		if(cash_open)
			user << "You neatly sort the cash into the box."
			cash_stored += SC.worth
			overlays |= "register_cash"
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				H.drop_from_inventory(SC)
			qdel(SC)
		else
			scan_cash(SC)
	else if(istype(O, /obj/item/weapon/card/emag))
		return ..()
	else if(istype(O, /obj/item/weapon/wrench))
		var/obj/item/weapon/wrench/W = O
		toggle_anchors(W, user)
	// Not paying: Look up price and add it to transaction_amount
	else
		scan_item_price(O)


/obj/machinery/cash_register/MouseDrop_T(atom/dropping, mob/user)
	if(Adjacent(dropping) && Adjacent(user) && !user.stat)
		attackby(dropping, user)


/obj/machinery/cash_register/proc/confirm(obj/item/I)
	if(confirm_item == I)
		return 1
	else
		confirm_item = I
		src.visible_message("\icon[src]<b>Total price:</b> [transaction_amount] Thaler\s. Swipe again to confirm.")
		playsound(src, 'sound/machines/twobeep.ogg', 25)
		return 0


/obj/machinery/cash_register/proc/scan_card(obj/item/weapon/card/id/I, obj/item/ID_container)
	if (!transaction_amount)
		return

	if(!confirm(I))
		return

	if (!linked_account)
		usr.visible_message("\icon[src]<span class='warning'>Unable to connect to linked account.</span>")
		return

	if (cash_open)
		playsound(src, 'sound/machines/buzz-sigh.ogg', 25)
		usr << "\icon[src]<span class='warning'>The cash box is open.</span>"
		return

	// Access account for transaction
	if(check_account())
		var/datum/money_account/D = get_account(I.associated_account_number)
		var/attempt_pin = ""
		if(D && D.security_level)
			attempt_pin = input("Enter PIN", "Transaction") as num
			D = null
		D = attempt_account_access(I.associated_account_number, attempt_pin, 2)

		if(!D)
			src.visible_message("\icon[src]<span class='warning'>Unable to access account. Check security settings and try again.</span>")
		else
			if(D.suspended)
				src.visible_message("\icon[src]<span class='warning'>Your account has been suspended.</span>")
			else
				if(transaction_amount > D.money)
					src.visible_message("\icon[src]<span class='warning'>Not enough funds.</span>")
				else
					// Transfer the money
					D.money -= transaction_amount
					linked_account.money += transaction_amount

					// Create log entry in client's account
					var/datum/transaction/T = new()
					T.target_name = "[linked_account.owner_name]"
					T.purpose = transaction_purpose
					T.amount = "([transaction_amount])"
					T.source_terminal = machine_id
					T.date = current_date_string
					T.time = stationtime2text()
					D.transaction_log.Add(T)

					// Create log entry in owner's account
					T = new()
					T.target_name = D.owner_name
					T.purpose = transaction_purpose
					T.amount = "[transaction_amount]"
					T.source_terminal = machine_id
					T.date = current_date_string
					T.time = stationtime2text()
					linked_account.transaction_log.Add(T)

					// Save log
					add_transaction_log(I.registered_name ? I.registered_name : "n/A", "ID Card", transaction_amount)

					// Confirm and reset
					transaction_complete()


/obj/machinery/cash_register/proc/scan_wallet(obj/item/weapon/spacecash/ewallet/E)
	if (!transaction_amount)
		return

	if(!confirm(E))
		return

	if (cash_open)
		playsound(src, 'sound/machines/buzz-sigh.ogg', 25)
		usr << "\icon[src]<span class='warning'>The cash box is open.</span>"
		return

	// Access account for transaction
	if(check_account())
		if(transaction_amount > E.worth)
			src.visible_message("\icon[src]<span class='warning'>Not enough funds.</span>")
		else
			// Transfer the money
			E.worth -= transaction_amount
			linked_account.money += transaction_amount

			// Create log entry in owner's account
			var/datum/transaction/T = new()
			T.target_name = E.owner_name
			T.purpose = transaction_purpose
			T.amount = "[transaction_amount]"
			T.source_terminal = machine_id
			T.date = current_date_string
			T.time = stationtime2text()
			linked_account.transaction_log.Add(T)

			// Save log
			add_transaction_log(E.owner_name, "E-Wallet", transaction_amount)

			// Confirm and reset
			transaction_complete()


/obj/machinery/cash_register/proc/scan_cash(obj/item/weapon/spacecash/SC)
	if (!transaction_amount)
		return

	if(!confirm(SC))
		return

	if (cash_open)
		playsound(src, 'sound/machines/buzz-sigh.ogg', 25)
		usr << "\icon[src]<span class='warning'>The cash box is open.</span>"
		return

	// Access account for transaction
	if(check_account())
		if(transaction_amount > SC.worth)
			src.visible_message("\icon[src]<span class='warning'>Not enough money.</span>")
		else
			// Insert cash into magical slot
			SC.worth -= transaction_amount
			SC.update_icon()
			if(!SC.worth)
				if(ishuman(SC.loc))
					var/mob/living/carbon/human/H = SC.loc
					H.drop_from_inventory(SC)
				qdel(SC)
			cash_stored += transaction_amount

			// Save log
			add_transaction_log("n/A", "Cash", transaction_amount)

			// Confirm and reset
			transaction_complete()


/obj/machinery/cash_register/proc/scan_item_price(obj/O)
	if(!istype(O))	return
	if (cash_open)
		playsound(src, 'sound/machines/buzz-sigh.ogg', 25)
		usr << "\icon[src]<span class='warning'>The cash box is open.</span>"
		return

	// First check if item has a valid price
	var/price = O.get_item_cost()
	if(isnull(price))
		src.visible_message("\icon[src]<span class='warning'>Unable to find item in database.</span>")
		return
	// Call out item cost
	src.visible_message("\icon[src]\A [O]: [price ? "[price] Thaler\s" : "free of charge"].")
	// Note the transaction purpose for later use
	if(transaction_purpose)
		transaction_purpose += "<br>"
	transaction_purpose += "[O]: [price] Thaler\s"
	transaction_amount += price
	item_list += "[O]"
	price_list += "[price] &thorn"
	// Animation and sound
	playsound(src, 'sound/machines/twobeep.ogg', 25)
	// Reset confirmation
	confirm_item = null


/obj/machinery/cash_register/proc/add_transaction_log(var/c_name, var/p_method, var/t_amount)
	var/dat = {"
	<head><style>
		.tx-table {border: 1px solid black;}
		.tx-title {text-align: center; background-color:#ddddff; font-weight: bold}
		.tx-name {background-color: #bbbbee}
		.tx-data {text-align: right; background-color: #ccccff;}
	</head></style>
	<table width=300>
	<tr><td colspan="2" class="tx-title">Transaction #[transaction_logs.len+1]</td></tr>
	<tr></tr>
	<tr><td class="tx-name">Customer</td><td class="tx-data">[c_name]</td></tr>
	<tr><td class="tx-name">Pay Method</td><td class="tx-data">[p_method]</td></tr>
	<tr><td class="tx-name">Station Time</td><td class="tx-data">[stationtime2text()]</td></tr>
	</table>
	<table width=300>
	"}
	for(var/i=1, i<=item_list.len, i++)
		dat += "<tr><td class=\"tx-name\">[item_list[i]]</td><td class=\"tx-data\" width=50>[price_list[i]]</td></tr>"
	dat += "<tr></tr><tr><td colspan=\"2\" class=\"tx-name\" style='text-align: right'><b>Total Amount: [transaction_amount] &thorn</b></td></tr>"
	dat += "</table>"

	transaction_logs += dat


/obj/machinery/cash_register/proc/check_account()
	if (!linked_account)
		usr.visible_message("\icon[src]<span class='warning'>Unable to connect to linked account.</span>")
		return 0

	if(linked_account.suspended)
		src.visible_message("\icon[src]<span class='warning'>Connected account has been suspended.</span>")
		return 0
	return 1


/obj/machinery/cash_register/proc/transaction_complete()
	/// Visible confirmation
	playsound(src, 'sound/machines/chime.ogg', 25)
	src.visible_message("\icon[src]<span class='notice'>Transaction complete.</span>")
	flick("register_approve", src)
	reset_memory()

/obj/machinery/cash_register/proc/reset_memory()
	transaction_amount = null
	transaction_purpose = ""
	item_list.Cut()
	price_list.Cut()
	confirm_item = null


/obj/machinery/cash_register/verb/open_cash_box()
	set category = "Object"
	set name = "Open Cash Box"
	set desc = "Open/closes the register's cash box."
	set src in view(1)

	if(usr.stat) return

	if(cash_locked)
		usr << "<span class='warning'>The cash box is locked.</span>"
	else if(cash_open)
		cash_open = 0
		overlays -= "register_approve"
		overlays -= "register_open"
		overlays -= "register_cash"
	else
		cash_open = 1
		overlays += "register_approve"
		overlays += "register_open"
		if(cash_stored)
			overlays += "register_cash"


/obj/machinery/cash_register/proc/toggle_anchors(obj/item/weapon/wrench/W, mob/user)
	if(manipulating) return
	manipulating = 1
	if(!anchored)
		user.visible_message("\The [user] begins securing \the [src] to the floor.",
	                         "You begin securing \the [src] to the floor.")
	else
		user.visible_message("<span class='warning'>\The [user] begins unsecuring \the [src] from the floor.</span>",
	                         "You begin unsecuring \the [src] from the floor.")
	playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
	if(!do_after(user, 20))
		manipulating = 0
		return
	if(!anchored)
		user.visible_message("<span class='notice'>\The [user] has secured \the [src] to the floor.</span>",
	                         "<span class='notice'>You have secured \the [src] to the floor.</span>")
	else
		user.visible_message("<span class='warning'>\The [user] has unsecured \the [src] from the floor.</span>",
	                         "<span class='notice'>You have unsecured \the [src] from the floor.</span>")
	anchored = !anchored
	manipulating = 0
	return



/obj/machinery/cash_register/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		src.visible_message("<span class='danger'>The [src]'s cash box springs open as [user] swipes the card through the scanner!</span>")
		playsound(src, "sparks", 50, 1)
		req_access = list()
		emagged = 1
		locked = 0
		cash_locked = 0
		open_cash_box()

//--Premades--//

/obj/machinery/cash_register/command
	New()
		linked_account = department_accounts["Command"]
		..()
		/obj/machinery/cash_register/medical

	New()
		linked_account = department_accounts["Medical"]
		..()

/obj/machinery/cash_register/engineering
	New()
		linked_account = department_accounts["Engineering"]
		..()

/obj/machinery/cash_register/science
	New()
		linked_account = department_accounts["Science"]
		..()

/obj/machinery/cash_register/security
	New()
		linked_account = department_accounts["Security"]
		..()

/obj/machinery/cash_register/cargo
	New()
		linked_account = department_accounts["Cargo"]
		..()

/obj/machinery/cash_register/civilian
	New()
		linked_account = department_accounts["Civilian"]
		..()