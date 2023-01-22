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

	. += "<br><b>Records</b>:"
	if (jobban_isbanned(user, "Records"))
		. += "[SPAN_WARNING("You are banned from using character records.")]"
	else
		.+= TBTN("set_public_record", TextPreview(pref.public_record, 40), "Public")
		.+= TBTN("set_medical_records", TextPreview(pref.med_record, 40), "Medical")
		.+= TBTN("set_general_records", TextPreview(pref.gen_record, 40), "Employment")
		.+= TBTN("set_security_records", TextPreview(pref.sec_record, 40), "Security")
		.+= TBTN("set_memory", TextPreview(pref.memory, 40), "Memory")

	. += "<br><b>Other</b>:"
	var/set_addr_button = TBTN("set_email_addr", pref.email_addr ? pref.email_addr : "(default)", "Email Address")
	var/list/branches = pref.for_each_selected_branch(CALLBACK(src, .proc/allow_email_branch_check))
	for (var/name in branches)
		set_addr_button += "  " + (branches[name] ? UI_FONT_GOOD(name) : UI_FONT_BAD(name))
	. += set_addr_button

	. += TBTN("set_email_pass", pref.email_pass ? pref.email_pass : "(random)", "Email Password")
	. = jointext(., "<br>")

/datum/category_item/player_setup_item/background/records/OnTopic(var/href,var/list/href_list, var/mob/user)
	if (href_list["set_public_record"])
		var/new_public = sanitize(input(user,"Enter general public record information here.",CHARACTER_PREFERENCE_INPUT_TITLE, html_decode(pref.public_record)) as message|null, MAX_PAPER_MESSAGE_LEN, extra = 0)
		if (!isnull(new_public) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			pref.public_record = new_public
		return TOPIC_REFRESH

	else if(href_list["set_medical_records"])
		var/new_medical = sanitize(input(user,"Enter medical information here.",CHARACTER_PREFERENCE_INPUT_TITLE, html_decode(pref.med_record)) as message|null, MAX_PAPER_MESSAGE_LEN, extra = 0)
		if(!isnull(new_medical) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			pref.med_record = new_medical
		return TOPIC_REFRESH

	else if(href_list["set_general_records"])
		var/new_general = sanitize(input(user,"Enter employment information here.",CHARACTER_PREFERENCE_INPUT_TITLE, html_decode(pref.gen_record)) as message|null, MAX_PAPER_MESSAGE_LEN, extra = 0)
		if(!isnull(new_general) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			pref.gen_record = new_general
		return TOPIC_REFRESH

	else if(href_list["set_security_records"])
		var/sec_medical = sanitize(input(user,"Enter security information here.",CHARACTER_PREFERENCE_INPUT_TITLE, html_decode(pref.sec_record)) as message|null, MAX_PAPER_MESSAGE_LEN, extra = 0)
		if(!isnull(sec_medical) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			pref.sec_record = sec_medical
		return TOPIC_REFRESH

	else if(href_list["set_memory"])
		var/memes = sanitize(input(user,"Enter memorized information here.",CHARACTER_PREFERENCE_INPUT_TITLE, html_decode(pref.memory)) as message|null, MAX_PAPER_MESSAGE_LEN, extra = 0)
		if(!isnull(memes) && CanUseTopic(user))
			pref.memory = memes
		return TOPIC_REFRESH

	else if (href_list["set_email_pass"])
		var/value = input(user, "Enter email password:", "Email Password", pref.email_pass) as text
		if (isnull(value) || !CanUseTopic(user))
			return TOPIC_NOACTION
		if (value != "")
			var/clean = sanitize(value)
			var/chars = length(clean)
			if (chars < 4 || chars > 16)
				to_chat(user, SPAN_WARNING("Invalid Email Password '[clean]': must be 4..16 safe glyphs."))
				return TOPIC_NOACTION
			value = clean
		pref.email_pass = value
		return TOPIC_REFRESH

	else if (href_list["set_email_addr"])
		var/value = input(user, "Enter email username:", "Email Address", pref.email_addr) as text
		if (isnull(value) || !CanUseTopic(user))
			return TOPIC_NOACTION
		if (value != "")
			var/clean = sanitize_for_email(value)
			var/chars = length(clean)
			if (chars < 4 || chars > 24)
				to_chat(user, SPAN_WARNING("Invalid Email Username '[clean]': must be 4..24 glyphs from /a-z0-9./"))
				return TOPIC_NOACTION
			value = clean
		pref.email_addr = value
		return TOPIC_REFRESH

	. =  ..()
