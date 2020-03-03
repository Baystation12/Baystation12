/datum/goal/clean
	completion_message = "Things are looking a lot nicer now."
	var/cleaned = 0
	var/need_cleaned

/datum/goal/clean/New()
	need_cleaned = rand(10,20)
	..()

/datum/goal/clean/update_strings()
	description = "This place is disgusting. Scrub out at least [need_cleaned] [need_cleaned == 1 ? "mess" : "messes"] with soap."

/datum/goal/clean/check_success()
	return (cleaned >= need_cleaned)

/datum/goal/clean/update_progress(var/progress)
	if(cleaned < need_cleaned)
		cleaned += progress
		if(cleaned >= need_cleaned)
			on_completion()

/datum/goal/clean/walk/get_summary_value()
	return " ([cleaned]/[need_cleaned]so far)"

/datum/goal/money
	var/target_amount

/datum/goal/money/update_strings()
	target_amount = rand(100, 200)
	var/datum/mind/mind = owner
	for(var/datum/money_account/acct in all_money_accounts)
		if(acct.owner_name == mind.current.real_name)
			target_amount = acct.get_balance() * rand(2,3)
			break
	description = "End the round with bank balance higher than $[target_amount]."

/datum/goal/money/check_success()
	var/datum/mind/mind = owner
	for(var/datum/money_account/acct in all_money_accounts)
		if(acct.owner_name == mind.current.real_name)
			return acct.get_balance() > target_amount
	return FALSE