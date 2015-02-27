/mob/living/carbon/human
	var/list/datum/addiction/addictions = list() // No addicted monkeys, mice, or cyborgs

/mob/living/carbon/human/proc/addict(var/ad_type, var/dose)
	for(var/datum/addiction/A in addictions)
		if(istype(A, ad_type))
			A.give_dose(dose)
			return
	var/datum/addiction/AD = new ad_type()
	AD.give_dose(dose)
	AD.owner = src
	addictions += AD
	return

/mob/living/carbon/human/proc/heal_addict(var/ad_type, var/healing, var/dose_red)
	for(var/datum/addiction/A in addictions)
		if(istype(A, ad_type))
			A.give_medicine(healing, dose_red)
			return

/datum/addiction
	var/mob/living/carbon/human/owner = null

	var/name = "Addiction"
	var/list/stage_dose = list(0)
	var/recover_level = 0 // How far into withdrawal mob needs to be to start recovering
	var/recover_speed = 0 // How quickly mob is healed of it if he's not taking the drug

	var/total_dose = 0 // How far we are, in (reagent units * reagent strength)
	var/healing_progress = 0
	var/stage = 0 // Previous two vars combined
	var/withdrawal = 0 // How far into withdrawal we are, in ticks

/datum/addiction/proc/process() // Fired every tick
	update_stage()
	++withdrawal
	if(withdrawal > recover_level)
		if(stage > 0)
			withdrawal_act()
		healing_progress += recover_speed
	else if(stage > 0)
		stage_act()
	if(healing_progress >= total_dose) // Congratulations!
		heal_act()
		total_dose = 0 // Let's not delete it for the logging purposes. Maybe make it easier to re-addict in the future.
	return

/datum/addiction/proc/update_stage()
	var/t = stage_dose.len
	stage = 0
	for(var/i = 1 to t)
		if(total_dose > stage_dose[i])
			stage = i
	return

/datum/addiction/proc/give_dose(var/dose) // Called by the reagent to show that addiction is worsened
	total_dose += dose
	withdrawal = 0

/datum/addiction/proc/give_medicine(var/healing, var/dose_red) // Called by the reagent to show that addiction is lessened
	healing_progress += healing
	total_dose -= dose_red

/datum/addiction/proc/withdrawal_act()
	return

/datum/addiction/proc/stage_act()
	return

/datum/addiction/proc/heal_act()
	return

/datum/addiction/alcohol
	name = "Alcohol addiction"
	stage_dose = list(100, 400, 600, 800, 1000)
	recover_level = 900 // 900 ticks ~ 1800 seconds ~ 30 minutes without drinking
	recover_speed = 1

/datum/addiction/alcohol/withdrawal_act()
	if(stage == 1 && prob(1))
		owner << "<span class='warning'>You have a light headache.</span>"
	if(stage == 2 && prob(1))
		owner << "<span class='warning'>You have a headache.</span>"
	if(stage >= 3 && prob(1))
		owner << "<span class='danger'>You have a severe headache!</span>"
	if(stage >= 2 && prob(1))
		owner << "<span class='warning'>You start sweating.</span>"
	if(stage >= 3 && prob(1))
		owner << "<span class='warning'>You feel anxious.</span>"
	if(stage >= 4 && prob(1))
		owner << "<span class='danger'>Your hands start shaking uncontrollably!</span>"
		owner.drop_item()
	if(stage >= 4 && prob(1))
		owner << "<span class='warning'>You feel nauseous...</span>"
	if(stage == 5 && prob(1))
		owner << "<span class='danger'>You suddenly feel weak.</span>"
		owner.Weaken(5)
	if(stage == 5 && prob(1))
		owner.vomit()