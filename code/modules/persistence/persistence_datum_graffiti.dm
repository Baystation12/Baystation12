/datum/persistent/graffiti
	name = "graffiti"
	tokens_per_line = 6
	entries_expire_at = 50
	var/entries_decay_at
	var/const/graffiti_decay_weight = 0.5

/datum/persistent/graffiti/set_filename()
	filename = "data/persistent/[lowertext(GLOB.using_map.name)]-graffiti.txt"
	entries_decay_at = Floor(entries_expire_at * 0.5)

/datum/persistent/graffiti/label_tokens(var/list/tokens)
	var/list/labelled_tokens = ..()
	var/entries = LAZYLEN(labelled_tokens)
	labelled_tokens["author"] =  tokens[entries+1]
	labelled_tokens["message"] = tokens[entries+2]
	return labelled_tokens

/datum/persistent/graffiti/get_valid_turf(var/turf/T, var/list/tokens)
	var/turf/checking_turf = ..()
	if(istype(checking_turf) && checking_turf.can_engrave())
		return checking_turf

/datum/persistent/graffiti/check_turf_contents(var/turf/T, var/list/tokens)
	var/too_much_graffiti = 0
	for(var/obj/effect/decal/writing/W in .)
		too_much_graffiti++
		if(too_much_graffiti >= 5)
			return FALSE
	return TRUE

/datum/persistent/graffiti/process_and_apply_tokens(var/list/tokens)

	var/_n =       tokens["age"]
	var/_message = tokens["message"]

	// If it's old enough we start to trim it down and scramble parts.
	if(_n >= entries_decay_at)
		var/decayed_message = ""
		for(var/i = 1 to length(_message))
			var/char = copytext(_message, i, i + 1)
			if(prob(round(_n * graffiti_decay_weight)))
				if(prob(99))
					decayed_message += pick(".",",","-","'","\\","/","\"",":",";")
			else
				decayed_message += char
		_message = decayed_message

	if(length(_message))
		tokens["message"] = _message
		. = ..()

/datum/persistent/graffiti/create_entry_instance(var/turf/creating, var/list/tokens)
	new /obj/effect/decal/writing(creating, tokens["age"]+1, tokens["message"], tokens["author"])

/datum/persistent/graffiti/is_valid_entry(var/atom/entry)
	. = ..()
	if(.)
		var/turf/T = entry.loc
		. = T.can_engrave()

/datum/persistent/graffiti/get_entry_age(var/atom/entry)
	var/obj/effect/decal/writing/save_graffiti = entry
	return save_graffiti.graffiti_age

/datum/persistent/graffiti/compile_entry(var/atom/entry, var/write_file)
	. = ..()
	var/obj/effect/decal/writing/save_graffiti = entry
	LAZYADD(., "[save_graffiti.author ? save_graffiti.author : "unknown"]")
	LAZYADD(., "[save_graffiti.message]")
