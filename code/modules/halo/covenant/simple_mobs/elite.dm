
/mob/living/simple_animal/hostile/covenant/elite
	name = "Elite Minor (NPC)"
	icon = 'code/modules/halo/covenant/simple_mobs/simple_mobs48.dmi'
	health = 150
	maxHealth = 150
	combat_tier = 3
	resistance = 10
	icon_state = "minor"
	icon_living = "minor"
	icon_dead = "dead_minor"
	possible_weapons = list(/obj/item/weapon/gun/energy/plasmarifle)
	var/shield_left = 50
	var/shield_max = 50
	var/recharge_delay = 5 SECONDS
	var/recharge_rate = 10
	var/last_damage = 0
	var/recharging = 0

/mob/living/simple_animal/hostile/covenant/elite/major
	name = "Elite Major (NPC)"
	icon_state = "major"
	icon_living = "major"
	icon_dead = "dead_major"
	shield_left = 100
	shield_max = 100
	recharge_rate = 20
	combat_tier = 4
	possible_weapons = list(/obj/item/weapon/gun/energy/plasmarepeater)

/mob/living/simple_animal/hostile/covenant/elite/adjustBruteLoss(damage)
	last_damage = world.time
	if(recharging)
		overlays -= "shield_recharge"
		recharging = 0

	//take damage from shield first
	if(shield_left > 0)
		overlays |= "shield_flicker"
		var/shield_absorbed = min(shield_left, damage)
		shield_left -= shield_absorbed
		damage -= shield_absorbed

	. = ..(damage)

/mob/living/simple_animal/hostile/covenant/elite/Life()
	. = ..()

	//dont need to display damage any more
	overlays -= "shield_flicker"

	if(stat == DEAD)
		overlays -= "shield_recharge"
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
