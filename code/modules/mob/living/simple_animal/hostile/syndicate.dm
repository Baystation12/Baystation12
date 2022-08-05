/mob/living/simple_animal/hostile/syndicate
	name = "\improper Syndicate operative"
	desc = "Death to the Company."
	icon_state = "syndicate"
	icon_living = "syndicate"
	icon_dead = "syndicate_dead"
	icon_gib = "syndicate_gib"
	turns_per_move = 5
	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"
	speed = 4
	maxHealth = 100
	health = 100
	harm_intent_damage = 5
	natural_weapon = /obj/item/natural_weapon/punch
	can_escape = TRUE
	a_intent = I_HURT
	var/corpse = /obj/effect/landmark/corpse/syndicate
	var/weapon1
	var/weapon2
	unsuitable_atmos_damage = 15
	environment_smash = 1
	faction = "syndicate"
	status_flags = CANPUSH

/mob/living/simple_animal/hostile/syndicate/death(gibbed, deathmessage, show_dead_message)
	..(gibbed, deathmessage, show_dead_message)
	if(corpse)
		new corpse (src.loc)
	if(weapon1)
		new weapon1 (src.loc)
	if(weapon2)
		new weapon2 (src.loc)
	qdel(src)
	return

///////////////Sword and shield////////////

/mob/living/simple_animal/hostile/syndicate/melee
	icon_state = "syndicatemelee"
	icon_living = "syndicatemelee"
	natural_weapon = /obj/item/melee/energy/sword/red/activated
	weapon1 = /obj/item/melee/energy/sword/red/activated
	weapon2 = /obj/item/shield/energy
	status_flags = 0

/mob/living/simple_animal/hostile/syndicate/melee/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(O.force)
		if(prob(80))
			var/damage = O.force
			if (O.damtype == DAMAGE_PAIN)
				damage = 0
			health -= damage
			visible_message("<span class='danger'>\The [src] has been attacked with \the [O] by \the [user].</span>")
		else
			visible_message("<span class='danger'>\The [src] blocks the [O] with its shield!</span>")
		//user.do_attack_animation(src)
	else
		to_chat(usr, "<span class='warning'>This weapon is ineffective, it does no damage.</span>")
		visible_message("<span class='warning'>\The [user] gently taps \the [src] with \the [O].</span>")


/mob/living/simple_animal/hostile/syndicate/melee/bullet_act(var/obj/item/projectile/Proj)
	if(!Proj)	return
	if (status_flags & GODMODE)
		return PROJECTILE_FORCE_MISS
	if(prob(65))
		src.health -= Proj.damage
	else
		visible_message("<span class='danger'>\The [src] blocks \the [Proj] with its shield!</span>")
	return 0


/mob/living/simple_animal/hostile/syndicate/melee/space
	min_gas = null
	max_gas = null
	minbodytemp = 0
	icon_state = "syndicatemeleespace"
	icon_living = "syndicatemeleespace"
	name = "Syndicate Commando"
	corpse = /obj/effect/landmark/corpse/syndicate
	speed = 0

/mob/living/simple_animal/hostile/syndicate/ranged
	ranged = 1
	rapid = 1
	icon_state = "syndicateranged"
	icon_living = "syndicateranged"
	casingtype = /obj/item/ammo_casing/pistol
	projectilesound = 'sound/weapons/gunshot/gunshot_smg.ogg'
	projectiletype = /obj/item/projectile/bullet/pistol

	weapon1 = /obj/item/gun/projectile/automatic/merc_smg

/mob/living/simple_animal/hostile/syndicate/ranged/space
	icon_state = "syndicaterangedpsace"
	icon_living = "syndicaterangedpsace"
	name = "Syndicate Commando"
	min_gas = null
	max_gas = null
	minbodytemp = 0
	corpse = /obj/effect/landmark/corpse/syndicate/commando
	speed = 0

/mob/living/simple_animal/hostile/viscerator
	name = "viscerator"
	desc = "A small, twin-bladed machine capable of inflicting very deadly lacerations."
	icon = 'icons/mob/simple_animal/critter.dmi'
	icon_state = "viscerator_attack"
	icon_living = "viscerator_attack"
	pass_flags = PASS_FLAG_TABLE
	health = 15
	maxHealth = 15
	natural_weapon = /obj/item/natural_weapon/rotating_blade
	faction = "syndicate"
	min_gas = null
	max_gas = null
	minbodytemp = 0

	meat_type =     null
	meat_amount =   0
	bone_material = null
	bone_amount =   0
	skin_material = null
	skin_amount =   0
/obj/item/natural_weapon/rotating_blade
	name = "rotating blades"
	attack_verb = list("sliced", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	force = 15
	edge = 1
	sharp = 1

/mob/living/simple_animal/hostile/viscerator/death(gibbed, deathmessage, show_dead_message)
	..(null,"is smashed into pieces!", show_dead_message)
	qdel(src)

/mob/living/simple_animal/hostile/viscerator/hive
	faction = "hivebot"
