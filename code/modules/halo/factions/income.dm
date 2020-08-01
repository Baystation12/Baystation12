
/datum/faction
	var/world_time

/datum/faction/proc/handle_income()
	world_time = world.time

	//we havent started timing yet
	if(!next_income)
		next_income = world.time + income_delay

	//time for income
	else if(world.time >= next_income)
		//reset the timer
		next_income = world.time + income_delay

		//create a transaction on the account
		var/datum/transaction/T = new("HQ", "Income", income, "Terminal #F[rand(100000,999999)]")
		money_account.transaction_log.Add(T)
		money_account.money += income

/datum/faction/proc/get_station_income_time()
	//we havent started timing yet
	if(!next_income)
		next_income = world.time + income_delay

	return worldtime2stationtime(next_income)
