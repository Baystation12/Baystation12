/mob/living/simple_animal/hostile/covenant/elite/adjustBruteLoss(damage)
	last_damage = world.time
	if(recharging)
		overlays -= "shield_recharge"
		recharging = 0

	//take damage from shield first
	if(shield_left > 0)
		if(!flickering)
			overlays |= "shield_flicker"
			flickering = 1
		var/shield_absorbed = min(shield_left, damage)
		shield_left -= shield_absorbed
		damage -= shield_absorbed
	. = ..(damage)

/mob/living/simple_animal/hostile/covenant/elite/Life()
	. = ..()

	//dont need to display damage any more
	if(flickering)
		overlays -= "shield_flicker"
		flickering = 0

	if(stat == DEAD)
		overlays.Cut() // Gets rid of all overlays to make visiblity over dead enemies easier.
	else
		//are we currently recharging?
		if(recharging)
			shield_left += recharge_rate

			//have we just finished recharging?
			if(shield_left >= shield_max)
				shield_left = shield_max
				overlays -= "shield_recharge"
				recharging = 0

		//should we start recharging?
		else if(world.time >= last_damage + recharge_delay && shield_left < shield_max)
			recharging = 1
			overlays |= "shield_recharge"
