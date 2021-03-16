/datum/ailment/fault/noisemaker
	name = "noisemaker"
	diagnosis_string = "$USER_HIS$ $ORGAN$ is emitting a creak."

/datum/ailment/fault/noisemaker/on_ailment_event()
	organ.owner.audible_message(SPAN_DANGER("[organ.owner]'s [organ.name] creaks."), hearing_distance = 7)
	playsound(organ.owner, 'sound/machines/airlock_creaking.ogg', 100, 1, 4, ignore_walls = FALSE, zrange = 1)
