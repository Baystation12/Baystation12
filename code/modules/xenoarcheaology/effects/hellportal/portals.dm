/obj/effect/gateway/artifact
	name = "reality tear"
	desc = "A piercing pain strikes your mind as you peer into the tear, witnessing horrors and suffering beyond comprehension."
	light_outer_range=5
	light_color="#ff0000"
	spawnable = list(
		/mob/living/simple_animal/hostile/meat/abomination = 5,
		/mob/living/simple_animal/hostile/meat/horror = 30,
		/mob/living/simple_animal/hostile/meat/strippedhuman = 60,
		/mob/living/simple_animal/hostile/meat/horrorminer = 60,
		/mob/living/simple_animal/hostile/meat/horrorsmall = 80,
		/mob/living/simple_animal/hostile/meat = 5,
		/mob/living/simple_animal/hostile/scarybat = 70,
		/mob/living/simple_animal/hostile/creature = 40
	)
	var/datum/artifact_effect/hellportal/parent
	var/mob_spawn_sounds = list(
		'sound/magic/mutate.ogg',
		'sound/effects/squelch1.ogg',
		'sound/effects/squelch2.ogg'
	)

/obj/effect/gateway/artifact/small/New(turf/T)
	..()

	addtimer(CALLBACK(src, .proc/create_and_delete), rand(15, 30) SECONDS)

/obj/effect/gateway/artifact/small/proc/create_and_delete()
	var/mob/living/simple_animal/T = pickweight(spawnable)
	T = new T(src.loc)
	T.min_gas = null
	T.max_gas = null
	T.minbodytemp = 0
	T.maxbodytemp = 5000
	T.faction = "meat"

	if (parent)
		parent.register_mob(T)

	playsound(T, pick(mob_spawn_sounds), 100)
	visible_message(SPAN_WARNING("\The [src] widens for a moment as a horrific monster forces its way through, before it blinks out of existence."))
	qdel(src)

//Spawns after the artifact is destroyed
/obj/effect/gateway/artifact/big
	name = "interdimensional gateway"
	desc = "A huge hole in reality with a strange, pulsing heartbeat. Faint, agonized screams can be heard from inside it..."
	light_outer_range = 10
	///Ticks down every so often until portal vanishes.
	var/health = 15
	///How many mobs we've spawned.
	var/spawned_mobs = 0
	///Maximum amount of mobs we can spawn.
	var/mob_limit
	///Multiplier applied to the `transform` variable.
	var/size_multiplier = 1.5
	///Portal will play a sound from this list when its health ticks down.
	var/list/sounds = list(
		'sound/hallucinations/wail.ogg',
		'sound/hallucinations/far_noise.ogg',
		'sound/hallucinations/veryfar_noise.ogg'
	)

/obj/effect/gateway/artifact/big/New(turf/T)
	..()

	mob_limit = health * 2
	SetTransform(scale = size_multiplier)
	addtimer(CALLBACK(src, .proc/spawn_monster), rand(30, 60) SECONDS)
	GLOB.sound_player.PlayLoopingSound(src, "\ref[src]", 'sound/effects/Heart Beat.ogg', 70, 6)

/obj/effect/gateway/artifact/big/proc/spawn_monster()
	var/mob/living/simple_animal/T = pickweight(spawnable)
	T = new T(src.loc)
	T.min_gas = null
	T.max_gas = null
	T.minbodytemp = 0
	T.maxbodytemp = 5000
	T.faction = "meat"

	if (prob(60))
		health--
		spawned_mobs++

		if (spawned_mobs >= mob_limit)
			health = 0

		playsound(loc, pick(sounds), 75, 1)

		if (health <= 0)
			visible_message(SPAN_DANGER("\The [src] shrieks and contorts as it finally collapses in on itself!"))
			qdel(src)
			return

		visible_message(SPAN_WARNING("\The [src] lets out an agonized wail, contorting as \the [T] crawls through!"))
	else
		visible_message(SPAN_WARNING("\The [src] deposits \the [T] into the world!"))


	addtimer(CALLBACK(src, .proc/spawn_monster), rand(15, 30) SECONDS)
