/datum/unit_test/audio_track_validate
	name = "AUDIO TRACK: Validate Audio Tracks"


/datum/unit_test/audio_track_validate/start_test()
	var/list/failed = list()
	var/list/available = decls_repository.get_decls_of_subtype(/decl/audio/track)
	for (var/key in available)
		var/decl/audio/track/track = available[key]
		if (!isfile(track.source))
			failed |= track
			log_bad("Invalid Audio Track [track.type]: Invalid Source")
		if (!istext(track.title))
			failed |= track
			log_bad("Invalid Audio Track [track.type]: Invalid Title")
		if (!istype(track.license, /decl/license))
			failed |= track
			log_bad("Invalid Audio Track [track.type]: Invalid License")
		else if (track.license.attribution_mandatory)
			if (!istext(track.author))
				failed |= track
				log_bad("Invalid Audio Track [track.type]: Invalid Author")
			if (!istext(track.url))
				failed |= track
				log_bad("Invalid Audio Track [track.type]: Invalid URL")
	if (length(failed))
		fail("Found [length(failed)] badly configured audio/track instance\s.")
	else
		pass("All audio/track instances OK.")
	return 1



/datum/unit_test/jukebox_validate
	name = "JUKEBOXES: Validate Jukeboxes"


/datum/unit_test/jukebox_validate/start_test()
	var/list/failed = list()
	for (var/jukebox/jukebox)
		for (var/entry in jukebox.tracks)
			var/jukebox_track/track = entry
			if (!track.title || !isfile(track.source))
				log_bad("Invalid Jukebox Track: [log_info_line(jukebox)]")
				failed += jukebox
				break
	if (length(failed))
		fail("Found [length(failed)] invalid jukebox\s.")
	else
		pass("All jukeboxes OK.")
	return 1
