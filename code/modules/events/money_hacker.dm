var/global/account_hack_attempted = 0

/datum/event/money_hacker
	var/datum/money_account/affected_account
	endWhen = 100
	var/end_time

/datum/event/money_hacker/setup()
	end_time = world.time + 6000
	if(all_money_accounts.len)
		affected_account = pick(all_money_accounts)

		account_hack_attempted = 1
	else
		kill()

/datum/event/money_hacker/announce()
	var/obj/machinery/message_server/MS = get_message_server()
	if(MS)
		// Hide the account number for now since it's all you need to access a standard-security account. Change when that's no longer the case.
		var/message = "A brute force hack has been detected (in progress since [stationtime2text()]). The target of the attack is: Financial account #[affected_account.account_number], \
		without intervention this attack will succeed in approximately 10 minutes. Required intervention: temporary suspension of affected accounts until the attack has ceased. \
		Notifications will be sent as updates occur."
		var/my_department = "[location_name()] Firewall Subroutines"
		MS.send_rc_message("XO's Desk", my_department, message, "", "", 2)


/datum/event/money_hacker/tick()
	if(world.time >= end_time)
		endWhen = activeFor
	else
		endWhen = activeFor + 10

/datum/event/money_hacker/end()
	var/message = "The attack has ceased, the affected accounts can now be brought online."
	if(affected_account && !affected_account.suspended)
		//hacker wins
		message = "The hack attempt has succeeded."

		//subtract the money
		var/amount = affected_account.money * 0.8 + (rand(2,4) - 2) / 10

		//create a taunting log entry
		var/name = pick("","[pick("Biesel","New Gibson")] GalaxyNet Terminal #[rand(111,999)]","your mums place","nantrasen high CommanD")
		var/purpose = pick("Ne$ ---ount fu%ds init*&lisat@*n","PAY BACK YOUR MUM","Funds withdrawal","pWnAgE","l33t hax","liberationez")
		var/datum/transaction/singular/T = new(affected_account, name, -amount, purpose)
		var/date1 = "31 December, 1999"
		var/date2 = "[num2text(rand(1,31))] [pick("January","February","March","April","May","June","July","August","September","October","November","December")], [rand(1000,3000)]"
		T.date = pick("", stationdate2text(), date1, date2)
		var/time1 = rand(0, 99999999)
		var/time2 = "[round(time1 / 36000)+12]:[pad_left(time1 / 600 % 60, 2, "0")]"
		T.time = pick("", stationtime2text(), time2)
		
		T.perform()

	var/obj/machinery/message_server/MS = get_message_server()
	if(MS)
		var/my_department = "[location_name()] Firewall Subroutines"
		MS.send_rc_message("XO's Desk", my_department, message, "", "", 2)