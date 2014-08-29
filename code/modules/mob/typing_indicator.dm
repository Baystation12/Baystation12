var/global/image/typing_indicator

/mob/proc/set_typing_indicator(var/state)
	if(client)
		if(!(client.prefs.toggles & SHOW_TYPING))
			if(!typing_indicator)
				typing_indicator = image('icons/mob/talk.dmi',null,"typing")
			if(state)
				if(!(typing_indicator in overlays))
					overlays += typing_indicator
			else
				overlays -= typing_indicator
			return state

/mob/verb/say_wrapper()
	set name = ".Say"
	set hidden = 1

	set_typing_indicator(1)
	hud_typing = 1
	var/message = input("","say (text)") as text
	hud_typing = 0
	set_typing_indicator(0)
	if(message)
		say_verb(message)

/mob/verb/me_wrapper()
	set name = ".Me"
	set hidden = 1

	set_typing_indicator(1)
	hud_typing = 1
	var/message = input("","me (text)") as text
	hud_typing = 0
	set_typing_indicator(0)
	if(message)
		me_verb(message)

/mob/proc/handle_typing_indicator()
	if(client)
		if(!(client.prefs.toggles & SHOW_TYPING) && !hud_typing)
			var/temp = winget(client, "input", "text")
			if(length(temp) > 5 && findtext(temp, "Say \"", 1, 7))
				set_typing_indicator(1)
			else if(length(temp) > 3 && findtext(temp, "Me ", 1, 5))
				set_typing_indicator(1)
			else
				set_typing_indicator(0)

/client/verb/typing_indicator()
	set name = "Show/Hide Typing Indicator"
	set category = "Preferences"
	set desc = "Toggles showing an indicator when you are typing emote or say message."
	prefs.toggles ^= SHOW_TYPING
	prefs.save_preferences()
	src << "You will [(prefs.toggles & CHAT_OOC) ? "now" : "no longer"] display typing indicator."
	feedback_add_details("admin_verb","TID") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
