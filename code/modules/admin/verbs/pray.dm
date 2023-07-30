/mob/verb/pray(msg as text)
	set category = "IC"
	set name = "Pray"

	sanitize_and_communicate(/singleton/communication_channel/pray, src, msg)

/proc/Centcomm_announce(msg, mob/Sender, iamessage)
	var/mob/intercepted = check_for_interception()
	msg = SPAN_NOTICE("<b>[SPAN_COLOR("orange", "[uppertext(GLOB.using_map.boss_short)]M[iamessage ? " IA" : ""][intercepted ? "(Intercepted by [intercepted])" : null]:")][key_name(Sender, 1)] (<A HREF='?_src_=holder;adminplayeropts=\ref[Sender]'>PP</A>) (<A HREF='?_src_=vars;Vars=\ref[Sender]'>VV</A>) ([admin_jump_link(Sender)]) (<A HREF='?_src_=holder;secretsadmin=check_antagonist'>CA</A>) (<A HREF='?_src_=holder;BlueSpaceArtillery=\ref[Sender]'>BSA</A>) (<A HREF='?_src_=holder;CentcommReply=\ref[Sender]'>RPLY</A>):</b> [msg]")
	for(var/client/C as anything in GLOB.admins)
		if (R_ADMIN & C.holder.rights)
			to_chat(C, msg)
			sound_to(C, 'sound/machines/signal.ogg')

/proc/Syndicate_announce(msg, mob/Sender)
	var/mob/intercepted = check_for_interception()
	msg = SPAN_NOTICE("<b>[SPAN_COLOR("crimson", "ILLEGAL[intercepted ? "(Intercepted by [intercepted])" : null]:")][key_name(Sender, 1)] (<A HREF='?_src_=holder;adminplayeropts=\ref[Sender]'>PP</A>) (<A HREF='?_src_=vars;Vars=\ref[Sender]'>VV</A>) (<A HREF='?_src_=holder;narrateto=\ref[Sender]'>DN</A>) ([admin_jump_link(Sender)]) (<A HREF='?_src_=holder;secretsadmin=check_antagonist'>CA</A>) (<A HREF='?_src_=holder;BlueSpaceArtillery=\ref[Sender]'>BSA</A>) (<A HREF='?_src_=holder'>TAKE</a>) (<A HREF='?_src_=holder;SyndicateReply=\ref[Sender]'>RPLY</A>):</b> [msg]")
	for(var/client/C as anything in GLOB.admins)
		if (R_ADMIN & C.holder.rights)
			to_chat(C, msg)
			sound_to(C, 'sound/machines/signal.ogg')
