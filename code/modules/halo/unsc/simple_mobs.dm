
/mob/living/simple_animal/hostile/unsc
	name = "UNSC Ship Crew (NPC)"
	faction = "UNSC"
	health = 100
	maxHealth = 100
	icon = 'code/modules/halo/unsc/simple_mobs.dmi'
	combat_tier = 1
	possible_weapons = list(/obj/item/weapon/gun/projectile/m6d_magnum)

/mob/living/simple_animal/hostile/unsc/marine
	name = "UNSC Defender (Marine)"
	icon_state = "marine"
	icon_living  = "marine"
	icon_dead = "dead_marine"
	resistance = 5
	combat_tier = 2
	possible_weapons = list(/obj/item/weapon/gun/projectile/m7_smg,/obj/item/weapon/gun/projectile/ma5b_ar)

/mob/living/simple_animal/hostile/unsc/odst
	name = "UNSC Defender (ODST)"
	icon_state = "odst"
	icon_living  = "odst"
	icon_dead = "dead_odst"
	resistance = 5
	combat_tier = 2
	possible_weapons = list(/obj/item/weapon/gun/projectile/m7_smg, /obj/item/weapon/gun/projectile/br55, /obj/item/weapon/gun/projectile/m392_dmr)

/mob/living/simple_animal/hostile/builder_mob/unsc
	name = "UNSC Marine Combat Engineer"
	desc = "Looks like he forgot his weapon."
	icon = 'code/modules/halo/unsc/simple_mobs.dmi'
	icon_state = "marine"
	icon_living = "marine"
	icon_dead = "marine_dead"
	faction = "UNSC"
