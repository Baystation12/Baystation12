/// How long the chat message's spawn-in animation will occur for
#define CHAT_MESSAGE_SPAWN_TIME 0.2 SECONDS
/// How long the chat message will exist prior to any exponential decay
#define CHAT_MESSAGE_LIFESPAN 5 SECONDS
/// How long the chat message's end of life fading animation will occur for
#define CHAT_MESSAGE_EOL_FADE 0.7 SECONDS
/// Grace period for fade before we actually delete the chat message
#define CHAT_MESSAGE_GRACE_PERIOD 0.2 SECONDS

/// Factor of how much the message index (number of messages) will account to exponential decay
#define CHAT_MESSAGE_EXP_DECAY 0.7
/// Factor of how much height will account to exponential decay
#define CHAT_MESSAGE_HEIGHT_DECAY 0.9
/// Approximate height in pixels of an 'average' line, used for height decay
#define CHAT_MESSAGE_APPROX_LHEIGHT 11

/// Max default runechat message length in characters
#define CHAT_MESSAGE_LENGTH 68
/// Max extended runechat message length in characters
#define CHAT_MESSAGE_EXT_LENGTH 150
/// Max default runechat message width in pixels
#define CHAT_MESSAGE_WIDTH 96
/// Max extended runechat message width in pixels
#define CHAT_MESSAGE_EXT_WIDTH 128

// Tweak these defines to change the available color ranges
#define CM_COLOR_SAT_MIN 0.6
#define CM_COLOR_SAT_MAX 0.7
#define CM_COLOR_LUM_MIN 0.65
#define CM_COLOR_LUM_MAX 0.8

/// Macro from Lummox used to get height from a MeasureText proc.
/// resolves the MeasureText() return value once, then resolves the height, then sets return_var to that.
#define WXH_TO_HEIGHT(measurement, return_var) \
	do { \
		var/_measurement = measurement; \
		return_var = text2num(copytext(_measurement, findtextEx(_measurement, "x") + 1)); \
	} while(FALSE);

// Cached runechat icon
GLOBAL_LIST_EMPTY(runechat_image_cache)

/hook/startup/proc/runechat_images()
	var/image/radio_image = image('icons/chaticons.dmi', icon_state = "radio")
	GLOB.runechat_image_cache["radio"] = radio_image

	var/image/emote_image = image('icons/chaticons.dmi', icon_state = "emote")
	GLOB.runechat_image_cache["emote"] = emote_image

	return TRUE

/**
  * # Chat Message Overlay
  *
  * Datum for generating a message overlay on the map
  * Ported from TGStation; https://github.com/tgstation/tgstation/pull/50608, author:  bobbahbrown
  */
/datum/chatmessage
	/// The visual element of the chat message
	var/image/message
	/// The location in which the message is appearing
	var/atom/message_loc
	/// The client who heard this message
	var/client/owned_by
	/// Contains the scheduled destruction time, used for scheduling EOL
	var/scheduled_destruction
	/// Contains the time that the EOL for the message will be complete, used for qdel scheduling
	var/eol_complete
	/// Contains the approximate amount of lines for height decay
	var/approx_lines
	/// Contains the reference to the next chatmessage in the bucket, used by runechat subsystem
	var/datum/chatmessage/next
	/// Contains the reference to the previous chatmessage in the bucket, used by runechat subsystem
	var/datum/chatmessage/prev
	/// The current index used for adjusting the layer of each sequential chat message such that recent messages will overlay older ones
	var/static/current_z_idx = 0
	/// When we started animating the message
	var/animate_start = 0
	/// Our animation lifespan, how long this message will last
	var/animate_lifespan = 0

/**
  * Constructs a chat message overlay
  *
  * Arguments:
  * * text - The text content of the overlay
  * * target - The target atom to display the overlay at
  * * owner - The mob that owns this overlay, only this mob will be able to view it
  * * extra_classes - Extra classes to apply to the span that holds the text
  * * lifespan - The lifespan of the message in deciseconds
  */
/datum/chatmessage/New(text, atom/target, mob/owner, list/extra_classes = list(), lifespan = CHAT_MESSAGE_LIFESPAN)
	. = ..()
	if (!istype(target))
		CRASH("Invalid target given for chatmessage")
	if(QDELETED(owner) || !istype(owner) || !owner.client)
		stack_trace("[src.type] created with [isnull(owner) ? "null" : "invalid"] mob owner")
		qdel(src)
		return
	invoke_async(src, .proc/generate_image, text, target, owner, extra_classes, lifespan)

/datum/chatmessage/Destroy()
	if (!QDELING(owned_by))
		if(world.timeofday < animate_start + animate_lifespan)
			stack_trace("Del'd before we finished fading, with [(animate_start + animate_lifespan) - world.timeofday] time left")

		if (owned_by.seen_messages)
			LAZYREMOVEASSOC(owned_by.seen_messages, message_loc, src)
		owned_by.images.Remove(message)

	owned_by = null
	message_loc = null
	message = null
	return ..()

/**
  * Generates a chat message image representation
  *
  * Arguments:
  * * text - The text content of the overlay
  * * target - The target atom to display the overlay at
  * * owner - The mob that owns this overlay, only this mob will be able to view it
  * * extra_classes - Extra classes to apply to the span that holds the text
  * * lifespan - The lifespan of the message in deciseconds
  */
/datum/chatmessage/proc/generate_image(text, atom/target, mob/owner, list/extra_classes, lifespan)
	// Register client who owns this message
	owned_by = owner.client
	GLOB.destroyed_event.register(owned_by, src, .proc/qdel_self)

	// Remove spans in the message from things like the recorder
	var/static/regex/span_check = new(@"<\/?span[^>]*>", "gi")
	text = replacetext(text, span_check, "")

	// Clip message
	var/extra_length = owned_by.get_preference_value(/datum/client_preference/runechat_messages_length) == GLOB.PREF_LONG
	var/maxlen = extra_length ? CHAT_MESSAGE_EXT_LENGTH : CHAT_MESSAGE_LENGTH
	var/msgwidth = extra_length ? CHAT_MESSAGE_EXT_WIDTH : CHAT_MESSAGE_WIDTH
	if (length_char(text) > maxlen)
		text = copytext_char(text, 1, maxlen + 1) + "..." // BYOND index moment

	// Calculate target color if not already present
	if (!target.chat_color || target.chat_color_name != target.name)
		target.chat_color = colorize_string(target.name)
		target.chat_color_darkened = colorize_string(target.name, 0.85, 0.85)
		target.chat_color_name = target.name

	// Get rid of any URL schemes that might cause BYOND to automatically wrap something in an anchor tag
	var/static/regex/url_scheme = new(@"[A-Za-z][A-Za-z0-9+-\.]*:\/\/", "g")
	text = replacetext(text, url_scheme, "")

	// Reject whitespace
	var/static/regex/whitespace = new(@"^\s*$")
	if (whitespace.Find(text))
		qdel(src)
		return

	// Non mobs speakers can be small
	if (!ismob(target))
		extra_classes |= "small"

	// Why are you yelling?
	if(copytext_char(text, -2) == "!!")
		extra_classes |= "yell"

	// Append radio icon if from a virtual speaker
	if (extra_classes.Find("virtual-speaker"))
		var/image/r_icon = image('icons/chaticons.dmi', icon_state = "radio")
		text = "\icon[r_icon]&nbsp;" + text
	else if (extra_classes.Find("emote"))
		var/image/r_icon = image('icons/chaticons.dmi', icon_state = "emote")
		text = "\icon[r_icon]&nbsp;" + text

	// We dim italicized text to make it more distinguishable from regular text
	var/tgt_color = target.chat_color
	if (extra_classes.Find("italics") || extra_classes.Find("emote"))
		tgt_color = target.chat_color_darkened

	// Approximate text height
	// Note we have to replace HTML encoded metacharacters otherwise MeasureText will return a zero height
	// BYOND Bug #2563917
	// Construct text
	var/static/regex/html_metachars = new(@"&[A-Za-z]{1,7};", "g")
	var/complete_text = "<span class='center maptext [extra_classes != null ? extra_classes.Join(" ") : ""]' style='color: [tgt_color]'>[text]</span>"
	var/mheight
	WXH_TO_HEIGHT(owned_by.MeasureText(replacetext(complete_text, html_metachars, "m"), null, msgwidth), mheight)

	invoke_async(src, .proc/finish_image_generation, mheight, target, owner, complete_text, lifespan)

/// Finishes the image generation after the MeasureText() call in generate_image().
/// Necessary because after that call the proc can resume at the end of the tick and cause overtime.
/datum/chatmessage/proc/finish_image_generation(mheight, atom/target, mob/owner, complete_text, lifespan)
	var/rough_time = world.timeofday
	approx_lines = max(1, mheight / CHAT_MESSAGE_APPROX_LHEIGHT)

	// Translate any existing messages upwards, apply exponential decay factors to timers
	message_loc = isturf(target) ? target : get_atom_on_turf(target)
	if (owned_by.seen_messages)
		var/idx = 1
		var/combined_height = approx_lines
		for(var/datum/chatmessage/m as anything in owned_by.seen_messages[message_loc])
			combined_height += m.approx_lines

			var/time_spent = rough_time - m.animate_start
			var/time_before_fade = m.animate_lifespan - CHAT_MESSAGE_EOL_FADE

			// When choosing to update the remaining time we have to be careful not to update the
			// scheduled time once the EOL has been executed.
			if (time_spent >= time_before_fade)
				animate(m.message, pixel_y = m.message.pixel_y + mheight, time = CHAT_MESSAGE_SPAWN_TIME, flags = ANIMATION_PARALLEL)
				continue

			var/remaining_time = time_before_fade * (CHAT_MESSAGE_EXP_DECAY ** idx++) * (CHAT_MESSAGE_HEIGHT_DECAY ** combined_height)
			// Ensure we don't accidentially spike alpha up or something silly like that
			m.message.alpha = m.get_current_alpha(time_spent)
			if (remaining_time > 0)
				// Stay faded in for a while, then
				animate(m.message, alpha = 255, remaining_time)
				// Fade out
				animate(alpha = 0, time = CHAT_MESSAGE_EOL_FADE)
				m.animate_lifespan = remaining_time + CHAT_MESSAGE_EOL_FADE
			else
				// Your time has come my son
				animate(alpha = 0, time = CHAT_MESSAGE_EOL_FADE)
			// We run this after the alpha animate, because we don't want to interrup it, but also don't want to block it by running first
			// Sooo instead we do this. bit messy but it fuckin works
			animate(m.message, pixel_y = m.message.pixel_y + mheight, time = CHAT_MESSAGE_SPAWN_TIME, flags = ANIMATION_PARALLEL)

	// Build message image
	message = image(loc = message_loc, layer = ABOVE_HUMAN_LAYER)
	message.plane = RUNECHAT_PLANE
	message.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA | KEEP_APART
	message.alpha = 0
	message.pixel_y = target.maptext_height
	message.maptext_width = CHAT_MESSAGE_WIDTH
	message.maptext_height = mheight * 1.25
	message.maptext_x = (CHAT_MESSAGE_WIDTH - owner.bound_width) * -0.5
	message.maptext = complete_text

	// View the message
	LAZYADDASSOCLIST(owned_by.seen_messages, message_loc, src)
	owned_by.images |= message

	// Fade in
	animate(message, alpha = 255, time = CHAT_MESSAGE_SPAWN_TIME)
	var/time_before_fade = lifespan - CHAT_MESSAGE_SPAWN_TIME - CHAT_MESSAGE_EOL_FADE

	// Stay faded in
	animate(alpha = 255, time = time_before_fade)

	// Fade out
	animate(alpha = 0, time = CHAT_MESSAGE_EOL_FADE)

	// Desctruct yourself
	addtimer(new Callback(src, .proc/qdel_self), lifespan + CHAT_MESSAGE_GRACE_PERIOD, TIMER_UNIQUE|TIMER_OVERRIDE)

/datum/chatmessage/proc/get_current_alpha(time_spent)
	if(time_spent < CHAT_MESSAGE_SPAWN_TIME)
		return (time_spent / CHAT_MESSAGE_SPAWN_TIME) * 255

	var/time_before_fade = animate_lifespan - CHAT_MESSAGE_EOL_FADE
	if(time_spent <= time_before_fade)
		return 255

	return (1 - ((time_spent - time_before_fade) / CHAT_MESSAGE_EOL_FADE)) * 255

/**
  * Creates a message overlay at a defined location for a given speaker
  *
  * Arguments:
  * * speaker - The atom who is saying this message
  * * message - The text content of the message
  * * italics - Decides if this should be small or not, as generally italics text are for whisper/radio overhear
  * * existing_extra_classes - Additional classes to add to the message
  */
/mob/proc/create_chat_message(atom/movable/speaker, message, italics, list/existing_extra_classes, audible = TRUE)
	if(!client)
		return

	// Doesn't want to hear
	if(ismob(speaker) && client.get_preference_value(/datum/client_preference/runechat_mob) != GLOB.PREF_YES)
		return
	if(isobj(speaker) && client.get_preference_value(/datum/client_preference/runechat_obj) != GLOB.PREF_YES)
		return

	// Incapable of receiving
	if((audible && is_deaf()) || (!audible && is_blind()))
		return

	// Check for virtual speakers (aka hearing a message through a radio)
	if(existing_extra_classes.Find("radio"))
		return

	/* Not currently necessary
	message = strip_html_properly(message)
	if(!message)
		return
	*/

	var/list/extra_classes = list()
	extra_classes += existing_extra_classes

	if(italics)
		extra_classes |= "italics"

	// Display visual above source
	new /datum/chatmessage(message, speaker, src, extra_classes)

/**
  * Gets a color for a name, will return the same color for a given string consistently within a round.atom
  *
  * Note that this proc aims to produce pastel-ish colors using the HSL colorspace. These seem to be favorable for displaying on the map.
  *
  * Arguments:
  * * name - The name to generate a color for
  * * sat_shift - A value between 0 and 1 that will be multiplied against the saturation
  * * lum_shift - A value between 0 and 1 that will be multiplied against the luminescence
  */
/datum/chatmessage/proc/colorize_string(name, sat_shift = 1, lum_shift = 1)
	// seed to help randomness
	var/static/rseed = rand(1,26)

	// get hsl using the selected 6 characters of the md5 hash
	var/hash = copytext(md5(name), rseed, rseed + 6)
	var/h = hex2num(copytext(hash, 1, 3)) * (360 / 255)
	var/s = SHIFTR(hex2num(copytext(hash, 3, 5)), 2) * ((CM_COLOR_SAT_MAX - CM_COLOR_SAT_MIN) / 63) + CM_COLOR_SAT_MIN
	var/l = SHIFTR(hex2num(copytext(hash, 5, 7)), 2) * ((CM_COLOR_LUM_MAX - CM_COLOR_LUM_MIN) / 63) + CM_COLOR_LUM_MIN

	// adjust for shifts
	s *= clamp(sat_shift, 0, 1)
	l *= clamp(lum_shift, 0, 1)

	// convert to rgba
	var/h_int = round(h/60) // mapping each section of H to 60 degree sections
	var/c = (1 - abs(2 * l - 1)) * s
	var/x = c * (1 - abs((h / 60) % 2 - 1))
	var/m = l - c * 0.5
	x = (x + m) * 255
	c = (c + m) * 255
	m *= 255
	switch(h_int)
		if(0)
			return rgb(c,x,m)
		if(1)
			return rgb(x,c,m)
		if(2)
			return rgb(m,c,x)
		if(3)
			return rgb(m,x,c)
		if(4)
			return rgb(x,m,c)
		if(5)
			return rgb(c,m,x)

/atom/proc/runechat_message(message, range = world.view, italics, list/classes = list(), audible = TRUE)
	var/list/hearing_mobs = list()
	var/list/objs = list()
	get_mobs_and_objs_in_view_fast(get_turf(src), range, hearing_mobs, objs, checkghosts = FALSE)

	for(var/mob in hearing_mobs)
		var/mob/M = mob
		if(!M.client)
			continue
		M.create_chat_message(src, message, italics, classes, audible)


#undef CHAT_MESSAGE_SPAWN_TIME
#undef CHAT_MESSAGE_LIFESPAN
#undef CHAT_MESSAGE_EOL_FADE
#undef CHAT_MESSAGE_GRACE_PERIOD
#undef CHAT_MESSAGE_EXP_DECAY
#undef CHAT_MESSAGE_HEIGHT_DECAY
#undef CHAT_MESSAGE_APPROX_LHEIGHT
#undef CHAT_MESSAGE_LENGTH
#undef CHAT_MESSAGE_EXT_LENGTH
#undef CHAT_MESSAGE_WIDTH
#undef CHAT_MESSAGE_EXT_WIDTH

#undef CM_COLOR_SAT_MIN
#undef CM_COLOR_SAT_MAX
#undef CM_COLOR_LUM_MIN
#undef CM_COLOR_LUM_MAX
