/singleton/emote/slime
	key = "nomood"
	var/mood

/singleton/emote/slime/do_extra(mob/living/carbon/slime/user)
	user.mood = mood
	user.regenerate_icons()

/singleton/emote/slime/check_user(atom/user)
	return istype(user, /mob/living/carbon/slime)

/singleton/emote/slime/pout
	key = "pout"
	mood = "pout"

/singleton/emote/slime/sad
	key = "sad"
	mood = "sad"

/singleton/emote/slime/angry
	key = "angry"
	mood = "angry"

/singleton/emote/slime/frown
	key = "frown"
	mood = "mischevous"

/singleton/emote/slime/smile
	key = "smile"
	mood = ":3"
