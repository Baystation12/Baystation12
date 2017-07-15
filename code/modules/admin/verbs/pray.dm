/mob/verb/pray(msg as text)
	set category = "IC"
	set name = "Pray"

	msg = sanitize(msg)
	if(!msg)	return

	if(usr.client)
		if(usr.client.prefs.muted & MUTE_PRAY)
			to_chat(usr, "<span class='warning'>You cannot pray (muted).</span>")
			return

	var/image/cross = image('icons/obj/storage.dmi',"bible")
	msg = "<span class='notice'>\icon[cross] <b><font color=purple>PRAY: </font>[key_name(src, 1)] (<A HREF='?_src_=holder;adminmoreinfo=\ref[src]'>?</A>) (<A HREF='?_src_=holder;adminplayeropts=\ref[src]'>PP</A>) (<A HREF='?_src_=vars;Vars=\ref[src]'>VV</A>) (<A HREF='?_src_=holder;subtlemessage=\ref[src]'>SM</A>) ([admin_jump_link(src, src)]) (<A HREF='?_src_=holder;secretsadmin=check_antagonist'>CA</A>) (<A HREF='?_src_=holder;adminspawncookie=\ref[src]'>SC</a>) (<A HREF='?_src_=holder;take_ic=\ref[src]'>TAKE</a>):</b> [msg]</span>"

	for(var/client/C in GLOB.admins)
		if(R_ADMIN & C.holder.rights)
			if(C.is_preference_enabled(/datum/client_preference/admin/show_chat_prayers))
				to_chat(C, msg)
				sound_to(C, 'sound/effects/ding.ogg')
	to_chat(usr, "Your prayers have been received by the gods.")
	feedback_add_details("admin_verb","PR") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	//log_admin("HELP: [key_name(src)]: [msg]")

/proc/Centcomm_announce(var/msg, var/mob/Sender, var/iamessage)
	msg = "<span class='notice'><b><font color=orange>[uppertext(GLOB.using_map.boss_short)]M[iamessage ? " IA" : ""]:</font>[key_name(Sender, 1)] (<A HREF='?_src_=holder;adminplayeropts=\ref[Sender]'>PP</A>) (<A HREF='?_src_=vars;Vars=\ref[Sender]'>VV</A>) (<A HREF='?_src_=holder;subtlemessage=\ref[Sender]'>SM</A>) ([admin_jump_link(Sender, src)]) (<A HREF='?_src_=holder;secretsadmin=check_antagonist'>CA</A>) (<A HREF='?_src_=holder;BlueSpaceArtillery=\ref[Sender]'>BSA</A>) (<A HREF='?_src_=holder;take_ic=\ref[src]'>TAKE</a>) (<A HREF='?_src_=holder;CentcommReply=\ref[Sender]'>RPLY</A>):</b> [msg]</span>"
	for(var/client/C in GLOB.admins)
		if(R_ADMIN & C.holder.rights)
			to_chat(C, msg)
			sound_to(C, 'sound/machines/signal.ogg')

/proc/Syndicate_announce(var/msg, var/mob/Sender)
	msg = "<span class='notice'><b><font color=crimson>ILLEGAL:</font>[key_name(Sender, 1)] (<A HREF='?_src_=holder;adminplayeropts=\ref[Sender]'>PP</A>) (<A HREF='?_src_=vars;Vars=\ref[Sender]'>VV</A>) (<A HREF='?_src_=holder;subtlemessage=\ref[Sender]'>SM</A>) ([admin_jump_link(Sender, src)]) (<A HREF='?_src_=holder;secretsadmin=check_antagonist'>CA</A>) (<A HREF='?_src_=holder;BlueSpaceArtillery=\ref[Sender]'>BSA</A>) (<A HREF='?_src_=holder;take_ic=\ref[src]'>TAKE</a>) (<A HREF='?_src_=holder;SyndicateReply=\ref[Sender]'>RPLY</A>):</b> [msg]</span>"
	for(var/client/C in GLOB.admins)
		if(R_ADMIN & C.holder.rights)
			to_chat(C, msg)
			sound_to(C, 'sound/machines/signal.ogg')
