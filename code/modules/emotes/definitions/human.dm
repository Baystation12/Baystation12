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
