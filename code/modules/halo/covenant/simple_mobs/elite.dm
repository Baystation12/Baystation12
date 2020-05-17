
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

/mob/living/simple_animal/hostile/covenant/elite/ultra
	name = "Elite Ultra (NPC)"
	icon_state = "ultra"
	icon_living = "ultra"
	icon_dead = "dead_ultra"
	shield_left = 150
	shield_max = 150
	recharge_rate = 25
	combat_tier = 5
	possible_weapons = list(/obj/item/weapon/gun/projectile/type31needlerifle,/obj/item/weapon/gun/projectile/type51carbine)

/mob/living/simple_animal/hostile/covenant/elite/zealot
	name = "Elite Zealot (NPC)"
	icon_state = "zealot"
	icon_living = "zealot"
	icon_dead = "dead_zealot"
	shield_left = 150
	shield_max = 150
	recharge_rate = 25
	combat_tier = 6
	melee_damage_lower = 45
	melee_damage_upper = 55
	possible_weapons = list()
	damtype = BURN

/mob/living/simple_animal/hostile/covenant/elite/zealot/New()
	. = ..()
	playsound(get_turf(src), 'code/modules/halo/sounds/Energysworddeploy.ogg', 100, 0, 0)

/mob/living/simple_animal/hostile/covenant/elite/zealot/do_attack_animation(var/target)
	. = ..()
	playsound(get_turf(src), 'code/modules/halo/sounds/Energyswordhit.ogg', 100, 0, 0)
