datum/preferences/proc/contentGenericRecord()
	var/data = {"

		<html><body>

		<nav class='vNav'>
		<ul>
		<li><a href='?src=\ref[src];page=1'>Character</a>
		<li><a href='?src=\ref[src];page=2'>Occupation</a>
		<li><a href='?src=\ref[src];page=3'>Loadout</a>
		<li><a href='?src=\ref[src];page=4'>Local Preferences</a>
		<li><hr>
		<li><a class='active' href='?src=\ref[src];page=9'>Records</a>
		<li><hr>
		<li><a href='?src=\ref[src];page=8'>Global Preferences</a>
		</ul>
		</nav>

		<nav class='hNav'>
		<ul>
		<li><a href='?src=\ref[src];save=1'>Save</a>
		<li><a href='?src=\ref[src];load=1'>Load</a>
		<li><a href='?src=\ref[src];delete=1'>Reset</a>
		<li><a href='?src=\ref[src];lock=1'>Lock</a>
		</ul>
		</nav>

		<div class='main'> "}
	data += "<b>Background Information</b><br>"
	data += "[GLOB.using_map.company_name] Relation: <a href='?src=\ref[src];nt_relation=1'>[nanotrasen_relation]</a><br/>"
	if(char_lock)
		data += "Home System: [home_system]<br/>"
		data += "Citizenship: [citizenship]<br/>"
	else
		data += "Home System: <a href='?src=\ref[src];home_system=1'>[home_system]</a><br/>"
		data += "Citizenship: <a href='?src=\ref[src];citizenship=1'>[citizenship]</a><br/>"

	data += "Faction: <a href='?src=\ref[src];faction=1'>[faction]</a><br/>"
	data += "Religion: <a href='?src=\ref[src];religion=1'>[religion]</a><br/>"

	data += "<br/><b>Records</b>:<br/>"
	if(jobban_isbanned(user, "Records"))
		data += "<span class='danger'>You are banned from using character records.</span><br>"
	else
		if(char_lock)
			data += "Medical Records:<br>"
			data += "[TextPreview(med_record,40)]<br><br>"
			data += "Employment Records:<br>"
			data += "[TextPreview(gen_record,40)]<br><br>"
			data += "Security Records:<br>"
			data += "[TextPreview(sec_record,40)]<br>"
		else
			data += "Medical Records:<br>"
			data += "<a href='?src=\ref[src];set_medical_records=1'>[TextPreview(med_record,40)]</a><br><br>"
			data += "Employment Records:<br>"
			data += "<a href='?src=\ref[src];set_general_records=1'>[TextPreview(gen_record,40)]</a><br><br>"
			data += "Security Records:<br>"
			data += "<a href='?src=\ref[src];set_security_records=1'>[TextPreview(sec_record,40)]</a><br>"


	data += {"

		</div>

		<div class='secondary'>
		</div>

		<div class='background'>
		</div>

		</body></html>

		"}

	return data

/datum/preferences/proc/Topic9(var/href, var/list/href_list)

	if(href_list["page"])
		selected_menu = text2num(href_list["page"])

	else if(href_list["nt_relation"])
		var/new_relation = input(user, "Choose your relation to [GLOB.using_map.company_name]. Note that this represents what others can find out about your character by researching your background, not what your character actually thinks.", "Character Preference", nanotrasen_relation)  as null|anything in COMPANY_ALIGNMENTS
		if(new_relation && CanUseTopic(user))
			nanotrasen_relation = new_relation

	else if(href_list["home_system"])
		var/choice = input(user, "Please choose a home system.", "Character Preference", home_system) as null|anything in home_system_choices + list("Unset","Other")
		if(!choice || !CanUseTopic(user))
			return
		if(choice == "Other")
			var/raw_choice = sanitize(input(user, "Please enter a home system.", "Character Preference")  as text|null, MAX_NAME_LEN)
			if(raw_choice && CanUseTopic(user))
				home_system = raw_choice
		else
			home_system = choice

	else if(href_list["citizenship"])
		var/choice = input(user, "Please choose your current citizenship.", "Character Preference", citizenship) as null|anything in citizenship_choices + list("None","Other")
		if(!choice || !CanUseTopic(user))
			return
		if(choice == "Other")
			var/raw_choice = sanitize(input(user, "Please enter your current citizenship.", "Character Preference") as text|null, MAX_NAME_LEN)
			if(raw_choice && CanUseTopic(user))
				citizenship = raw_choice
		else
			citizenship = choice


	else if(href_list["faction"])
		var/choice = input(user, "Please choose a faction to work for.", "Character Preference", faction) as null|anything in faction_choices + list("None","Other")
		if(!choice || !CanUseTopic(user))
			return
		if(choice == "Other")
			var/raw_choice = sanitize(input(user, "Please enter a faction.", "Character Preference")  as text|null, MAX_NAME_LEN)
			if(raw_choice)
				faction = raw_choice
		else
			faction = choice


	else if(href_list["religion"])
		var/choice = input(user, "Please choose a religion.", "Character Preference", religion) as null|anything in religion_choices + list("None","Other")
		if(!choice || !CanUseTopic(user))
			return
		if(choice == "Other")
			var/raw_choice = sanitize(input(user, "Please enter a religon.", "Character Preference")  as text|null, MAX_NAME_LEN)
			if(raw_choice)
				religion = sanitize(raw_choice)
		else
			religion = choice


	else if(href_list["set_medical_records"])
		var/new_medical = sanitize(input(user,"Enter medical information here.","Character Preference", html_decode(med_record)) as message|null, MAX_PAPER_MESSAGE_LEN, extra = 0)
		if(!isnull(new_medical) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			med_record = new_medical

	else if(href_list["set_general_records"])
		var/new_general = sanitize(input(user,"Enter employment information here.","Character Preference", html_decode(gen_record)) as message|null, MAX_PAPER_MESSAGE_LEN, extra = 0)
		if(!isnull(new_general) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			gen_record = new_general


	else if(href_list["set_security_records"])
		var/sec_medical = sanitize(input(user,"Enter security information here.","Character Preference", html_decode(sec_record)) as message|null, MAX_PAPER_MESSAGE_LEN, extra = 0)
		if(!isnull(sec_medical) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			sec_record = sec_medical

