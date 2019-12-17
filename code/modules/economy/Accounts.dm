/datum/money_account
	var/account_name = ""
	var/owner_name = ""
	var/account_number = 0
	var/remote_access_pin = 0
	var/money = 0
	var/list/transaction_log = list()
	var/suspended = 0
	var/security_level = 0	//0 - auto-identify from worn ID, require only account number
							//1 - require manual login / account number and pin
							//2 - require card and manual login
	var/account_type = ACCOUNT_TYPE_PERSONAL

/datum/money_account/New(var/account_type)
	account_type = account_type ? account_type : ACCOUNT_TYPE_PERSONAL

// is_source inverts the amount.
/datum/money_account/proc/add_transaction(var/datum/transaction/T, is_source = FALSE)
	money = max(is_source ? money - T.amount : money + T.amount, 0)
	transaction_log += T

/datum/money_account/proc/get_balance()
	return money

/datum/money_account/proc/log_msg(msg, machine_id)
	var/datum/transaction/log/T = new(src, msg, machine_id)
	return T.perform()

/datum/money_account/proc/deposit(amount, purpose, machine_id)
	var/datum/transaction/singular/T = new(src, machine_id, amount, purpose)
	return T.perform()

/datum/money_account/proc/withdraw(amount, purpose, machine_id)
	var/datum/transaction/singular/T = new(src, machine_id, -amount, purpose)
	return T.perform()

/datum/money_account/proc/transfer(to_account, amount, purpose)
	var/datum/transaction/T = new(src, to_account, amount, purpose)
	return T.perform()


/proc/create_account(var/account_name = "Default account name", var/owner_name, var/starting_funds = 0, var/account_type = ACCOUNT_TYPE_PERSONAL, var/obj/machinery/computer/account_database/source_db)

	//create a new account
	var/datum/money_account/M = new()
	M.account_name = account_name
	M.owner_name = (owner_name ? owner_name : account_name)
	M.account_type = account_type
	M.remote_access_pin = rand(1111, 111111)

	//create an entry in the account transaction log for when it was created
	//note that using the deposit proc on the account isn't really feasible because we need to change the transaction data before performing it
	var/datum/transaction/singular/T = new(M, (source_db ? source_db.machine_id : "NTGalaxyNet Terminal #[rand(111,1111)]"), starting_funds, "Account creation")
	if(!source_db)
		//set a random date, time and location some time over the past few decades
		T.date = "[num2text(rand(1,31))] [pick("January","February","March","April","May","June","July","August","September","October","November","December")], [game_year-rand(8,18)]"
		T.time = "[rand(0,24)]:[rand(11,59)]"

		M.account_number = random_id("station_account_number", 111111, 999999)
	else
		M.account_number = next_account_number
		next_account_number += rand(1,25)

		//create a sealed package containing the account details
		var/obj/item/smallDelivery/P = new /obj/item/smallDelivery(source_db.loc)

		var/obj/item/weapon/paper/R = new /obj/item/weapon/paper(P)
		P.wrapped = R
		R.SetName("Account information: [M.account_name]")
		R.info = "<b>Account details (confidential)</b><br><hr><br>"
		R.info += "<i>Account holder:</i> [M.owner_name]<br>"
		R.info += "<i>Account number:</i> [M.account_number]<br>"
		R.info += "<i>Account pin:</i> [M.remote_access_pin]<br>"
		R.info += "<i>Starting balance:</i> [GLOB.using_map.local_currency_name_short][M.money]<br>"
		R.info += "<i>Date and time:</i> [stationtime2text()], [stationdate2text()]<br><br>"
		R.info += "<i>Creation terminal ID:</i> [source_db.machine_id]<br>"
		R.info += "<i>Authorised officer overseeing creation:</i> [source_db.held_card.registered_name]<br>"

		//stamp the paper
		var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
		stampoverlay.icon_state = "paper_stamp-boss"
		if(!R.stamped)
			R.stamped = new
		R.stamped += /obj/item/weapon/stamp
		R.overlays += stampoverlay
		R.stamps += "<HR><i>This paper has been stamped by the Accounts Database.</i>"

	//add the account
	T.perform()
	all_money_accounts.Add(M)

	return M

//this returns the first account datum that matches the supplied accnum/pin combination, it returns null if the combination did not match any account
/proc/attempt_account_access(var/attempt_account_number, var/attempt_pin_number, var/security_level_passed = 0)
	var/datum/money_account/D = get_account(attempt_account_number)
	if(D && D.security_level <= security_level_passed && (!D.security_level || D.remote_access_pin == attempt_pin_number) )
		return D

/proc/get_account(var/account_number)
	for(var/datum/money_account/D in all_money_accounts)
		if(D.account_number == account_number)
			return D
