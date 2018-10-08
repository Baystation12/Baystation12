/datum/rdcontract
	var/name = "research contract"
	var/desc = "a r&d contract for the delivery of an item"
	var/ukey_name = "default" // see create_ukey()

	var/highend = 0
	// type path of the item to deliver
	var/delivery_type = null
	// reward for completing the contract
	var/reward = 0
	// account number to pay reward to
	var/reward_account_number
	// fluff. who are you doing the contract for?
	var/contractor

/datum/rdcontract/New(var/account_number)
	..()

	reward_account_number = account_number
	if(!setup())
		qdel_self()

// return indicates success
/datum/rdcontract/proc/setup()
	contractor = pick(GLOB.corporate_factions)

	return create_ukey()

// get a unique id for the unique key
// this may be called multiple times if the ID has been used before (contract wouldn't be unique)
/datum/rdcontract/proc/get_ukey_id()
	return null

// make a ukey to ensure contract uniqueness
// return indicates success
/datum/rdcontract/proc/create_ukey()
	var/id = get_ukey_id()

	// make a unique key for this contract
	var/ukey = "[ukey_name]-[id]"
	while(GLOB.used_rd_contracts.Find(ukey))
		id = get_ukey_id()

		// special return to indicate that no id could be made
		if(isnull(id))
			return 0

		ukey = "[ukey_name]-[id]"
	GLOB.used_rd_contracts.Add(ukey)

	return 1

// check for completion. don't call complete() from this. the delivery tube machine does it
/datum/rdcontract/proc/check_completion(var/obj/O)
	return 0

// add money to the science department account
/datum/rdcontract/proc/complete()
	var/datum/money_account/account = get_account(reward_account_number)
	if(!account)
		return 0

	var/datum/transaction/T = new("Torch, Ltd. Research Dept.", "Contract completion", reward, contractor)
	account.do_transaction(T)

	qdel_self()
	return 1
