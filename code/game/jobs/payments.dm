proc/calculate_paycheck(var/mob/living/carbon/human/M, var/roundend = 0) //Tax = if we should calculate taxes, add if we want to add the cash.
	if(M && istype(M) && M.client && M.client.prefs.char_department && M.job) //SO MANY CHECKS JEZUS ah well
		var/datum/job/job = job_master.GetJob(M.job)
		var/paycheck = round(get_base_pay(M) * 4, 0.01)
		if(evacuation_controller.emergency_evacuation)
			paycheck = paycheck/100*80
		if(roundend)
			var/mins = round((round_duration_in_ticks % 36000) / 600)
			var/deduct = (paycheck/60)*(60 % mins)
			paycheck -= deduct
		if(M.client.prefs.permadeath)
			get_tax_deduction("pension", paycheck, 1)
		else
			get_tax_deduction("pension", paycheck, 0)
		get_tax_deduction("income", paycheck)
		return paycheck

proc/send_paycheck(var/mob/living/carbon/human/M, var/paycheck)
	if(M && paycheck)
		var/bank = 0
		var/pension = 0
		if(M.CharRecords.permadeath)
			pension = get_tax_deduction("pension", paycheck, 1)
		else
			pension = get_tax_deduction("pension", paycheck, 0)
		bank = get_tax_deduction("income", paycheck)
		M.CharRecords.pension_balance += pension
		paycheck -= bank+pension
		M.CharRecords.bank_balance += paycheck
		return paycheck

proc/get_tax_deduction(var/taxtype, var/paycheck, var/permadeath)
	if(taxtype && paycheck)
		switch(taxtype)
			if("income")
				var/incometax = (paycheck / 100) * 20 //20%
				return incometax
			if("pension")
				var/pensiontax
				if(permadeath)
					pensiontax = (paycheck / 100) * 16
				else
					pensiontax = (paycheck / 100) * 10
				return pensiontax

proc/get_base_pay(var/mob/living/carbon/human/M)
	if(M && M.job)
		var/datum/job/job = job_master.GetJob(M.job)
		var/base_pay = job.base_pay //Base pay from job
		var/efficiencybonus = 4+(4*paychecks) //Efficiencybonus = 4% + 4% per paycheck.
		var/rankbonus = calculate_department_rank(M) * 5 // Rank bonus = rank number * 5%
		var/end_base_pay = (base_pay/100) * (100+efficiencybonus+rankbonus) // Turns 1% into more %
		return end_base_pay