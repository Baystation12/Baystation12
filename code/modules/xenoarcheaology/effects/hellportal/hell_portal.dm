/datum/artifact_effect/hellportal
	name = "hellportal"
	effect_type = EFFECT_BLUESPACE
	var/convert_count //how many turfs are converted to lava each activation
	var/active_portals_max //how many portals can be spawned at each interval
	var/maximum_mob_count
	var/target_temp = 500
	var/activation_sound = 'sound/effects/ghost.ogg'
	var/mob_spawn_sounds = list(
		'sound/magic/mutate.ogg',
		'sound/effects/squelch1.ogg',
		'sound/effects/squelch2.ogg'
	)
	var/activation_messages = list(
		"lets loose a thousand agonized screams as it forces reality around it to bleed and distort!",
		"cracks and blisters, blood seeping out from within!",
		"shrieks as a blistering heat fills the room, the world around it turning to flesh and stone!",
		"emits a pained, human sounding groan as it disfigures reality!"
	)

	var/damage = 0
	var/list/monsters = list(
		/mob/living/simple_animal/hostile/meat/abomination = 5,
		/mob/living/simple_animal/hostile/meat/horror = 30,
		/mob/living/simple_animal/hostile/meat/strippedhuman = 60,
		/mob/living/simple_animal/hostile/meat/horrorminer = 60,
		/mob/living/simple_animal/hostile/meat/horrorsmall = 80,
		/mob/living/simple_animal/hostile/meat = 5,
		/mob/living/simple_animal/hostile/scarybat = 70,
		/mob/living/simple_animal/hostile/creature = 40
	)
	var/list/portals = list()
	var/list/mobs = list()

/datum/artifact_effect/hellportal/New()
	..()
	effect = EFFECT_PULSE
	convert_count = rand(1, 5)
	active_portals_max = rand(2, 4)
	maximum_mob_count = rand(5, 20)
	damage = rand(20, 50)
	if (chargelevelmax > 30)
		chargelevelmax = rand(10, 30)

/datum/artifact_effect/hellportal/Destroy()
	for (var/mob/M in mobs)
		unregister_mob(M)

	for (var/P in portals)
		GLOB.destroyed_event.unregister(P, src)

	..()

/datum/artifact_effect/hellportal/DoEffectPulse(send_message = TRUE)
	if (holder)
		convert_turfs()
		spawn_monsters()
		hurt_players(FALSE)
		playsound(holder, activation_sound, 100)
		var/datum/gas_mixture/env = holder.loc.return_air()
		if(env && env.temperature < target_temp)
			env.temperature += rand(2, 10)
		if (send_message)
			holder.visible_message(SPAN_DANGER("\The [holder] [pick(activation_messages)]"))

//Helper procs

/datum/artifact_effect/hellportal/proc/convert_turfs()
	for (var/i = 0 to convert_count)
		var/turf/T = pick(trange(effectrange, get_turf(holder)))
		var/turf/simulated/floor/F

		if (T.is_wall())
			T.ChangeTurf(/turf/simulated/wall/cult)
		else if (T.is_floor())
			F = T

			if (istype(F.flooring, /decl/flooring/flesh))
				continue

			if (prob(25))
				new /obj/effect/gibspawner/human(F)

			F.set_flooring(decls_repository.get_decl(/decl/flooring/flesh))
			F.desc = "Disgusting flooring made out of flesh, bone, eyes, and various other human bits and peices."


/datum/artifact_effect/hellportal/proc/spawn_monsters()
	if (length(mobs) < maximum_mob_count)
		for (var/i = 0 to (active_portals_max - length(portals)))
			if (length(portals) >= active_portals_max)
				return

			var/turf/T = pick(pick_turf_in_range(get_turf(holder), effectrange, list(/proc/not_turf_contains_dense_objects, /proc/is_not_space_turf, /proc/is_not_holy_turf, /proc/is_not_open_space)))

			if (!T)
				return

			var/obj/effect/gateway/artifact/small/gate = new(T)
			gate.spawnable = monsters
			gate.parent = src
			portals += gate

			GLOB.destroyed_event.register(gate, src, /datum/artifact_effect/hellportal/proc/reduce_portal_count)

/datum/artifact_effect/hellportal/proc/hurt_players(send_message = TRUE)
	for (var/mob/living/carbon/human/H in range(effectrange, get_turf(holder)))
		var/weakness = GetAnomalySusceptibility(H)
		H.apply_damage(damage * weakness, BRUTE, damage_flags = DAM_DISPERSED)
		H.apply_damage(damage * weakness, BURN, damage_flags = DAM_DISPERSED)
		if (send_message)
			if (weakness == 0)
				to_chat(H, SPAN_WARNING("Some unseen force tries to tear into your suit, but fails!"))
			else
				to_chat(H, SPAN_DANGER("Searing pain strikes your body as you briefly find yourself in a burning hellscape!"))

/datum/artifact_effect/hellportal/proc/reduce_portal_count(obj/effect/gateway/artifact/P)
	GLOB.destroyed_event.unregister(P, src)
	portals -= P

/datum/artifact_effect/hellportal/proc/unregister_mob(mob/M)
	GLOB.destroyed_event.unregister(M, src)
	GLOB.death_event.unregister(M, src)
	mobs -= M

/datum/artifact_effect/hellportal/proc/register_mob(mob/M)
	mobs += M
	GLOB.destroyed_event.register(M, src, .proc/unregister_mob)
	GLOB.death_event.register(M, src, .proc/unregister_mob)

	playsound(M, pick(mob_spawn_sounds), 100)

/datum/artifact_effect/hellportal/destroyed_effect()
	convert_count = rand(40, 60)
	active_portals_max = rand(15, 30)
	maximum_mob_count = 1000 //set obscenly high so we can spawn a bunch at once before deletion
	damage = rand(50, 100)
	effectrange = 30 //create lots of bads in a large area

	DoEffectPulse(FALSE)
	for(var/mob/M in GLOB.player_list)
		if((M.z == holder.z) && !istype(M,/mob/new_player))
			to_chat(M, SPAN_DANGER(FONT_LARGE("Agonized screams fill your ears as the world around you briefly burns in hellfire!")))
			if (istype(M, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = M
				H.apply_damage((damage / 4), BRUTE, damage_flags = DAM_DISPERSED)

	var/obj/effect/gateway/artifact/big/G = new (get_turf(holder))
	G.spawnable = monsters
	GLOB.sound_player.PlayLoopingSound(G, "\ref[src]", 'sound/effects/Heart Beat.ogg', 70, 6)
