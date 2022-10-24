/singleton/emote/human
	key = "vomit"

/singleton/emote/human/check_user(mob/living/carbon/human/user)
	return (istype(user) && user.check_has_mouth() && !user.isSynthetic())

/singleton/emote/human/do_emote(mob/living/carbon/human/user)
	user.vomit()

/singleton/emote/human/deathgasp
	key = "deathgasp"

/singleton/emote/human/deathgasp/get_emote_message_3p(mob/living/carbon/human/user)
	return "USER [user.species.get_death_message()]"

/singleton/emote/human/swish
	key = "swish"

/singleton/emote/human/swish/do_emote(mob/living/carbon/human/user)
	user.animate_tail_once()

/singleton/emote/human/wag
	key = "wag"

/singleton/emote/human/wag/do_emote(mob/living/carbon/human/user)
	user.animate_tail_start()

/singleton/emote/human/sway
	key = "sway"

/singleton/emote/human/sway/do_emote(mob/living/carbon/human/user)
	user.animate_tail_start()

/singleton/emote/human/qwag
	key = "qwag"

/singleton/emote/human/qwag/do_emote(mob/living/carbon/human/user)
	user.animate_tail_fast()

/singleton/emote/human/fastsway
	key = "fastsway"

/singleton/emote/human/fastsway/do_emote(mob/living/carbon/human/user)
	user.animate_tail_fast()

/singleton/emote/human/swag
	key = "swag"

/singleton/emote/human/swag/do_emote(mob/living/carbon/human/user)
	user.animate_tail_stop()

/singleton/emote/human/stopsway
	key = "stopsway"

/singleton/emote/human/stopsway/do_emote(mob/living/carbon/human/user)
	user.animate_tail_stop()
