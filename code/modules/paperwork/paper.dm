#define PAPER_MAX_FIELDS 50
#define PAPER_META(message) "<p><i>[message]</i></p>"
#define PAPER_META_BAD(message) "<p style='color:red'><i>[message]</i></p>"


/obj/item/paper
	name = "sheet of paper"
	gender = NEUTER
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "paper"
	item_state = "paper"
	randpixel = 8
	throwforce = 0
	w_class = ITEM_SIZE_TINY
	throw_range = 1
	throw_speed = 1
	layer = ABOVE_OBJ_LAYER
	slot_flags = SLOT_HEAD
	body_parts_covered = HEAD
	attack_verb = list("bapped")

	var/const/deffont = "Verdana"
	var/const/signfont = "Brush Script MT"
	var/const/crayonfont = "Comic Sans MS"
	var/const/fancyfont = "Garamond"

	var/info //What's actually written on the paper.
	var/info_links //A different version of the paper which includes html links at fields and EOF
	var/stamps //The (text for the) stamps on the paper.
	var/fields = 0 //Amount of user created fields
	var/free_space = MAX_PAPER_MESSAGE_LEN
	var/list/stamped
	var/list/ico = list() //Icons and
	var/list/offset_x = list() //offsets stored for later
	var/list/offset_y = list() //usage by the photocopier
	var/spam_flag = 0
	var/last_modified_ckey
	var/age = 0
	var/list/metadata
	var/readable = TRUE //Paper will not be able to be written on and will not bring up a window upon examine if FALSE
	var/is_memo = FALSE //If TRUE, paper will act the same as readable = FALSE, but will also be unrenameable.
	var/datum/language/language = LANGUAGE_HUMAN_EURO //Language the paper was written in. Editable by users up until something's actually written
	var/scan_file_type = /datum/computer_file/data/text
	var/is_copy = TRUE


/obj/item/paper/Initialize(mapload, text, title, list/metadata, datum/language/language)
	. = ..()
	set_content(text ? text : info, title)
	if (metadata)
		src.metadata = metadata
	if (language)
		src.language = language
	if (!set_language(src.language, TRUE))
		log_debug("[src] ([type]) initialized with invalid or missing language `[src.language]` defined.")
		set_language(LANGUAGE_HUMAN_EURO, TRUE)


/obj/item/paper/on_update_icon()
	if(icon_state == "paper_talisman" || is_memo)
		return
	else if(info)
		icon_state = "paper_words"
	else
		icon_state = "paper"


/obj/item/paper/examine(mob/user, distance, is_adjacent)
	. = ..()
	if(!is_memo && name != "sheet of paper")
		to_chat(user, "It's titled '[name]'.")
	if(is_adjacent)
		show_content(usr)
	else
		to_chat(user, SPAN_NOTICE("You have to go closer if you want to read it."))


/obj/item/paper/attack_self(mob/living/user as mob)
	if(user.a_intent == I_HURT)
		if(icon_state == "scrap")
			user.show_message(SPAN_WARNING("\The [src] is already crumpled."))
			return
		info = stars(info,85)
		user.visible_message("\The [user] crumples \the [src] into a ball!")
		icon_state = "scrap"
		return
	examinate(user, src)


/obj/item/paper/attack_ai(mob/living/silicon/ai/user)
	show_content(user)


/obj/item/paper/use_before(atom/target, mob/living/user)
	if (!isliving(target))
		return FALSE
	var/mob/living/carbon/human/human = target
	var/zone = user.zone_sel.selecting
	if (zone == BP_EYES)
		var/action = "looks at \a [initial(name)]"
		var/action_self = "look at \the [src]"
		if (user != target)
			action = "shows \a [initial(name)] to \the [target]"
			action_self = "show \a [initial(name)] to \the [target]"
		user.visible_message(
			SPAN_ITALIC("\The [user] [action]."),
			SPAN_ITALIC("You [action_self].")
		)
		if (human.client)
			examinate(target, src)
		return TRUE
	if (!istype(human))
		return FALSE
	if (zone != BP_MOUTH && zone != BP_HEAD)
		return FALSE
	var/obj/item/organ/external/head/head = human.organs_by_name[BP_HEAD]
	if (!istype(head))
		to_chat(user, SPAN_WARNING("\The [target] has no head!"))
		return TRUE
	var/target_name = "their"
	var/target_name_self = "your"
	if (user != target)
		target_name = "[target]'s"
		target_name_self = target_name
	var/part_name = "head"
	if (zone == BP_MOUTH)
		part_name = "mouth"
	user.visible_message(
		SPAN_ITALIC("\The [user] starts wiping [target_name] [part_name] with \a [initial(name)]."),
		SPAN_ITALIC("You start to wipe [target_name_self] [part_name] with \the [src].")
	)
	if (!do_after(user, 2 SECONDS, target, DO_EQUIP & ~DO_BOTH_CAN_TURN))
		return TRUE
	user.visible_message(
		SPAN_NOTICE("\The [user] finishes cleaning [target_name] [part_name]."),
		SPAN_NOTICE("You finish cleaning [target_name_self] [part_name]."),
	)
	if (zone == BP_MOUTH)
		human.makeup_style = null
		human.update_body()
	else
		head.forehead_graffiti = null
	return TRUE


/obj/item/paper/proc/PaperWritable(mob/living/user)
	if (user?.stat)
		return FALSE
	if (user?.restrained())
		return FALSE
	if (loc == user || Adjacent(user))
		return TRUE
	if (!istype(loc, /obj/item/material/folder) && !istype(loc, /obj/item/material/folder/clipboard))
		return FALSE
	if (loc.loc == user || loc.Adjacent(user))
		return TRUE
	return FALSE


/obj/item/paper/Topic(href_text, list/href_list, datum/topic_state/state)
	if (href_list["change_language"])
		if (!PaperWritable(usr))
			return
		choose_language(usr)
		show_content(usr, editable = TRUE)
		return
	if (href_list["write"])
		if (free_space <= 0)
			to_chat(usr, SPAN_INFO("There isn't enough space left on \the [src] to write anything."))
			return
		var/obj/item/pen/pen = usr.IsHolding(/obj/item/pen)
		if (!pen && istype(usr.back, /obj/item/rig))
			var/obj/item/rig/rig = usr.back
			if (rig.offline)
				return
			var/obj/item/rig_module/device/pen/module = locate(/obj/item/rig_module/device/pen) in rig.installed_modules
			pen = module?.device
		if (!pen && istype(loc, /obj/item/material/folder/clipboard))
			var/obj/item/material/folder/clipboard/clipboard = loc
			pen = clipboard.stored_pen
		if (!pen)
			return
		if (!PaperWritable(usr))
			return
		if (!pen.active)
			pen.toggle()
		var/iscrayon = 0
		var/isfancy = 0
		if(pen.iscrayon)
			iscrayon = TRUE
		if(pen.isfancy)
			isfancy = TRUE
		var/t = input("Enter what you want to write:", "Write", null, null) as message | null
		t = sanitize(t, free_space, extra = 0, trim = 0)
		if (!t)
			return
		if (!PaperWritable(usr))
			return
		var/last_fields_value = fields
		t = parsepencode(t, pen, usr, iscrayon, isfancy)
		if (fields > PAPER_MAX_FIELDS)
			to_chat(usr, SPAN_WARNING("Too many fields. Sorry, you can't do this."))
			fields = last_fields_value
			return
		if (href_list["write"] != "end")
			addtofield(text2num(href_list["write"]), t)
		else
			info += t
			updateinfolinks()
		last_modified_ckey = usr.ckey
		update_space(t)
		show_content(usr, editable = TRUE)
		playsound(src, pick('sound/effects/pen1.ogg','sound/effects/pen2.ogg'), 10)
		update_icon()
		if (istype(loc, /obj/item/material/folder/clipboard))
			var/obj/item/material/folder/clipboard/clipboard = loc
			if (clipboard.top_paper == src)
				loc.update_icon()


/obj/item/paper/use_tool(obj/item/P, mob/living/user, list/click_params)
	if(istype(P, /obj/item/tape_roll))
		var/obj/item/tape_roll/tape = P
		tape.stick(src, user)
		return TRUE
	if(istype(P, /obj/item/paper) || istype(P, /obj/item/photo))
		if(!can_bundle())
			USE_FEEDBACK_FAILURE("You cannot bundle these together!")
			return TRUE
		var/obj/item/paper/other = P
		if(istype(other) && !other.can_bundle())
			USE_FEEDBACK_FAILURE("You cannot bundle these together!")
			return TRUE
		if (istype(P, /obj/item/paper/carbon))
			var/obj/item/paper/carbon/C = P
			if (!C.iscopy && !C.copied)
				to_chat(user, SPAN_NOTICE("Take off the carbon copy first."))
				return TRUE
		var/obj/item/paper_bundle/B = new(src.loc)
		if (name != "paper")
			B.SetName(name)
		else if (P.name != "paper" && P.name != "photo")
			B.SetName(P.name)
		if(!user.unEquip(P, B) || !user.unEquip(src, B))
			return TRUE
		user.put_in_hands(B)
		to_chat(user, SPAN_NOTICE("You clip the [P.name] to [(src.name == "paper") ? "the paper" : src.name]."))
		B.pages.Add(src)
		B.pages.Add(P)
		B.update_icon()
		return TRUE
	if (istype(P, /obj/item/pen))
		if(icon_state == "scrap")
			to_chat(usr, SPAN_WARNING("\The [src] is too crumpled to write on."))
			return TRUE
		var/obj/item/pen/robopen/RP = P
		if ( istype(RP) && RP.mode == 2 )
			RP.RenamePaper(user,src)
		else
			show_content(user, editable = TRUE)
		return TRUE
	if (istype(P, /obj/item/stamp) || istype(P, /obj/item/clothing/ring/seal))
		if (!PaperWritable(user))
			return TRUE
		stamps += (!stamps ? "<HR>" : "<BR>") + "<i>This paper has been stamped with the [P.name].</i>"
		var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
		var/x
		var/y
		if(istype(P, /obj/item/stamp/captain) || istype(P, /obj/item/stamp/boss))
			x = rand(-2, 0)
			y = rand(-1, 2)
		else
			x = rand(-2, 2)
			y = rand(-3, 2)
		offset_x += x
		offset_y += y
		stampoverlay.pixel_x = x
		stampoverlay.pixel_y = y
		if(!ico)
			ico = new
		ico += "paper_[P.icon_state]"
		stampoverlay.icon_state = "paper_[P.icon_state]"
		if(!stamped)
			stamped = new
		stamped += P.type
		AddOverlays(stampoverlay)
		playsound(src, 'sound/effects/stamp.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("You stamp the paper with your [P.name]."))
		if (istype(loc, /obj/item/material/folder/clipboard))
			var/obj/item/material/folder/clipboard/clipboard = loc
			if (clipboard.top_paper == src)
				loc.update_icon()
		return TRUE
	if (istype(P, /obj/item/flame))
		burnpaper(P, user)
		return TRUE
	if (istype(P, /obj/item/paper_bundle))
		if(!can_bundle())
			USE_FEEDBACK_FAILURE("You cannot bundle these together!")
			return TRUE
		var/obj/item/paper_bundle/attacking_bundle = P
		attacking_bundle.insert_sheet_at(user, (length(attacking_bundle.pages))+1, src)
		attacking_bundle.update_icon()
		return TRUE
	return ..()


/obj/item/paper/proc/set_content(text, title, parse_pencode = TRUE)
	if(title)
		SetName(title)
	info = parse_pencode ? parsepencode(text) : text
	update_icon()
	update_space(info)
	updateinfolinks()


/obj/item/paper/proc/set_language(datum/language/new_language, force)
	if (!new_language || info && !force)
		return FALSE
	if (!istype(new_language))
		new_language = global.all_languages[new_language]
		if (!istype(new_language))
			return FALSE
	language = new_language
	return TRUE


/obj/item/paper/proc/choose_language(mob/user, admin_force)
	if (info)
		to_chat(user, SPAN_WARNING("\The [src] already has writing on it and cannot have its language changed."))
		return
	if (!admin_force && !length(user.languages))
		to_chat(user, SPAN_WARNING("You don't know any languages to choose from."))
		return
	var/list/selectable_languages = list()
	if (admin_force)
		for (var/key in global.all_languages)
			var/datum/language/L = global.all_languages[key]
			if (L.has_written_form)
				selectable_languages += L
	else
		for (var/datum/language/L in user.languages)
			if (L.has_written_form)
				selectable_languages += L
	var/new_language = input(user, "What language do you want to write in?", "Change language", language) as null|anything in selectable_languages
	if (!new_language || new_language == language)
		to_chat(user, SPAN_NOTICE("You decide to leave the language as [language.name]."))
		return
	if (!admin_force && !Adjacent(user) && !CanInteract(user, GLOB.deep_inventory_state))
		to_chat(user, SPAN_WARNING("You must remain next to or continue holding \the [src] to do that."))
		return
	set_language(new_language)


/obj/item/paper/proc/show_content(mob/user, force, editable)
	if (!readable || is_memo)
		return
	if (isclient(user))
		var/client/C = user
		user = C.mob
	if (!user)
		return
	var/can_read = force || isghost(user)
	if (!can_read)
		can_read = isAI(user)
		if (can_read)
			var/mob/living/silicon/ai/AI = user
			can_read = get_dist(src, AI.camera) < 2
		else
			can_read = ishuman(user) || issilicon(user)
			if (can_read)
				can_read = get_dist(src, user) < 3
	var/html = "<html><head><title>[name]</title><meta http-equiv='Content-Type' content='text/html; charset=utf-8'></head><body bgcolor='[color]'>"
	if (!can_read)
		html += PAPER_META_BAD("The paper is too far away or you can't read.")
		html += "<hr/></body></html>"
	var/has_content = length(info)
	var/has_language = force || (language in user.languages)
	if (has_content && !has_language && !isghost(user))
		html += PAPER_META_BAD("The paper is written in a language you don't understand.")
		html += "<hr/>" + language.scramble(info)
	else if (editable)
		if (has_content)
			html += PAPER_META("The paper is written in [language.name].")
			html += "<hr/>" + info_links
		else if (force || length(user.languages))
			if (!has_language)
				language = user.languages[1]
			html += PAPER_META("You are writing in <a href='byond://?src=\ref[src];change_language=1'>[language.name]</a>.")
			html += "<hr/>" + info_links
		else
			html += PAPER_META_BAD("You can't write without knowing a language.")
	else if (has_content)
		html += PAPER_META("The paper is written in [language.name].")
		html += "<hr/>" + info
	html += "[stamps]</body></html>"
	show_browser(user, html, "window=[name]")
	onclose(user, "[name]")


/obj/item/paper/proc/addtofield(id, text, links = 0)
	var/locid = 0
	var/laststart = 1
	var/textindex = 1
	while(locid < PAPER_MAX_FIELDS)
		var/istart = 0
		if(links)
			istart = findtext(info_links, "<span class=\"paper_field\">", laststart)
		else
			istart = findtext(info, "<span class=\"paper_field\">", laststart)
		if(istart==0)
			return // No field found with matching id
		laststart = istart+1
		locid++
		if(locid == id)
			var/iend = 1
			if(links)
				iend = findtext(info_links, "</span>", istart)
			else
				iend = findtext(info, "</span>", istart)
			textindex = iend
			break
	if(links)
		var/before = copytext(info_links, 1, textindex)
		var/after = copytext(info_links, textindex)
		info_links = before + text + after
	else
		var/before = copytext(info, 1, textindex)
		var/after = copytext(info, textindex)
		info = before + text + after
		updateinfolinks()


/obj/item/paper/proc/updateinfolinks()
	info_links = info
	for(var/i = 1 to fields)
		addtofield(i, "<span style='font-family: [deffont]'><A href='byond://?src=\ref[src];write=[i]'>write</A></span>", 1)
	info_links = info_links + "<span style='font-family: [deffont]'><A href='byond://?src=\ref[src];write=end'>write</A></span>"


/obj/item/paper/proc/update_space(new_text)
	if (new_text)
		free_space -= length_char(strip_html_properly(new_text))


/obj/item/paper/proc/clearpaper()
	info = null
	stamps = null
	free_space = MAX_PAPER_MESSAGE_LEN
	stamped = list()
	ClearOverlays()
	updateinfolinks()
	update_icon()


/obj/item/paper/proc/get_signature(obj/item/pen/P, mob/user as mob)
	if(P && istype(P, /obj/item/pen))
		return P.get_signature(user)
	return (user && user.real_name) ? user.real_name : "Anonymous"


/obj/item/paper/proc/parsepencode(t, obj/item/pen/P, mob/user, iscrayon, isfancy, isadmin)
	if(!length(t))
		return ""
	if (isadmin) //TODO: let admins sign things again
		t = replacetext(t, "\[sign\]", "")
	if (findtext(t, "\[sign\]"))
		t = replacetext(t, "\[sign\]", "<span style='font-family: [signfont]; font-size: 1.5em'><i>[get_signature(P, user)]</i></span>")
	if(iscrayon) // If it is a crayon, and he still tries to use these, make them empty!
		t = replacetext(t, "\[*\]", "")
		t = replacetext(t, "\[hr\]", "")
		t = replacetext(t, "\[small\]", "")
		t = replacetext(t, "\[/small\]", "")
		t = replacetext(t, "\[list\]", "")
		t = replacetext(t, "\[/list\]", "")
		t = replacetext(t, "\[table\]", "")
		t = replacetext(t, "\[/table\]", "")
		t = replacetext(t, "\[row\]", "")
		t = replacetext(t, "\[cell\]", "")
		t = replacetext(t, "\[logo\]", "")
	if(iscrayon)
		t = "<span style='font-family: [crayonfont]; color: [P ? P.colour : "black"]'><b>[t]</b></span>"
	else if(isfancy)
		t = "<span style='font-family: [fancyfont]; color: [P ? P.colour : "black"]'>[t]</span>"
	else
		t = "<span style='font-family: [deffont]; color: [P ? P.colour : "black"]'>[t]</span>"
	t = pencode2html(t)
	var/laststart = 1 //Count the fields
	while(fields < PAPER_MAX_FIELDS)
		var/i = findtext(t, "<span class=\"paper_field\">", laststart)	//</span>
		if(i==0)
			break
		laststart = i+1
		fields++
	return t


/obj/item/paper/proc/burnpaper(obj/item/flame/P, mob/user)
	var/class = "warning"
	if(P.lit && !user.restrained())
		if(istype(P, /obj/item/flame/lighter/zippo))
			class = "rose"
		user.visible_message(SPAN_CLASS("[class]", "[user] holds \the [P] up to \the [src], trying to burn it!"), \
		SPAN_CLASS("[class]", "You hold \the [P] up to \the [src], burning it slowly."))
		spawn(20)
			if(get_dist(src, user) < 2 && user.get_active_hand() == P && P.lit)
				user.visible_message(SPAN_CLASS("[class]", "[user] burns right through \the [src], turning it to ash. It flutters through the air before settling on the floor in a heap."), \
				SPAN_CLASS("[class]", "You burn right through \the [src], turning it to ash. It flutters through the air before settling on the floor in a heap."))
				new /obj/decal/cleanable/ash(get_turf(src))
				qdel(src)
			else
				to_chat(user, SPAN_WARNING("You must hold \the [P] steady to burn \the [src]."))



/obj/item/paper/proc/can_bundle()
	return TRUE


/obj/item/paper/proc/show_info(mob/user)
	return info


/obj/item/paper/verb/verb_choose_language()
	set name = "Set writing language"
	set category = "Object"
	set src in usr
	choose_language(usr)


/obj/item/paper/verb/rename()
	set name = "Rename paper"
	set category = "Object"
	set src in usr
	if((MUTATION_CLUMSY in usr.mutations) && prob(50))
		to_chat(usr, SPAN_WARNING("You cut yourself on the paper."))
		return
	else if(is_memo)
		to_chat(usr, SPAN_NOTICE("You decide not to alter the name of \the [src]."))
		return
	var/n_name = sanitizeSafe(input(usr, "What would you like to label the paper?", "Paper Labelling", null)  as text, MAX_NAME_LEN)
	// We check loc one level up, so we can rename in clipboards and such. See also: /obj/item/photo/rename()
	if(!n_name || !CanInteract(usr, GLOB.deep_inventory_state))
		return
	SetName(n_name)
	add_fingerprint(usr)


/obj/item/paper/manifest
	name = "supply manifest"


/obj/item/paper/anomaly_scan
	name = "anomaly scan result"


/obj/item/paper/spacer
	language = LANGUAGE_SPACER


/obj/item/paper/crumpled
	name = "paper scrap"
	icon_state = "scrap"


/obj/item/paper/crumpled/on_update_icon()
	return


/obj/item/paper/crumpled/bloody
	icon_state = "scrap_bloodied"


/obj/item/paper/bar_shotgun
	name = "shotgun permit"
	info = "This permit signifies that the Bartender is permitted to posess this firearm in the bar, and ONLY the bar. Failure to adhere to this permit will result in confiscation of the weapon and possibly arrest."


/obj/item/paper/workvisa
	name = "Sol Work Visa"
	desc = "A flimsy piece of laminated cardboard issued by the Sol Central Government."
	icon_state = "workvisa"
	info = "<center><b><large>Work Visa of the Sol Central Government</large></b></center><br><center><img src = sollogo.png><br><br><i><small>Issued on behalf of the Secretary-General.</small></i></center><hr><BR>This paper hereby permits the carrier to travel unhindered through Sol territories, colonies, and space for the purpose of work and labor."
	body_parts_covered = FLAGS_OFF
	slot_flags = FLAGS_OFF


/obj/item/paper/workvisa/on_update_icon()
	return


/obj/item/paper/travelvisa
	name = "Sol Travel Visa"
	desc = "A flimsy piece of laminated cardboard issued by the Sol Central Government."
	icon_state = "travelvisa"
	info = "<center><b><large>Travel Visa of the Sol Central Government</large></b></center><br><center><img src = sollogo.png><br><br><i><small>Issued on behalf of the Secretary-General.</small></i></center><hr><BR>This paper hereby permits the carrier to travel unhindered through Sol territories, colonies, and space for the purpose of pleasure and recreation."
	body_parts_covered = FLAGS_OFF
	slot_flags = FLAGS_OFF


/obj/item/paper/travelvisa/on_update_icon()
	return


/obj/item/paper/aromatherapy_disclaimer
	name = "aromatherapy disclaimer"
	info = "<I>The manufacturer and the retailer make no claims of the contained products' effacy.</I> <BR><BR><B>Use at your own risk.</B>"


#undef PAPER_META_BAD
#undef PAPER_META
#undef PAPER_MAX_FIELDS
