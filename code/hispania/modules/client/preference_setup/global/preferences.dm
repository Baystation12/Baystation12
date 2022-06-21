GLOBAL_VAR_CONST(PREF_YES, "Si")
GLOBAL_VAR_CONST(PREF_NO, "No")
GLOBAL_VAR_CONST(PREF_ALL_SPEECH, "Todas las palabras")
GLOBAL_VAR_CONST(PREF_NEARBY, "cercanas")
GLOBAL_VAR_CONST(PREF_ALL_EMOTES, "Todos los gestos")
GLOBAL_VAR_CONST(PREF_ALL_CHATTER, "Todos los radios")
GLOBAL_VAR_CONST(PREF_SHORT, "Corto")
GLOBAL_VAR_CONST(PREF_LONG, "Largo")
GLOBAL_VAR_CONST(PREF_SHOW, "Mostrar")
GLOBAL_VAR_CONST(PREF_HIDE, "Ocultar")
GLOBAL_VAR_CONST(PREF_FANCY, "Fantastico")
GLOBAL_VAR_CONST(PREF_PLAIN, "Sencillo")
GLOBAL_VAR_CONST(PREF_PRIMARY, "Primario")
GLOBAL_VAR_CONST(PREF_ALL, "Todo")
GLOBAL_VAR_CONST(PREF_OFF, "Apagado")
GLOBAL_VAR_CONST(PREF_BASIC, "Basico")
GLOBAL_VAR_CONST(PREF_FULL, "Completo")
GLOBAL_VAR_CONST(PREF_MIDDLE_CLICK, "Click medio")
GLOBAL_VAR_CONST(PREF_ALT_CLICK, "alt click")
GLOBAL_VAR_CONST(PREF_CTRL_CLICK, "ctrl click")
GLOBAL_VAR_CONST(PREF_CTRL_SHIFT_CLICK, "ctrl shift click")
GLOBAL_VAR_CONST(PREF_HEAR, "Oir")
GLOBAL_VAR_CONST(PREF_SILENT, "Silencio")
GLOBAL_VAR_CONST(PREF_SHORTHAND, "Taquigrafia")
GLOBAL_VAR_CONST(PREF_NEVER, "Nunca")
GLOBAL_VAR_CONST(PREF_NON_ANTAG, "Solo no Antag")
GLOBAL_VAR_CONST(PREF_ALWAYS, "Siempre")
GLOBAL_VAR_CONST(PREF_SMALL, "Pequeno")
GLOBAL_VAR_CONST(PREF_MEDIUM, "Medio")
GLOBAL_VAR_CONST(PREF_LARGE, "Grande")
GLOBAL_VAR_CONST(PREF_LOW, "Bajo")
GLOBAL_VAR_CONST(PREF_MED, "Medio")
GLOBAL_VAR_CONST(PREF_HIGH, "Alto")

var/global/list/_client_preferences
var/global/list/_client_preferences_by_key
var/global/list/_client_preferences_by_type

/proc/get_client_preferences()
	if(!_client_preferences)
		_client_preferences = list()
		for(var/ct in subtypesof(/datum/client_preference))
			var/datum/client_preference/client_type = ct
			if(initial(client_type.description))
				_client_preferences += new client_type()
	return _client_preferences

/proc/get_client_preference(var/datum/client_preference/preference)
	if(istype(preference))
		return preference
	if(ispath(preference))
		return get_client_preference_by_type(preference)
	return get_client_preference_by_key(preference)

/proc/get_client_preference_by_key(var/preference)
	if(!_client_preferences_by_key)
		_client_preferences_by_key = list()
		for(var/ct in get_client_preferences())
			var/datum/client_preference/client_pref = ct
			_client_preferences_by_key[client_pref.key] = client_pref
	return _client_preferences_by_key[preference]

/proc/get_client_preference_by_type(var/preference)
	if(!_client_preferences_by_type)
		_client_preferences_by_type = list()
		for(var/ct in get_client_preferences())
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

	if(!default_value)
		default_value = options[1]

/datum/client_preference/proc/may_set(client/given_client)
	return TRUE

/datum/client_preference/proc/changed(var/mob/preference_mob, var/new_value)
	return

/*********************
* Player Preferences *
*********************/

/datum/client_preference/play_admin_midis
	description = "-Escuchar midis de admins"
	key = "SOUND_MIDI"

/datum/client_preference/play_lobby_music
	description = "-Escuchar musica del lobby"
	key = "SOUND_LOBBY"

/datum/client_preference/play_lobby_music/changed(var/mob/preference_mob, var/new_value)
	if(new_value == GLOB.PREF_YES)
		if(isnewplayer(preference_mob))
			sound_to(preference_mob, GLOB.using_map.lobby_track.get_sound())
			to_chat(preference_mob, GLOB.using_map.lobby_track.get_info())
	else
		sound_to(preference_mob, sound(null, repeat = 0, wait = 0, volume = 85, channel = GLOB.lobby_sound_channel))

/datum/client_preference/play_ambiance
	description = "-Escuchar sonidos ambientales"
	key = "SOUND_AMBIENCE"

/datum/client_preference/play_ambiance/changed(var/mob/preference_mob, var/new_value)
	if(new_value == GLOB.PREF_NO)
		sound_to(preference_mob, sound(null, repeat = 0, wait = 0, volume = 0, channel = GLOB.lobby_sound_channel))
		sound_to(preference_mob, sound(null, repeat = 0, wait = 0, volume = 0, channel = GLOB.ambience_sound_channel))

/datum/client_preference/play_announcement_sfx
	description = "-Play announcement sound effects"
	key = "SOUND_ANNOUNCEMENT"
	options = list(GLOB.PREF_YES, GLOB.PREF_NO)
/datum/client_preference/ghost_ears
	description = "-Leer como fantasma"
	key = "CHAT_GHOSTEARS"
	options = list(GLOB.PREF_ALL_SPEECH, GLOB.PREF_NEARBY)

/datum/client_preference/ghost_sight
	description = "-Ver como fantasma"
	key = "CHAT_GHOSTSIGHT"
	options = list(GLOB.PREF_ALL_EMOTES, GLOB.PREF_NEARBY)

/datum/client_preference/ghost_radio
	description = "-Leer radio como fantasma"
	key = "CHAT_GHOSTRADIO"
	options = list(GLOB.PREF_ALL_CHATTER, GLOB.PREF_NEARBY)

/datum/client_preference/preview_scale
	description = "-Escala de vista previa"
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
	description = "-Mostrar nombres de idiomas"
	key = "LANGUAGE_DISPLAY"
	options = list(GLOB.PREF_SHORTHAND, GLOB.PREF_FULL, GLOB.PREF_OFF)

/datum/client_preference/ghost_language_hide
	description = "-Ocultar nombres de idiomas como fantasma"
	key = "LANGUAGE_DISPLAY_GHOST"

/datum/client_preference/ghost_follow_link_length
	description = "-Seguimiento fantasma"
	key = "CHAT_GHOSTFOLLOWLINKLENGTH"
	options = list(GLOB.PREF_SHORT, GLOB.PREF_LONG, GLOB.PREF_OFF)

/datum/client_preference/chat_tags
	description = "-Etiquetas de chat"
	key = "CHAT_SHOWICONS"
	options = list(GLOB.PREF_SHOW, GLOB.PREF_HIDE)

/datum/client_preference/show_typing_indicator
	description = "-Indicador de escritura"
	key = "SHOW_TYPING"
	options = list(GLOB.PREF_SHOW, GLOB.PREF_HIDE)

/datum/client_preference/show_typing_indicator/changed(var/mob/preference_mob, var/new_value)
	if(new_value == GLOB.PREF_HIDE)
		preference_mob.remove_typing_indicator()

/datum/client_preference/show_ooc
	description = "-OOC chat"
	key = "CHAT_OOC"
	options = list(GLOB.PREF_SHOW, GLOB.PREF_HIDE)

/datum/client_preference/show_aooc
	description = "-AOOC chat"
	key = "CHAT_AOOC"
	options = list(GLOB.PREF_SHOW, GLOB.PREF_HIDE)

/datum/client_preference/show_looc
	description ="-LOOC chat"
	key = "CHAT_LOOC"
	options = list(GLOB.PREF_SHOW, GLOB.PREF_HIDE)

/datum/client_preference/show_dsay
	description ="-Dead chat"
	key = "CHAT_DEAD"
	options = list(GLOB.PREF_SHOW, GLOB.PREF_HIDE)

/datum/client_preference/show_progress_bar
	description ="-Barra de progreso"
	key = "SHOW_PROGRESS"
	options = list(GLOB.PREF_SHOW, GLOB.PREF_HIDE)

/datum/client_preference/browser_style
	description = "-Estilo de navegador NanoUI"
	key = "BROWSER_STYLED"
	options = list(GLOB.PREF_FANCY, GLOB.PREF_PLAIN)

/datum/client_preference/autohiss
	description = "-Autosilbido"
	key = "AUTOHISS"
	options = list(GLOB.PREF_OFF, GLOB.PREF_BASIC, GLOB.PREF_FULL)

/datum/client_preference/hardsuit_activation
	description = "-Clave de activacion del modulo Hardsuit"
	key = "HARDSUIT_ACTIVATION"
	options = list(GLOB.PREF_MIDDLE_CLICK, GLOB.PREF_CTRL_CLICK, GLOB.PREF_ALT_CLICK, GLOB.PREF_CTRL_SHIFT_CLICK)

/datum/client_preference/holster_on_intent
	description = "-Dibujar el arma segun la intencion"
	key = "HOLSTER_ON_INTENT"

/datum/client_preference/show_credits
	description = "-Mostrar titulos finales"
	key = "SHOW_CREDITS"

/datum/client_preference/show_ckey_credits
	description = "-Mostrar Ckey en creditos finales/lista de roles especiales"
	key = "SHOW_CKEY_CREDITS"
	options = list(GLOB.PREF_HIDE, GLOB.PREF_SHOW)

/datum/client_preference/show_ckey_deadchat
	description = "-Mostrar Ckey en Dead chat"
	key = "SHOW_CKEY_DEADCHAT"
	options = list(GLOB.PREF_SHOW, GLOB.PREF_HIDE)

/datum/client_preference/show_ready
	description = "-Mostrar estado Listo en el lobby"
	key = "SHOW_READY"
	options = list(GLOB.PREF_SHOW, GLOB.PREF_HIDE)

/datum/client_preference/announce_ghost_join
	description = "-Anunciar al unirse como observador"
	key = "ANNOUNCE_GHOST"
	options = list(GLOB.PREF_YES, GLOB.PREF_NO)

/datum/client_preference/play_instruments
	description = "-Escuchar instrumentos"
	key = "SOUND_INSTRUMENTS"

/datum/client_preference/give_personal_goals
	description = "-Dar metas personales"
	key = "PERSONAL_GOALS"
	options = list(GLOB.PREF_NEVER, GLOB.PREF_NON_ANTAG, GLOB.PREF_ALWAYS)

/datum/client_preference/show_department_goals
	description = "-Mostrar metas departamentales"
	key = "DEPT_GOALS"
	options = list(GLOB.PREF_SHOW, GLOB.PREF_HIDE)

/datum/client_preference/examine_messages
	description = "-Examinando mensajes"
	key = "EXAMINE_MESSAGES"
	options = list(GLOB.PREF_SHOW, GLOB.PREF_HIDE)

/datum/client_preference/graphics_quality
	description = "-Calidad de graficos (donde sea relevante, reducira los efectos)"
	key = "GRAPHICS_QUALITY"
	options = list(GLOB.PREF_LOW, GLOB.PREF_MED, GLOB.PREF_HIGH)
	default_value = GLOB.PREF_HIGH

/datum/client_preference/graphics_quality/changed(mob/preference_mob, new_value)
	if(preference_mob?.client)
		for(var/atom/movable/renderer/R as anything in preference_mob.renderers)
			R.GraphicsUpdate()

/datum/client_preference/goonchat
	description = "-Usa el chat Goon"
	key = "USE_GOONCHAT"

/datum/client_preference/goonchat/changed(var/mob/preference_mob, var/new_value)
	if(preference_mob && preference_mob.client)
		var/client/C = preference_mob.client
		if(new_value == GLOB.PREF_YES)
			C.chatOutput.loaded = FALSE
			C.chatOutput.start()
		else
			C.force_white_theme()
			winset(C, "output", "is-visible=true;is-disabled=false")
			winset(C, "browseroutput", "is-visible=false")

/********************
* General Staff Preferences *
********************/

/datum/client_preference/staff
	var/flags

/datum/client_preference/staff/may_set(client/given_client)
	if(ismob(given_client))
		var/mob/M = given_client
		given_client = M.client
	if(!given_client)
		return FALSE
	if(flags)
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
