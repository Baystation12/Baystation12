/datum/unit_test/icon_test
	name = "ICON STATE template"

/datum/unit_test/icon_test/robots_shall_have_eyes_for_each_state
	name = "ICON STATE - Robot shall have eyes for each icon state"
	var/list/excepted_icon_states = list(
		"b1","b1+o","b2","b2+o","b3","b3+o","d1","d1+o","d2","d2+o","d3","d3+o",
		"floor1","floor2","floor3","floor4","floor5","floor6","floor7",
		"gib1","gib2","gib3","gib4","gib5","gib6","gib7",,"gibdown","gibup","gibbl1","gibarm","gibleg",
		"streak1","streak2","streak3","streak4","streak5",
		"spiderbot-chassis","spiderbot-chassis-posi","spiderbot-chassis-mmi","spiderbot-smashed",
		"droid-combat-roll","droid-combat-shield","emag","remainsrobot", "robot+o+c","robot+o-c","robot+we")

/datum/unit_test/icon_test/robots_shall_have_eyes_for_each_state/start_test()
	var/missing_states = 0
	var/icon_states = icon_states('icons/mob/robots.dmi')
	for(var/icon_state in icon_states)
		if(icon_state in excepted_icon_states)
			continue
		if(starts_with(icon_state, "eyes-"))
			continue
		if(findtext(icon_state, "openpanel"))
			continue
		var/eye_icon_state = "eyes-[icon_state]"
		if(!(eye_icon_state in icon_states))
			log_unit_test("Eye icon state [eye_icon_state] is missing.")
			missing_states++

	if(missing_states)
		fail("[missing_states] eye icon state\s [missing_states == 1 ? "is" : "are"] missing.")
	else
		pass("All related eye icon states exists.")
	return 1
