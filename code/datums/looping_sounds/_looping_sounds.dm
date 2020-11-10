/*
	output_atoms	(list of atoms)			The destination(s) for the sounds

	mid_sounds		(list or soundfile)		Since this can be either a list or a single soundfile you can have random sounds. May contain further lists but must contain a soundfile at the end.
	mid_length		(num)					The length to wait between playing mid_sounds

	start_sound		(soundfile)				Played before starting the mid_sounds loop
	start_length	(num)					How long to wait before starting the main loop after playing start_sound

	end_sound		(soundfile)				The sound played after the main loop has concluded

	chance			(num)					Chance per loop to play a mid_sound
	volume			(num)					Sound output volume
	max_loops		(num)					The max amount of loops to run for.
	direct			(bool)					If true plays directly to provided atoms instead of from them
*/
/datum/looping_sound
	var/list/atom/output_atoms
	var/mid_sounds
	var/mid_length
	///Override for volume of start sound
	var/start_volume
	var/start_sound
	var/start_length
	///Override for volume of end sound
	var/end_volume
	var/end_sound
	var/chance
	var/volume = 100
	var/vary = FALSE
	var/max_loops
	var/direct
	var/extra_range = 0
	var/falloff_exponent
	var/timerid
	var/falloff_distance
	var/sound_id
	var/datum/sound_token/sound_token

/datum/looping_sound/New(list/_output_atoms=list(), start_immediately=FALSE, _direct=FALSE)
	if(!mid_sounds)
		WARNING("A looping sound datum was created without sounds to play.")
		return

	output_atoms = _output_atoms
	direct = _direct

	if(start_immediately)
		start()

/datum/looping_sound/Destroy()
	stop()
	output_atoms = null
	return ..()

/datum/looping_sound/proc/start(atom/add_thing)
	testing("Starting a sound! [add_thing], [timerid]")
	if(add_thing)
		output_atoms |= add_thing
	on_start()

/datum/looping_sound/proc/stop(atom/remove_thing)
	if(remove_thing)
		output_atoms -= remove_thing
	if(!timerid)
		return

	QDEL_NULL(sound_token)
	sound_id = null
	on_stop()
	if (timerid)
		deltimer(timerid)
		timerid = null

/datum/looping_sound/proc/start_mid_sound(starttime)
	if (!chance || prob(chance))
		play(get_sound())

/datum/looping_sound/proc/play(soundfile, volume_override, no_loop=FALSE)
	testing("Trying to play sound: [soundfile]")

	var/list/atoms_cache = output_atoms
	var/sound/S = sound(soundfile)
	sound_id = "[type]_[sequential_id(type)]"
	S.volume = volume_override || volume //Use volume as fallback if theres no override
	for(var/i in 1 to atoms_cache.len)
		var/atom/thing = atoms_cache[i]
		if(no_loop)
			sound_to(thing, S)
		else
			//playsound(var/atom/source, soundin, vol as num, vary, extrarange as num, falloff, var/is_global, var/frequency, var/is_ambiance = 0)
			//playsound(thing, S, volume, vary, extra_range, 0, FALSE, null, TRUE)
			//PlayLoopingSound(var/atom/source, var/sound_id, var/sound, var/volume, var/range, var/falloff = 1, var/echo, var/frequency, var/prefer_mute)
			testing("Playing sound")
			sound_token = GLOB.sound_player.PlayLoopingSound(thing, sound_id, S, volume)
			sound_token.PrivLocateListeners(current_turfs = get_area_turfs(thing))


/datum/looping_sound/proc/get_sound(starttime, _mid_sounds)
	. = _mid_sounds || mid_sounds
	while (!isfile(.) && !isnull(.))
		. = pickweight(.)

/datum/looping_sound/proc/on_start()
	var/start_wait = 0
	if (start_sound)
		play(start_sound, start_volume)
		start_wait = start_length
	timerid = addtimer(CALLBACK(src, .proc/start_mid_sound), start_wait, TIMER_CLIENT_TIME | TIMER_STOPPABLE)

/datum/looping_sound/proc/on_stop()
	if (end_sound)
		play(end_sound, end_volume, TRUE)