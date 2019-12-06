/decl/emote/slime
	key = "nomood"
	var/mood

/decl/emote/slime/do_extra(var/mob/living/carbon/slime/user)
	user.mood = mood
	user.regenerate_icons()

/decl/emote/slime/check_user(var/atom/user)
	return istype(user, /mob/living/carbon/slime)

/decl/emote/slime/pout
	key = "pout"
	mood = "pout"

/decl/emote/slime/sad
	key = "sad"
	mood = "sad"

/decl/emote/slime/angry
	key = "angry"
	mood = "angry"

/decl/emote/slime/frown
	key = "frown"
	mood = "mischevous"

/decl/emote/slime/smile
	key = "smile"
	mood = ":3"
