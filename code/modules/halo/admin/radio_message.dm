
/client/proc/custom_radio_message()
	set category = "Fun"
	set name = "Custom Radio Message"
	if(!check_rights(R_FUN))
		return
	var/list/options = GLOB.channels_ciphers.Copy()
	options.Add("Custom Frequency")

	var/choice = input("Which radio channel do you want to message?",\
		"Choose Target")\
		as null|anything in options
	if(!choice)
		return

	var/from = input("Enter the name of who should send the message.","Source name") as null|text
	if(!from)
		return

	var/message = input("Enter the radio message to send.","Radio Message") as null|text
	if(!message)
		return

	var/language_name = input("Enter the language name to transmit in.","Language") as null|anything in all_languages
	if(!language_name)
		return

	if(choice == "Custom Frequency")
		choice = input("Enter the frequency number, typically between [RADIO_LOW_FREQ] and [RADIO_HIGH_FREQ]",\
			"Choose Frequency") as null|num
		if(!choice)
			return
		GLOB.global_announcer.autosay_freq(message, from, choice, language_name)
	else
		GLOB.global_announcer.autosay(message, from, choice, language_name)

	message_admins("[key_name_admin(src)] has sent a custom radio message to [choice].")



// secrets panel entry for custom radio message

/datum/admin_secret_item/fun_secret/custom_radio_message
	name = "Custom Radio message"

/datum/admin_secret_item/fun_secret/custom_radio_message/execute(var/mob/user)
	user.client.custom_radio_message()
