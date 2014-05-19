// This is a parent directive meant to be derived by directives that fit
// the "fire X type of employee" pattern of directives. Simply apply your
// flavor text and override get_crew_to_terminate in your child datum.
// See alien_fraud_directive.dm for an example.
datum/directive/terminations
	var/list/accounts_to_revoke = list()
	var/list/accounts_to_suspend = list()
	var/list/ids_to_terminate = list()

	proc/get_crew_to_terminate()
		return list()

datum/directive/terminations/directives_complete()
	for(var/account_number in accounts_to_suspend)
		if (!accounts_to_suspend[account_number])
			return 0

	for(var/account_number in accounts_to_revoke)
		if (!accounts_to_revoke[account_number])
			return 0

	return ids_to_terminate.len == 0

datum/directive/terminations/initialize()
	for(var/mob/living/carbon/human/A in get_crew_to_terminate())
		var/datum/money_account/account = A.mind.initial_account
		accounts_to_revoke["[account.account_number]"] = 0
		accounts_to_suspend["[account.account_number]"] = account.suspended
		ids_to_terminate.Add(A.wear_id)

/hook/revoke_payroll/proc/payroll_directive(datum/money_account/account)
	var/datum/directive/terminations/D = get_directive("terminations")
	if (!D) return 1

	if(D.accounts_to_revoke && D.accounts_to_revoke.Find("[account.account_number]"))
		D.accounts_to_revoke["[account.account_number]"] = 1

	return 1

/hook/change_account_status/proc/suspension_directive(datum/money_account/account)
	var/datum/directive/terminations/D = get_directive("terminations")
	if (!D) return 1

	if(D.accounts_to_suspend && D.accounts_to_suspend.Find("[account.account_number]"))
		D.accounts_to_suspend["[account.account_number]"] = account.suspended

	return 1

/hook/terminate_employee/proc/termination_directive(obj/item/weapon/card/id)
	var/datum/directive/terminations/D = get_directive("terminations")
	if (!D) return 1

	if(D.ids_to_terminate && D.ids_to_terminate.Find(id))
		D.ids_to_terminate.Remove(id)

	return 1
