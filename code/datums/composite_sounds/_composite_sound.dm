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

/datum/composite_sound
	var/list/atom/output_atoms = list()
	var/mid_sounds
	var/mid_length
	var/start_sound
	var/start_length
	var/end_sound
	var/chance
	var/volume = 100
	var/max_loops
	var/direct

	var/timerid

/datum/composite_sound/New(list/_output_atoms=list(), start_immediately=FALSE, _direct=FALSE)
	if(!mid_sounds)
		WARNING("A composite sound datum was created without sounds to play.")
		return

	output_atoms |= _output_atoms
	direct = _direct

	if(start_immediately)
		start()

/datum/composite_sound/Destroy()
	stop()
	output_atoms = null
	return ..()

/datum/composite_sound/proc/start(atom/add_thing)
	if(add_thing)
		LAZYDISTINCTADD(output_atoms, add_thing)
	if(timerid)
		return
	on_start()

/datum/composite_sound/proc/stop(atom/remove_thing)
	if(remove_thing)
		LAZYREMOVE(output_atoms, remove_thing)
	if(!timerid)
		return
	on_stop()
	deltimer(timerid)
	timerid = null

/datum/composite_sound/proc/sound_loop(starttime)
	if(max_loops && (world.time >= starttime + mid_length * max_loops))
		stop()
		return
	if(!chance || prob(chance))
		play(get_sound(starttime))
	if(!timerid)
		timerid = addtimer(new Callback(src, .proc/sound_loop, world.time), mid_length, TIMER_STOPPABLE | TIMER_LOOP)

/datum/composite_sound/proc/play(soundfile)
	var/sound/S = sound(soundfile)
	for(var/atom/thing as anything in output_atoms)
		playsound(thing, S, volume)

/datum/composite_sound/proc/get_sound(starttime, _mid_sounds)
	. = _mid_sounds || mid_sounds
	while(!isfile(.) && !isnull(.))
		. = pickweight(.)

/datum/composite_sound/proc/on_start()
	var/start_wait = 0
	if(start_sound)
		play(start_sound)
		start_wait = start_length
	addtimer(new Callback(src, .proc/sound_loop), start_wait, TIMER_CLIENT_TIME)

/datum/composite_sound/proc/on_stop()
	if(end_sound)
		play(end_sound)
