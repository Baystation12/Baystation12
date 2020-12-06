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

/datum/goal/clean/get_summary_value()
	return " ([cleaned]/[need_cleaned] so far)"

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

//Fitness Personal Goal
//Weights
/datum/goal/weights
	completion_message = "Yeah! Get Swole!"
	var/reps = 0
	var/need_reps

/datum/goal/weights/New()
	need_reps = rand(10,80)
	..()

/datum/goal/weights/update_strings()
	description = "Head to the gym and lift some weights on the weightlifting machine."

/datum/goal/weights/check_success()
	return (reps >= need_reps)

/datum/goal/weights/update_progress(var/progress)
	if(reps < need_reps)
		reps += progress
		if(reps >= need_reps)
			on_completion()

/datum/goal/weights/get_summary_value()
	return " ([reps]/[need_reps] reps so far)"

//PunchingBag
/datum/goal/punchingbag
	completion_message = "Finally let all that anger out? Good."
	var/hits = 0
	var/need_hits

/datum/goal/punchingbag/New()
	need_hits = rand(30,120)
	..()

/datum/goal/punchingbag/update_strings()
	description = "Need to hit something really bad? Maybe you shoud hit the punching bag in the gym."

/datum/goal/punchingbag/check_success()
	return (hits >= need_hits)

/datum/goal/punchingbag/update_progress(var/progress)
	if(hits < need_hits)
		hits += progress
		if(hits >= need_hits)
			on_completion()

/datum/goal/punchingbag/get_summary_value()
	return " ([hits]/[need_hits] hits so far)"
