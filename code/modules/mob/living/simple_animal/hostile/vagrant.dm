
/mob/living/simple_animal/hostile/vagrant
	name = "creature"
	desc = "You get the feeling you should run."
	icon = 'icons/mob/mob.dmi'
	icon_state = "vagrant"
	icon_living = "vagrant"
	icon_dead = "vagrant"
	icon_gib = "vagrant"
	maxHealth = 60
	health = 20
	speed = 5
	speak_chance = 0
	turns_per_move = 4
	move_to_delay = 4
	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"
	break_stuff_probability = 0
	faction = "vagrant"
	harm_intent_damage = 3
	melee_damage_lower = 3
	melee_damage_upper = 4
	light_color = "#8a0707"
	attacktext = "mauled"
	attack_sound = 'sound/weapons/bite.ogg'
	min_gas = null
	max_gas = null
	minbodytemp = 0
	var/cloaked = 0
	var/mob/living/carbon/human/gripping = null
	var/blood_per_tick = 3
	var/health_per_tick = 0.8
	pass_flags = PASS_FLAG_TABLE

	bleed_colour = "#aad9de"

/mob/living/simple_animal/hostile/vagrant/Allow_Spacemove(var/check_drift = 0)
	return 1

/mob/living/simple_animal/hostile/vagrant/bullet_act(var/obj/item/projectile/Proj)
	var/oldhealth = health
	. = ..()
	if((target_mob != Proj.firer) && health < oldhealth && !incapacitated(INCAPACITATION_KNOCKOUT)) //Respond to being shot at
		target_mob = Proj.firer
		turns_per_move = 3
		MoveToTarget()

/mob/living/simple_animal/hostile/vagrant/death(gibbed)
	. = ..()
	if(. && !gibbed)
		gib()

/mob/living/simple_animal/hostile/vagrant/Life()
	. = ..()
	if(!.)
		return FALSE
	if(gripping)
		if(!(get_turf(src) == get_turf(gripping)))
			gripping = null

		else if(gripping.should_have_organ(BP_HEART))
			var/blood_volume = round(gripping.vessel.get_reagent_amount(/datum/reagent/blood))
			if(blood_volume > 5)
				gripping.vessel.remove_reagent(/datum/reagent/blood, blood_per_tick)
				health = min(health + health_per_tick, maxHealth)
				if(prob(15))
					to_chat(gripping, "<span class='danger'>You feel your fluids being drained!</span>")
			else
				gripping = null

		if(turns_per_move != initial(turns_per_move))
			turns_per_move = initial(turns_per_move)

	if(stance == HOSTILE_STANCE_IDLE && !cloaked)
		cloaked = 1
		update_icon()
	if(health == maxHealth)
		new/mob/living/simple_animal/hostile/vagrant(src.loc)
		new/mob/living/simple_animal/hostile/vagrant(src.loc)
		gib()
		return

/mob/living/simple_animal/hostile/vagrant/on_update_icon()
	if(cloaked) //It's fun time
		alpha = 75
		set_light(0)
		icon_state = initial(icon_state)
		move_to_delay = initial(move_to_delay)
	else //It's fight time
		alpha = 255
		icon_state = "vagrant_glowing"
		set_light(0.2, 0.1, 3)
		move_to_delay = 2

/mob/living/simple_animal/hostile/vagrant/AttackingTarget()
	. = ..()
	if(ishuman(.))
		var/mob/living/carbon/human/H = .
		if(gripping == H)
			H.Weaken(1)
			H.Stun(1)
			return
		//This line ensures there's always a reasonable chance of grabbing, while still
		//Factoring in health
		if(!gripping && (cloaked || prob(health + ((maxHealth - health) * 2))))
			gripping = H
			cloaked = 0
			update_icon()
			H.Weaken(1)
			H.Stun(1)
			H.visible_message("<span class='danger'>\the [src] latches onto \the [H], pulsating!</span>")
			src.forceMove(gripping.loc)

/mob/living/simple_animal/hostile/vagrant/swarm/Initialize()
	. = ..()
	if(prob(75)) new/mob/living/simple_animal/hostile/vagrant(loc)
	if(prob(50)) new/mob/living/simple_animal/hostile/vagrant(loc)
