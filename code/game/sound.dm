/proc/playsound(var/atom/source, soundin, vol as num, vary, extrarange as num)
	//Frequency stuff only works with 45kbps oggs.

	switch(soundin)
		if ("shatter") soundin = pick('Glassbr1.ogg','Glassbr2.ogg','Glassbr3.ogg')
		if ("explosion") soundin = pick('Explosion1.ogg','Explosion2.ogg')
		if ("sparks") soundin = pick('sparks1.ogg','sparks2.ogg','sparks3.ogg','sparks4.ogg')
		if ("rustle") soundin = pick('rustle1.ogg','rustle2.ogg','rustle3.ogg','rustle4.ogg','rustle5.ogg')
		if ("punch") soundin = pick('punch1.ogg','punch2.ogg','punch3.ogg','punch4.ogg')
		if ("clownstep") soundin = pick('clownstep1.ogg','clownstep2.ogg')
		if ("swing_hit") soundin = pick('genhit1.ogg', 'genhit2.ogg', 'genhit3.ogg')
		if ("hiss") soundin = pick('hiss1.ogg','hiss2.ogg','hiss3.ogg','hiss4.ogg')

	var/sound/S = sound(soundin)
	S.wait = 0 //No queue
	S.channel = 0 //Any channel
	S.volume = vol

	if (vary)
		S.frequency = rand(32000, 55000)
	for (var/mob/M in range(world.view+extrarange, source))       // Plays for people in range.
		if (M.client)
			if(M.ear_deaf <= 0 || !M.ear_deaf)
				if(isturf(source))
					var/dx = source.x - M.x
					S.pan = max(-100, min(100, dx/8.0 * 100))

				M << S

				for(var/obj/structure/closet/L in range(world.view+extrarange, source))
					if(locate(/mob/, L))
						for(var/mob/Ml in L)
							Ml << S
																		// Now plays for people in lockers!  -- Polymorph

/mob/proc/playsound_local(var/atom/source, soundin, vol as num, vary, extrarange as num)
	if(!src.client || ear_deaf > 0)	return
	switch(soundin)
		if ("shatter") soundin = pick('Glassbr1.ogg','Glassbr2.ogg','Glassbr3.ogg')
		if ("explosion") soundin = pick('Explosion1.ogg','Explosion2.ogg')
		if ("sparks") soundin = pick('sparks1.ogg','sparks2.ogg','sparks3.ogg','sparks4.ogg')
		if ("rustle") soundin = pick('rustle1.ogg','rustle2.ogg','rustle3.ogg','rustle4.ogg','rustle5.ogg')
		if ("punch") soundin = pick('punch1.ogg','punch2.ogg','punch3.ogg','punch4.ogg')
		if ("clownstep") soundin = pick('clownstep1.ogg','clownstep2.ogg')
		if ("swing_hit") soundin = pick('genhit1.ogg', 'genhit2.ogg', 'genhit3.ogg')
		if ("hiss") soundin = pick('hiss1.ogg','hiss2.ogg','hiss3.ogg','hiss4.ogg')

	var/sound/S = sound(soundin)
	S.wait = 0 //No queue
	S.channel = 0 //Any channel
	S.volume = vol

	if (vary)
		S.frequency = rand(32000, 55000)
	if(isturf(source))
		var/dx = source.x - src.x
		S.pan = max(-100, min(100, dx/8.0 * 100))

	src << S

client/verb/Toggle_Soundscape()
	set category = "OOC"
	set name = "Toggle Ambience"
	usr:client:no_ambi = !usr:client:no_ambi
	if(usr:client:no_ambi)
		usr << sound('shipambience.ogg', repeat = 0, wait = 0, volume = 0, channel = 2)
	else
		usr << sound('shipambience.ogg', repeat = 1, wait = 0, volume = 35, channel = 2)
	usr << "Toggled ambience sound."
	return


/area/Entered(A)
	var/sound = null
	var/musVolume = 25
	sound = 'ambigen1.ogg'

	if (ismob(A))

		if (istype(A, /mob/dead/observer)) return
		if (!A:client) return
		//if (A:ear_deaf) return

		if (A && A:client && !A:client:ambience_playing && !A:client:no_ambi) // Ambience goes down here -- make sure to list each area seperately for ease of adding things in later, thanks! Note: areas next to each other should have the same sounds to prevent cutoff when possible.- LastyScratch
			A:client:ambience_playing = 1
			A << sound('shipambience.ogg', repeat = 1, wait = 0, volume = 35, channel = 2)

		switch(src.name)
			if ("Chapel") sound = pick('ambicha1.ogg','ambicha2.ogg','ambicha3.ogg','ambicha4.ogg')
			if ("Morgue") sound = pick('ambimo1.ogg','ambimo2.ogg','title2.ogg')
			if ("Space") sound = pick('ambispace.ogg','title2.ogg',)
			if ("Engine Control") sound = pick('ambisin1.ogg','ambisin2.ogg','ambisin3.ogg','ambisin4.ogg')
			if ("Atmospherics") sound = pick('ambiatm1.ogg')
			if ("AI Sat Ext") sound = pick('ambiruntime.ogg','ambimalf.ogg')
			if ("AI Satellite") sound = pick('ambimalf.ogg')
			if ("AI Satellite Teleporter Room") sound = pick('ambiruntime.ogg','ambimalf.ogg')
			if ("Bar") sound = pick('title1.ogg')
			if ("AI Upload Foyer") sound = pick('ambimalf.ogg', 'null.ogg')
			if ("AI Upload Chamber") sound = pick('ambimalf.ogg','null.ogg')
			if ("Mine")
				sound = pick('ambimine.ogg')
				musVolume = 25
			else
				sound = pick('ambiruntime.ogg','ambigen1.ogg','ambigen3.ogg','ambigen4.ogg','ambigen5.ogg','ambigen6.ogg','ambigen7.ogg','ambigen8.ogg','ambigen9.ogg','ambigen10.ogg','ambigen11.ogg','ambigen12.ogg','ambigen14.ogg')


		if (prob(35))
			if(A && A:client && !A:client:played)
				A << sound(sound, repeat = 0, wait = 0, volume = musVolume, channel = 1)
				A:client:played = 1
				spawn(600)
					if(A && A:client)
						A:client:played = 0
