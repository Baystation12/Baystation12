/decl/communication_channel/pray
	name = "PRAY"
	expected_communicator_type = /mob
	flags = 0
	log_proc = /proc/log_say
	mute_setting = MUTE_PRAY

/decl/communication_channel/pray/do_communicate(var/client/communicator, var/message, var/speech_method_type)
	var/image/cross = image('icons/obj/storage.dmi',"bible")
	for(var/m in player_list)
		var/mob/M = m
		if(!M.client)
			continue
		var/extra
		if(M.client.holder && M.client.is_preference_enabled(/datum/client_preference/admin/show_chat_prayers))
			extra = "[key_name(communicator, 1)] (<A HREF='?_src_=holder;adminmoreinfo=\ref[communicator]'>?</A>) (<A HREF='?_src_=holder;adminplayeropts=\ref[communicator]'>PP</A>) (<A HREF='?_src_=vars;Vars=\ref[communicator]'>VV</A>) (<A HREF='?_src_=holder;subtlemessage=\ref[communicator]'>SM</A>) ([admin_jump_link(communicator, communicator)]) (<A HREF='?_src_=holder;secretsadmin=check_antagonist'>CA</A>) (<A HREF='?_src_=holder;adminspawncookie=\ref[communicator]'>SC</a>)"
		else if(istype(m, /mob/living/deity))
			var/mob/living/deity/deity = m
			if(deity.is_follower(communicator, silent = 1)) //If its their follower send the message
				extra = "[M] (<a href='?src=\ref[deity];jump=\ref[communicator]'>J</a>)"
			else //Otherwise just pass
				continue
		else if(communicator == M) //Give it to ourselves
			receive_communication(communicator, M, "<span class='notice'>\icon[cross] <b>You send the prayer, \"[message]\" out into the heavens.</b></notice>")
			return
		else
			continue
		receive_communication(communicator, M, "<span class='notice'>\icon[cross] <b><font color=purple>PRAY: </font>[extra ? "[extra]" : ""]: </b>[message]</span>")
		sound_to(m, 'sound/effects/ding.ogg')