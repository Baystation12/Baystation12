//An AI-controlled 'companion' for the Technomancer.  It's tough, strong, and can also use spells.
/mob/living/simple_animal/hostile/technomancer_golem
	name = "G.O.L.E.M."
	desc = "A rather unusual looking synthetic."
	icon = 'icons/mob/robots.dmi'
	icon_state = "Security"
	health = 250
	maxHealth = 250
	stop_automated_movement = 1
	wander = 0
	response_help   = "pets"
	response_disarm = "pushes away"
	response_harm   = "punches"
	harm_intent_damage = 3

	heat_damage_per_tick = 0
	cold_damage_per_tick = 0

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	unsuitable_atoms_damage = 0
	speed = 0

	melee_damage_lower = 10
	melee_damage_upper = 10
	attacktext = "pummeled"
	attack_sound = null
	friendly = "hugs"
	resistance = 0

	var/obj/item/weapon/technomancer_core/core = null
	var/obj/item/weapon/spell/active_spell = null
	var/mob/living/master = null

/mob/living/simple_animal/hostile/technomancer_golem/New()
	..()
	core = new core(src)

/mob/living/simple_animal/hostile/technomancer_golem/Destroy()
	qdel_null(core)
	master = null
	return ..()

/mob/living/simple_animal/hostile/technomancer_golem/proc/bind_to_mob(mob/user)
	if(!user || master)
		return
	master = user
	name = "[master]'s [initial(name)]"

/mob/living/simple_animal/hostile/technomancer_golem/examine(mob/user)
	..()
	if(user.mind && technomancers.is_antagonist(user.mind))
		to_chat(user,"Your pride and joy.  It's a very special synthetic robot, capable of using functions similar to you, and you built it \
		yourself!  It'll always stand by your side, ready to help you out.  You have no idea what GOLEM stands for, however...")

/mob/living/simple_animal/hostile/technomancer_golem/Life()
	handle_ai()

/mob/living/simple_animal/hostile/technomancer_golem/proc/handle_ai()
	if(!master)
		return
	if(get_dist(src, master) > 6 || src.z != master.z)
		recall_to_master()


/mob/living/simple_animal/hostile/technomancer_golem/proc/recall_to_master()
	return