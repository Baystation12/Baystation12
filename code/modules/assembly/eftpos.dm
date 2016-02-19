/obj/item/device/assembly/eftpos
	name = "\improper EFTPOS scanner"
	desc = "Swipe your ID card to make purchases electronically."
	icon = 'icons/obj/device.dmi'
	icon_state = "eftpos"
	var/machine_id = ""
	var/eftpos_name = "Default EFTPOS scanner"
	var/transaction_locked = 0
	var/transaction_paid = 0
	var/transaction_amount = 0
	var/transaction_purpose = "Default charge"
	var/access_code = 0
	var/datum/money_account/linked_account

	wires = WIRE_DIRECT_RECEIVE | WIRE_PROCESS_RECEIVE | WIRE_PROCESS_ACTIVATE | WIRE_PROCESS_SEND | WIRE_DIRECT_SEND | WIRE_MISC_CONNECTION
	wire_num = 6

/obj/item/device/assembly/eftpos/New()
	..()
	machine_id = "[station_name()] EFTPOS #[num_financial_terminals++]"
	access_code = rand(1111,111111)
	spawn(0)
		print_reference()

		//create a short manual as well
		var/obj/item/weapon/paper/R = new(src.loc)
		R.name = "Steps to success: Correct EFTPOS Usage"
		/*
		R.info += "<b>When first setting up your EFTPOS device:</b>"
		R.info += "1. Memorise your EFTPOS command code (provided with all EFTPOS devices).<br>"
		R.info += "2. Confirm that your EFTPOS device is connected to your local accounts database. For additional assistance with this step, contact NanoTrasen IT Support<br>"
		R.info += "3. Confirm that your EFTPOS device has been linked to the account that you wish to recieve funds for all transactions processed on this device.<br>"
		R.info += "<b>When starting a new transaction with your EFTPOS device:</b>"
		R.info += "1. Ensure the device is UNLOCKED so that new data may be entered.<br>"
		R.info += "2. Enter a sum of money and reference message for the new transaction.<br>"
		R.info += "3. Lock the transaction, it is now ready for your customer.<br>"
		R.info += "4. If at this stage you wish to modify or cancel your transaction, you may simply reset (unlock) your EFTPOS device.<br>"
		R.info += "5. Give your EFTPOS device to the customer, they must authenticate the transaction by swiping their ID card and entering their PIN number.<br>"
		R.info += "6. If done correctly, the transaction will be logged to both accounts with the reference you have entered, the terminal ID of your EFTPOS device and the money transferred across accounts.<br>"
		*/
		//Temptative new manual:
		R.info += "<b>First EFTPOS setup:</b><br>"
		R.info += "1. Memorise your EFTPOS command code (provided with all EFTPOS devices).<br>"
		R.info += "2. Connect the EFTPOS to the account in which you want to receive the funds.<br><br>"
		R.info += "<b>When starting a new transaction:</b><br>"
		R.info += "1. Enter the amount of money you want to charge and a purpose message for the new transaction.<br>"
		R.info += "2. Lock the new transaction. If you want to modify or cancel the transaction, you simply have to reset your EFTPOS device.<br>"
		R.info += "3. Give the EFTPOS device to your customer, he/she must finish the transaction by swiping their ID card or a charge card with enough funds.<br>"
		R.info += "4. If everything is done correctly, the money will be transferred. To unlock the device you will have to reset the EFTPOS device.<br>"


		//stamp the paper
		var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
		stampoverlay.icon_state = "paper_stamp-cent"
		if(!R.stamped)
			R.stamped = new
		R.offset_x += 0
		R.offset_y += 0
		R.ico += "paper_stamp-cent"
		R.stamped += /obj/item/weapon/stamp
		R.overlays += stampoverlay
		R.stamps += "<HR><i>This paper has been stamped by the EFTPOS device.</i>"
		interface_name = eftpos_name

	//by default, connect to the station account
	//the user of the EFTPOS device can change the target account though, and no-one will be the wiser (except whoever's being charged)
	linked_account = station_account

/obj/item/device/assembly/eftpos/proc/print_reference()
	var/obj/item/weapon/paper/R = new(src.loc)
	R.name = "Reference: [eftpos_name]"
	R.info = "<b>[eftpos_name] reference</b><br><br>"
	R.info += "Access code: [access_code]<br><br>"
	R.info += "<b>Do not lose or misplace this code.</b><br>"

	//stamp the paper
	var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
	stampoverlay.icon_state = "paper_stamp-cent"
	if(!R.stamped)
		R.stamped = new
	R.stamped += /obj/item/weapon/stamp
	R.overlays += stampoverlay
	R.stamps += "<HR><i>This paper has been stamped by the EFTPOS device.</i>"
	var/obj/item/smallDelivery/D = new(R.loc)
	R.loc = D
	D.wrapped = R
	D.name = "small parcel - 'EFTPOS access code'"

/obj/item/device/assembly/eftpos/get_data()
	var/list/data = list()
	data.Add("Value", "$[transaction_amount]", \
			 "Linked account", "[linked_account ? linked_account.owner_name : "None"]", \
			 "Transaction Purpose", transaction_purpose)
	return data

/obj/item/device/assembly/eftpos/get_buttons()
	var/list/data = list()
	if(transaction_locked)
		data.Add("Back[transaction_paid ? "" : " (authentication required)"]")
//		if(!transaction_paid)
//			data.Add("\[------\]")
	else
		data.Add("Lock in new transaction")
		data.Add("Change Code")
		data.Add("Change Eftpos ID")
		data.Add("Reset Access Code")
	return data

/obj/item/device/assembly/eftpos/get_nonset_data()
	var/list/data = list()
	data.Add("<i>This terminal is</i> [machine_id]", "<i>Report this code when contacting NanoTrasen IT Support</i>")
	if(transaction_locked)
		data.Add("Transaction purpose: <b>[transaction_purpose]</b>", "Value: <b>$[transaction_amount]</b><br>", \
				 "Linked account: <b>[linked_account ? linked_account.owner_name : "None"]</b><hr>")
		if(transaction_paid)
			data.Add("<i>This transaction has been processed successfully.</i><hr>")
		else
			data.Add("<i>Scan your ID below to complete transaction</i>")
			data.Add("<A href='?src=\ref[src];option=scan'>\[------\]</A>")

	return data

/obj/item/device/assembly/eftpos/Topic(href, href_list)
	if(href_list["option"])
		switch(href_list["option"])
			if("scan")
				if(linked_account)
					var/obj/item/I = usr.get_active_hand()
					if (istype(I, /obj/item/weapon/card))
						scan_card(I)
				else
					usr << "\icon[src]<span class='warning'>Unable to link accounts.</span>"
			if("Change Code")
				var/attempt_code = input("Re-enter the current EFTPOS access code", "Confirm old EFTPOS code") as num
				if(attempt_code == access_code)
					var/trycode = input("Enter a new access code for this device (4-6 digits, numbers only)", "Enter new EFTPOS code") as num
					if(trycode >= 1000 && trycode <= 999999)
						access_code = trycode
					else
						alert("That is not a valid code!")
					print_reference()
				else
					usr << "\icon[src]<span class='warning'>Incorrect code entered.</span>"
			if("Change Eftpos ID")
				var/attempt_code = text2num(input("Re-enter the current EFTPOS access code", "Confirm EFTPOS code"))
				if(attempt_code == access_code)
					eftpos_name = sanitize(input("Enter a new terminal ID for this device", "Enter new EFTPOS ID"), MAX_NAME_LEN) + " EFTPOS scanner"
					print_reference()
				else
					usr << "\icon[src]<span class='warning'>Incorrect code entered.</span>"
			if("Reset Access Code")
				//reset the access code - requires HoP/captain access
				var/obj/item/I = usr.get_active_hand()
				if (istype(I, /obj/item/weapon/card))
					var/obj/item/weapon/card/id/C = I
					if(access_cent_captain in C.access || access_hop in C.access || access_captain in C.access)
						access_code = 0
						usr << "\icon[src]<span class='info'>Access code reset to 0.</span>"
				else if (istype(I, /obj/item/weapon/card/emag))
					access_code = 0
					usr << "\icon[src]<span class='info'>Access code reset to 0.</span>"
			if("Transaction Purpose")
				var/inp = input(usr, "What is the purpose of the transaction?", "Eftpos")
				if(inp)
					transaction_purpose = inp
				else transaction_purpose = "Default"
		if(href_list["option"] == "Back[transaction_paid ? "" : " (authentication required)"]" || href_list["option"] == "Lock in new transaction")
			if(transaction_locked)
				if(transaction_paid)
					transaction_locked = 0
					transaction_paid = 0
				else
					var/attempt_code = input("Enter EFTPOS access code", "Reset Transaction") as num
					if(attempt_code == access_code)
						transaction_locked = 0
						transaction_paid = 0
			else if(linked_account)
				transaction_locked = 1
			else
				usr << "\icon[src]<span class='warning'>No account connected to send transactions to.</span>"
		if(href_list["option"] == "Value")
			var/try_num = input("Enter amount for EFTPOS transaction", "Transaction amount") as num
			if(try_num < 0)
				alert("That is not a valid amount!")
			else
				transaction_amount = try_num
		if(href_list["option"] == "Linked account")
			var/attempt_account_num = input("Enter account number to pay EFTPOS charges into", "New account number") as num
			var/attempt_pin = input("Enter pin code", "Account pin") as num
			linked_account = attempt_account_access(attempt_account_num, attempt_pin, 1)
			if(linked_account)
				if(linked_account.suspended)
					linked_account = null
					usr << "\icon[src]<span class='warning'>Account has been suspended.</span>"
			else
				usr << "\icon[src]<span class='warning'>Account not found.</span>"
	..()

/obj/item/device/assembly/eftpos/receive_data(var/list/data)
	if(!..()) return 0
	for(var/N in data)
		var/check = text2num(N)
		if(check && isnum(check))
			transact(check)


/obj/item/device/assembly/eftpos/attackby(obj/item/O as obj, user as mob)
	var/obj/item/weapon/card/id/I = O.GetID()
	if(I)
		if(linked_account)
			scan_card(I, O)
		else
			user << "\icon[src]<span class='warning'>Unable to connect to linked account.</span>"
	else if (istype(O, /obj/item/weapon/spacecash/ewallet))
		var/obj/item/weapon/spacecash/ewallet/E = O
		if (linked_account)
			if(!linked_account.suspended)
				if(transaction_locked && !transaction_paid)
					if(transaction_amount <= E.worth)
						playsound(src, 'sound/machines/chime.ogg', 50, 1)
						src.visible_message("\icon[src] \The [src] chimes.")
						transaction_paid = 1

						//transfer the money
						E.worth -= transaction_amount
						linked_account.money += transaction_amount

						//create entry in the EFTPOS linked account transaction log
						var/datum/transaction/T = new()
						T.target_name = E.owner_name //D.owner_name
						T.purpose = (transaction_purpose ? transaction_purpose : "None supplied.")
						T.amount = transaction_amount
						T.source_terminal = machine_id
						T.date = current_date_string
						T.time = worldtime2text()
						linked_account.transaction_log.Add(T)
					else
						user << "\icon[src]<span class='warning'>\The [O] doesn't have that much money!</span>"
			else
				user << "\icon[src]<span class='warning'>Connected account has been suspended.</span>"
		else
			user << "\icon[src]<span class='warning'>EFTPOS is not connected to an account.</span>"

	else
		..()

/obj/item/device/assembly/eftpos/proc/scan_card(var/obj/item/weapon/card/I, var/obj/item/ID_container)
	if (istype(I, /obj/item/weapon/card/id))
		var/obj/item/weapon/card/id/C = I
		if(I==ID_container || ID_container == null)
			usr.visible_message("<span class='info'>\The [usr] swipes a card through \the [src].</span>")
		else
			usr.visible_message("<span class='info'>\The [usr] swipes \the [ID_container] through \the [src].</span>")
		if(transaction_locked && !transaction_paid)
			if(linked_account)
				if(!linked_account.suspended)
					transact(C.associated_account_number)
				else
					usr << "\icon[src]<span class='warning'>Connected account has been suspended.</span>"
			else
				usr << "\icon[src]<span class='warning'>EFTPOS is not connected to an account.</span>"
	else if (istype(I, /obj/item/weapon/card/emag))
		if(transaction_locked)
			if(transaction_paid)
				usr << "\icon[src]<span class='info'>You stealthily swipe \the [I] through \the [src].</span>"
				transaction_locked = 0
				transaction_paid = 0
			else
				usr.visible_message("<span class='info'>\The [usr] swipes a card through \the [src].</span>")
				playsound(src, 'sound/machines/chime.ogg', 50, 1)
				src.visible_message("\icon[src] \The [src] chimes.")
				transaction_paid = 1
	else
		..()

	//emag?

/obj/item/device/assembly/eftpos/proc/transact(var/account_num)
	var/attempt_pin = ""
	var/datum/money_account/D = get_account(account_num)
	if(D.security_level)
		attempt_pin = input("Enter pin code", "EFTPOS transaction") as num
		D = null
	D = attempt_account_access(account_num, attempt_pin, 2)
	if(D)
		if(!D.suspended)
			if(transaction_amount <= D.money)
				playsound(src, 'sound/machines/chime.ogg', 50, 1)
				src.visible_message("\icon[src] \The [src] chimes.")
				transaction_paid = 1

				//transfer the money
				D.money -= transaction_amount
				linked_account.money += transaction_amount

				//create entries in the two account transaction logs
				var/datum/transaction/T = new()
				T.target_name = "[linked_account.owner_name] (via [eftpos_name])"
				T.purpose = transaction_purpose
				if(transaction_amount > 0)
					T.amount = "([transaction_amount])"
				else
					T.amount = "[transaction_amount]"
				T.source_terminal = machine_id
				T.date = current_date_string
				T.time = worldtime2text()
				D.transaction_log.Add(T)
				//
				T = new()
				T.target_name = D.owner_name
				T.purpose = transaction_purpose
				T.amount = "[transaction_amount]"
				T.source_terminal = machine_id
				T.date = current_date_string
				T.time = worldtime2text()
				linked_account.transaction_log.Add(T)
			else
				usr << "\icon[src]<span class='warning'>You don't have that much money!</span>"
		else
			usr << "\icon[src]<span class='warning'>Your account has been suspended.</span>"
	else
		usr << "\icon[src]<span class='warning'>Unable to access account. Check security settings and try again.</span>"