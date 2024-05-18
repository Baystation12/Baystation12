/obj/item/card/id/syndicate
	assignment = "Agent"
	origin_tech = list(TECH_ESOTERIC = 3)
	var/electronic_warfare = 1
	var/mob/registered_user = null
	color = COLOR_GRAY40
	detail_color = COLOR_NT_RED

/obj/item/card/id/syndicate/New(mob/user as mob)
	..()
	access = syndicate_access.Copy()

/obj/item/card/id/syndicate/station_access/New()
	..() // Same as the normal Syndicate id, only already has all station access
	access |= get_all_station_access()

/obj/item/card/id/syndicate/Destroy()
	unset_registered_user(registered_user)
	return ..()

/obj/item/card/id/syndicate/prevent_tracking()
	return electronic_warfare

/obj/item/card/id/syndicate/use_after(atom/O, mob/living/user, click_parameters)
	if(istype(O, /obj/item/card/id))
		var/obj/item/card/id/I = O
		access |= I.access
		if(player_is_antag(user.mind))
			to_chat(user, SPAN_NOTICE("The microscanner activates as you pass it over the ID, copying its access."))
		return TRUE

/obj/item/card/id/syndicate/attack_self(mob/user as mob)
	// We use the fact that registered_name is not unset should the owner be vaporized, to ensure the id doesn't magically become unlocked.
	if(!registered_user && register_user(user))
		to_chat(user, SPAN_NOTICE("The microscanner marks you as its owner, preventing others from accessing its internals."))
	if(registered_user == user)
		switch(alert("Would you like edit the ID, or show it?","Show or Edit?", "Edit","Show"))
			if("Edit")
				ui_interact(user)
			if("Show")
				..()
	else
		..()

/obj/item/card/id/syndicate/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1)
	var/data[0]
	var/entries[0]
	entries[LIST_PRE_INC(entries)] = list("name" = "Age", 				"value" = age)
	entries[LIST_PRE_INC(entries)] = list("name" = "Prefix", 			"value" = formal_name_prefix)
	entries[LIST_PRE_INC(entries)] = list("name" = "Suffix", 			"value" = formal_name_suffix)
	entries[LIST_PRE_INC(entries)] = list("name" = "Appearance",		"value" = "Set")
	entries[LIST_PRE_INC(entries)] = list("name" = "Assignment",		"value" = assignment)
	if(GLOB.using_map.flags & MAP_HAS_BRANCH)
		entries[LIST_PRE_INC(entries)] = list("name" = "Branch",		"value" = military_branch ? military_branch.name : "N/A")
	if(military_branch && (GLOB.using_map.flags & MAP_HAS_RANK))
		entries[LIST_PRE_INC(entries)] = list("name" = "Rank",			"value" = military_rank ? military_rank.name : "N/A")
	entries[LIST_PRE_INC(entries)] = list("name" = "Blood Type",		"value" = blood_type)
	entries[LIST_PRE_INC(entries)] = list("name" = "DNA Hash", 			"value" = dna_hash)
	entries[LIST_PRE_INC(entries)] = list("name" = "Fingerprint Hash",	"value" = fingerprint_hash)
	entries[LIST_PRE_INC(entries)] = list("name" = "Name", 				"value" = registered_name)
	entries[LIST_PRE_INC(entries)] = list("name" = "Photo", 			"value" = "Update")
	entries[LIST_PRE_INC(entries)] = list("name" = "Sex", 				"value" = sex)
	entries[LIST_PRE_INC(entries)] = list("name" = "Factory Reset",		"value" = "Use With Care")
	data["electronic_warfare"] = electronic_warfare
	data["entries"] = entries

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "agent_id_card.tmpl", "Agent id", 600, 400)
		ui.set_initial_data(data)
		ui.open()

/obj/item/card/id/syndicate/proc/register_user(mob/user)
	if(!istype(user) || user == registered_user)
		return FALSE
	unset_registered_user()
	registered_user = user
	user.set_id_info(src)
	GLOB.destroyed_event.register(user, src, TYPE_PROC_REF(/obj/item/card/id/syndicate, unset_registered_user))
	return TRUE

/obj/item/card/id/syndicate/proc/unset_registered_user(mob/user)
	if(!registered_user || (user && user != registered_user))
		return
	GLOB.destroyed_event.unregister(registered_user, src)
	registered_user = null

/obj/item/card/id/syndicate/CanUseTopic(mob/user, datum/topic_state/state, href_list)
	if(!(href_list && href_list["look_at_id"]) && (user != registered_user))
		return STATUS_CLOSE
	return ..()

/obj/item/card/id/syndicate/Topic(href, href_list, datum/topic_state/state)
	if(..())
		return 1

	var/user = usr
	if(href_list["electronic_warfare"])
		electronic_warfare = text2num(href_list["electronic_warfare"])
		to_chat(user, SPAN_NOTICE("Electronic warfare [electronic_warfare ? "enabled" : "disabled"]."))
	else if(href_list["set"])
		switch(href_list["set"])
			if("Age")
				var/new_age = input(user,"What age would you like to put on this card?","Agent Card Age", age) as null|num
				if(!isnull(new_age) && CanUseTopic(user, state))
					if(new_age < 0)
						age = initial(age)
					else
						age = new_age
					to_chat(user, SPAN_NOTICE("Age has been set to '[age]'."))
					. = 1
			if("Prefix")
				var/new_prefix = sanitizeSafe(input(user,"What title prefix would you like to put on this card?","Agent Card Prefix", age) as text, MAX_NAME_LEN)
				if(!isnull(new_prefix) && CanUseTopic(user, state))
					formal_name_prefix = new_prefix
					to_chat(user, SPAN_NOTICE("Title prefix has been set to '[formal_name_prefix]'."))
					. = 1
			if("Suffix")
				var/new_suffix = sanitizeSafe(input(user,"What title suffix would you like to put on this card?","Agent Card Suffix", age) as text, MAX_NAME_LEN)
				if(!isnull(new_suffix) && CanUseTopic(user, state))
					formal_name_suffix = new_suffix
					to_chat(user, SPAN_NOTICE("Title suffix has been set to '[formal_name_suffix]'."))
					. = 1
			if("Appearance")
				var/datum/card_state/choice = input(user, "Select the appearance for this card.", "Agent Card Appearance") as null|anything in id_card_states()
				if(choice && CanUseTopic(user, state))
					src.icon_state = choice.icon_state
					src.item_state = choice.item_state
					src.color = choice.color
					src.detail_color = choice.detail_color
					src.extra_details = choice.extra_details
					update_icon()
					to_chat(usr, SPAN_NOTICE("Appearance changed to [choice]."))
					. = 1
			if("Assignment")
				var/new_job = sanitize(input(user,"What assignment would you like to put on this card?\nChanging assignment will not grant or remove any access levels.","Agent Card Assignment", assignment) as null|text)
				if(!isnull(new_job) && CanUseTopic(user, state))
					src.assignment = new_job
					to_chat(user, SPAN_NOTICE("Occupation changed to '[new_job]'."))
					. = 1
			if("Blood Type")
				var/default = blood_type
				if(default == initial(blood_type) && ishuman(user))
					var/mob/living/carbon/human/H = user
					if(H.dna)
						default = H.dna.b_type
				var/new_blood_type = sanitize(input(user,"What blood type would you like to be written on this card?","Agent Card Blood Type",default) as null|text)
				if(!isnull(new_blood_type) && CanUseTopic(user, state))
					src.blood_type = new_blood_type
					to_chat(user, SPAN_NOTICE("Blood type changed to '[new_blood_type]'."))
					. = 1
			if("DNA Hash")
				var/default = dna_hash
				if(default == initial(dna_hash) && ishuman(user))
					var/mob/living/carbon/human/H = user
					if(H.dna)
						default = H.dna.unique_enzymes
				var/new_dna_hash = sanitize(input(user,"What DNA hash would you like to be written on this card?","Agent Card DNA Hash",default) as null|text)
				if(!isnull(new_dna_hash) && CanUseTopic(user, state))
					src.dna_hash = new_dna_hash
					to_chat(user, SPAN_NOTICE("DNA hash changed to '[new_dna_hash]'."))
					. = 1
			if("Fingerprint Hash")
				var/default = fingerprint_hash
				if(default == initial(fingerprint_hash) && ishuman(user))
					var/mob/living/carbon/human/H = user
					if(H.dna)
						default = md5(H.dna.uni_identity)
				var/new_fingerprint_hash = sanitize(input(user,"What fingerprint hash would you like to be written on this card?","Agent Card Fingerprint Hash",default) as null|text)
				if(!isnull(new_fingerprint_hash) && CanUseTopic(user, state))
					src.fingerprint_hash = new_fingerprint_hash
					to_chat(user, SPAN_NOTICE("Fingerprint hash changed to '[new_fingerprint_hash]'."))
					. = 1
			if("Name")
				var/new_name = sanitizeName(input(user,"What name would you like to put on this card?","Agent Card Name", registered_name) as null|text, allow_numbers=TRUE)
				if(!isnull(new_name) && CanUseTopic(user, state))
					src.registered_name = new_name
					to_chat(user, SPAN_NOTICE("Name changed to '[new_name]'."))
					. = 1
			if("Photo")
				set_id_photo(user)
				to_chat(user, SPAN_NOTICE("Photo changed."))
				. = 1
			if("Sex")
				var/new_sex = sanitize(input(user,"What sex would you like to put on this card?","Agent Card Sex", sex) as null|text)
				if(!isnull(new_sex) && CanUseTopic(user, state))
					src.sex = new_sex
					to_chat(user, SPAN_NOTICE("Sex changed to '[new_sex]'."))
					. = 1
			if("Factory Reset")
				if(alert("This will factory reset the card, including access and owner. Continue?", "Factory Reset", "No", "Yes") == "Yes" && CanUseTopic(user, state))
					age = initial(age)
					formal_name_prefix = initial(formal_name_prefix)
					formal_name_suffix = initial(formal_name_suffix)
					access = syndicate_access.Copy()
					assignment = initial(assignment)
					blood_type = initial(blood_type)
					dna_hash = initial(dna_hash)
					electronic_warfare = initial(electronic_warfare)
					fingerprint_hash = initial(fingerprint_hash)
					icon_state = initial(icon_state)
					color = initial(color)
					detail_color = initial(detail_color)
					extra_details = initial(extra_details)
					SetName(initial(name))
					registered_name = initial(registered_name)
					unset_registered_user()
					sex = initial(sex)
					military_branch = initial(military_branch)
					military_rank = initial(military_rank)
					to_chat(user, SPAN_NOTICE("All information has been deleted from \the [src]."))
					. = 1
			if("Branch")
				var/new_branch = sanitize(input(user,"What branch of service would you like to put on this card?","Agent Card Branch") as null|anything in GLOB.mil_branches.spawn_branches())
				if(!isnull(new_branch) && CanUseTopic(user, state))
					src.military_branch =  GLOB.mil_branches.spawn_branches()[new_branch]
					to_chat(user, SPAN_NOTICE("Branch changed to '[military_branch.name]'."))
					. = 1
			if("Rank")
				var/new_rank = sanitize(input(user,"What rank would you like to put on this card?","Agent Card Rank") as null|anything in GLOB.mil_branches.spawn_ranks(military_branch.name))
				if(!isnull(new_rank) && CanUseTopic(user, state))
					src.military_rank = GLOB.mil_branches.spawn_ranks(military_branch.name)[new_rank]
					to_chat(user, SPAN_NOTICE("Rank changed to '[military_rank.name]'."))
					. = 1

	// Always update the UI, or buttons will spin indefinitely
	SSnano.update_uis(src)

var/global/list/id_card_states
/proc/id_card_states()
	RETURN_TYPE(/list)
	if(!id_card_states)
		id_card_states = list()
		for(var/path in typesof(/obj/item/card/id))
			var/obj/item/card/id/ID = path
			var/datum/card_state/CS = new()
			CS.icon_state = initial(ID.icon_state)
			CS.item_state = initial(ID.item_state)
			CS.color = initial(ID.color)
			CS.detail_color = initial(ID.detail_color)
			CS.extra_details = initial(ID.extra_details)
			CS.name = initial(ID.name)
			if (initial(ID.job_access_type))
				var/datum/job/J = initial(ID.job_access_type)
				CS.name += " ([initial(J.title)]) "
			CS.name += " - [initial(ID.icon_state)]"
			var/color_pair = ""
			if(CS.color)
				color_pair += CS.color
			if(CS.detail_color)
				color_pair += "/[CS.detail_color]"
			if(color_pair)
				CS.name += " - [color_pair]"
			id_card_states += CS
		id_card_states = dd_sortedObjectList(id_card_states)

	return id_card_states

/datum/card_state
	var/name
	var/icon_state
	var/item_state
	var/color
	var/detail_color
	var/details
	var/extra_details

/datum/card_state/dd_SortValue()
	return name
