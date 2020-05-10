
/mob/living/simple_animal/hostile/covenant/grunt
	name = "Grunt (NPC)"
	icon_state = "grunt"
	icon_living = "grunt"
	icon_dead = "dead_grunt"
	possible_weapons = list(/obj/item/weapon/gun/energy/plasmapistol, /obj/item/weapon/gun/projectile/needler)
	combat_tier = 1

/mob/living/simple_animal/hostile/builder_mob/cov
	name = "Unggoy Construction Worker"
	desc = "Tasked with constructing instead of fighting, they have not been provided with a weapon."
	icon = 'code/modules/halo/covenant/simple_mobs/simple_mobs.dmi'
	icon_state = "grunt"
	icon_living = "grunt"
	icon_dead = "grunt_dead"
	faction = "Covenant"
