
/mob/living/simple_animal/hostile/covenant/jackal/shield/New()
	. = ..()
	overlays += shield_state

/mob/living/simple_animal/hostile/covenant/jackal/shield/bullet_act(var/obj/item/projectile/P, var/def_zone)

	//does the shield block the bullet?
	if(blocked_dir(P.starting) && absorb_damage(P.damage, P.name))
		//dirty hack to stop the attack log message going through
		P.silenced = 1
		return

	//process the bullet normally
	. = ..()

/mob/living/simple_animal/hostile/covenant/jackal/shield/hit_with_weapon(obj/item/O, mob/living/user, var/effective_force, var/hit_zone)

	if(blocked_dir(get_turf(O)) && absorb_damage(O.force, O.name))
		return 1

	. = ..()

/mob/living/simple_animal/hostile/covenant/jackal/shield/proc/blocked_dir(var/turf/source_turf)
	if(!source_turf)
		return 0

	var/need_dir = get_dir(src.loc, source_turf)
	var/list/block_dirs = list(src.dir, turn(src.dir, 45), turn(src.dir, -45))

	//is it in a 90 degree cone in front of us?
	if(need_dir in block_dirs)
		return 1

	return 0

/mob/living/simple_animal/hostile/covenant/jackal/shield/proc/absorb_damage(var/damage, var/source)
	//have we got shield left?
	if(shield_left > 0)
		//reset the recharge timer
		last_damage = world.time
		recharging = 0

		//take the damage on our shield
		shield_left -= damage

		//did the shield run out?
		if(shield_left < 0)
			shield_left = 0
			overlays -= shield_state
			shield_state = null
			src.visible_message("<span class='danger'>[src]'s shield collapses from damage!</span>")

		else
			src.visible_message("<span class='notice'>[src]'s shield absorbs the [source].</span>")
			if(shield_left < shield_max * damage_state_multiplier)
				//visually show our shield is damaged
				overlays -= shield_state
				shield_state = "shield_low"
				overlays += shield_state

		return 1

	//the bullet wasnt blocked
	return 0

/mob/living/simple_animal/hostile/covenant/jackal/shield/Life()
	. = ..()

	if(stat == DEAD)
		overlays -= shield_state
	else
		//are we currently recharging?
		if(recharging)
			shield_left += recharge_rate

			//our shield has recharged
			if(!shield_state)
				shield_state = "shield_damage"
				overlays += shield_state

			//back to normal shield graphic
			else if(shield_state == "shield_damage" && shield_left > shield_max * damage_state_multiplier)
				overlays -= shield_state
				shield_state = "shield"
				overlays += shield_state

			//have we just finished recharging?
			if(shield_left >= shield_max)
				shield_left = shield_max
				recharging = 0

		//should we start recharging?
		else if(world.time >= last_damage + recharge_delay && shield_left < shield_max)
			recharging = 1
