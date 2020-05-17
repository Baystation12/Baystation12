
/mob/living/simple_animal/hostile/unsc
	name = "UNSC Ship Crew (NPC)"
	faction = "UNSC"
	health = 100
	maxHealth = 100
	icon = 'code/modules/halo/unsc/simple_mobs.dmi'
	combat_tier = 1
	possible_weapons = list(/obj/item/weapon/gun/projectile/m6d_magnum)

/mob/living/simple_animal/hostile/unsc/marine
	name = "UNSC Marine (NPC)"
	icon_state = "marine"
	icon_living  = "marine"
	icon_dead = "dead_marine"
	resistance = 5
	combat_tier = 2
	possible_weapons = list(/obj/item/weapon/gun/projectile/m7_smg,/obj/item/weapon/gun/projectile/ma5b_ar)

/mob/living/simple_animal/hostile/unsc/odst
	name = "ODST (NPC)"
	icon_state = "odst"
	icon_living  = "odst"
	icon_dead = "dead_odst"
	resistance = 10
	combat_tier = 3
	possible_weapons = list(/obj/item/weapon/gun/projectile/m7_smg, /obj/item/weapon/gun/projectile/br55, /obj/item/weapon/gun/projectile/m392_dmr)

/mob/living/simple_animal/hostile/builder_mob/unsc
	name = "UNSC Marine Combat Engineer"
	desc = "Looks like he forgot his weapon."
	icon = 'code/modules/halo/unsc/simple_mobs.dmi'
	icon_state = "marine"
	icon_living = "marine"
	icon_dead = "marine_dead"
	faction = "UNSC"

/mob/living/simple_animal/hostile/unsc/spartan_two
	name = "Spartan II (NPC)"
	icon = 'code/modules/halo/unsc/spartan_npc.dmi'
	icon_state = "mjolnir_mk4"
	icon_living  = "mjolnir_mk4"
	icon_dead = "mjolnir_mk4_dead"
	possible_weapons = list(
		/obj/item/weapon/gun/energy/charged/spartanlaser,\
		/obj/item/weapon/gun/projectile/shotgun/pump/m90_ts,\
		/obj/item/weapon/gun/projectile/m739_lmg)
	health = 150
	maxHealth = 150
	resistance = 15
	combat_tier = 4
	var/shield_left = 150
	var/shield_max = 150
	var/recharge_delay = 5 SECONDS
	var/recharge_rate = 30
	var/last_damage = 0
	var/recharging = 0

/mob/living/simple_animal/hostile/unsc/spartan_two/adjustBruteLoss(damage)
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

/mob/living/simple_animal/hostile/unsc/spartan_two/Life()
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

/mob/living/simple_animal/hostile/unsc/spartan_two/getRollDist()
	switch(GLOB.difficulty_level)
		if(DIFFICULTY_EASY)
			return 2
		if(DIFFICULTY_NORMAL)
			return 2
		if(DIFFICULTY_HEROIC)
			return 3
		if(DIFFICULTY_LEGENDARY)
			return 4

mob/living/simple_animal/hostile/unsc/spartan_two/getPerRollDelay()
	switch(GLOB.difficulty_level)
		if(DIFFICULTY_EASY)
			return 2
		if(DIFFICULTY_NORMAL)
			return 1
		if(DIFFICULTY_HEROIC)
			return 0
		if(DIFFICULTY_LEGENDARY)
			return -1

mob/living/simple_animal/hostile/unsc/spartan_two/apply_difficulty_setting()
	//apply difficulty
	switch(GLOB.difficulty_level)
		if(DIFFICULTY_HEROIC)
			if(shield_max)
				shield_max += 50
		if(DIFFICULTY_LEGENDARY)
			if(shield_max)
				shield_max += 100
				recharge_rate *= 2
