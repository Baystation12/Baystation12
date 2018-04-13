/datum/unit_test/music_track_validate
	name = "MUSIC TRACK: Validate Music Tracks"

/datum/unit_test/music_track_validate/start_test()
	var/music_tracks_by_type = decls_repository.get_decls_of_subtype(/music_track)

	var/list/bad_tracks = list()
	for(var/music_track_type in music_tracks_by_type)
		var/music_track/music_track = music_tracks_by_type[music_track_type]
		if(!music_track.song)
			log_bad("[music_track_type] - Missing song")
			bad_tracks |= music_track
		if(!music_track.title)
			log_bad("[music_track_type] - Missing title")
			bad_tracks |= music_track
		if(istype(music_track.license, /decl/license))
			if(music_track.license.attribution_mandatory)
				if(!music_track.artist || cmptext(music_track.artist, "unknown"))
					log_bad("[music_track_type] - Invalid artist")
					bad_tracks |= music_track
				if(!music_track.url || cmptext(music_track.url, "unknown"))
					log_bad("[music_track_type] - Invalid url")
					bad_tracks |= music_track
		else
			log_bad("[music_track_type] - Invalid license")
			bad_tracks |= music_track

	if(bad_tracks.len)
		fail("Found [bad_tracks.len] incorrectly setup music track\s.")
	else
		pass("All music tracks are correctly setup.")

	return 1

/datum/unit_test/jukebox_track_validate
	name = "MUSIC TRACK: Validate Jukebox Tracks"

/datum/unit_test/jukebox_track_validate/start_test()
	var/list/bad_boxes = list()
	for(var/obj/machinery/media/jukebox/jukebox in world)
		for(var/entry in jukebox.tracks)
			var/datum/track/track = entry
			if(!track.title || !ispath(track.track, /music_track))
				bad_boxes += jukebox
				log_bad("Invalid jukebox track: [log_info_line(jukebox)]")
				break

	if(bad_boxes.len)
		fail("Found [bad_boxes.len] invalid jukebox(es)")
	else
		pass("All jukeboxes had valid tracks.")

	return 1
