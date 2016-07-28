var/list/station_languages = list(LANGUAGE_SOL_COMMON,
                                  LANGUAGE_GAL_COMMON,
                                  LANGUAGE_TRADEBAND,
                                  LANGUAGE_GUTTER,
                                  LANGUAGE_UNATHI,
                                  LANGUAGE_SIIK_MAAS,
                                  LANGUAGE_SKRELLIAN,
                                  LANGUAGE_RESOMI)

/obj/item/device/taperecorder
	name = "universal recorder"
	desc = "A device that can record up to an hour of dialogue and play it back. It automatically translates the content in playback."
	icon_state = "taperecorderidle"
	item_state = "analyzer"
	w_class = 2
	matter = list(DEFAULT_WALL_MATERIAL = 60,"glass" = 30)
	flags = CONDUCT
	throwforce = 2
	throw_speed = 4
	throw_range = 20

	virtual = /mob/observer/virtual
	universal_speak = TRUE
	universal_understand = TRUE
	var/current_language = LANGUAGE_GAL_COMMON
	var/list/inputs = list()
	var/sufix
	var/datum/language/language

/obj/item/device/taperecorder/hear(var/datum/communication/c, var/datum/communication_metadata/cm)
	if(cm.source.host != src)
		inputs[c] = station_time_in_ticks

/obj/item/device/taperecorder/attack_self()
	for(var/entry in inputs)
		var/datum/communication/c = entry
		language = all_languages[(c.language.name in station_languages) ? current_language : c.language.name]
		var/input = "\[[time2text(inputs[c], "hh:mm:ss")]\] <b>\The [voice_id_repository.resolve_voice_id(c.voice_id, src)]</b> [language.format_message(c.sound, language.speech_verb)]"
		communicate(input)
		reset()

/obj/item/device/taperecorder/proc/reset()
	sufix = null
	language = null

/obj/item/device/taperecorder/parse_language(var/datum/communication_metadata/full/cm)
	if(language)
		cm.language = language
	else
		..()
