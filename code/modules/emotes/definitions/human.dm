/decl/emote/human
	key = "vomit"

/decl/emote/human/check_user(var/atom/user)
	return istype(user, /mob/living/carbon/human)

/decl/emote/human/do_emote(var/mob/living/carbon/human/user)
	user.vomit()

/decl/emote/human/deathgasp
	key = "deathgasp"

/decl/emote/human/deathgasp/get_emote_message_3p(var/mob/living/carbon/human/user)
	return "USER [user.species.get_death_message()]"

/decl/emote/human/swish
	key = "swish"

/decl/emote/human/swish/do_emote(var/mob/living/carbon/human/user)
	user.animate_tail_once()

/decl/emote/human/wag
	key = "wag"

/decl/emote/human/wag/do_emote(var/mob/living/carbon/human/user)
	user.animate_tail_start()

/decl/emote/human/sway
	key = "sway"

/decl/emote/human/sway/do_emote(var/mob/living/carbon/human/user)
	user.animate_tail_start()

/decl/emote/human/qwag
	key = "qwag"

/decl/emote/human/qwag/do_emote(var/mob/living/carbon/human/user)
	user.animate_tail_fast()

/decl/emote/human/fastsway
	key = "fastsway"

/decl/emote/human/fastsway/do_emote(var/mob/living/carbon/human/user)
	user.animate_tail_fast()

/decl/emote/human/swag
	key = "swag"

/decl/emote/human/swag/do_emote(var/mob/living/carbon/human/user)
	user.animate_tail_stop()

/decl/emote/human/stopsway
	key = "stopsway"

/decl/emote/human/stopsway/do_emote(var/mob/living/carbon/human/user)
	user.animate_tail_stop()

/decl/emote/human/signal
	key = "signal"
	emote_message_3p = "USER signals."
	emote_message_3p_target = "USER signals at TARGET."
	message_type = VISIBLE_MESSAGE

/decl/emote/human/signal/get_emote_message_3p(var/mob/user, var/atom/target, var/extra_params)
	if(istype(user) && !(user.r_hand && user.l_hand))
		var/t1 = round(text2num(extra_params))
		if(isnum(t1) && t1 <= 5)
			return "USER raises [t1] finger\s."
	return .. ()

/decl/emote/human/handshake
	key = "handshake"
	check_restraints = TRUE
	emote_message_3p = "USER shakes hands with USER_THEMself."
	emote_message_3p_target = "USER shakes hands with TARGET."
	message_type = VISIBLE_MESSAGE

/decl/emote/human/handshake/get_emote_message_3p(var/atom/user, var/atom/target, var/extra_params)
	if(target && !user.Adjacent(target))
		return "USER holds out USER_HIS hand out to TARGET."
	return ..()