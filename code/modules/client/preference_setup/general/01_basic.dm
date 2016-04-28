datum/preferences
	var/sex = MALE					//gender of character (well duh)

/datum/category_item/player_setup_item/general/basic
	name = "Basic"
	sort_order = 1

/datum/category_item/player_setup_item/general/basic/load_character(var/savefile/S)
	S["real_name"]				>> pref.real_name
	S["name_is_always_random"]	>> pref.be_random_name
	S["sex"]					>> pref.sex
	S["gender"]					>> pref.gender
	S["age"]					>> pref.age
	S["spawnpoint"]				>> pref.spawnpoint
	S["OOC_Notes"]				>> pref.metadata

/datum/category_item/player_setup_item/general/basic/save_character(var/savefile/S)
	S["real_name"]				<< pref.real_name
	S["name_is_always_random"]	<< pref.be_random_name
	S["sex"]					<< pref.sex
	S["gender"]					<< pref.gender
	S["age"]					<< pref.age
	S["spawnpoint"]				<< pref.spawnpoint
	S["OOC_Notes"]				<< pref.metadata

/datum/category_item/player_setup_item/general/basic/sanitize_character()
	var/datum/species/S = all_species[pref.species ? pref.species : "Human"]
	pref.age                = sanitize_integer(pref.age, S.min_age, S.max_age, initial(pref.age))
	pref.sex             = sanitize_inlist(pref.sex, S.sexes, pick(S.sexes))
	pref.gender			= sanitize_inlist(pref.gender, S.genders, S.genders[1])
	pref.real_name          = sanitize_name(pref.real_name, pref.species)
	if(!pref.real_name)
		if (S.allow_genders)
			pref.real_name      = random_name(pick_gender(pref.gender, pref.sex), pref.species)
		else
			pref.real_name = random_name(pref.sex, pref.species)
	pref.spawnpoint         = sanitize_inlist(pref.spawnpoint, spawntypes, initial(pref.spawnpoint))
	pref.be_random_name     = sanitize_integer(pref.be_random_name, 0, 1, initial(pref.be_random_name))

/datum/category_item/player_setup_item/general/basic/content()
	var/datum/species/S = all_species[pref.species ? pref.species : "Human"]
	. = "<b>Name:</b> "
	. += "<a href='?src=\ref[src];rename=1'><b>[pref.real_name]</b></a><br>"
	. += "(<a href='?src=\ref[src];random_name=1'>Random Name</A>) "
	. += "(<a href='?src=\ref[src];always_random_name=1'>Always Random Name: [pref.be_random_name ? "Yes" : "No"]</a>)"
	. += "<br>"
	. += "<b>Sex:</b> <a href='?src=\ref[src];sex=1'><b>[sex2text(pref.sex)]</b></a><br>"
	. += "<b>Gender:</b> [S.allow_genders ? "<a href='?src=\ref[src];gender=1'><b>[gender2text(pref.gender, pref.sex)]</b></a>" : "N/A"]<br>"
	. += "<b>Age:</b> <a href='?src=\ref[src];age=1'>[pref.age]</a><br>"
	. += "<b>Spawn Point</b>: <a href='?src=\ref[src];spawnpoint=1'>[pref.spawnpoint]</a><br>"
	if(config.allow_Metadata)
		. += "<b>OOC Notes:</b> <a href='?src=\ref[src];metadata=1'> Edit </a><br>"

/datum/category_item/player_setup_item/general/basic/OnTopic(var/href,var/list/href_list, var/mob/user)
	var/datum/species/S = all_species[pref.species]
	if(href_list["rename"])
		var/raw_name = input(user, "Choose your character's name:", "Character Name")  as text|null
		if (!isnull(raw_name) && CanUseTopic(user))
			var/new_name = sanitize_name(raw_name, pref.species)
			if(new_name)
				pref.real_name = new_name
				return TOPIC_REFRESH
			else
				user << "<span class='warning'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</span>"
				return TOPIC_NOACTION

	else if(href_list["random_name"])
		if (pref.gender == "Opposite" || istype(pref.gender, /datum/gender))
			pref.real_name = random_name(pick_gender(pref.gender, pref.sex), pref.species)
		else
			pref.real_name = random_name(pref.sex, pref.species)
		return TOPIC_REFRESH

	else if(href_list["always_random_name"])
		pref.be_random_name = !pref.be_random_name
		return TOPIC_REFRESH

	else if(href_list["sex"])
		var/new_sex = input(user, "Choose your character's biological gender:", "Character Preference", pref.sex) as null|anything in S.sexes
		if(new_sex && CanUseTopic(user))
			pref.sex = new_sex
		return TOPIC_REFRESH

	else if(href_list["gender"])
		var/new_gender = input(user, "Choose your character's identity gender:", "Character Preference", pref.gender) as null|anything in S.genders
		if(new_gender && S.allow_genders && CanUseTopic(user))
			pref.gender = new_gender
		else
			pref.gender = gender2text(-1)
		return TOPIC_REFRESH

	else if(href_list["age"])
		var/new_age = input(user, "Choose your character's age:\n([S.min_age]-[S.max_age])", "Character Preference", pref.age) as num|null
		if(new_age && CanUseTopic(user))
			pref.age = max(min(round(text2num(new_age)), S.max_age), S.min_age)
			return TOPIC_REFRESH

	else if(href_list["spawnpoint"])
		var/list/spawnkeys = list()
		for(var/spawntype in spawntypes)
			spawnkeys += spawntype
		var/choice = input(user, "Where would you like to spawn when late-joining?") as null|anything in spawnkeys
		if(!choice || !spawntypes[choice] || !CanUseTopic(user))	return TOPIC_NOACTION
		pref.spawnpoint = choice
		return TOPIC_REFRESH

	else if(href_list["metadata"])
		var/new_metadata = sanitize(input(user, "Enter any information you'd like others to see, such as Roleplay-preferences:", "Game Preference" , pref.metadata)) as message|null
		if(new_metadata && CanUseTopic(user))
			pref.metadata = sanitize(new_metadata)
			return TOPIC_REFRESH

	return ..()
