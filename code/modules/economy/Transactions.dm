#define TRANSACTION_TYPE_DEPOSIT 1
#define TRANSACTION_TYPE_WITHDRAWAL 2

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

/datum/transaction/New(_source, _target, _amount, _purpose)
	..()
	date = stationdate2text()
	time = stationtime2text()

	purpose = _purpose
	amount = _amount

	target = _target
	source = _source

/datum/transaction/proc/valid()
	if(isnull(target) || isnull(source))
		return FALSE

	// Transactions between different account types are invalid
	if(target.account_type != source.account_type)
		return FALSE

	if(target.suspended || source.suspended)
		return FALSE

	return TRUE

// Whether or not the source account can afford the transaction
/datum/transaction/proc/source_can_afford()
	return (source.money >= amount)

/datum/transaction/proc/get_target_name()
	if(isnull(target))
		return "ERROR"

	return target.account_name

/datum/transaction/proc/get_source_name()
	if(isnull(source))
		return "ERROR"

	return source.account_name

/datum/transaction/proc/perform()
	if(!valid() || !source_can_afford())
		return FALSE

	target.add_transaction(src, TRUE)
	source.add_transaction(src, FALSE)

	return TRUE

/datum/transaction/proc/sanitize_amount() //some place still uses (number) for negative amounts and I can't find it
	if(!istext(amount))
		return

	// Check if the text is numeric.
	var/text = amount
	amount = text2num(text)

	// Otherwise, the (digits) thing is going on.
	if(!amount)
		var/regex/R = regex("\\d+")
		R.Find(text)
		amount = -text2num(R.match)

/*
	Transactions that only involve one account
	Transactions like this would be cash deposits/withdrawals, lottery winnings, filling your account at gamestart, etc.
*/

/datum/transaction/singular
	var/other_name = "ERR"
	var/transaction_type = TRANSACTION_TYPE_DEPOSIT

/datum/transaction/singular/New(is_deposit, account, _other_name, amount, purpose)
	transaction_type = is_deposit ? TRANSACTION_TYPE_DEPOSIT : TRANSACTION_TYPE_WITHDRAWAL
	other_name = _other_name

	..((is_deposit() ? null : account), (is_deposit() ? account : null), amount, purpose)

/datum/transaction/singular/proc/is_deposit()
	return (transaction_type == TRANSACTION_TYPE_DEPOSIT)

// Deposits require the target account to be valid. Withdrawals require the source account to be valid
/datum/transaction/singular/valid()
	if(is_deposit())
		return (!isnull(target) && !target.suspended)
	else
		return (!isnull(source) && !source.suspended)

/datum/transaction/singular/source_can_afford()
	return (is_deposit() ? TRUE : ..())

// For deposits: returns the name of the account the money was deposited to. For withdrawals: returns the machine ID of the machine the withdrawal was made at
/datum/transaction/singular/get_target_name()
	return (is_deposit() ? target.account_name : other_name)

// For deposits: returns the machine ID of the machine the deposit was made to. For withdrawals: returns the name of the account the money was withdrawn from
/datum/transaction/singular/get_source_name()
	return (is_deposit() ? other_name : source.account_name)

/datum/transaction/singular/perform()
	if(!valid() || !source_can_afford())
		return FALSE

	if(is_deposit())
		target.add_transaction(src, TRUE)
	else
		source.add_transaction(src, FALSE)

	return TRUE

/*
	Log messages
*/

/datum/transaction/log
	var/machine_id = "ERRID#?"

/datum/transaction/log/New(account, message, _machine_id)
	machine_id = _machine_id

	..(null, account, 0, "LOG: [message]")

/datum/transaction/log/valid()
	return !isnull(target)

/datum/transaction/log/get_source_name()
	return machine_id

/datum/transaction/log/perform()
	if(!valid())
		return FALSE

	target.add_transaction(src)
	return TRUE

#undef TRANSACTION_TYPE_DEPOSIT
#undef TRANSACTION_TYPE_WITHDRAWAL