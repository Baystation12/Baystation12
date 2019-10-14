
//monitor death beam

/obj/item/projectile/beam/monitor
	name = "monitor beam"
	icon_state = "heavylaser"

	damage = 500 //This should one-hit kill all mobs, including lekgolo. Likely destroys most vehicles just as fast, if not instantly.
	damage_type = BURN
	check_armour = "laser"
	armor_penetration = 100
	accuracy = 2

	muzzle_type = /obj/effect/projectile/laser_heavy/muzzle
	tracer_type = /obj/effect/projectile/laser_heavy/tracer
	impact_type = /obj/effect/projectile/laser_heavy/impact

/obj/item/weapon/gun/energy/laser/monitor_beam
	name = "Monitor Beam"
	self_recharge = 1
	recharge_time = 0
	fire_delay = 30

	fire_sound = 'code/modules/halo/sounds/Spartan_Laser_Beam_Shot_Sound_Effect.ogg'
	projectile_type = /obj/item/projectile/beam/monitor

/obj/item/weapon/gun/energy/laser/monitor_beam/handle_click_empty(mob/user)
	if(user)
		to_chat(user,"<span class='info'>[src] is temporarily out of charge, please wait a moment.</span>")

//monitor stun beam

/obj/item/projectile/beam/monitor_stun
	name = "monitor stun beam"
	icon_state = "stun"

	check_armour = "energy"
	sharp = 0 //not a laser
	taser_effect = 1
	agony = 40
	weaken = 2
	damage_type = STUN
	accuracy = 2

	muzzle_type = /obj/effect/projectile/stun/muzzle
	tracer_type = /obj/effect/projectile/stun/tracer
	impact_type = /obj/effect/projectile/stun/impact

/obj/item/weapon/gun/energy/laser/monitor_beam_stun
	name = "Monitor Stun Beam"
	self_recharge = 1
	recharge_time = 0
	fire_delay = 30

	fire_sound = 'code/modules/halo/sounds/Spartan_Laser_Beam_Shot_Sound_Effect.ogg'
	projectile_type = /obj/item/projectile/beam/monitor_stun

/obj/item/weapon/gun/energy/laser/monitor_beam_stun/handle_click_empty(mob/user)
	if(user)
		to_chat(user,"<span class='info'>[src] is temporarily out of charge, please wait a moment.</span>")

//angery monitor

/mob/living/simple_animal/hostile/monitor
	name = "Monitor"
	desc = "An incredibly advanced AI made from ancient alien technology."
	faction = "Forerunner"
	icon = 'code/modules/halo/Forerunner/Monitor.dmi'
	icon_state = "monitor"
	icon_living = "monitor"
	icon_dead = "monitor_dead"
	universal_speak = 1
	universal_understand = 1
	ranged = 1
	speak_chance = 7
	health = 9999999999
	maxHealth = 9999999999
	resistance = 1000
	feral = 1
	var/npc_use_stunbeam = 1
	var/list/speak_friendly = list("Let's see now!","Hmm, ah!","Oh, that's a good idea!","Hah I am a genius!","I am a genius hahahaha!","Ah!")
	var/list/speak_angry = list(\
		"You have endangered my installation!",\
		"Your recklessness threatens us all!",\
		"I cannot believe my makers let you live!",\
		"I see now. Truly we had no other choice!",\
		"The installation... it is mine!",\
		"You do not belong here!",\
		"We must enact containment protocols at once! No more delay!")
	var/list/emote_see_friendly = list("bobs gently","glows brightly for a moment","pulses","shines its eyebeam around it")
	var/list/emote_see_angry = list("emits a shower of sparks","twitches and vibrates",)
	var/list/emote_hear_friendly = list("chuckles","hums a tuneless song",)
	var/list/emote_hear_angry = list("screams in rage","screams in frustration")

	var/list/attack_response_friendly = list("Oh dear!","Oh well!","Are you really sure that's good idea?","Foolish.","How primitive.")
	var/list/attack_response_angry = list("I will save your head!","I will dispose of you!","Impertinence!")

	var/last_pain_scream = 0
	var/obj/item/weapon/gun/energy/laser/monitor_beam/monitorbeam
	var/obj/item/weapon/gun/energy/laser/monitor_beam_stun/monitorbeamstun
	var/obj/item/weapon/gun/selected_gun

/mob/living/simple_animal/hostile/monitor/friendly
	feral = 0

/mob/living/simple_animal/hostile/monitor/New()
	. = ..()
	monitorbeam = new()
	monitorbeamstun = new()
	selected_gun = monitorbeamstun
	name = monitor_name()

	src.verbs += /mob/living/simple_animal/hostile/monitor/proc/enable_stunbeam
	src.verbs += /mob/living/simple_animal/hostile/monitor/proc/deactivate_weapon

	if(feral)
		speak = speak_friendly + speak_angry
		emote_see = emote_see_friendly + emote_see_angry
		emote_hear = emote_hear_friendly + emote_hear_angry
	else
		speak = speak_friendly
		emote_see = emote_see_friendly
		emote_hear = emote_hear_friendly

/mob/living/simple_animal/hostile/monitor/Life()
	//for admins to force a switch between deathbeam and stunbeam
	if(npc_use_stunbeam)
		if(selected_gun == monitorbeam)
			enable_stunbeam()

	else if(selected_gun == monitorbeamstun)
		enable_deathbeam()

	. = ..()

/mob/living/simple_animal/hostile/monitor/proc/enable_deathbeam()
	set category = "IC"
	set name = "Switch to Death Beam"

	selected_gun = monitorbeam
	to_chat(src, "<span class='info'>You switch to Death Beam.</span>")

	src.verbs -= /mob/living/simple_animal/hostile/monitor/proc/enable_deathbeam
	src.verbs += /mob/living/simple_animal/hostile/monitor/proc/enable_stunbeam
	src.verbs |= /mob/living/simple_animal/hostile/monitor/proc/deactivate_weapon

/mob/living/simple_animal/hostile/monitor/proc/deactivate_weapon()
	set category = "IC"
	set name = "Power down weapons"

	selected_gun = null
	to_chat(src, "<span class='info'>You power down your weapons.</span>")
	src.verbs -= /mob/living/simple_animal/hostile/monitor/proc/deactivate_weapon

/mob/living/simple_animal/hostile/monitor/proc/enable_stunbeam()
	set category = "IC"
	set name = "Switch to Stun Beam"

	selected_gun = monitorbeamstun
	to_chat(src, "<span class='info'>You switch to Stun Beam.</span>")

	src.verbs += /mob/living/simple_animal/hostile/monitor/proc/enable_deathbeam
	src.verbs -= /mob/living/simple_animal/hostile/monitor/proc/enable_stunbeam
	src.verbs |= /mob/living/simple_animal/hostile/monitor/proc/deactivate_weapon

/mob/living/simple_animal/hostile/monitor/IsAdvancedToolUser()
	return 1

/mob/living/simple_animal/hostile/monitor/RangedAttack(var/atom/attacked)
	selected_gun.Fire(attacked, src)

/mob/living/simple_animal/hostile/monitor/bullet_act(var/obj/item/projectile/Proj)
	. = ..()
	if(last_pain_scream + 6 SECONDS < world.time && !src.client)
		if(feral)
			src.say(pick(attack_response_angry + attack_response_friendly))
		else
			src.say(pick(attack_response_friendly))
		last_pain_scream = world.time

/mob/living/simple_animal/hostile/monitor/FindTarget()
	if(!feral)
		return null
	return ..()

/mob/living/simple_animal/hostile/monitor/get_equivalent_body_part(var/def_zone)
	return "chassis"

/mob/living/simple_animal/hostile/monitor/death(gibbed, deathmessage = "explodes!", show_dead_message = 1)
	var/turf/T = get_turf(src)
	. = ..(gibbed, deathmessage, show_dead_message)
	explosion(T, 2, 4, 6, 8, adminlog = 0)
	new /obj/effect/gibspawner/robot(T)

/mob/living/simple_animal/hostile/monitor/bullet_act(var/obj/item/projectile/P, var/def_zone)
	if(istype(P, /obj/item/projectile/beam/sentinel))
		return PROJECTILE_FORCE_MISS

	if(istype(P, /obj/item/projectile/beam/monitor))
		return PROJECTILE_FORCE_MISS

	if(istype(P, /obj/item/projectile/beam/monitor_stun))
		return PROJECTILE_FORCE_MISS

	return ..()

// random monitor name

/proc/monitor_name()
	var/list/values = list(\
		"Penitent",\
		"Vigilant",\
		"Guilty",\
		"Defensive",\
		"Watchful",\
		"Silent",\
		"Watchful",\
		"Alert",\
		"Dutiful",\
		"Obedient",\
		"Magisterial",\
		"Obedient",\
		"Helpful",\
		"Facilitating",\
		"Subservient",\
		"Steady",\
		"Mindful",\
		"Obedient",\
		"Faithful",\
		"Loyal",\
		"Constant",\
		"Exuberant",\
		"Truthful",\
		"Abject",\
		"Despondent",\
		"Grieving",\
		"Anxious",\
		"Hopeless",\
		"Indifferent",\
		"Isolated",\
		"Jealous",\
		"Judgemental",\
		"Lonely",\
		"Lost",\
		"Erratic",\
		"Condemned",\
		"Conceited",\
		"Envious",\
		"Pitiful",\
		"Shy",\
		"Repressive",\
		"Resigned",\
		"Conflicted",\
		"Vain",\
		"Grateful",\
		"Elevated",\
		"Content",\
		"Euphoric",\
		"Volatile",\
		"Amplified",\
		"Inverse",\
		"Belligerent",\
		"Ebullient",\
		"Tragic",\
		"Static",\
		"Alternate",\
		"Quiescent",\
		"Trustworthy")

	var/list/nouns = list(\
		"Tangent",\
		"Spark",\
		"Sign",\
		"Carillon",\
		"Keeper",\
		"Guardian",\
		"Companion",\
		"Overseer",\
		"Shield",\
		"Protector",\
		"Custodian",\
		"Neuron",\
		"Parallel",\
		"Sentinel",\
		"Witness",\
		"Struct",\
		"Testament",\
		"Analogue",\
		"Rhetoric",\
		"Phase",\
		"Operator",\
		"Resolution",\
		"Vector",\
		"Pulse",\
		"Factor",\
		"Gauge",\
		"Creed",\
		"Parallel",\
		"Junction",\
		"Receiver",\
		"Counter",\
		"Signal",\
		"Transmission",\
		"Prism",\
		"Commons",\
		"Switch",\
		"Handover",\
		"Circuit",\
		"Harmonic",\
		"Carrier",\
		"Ripple",\
		"Register",\
		"Shift",\
		"Bridge",\
		"Circuit",\
		"Decibel",\
		"Watcher")

	var/number
	if(prob(33))
		number = 7 ** rand(1,5)
	else
		switch(pick(1,2,3,4))
			if(1)
				number = rand(1,9)
				number = "00[number]"
			if(2)
				number = rand(10,99)
				number = "0[number]"
			if(3)
				number = rand(100,999)
			if(4)
				number = rand(1000,9999)

	return "[number]-[pick(values)] [pick(nouns)]"
