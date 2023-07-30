GLOBAL_VAR_CONST(PREF_YES, "Yes")
GLOBAL_VAR_CONST(PREF_NO, "No")
GLOBAL_VAR_CONST(PREF_ALL_SPEECH, "All Speech")
GLOBAL_VAR_CONST(PREF_NEARBY, "Nearby")
GLOBAL_VAR_CONST(PREF_ALL_EMOTES, "All Emotes")
GLOBAL_VAR_CONST(PREF_ALL_CHATTER, "All Chatter")
GLOBAL_VAR_CONST(PREF_SHORT, "Short")
GLOBAL_VAR_CONST(PREF_LONG, "Long")
GLOBAL_VAR_CONST(PREF_SHOW, "Show")
GLOBAL_VAR_CONST(PREF_HIDE, "Hide")
GLOBAL_VAR_CONST(PREF_PRIMARY, "Primary")
GLOBAL_VAR_CONST(PREF_ALL, "All")
GLOBAL_VAR_CONST(PREF_OFF, "Off")
GLOBAL_VAR_CONST(PREF_BASIC, "Basic")
GLOBAL_VAR_CONST(PREF_FULL, "Full")
GLOBAL_VAR_CONST(PREF_MIDDLE_CLICK, "middle click")
GLOBAL_VAR_CONST(PREF_ALT_CLICK, "alt click")
GLOBAL_VAR_CONST(PREF_CTRL_CLICK, "ctrl click")
GLOBAL_VAR_CONST(PREF_CTRL_SHIFT_CLICK, "ctrl shift click")
GLOBAL_VAR_CONST(PREF_HEAR, "Hear")
GLOBAL_VAR_CONST(PREF_SILENT, "Silent")
GLOBAL_VAR_CONST(PREF_SHORTHAND, "Shorthand")
GLOBAL_VAR_CONST(PREF_NEVER, "Never")
GLOBAL_VAR_CONST(PREF_NON_ANTAG, "Non-Antag Only")
GLOBAL_VAR_CONST(PREF_ALWAYS, "Always")
GLOBAL_VAR_CONST(PREF_SMALL, "Small")
GLOBAL_VAR_CONST(PREF_MEDIUM, "Medium")
GLOBAL_VAR_CONST(PREF_LARGE, "Large")
GLOBAL_VAR_CONST(PREF_LOW, "Low")
GLOBAL_VAR_CONST(PREF_MED, "Medium")
GLOBAL_VAR_CONST(PREF_HIGH, "High")

var/global/list/_client_preferences
var/global/list/_client_preferences_by_key
var/global/list/_client_preferences_by_type

/proc/get_client_preferences()
	RETURN_TYPE(/list)
	if (!_client_preferences)
		_client_preferences = list()
		for (var/ct in subtypesof(/datum/client_preference))
			var/datum/client_preference/client_type = ct
			if (initial(client_type.description))
				_client_preferences += new client_type()
	return _client_preferences

/proc/get_client_preference(datum/client_preference/preference)
	RETURN_TYPE(/datum/client_preference)
	if (istype(preference))
		return preference
	if (ispath(preference))
		return get_client_preference_by_type(preference)
	return get_client_preference_by_key(preference)

/proc/get_client_preference_by_key(preference)
	RETURN_TYPE(/datum/client_preference)
	if (!_client_preferences_by_key)
		_client_preferences_by_key = list()
		for (var/ct in get_client_preferences())
			var/datum/client_preference/client_pref = ct
			_client_preferences_by_key[client_pref.key] = client_pref
	return _client_preferences_by_key[preference]

/proc/get_client_preference_by_type(preference)
	RETURN_TYPE(/datum/client_preference)
	if (!_client_preferences_by_type)
		_client_preferences_by_type = list()
		for (var/ct in get_client_preferences())
			var/datum/client_preference/client_pref = ct
			_client_preferences_by_type[client_pref.type] = client_pref
	return _client_preferences_by_type[preference]

/datum/client_preference
	var/description
	var/key
	var/list/options = list(GLOB.PREF_YES, GLOB.PREF_NO)
	var/default_value

/datum/client_preference/New()
	. = ..()

	if (!default_value)
		default_value = options[1]

/datum/client_preference/proc/may_set(client/given_client)
	return TRUE

/datum/client_preference/proc/changed(mob/preference_mob, new_value)
	return

/*********************
* Player Preferences *
*********************/

/datum/client_preference/play_admin_midis
	description = "Play admin midis"
	key = "SOUND_MIDI"

/datum/client_preference/play_lobby_music
	description = "Play lobby music"
	key = "SOUND_LOBBY"

/datum/client_preference/play_lobby_music/changed(mob/preference_mob, new_value)
	if (new_value == GLOB.PREF_YES)
		if (isnewplayer(preference_mob))
			sound_to(preference_mob, GLOB.using_map.lobby_track.get_sound())
			to_chat(preference_mob, GLOB.using_map.lobby_track.get_info())
	else
		sound_to(preference_mob, sound(null, repeat = 0, wait = 0, volume = 85, channel = GLOB.lobby_sound_channel))

/datum/client_preference/play_ambiance
	description = "Play ambience"
	key = "SOUND_AMBIENCE"

/datum/client_preference/play_ambiance/changed(mob/preference_mob, new_value)
	if (new_value == GLOB.PREF_NO)
		sound_to(preference_mob, sound(null, channel = GLOB.ambience_channel_vents))
		sound_to(preference_mob, sound(null, channel = GLOB.ambience_channel_forced))
		sound_to(preference_mob, sound(null, channel = GLOB.ambience_channel_common))

/datum/client_preference/play_announcement_sfx
	description = "Play announcement sound effects"
	key = "SOUND_ANNOUNCEMENT"
	options = list(GLOB.PREF_YES, GLOB.PREF_NO)
/datum/client_preference/ghost_ears
	description = "Ghost ears"
	key = "CHAT_GHOSTEARS"
	options = list(GLOB.PREF_ALL_SPEECH, GLOB.PREF_NEARBY)

/datum/client_preference/ghost_sight
	description = "Ghost sight"
	key = "CHAT_GHOSTSIGHT"
	options = list(GLOB.PREF_ALL_EMOTES, GLOB.PREF_NEARBY)

/datum/client_preference/ghost_radio
	description = "Ghost radio"
	key = "CHAT_GHOSTRADIO"
	options = list(GLOB.PREF_ALL_CHATTER, GLOB.PREF_NEARBY)

/datum/client_preference/preview_scale
	description = "Options Preview Scale"
	key = "PREVIEW_SCALE"
	options = list(GLOB.PREF_MEDIUM, GLOB.PREF_LARGE, GLOB.PREF_SMALL)

/datum/client_preference/preview_scale/changed(mob/mob, val)
	var/datum/preferences/prefs = mob.client?.prefs
	if (!prefs)
		return
	prefs.update_preview_icon(TRUE)
	if (!prefs.popup)
		return
	prefs.update_setup_window(usr)

/datum/client_preference/language_display
	description = "Show Language Names"
	key = "LANGUAGE_DISPLAY"
	options = list(GLOB.PREF_SHORTHAND, GLOB.PREF_FULL, GLOB.PREF_OFF)

/datum/client_preference/ghost_language_hide
	description = "Hide Language Names As Ghost"
	key = "LANGUAGE_DISPLAY_GHOST"

/datum/client_preference/ghost_follow_link_length
	description = "Ghost Follow Links"
	key = "CHAT_GHOSTFOLLOWLINKLENGTH"
	options = list(GLOB.PREF_SHORT, GLOB.PREF_LONG, GLOB.PREF_OFF)

/datum/client_preference/chat_tags
	description = "Chat tags"
	key = "CHAT_SHOWICONS"
	options = list(GLOB.PREF_SHOW, GLOB.PREF_HIDE)

/datum/client_preference/show_typing_indicator
	description = "Typing indicator"
	key = "SHOW_TYPING"
	options = list(GLOB.PREF_SHOW, GLOB.PREF_HIDE)

/datum/client_preference/show_typing_indicator/changed(mob/preference_mob, new_value)
	SStyping.UpdatePreference(preference_mob.client, new_value == GLOB.PREF_SHOW)

/datum/client_preference/show_ooc
	description = "OOC chat"
	key = "CHAT_OOC"
	options = list(GLOB.PREF_SHOW, GLOB.PREF_HIDE)

/datum/client_preference/show_aooc
	description = "AOOC chat"
	key = "CHAT_AOOC"
	options = list(GLOB.PREF_SHOW, GLOB.PREF_HIDE)

/datum/client_preference/show_looc
	description ="LOOC chat"
	key = "CHAT_LOOC"
	options = list(GLOB.PREF_SHOW, GLOB.PREF_HIDE)

/datum/client_preference/show_dsay
	description ="Dead chat"
	key = "CHAT_DEAD"
	options = list(GLOB.PREF_SHOW, GLOB.PREF_HIDE)

/datum/client_preference/show_progress_bar
	description ="Progress Bar"
	key = "SHOW_PROGRESS"
	options = list(GLOB.PREF_SHOW, GLOB.PREF_HIDE)

/datum/client_preference/autohiss
	description = "Autohiss"
	key = "AUTOHISS"
	options = list(GLOB.PREF_OFF, GLOB.PREF_BASIC, GLOB.PREF_FULL)

/datum/client_preference/hardsuit_activation
	description = "Hardsuit Module Activation Key"
	key = "HARDSUIT_ACTIVATION"
	options = list(GLOB.PREF_MIDDLE_CLICK, GLOB.PREF_CTRL_CLICK, GLOB.PREF_ALT_CLICK, GLOB.PREF_CTRL_SHIFT_CLICK)

/datum/client_preference/holster_on_intent
	description = "Draw gun based on intent"
	key = "HOLSTER_ON_INTENT"

/datum/client_preference/show_credits
	description = "Show End Titles"
	key = "SHOW_CREDITS"

/datum/client_preference/show_ckey_credits
	description = "Show Ckey in End Credits/Special Role List"
	key = "SHOW_CKEY_CREDITS"
	options = list(GLOB.PREF_HIDE, GLOB.PREF_SHOW)

/datum/client_preference/show_ckey_deadchat
	description = "Show Ckey in Deadchat"
	key = "SHOW_CKEY_DEADCHAT"
	options = list(GLOB.PREF_SHOW, GLOB.PREF_HIDE)

/datum/client_preference/show_ready
	description = "Show Ready Status in Lobby"
	key = "SHOW_READY"
	options = list(GLOB.PREF_SHOW, GLOB.PREF_HIDE)

/datum/client_preference/announce_ghost_join
	description = "Announce When Joining as Observer"
	key = "ANNOUNCE_GHOST"
	options = list(GLOB.PREF_YES, GLOB.PREF_NO)

/datum/client_preference/play_instruments
	description = "Play instruments"
	key = "SOUND_INSTRUMENTS"

/datum/client_preference/give_personal_goals
	description = "Give Personal Goals"
	key = "PERSONAL_GOALS"
	options = list(GLOB.PREF_NEVER, GLOB.PREF_NON_ANTAG, GLOB.PREF_ALWAYS)

/datum/client_preference/show_department_goals
	description = "Show Departmental Goals"
	key = "DEPT_GOALS"
	options = list(GLOB.PREF_SHOW, GLOB.PREF_HIDE)

/datum/client_preference/examine_messages
	description = "Examining messages"
	key = "EXAMINE_MESSAGES"
	options = list(GLOB.PREF_SHOW, GLOB.PREF_HIDE)

/datum/client_preference/graphics_quality
	description = "Graphics quality (where relevant it will reduce effects)"
	key = "GRAPHICS_QUALITY"
	options = list(GLOB.PREF_LOW, GLOB.PREF_MED, GLOB.PREF_HIGH)
	default_value = GLOB.PREF_HIGH

/datum/client_preference/graphics_quality/changed(mob/preference_mob, new_value)
	if (preference_mob?.client)
		for (var/atom/movable/renderer/R as anything in preference_mob.renderers)
			R.GraphicsUpdate()

/datum/client_preference/goonchat
	description = "Use Goon Chat"
	key = "USE_GOONCHAT"

/datum/client_preference/goonchat/changed(mob/preference_mob, new_value)
	if (preference_mob && preference_mob.client)
		var/client/C = preference_mob.client
		if (new_value == GLOB.PREF_YES)
			C.chatOutput.loaded = FALSE
			C.chatOutput.start()
		else
			C.force_white_theme()
			winset(C, "output", "is-visible=true;is-disabled=false")
			winset(C, "browseroutput", "is-visible=false")

/datum/client_preference/notify_ghost_trap
	description = "Notify when ghost-trap roles are available."
	key = "GHOST_TRAP"
	options = list(GLOB.PREF_YES, GLOB.PREF_NO)
	default_value = GLOB.PREF_YES


/datum/client_preference/surgery_skip_radial
	description = "Skip the radial menu for single-option surgeries."
	key = "SURGERY_SKIP_RADIAL"
	options = list(GLOB.PREF_YES, GLOB.PREF_NO)
	default_value = GLOB.PREF_NO


/********************
* General Staff Preferences *
********************/

/datum/client_preference/staff
	var/flags

/datum/client_preference/staff/may_set(client/given_client)
	if (ismob(given_client))
		var/mob/M = given_client
		given_client = M.client
	if (!given_client)
		return FALSE
	if (flags)
		return check_rights(flags, 0, given_client)
	else
		return given_client && given_client.holder

/datum/client_preference/staff/show_chat_prayers
	description = "Chat Prayers"
	key = "CHAT_PRAYER"
	options = list(GLOB.PREF_SHOW, GLOB.PREF_HIDE)

/datum/client_preference/staff/play_adminhelp_ping
	description = "Adminhelps"
	key = "SOUND_ADMINHELP"
	options = list(GLOB.PREF_HEAR, GLOB.PREF_SILENT)

/datum/client_preference/staff/show_rlooc
	description = "Remote LOOC chat"
	key = "CHAT_RLOOC"
	options = list(GLOB.PREF_SHOW, GLOB.PREF_HIDE)

/********************
* Admin Preferences *
********************/

/datum/client_preference/staff/show_attack_logs
	description = "Attack Log Messages"
	key = "CHAT_ATTACKLOGS"
	options = list(GLOB.PREF_SHOW, GLOB.PREF_HIDE)
	flags = R_ADMIN
	default_value = GLOB.PREF_HIDE

/********************
* Debug Preferences *
********************/

/datum/client_preference/staff/show_debug_logs
	description = "Debug Log Messages"
	key = "CHAT_DEBUGLOGS"
	options = list(GLOB.PREF_SHOW, GLOB.PREF_HIDE)
	default_value = GLOB.PREF_HIDE
	flags = R_ADMIN|R_DEBUG


/datum/client_preference/staff/show_runtime_logs
	description = "Runtime Log Messages"
	key = "CHAT_RUNTIMELOGS"
	options = list(GLOB.PREF_SHOW, GLOB.PREF_HIDE)
	default_value = GLOB.PREF_HIDE
	flags = R_ADMIN | R_DEBUG
