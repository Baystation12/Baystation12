/jukebox //abstraction of music player behavior for jukeboxes, headphones, etc
	var/atom/owner
	var/sound_id
	var/datum/sound_token/token
	var/list/tracks
	var/index = 1
	var/volume = 20
	var/volume_max = 50
	var/volume_step = 10
	var/frequency = 1
	var/range = 7
	var/falloff = 1
	var/template
	var/ui_title
	var/ui_width
	var/ui_height
	var/playing


/jukebox/New(atom/_owner, _template, _ui_title, _ui_width, _ui_height)
	. = ..()
	if (QDELETED(_owner) || !isatom(_owner))
		qdel(src)
		return
	owner = _owner
	tracks = list()
	for (var/path in GLOB.jukebox_tracks)
		var/decl/audio/track/track = decls_repository.get_decl(path)
		AddTrack(track.display || track.title, track.source)
	sound_id = "[/jukebox]_[sequential_id(/jukebox)]"
	template = _template
	ui_title = _ui_title
	ui_width = _ui_width
	ui_height = _ui_height


/jukebox/Destroy()
	QDEL_NULL_LIST(tracks)
	QDEL_NULL(token)
	owner = null
	. = ..()


/jukebox/proc/AddTrack(title = "Track [length(tracks) + 1]", source)
	tracks += new /jukebox_track (title, source)


/jukebox/proc/Next()
	if (++index > length(tracks))
		index = 1
	if (playing)
		Stop()
		Play()


/jukebox/proc/Last()
	if (--index < 1)
		index = length(tracks)
	if (playing)
		Stop()
		Play()


/jukebox/proc/Track(_index)
	_index = text2num(_index)
	if (!IsInteger(_index))
		return
	index = clamp(_index, 1, length(tracks))
	if (playing)
		Stop()
		Play()


/jukebox/proc/Stop()
	playing = FALSE
	QDEL_NULL(token)
	owner.queue_icon_update()


/jukebox/proc/Play()
	if (playing)
		return
	var/jukebox_track/track = tracks[index]
	if (!track.source)
		return
	playing = TRUE
	token = GLOB.sound_player.PlayLoopingSound(owner, sound_id, track.source,
		volume, range, falloff, frequency = frequency, preference = /datum/client_preference/play_jukeboxes, prefer_mute = TRUE)
	owner.queue_icon_update()


/jukebox/proc/Volume(_volume)
	_volume = text2num(_volume)
	if (!isfinite(_volume))
		return
	if (_volume >= 0)
		volume = min(_volume, volume_max)
	else if (_volume == -1)
		volume = max(volume - volume_step, 0)
	else if (_volume == -2)
		volume = min(volume + volume_step, volume_max)
	if (token)
		token.SetVolume(volume)


/jukebox/nano_host()
	return owner


/jukebox/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui, force_open = TRUE, datum/topic_state/state = GLOB.default_state)//, datum/topic_state/state = GLOB.jukebox_state)
	var/list/data_tracks = list()
	for (var/i = 1 to length(tracks))
		var/jukebox_track/track = tracks[i]
		data_tracks += list(list("track" = track.title, "index" = i))
	var/jukebox_track/track = tracks[index]
	var/list/data = list(
		"track" = track.title,
		"playing" = playing,
		"volume" = volume,
		"tracks" = data_tracks
	)
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new (user, src, ui_key, template, ui_title, ui_width, ui_height, state = state)
		ui.set_initial_data(data)
		ui.open()


/jukebox/Topic(href, href_list)
	switch ("[href_list["act"]]")
		if ("next") Next()
		if ("last") Last()
		if ("stop") Stop()
		if ("play") Play()
		if ("volume") Volume("[href_list["dat"]]")
		if ("track") Track("[href_list["dat"]]")
	return TOPIC_REFRESH



/jukebox_track
	var/title
	var/source


/jukebox_track/New(_title, _source, _volume)
	title = _title
	source = _source



GLOBAL_LIST_INIT(jukebox_tracks, list(
	/decl/audio/track/absconditus,
	/decl/audio/track/ambispace,
	/decl/audio/track/asfarasitgets,
	/decl/audio/track/clouds_of_fire,
	/decl/audio/track/comet_haley,
	/decl/audio/track/df_theme,
	/decl/audio/track/digit_one,
	/decl/audio/track/dilbert,
	/decl/audio/track/eighties,
	/decl/audio/track/elevator,
	/decl/audio/track/elibao,
	/decl/audio/track/endless_space,
	/decl/audio/track/floating,
	/decl/audio/track/hull_rupture,
	/decl/audio/track/human,
	/decl/audio/track/inorbit,
	/decl/audio/track/lasers,
	/decl/audio/track/level3_mod,
	/decl/audio/track/lysendraa,
	/decl/audio/track/marhaba,
	/decl/audio/track/martiancowboy,
	/decl/audio/track/misanthropic_corridors,
	/decl/audio/track/monument,
	/decl/audio/track/nebula,
	/decl/audio/track/on_the_rocks,
	/decl/audio/track/one_loop,
	/decl/audio/track/pwmur,
	/decl/audio/track/rimward_cruise,
	/decl/audio/track/space_oddity,
	/decl/audio/track/thunderdome,
	/decl/audio/track/torch,
	/decl/audio/track/torn,
	/decl/audio/track/treacherous_voyage,
	/decl/audio/track/voidsent,
	/decl/audio/track/wake,
	/decl/audio/track/wildencounters
))
