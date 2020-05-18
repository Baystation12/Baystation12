
/mob/living/simple_animal/hostile/covenant/drone
	name = "Drone (NPC)"
	desc = "A flying insect like creature covered in hard chitin."
	icon = 'code/modules/halo/covenant/simple_mobs/yanmee.dmi'
	icon_state = "drone_flying"
	icon_dead = "drone_dead"
	attacktext = "swiped"
	emote_hear = list("chitters","buzzes")
	emote_see = list("flutters its wings")
	speak_chance = 1
	combat_tier = 1
	speed = 5

/mob/living/simple_animal/hostile/covenant/drone/ranged
	possible_weapons = list(/obj/item/weapon/gun/energy/plasmapistol/npc, /obj/item/weapon/gun/projectile/needler/npc)
