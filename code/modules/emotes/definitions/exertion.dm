
/decl/emote/exertion/biological
	key = "esweat"
	emote_range = 4
	emote_message_1p = "Вы сильно потеете."
	emote_message_3p = "USER сильно потеет."

/decl/emote/exertion/biological/check_user(mob/living/user)
	if(istype(user) && !user.isSynthetic())
		return ..()
	return FALSE

/decl/emote/exertion/biological/breath
	key = "ebreath"
	emote_message_1p = "You feel out of breath."
	emote_message_3p = "USER looks out of breath."

/decl/emote/exertion/biological/pant
	key = "epant"
	emote_range = 3
	message_type = AUDIBLE_MESSAGE
	emote_message_1p = "You pant to catch your breath."
	emote_message_3p = "USER pants for air."
	emote_message_impaired = "You can see USER breathing heavily."

/decl/emote/exertion/synthetic
	key = "ewhine"
	emote_range = 3
	message_type = AUDIBLE_MESSAGE
	emote_message_1p = "Вы перегрузили свои приводы."
	emote_message_3p = "USER's приводы становятся белыми от напряжения."

/decl/emote/exertion/synthetic/check_user(mob/living/user)
	if(istype(user) && user.isSynthetic())
		return ..()
	return FALSE

/decl/emote/exertion/synthetic/creak
	key = "ecreak"
	emote_message_1p = "Показатели нагрузки на шасси резко возрастают."
	emote_message_3p = "USER's joints creak with stress."
