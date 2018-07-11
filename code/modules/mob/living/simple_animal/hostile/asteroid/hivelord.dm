////////////////Hivelord////////////////

/mob/living/simple_animal/hostile/asteroid/hivelord
	name = "hivelord"
	desc = "A truly alien creature, it is a mass of unknown organic material, constantly fluctuating. When attacking, pieces of it split off and attack in tandem with the original."
	icon = 'icons/mob/asteroid/hivelord.dmi'
	icon_state = "Hivelord"
	icon_living = "Hivelord"
	icon_aggro = "Hivelord_alert"
	icon_dead = "Hivelord_dead"
	icon_gib = "syndicate_gib"
	mouse_opacity = 2
	move_to_delay = 14
	ranged = 1
	vision_range = 5
	aggro_vision_range = 9
	idle_vision_range = 5
	speed = 3
	maxHealth = 75
	health = 75
	harm_intent_damage = 5
	melee_damage_lower = 0
	melee_damage_upper = 0
	attacktext = "lashes out at"
	throw_message = "falls right through the strange body of the"
	ranged_cooldown = 0
	ranged_cooldown_cap = 0
	environment_smash = 0
	retreat_distance = 3
	minimum_distance = 3
	pass_flags = PASS_FLAG_TABLE

/mob/living/simple_animal/hostile/asteroid/hivelord/OpenFire(the_target)
	var/mob/living/simple_animal/hostile/asteroid/hivelordbrood/A = new /mob/living/simple_animal/hostile/asteroid/hivelordbrood(src.loc)
	A.GiveTarget(target_mob)
	A.friends = friends
	A.faction = faction
	return

/mob/living/simple_animal/hostile/asteroid/hivelord/AttackingTarget()
	OpenFire()

/mob/living/simple_animal/hostile/asteroid/hivelord/death(gibbed)
	new /obj/item/asteroid/hivelord_core(src.loc)
	mouse_opacity = 1
	..(gibbed)



////////////////Hivelordbrood////////////////

/mob/living/simple_animal/hostile/asteroid/hivelordbrood
	name = "hivelord brood"
	desc = "A fragment of the original Hivelord, rallying behind its original. One isn't much of a threat, but..."
	icon = 'icons/mob/asteroid/hivelord.dmi'
	icon_state = "Hivelordbrood"
	icon_living = "Hivelordbrood"
	icon_aggro = "Hivelordbrood"
	icon_dead = "Hivelordbrood"
	icon_gib = "syndicate_gib"
	mouse_opacity = 2
	move_to_delay = 0
	friendly = "buzzes near"
	vision_range = 10
	speed = 3
	maxHealth = 1
	health = 1
	harm_intent_damage = 5
	melee_damage_lower = 2
	melee_damage_upper = 2
	attacktext = "slashes"
	throw_message = "falls right through the strange body of the"
	environment_smash = 0
	pass_flags = PASS_FLAG_TABLE
	var/lifetime = 100

/mob/living/simple_animal/hostile/asteroid/hivelordbrood/Life()
	..()
	if(lifetime)
		lifetime--
	else death()

/mob/living/simple_animal/hostile/asteroid/hivelordbrood/death()
	qdel(src)



////////////////Hivelord core////////////////

/obj/item/asteroid/hivelord_core
	name = "creature remains"
	desc = "All that remains of creature, it seems to be what allows it to break pieces of itself off without being hurt... its healing properties will soon become inert if not used quickly."
	icon = 'icons/obj/food.dmi'
	icon_state = "boiledrorocore"
	var/inert = 0

/obj/item/asteroid/hivelord_core/New()
	. = ..()
	addtimer(CALLBACK(src, .proc/make_inert), 1200)

/obj/item/asteroid/hivelord_core/proc/make_inert()
	inert = 1
	desc = "The remains of creature that have become useless, having been left alone too long after being harvested."

/obj/item/asteroid/hivelord_core/attack(mob/living/M, mob/living/user)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(inert)
			to_chat(user, "<span class='notice'>[src] have become inert, its healing properties are no more.</span>")
			return
		else
			if(H.stat == DEAD)
				to_chat(user, "<span class='notice'>[src] are useless on the dead.</span>")
				return
			if(H != user)
				H.visible_message("[user] forces [H] to apply [src]... they quickly regenerate all injuries!")
			else
				to_chat(user, "<span class='notice'>You start to smear [src] on yourself. It feels and smells disgusting, but you feel amazingly refreshed in mere moments.</span>")
			H.revive()
			qdel(src)
	..()

////////////////Hoverhead////////////////

/mob/living/simple_animal/hostile/asteroid/hivelord/hoverhead
	name = "hoverhead"
	desc = "Strange hovering humanoid with exaggerated head and degenerated limbs. His gigantic head constantly emits forcefield of unknown origins."
	icon = 'icons/mob/asteroid/psychekinetic.dmi'
	icon_state = "Psychekinetic"
	icon_living = "Psychekinetic"
	icon_aggro = "Psychekinetic_alert"
	icon_dead = "Psychekinetic_dead"

/mob/living/simple_animal/hostile/asteroid/hivelord/OpenFire(the_target)
	var/mob/living/simple_animal/hostile/asteroid/hivelordbrood/p_anomaly/A = new /mob/living/simple_animal/hostile/asteroid/hivelordbrood/p_anomaly(src.loc)
	A.GiveTarget(target_mob)
	A.friends = friends
	A.faction = faction
	return

////////////////Psychokinetic anomaly////////////////

/mob/living/simple_animal/hostile/asteroid/hivelordbrood/p_anomaly
	name = "psychokinetic anomaly"
	desc = "A strange space-time anomaly that boils and compresses all matter around it."
	icon = 'icons/mob/asteroid/psychekinetic.dmi'
	icon_state = "Psychekinetic_anomaly"
	icon_living = "Psychekinetic_anomaly"
	icon_aggro = "Psychekinetic_anomaly"
	icon_dead = "Psychekinetic_anomaly"
	damtype = BURN