/singleton/communication_channel/pray
	name = "PRAY"
	expected_communicator_type = /mob
	log_proc = GLOBAL_PROC_REF(log_say)
	flags = COMMUNICATION_ADMIN_FOLLOW
	mute_setting = MUTE_PRAY

/singleton/communication_channel/pray/do_communicate(mob/communicator, message, speech_method_type)
	var/image/cross = image('icons/obj/books.dmi',"bible")
	for(var/mob/M in GLOB.player_list)
		if(!M.client)
			continue
		if(M.client.holder && M.client.get_preference_value(/datum/client_preference/staff/show_chat_prayers) == GLOB.PREF_SHOW)
			receive_communication(communicator, M, "\[<A HREF='byond://?_src_=holder;adminspawncookie=\ref[communicator]'>SC</a>\] \[<A HREF='byond://?_src_=holder;narrateto=\ref[communicator]'>DN</a>\][SPAN_NOTICE("[icon2html(cross, M)] <b>[SPAN_COLOR("purple", "PRAY: ")][key_name(communicator, 1)]: </b>[message]")]")
		else if(communicator == M) //Give it to ourselves
			receive_communication(communicator, M, SPAN_NOTICE("[icon2html(cross, M)] <b>You send the prayer, \"[message]\" out into the heavens.</b>"))

/singleton/communication_channel/pray/receive_communication(mob/communicator, mob/receiver, message)
	..()
	sound_to(receiver, 'sound/effects/ding.ogg')
