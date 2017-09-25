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
	var/recommendations = list()
	var/neurallaces
	var/promoted //May be obselete.
	var/permadeath

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
/*
/datum/ntprofile/proc/add_recommendation(var/maker, var/reason)
	if(!maker || !reason)	return
	if(!recommendations)
		recommendations = list()
	recommendations.Add(name = "[maker]", reason = "[reason]")
*/