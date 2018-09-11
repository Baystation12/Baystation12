#define UKEY_ID_INVALID 0

/datum/rdcontract
	var/name = "research contract"
	var/desc = "a r&d contract for the delivery of an item"
	var/ukey_name = "default" // see create_ukey()

	// type path of the item to deliver
	var/delivery_type = null
	// reward for completing the contract
	var/reward = 0
	// fluff. who are you doing the contract for?
	var/contractor

/datum/rdcontract/New()
	. = ..()

	var/succ = setup()
	if(!succ)
		qdel(src)

// return indicates success
/datum/rdcontract/proc/setup()
	var/list/contractors = list(
		"GeneriTech",
		"Nuisance Co.",
		"MicroTarp",
		"Qualm Labs"
	)
	contractor = pick(contractors)

	var/could_make_unique = create_ukey()
	if(!could_make_unique)
		return 0

	return 1

// get a unique id for the unique key
// this may be called multiple times if the ID has been used before (contract wouldn't be unique)
/datum/rdcontract/proc/get_ukey_id()
	return UKEY_ID_INVALID

// make a ukey to ensure contract uniqueness
// return indicates success
/datum/rdcontract/proc/create_ukey()
	var/id = get_ukey_id()

	// make a unique key for this contract
	var/ukey = "[ukey_name]-[id]"
	while(GLOB.used_rd_contracts.Find(ukey))
		id = get_ukey_id()

		// special return to indicate that no id could be made
		if (id == UKEY_ID_INVALID)
			return 0

		ukey = "[ukey_name]-[id]"
	GLOB.used_rd_contracts.Add(ukey)

	for(var/unikey in GLOB.used_rd_contracts)
		world << unikey

	return 1

// check for completion. don't call complete() from this. the delivery tube machine does it
/datum/rdcontract/proc/check_completion(var/obj/O)
	return 0

// add money to the science department account
/datum/rdcontract/proc/complete()
	qdel(src)

	var/datum/money_account/rd_account = get_department_account("Science")
	if(!rd_account)
		return 0

	var/datum/transaction/T = new("NanoTrasen SEV Torch Dept.", "Contract completion", reward, contractor)
	rd_account.do_transaction(T)

	return 1
