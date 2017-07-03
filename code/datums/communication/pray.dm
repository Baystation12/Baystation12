/decl/communication_channel/pray
	name = "PRAY"
	expected_communicator_type = /mob
	log_proc = /proc/log_say
	mute_setting = MUTE_PRAY

/decl/communication_channel/pray/do_communicate(var/mob/communicator, var/message, var/speech_method_type)
	var/image/cross = image('icons/obj/storage.dmi',"bible")
	for(var/m in player_list)
		var/mob/M = m
		if(!M.client)
			continue
		if(M.client.holder && M.client.is_preference_enabled(/datum/client_preference/admin/show_chat_prayers))
			receive_communication(communicator, M, "<span class='notice'>\icon[cross] <b><font color=purple>PRAY: </font>[key_name(communicator, 1)] (<A HREF='?_src_=holder;adminmoreinfo=\ref[communicator]'>?</A>) (<A HREF='?_src_=holder;adminplayeropts=\ref[communicator]'>PP</A>) (<A HREF='?_src_=vars;Vars=\ref[communicator]'>VV</A>) (<A HREF='?_src_=holder;subtlemessage=\ref[communicator]'>SM</A>) ([admin_jump_link(communicator, communicator)]) (<A HREF='?_src_=holder;secretsadmin=check_antagonist'>CA</A>) (<A HREF='?_src_=holder;adminspawncookie=\ref[communicator]'>SC</a>): </b>[message]</span>")
		else if(communicator == M) //Give it to ourselves
			receive_communication(communicator, M, "<span class='notice'>\icon[cross] <b>You send the prayer, \"[message]\" out into the heavens.</b></span>")

/decl/communication_channel/pray/receive_communication(var/mob/communicator, var/mob/receiver, var/message)
	..()
	sound_to(receiver, 'sound/effects/ding.ogg')