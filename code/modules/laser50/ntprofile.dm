/datum/ntprofile
	var/mob/living/carbon/human/owner
	var/client/clientowner
/*-------DEPARTMENT-RELATED-------*/
	var/char_department = SRV
	var/department_playtime
	var/department_experience
	var/department_rank
/*-------CHARACTER-RELATED-------*/
	var/bank_balance
	var/pension_balance
	var/bonuscredit = 0
	var/employeescore = 5 //Calculated at run-time.
	var/list/employee_records = list()
	var/neurallaces
	var/promoted //May be obselete.
	var/permadeath
/*--------OTHER-RELATED--------*/

/datum/ntprofile/New(var/mob/living/carbon/human/H) //Init the profile.. Human set as owner.
	if(H && H.client)
		owner = H //Assign Owner..
		clientowner = H.client
		load_persistent() //Load persistent info.
		load_score()

/datum/ntprofile/proc/load_persistent()
	if(owner && clientowner) //Must be valid.
		if(!clientowner.prefs.loaded_character)	return 0 //ERROR Fuck this shit
		var/savefile/S = clientowner.prefs.loaded_character
		S["char_department"]		>> char_department
		S["department_playtime"]	>> department_playtime
		S["dept_experience"]		>> department_experience
		S["bank_balance"]			>> bank_balance
		S["department_rank"]		>> department_rank
		S["pension_balance"]		>> pension_balance
		S["permadeath"]				>> permadeath
		S["neurallaces"]			>> neurallaces
		S["employee_records"]		>> employee_records
		S["promotion"]				>> promoted
		S["bonuscredit"]			>> bonuscredit

/datum/ntprofile/proc/save_persistent()
	if(owner && clientowner) //Must be valid.
		if(!clientowner.prefs.loaded_character)	return 0 //ERROR Fuck this shit
		var/savefile/S = clientowner.prefs.loaded_character
		S["char_department"]		<< char_department
		S["department_playtime"]	<< department_playtime
		S["dept_experience"]		<< department_experience
		S["bank_balance"]			<< bank_balance
		S["department_rank"]		<< department_rank
		S["pension_balance"]		<< pension_balance
		S["permadeath"]				<< permadeath
		S["neurallaces"]			<< neurallaces
		S["employee_records"]		<< employee_records
		S["promotion"]				<< promoted
		S["bonuscredit"]			<< bonuscredit

/datum/ntprofile/proc/load_score()
	if(!owner || !employee_records)	return 5
	var/totalscore = 0
	var/counter = 0
	for(var/datum/ntprofile/employeerecord/N in employee_records)
		N.recomscore += totalscore
		counter++
	employeescore = totalscore/counter
	return employeescore

/datum/ntprofile/employeerecord
	var/mob/living/carbon/human/maker = ""       //The maker of the Recommendation
	var/note = "" //The note to add.
	var/recomscore = 0        // The score (1-10) we apply to the overall NT score
	var/warrantspromotion = 0 //If this is enough to warrant a promotion, EG from regular to senior roles.
	var/paybonuspercent = 0   //The percentage of extra hourly pay this will give the reciever
	var/paybonuscredit = 0    //The amount of credits recieved on the next paycheck.
	var/nanotrasen = 0        //Is this an official NanoTrasen Recommendation? (Adds a little checkmark?)
	/*Recommendations are checked every paycheck, bonus credit that is outstanding (not 0) will be paid out*/

/datum/ntprofile/proc/add_employeerecord(var/recommaker, var/note, var/recomscore, var/warrantspromotion, var/paybonuspercent, var/paybonuscredit, var/nanotrasen)
	if(recommaker && note) //The 2 main dawgs
//		var/mob/living/carbon/human/Maker = recommaker
		var/datum/ntprofile/employeerecord/record = new(recommaker, note, recomscore, warrantspromotion, paybonuspercent, paybonuscredit, nanotrasen)
		if(record)
			employee_records.Add(record)
			load_score() //Re-load the score, reset the average.

/*		if(nanotrasen)
			employee_records.Add("NOTE: NanoTrasen (OFFICIAL) -- [note] (S: [recomscore]")
			calculate_bonus_credit(owner, paybonuscredit, paybonuspercent)
		else
			employee_records.Add("NOTE: [Maker] ([Maker.job]) -- [note] (S: [recomscore]")
			calculate_bonus_credit(owner, paybonuscredit, paybonuspercent)
*/
/*
/datum/ntprofile/proc/add_recommendation(var/maker, var/reason)
	if(!maker || !reason)	return
	if(!recommendations)
		recommendations = list()
	recommendations.Add(name = "[maker]", reason = "[reason]")
*/