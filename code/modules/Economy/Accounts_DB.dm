
/obj/machinery/account_database
	name = "Accounts uplink console"
	desc = "Access transaction logs, account data and all kinds of other financial records."
	icon = 'icons/obj/computer.dmi'
	icon_state = "aiupload"
	density = 1
	req_one_access = list(access_hop, access_captain, access_cent_captain)
	var/receipt_num
	var/machine_id = ""
	var/obj/item/weapon/card/id/held_card
	var/access_level = 0
	var/datum/money_account/detailed_account_view
	var/creating_new_account = 0

/obj/machinery/account_database/New()
	..()
	machine_id = "[station_name()] Acc. DB #[num_financial_terminals++]"

/obj/machinery/account_database/attack_hand(mob/user as mob)
	if(get_dist(src,user) <= 1)
		var/dat = "<b>Accounts Database</b><br>"
		dat += "<i>[machine_id]</i><br>"
		dat += "Confirm identity: <a href='?src=\ref[src];choice=insert_card'>[held_card ? held_card : "-----"]</a><br>"

		if(access_level > 0)
			dat += "You may not edit accounts at this terminal, only create and view them.<br>"
			if(creating_new_account)
				dat += "<br>"
				dat += "<a href='?src=\ref[src];choice=view_accounts_list;'>Return to accounts list</a>"
				dat += "<form name='create_account' action='?src=\ref[src]' method='get'>"
				dat += "<input type='hidden' name='src' value='\ref[src]'>"
				dat += "<input type='hidden' name='choice' value='finalise_create_account'>"
				dat += "<b>Holder name:</b> <input type='text' id='holder_name' name='holder_name' style='width:250px; background-color:white;'><br>"
				dat += "<b>Initial funds:</b> <input type='text' id='starting_funds' name='starting_funds' style='width:250px; background-color:white;'> (subtracted from station account)<br>"
				dat += "<i>New accounts are automatically assigned a secret number and pin, which are printed separately in a sealed package.</i><br>"
				dat += "<input type='submit' value='Create'><br>"
				dat += "</form>"
			else
				if(detailed_account_view)
					dat += "<br>"
					dat += "<a href='?src=\ref[src];choice=view_accounts_list;'>Return to accounts list</a><hr>"
					dat += "<b>Account number:</b> #[detailed_account_view.account_number]<br>"
					dat += "<b>Account holder:</b> [detailed_account_view.owner_name]<br>"
					dat += "<b>Account balance:</b> $[detailed_account_view.money]<br>"
					if(access_level > 1)
						dat += "<b><a href='?src=\ref[src];choice=add_funds'>Silently add funds (no transaction log)</a><br>"
						dat += "<b><a href='?src=\ref[src];choice=remove_funds'>Silently remove funds (no transaction log)</a><br>"
					dat += "<b><a href='?src=\ref[src];choice=toggle_suspension'>[detailed_account_view.suspended ? "Unsuspend account" : "Suspend account"]</a><br>"
					dat += "<table border=1 style='width:100%'>"
					dat += "<tr>"
					dat += "<td><b>Date</b></td>"
					dat += "<td><b>Time</b></td>"
					dat += "<td><b>Target</b></td>"
					dat += "<td><b>Purpose</b></td>"
					dat += "<td><b>Value</b></td>"
					dat += "<td><b>Source terminal ID</b></td>"
					dat += "</tr>"
					for(var/datum/transaction/T in detailed_account_view.transaction_log)
						dat += "<tr>"
						dat += "<td>[T.date]</td>"
						dat += "<td>[T.time]</td>"
						dat += "<td>[T.target_name]</td>"
						dat += "<td>[T.purpose]</td>"
						dat += "<td>$[T.amount]</td>"
						dat += "<td>[T.source_terminal]</td>"
						dat += "</tr>"
					dat += "</table>"
				else
					dat += "<a href='?src=\ref[src];choice=create_account;'>Create new account</a><br><br>"
					dat += "<table border=1 style='width:100%'>"
					for(var/i=1, i<=all_money_accounts.len, i++)
						var/datum/money_account/D = all_money_accounts[i]
						dat += "<tr>"
						dat += "<td>#[D.account_number]</td>"
						dat += "<td>[D.owner_name]</td>"
						dat += "<td>[D.suspended ? "SUSPENDED" : ""]</td>"
						dat += "<td><a href='?src=\ref[src];choice=view_account_detail;account_index=[i]'>View in detail</a></td>"
						dat += "</tr>"
					dat += "</table>"

		user << browse(dat,"window=account_db;size=700x650")
	else
		user << browse(null,"window=account_db")

/obj/machinery/account_database/attackby(O as obj, user as mob)//TODO:SANITY
	if(istype(O, /obj/item/weapon/card))
		var/obj/item/weapon/card/id/idcard = O
		if(!held_card)
			usr.drop_item()
			idcard.loc = src
			held_card = idcard

			if(access_cent_captain in idcard.access)
				access_level = 2
			else if(access_hop in idcard.access || access_captain in idcard.access)
				access_level = 1
	else
		..()

/obj/machinery/account_database/Topic(var/href, var/href_list)

	if(href_list["choice"])
		switch(href_list["choice"])
			if("create_account")
				creating_new_account = 1
			if("add_funds")
				var/amount = input("Enter the amount you wish to add", "Silently add funds") as num
				if(detailed_account_view)
					detailed_account_view.money += amount
			if("remove_funds")
				var/amount = input("Enter the amount you wish to remove", "Silently remove funds") as num
				if(detailed_account_view)
					detailed_account_view.money -= amount
			if("toggle_suspension")
				if(detailed_account_view)
					if(detailed_account_view.suspended)
						detailed_account_view.suspended = 0
					else
						detailed_account_view.suspended = 1
			if("finalise_create_account")
				var/account_name = href_list["holder_name"]
				var/starting_funds = max(text2num(href_list["starting_funds"]), 0)
				create_account(account_name, starting_funds, src)
				if(starting_funds > 0)
					//subtract the money
					station_account.money -= starting_funds

					//create a transaction log entry
					var/datum/transaction/T = new()
					T.target_name = account_name
					T.purpose = "New account funds initialisation"
					T.amount = "([starting_funds])"
					T.date = current_date_string
					T.time = worldtime2text()
					T.source_terminal = machine_id
					station_account.transaction_log.Add(T)

				creating_new_account = 0
			if("insert_card")
				if(held_card)
					held_card.loc = src.loc

					if(ishuman(usr) && !usr.get_active_hand())
						usr.put_in_hands(held_card)
					held_card = null
					access_level = 0

				else
					var/obj/item/I = usr.get_active_hand()
					if (istype(I, /obj/item/weapon/card/id))
						var/obj/item/weapon/card/id/C = I
						usr.drop_item()
						C.loc = src
						held_card = C

						if(access_cent_captain in C.access)
							access_level = 2
						else if(access_hop in C.access || access_captain in C.access)
							access_level = 1
			if("view_account_detail")
				var/index = text2num(href_list["account_index"])
				if(index && index <= all_money_accounts.len)
					detailed_account_view = all_money_accounts[index]
			if("view_accounts_list")
				detailed_account_view = null
				creating_new_account = 0

	src.attack_hand(usr)
