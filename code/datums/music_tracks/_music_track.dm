/music_track
	var/artist
	var/title
	var/album
	var/decl/license/license
	var/song
	var/url // Remember to include http:// or https:// or BYOND will be sad
	var/volume = 70

/music_track/New()
	license = decls_repository.get_decl(license)

/music_track/proc/play_to(var/listener)
	to_chat(listener, "<span class='good'>Now Playing:</span>")
	to_chat(listener, "<span class='good'>[title][artist ? " by [artist]" : ""][album ? " ([album])" : ""]</span>")
	if(url)
		to_chat(listener, url)

	to_chat(listener, "<span class='good'>License: <a href='[license.url]'>[license.name]</a></span>")
	sound_to(listener, sound(song, repeat = 1, wait = 0, volume = volume, channel = GLOB.lobby_sound_channel))

// No VV editing anything about music tracks
/music_track/VV_static()
	return ..() + vars
