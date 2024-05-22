SUBSYSTEM_DEF(typing)
	name = "Typing"
	flags = SS_BACKGROUND | SS_NO_INIT
	wait = 0.5 SECONDS

	/// The skin control to poll for TYPING_STATE_INPUT status.
	var/const/INPUT_HANDLE = "mainwindow.input"

	var/const/INFLIGHT_TIMEOUT = 5 SECONDS

	/// The status entry index of the related client's typing indicator visibility preference.
	var/const/INDEX_PREFERENCE = 1

	/// The status entry index of the inflight state.
	var/const/INDEX_INFLIGHT = 2

	/// The status entry index of the timeout threshold.
	var/const/INDEX_TIMEOUT = 3

	/// The status entry index of the input bar typing state.
	var/const/INDEX_INPUT_STATE = 4

	/// The status entry index of the verb input typing state.
	var/const/INDEX_VERB_STATE = 5

	/// The highest index in a status entry.
	var/const/MAX_INDEX = 5

	/*
	* A list of (ckey = list(
			preference = 0|1,
			inflight = 0|1,
			timeout = num,
			istyping_input = 0|1,
			istyping_hotkey = 0|1
		), ...)
		See PROC_REF(GetEntry for details.
	*/
	var/static/list/status = list()

	/// Matches input bar verbs that should set TYPING_STATE_INPUT.
	var/static/regex/match_verbs = regex("^(Me|Say) +\"?\\w+")

	/// A list of clients waiting to be polled for input state.
	var/static/list/client/queue = list()


/datum/controller/subsystem/typing/Recover()
	status = list()
	queue = list()


/datum/controller/subsystem/typing/UpdateStat(time)
	if (PreventUpdateStat(time))
		return ..()
	var/enabled = 0
	var/typing = 0
	var/list/entry
	for (var/ckey in status)
		entry = status[ckey]
		if (entry[INDEX_PREFERENCE])
			++enabled
		if (entry[INDEX_INPUT_STATE] || entry[INDEX_VERB_STATE])
			++typing
	..("[enabled] enabled, [typing] typing")


/datum/controller/subsystem/typing/fire(resumed, no_mc_tick)
	if (!resumed)
		queue = list()
		for (var/client/client as anything in GLOB.clients)
			queue += client
		if (!length(queue))
			return
	var/cut_until = 1
	var/list/entry
	for (var/client/client as anything in queue)
		++cut_until
		if (QDELETED(client))
			continue
		entry = GetEntry(client)
		if (!entry[INDEX_PREFERENCE])
			continue
		if (!entry[INDEX_INFLIGHT])
			UpdateInputState(client, entry)
		else if (world.time < entry[INDEX_TIMEOUT])
			entry[INDEX_INFLIGHT] = FALSE
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			queue.Cut(1, cut_until)
			return
	queue.Cut()


/// Return, generating if necessary, a ckey-indexed list holding typing status.
/datum/controller/subsystem/typing/proc/GetEntry(client/client)
	PRIVATE_PROC(TRUE)
	var/ckey
	if (istext(client))
		ckey = client
	else if (istype(client))
		ckey = client.ckey
	else
		return
	var/list/entry = status[ckey]
	if (!entry)
		entry = new (MAX_INDEX)
		entry[INDEX_PREFERENCE] = client.get_preference_value(/datum/client_preference/show_typing_indicator) == GLOB.PREF_SHOW
		entry[INDEX_INFLIGHT] = FALSE
		entry[INDEX_TIMEOUT] = world.time
		entry[INDEX_INPUT_STATE] = FALSE
		entry[INDEX_VERB_STATE] = FALSE
		status[ckey] = entry
	return entry


/// Updates client's preference bool for whether typing indicators should be shown.
/datum/controller/subsystem/typing/proc/UpdatePreference(client/client, preference)
	var/list/entry = GetEntry(client)
	entry[INDEX_PREFERENCE] = preference
	UpdateIndicator(client, entry)


/// Updates client|ckey's verb typing state to new_state.
/datum/controller/subsystem/typing/proc/UpdateVerbState(client/client, state)
	if (!isliving(client?.mob))
		return
	var/list/entry = GetEntry(client)
	entry[INDEX_VERB_STATE] = state
	UpdateIndicator(client, entry)


/// Request client's input bar state using winget and updating entry accordingly.
/datum/controller/subsystem/typing/proc/UpdateInputState(client/client, list/entry)
	PRIVATE_PROC(TRUE)
	set waitfor = FALSE
	var/timeout = world.time + INFLIGHT_TIMEOUT
	entry[INDEX_INFLIGHT] = TRUE
	entry[INDEX_TIMEOUT] = timeout
	var/content = winget(client, INPUT_HANDLE, "text")
	if (timeout != entry[INDEX_TIMEOUT]) // We're stale. Touch nothing.
		return
	entry[INDEX_INFLIGHT] = FALSE
	if (QDELETED(client) || !isliving(client.mob))
		return
	entry[INDEX_INPUT_STATE] = match_verbs.Find(content) != 0
	UpdateIndicator(client, entry)


/// Attempt to update the mob's typing state and indicator according to new state.
/datum/controller/subsystem/typing/proc/UpdateIndicator(client/client, list/entry)
	PRIVATE_PROC(TRUE)
	var/mob/living/target = client.mob
	var/display = target.stat == CONSCIOUS && entry[INDEX_PREFERENCE] && (entry[INDEX_INPUT_STATE] || entry[INDEX_VERB_STATE])
	if (display == target.is_typing)
		return
	if (display)
		if (!target.typing_indicator)
			target.typing_indicator = new (null, target)
		target.typing_indicator.pixel_y = target.icon_height - 32
		target.vis_contents += target.typing_indicator
		target.is_typing = TRUE
	else
		if (target.typing_indicator)
			target.vis_contents -= target.typing_indicator
		target.is_typing = FALSE


/atom/movable/typing_indicator
	icon = 'icons/mob/talk.dmi'
	icon_state = "typing"
	plane = EFFECTS_ABOVE_LIGHTING_PLANE
	layer = SPEECH_INDICATOR_LAYER
	mouse_opacity = XMOUSE_OPACITY_NEVER
	simulated = FALSE
	anchored = TRUE

	var/mob/living/owner


/atom/movable/typing_indicator/Destroy()
	if (owner)
		owner.vis_contents -= src
		owner.typing_indicator = null
	owner = null
	return ..()


/atom/movable/typing_indicator/Initialize(mapload, mob/living/_owner, _state = "typing")
	. = ..()
	if (!istype(_owner))
		return INITIALIZE_HINT_QDEL
	icon_state = _state
	owner = _owner


/// If this mob is or was piloted by a player with typing indicators enabled, an instance of one.
/mob/living/var/atom/movable/typing_indicator/typing_indicator


/// Whether this mob is currently typing, if piloted by a player.
/mob/living/var/is_typing


/mob/living/Destroy()
	QDEL_NULL(typing_indicator)
	return ..()


/mob/living/Logout()
	if (typing_indicator)
		vis_contents -= typing_indicator
	is_typing = FALSE
	..()


/mob/verb/say_wrapper()
	set name = ".Say"
	set hidden = TRUE
	SStyping.UpdateVerbState(client, TRUE)
	var/message = input("","say (text)") as null | text
	SStyping.UpdateVerbState(client, FALSE)
	if (message)
		say_verb(message)


/mob/verb/me_wrapper()
	set name = ".Me"
	set hidden = TRUE
	SStyping.UpdateVerbState(client, TRUE)
	var/message = input("","me (text)") as null | text
	SStyping.UpdateVerbState(client, FALSE)
	if (message)
		me_verb(message)
