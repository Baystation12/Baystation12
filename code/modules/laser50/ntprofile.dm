/datum/ntprofile
	var/mob/living/carbon/human/owner
	var/client/clientowner
/*-------DEPARTMENT-RELATED-------*/
	var/char_department
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
		S["recommendations"]		>> recommendations
		S["promotion"]				>> promoted

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
		S["recommendations"]		<< recommendations
		S["promotion"]				<< promoted



/datum/ntprofile/recommendation
	var/mob/living/carbon/human/recommaker = ""       //The maker of the Recommendation
	var/mob/living/carbon/human/recomfor = ""         //The reason they have been recommended
	var/recomscore = 0        // The score we assign to it, 3 score needed to be head eligible.
	var/warrantspromotion = 0 //If this is enough to warrant a promotion, EG from regular to senior roles.
	var/paybonuspercent = 0   //The percentage of extra hourly pay this will give the reciever
	var/paybonuscredit = 0    //The amount of credits recieved on the next paycheck.
	var/nanotrasen = 0        //Is this an official NanoTrasen Recommendation? (Adds a little checkmark?)
	/*Recommendations are checked every paycheck, bonus credit that is outstanding (not 0) will be paid out*/

/datum/ntprofile/recommendation/proc/add_recommendation(var/recommaker, var/recomfor, var/recomscore, var/warrantspromotion, var/paybonuspercent, var/paybonuscredit, var/nanotrasen)
	if(recommaker && recomfor && recomcore) //The 3 main dawgs
		recommendations.Add({"Recommendation to [recomfor] ([recomfor.job]), Recieved by [recommaker] ([ismob(recommaker) ? [recommaker.job] : ])
		For [recomfor]. [nanotrasen ? "Official NanoTrasen Recommendation."]
		"})

/*
/datum/ntprofile/proc/add_recommendation(var/maker, var/reason)
	if(!maker || !reason)	return
	if(!recommendations)
		recommendations = list()
	recommendations.Add(name = "[maker]", reason = "[reason]")
*/