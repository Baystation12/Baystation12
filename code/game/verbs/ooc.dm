/mob/verb/listen_ooc()
	set name = "Hear/Stop Hearing OOC"
	set category = "OOC"

	if (src.client)
		src.client.listen_ooc = !src.client.listen_ooc
		if (src.client.listen_ooc)
			src << "\blue You are now listening to messages on the OOC channel."
		else
			src << "\blue You are no longer listening to messages on the OOC channel."

/mob/verb/ooc(msg as text)
	set name = "OOC" //Gave this shit a shorter name so you only have to time out "ooc" rather than "ooc message" to use it --NeoFite
	set category = "OOC"
	if (IsGuestKey(src.key))
		src << "Guests may not use OOC."
		return
	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)
		return
	else if (!src.client.listen_ooc)
		src << "\red You have OOC muted."
		return
	else if (!ooc_allowed && !src.client.holder)
		src << "\red OOC is globally muted"
		return
	else if (!dooc_allowed && !src.client.holder && (src.client.deadchat != 0))
		usr << "\red OOC for dead mobs has been turned off."
		return
	else if (src.client)
		if(src.client.muted & MUTE_OOC)
			src << "\red You cannot use OOC (muted)."
			return

		if (src.client.handle_spam_prevention(msg,MUTE_OOC))
			return
	else if (findtext(msg, "byond://") && !src.client.holder)
		src << "<B>Advertising other servers is not allowed.</B>"
		log_admin("[key_name(src)] has attempted to advertise in OOC: [msg]")
		message_admins("[key_name_admin(src)] has attempted to advertise in OOC: [msg]")
		return

	log_ooc("[src.name]/[src.key] : [msg]")

	for (var/client/C)
		if(C.listen_ooc)
			if (src.client.holder)
				if(!src.client.holder.fakekey || C.holder)

					if (src.client.holder.rank == "Admin Observer")
						C << "<span class='adminobserverooc'><span class='prefix'>OOC:</span> <EM>[src.key][src.client.holder.fakekey ? "/([src.client.holder.fakekey])" : ""]:</EM> <span class='message'>[msg]</span></span>"
					else if (src.client.holder.level >= 5)
						C << "<font color=[src.client.holder.ooccolor]><b><span class='prefix'>OOC:</span> <EM>[src.key][src.client.holder.fakekey ? "/([src.client.holder.fakekey])" : ""]:</EM> <span class='message'>[msg]</span></b></font>"

					else if (src.client.holder.rank == "Retired Admin")
						C << "<span class='ooc'><span class='prefix'>OOC:</span> <EM>[src.key][src.client.holder.fakekey ? "/([src.client.holder.fakekey])" : ""]:</EM> <span class='message'>[msg]</span></span>"
					else if (src.client.holder.rank == "Moderator")
						C << "<span class='modooc'><span class='prefix'>OOC:</span> <EM>[src.key][src.client.holder.fakekey ? "/([src.client.holder.fakekey])" : ""]:</EM> <span class='message'>[msg]</span></span>"
					else
						C << "<span class='adminooc'><span class='prefix'>OOC:</span> <EM>[src.key][src.client.holder.fakekey ? "/([src.client.holder.fakekey])" : ""]:</EM> <span class='message'>[msg]</span></span>"
				else
					C << "<span class='ooc'><span class='prefix'>OOC:</span> <EM>[src.client.holder.fakekey ? "/([src.client.holder.fakekey])" : ""]:</EM> <span class='message'>[msg]</span></span>"
			else
				C << "<span class='ooc'><span class='prefix'>OOC:</span> <EM>[src.key]:</EM> <span class='message'>[msg]</span></span>"
