/datum/preferences
	var/public_record = ""
	var/med_record = ""
	var/sec_record = ""
	var/gen_record = ""
	var/memory = ""
	var/email_addr = ""
	var/email_pass = ""

/datum/category_item/player_setup_item/background/records
	name = "Records"
	sort_order = 3

/datum/category_item/player_setup_item/background/records/load_character(datum/pref_record_reader/R)
	pref.public_record = R.read("public_record")
	pref.med_record = R.read("med_record")
	pref.sec_record = R.read("sec_record")
	pref.gen_record = R.read("gen_record")
	pref.memory = R.read("memory")
	pref.email_addr = R.read("email_addr")
	pref.email_pass = R.read("email_pass")

/datum/category_item/player_setup_item/background/records/save_character(datum/pref_record_writer/W)
	W.write("public_record", pref.public_record)
	W.write("med_record", pref.med_record)
	W.write("sec_record", pref.sec_record)
	W.write("gen_record", pref.gen_record)
	W.write("memory", pref.memory)
	W.write("email_addr", pref.email_addr)
	W.write("email_pass", pref.email_pass)

/datum/category_item/player_setup_item/background/records/proc/allow_email_branch_check(datum/mil_branch/B)
	return B.allow_custom_email

/datum/category_item/player_setup_item/background/records/content(mob/user)
	. = list() 
	// [SIERRA-EDIT] - EXPANDED_CULTURE_DESCRIPTOR - Перевод
	// . += "<br><b>Records</b>:" // SIERRA-EDIT - ORIGINAL
	. += "<br><b>Записи</b>:"
	// [/SIERRA-EDIT]
	if (jobban_isbanned(user, "Records"))
		. += "[SPAN_WARNING("You are banned from using character records.")]"
	// [SIERRA-EDIT] - EXPANDED_CULTURE_DESCRIPTOR - Перевод
	// else  // SIERRA-EDIT - ORIGINAL
		// .+= TBTN("set_public_record", TextPreview(pref.public_record, 40), "Public") // SIERRA-EDIT - ORIGINAL
		// .+= TBTN("set_medical_records", TextPreview(pref.med_record, 40), "Medical") // SIERRA-EDIT - ORIGINAL
		// .+= TBTN("set_general_records", TextPreview(pref.gen_record, 40), "Employment") // SIERRA-EDIT - ORIGINAL
		// .+= TBTN("set_security_records", TextPreview(pref.sec_record, 40), "Security") // SIERRA-EDIT - ORIGINAL
		// .+= TBTN("set_memory", TextPreview(pref.memory, 40), "Memory") // SIERRA-EDIT - ORIGINAL
	// . += "<br><b>Other</b>:" // SIERRA-EDIT - ORIGINAL	
	// var/set_addr_button = TBTN("set_email_addr", pref.email_addr ? pref.email_addr : "(default)", "Email Address") // SIERRA-EDIT - ORIGINAL
	// var/list/branches = pref.for_each_selected_branch(new Callback(src, PROC_REF(allow_email_branch_check)) // SIERRA-EDIT - ORIGINAL
	// for (var/name in branches) // SIERRA-EDIT - ORIGINAL
		// set_addr_button += "  " + (branches[name] ? UI_FONT_GOOD(name) : UI_FONT_BAD(name)) // SIERRA-EDIT - ORIGINAL
	// . += set_addr_button // SIERRA-EDIT - ORIGINAL
	// . += TBTN("set_email_pass", pref.email_pass ? pref.email_pass : "(random)", "Email Password") // SIERRA-EDIT - ORIGINAL
	else
		.+= TBTN("set_public_record", TextPreview(pref.public_record, 40), "Публичные записи") 
		.+= TBTN("set_medical_records", TextPreview(pref.med_record, 40), "Записи здравоохранения")
		.+= TBTN("set_general_records", TextPreview(pref.gen_record, 40), "Записи трудоустройства")
		.+= TBTN("set_security_records", TextPreview(pref.sec_record, 40), "Записи защиты активов")
		.+= TBTN("set_memory", TextPreview(pref.memory, 40), "Воспоминания")
	. += "<br><b>Другое</b>:"
	var/set_addr_button = TBTN("set_email_addr", pref.email_addr ? pref.email_addr : "(стандартный)", "Почтовый адрес")
	var/list/branches = pref.for_each_selected_branch(new Callback(src, PROC_REF(allow_email_branch_check)))
	for (var/name in branches)
		set_addr_button += "  " + (branches[name] ? UI_FONT_GOOD(name) : UI_FONT_BAD(name))
	. += set_addr_button
	. += TBTN("set_email_pass", pref.email_pass ? pref.email_pass : "(случайный)", "Пароль от почты")
	// [/SIERRA-EDIT]
	. = jointext(., "<br>")

/datum/category_item/player_setup_item/background/records/OnTopic(href,list/href_list, mob/user)
	if (href_list["set_public_record"])
		// [SIERRA-EDIT] - EXPANDED_CULTURE_DESCRIPTOR - Перевод
		// var/new_public = sanitize(input(user,"Enter general public record information here.",CHARACTER_PREFERENCE_INPUT_TITLE, html_decode(pref.public_record)) as message|null, MAX_PAPER_MESSAGE_LEN, extra = 0) // SIERRA-EDIT - ORIGINAL
		var/new_public = sanitize(input(user,"Введите публично доступную информацию о персонаже.",CHARACTER_PREFERENCE_INPUT_TITLE, html_decode(pref.public_record)) as message|null, MAX_PAPER_MESSAGE_LEN, extra = 0)
		// [/SIERRA-EDIT]
		if (!isnull(new_public) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			pref.public_record = new_public
		return TOPIC_REFRESH

	else if(href_list["set_medical_records"])
		// [SIERRA-EDIT] - EXPANDED_CULTURE_DESCRIPTOR - Перевод
		// var/new_medical = sanitize(input(user,"Enter medical information here.",CHARACTER_PREFERENCE_INPUT_TITLE, html_decode(pref.med_record)) as message|null, MAX_PAPER_MESSAGE_LEN, extra = 0) // SIERRA-EDIT - ORIGINAL
		var/new_medical = sanitize(input(user,"Введите записи о персонаже для отдела здравоохранения.",CHARACTER_PREFERENCE_INPUT_TITLE, html_decode(pref.med_record)) as message|null, MAX_PAPER_MESSAGE_LEN, extra = 0)
		// [/SIERRA-EDIT]
		if(!isnull(new_medical) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			pref.med_record = new_medical
		return TOPIC_REFRESH

	else if(href_list["set_general_records"])
		// [SIERRA-EDIT] - EXPANDED_CULTURE_DESCRIPTOR - Перевод
		// var/new_general = sanitize(input(user,"Enter employment information here.",CHARACTER_PREFERENCE_INPUT_TITLE, html_decode(pref.gen_record)) as message|null, MAX_PAPER_MESSAGE_LEN, extra = 0) // SIERRA-EDIT - ORIGINAL
		var/new_general = sanitize(input(user,"Введите записи по трудоустройству персонажа.",CHARACTER_PREFERENCE_INPUT_TITLE, html_decode(pref.gen_record)) as message|null, MAX_PAPER_MESSAGE_LEN, extra = 0)
		// [/SIERRA-EDIT]
		if(!isnull(new_general) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			pref.gen_record = new_general
		return TOPIC_REFRESH

	else if(href_list["set_security_records"])
		// [SIERRA-EDIT] - EXPANDED_CULTURE_DESCRIPTOR - Перевод
		// var/sec_medical = sanitize(input(user,"Enter security information here.",CHARACTER_PREFERENCE_INPUT_TITLE, html_decode(pref.sec_record)) as message|null, MAX_PAPER_MESSAGE_LEN, extra = 0) // SIERRA-EDIT - ORIGINAL
		var/sec_medical = sanitize(input(user,"Введите записи отдела защиты активов о персонаже.",CHARACTER_PREFERENCE_INPUT_TITLE, html_decode(pref.sec_record)) as message|null, MAX_PAPER_MESSAGE_LEN, extra = 0)
		// [/SIERRA-EDIT]
		if(!isnull(sec_medical) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			pref.sec_record = sec_medical
		return TOPIC_REFRESH

	else if(href_list["set_memory"])
		// [SIERRA-EDIT] - EXPANDED_CULTURE_DESCRIPTOR - Перевод
		// var/memes = sanitize(input(user,"Enter memorized information here.",CHARACTER_PREFERENCE_INPUT_TITLE, html_decode(pref.memory)) as message|null, MAX_PAPER_MESSAGE_LEN, extra = 0) // SIERRA-EDIT - ORIGINAL
		var/memes = sanitize(input(user,"Введите информацию, которая хранится в памяти персонажа.",CHARACTER_PREFERENCE_INPUT_TITLE, html_decode(pref.memory)) as message|null, MAX_PAPER_MESSAGE_LEN, extra = 0)
		// [/SIERRA-EDIT]
		if(!isnull(memes) && CanUseTopic(user))
			pref.memory = memes
		return TOPIC_REFRESH

	else if (href_list["set_email_pass"])
		// [SIERRA-EDIT] - EXPANDED_CULTURE_DESCRIPTOR - Перевод
		// var/value = input(user, "Enter email password:", "Email Password", pref.email_pass) as text // SIERRA-EDIT - ORIGINAL
		var/value = input(user, "Введите пароль для почты:", "Email Password", pref.email_pass) as text
		// [/SIERRA-EDIT]
		if (isnull(value) || !CanUseTopic(user))
			return TOPIC_NOACTION
		if (value != "")
			var/clean = sanitize(value)
			var/chars = length(clean)
			if (chars < 4 || chars > 16)
				// [SIERRA-EDIT] - EXPANDED_CULTURE_DESCRIPTOR - Перевод
				// to_chat(user, SPAN_WARNING("Invalid Email Password '[clean]': must be 4..16 safe glyphs.")) // SIERRA-EDIT - ORIGINAL
				to_chat(user, SPAN_WARNING("Неподходящий пароль '[clean]': пароль должен содержать 4..16 символов."))
				// [/SIERRA-EDIT]
				return TOPIC_NOACTION
			value = clean
		pref.email_pass = value
		return TOPIC_REFRESH

	else if (href_list["set_email_addr"])
		// [SIERRA-EDIT] - EXPANDED_CULTURE_DESCRIPTOR - Перевод
		// var/value = input(user, "Enter email username:", "Email Address", pref.email_addr) as text // SIERRA-EDIT - ORIGINAL
		var/value = input(user, "Введите логин для почты:", "Email Address", pref.email_addr) as text 
		// [/SIERRA-EDIT]
		if (isnull(value) || !CanUseTopic(user))
			return TOPIC_NOACTION
		if (value != "")
			var/clean = sanitize_for_email(value)
			var/chars = length(clean)
			if (chars < 4 || chars > 24)
				// [SIERRA-EDIT] - EXPANDED_CULTURE_DESCRIPTOR - Перевод
				// to_chat(user, SPAN_WARNING("Invalid Email Username '[clean]': must be 4..24 glyphs from /a-z0-9./")) // SIERRA-EDIT - ORIGINAL
				to_chat(user, SPAN_WARNING("Неподходящий логин '[clean]': логин должен содержать 4..24 символов /a-z0-9./")) 
				// [/SIERRA-EDIT]
				return TOPIC_NOACTION
			value = clean
		pref.email_addr = value
		return TOPIC_REFRESH

	. =  ..()
