// Thanks to Burger from Burgerstation for the foundation for this
var/global/list/floating_chat_colors = list()

/// How long the chat message's spawn-in animation will occur for
#define CHAT_MESSAGE_SPAWN_TIME 0.2 SECONDS
/// How long the chat message will exist prior to any exponential decay
#define CHAT_MESSAGE_LIFESPAN 5 SECONDS
/// How long the chat message's end of life fading animation will occur for
#define CHAT_MESSAGE_EOL_FADE 0.7 SECONDS
/// Max width of chat message in pixels
#define CHAT_MESSAGE_WIDTH 128
/// Max width of chat message in pixels
#define CHAT_MESSAGE_HEIGHT 64

/// LAZYLIST of `/image`. Floating text message images being processed by this atom.
/atom/movable/var/list/stored_chat_text

/proc/strip_floating_text(message)
	/// Get rid of any URL schemes that might cause BYOND to automatically wrap something in an anchor tag
	var/static/regex/url_scheme = new(@"[A-Za-z][A-Za-z0-9+-\.]*:\/\/", "g")
	message = replacetext(message, url_scheme, "")

	var/static/regex/html_metachars = new(@"&[A-Za-z]{1,7};", "g")
	return replacetext(message, html_metachars, "")

/proc/format_floating_text(message, icon_prepend, limit)
	message = strip_floating_text(message)
	if(icon_prepend)
		message = "[icon_prepend] [message]"
	if(length_char(message) > limit)
		message = "[copytext_char(message, 1, limit)]..."
	return capitalize(message)

/atom/movable/proc/animate_chat(raw_message, datum/language/language, size, list/show_to, icon_state_override, duration = CHAT_MESSAGE_LIFESPAN)
	set waitfor = FALSE

	var/message = strip_floating_text(raw_message)
	var/original_message = message

	//additional style params for the message
	var/style
	var/fontsize = 7
	var/limit = 120

	var/icon_prepend
	if(language && language.name == "Noise" && !icon_state_override)
		var/image/emote_icon = image(icon = 'icons/mob/floating_chat_icons.dmi', icon_state = "emote")
		icon_prepend = "\icon[emote_icon]"
		size = RUNECHAT_SMALL
	else if(icon_state_override)
		var/image/emote_icon = image(icon = 'icons/mob/floating_chat_icons.dmi', icon_state = icon_state_override)
		icon_prepend = "\icon[emote_icon]"

	if(icon_prepend)
		limit += length_char(icon_prepend)
	if(size == RUNECHAT_SMALL)
		fontsize = 6

	if(copytext_char(message, length_char(message) - 1) == "!!" || size == RUNECHAT_LARGE)
		fontsize = 8
		limit = 60
		if(icon_prepend)
			limit += length_char(icon_prepend)
		style += "font-weight: bold;"

	if(!global.floating_chat_colors[name])
		global.floating_chat_colors[name] = get_random_colour(160, 230)
	style += "color: [global.floating_chat_colors[name]];"

	var/non_verbal = language?.flags & (NONVERBAL | SIGNLANG)
	var/image/understood
	var/shift_existing = TRUE
	for(var/client/C in show_to)
		var/mob/listener = C.mob
		if(listener.is_deaf() || C.get_preference_value(/datum/client_preference/floating_messages) != GLOB.PREF_SHOW)
			continue
		var/image/shown
		if(!listener.say_understands(src, language))
			if(language)
				shown = generate_floating_text(src, (icon_prepend ? "[icon_prepend] " : "") + language.scramble(original_message, listener.languages), style, fontsize, duration, show_to, 8, shift_existing)
				shift_existing = FALSE
		else if(!non_verbal && listener.get_hearing_loss() > 0)
			var/heard = listener.apply_hearing_loss(raw_message, src, language, (src in view(listener)) && !listener.is_blind())
			if(heard != raw_message)
				shown = generate_floating_text(src, format_floating_text(heard, icon_prepend, limit), style, fontsize, duration, show_to, null, shift_existing)
				shift_existing = FALSE
		if(!shown)
			if(!understood)
				understood = generate_floating_text(src, format_floating_text(raw_message, icon_prepend, limit), style, fontsize, duration, show_to, null, shift_existing)
				shift_existing = FALSE
			shown = understood
		C.images += shown

/proc/generate_floating_text(atom/movable/holder, message, style, size, duration, show_to, height_adjust, shift_existing = TRUE)
	var/image/I = image(null, get_atom_on_turf(holder))
	I.plane = HUD_PLANE
	I.layer = HUD_ABOVE_ITEM_LAYER
	I.alpha = 0
	I.maptext_width = CHAT_MESSAGE_WIDTH
	I.maptext_height = CHAT_MESSAGE_HEIGHT
	I.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA | KEEP_APART
	I.pixel_w = -round(I.maptext_width/2) + 16 + holder.get_overhead_text_x_offset()
	I.pixel_z = holder.get_overhead_text_y_offset()

	style = "-dm-text-outline: 1px black; font-size: [size]px; line-height: 1.1; [style]"
	I.maptext = "<center><span style=\"[style]\">[message]</span></center>"
	animate(I, CHAT_MESSAGE_SPAWN_TIME, alpha = 255, pixel_z = 28)

	if(shift_existing)
		var/move_up_z = 10
		for(var/image/old in holder.stored_chat_text)
			var/pixel_z_new = old.pixel_z + move_up_z
			animate(old, CHAT_MESSAGE_SPAWN_TIME, pixel_z = pixel_z_new)

	LAZYADD(holder.stored_chat_text, I)

	addtimer(new Callback(GLOBAL_PROC, GLOBAL_PROC_REF(remove_floating_text), holder, I), duration)
	addtimer(new Callback(GLOBAL_PROC, GLOBAL_PROC_REF(remove_images_from_clients), I, show_to), duration + CHAT_MESSAGE_EOL_FADE)

	return I

/proc/remove_floating_text(atom/movable/holder, image/I)
	animate(I, CHAT_MESSAGE_EOL_FADE, pixel_z = I.pixel_z + 12, alpha = 0, flags = ANIMATION_PARALLEL)
	LAZYREMOVE(holder.stored_chat_text, I)

#undef CHAT_MESSAGE_SPAWN_TIME
#undef CHAT_MESSAGE_LIFESPAN
#undef CHAT_MESSAGE_EOL_FADE
#undef CHAT_MESSAGE_WIDTH
#undef CHAT_MESSAGE_HEIGHT
