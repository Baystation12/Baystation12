
/mob/living/simple_animal/hostile/covenant/grunt
	var/shield_left = 0
	var/shield_max = 0
	var/recharge_delay = 5 SECONDS
	var/recharge_rate = 10
	var/last_damage = 0
	var/recharging = 0

/mob/living/simple_animal/hostile/covenant/grunt/adjustBruteLoss(damage)
	last_damage = world.time
	if(recharging)
		overlays -= "shield_overlay_recharge"
		recharging = 0

	//take damage from shield first
	if(shield_left > 0)
		overlays |= "shield_overlay_damage"
		var/shield_absorbed = min(shield_left, damage)
		shield_left -= shield_absorbed
		damage -= shield_absorbed

	. = ..(damage)

/mob/living/simple_animal/hostile/covenant/grunt/Life()
	. = ..()

	//dont need to display damage any more
	overlays -= "shield_overlay_damage"

	if(stat == DEAD)
		overlays -= "shield_overlay_recharge"
	else
		//are we currently recharging?
		if(recharging)
			shield_left += recharge_rate

			//have we just finished recharging?
			if(shield_left >= shield_max)
				shield_left = shield_max
				overlays -= "shield_overlay_recharge"
				recharging = 0

		//should we start recharging?
		else if(world.time >= last_damage + recharge_delay && shield_left < shield_max)
			recharging = 1
			overlays |= "shield_overlay_recharge"
