/datum/rdcontract
	var/name = "research contract"
	var/desc = "a r&d contract for the delivery of an item"

	// type path of the item to deliver
	var/delivery_type = null
	// reward for completing the contract
	var/reward = 0
	// fluff. who are you doing the contract for?
	var/contractor

/datum/rdcontract/New()
	. = ..()

	setup()

/datum/rdcontract/proc/setup()
	var/list/contractors = list(
		"GeneriTech",
		"Nuisance Co.",
		"MicroTarp",
		"Qualm Labs"
	)
	contractor = pick(contractors)

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
