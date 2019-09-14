/datum/unit_test/say
	disabled = FALSE
	template = /datum/unit_test/say


/datum/unit_test/say/one_mob_shall_be_able_to_speak_to_another_mob
	name = "SAY: One mob shall be able to speak to another mob"

/datum/unit_test/say/one_mob_shall_be_able_to_speak_to_another_mob/start_test()
	var/mob/say/S = get_named_instance(/mob/say, get_turf(locate(/obj/effect/landmark/virtual_spawn/one)))
	var/mob/say/R = get_named_instance(/mob/say, get_turf(locate(/obj/effect/landmark/virtual_spawn/two)))

	var/message = "A test message"
	communicate(/decl/communication_channel/say, S, new/datum/lang_message(S, message, /decl/language/common))

	if (S?.received_message?.raw_message != message)
		fail("The sender did not receive the expected message. Expected '[message]', was '[S?.received_message?.raw_message]'")
	else if (R?.received_message?.raw_message != message)
		fail("The receiver did not receive the expected message. Expected '[message]', was '[R?.received_message?.raw_message]'")
	else
		pass("The sender and receiver both received the expected message")

	qdel(S)
	qdel(R)
	return 1


/datum/unit_test/say/message_mod_shall_be_able_to_be_non_applicable
	name = "Message mod shall be able to be non-applicable"

/datum/unit_test/say/message_mod_shall_be_able_to_be_non_applicable/start_test()
	var/origin = new/obj()
	var/datum/lang_message/LM = new/datum/lang_message(origin, "Test", /decl/language/common, list(/decl/message_modifier/exclamation/roar))

	LM.GetMessage(origin)
	if(!length(LM))
		pass("Message modifier was non-applicable as expected")
	else
		fail("Unexpected message modifier list: [log_info_line(LM.message_modifiers)]")

	qdel(LM)
	qdel(origin)
	return 1


/datum/unit_test/say/message_mod_shall_be_able_to_negate
	name = "Message mod shall be able to negate"

/datum/unit_test/say/message_mod_shall_be_able_to_negate/start_test()
	var/origin = new/obj()
	var/datum/lang_message/LM = new/datum/lang_message(origin, "Test", /decl/language/common, list(/decl/message_modifier/no_stutter, /decl/message_modifier/stutter))

	LM.GetMessage(origin)
	if(length(LM.message_modifiers) == 1 && istype(LM.message_modifiers[1], /decl/message_modifier/no_stutter))
		pass("Message modifier was negacted as expected")
	else
		fail("Unexpected message modifier list: [log_info_line(LM.message_modifiers)]")

	qdel(LM)
	qdel(origin)
	return 1


/datum/unit_test/say/message_mods_shall_be_able_to_combine
	name = "Message mods shall be able to combine"

/datum/unit_test/say/message_mods_shall_be_able_to_combine/start_test()
	var/origin = new/obj()
	var/datum/lang_message/LM = new/datum/lang_message(origin, "Test", /decl/language/common, list(/decl/message_modifier/synth, /decl/message_modifier/whisper))

	LM.GetMessage(origin)
	if(length(LM.message_modifiers) == 1 && istype(LM.message_modifiers[1], /decl/message_modifier/whisper/synth))
		pass("Message modifiers were combined as expected")
	else
		fail("Unexpected message modifier list: [log_info_line(LM.message_modifiers)]")

	qdel(LM)
	qdel(origin)
	return 1

/mob/say
	var/datum/lang_message/received_message

/mob/say/OnReceive(var/datum/lang_message/message)
	received_message = message
