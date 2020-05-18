
/mob/living/simple_animal/hostile/builder_mob/cov
	name = "Unggoy Construction Worker"
	desc = "Tasked with constructing instead of fighting, they have not been provided with a weapon."
	icon = 'code/modules/halo/covenant/simple_mobs/simple_mobs.dmi'
	icon_state = "grunt"
	icon_living = "grunt"
	icon_dead = "grunt_dead"
	faction = "Covenant"

/obj/item/weapon/gun/energy/plasmapistol/npc
	burst = 2

/obj/item/weapon/gun/projectile/needler/npc
	burst = 2

/mob/living/simple_animal/hostile/covenant/grunt
	name = "Grunt (NPC)"
	icon_state = "grunt_minor"
	icon_living = "grunt_minor"
	icon_dead = "grunt_minor_dead"
	possible_weapons = list(/obj/item/weapon/gun/energy/plasmapistol/npc, /obj/item/weapon/gun/projectile/needler/npc)
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
	shield_left = 50
	shield_max = 50
