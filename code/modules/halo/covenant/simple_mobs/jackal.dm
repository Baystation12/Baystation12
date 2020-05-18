
/mob/living/simple_animal/hostile/covenant/jackal
	name = "Jackal (NPC)"
	icon_state = "kigyar"
	icon_living = "kigyar"
	icon_dead = "dead_kigyar"
	combat_tier = 2
	possible_weapons = list(/obj/item/weapon/gun/projectile/type51carbine, /obj/item/weapon/gun/projectile/type31needlerifle)
	see_in_dark = 7
	species_name = "Kig-Yar"

/mob/living/simple_animal/hostile/covenant/jackal/shield
	possible_weapons = list(/obj/item/weapon/gun/energy/plasmapistol/npc, /obj/item/weapon/gun/projectile/needler/npc)
	var/shield_max = 400
	var/shield_left = 400
	var/recharge_delay = 5 SECONDS
	var/recharge_rate = 75
	var/last_damage = 0
	var/recharging = 0
	var/shield_state = "shield"
	var/damage_state_multiplier = 0.5
	see_in_dark = 2

/mob/living/simple_animal/hostile/covenant/jackal/sniper
	possible_weapons = list(/obj/item/weapon/gun/energy/beam_rifle)
	combat_tier = 3
	see_in_dark = 7
