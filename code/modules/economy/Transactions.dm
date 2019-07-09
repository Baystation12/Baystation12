/*
	Regular transactions between accounts
*/

/datum/transaction
	var/purpose = ""
	var/amount = 0
	var/date = ""
	var/time = ""

	var/datum/money_account/target = null
	var/datum/money_account/source = null

// Can also do negative amounts to transfer from target to source
/datum/transaction/New(_source, _target, _amount, _purpose)
	..()

	date = stationdate2text()
	time = stationtime2text()

	purpose = _purpose
	amount = _amount

	source = _source
	target = _target

/datum/transaction/proc/valid()
	// None of the involved accounts can be suspended
	if(target.suspended || source.suspended)
		return FALSE

	// The payer must be able to afford the transaction
	if(!source_can_afford())
		return FALSE

	return TRUE

// Whether or not the source account can afford the transaction
/datum/transaction/proc/source_can_afford()
	return (source.money >= amount)

/datum/transaction/proc/get_target_name()
	return target.account_name

/datum/transaction/proc/get_source_name()
	return source.account_name

// Performs the transaction on both the source and target accounts
/datum/transaction/proc/perform()
	if(!valid())
		return FALSE

	target.add_transaction(src)
	source.add_transaction(src, TRUE)

	return TRUE

/*
	Transactions that only involve one account
	Transactions like this would be cash deposits/withdrawals, lottery winnings, filling your account at gamestart, etc.
	Note that this ALWAYS uses "source" as the account, even if it's actually the target. This is to ensure a consistent argument order (account, terminal/whatever name, amount, purpose)
*/

/datum/transaction/singular/proc/is_deposit()
	return (amount > 0)

/datum/transaction/singular/valid()
	return !source.suspended && source_can_afford()

/datum/transaction/singular/source_can_afford()
	return source.money + amount >= 0

// For deposits: returns the name of the account the money was deposited to. For withdrawals: returns the machine ID of the machine the withdrawal was made at
/datum/transaction/singular/get_target_name()
	return (is_deposit() ? source.account_name : target)

// For deposits: returns the machine ID of the machine the deposit was made to. For withdrawals: returns the name of the account the money was withdrawn from
/datum/transaction/singular/get_source_name()
	return (is_deposit() ? target : source.account_name)

/datum/transaction/singular/perform()
	if(!valid())
		return FALSE

	source.add_transaction(src)

	return TRUE

/*
	Log messages
	These should only be made through the logmsg proc of the account you want to create a log on!
*/

/datum/transaction/log
	var/machine_id = "ERRID#?"

/datum/transaction/log/New(account, message, _machine_id)
	machine_id = _machine_id

	..(null, account, 0, "LOG: [message]")

/datum/transaction/log/valid()
	return TRUE

/datum/transaction/log/get_source_name()
	return machine_id

/datum/transaction/log/perform()
	if(!valid())
		return FALSE

	target.add_transaction(src)
	return TRUE
