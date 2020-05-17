
/mob/living/simple_animal/hostile/builder_mob/cov
	name = "Unggoy Construction Worker"
	desc = "Tasked with constructing instead of fighting, they have not been provided with a weapon."
	icon = 'code/modules/halo/covenant/simple_mobs/simple_mobs.dmi'
	icon_state = "grunt"
	icon_living = "grunt"
	icon_dead = "grunt_dead"
	faction = "Covenant"

/mob/living/simple_animal/hostile/covenant/grunt
	name = "Grunt (NPC)"
	icon_state = "grunt_minor"
	icon_living = "grunt_minor"
	icon_dead = "grunt_minor_dead"
	possible_weapons = list(/obj/item/weapon/gun/energy/plasmapistol, /obj/item/weapon/gun/projectile/needler)
	combat_tier = 1

/mob/living/simple_animal/hostile/covenant/grunt/major
	name = "Grunt Major (NPC)"
	icon_state = "grunt_major"
	icon_living = "grunt_major"
	icon_dead = "grunt_major_dead"
	combat_tier = 2
	resistance = 5

/mob/living/simple_animal/hostile/covenant/grunt/heavy
	name = "Grunt Heavy (NPC)"
	icon_state = "grunt_heavy"
	icon_living = "grunt_heavy"
	icon_dead = "grunt_heavy_dead"
	combat_tier = 3
	resistance = 5
	possible_weapons = list(/obj/item/weapon/gun/projectile/fuel_rod)

/mob/living/simple_animal/hostile/covenant/grunt/ultra
	name = "Grunt Ultra (NPC)"
	icon_state = "grunt_ultra"
	icon_living = "grunt_ultra"
	icon_dead = "grunt_ultra_dead"
	combat_tier = 3
	resistance = 10
	var/shield_left = 50
	var/shield_max = 50
	var/recharge_delay = 5 SECONDS
	var/recharge_rate = 10
	var/last_damage = 0
	var/recharging = 0

/mob/living/simple_animal/hostile/covenant/grunt/ultra/adjustBruteLoss(damage)
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

/mob/living/simple_animal/hostile/covenant/grunt/ultra/Life()
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
