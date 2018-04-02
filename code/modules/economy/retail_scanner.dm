/obj/item/device/retail_scanner
	name = "retail scanner"
	desc = "Swipe your ID card to make purchases electronically."
	icon = 'icons/obj/device.dmi'
	icon_state = "retail_idle"
	slot_flags = SLOT_BELT
	req_access = list(access_heads)
	origin_tech = list(TECH_MATERIAL = 1)

	var/locked = 1
	var/emagged = 0
	var/machine_id = ""
	var/transaction_amount = 0 // cumulatd amount of money to pay in a single purchase
	var/transaction_purpose = null // text that gets used in ATM transaction logs
	var/list/transaction_logs = list() // list of strings using html code to visualise data
	var/list/item_list = list()  // entities and according
	var/list/price_list = list() // prices for each purchase

	var/obj/item/confirm_item
	var/datum/money_account/linked_account
	var/account_to_connect = null


// Claim machine ID
/obj/item/device/retail_scanner/Initialize()
	..()
	machine_id = "[station_name()] RETAIL #[num_financial_terminals++]"
	if(locate(/obj/structure/table) in loc)
		pixel_y = 3


// Always face the user when put on a table
/obj/item/device/retail_scanner/afterattack(atom/movable/AM, mob/user, proximity)
	if(!proximity)	return
	if(istype(AM, /obj/structure/table))
		src.pixel_y = 3 // Shift it up slightly to look better on table
		src.dir = get_dir(src, user)
	else
		scan_item_price(AM)

// Reset dir when picked back up
/obj/item/device/retail_scanner/pickup(mob/user)
	src.dir = SOUTH
	src.pixel_y = 0


/obj/item/device/retail_scanner/attack_self(mob/user as mob)
	user.set_machine(src)
	interact(user)


/obj/item/device/retail_scanner/AltClick(var/mob/user)
	if(Adjacent(user))
		user.set_machine(src)
		interact(user)


/obj/item/device/retail_scanner/interact(mob/user as mob)
	var/list/dat = list()
	dat +="<h2>Cash Register<hr></h2>"
	if (locked)
		dat += "<a href='?src=\ref[src];choice=toggle_lock'>Unlock</a><br>"
		dat += "Linked account: <b>[linked_account ? linked_account.owner_name : "None"]</b><br>"
	else
		dat += "<a href='?src=\ref[src];choice=toggle_lock'>Lock</a><br>"
		dat += "Linked account: <a href='?src=\ref[src];choice=link_account'>[linked_account ? linked_account.owner_name : "None"]</a><br>"
	dat += "<a href='?src=\ref[src];choice=custom_order'>Custom Order</a><hr>"

	if(item_list.len)
		dat += get_current_transaction()
		dat += "<br>"

	for(var/i=transaction_logs.len, i>=1, i--)
		dat += "[transaction_logs[i]]<br>"

	if(transaction_logs.len)
		dat += locked ? "<br>" : "<a href='?src=\ref[src];choice=reset_log'>Reset Log</a><br>"
		dat += "<br>"
	dat += "<i>Device ID:</i> [machine_id]"
	show_browser(user, jointext(dat, null), "window=cash_register;size=350x500")
	onclose(user, "retail")


/obj/item/device/retail_scanner/Topic(var/href, var/href_list)
	. = ..()
	if(.)
		return

	usr.set_machine(src)
	add_fingerprint(usr)

	if(href_list["choice"])
		switch(href_list["choice"])
			if("toggle_lock")
				if(allowed(usr))
					locked = !locked
				else
					to_chat(usr, "\icon[src]<span class='warning'>Insufficient access.</span>")
			if("link_account")
				var/attempt_account_num = input("Enter account number", "New account number") as num
				var/attempt_pin = input("Enter PIN", "Account PIN") as num
				linked_account = attempt_account_access(attempt_account_num, attempt_pin, 1)
				if(linked_account)
					if(linked_account.suspended)
						linked_account = null
						src.visible_message("\icon[src]<span class='warning'>Account has been suspended.</span>")
				else
					to_chat(usr, "\icon[src]<span class='warning'>Account not found.</span>")
			if("custom_order")
				var/t_purpose = sanitize(input("Enter purpose", "New purpose") as text)
				if (!t_purpose || !Adjacent(usr)) return
				transaction_purpose = t_purpose
				item_list += t_purpose
				var/t_amount = round(input("Enter price", "New price") as num)
				if (!t_amount || !Adjacent(usr)) return
				transaction_amount += t_amount
				price_list += t_amount
				playsound(src, 'sound/machines/twobeep.ogg', 25)
				src.visible_message("\icon[src][transaction_purpose]: [t_amount] Thaler\s.")
			if("set_amount")
				var/item_name = locate(href_list["item"])
				var/n_amount = round(input("Enter amount", "New amount") as num)
				n_amount = Clamp(n_amount, 0, 20)
				if (!item_list[item_name] || !Adjacent(usr)) return
				transaction_amount += (n_amount - item_list[item_name]) * price_list[item_name]
				if(!n_amount)
					item_list -= item_name
					price_list -= item_name
				else
					item_list[item_name] = n_amount
			if("subtract")
				var/item_name = locate(href_list["item"])
				if(item_name)
					transaction_amount -= price_list[item_name]
					item_list[item_name]--
					if(item_list[item_name] <= 0)
						item_list -= item_name
						price_list -= item_name
			if("add")
				var/item_name = locate(href_list["item"])
				if(item_list[item_name] >= 20) return
				transaction_amount += price_list[item_name]
				item_list[item_name]++
			if("clear")
				var/item_name = locate(href_list["item"])
				if(item_name)
					transaction_amount -= price_list[item_name] * item_list[item_name]
					item_list -= item_name
					price_list -= item_name
				else
					transaction_amount = 0
					item_list.Cut()
					price_list.Cut()
			if("reset_log")
				transaction_logs.Cut()
				to_chat(usr, "\icon[src]<span class='notice'>Transaction log reset.</span>")
	updateDialog()



/obj/item/device/retail_scanner/attackby(var/obj/item/O, var/mob/user)
	// Check for a method of paying (ID, PDA, e-wallet, cash, ect.)
	var/obj/item/weapon/card/id/I = O.GetIdCard()
	if(I)
		scan_card(I, O)
	else if (istype(O, /obj/item/weapon/spacecash/ewallet))
		var/obj/item/weapon/spacecash/ewallet/E = O
		scan_wallet(E)
	else if (istype(O, /obj/item/weapon/spacecash))
		to_chat(user, "<span class='warning'>This device does not accept cash.</span>")

	else if(istype(O, /obj/item/weapon/card/emag))
		return . = ..()
	// Not paying: Look up price and add it to transaction_amount
	else
		scan_item_price(O)


/obj/item/device/retail_scanner/showoff(mob/user)
	for (var/mob/M in view(user))
		M.show_message("[user] holds up [src]. <a HREF=?src=\ref[M];clickitem=\ref[src]>Swipe card or item.</a>",1)


/obj/item/device/retail_scanner/proc/confirm(var/obj/item/I)
	if(confirm_item == I)
		return 1
	else
		confirm_item = I
		src.visible_message("\icon[src]<b>Total price:</b> [transaction_amount] Thaler\s. Swipe again to confirm.")
		playsound(src, 'sound/machines/twobeep.ogg', 25)
		return 0


/obj/item/device/retail_scanner/proc/scan_card(var/obj/item/weapon/card/id/I, var/obj/item/ID_container)
	if (!transaction_amount)
		return

	if((item_list.len > 1 || item_list[item_list[1]] > 1) && !confirm(I))
		return

	if (!linked_account)
		usr.visible_message("\icon[src]<span class='warning'>Unable to connect to linked account.</span>")
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
					T.date = stationdate2text()
					T.time = stationtime2text()
					D.transaction_log.Add(T)

					// Create log entry in owner's account
					T = new()
					T.target_name = D.owner_name
					T.purpose = transaction_purpose
					T.amount = "[transaction_amount]"
					T.source_terminal = machine_id
					T.date = stationdate2text()
					T.time = stationtime2text()
					linked_account.transaction_log.Add(T)

					// Save log
					add_transaction_log(I.registered_name ? I.registered_name : "n/A", "ID Card", transaction_amount)

					// Confirm and reset
					transaction_complete()


/obj/item/device/retail_scanner/proc/scan_wallet(var/obj/item/weapon/spacecash/ewallet/E)
	if (!transaction_amount)
		return

	if((item_list.len > 1 || item_list[item_list[1]] > 1) && !confirm(E))
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
			T.date = stationdate2text()
			T.time = stationtime2text()
			linked_account.transaction_log.Add(T)

			// Save log
			add_transaction_log(E.owner_name, "E-Wallet", transaction_amount)

			// Confirm and reset
			transaction_complete()


/obj/item/device/retail_scanner/proc/scan_item_price(var/obj/O)
	if(!istype(O))	return
	if(item_list.len > 10)
		src.visible_message("\icon[src]<span class='warning'>Only up to ten different items allowed per purchase.</span>")
		return

	// First check if item has a valid price
	var/price = O.get_retail_cost()
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
	for(var/previously_scanned in item_list)
		if(price == price_list[previously_scanned] && O.name == previously_scanned)
			. = item_list[previously_scanned]++
	if(!.)
		item_list[O.name] = 1
		price_list[O.name] = price
		. = 1
	// Animation and sound
	flick("retail_scan", src)
	playsound(src, 'sound/machines/twobeep.ogg', 25)
	// Reset confirmation
	confirm_item = null


/obj/item/device/retail_scanner/proc/get_current_transaction()
	var/list/dat = {"
	<head><style>
		.tx-title-r {text-align: center; background-color:#ffdddd; font-weight: bold}
		.tx-name-r {background-color: #eebbbb}
		.tx-data-r {text-align: right; background-color: #ffcccc;}
	</head></style>
	<table width=300>
	<tr><td colspan="2" class="tx-title-r">New Entry</td></tr>
	<tr></tr>"}
	var/item_name
	for(var/i=1, i<=item_list.len, i++)
		item_name = item_list[i]
		dat += "<tr><td class=\"tx-name-r\">[item_list[item_name] ? "<a href='?src=\ref[src];choice=subtract;item=\ref[item_name]'>-</a> <a href='?src=\ref[src];choice=set_amount;item=\ref[item_name]'>Set</a> <a href='?src=\ref[src];choice=add;item=\ref[item_name]'>+</a> [item_list[item_name]] x " : ""][item_name] <a href='?src=\ref[src];choice=clear;item=\ref[item_name]'>Remove</a></td><td class=\"tx-data-r\" width=50>[price_list[item_name] * item_list[item_name]] &thorn</td></tr>"
	dat += "</table><table width=300>"
	dat += "<tr><td class=\"tx-name-r\"><a href='?src=\ref[src];choice=clear'>Clear Entry</a></td><td class=\"tx-name-r\" style='text-align: right'><b>Total Amount: [transaction_amount] &thorn</b></td></tr>"
	dat += "</table></html>"
	return dat


/obj/item/device/retail_scanner/proc/add_transaction_log(var/c_name, var/p_method, var/t_amount)
	var/list/dat = {"
	<head><style>
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
	var/item_name
	for(var/i=1, i<=item_list.len, i++)
		item_name = item_list[i]
		dat += "<tr><td class=\"tx-name\">[item_list[item_name] ? "[item_list[item_name]] x " : ""][item_name]</td><td class=\"tx-data\" width=50>[price_list[item_name] * item_list[item_name]] &thorn</td></tr>"
	dat += "<tr></tr><tr><td colspan=\"2\" class=\"tx-name\" style='text-align: right'><b>Total Amount: [transaction_amount] &thorn</b></td></tr>"
	dat += "</table>"

	transaction_logs += dat


/obj/item/device/retail_scanner/proc/check_account()
	if (!linked_account)
		usr.visible_message("\icon[src]<span class='warning'>Unable to connect to linked account.</span>")
		return 0

	if(linked_account.suspended)
		src.visible_message("\icon[src]<span class='warning'>Connected account has been suspended.</span>")
		return 0
	return 1


/obj/item/device/retail_scanner/proc/transaction_complete()
	/// Visible confirmation
	playsound(src, 'sound/machines/chime.ogg', 25)
	src.visible_message("\icon[src]<span class='notice'>Transaction complete.</span>")
	flick("retail_approve", src)
	reset_memory()
	updateDialog()


/obj/item/device/retail_scanner/proc/reset_memory()
	transaction_amount = null
	transaction_purpose = ""
	item_list.Cut()
	price_list.Cut()
	confirm_item = null


/obj/item/device/retail_scanner/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		to_chat(user, "<span class='danger'>You stealthily swipe the cryptographic sequencer through \the [src].</span>")
		playsound(src, "sparks", 50, 1)
		req_access = list()
		emagged = 1

//--Premades--//

/obj/item/device/retail_scanner/command
	account_to_connect = "Command"

/obj/item/device/retail_scanner/medical
	account_to_connect = "Medical"

/obj/item/device/retail_scanner/engineering
	account_to_connect = "Engineering"

/obj/item/device/retail_scanner/science
	account_to_connect = "Science"

/obj/item/device/retail_scanner/security
	account_to_connect = "Security"

/obj/item/device/retail_scanner/cargo
	account_to_connect = "Cargo"

/obj/item/device/retail_scanner/civilian
	account_to_connect = "Civilian"
