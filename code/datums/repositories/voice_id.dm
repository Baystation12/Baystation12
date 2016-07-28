var/datum/repository/voice_id/voice_id_repository = new()

/datum/repository/voice_id
	var/list/source_to_id
	var/list/id_to_name

/datum/repository/voice_id/New()
	source_to_id = list()
	id_to_name = list()
	..()

/datum/repository/voice_id/proc/acquire_voice_id(var/atom/source)
	if(istype(source))
		. = source_to_id[source]
	else
		CRASH("Unhandled source type: [source]")

	if(!.)
		. = sequential_id(/datum/repository/voice_id)
		source_to_id[source] = .
		id_to_name[num2text(.)] = source.get_voice_name()
		destroyed_event.register(source, src, /datum/repository/voice_id/proc/remove_entry)

/datum/repository/voice_id/proc/resolve_voice_id(var/voice_id, var/atom/listener)
	. = id_to_name[num2text(voice_id)]

/datum/repository/voice_id/proc/remove_entry(var/atom/source)
	source_to_id -= source

/atom/proc/get_voice_name()
	return name

/mob/get_voice_name()
	return real_name
