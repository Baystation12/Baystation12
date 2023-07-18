/mob/living/can_emote(emote_type)
	. = ..() && emoteCooldownCheck()
