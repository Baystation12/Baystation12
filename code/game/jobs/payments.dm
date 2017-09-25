proc/calculate_paycheck(var/mob/living/carbon/human/M, var/roundend = 0) //Tax = if we should calculate taxes, add if we want to add the cash.
	if(M && istype(M) && M.client && M.CharRecords.char_department && M.job) //SO MANY CHECKS JEZUS ah well
		var/paycheck = round(get_base_pay(M) * 4, 0.01)
		if(evacuation_controller.emergency_evacuation)
			paycheck = paycheck/100*80
		if(roundend)
			var/mins = round((round_duration_in_ticks % 36000) / 600)
			var/deduct = (paycheck/60)*(60 % mins)
			paycheck -= deduct
		if(M.CharRecords.permadeath)
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
		var/speciesmodifier = get_species_modifier(M)
		var/end_base_pay = (base_pay/100) * (100+efficiencybonus+rankbonus+speciesmodifier) // Turns 1% into more %
		return end_base_pay


/*=============================
==Species modifiers give small pay bonuses in specific departments
==based on how much NT likes them, how much they want the species to work there
==for example, Unathi is a combat-based species, so NT may prefer them in security
==since they can take a beating more.
=============================*/
proc/get_species_modifier(var/mob/living/carbon/human/M)
	if(M && M.species)
		var/bonuspercentage = 0
		switch(M.species.name)
			if("Vat-Grown Human")
				bonuspercentage -= 20
			if(SPECIES_HUMAN)
				if(M.CharRecords.char_department & COM)
					bonuspercentage += 10
			if(SPECIES_RESOMI)
				bonuspercentage -= 10
				if(M.CharRecords.char_department & ENG)
					bonuspercentage += 10
				if(M.CharRecords.char_department & SCI)
					bonuspercentage += 5
				if(M.CharRecords.char_department & SEC)
					bonuspercentage -= 10
			if(SPECIES_TAJARA)
				bonuspercentage -= 10
				if(M.CharRecords.char_department & ENG)
					bonuspercentage += 10
				if(M.CharRecords.char_department & SCI)
					bonuspercentage += 5
				if(M.CharRecords.char_department & COM)
					bonuspercentage -= 10
				if(M.CharRecords.char_department & MED)
					bonuspercentage -= 5
			if(SPECIES_DIONA)
				bonuspercentage -= 15
				if(M.CharRecords.char_department & SCI)
					bonuspercentage += 5
				if(M.CharRecords.char_department & SRV|CIV)
					bonuspercentage -= 10
			if(SPECIES_VOX)
				bonuspercentage -= 10
				if(M.CharRecords.char_department & ENG)
					bonuspercentage += 10
				if(M.CharRecords.char_department & SEC)
					bonuspercentage += 5
				if(M.CharRecords.char_department & COM)
					bonuspercentage -= 10
				if(M.CharRecords.char_department & MED)
					bonuspercentage -= 10
			if(SPECIES_IPC)
				bonuspercentage -= 15
			if(SPECIES_UNATHI)
				if(M.CharRecords.char_department & SEC)
					bonuspercentage += 10
				if(M.CharRecords.char_department & MED)
					bonuspercentage -= 5
			if(SPECIES_SKRELL)
				bonuspercentage += 5
				if(M.CharRecords.char_department & SCI)
					bonuspercentage += 10
				if(M.CharRecords.char_department & MED)
					bonuspercentage += 5
				if(M.CharRecords.char_department & SEC)
					bonuspercentage -= 5
		return bonuspercentage