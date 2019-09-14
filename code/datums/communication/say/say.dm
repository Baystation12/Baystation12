/decl/communication_channel/say
	name = "SAY"
	expected_communicator_type = /atom
	flags = COMMUNICATION_CANNOT_BAN
	log_proc = /proc/log_say

/decl/communication_channel/say/can_communicate(atom/communicator, datum/lang_message/M)
	return ..() && M.CanProduce(communicator)

// Custom logging, partially to include the language, partially because the message isn't a plain string
/decl/communication_channel/say/log_message(datum/communicator, datum/lang_message/M)
	return "[communicator.communication_identifier()] ([M.language.name]): [M.raw_message]"

/decl/communication_channel/say/do_communicate(var/atom/communicator, datum/lang_message/M)
	for(var/receiver in M.Receivers(communicator))
		receive_communication(communicator, receiver, M)

/decl/communication_channel/say/do_receive_communication(atom/communicator, atom/receiver, datum/lang_message/M)
	receiver.OnReceive(M)


/atom/proc/OnReceive(datum/lang_message/M)
	return

/mob/OnReceive(var/datum/lang_message/M)
	to_chat(src, M.GetMessage(src))

/atom/verb/whisperV(raw_message as text)
	set name = "WhisperTest"
	set src = usr
	say(sanitize(raw_message), list(/decl/message_modifier/whisper))

/atom/verb/sayV(raw_message as text)
	set name = "SayTest"
	set src = usr
	say(sanitize(raw_message))

/atom/proc/say(raw_message, modifiers)
	var/end_char = copytext(raw_message, lentext(raw_message), lentext(raw_message) + 1)
	switch(end_char)
		if("!")
			LAZYADD(modifiers, /decl/message_modifier/exclaim)
		if("?")
			LAZYADD(modifiers, /decl/message_modifier/ask)

	var/message = new/datum/lang_message(src, raw_message, /decl/language/common, modifiers)
	return communicate(/decl/communication_channel/say, src, message)
