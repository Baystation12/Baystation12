/mob/living/silicon/pai/say(var/msg)
	if(silence_time)
		src << "<font color=green>Communication circuits remain uninitialized.</font>"
		return 
	
	var/message = trim(copytext(sanitize(msg), 1, MAX_MESSAGE_LEN))
	var/message_mode = parse_message_mode(message)
	
	if(message_mode == "paichat")
		var/mob/living/carbon/human/carrier = src.findPaiCarrier() 
		
		if(carrier != null && carrier.checkHasHeadset())
			var/list/recipients = list(src, carrier)
			
			var/verb = say_quote(message)
			message = copytext(message,3)
			var/datum/language/speaking = parse_language(message)
			if (speaking)
				verb = speaking.speech_verb
				message = copytext(message,3)
			
			message = trim(message)
			paiChatSay(message, recipients, verb, speaking, src)
			
			return
	..(msg)