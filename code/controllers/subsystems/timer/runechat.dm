TIMER_SUBSYSTEM_DEF(runechat)
	name = "Runechat"
	priority = SS_PRIORITY_RUNECHAT

	///queue for runechat messages receiving client MeasureText() calls and ready to create the runechat images
	var/static/list/message_queue = list()

	///list that keeps track of all runechat message datums by their creation_string. used to keep track of runechat messages.
	///associative list of the form: list(creation string = the chatmessage datum assigned to that string)
	var/static/list/messages_by_creation_string = list()

	var/static/list/language_icons = list()

	/// When true, uses the game ID as a salt for color generation
	var/static/vary_colors_per_game = TRUE

	//Used in visible_message_flags, audible_message_flags and runechat_flags
	var/const/FLAGS_EMOTE = FLAG(0)

	var/const/FLAGS_DEFAULT = EMPTY_BITFIELD

	/// The dimensions of the chat message icons
	var/const/CHAT_MESSAGE_ICON_SIZE = 9


/datum/controller/subsystem/timer/runechat/Recover()
	..()


/datum/controller/subsystem/timer/runechat/UpdateStat(time)
	if (PreventUpdateStat(time))
		return ..()
	..("")


/datum/controller/subsystem/timer/runechat/Initialize(start_uptime)
	for (var/datum/language/language as anything in subtypesof(/datum/language))
		var/state = initial(language.icon_state)
		if (!state)
			continue
		var/icon/icon = icon('icons/language.dmi', state)
		icon.Scale(CHAT_MESSAGE_ICON_SIZE, CHAT_MESSAGE_ICON_SIZE)
		language_icons[language] = icon


/datum/controller/subsystem/timer/runechat/fire(resumed, no_mc_tick)
	..()
	if (!message_queue.len)
		return
	var/cut_until = 1
	for (var/datum/callback/callback as anything in message_queue)
		++cut_until
		if (!QDELETED(callback))
			callback.Invoke()
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			message_queue.Cut(1, cut_until)
			return
	message_queue.Cut()


/datum/controller/subsystem/timer/runechat/proc/CreateChatColors(atom/movable/movable, using_text)
	var/hash = md5("[using_text ? using_text : movable.name][vary_colors_per_game ? game_id : ""]")
	var/hue = hex2num(copytext(hash, 1, 2)) * 360 / 16
	var/chroma = hex2num(copytext(hash, 2, 3)) + 60
	var/grey_luminance = hex2num(copytext(hash, 3, 4)) + 55
	movable.chat_color_darkened = rgb(hue, chroma, grey_luminance, space = COLORSPACE_HCY)
	movable.chat_color = rgb(hue, chroma, grey_luminance + 15, space = COLORSPACE_HCY)
	movable.chat_color_text = using_text ? using_text : movable.name

/// The last text used to calculate a color for this atom
/atom/var/chat_color_text

/// The color to use for runechat from this atom
/atom/var/chat_color

/// The color to use for italicized runechat from this atom
/atom/var/chat_color_darkened


/// Messages currently visible to this client, as list(loc = list(/datum/runechat, ...))
/client/var/list/runechat_messages

/client/Destroy()
	runechat_messages?.Cut()
	runechat_messages = null
	..()


/datum/client_preference/runechat
	description = "Enable Runechat"
	key = "runechat"


/datum/client_preference/runechat_emotes
	description = "Emotes Use Runechat"
	key = "runechat_emotes"


/datum/client_preference/runechat_atoms
	description = "Objects Use Runechat"
	key = "runechat_atoms"
	default_value = GLOB.PREF_NO


/datum/client_preference/runechat_long
	description = "Long Runechat Messages"
	key = "runechat_long"
	default_value = GLOB.PREF_NO


/**
 * # Chat Message Overlay
 *
 * Datum for generating a message overlay on the map
 */
/datum/chatmessage
	/// How long the chat message's spawn-in animation will occur for
	var/const/CHAT_MESSAGE_SPAWN_TIME = 0.2 SECONDS

	/// How long the chat message will exist prior to any exponential decay
	var/const/CHAT_MESSAGE_LIFESPAN = 5 SECONDS

	/// How long the chat message's end of life fading animation will occur for
	var/const/CHAT_MESSAGE_EOL_FADE = 0.7 SECONDS

	/// Factor of how much the message index (number of messages) will account to exponential decay
	var/const/CHAT_MESSAGE_EXP_DECAY = 0.7

	/// Factor of how much height will account to exponential decay
	var/const/CHAT_MESSAGE_HEIGHT_DECAY = 0.9

	/// Approximate height in pixels of an 'average' line, used for height decay
	var/const/CHAT_MESSAGE_APPROX_LHEIGHT = 11

		/// Max width of chat message in pixels
	var/const/MESSAGE_WIDTH = 96

	/// max width of long chat message in pixels
	var/const/MESSAGE_WIDTH_LONG = 128

	/// Max length of chat message in characters
	var/const/MESSAGE_LENGTH = 68

	/// max length of long chat message in characters
	var/const/MESSAGE_LENGTH_LONG = 150

	///Base layer of chat elements
	var/const/CHAT_LAYER = SPEECH_INDICATOR_LAYER + 1

	///Highest possible layer of chat elements
	var/const/CHAT_LAYER_MAX = SPEECH_INDICATOR_LAYER + 2

	/// Maximum precision of float before rounding errors occur (in this context)
	var/const/CHAT_LAYER_Z_STEP = 0.0001

	/// The number of z-layer 'slices' usable by the chat message layering
	var/const/CHAT_LAYER_MAX_Z = (CHAT_LAYER_MAX - CHAT_LAYER) / CHAT_LAYER_Z_STEP

	///the layer value given to the message image in the last animation step after the image has faded.
	///used for either the initialization animation sequence or the edited stage 2 duration animation sequence.
	///to the server the images layer is set instantly to this value, but the client cant see it because its only adjusted for them
	/// after the message is inivisible. so this is used to mark what animation is being used for the server.
	var/const/MESSAGE_ANIMATION_DEFAULT_LAYER_MARK = 1020

	///the layer value given to the message image for the animation sequence where the image is forced into fading.
	///used so that the server doesnt force the image to fade twice.
	var/const/MESSAGE_ANIMATION_FORCE_FADE_LAYER_MARK = 1021

	///the layer mark given to the last stage of the animation sequence after it has been edited but not forced into the fading animation.
	var/const/MESSAGE_ANIMATION_EDIT_FADE_LAYER_MARK = 1022

	/// list of images generated for the message sent to each hearing client.
	/// associative list of the form: list(message image = client using that image)
	var/list/image/messages

	/// The clients who heard this message. only populated with clients that have been assigned an image
	/// associative list of the form: list(client who hears this message = chat message image that client uses)
	var/list/client/hearers

	/// all clients that have been assigned to this chatmessage datum from show_runechat().
	/// needed to ensure that the same client cant be a hearer to a message twice.
	/// associative list of the form: list(client = TRUE)
	var/list/client/all_hearers

	/// The location in which the message is appearing
	var/atom/message_loc

	/// what language the message is spoken in.
	var/datum/language/message_language

	/// Contains the approximate amount of lines for height decay for each message image.
	/// associative list of the form: list(message image = approximate lines for that image)
	var/list/approx_lines

	/// The current index used for adjusting the layer of each sequential chat message such that recent messages will overlay older ones
	var/static/current_z_idx = 0

	/// Contains the hash of our main assigned timer for the qdel_self fading event. by the time this timer executes all clients should have
	///already seen the end of the maptext animation sequence and cant see their message anymore. so this will remove all message images from all clients
	var/fadertimer = null

	///concatenated string of parameters given to us at creation
	var/creation_parameters = ""

	///if TRUE, then this datum was dropped from its spot in SSrunechat.messages_by_creation_string and thus wont remove that spot of the list.
	var/dropped_hash = FALSE

	///how long the main stage of this message lasts (maptext fully visible) by default.
	var/lifespan = 0

	///associative list of the form: list(message image = world.time that image is set to fade out)
	var/list/fade_times_by_image

	///what world.time this message datum was created.
	var/creation_time = 0

/**
 * Constructs a chat message overlay
 *
 * Arguments:
 * * text - The text content of the overlay
 * * target - The target atom to display the overlay at
 * * owner - The mob that owns this overlay, only this mob will be able to view it
 * * language - The language this message was spoken in
 * * extra_classes - Extra classes to apply to the span that holds the text
 * * lifespan - The lifespan of the message in deciseconds
 */
/datum/chatmessage/New(text, atom/target, datum/language/language, list/classes, lifespan = CHAT_MESSAGE_LIFESPAN)
	. = ..()
	if (!istype(target))
		CRASH("Invalid target given for chatmessage")
	src.lifespan = lifespan
	creation_time = world.time
	creation_parameters = "[text]-\ref[target]-[language]-[classes ? list2params(classes) : ""]-[creation_time]"
	if (++current_z_idx >= CHAT_LAYER_MAX_Z)
		current_z_idx = 0
	message_loc = isturf(target) ? target : get_atom_on_turf(target)
	GLOB.destroyed_event.register(message_loc, src, .proc/qdel_self)
	var/total_existence_time = CHAT_MESSAGE_SPAWN_TIME + lifespan + CHAT_MESSAGE_EOL_FADE + 1 SECONDS
	fadertimer = addtimer(CALLBACK(src, .proc/qdel_self), total_existence_time, TIMER_STOPPABLE|TIMER_DELETE_ME, SSrunechat)

	//in the case of a hash collision this will drop the older chatmessage datum from this list. this is fine however
	//since the dropped datum will still properly handle itself including deletion etc.
	//all this means is that you cant create message A on x listeners in some synchronous code execution loop,
	//then later on start a message B with the exact same parameters (so theres a hash collision) on y listeners
	//and then afterwards try to again add more listeners to message A.
	//if A and B have the exact same creation_parameters then the code has to assume that all listeners after B belong to B not A
	if(SSrunechat.messages_by_creation_string[creation_parameters])
		var/datum/chatmessage/old_message = SSrunechat.messages_by_creation_string[creation_parameters]
		old_message.dropped_hash = TRUE
	SSrunechat.messages_by_creation_string[creation_parameters] = src
	messages = list()
	hearers = list()
	approx_lines = list()
	fade_times_by_image = list()
	all_hearers = list()


/datum/chatmessage/Destroy()
	GLOB.destroyed_event.unregister(message_loc, src, .proc/qdel_self)
	for (var/client/hearer in all_hearers)
		GLOB.destroyed_event.unregister(hearer, src, .proc/HearerQdeleted)
		LAZYREMOVEASSOC(hearer.runechat_messages, message_loc, src)
		if (istype(hearers[hearer], /image))
			hearer.images -= hearers[hearer]
	for(var/datum/callback/queued_callback as anything in SSrunechat.message_queue)
		if (!queued_callback)
			SSrunechat.message_queue -= queued_callback
			continue
		if (queued_callback.object == src)
			SSrunechat.message_queue -= queued_callback
			qdel(queued_callback)
			break
	if (!dropped_hash)
		SSrunechat.messages_by_creation_string -= creation_parameters
	message_loc = null
	messages = null
	hearers = null
	all_hearers = null
	approx_lines = null
	fadertimer = null
	return ..()


/datum/chatmessage/proc/HearerQdeleted(client/hearer)
	if(!istype(hearer))
		return
	LAZYREMOVEASSOC(hearer.runechat_messages, message_loc, src)
	if(istype(hearers?[hearer], /image))
		var/image/seen_image = hearers[hearer]
		messages -= seen_image
	hearers -= hearer
	all_hearers -= hearer


/**
 * generates the spanned text used for the final image and creates a callback in SSrunechat to call CreateClientImage() next tick.
 * This proc exists solely to handle everything in the image creation process before MeasureText() returns, as otherwise when the client
 * returns the results of MeasureText() we are in the verb execution portion of the tick which means we're in danger of overtiming.
 * delaying the final image processing to SSrunechat's next fire() fixes this.
 *
 * Arguments:
 * * text - the text used in the image, gets edited if it holds non allowed characters and/or the listener doesnt understand the speakers language
 * * target - the atom creating the message being heard by others. the image we create will have its loc assigned to this atom
 * * owner - the mob hearing the message from target, must have a client
 * * lanugage - the language typepath this message is spoken in
 * * extra_classes - the spans used for this message
 */
/datum/chatmessage/proc/PrepareMessage(text, atom/target, mob/owner, datum/language/language, list/classes)
	set waitfor = FALSE //because this waits on info passed from the client

	var/client/owned_by = owner.client
	if(!owned_by)
		return FALSE

	LAZYSET(all_hearers, owned_by, TRUE)
	GLOB.destroyed_event.register(owned_by, src, .proc/HearerQdeleted)

	// Remove spans in the message from things like the recorder
	var/static/regex/span_check = new(@"<\/?span[^>]*>", "gi")
	text = replacetext(text, span_check, "")

	// Clip message

	var/max_chars = MESSAGE_LENGTH
	var/max_pixels = MESSAGE_WIDTH
	if (owner.get_preference_value(/datum/client_preference/runechat_long))
		max_chars = MESSAGE_LENGTH_LONG
		max_pixels = MESSAGE_WIDTH_LONG

	if (length_char(text) > max_chars)
		text = copytext_char(text, 1, max_chars + 1) + "..."

	// Calculate target color if not already present
	if (!target.chat_color || target.chat_color_text != target.name)
		SSrunechat.CreateChatColors(target)

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
		classes |= "small"

	var/list/prefixes

	// Append radio icon if from a virtual speaker
	if (classes.Find("virtual-speaker"))
		var/image/r_icon = image('icons/chat_icons.dmi', icon_state = "radio")
		LAZYADD(prefixes, "\icon[r_icon]")
	else if (classes.Find("emote"))
		var/image/r_icon = image('icons/chat_icons.dmi', icon_state = "emote")
		LAZYADD(prefixes, "\icon[r_icon]")

	if (language?.icon_state && (language.name in owner.languages))
		LAZYADD(prefixes, "\icon[SSrunechat.language_icons[language.type]]")

	text = "[prefixes?.Join("&nbsp;")][text]"

	// We dim italicized text to make it more distinguishable from regular text
	var/tgt_color = classes.Find("italic") ? target.chat_color_darkened : target.chat_color
	var/complete_text = "<span class='maptext center [classes.Join(" ")]' style='color: [tgt_color]'>[text]</span>"

	// Retrieve the display height of the message from the client using MeasureText. We must split on x because it returns a WidthxHeight string.
	var/message_height = owned_by.MeasureText(complete_text, null, max_pixels)
	message_height = text2num(copytext(message_height, findtextEx(message_height, "x") + 1))

	// Because of the implicit delay in retrieving a client response we re-check if we should continue, and if we have time or should queue.
	if(!owned_by || QDELETED(src) || QDELETED(message_loc) || !all_hearers?[owned_by])
		return
	if(TICK_CHECK)
		SSrunechat.message_queue += CALLBACK(src, .proc/CreateClientImage, target, owner, complete_text, message_height)
	else
		CreateClientImage(target, owner, complete_text, message_height)


/**
 * actually generates the runechat image for the message spoken by target and heard by owner.
 *
 * Arguments:
 * * target - the atom creating the message being heard by others. the image we create will have its loc assigned to this atom
 * * owner - the mob hearing the message from target, must have a client
 * * complete_text - the complete text used to create the images maptext
 * * mheight - height of the complete text returned by MeasureText() in pixels i think idfk
 */
/datum/chatmessage/proc/CreateClientImage(atom/target, mob/owner, complete_text, mheight)
	var/client/owned_by = owner.client
	if(!owned_by || QDELETED(target) || QDELETED(src))//possible since CreateClientImage() is called via a queue
		return
	var/our_approx_lines = max(1, mheight / CHAT_MESSAGE_APPROX_LHEIGHT)
	if (owned_by.runechat_messages) // Translate any existing messages upwards, apply exponential decay factors to timers
		var/num_runechat_messages = 1
		var/combined_height = our_approx_lines
		for(var/datum/chatmessage/preexisting_message as anything in owned_by.runechat_messages[message_loc])
			if(QDELETED(preexisting_message))
				stack_trace("qdeleted message encountered in a clients runechat_messages list!")
				LAZYREMOVEASSOC(owned_by.runechat_messages, message_loc, preexisting_message)
				continue
			var/image/other_message_image = preexisting_message.hearers[owned_by]
			if(!other_message_image)
				continue //no image yet because the message hasnt been able to create an image.
			combined_height += preexisting_message.approx_lines[other_message_image]
			var/current_stage_2_time_left = preexisting_message.fade_times_by_image[other_message_image] - (world.time + CHAT_MESSAGE_SPAWN_TIME)
			//how much time remains in the "fully visible" stage of animation, after we adjust it. round it down to the nearest tick
			var/real_stage_2_time_left = round((current_stage_2_time_left) * (CHAT_MESSAGE_EXP_DECAY ** num_runechat_messages) * (CHAT_MESSAGE_HEIGHT_DECAY ** combined_height), world.tick_lag)
			num_runechat_messages++
			///used to take away time from CHAT_MESSAGE_SPAWN_TIME's addition to the fading time
			var/non_abs_stage_2_time_left = real_stage_2_time_left
			real_stage_2_time_left = max(real_stage_2_time_left, 0)
			if(other_message_image.layer != MESSAGE_ANIMATION_FORCE_FADE_LAYER_MARK)
				//if the message isnt in stage 3 of the animation, adjust the length of stage 2. assume that stage 1 is over since its short
				//and taking that into account is harder than its worth. also check if theres enough time left after adjusting to bother
				if(preexisting_message.fade_times_by_image[other_message_image] > world.time && real_stage_2_time_left > 1 && other_message_image.layer != MESSAGE_ANIMATION_EDIT_FADE_LAYER_MARK)
					animate(other_message_image, alpha = 255, time = 0)
					animate(time = real_stage_2_time_left)
					animate(alpha = 0, time = CHAT_MESSAGE_EOL_FADE)
					animate(layer = MESSAGE_ANIMATION_EDIT_FADE_LAYER_MARK, time = 0)
					preexisting_message.fade_times_by_image[other_message_image] = world.time + non_abs_stage_2_time_left + CHAT_MESSAGE_SPAWN_TIME
				//just start the fading early if theres no real time left. layer is only MESSAGE_ANIMATION_DEFAULT_LAYER_MARK to the server if this hasnt already happened to the image
				else if(real_stage_2_time_left <= 1)
					//to the server, animations complete their edits instantly, jumping to the last stage of the animation. so we need this step if the client
					//was still in the second stage of animation. if the time was wrong and the client was in the third stage of animation when the updated step
					//arrives, then this will look weird.
					animate(other_message_image, alpha = 0, time = CHAT_MESSAGE_EOL_FADE, flags = ANIMATION_PARALLEL)
					animate(layer = MESSAGE_ANIMATION_FORCE_FADE_LAYER_MARK, time = 0)
					preexisting_message.fade_times_by_image[other_message_image] = world.time //make sure we can tell afterwards if its already fading
			//make it move upwards
			animate(other_message_image, pixel_y = other_message_image.pixel_y + mheight, time = CHAT_MESSAGE_SPAWN_TIME, flags = ANIMATION_PARALLEL)
	var/maptext_x_used = (MESSAGE_WIDTH - owner.bound_width) * -0.5
	var/image/message = CreateBaseImage(target, complete_text, mheight, maptext_x_used)
	//handle the client side animations for the image
	animate(message, alpha = 255, time = CHAT_MESSAGE_SPAWN_TIME)
	animate(alpha = 255, time = lifespan)
	animate(alpha = 0, time = CHAT_MESSAGE_EOL_FADE)
	animate(layer = MESSAGE_ANIMATION_DEFAULT_LAYER_MARK, time = 0) //This step is invisible to the client. It indicates to the server whether the last animation was forced.
	HandleImageAssociation(message, owned_by, our_approx_lines)


/datum/chatmessage/proc/CreateTemplate()
	var/mutable_appearance/template = new
	template.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA | KEEP_APART
	template.plane = EFFECTS_ABOVE_LIGHTING_PLANE
	template.alpha = 0
	template.maptext_width = MESSAGE_WIDTH
	return template


/datum/chatmessage/proc/CreateBaseImage(atom/target, maptext, mheight, maptext_x)
	var/static/mutable_appearance/template = CreateTemplate()
	template.layer = CHAT_LAYER + CHAT_LAYER_Z_STEP * current_z_idx
	template.maptext_height = mheight
	template.pixel_y = target.maptext_height
	template.pixel_x = (target.maptext_width * 0.5) - 16
	template.maptext_x = maptext_x
	template.maptext = maptext
	var/image/message = image(loc = message_loc)
	message.appearance = template.appearance
	return message


/datum/chatmessage/proc/HandleImageAssociation(image/message_image, client/associated_client, approximate_lines, set_time = TRUE)
	if (!message_image || !associated_client)
		return
	associated_client.images |= message_image
	approx_lines[message_image] = approximate_lines
	if (set_time)
		fade_times_by_image[message_image] = world.time + lifespan + CHAT_MESSAGE_SPAWN_TIME
	LAZYADDASSOCLIST(associated_client.runechat_messages, message_loc, src)
	LAZYSET(messages, message_image, associated_client)
	LAZYSET(hearers, associated_client, message_image)


/**
 * Creates a message overlay at a defined location for a given speaker. assumes that this mob has a client
 *
 * Arguments:
 * * speaker - The atom who is saying this message
 * * message_language - The language that the message is said in
 * * raw_message - The text content of the message
 * * spans - Additional classes to be added to the message
 */
/mob/proc/show_runechat(atom/movable/speaker, message, datum/language/language, list/classes, flags = SSrunechat.FLAGS_DEFAULT)
	if (!client)
		return
	if (get_preference_value(/datum/client_preference/runechat) != GLOB.PREF_YES)
		return
	if (!ismob(speaker) && get_preference_value(/datum/client_preference/runechat_atoms) != GLOB.PREF_YES)
		return


	/*
	// Check for virtual speakers (aka hearing a message through a radio)
	var/atom/movable/originalSpeaker = speaker
	if (istype(speaker, /atom/movable/virtualspeaker))
		var/atom/movable/virtualspeaker/v = speaker
		speaker = v.source
		spans |= "virtual-speaker"

	// Ignore virtual speaker (most often radio messages) from ourself
	if (originalSpeaker != src && speaker == src)
		return
	*/

	var/datum/chatmessage/message_to_use
	var/text_to_use

	if(flags & SSrunechat.FLAGS_EMOTE)
		text_to_use = message
		classes = list("emote", "italic")
	else
		//text_to_use = lang_treat(speaker, language, message, classes, null, TRUE)
		text_to_use = message
		classes = classes ? classes.Copy() : list()

	var/message_parameters = "[text_to_use]-\ref[speaker]-[language]-[list2params(classes)]-[world.time]"
	message_to_use = SSrunechat.messages_by_creation_string[message_parameters]
	//if an already existing message already has processed us as a hearer then we have to assume that this is from a new, identical message sent in the same tick
	//as the already existing one. thats the only time this can happen. if this is the case then create a new chatmessage
	if(!message_to_use || (message_to_use && message_to_use.all_hearers?[client]))
		message_to_use = new /datum/chatmessage (message_parameters, text_to_use, speaker, language, classes)
	message_to_use.PrepareMessage(text_to_use, speaker, src, language, classes)
