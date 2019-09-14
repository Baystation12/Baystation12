/decl/language
	var/name
	var/shorthand
	var/desc
	var/key
	var/component_flags = LANG_COMPONENT_AUDIBLE
	var/property_flags

	var/ask_verbs
	var/exclamation_verbs
	var/speech_verbs
	var/whisper_verbs

	var/distance_modifier
	var/list/message_modifiers // Innate message modifiers
	var/category = /decl/language

//To check if the language can be utilized at all, i.e. a hivemind language might require a particular organ to produce/receive
/decl/language/proc/CanProduce(var/atom/A)
	return TRUE

// To check if the language can be properly produced, otherwise it is muddled
/decl/language/proc/CanProduceProperly(var/atom/A)
	return TRUE

// Similar to producing but for the receiver
/decl/language/proc/CanReceive(var/atom/A)
	return TRUE

/decl/language/proc/CanReceiveProperly(var/atom/A)
	return TRUE

// Acquire the list of atoms that can receive given the speaker, distance, and ghost preferences
/decl/language/proc/Receivers(var/atom/speaker, var/distance)
	distance += distance_modifier
	. = OnGetReceivers(speaker, distance) || list()

	if(component_flags & LANG_COMPONENT_AUDIBLE)
		for(var/hearer in hearers_in_range(speaker, distance))
			if(CanReceive(hearer))
				.[hearer] |= RECEIVED_AUDIO

	if(component_flags & LANG_COMPONENT_VISIBLE)
		for(var/viewer in viewers_in_range(speaker, distance))
			if(CanReceive(viewer))
				.[viewer] |= RECEIVED_VISION

	if(component_flags & LANG_COMPONENT_ANY_HIVEMIND)
		var/turf/speaker_turf = get_turf(speaker)
		var/z_block = GetConnectedZlevels(speaker_turf.z)

		for(var/vmob in GLOB.all_virtual_mobs)
			var/mob/observer/virtual/V = vmob
			var/atom/host = V.host
			if(!CanReceive(host))
				continue

			if(component_flags & LANG_COMPONENT_GLOBAL_HIVEMIND)
				.[host] |= RECEIVED_GLOBAL_HIVEMIND

			if(component_flags & LANG_COMPONENT_ZBLOCK_HIVEMIND)
				if(V.z in z_block)
					.[host] |= RECEIVED_ZBLOCK_HIVEMIND

			if(component_flags & LANG_COMPONENT_RANGED_HIVEMIND)
				if(speaker_turf.z == V.z && get_dist(speaker_turf, V) <= distance)
					.[host] |= RECEIVED_RANGE_HIVEMIND

	var/ghost_preferences = GhostPreferences()
	// The dead are always included in the receiver list (based on their preferences)
	if(!length(ghost_preferences))
		return

	for(var/mob in GLOB.player_list)
		var/mob/observer/ghost/G = mob
		if(G.stat == DEAD || istype(G))
			for(var/preference in ghost_preferences)
				if(G.get_preference_value(preference) == GLOB.PREF_NEARBY)
					.[G] = RECEIVED_FULLY // The flag doesn't really matter, we'll check for deadness later anyway
					break

// This is the get-receivers-proc subtypes should override and specialize if needed
// Primarily for languages that use LANG_COMPONENT_OTHER
/decl/language/proc/OnGetReceivers(var/atom/speaker, var/distance)
	return

/decl/language/proc/GhostPreferences()
	. = list()
	// Treating everything except visible components as audible speech in terms of ghost preferences
	if(component_flags & ~LANG_COMPONENT_VISIBLE)
		. += /datum/client_preference/ghost_ears
	if(component_flags & LANG_COMPONENT_VISIBLE)
		. += /datum/client_preference/ghost_sight

/decl/language/proc/GetMessageModifiers()
	return message_modifiers
