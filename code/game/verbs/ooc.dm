
/client/verb/ooc(msg as text)
	set name = "OOC"
	set category = "OOC"

	if(say_disabled)	//This is here to try to identify lag problems
		usr << "\red Speech is currently admin-disabled."
		return

	if(!mob)	return
	if(IsGuestKey(key))
		src << "Guests may not use OOC."
		return

	msg = trim(copytext(sanitize(msg), 1, MAX_MESSAGE_LEN))
	if(!msg)	return

	if(!(prefs.toggles & CHAT_OOC))
		src << "\red You have OOC muted."
		return

	if(!holder)
		if(!ooc_allowed)
			src << "\red OOC is globally muted"
			return
		if(!dooc_allowed && (mob.stat == DEAD))
			usr << "\red OOC for dead mobs has been turned off."
			return
		if(prefs.muted & MUTE_OOC)
			src << "\red You cannot use OOC (muted)."
			return
		if(handle_spam_prevention(msg,MUTE_OOC))
			return
		if(findtext(msg, "byond://"))
			src << "<B>Advertising other servers is not allowed.</B>"
			log_admin("[key_name(src)] has attempted to advertise in OOC: [msg]")
			message_admins("[key_name_admin(src)] has attempted to advertise in OOC: [msg]")
			return

	log_ooc("[mob.name]/[key] : [msg]")

	var/ooc_style = "everyone"
	if(holder && !holder.fakekey)
		ooc_style = "elevated"
		if(holder.rights & R_MOD)
			ooc_style = "moderator"
		if(holder.rights & R_DEBUG)
			ooc_style = "developer"
		if(holder.rights & R_ADMIN)
			ooc_style = "admin"

	for(var/client/target in clients)
		if(target.prefs.toggles & CHAT_OOC)
			var/display_name = src.key
			if(holder)
				if(holder.fakekey)
					if(target.holder)
						display_name = "[holder.fakekey]/([src.key])"
					else
						display_name = holder.fakekey
			if(holder && !holder.fakekey && (holder.rights & R_ADMIN) && config.allow_admin_ooccolor && (src.prefs.ooccolor != initial(src.prefs.ooccolor))) // keeping this for the badmins
				target << "<font color='[src.prefs.ooccolor]'><span class='ooc'><span class='prefix'>OOC:</span> <EM>[display_name]:</EM> <span class='message'>[msg]</span></span></font>"
			else
				target << "<span class='ooc'><span class='[ooc_style]'><span class='prefix'>OOC:</span> <EM>[display_name]:</EM> <span class='message'>[msg]</span></span></span>"

/client/verb/looc(msg as text)
	set name = "LOOC" //Gave this shit a shorter name so you only have to time out "ooc" rather than "ooc message" to use it --NeoFite
	set desc = "Local OOC, seen only by those in view."
	set category = "OOC"

	if(say_disabled)	//This is here to try to identify lag problems
		usr << "\red Speech is currently admin-disabled."
		return

	if(!mob)	return
	if(IsGuestKey(key))
		src << "Guests may not use OOC."
		return

	msg = trim(copytext(sanitize(msg), 1, MAX_MESSAGE_LEN))
	if(!msg)	return

	if(!(prefs.toggles & CHAT_LOOC))
		src << "\red You have LOOC muted."
		return

	if(!holder)
		if(!ooc_allowed)
			src << "\red OOC is globally muted"
			return
		if(!dooc_allowed && (mob.stat == DEAD))
			usr << "\red OOC for dead mobs has been turned off."
			return
		if(prefs.muted & MUTE_OOC)
			src << "\red You cannot use OOC (muted)."
			return
		if(handle_spam_prevention(msg,MUTE_OOC))
			return
		if(findtext(msg, "byond://"))
			src << "<B>Advertising other servers is not allowed.</B>"
			log_admin("[key_name(src)] has attempted to advertise in OOC: [msg]")
			message_admins("[key_name_admin(src)] has attempted to advertise in OOC: [msg]")
			return

	log_ooc("(LOCAL) [mob.name]/[key] : [msg]")

	var/list/heard = get_mobs_in_view(7, src.mob)
	var/mob/S = src.mob
	
	var/display_name = S.key
	if(S.stat != DEAD)
		display_name = S.name
	
	// Handle non-admins
	for(var/mob/M in heard)
		if(!M.client)
			continue
		var/client/C = M.client
		if (C in admins)
			continue //they are handled after that

		if(C.prefs.toggles & CHAT_LOOC)
			if(holder)
				if(holder.fakekey)
					if(C.holder)
						display_name = "[holder.fakekey]/([src.key])"
					else
						display_name = holder.fakekey
			C << "<font color='#6699CC'><span class='ooc'><span class='prefix'>LOOC:</span> <EM>[display_name]:</EM> <span class='message'>[msg]</span></span></font>"
	
	// Now handle admins
	display_name = S.key
	if(S.stat != DEAD)
		display_name = "[S.name]/([S.key])"
	
	for(var/client/C in admins)
		if(C.prefs.toggles & CHAT_LOOC)
			var/prefix = "(R)LOOC"
			if (C.mob in heard)
				prefix = "LOOC"
			C << "<font color='#6699CC'><span class='ooc'><span class='prefix'>[prefix]:</span> <EM>[display_name]:</EM> <span class='message'>[msg]</span></span></font>"
