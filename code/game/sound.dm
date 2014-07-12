var/list/shatter_sound = list('sound/effects/Glassbr1.ogg','sound/effects/Glassbr2.ogg','sound/effects/Glassbr3.ogg')
var/list/explosion_sound = list('sound/effects/Explosion1.ogg','sound/effects/Explosion2.ogg')
var/list/spark_sound = list('sound/effects/sparks1.ogg','sound/effects/sparks2.ogg','sound/effects/sparks3.ogg','sound/effects/sparks4.ogg')
var/list/rustle_sound = list('sound/effects/rustle1.ogg','sound/effects/rustle2.ogg','sound/effects/rustle3.ogg','sound/effects/rustle4.ogg','sound/effects/rustle5.ogg')
var/list/punch_sound = list('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg')
var/list/clown_sound = list('sound/effects/clownstep1.ogg','sound/effects/clownstep2.ogg')
var/list/swing_hit_sound = list('sound/weapons/genhit1.ogg', 'sound/weapons/genhit2.ogg', 'sound/weapons/genhit3.ogg')
var/list/hiss_sound = list('sound/voice/hiss1.ogg','sound/voice/hiss2.ogg','sound/voice/hiss3.ogg','sound/voice/hiss4.ogg')
var/list/page_sound = list('sound/effects/pageturn1.ogg', 'sound/effects/pageturn2.ogg','sound/effects/pageturn3.ogg')
//var/list/gun_sound = list('sound/weapons/Gunshot.ogg', 'sound/weapons/Gunshot2.ogg','sound/weapons/Gunshot3.ogg','sound/weapons/Gunshot4.ogg')

/proc/playsound(var/atom/source, soundin, vol as num, vary, extrarange as num, falloff)

	soundin = get_sfx(soundin) // same sound for everyone

	if(isarea(source))
		error("[source] is an area and is trying to make the sound: [soundin]")
		return

	var/frequency = get_rand_frequency() // Same frequency for everybody
	var/turf/turf_source = get_turf(source)
	playsound_flood(turf_source, soundin, vol, vary, frequency, falloff, extrarange)

/* 	// Looping through the player list has the added bonus of working for mobs inside containers
	for (var/P in player_list)
		var/mob/M = P
		if(!M || !M.client)
			continue
		if(get_dist(M, turf_source) <= (world.view + extrarange) * 6)
			var/turf/T = get_turf(M)
			if(T && T.z == turf_source.z)
//				M.playsound_local(turf_source, soundin, vol, vary, frequency, falloff)
				playsound_flood(turf_source, soundin, vol, vary, frequency, falloff)*/

var/const/FALLOFF_SOUNDS = 2
var/const/SURROUND_CAP = 30

/mob/proc/playsound_local(var/turf/turf_source, soundin, vol as num, vary, frequency, falloff)
	if(!src.client || ear_deaf > 0)	return
	soundin = get_sfx(soundin)

	var/sound/S = sound(soundin)
	S.wait = 0 //No queue
	S.channel = 0 //Any channel
	S.volume = vol
	S.environment = 2

	if (vary)
		if(frequency)
			S.frequency = frequency
		else
			S.frequency = get_rand_frequency()

	if(isturf(turf_source))
		// 3D sounds, the technology is here!
		var/turf/T = get_turf(src)
		S.volume -= get_dist(T, turf_source) * 0.5
		if (S.volume < 0)
			S.volume = 0
		var/dx = turf_source.x - T.x // Hearing from the right/left

		S.x = round(max(-SURROUND_CAP, min(SURROUND_CAP, dx)), 1)

		var/dz = turf_source.y - T.y // Hearing from infront/behind
		S.z = round(max(-SURROUND_CAP, min(SURROUND_CAP, dz)), 1)

		// The y value is for above your head, but there is no ceiling in 2d spessmens.
		S.y = 1
		S.falloff = (falloff ? falloff : FALLOFF_SOUNDS)

	src << S

/client/proc/playtitlemusic()
	if(!ticker || !ticker.login_music)	return
	if(prefs.toggles & SOUND_LOBBY)
		src << sound(ticker.login_music, repeat = 0, wait = 0, volume = 85, channel = 1) // MAD JAMS

/proc/get_rand_frequency()
	return rand(32000, 55000) //Frequency stuff only works with 45kbps oggs.

/proc/get_sfx(soundin)
	if(istext(soundin))
		switch(soundin)
			if ("shatter") soundin = pick(shatter_sound)
			if ("explosion") soundin = pick(explosion_sound)
			if ("sparks") soundin = pick(spark_sound)
			if ("rustle") soundin = pick(rustle_sound)
			if ("punch") soundin = pick(punch_sound)
			if ("clownstep") soundin = pick(clown_sound)
			if ("swing_hit") soundin = pick(swing_hit_sound)
			if ("hiss") soundin = pick(hiss_sound)
			if ("pageturn") soundin = pick(page_sound)
			//if ("gunshot") soundin = pick(gun_sound)
	return soundin


/*
 *  This is a kind of crude flood-filling directional sound method
 *  loosely based on A* pathfinding with some potentially costly list
 *  operations to try and preserve smooth/sane sound falloff.
 *  ~ Z
 */
/*  I've gone through and integrated this with three directional audio.
 *  The way it's handled now is that anything that calls playsound() will
 *  call playsound_flood(), which produces a floodmap if there is an origin turf
 *  Otherwise, it'll just produce a global sound
 */

#define SOUND_FLOOD_FAILSAFE 200
/proc/playsound_flood(var/turf/origin, var/soundfile, var/volume, var/vary, var/frequency, var/falloff, var/extrarange)

	if(!soundfile || !volume) return


	soundfile = get_sfx(soundfile)
	var/sound/S = sound(soundfile)
	S.wait = 0 //No queue
	S.channel = 0 //Any channel
	S.environment = 2

	if (vary)
		if(frequency)
			S.frequency = frequency
		else
			S.frequency = get_rand_frequency()

	var/list/open_turfs = list()
	var/list/closed_turfs = list()

	// The open list stores both the turf and the volume of the sound when
	// it was added to the list; this is passed onto neighbors later.
	open_turfs[origin] = volume*2
	var/attempts = 0

	if(!isturf(origin))
		for (var/P in player_list)
			var/mob/M = P
			if(!M || !M.client)
				continue
			if(get_dist(M, origin) <= (world.view + extrarange) * 6)
				var/turf/T = get_turf(M)
				if(T && T.z == origin.z)
					M << S

	else
		while(open_turfs.len && attempts < SOUND_FLOOD_FAILSAFE)

			attempts++

			// Modifying the overall open turf list during the loop will cause some
			// turfs closer to the origin to have a lower volume than turfs farther
			// away, so we just copy it over and loop over the copy.

			var/list/current_open_turfs = open_turfs.Copy()

			for(var/turf/T in current_open_turfs)

				if(isnull(current_open_turfs[T]))
					continue

				//Switch turf from list of viable turfs to list of checked turfs.
				closed_turfs[T] = 1
				open_turfs[T] = null

				//Debug checks
				T.color = "#FF[num2hex(Floor(255-(current_open_turfs[T]/2)))][num2hex(Floor(current_open_turfs[T]/2))]"

				//Actually play the desired sound file.
				var/sound_dir
				for(var/mob/M in T.contents)
					//Get the sound dir once per turf loop.
					if(!sound_dir) sound_dir = get_dir(origin,T)
					//playsound(M.loc, soundfile, Floor(current_open_turfs[T]/2), 1)
					if(!M.client || M.ear_deaf > 0)
						return
					else
						var/turf/MT = M.loc

						S.volume = Floor(current_open_turfs[T])
						world << S.volume

						var/dx = origin.x - MT.x // Hearing from the right/left

						S.x = round(max(-SURROUND_CAP, min(SURROUND_CAP, dx)), 1)

						var/dz = origin.y - MT.y // Hearing from infront/behind
						S.z = round(max(-SURROUND_CAP, min(SURROUND_CAP, dz)), 1)

						// The y value is for above your head, but there is no ceiling in 2d spessmens.
						S.y = 1
						M << S

				//Add the neighbors to the list of viable turfs...
				for(var/turf/N in range(1,T))

					//...assuming we haven't checked them already.
					if(!isnull(closed_turfs[N]))
						continue

					//Some turfs are going to muffle sound more than others.
					var/newvolume = current_open_turfs[T] - N.sound_reduction

					//Doors will muffle sound.
					var/obj/machinery/door/D = locate() in N.contents
					if(D && D.density == 1 && D.loc != origin )
						newvolume = max(0,newvolume - 25)

					//Increase loss on diagonals to smooth it out a little.
/*					if(T.x != N.x && T.y != N.y)
						newvolume = Floor(newvolume*0.8)*/

					//gas pressure will reduce volume
					var/datum/gas_mixture/environment = T.return_air()
					newvolume = newvolume * Clamp(environment.return_pressure()/100,0,1)

					if(newvolume && newvolume > 0)
						//We will check this turf next pass.
//						if(!isnull(open_turfs[N]))
//							open_turfs[N] = Floor((open_turfs[N] + newvolume)/2)
//						else
						open_turfs[N] = newvolume
					else
						//Volume is 0, don't do anything with this turf.
						closed_turfs[N] = 1



/turf
	var/sound_reduction = 1

/turf/space
	sound_reduction = 255

/turf/simulated/wall
	sound_reduction = 25