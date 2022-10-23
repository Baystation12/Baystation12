/singleton/emote/audible/synth
	key = "beep"
	emote_message_3p = "USER beeps."
	emote_sound = 'sound/machines/twobeep.ogg'

/singleton/emote/audible/synth/check_user(mob/living/user)
	if(istype(user) && user.isSynthetic())
		return ..()
	return FALSE

/singleton/emote/audible/synth/ping
	key = "ping"
	emote_message_3p = "USER pings."
	emote_sound = 'sound/machines/ping.ogg'

/singleton/emote/audible/synth/buzz
	key = "buzz"
	emote_message_3p = "USER buzzes."
	emote_sound = 'sound/machines/buzz-sigh.ogg'

/singleton/emote/audible/synth/confirm
	key = "confirm"
	emote_message_3p = "USER emits an affirmative blip."
	emote_sound = 'sound/machines/synth_yes.ogg'

/singleton/emote/audible/synth/deny
	key = "deny"
	emote_message_3p = "USER emits a negative blip."
	emote_sound = 'sound/machines/synth_no.ogg'

/singleton/emote/audible/synth/security
	key = "law"
	emote_message_3p = "USER shows USER_HIS legal authorization barcode."
	emote_message_3p_target = "USER shows TARGET USER_THEIR legal authorization barcode."
	emote_sound = 'sound/voice/biamthelaw.ogg'

/singleton/emote/audible/synth/security/check_user(mob/living/silicon/robot/user)
	return (istype(user) && istype(user.module,/obj/item/robot_module/security))

/singleton/emote/audible/synth/security/halt
	key = "halt"
	emote_message_3p = "USER's speakers skreech, \"Halt! Security!\"."
	emote_sound = 'sound/voice/halt.ogg'
