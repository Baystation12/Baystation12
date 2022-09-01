/mob/living/silicon/pai/say(msg)
	if(silence_time)
		to_chat(src, "<font color=green>Communication circuits remain uninitialized.</font>")
	else
		..(msg)
