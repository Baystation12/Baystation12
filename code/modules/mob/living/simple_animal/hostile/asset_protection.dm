/mob/living/simple_animal/hostile/asset_protection
	name = "\improper Asset Protection Operator"
	desc = "He doesn't look too friendly."
	icon_state = "asset_protection"
	icon_living = "asset_protection"
	speak_chance = 0
	turns_per_move = 5
	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"
	speed = 0
	stop_automated_movement_when_pulled = 0
	maxHealth = 200
	health = 200
	harm_intent_damage = 5
	melee_damage_lower = 10
	melee_damage_upper = 10
	attacktext = "punched"
	a_intent = I_HURT
	var/corpse = /obj/effect/landmark/mobcorpse/assetprotection
	var/weapon1
	var/weapon2
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	unsuitable_atoms_damage = 15
	environment_smash = 1
	faction = "asset_protection"
	status_flags = CANPUSH

/mob/living/simple_animal/hostile/asset_protection/death()
	..()
	if(corpse)
		new corpse (src.loc)
	if(weapon1)
		new weapon1 (src.loc)
	if(weapon2)
		new weapon2 (src.loc)
	qdel(src)
	return

/mob/living/simple_animal/hostile/asset_protection/Process_Spacemove(var/check_drift = 0)
	return

///////////////Sword and shield////////////

/mob/living/simple_animal/hostile/asset_protection/melee
	melee_damage_lower = 20
	melee_damage_upper = 25
	icon_state = "assetprotectionmelee"
	icon_living = "assetprotectionmelee"
	weapon1 = /obj/item/weapon/melee/energy/sword/blue
	weapon2 = /obj/item/weapon/shield/energy
	attacktext = "slashed"
	status_flags = 0

/mob/living/simple_animal/hostile/asset_protection/melee/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(O.force)
		if(prob(80))
			var/damage = O.force
			if (O.damtype == HALLOSS)
				damage = 0
			health -= damage
			visible_message("<span class='danger'> [src] has been attacked with the [O] by [user]. ")
		else
			visible_message("<span class='danger'> [src] blocks the [O] with his shield! ")
	else
		usr << "<span class='warning'> This weapon is ineffective, it does no damage."
		visible_message("<span class='danger'> [user] gently taps [src] with the [O]. ")


/mob/living/simple_animal/hostile/asset_protection/melee/bullet_act(var/obj/item/projectile/Proj)
	if(!Proj)	return
	if(prob(65))
		src.health -= Proj.damage
	else
		visible_message("<span class='danger'> [src] blocks [Proj] with his shield!")
	return 0

///////////////Pulse rifle////////////

/mob/living/simple_animal/hostile/asset_protection/ranged
	ranged = 1
	rapid = 1
	icon_state = "assetprotectionranged"
	icon_living = "assetprotectionranged"
	projectilesound = 'sound/weapons/pulse.ogg'
	projectiletype = /obj/item/projectile/beam/pulse

	weapon1 = /obj/item/weapon/gun/energy/pulse_rifle