
/mob/living/simple_animal/hostile/covenant
	faction = "Covenant"
	health = 100
	maxHealth = 100
	melee_damage_lower = 10
	melee_damage_upper = 15
	break_stuff_probability = 50
	assault_target_type = /obj/effect/landmark/assault_target/covenant
	icon = 'code/modules/halo/covenant/simple_mobs/simple_mobs.dmi'
	var/obj/item/device/flashlight/held_light

/mob/living/simple_animal/hostile/covenant/New()
	. = ..()
	if(see_in_dark < 5)
		/*
		var/light_type = pick(\
			/obj/item/device/flashlight/glowstick/purple,\
			/obj/item/device/flashlight/glowstick/cyan,\
			/obj/item/device/flashlight/glowstick/blue)
			*/
		held_light = new /obj/item/device/flashlight(src)
		held_light.on = 1
		held_light.update_icon()

/mob/living/simple_animal/hostile/covenant/death(gibbed, deathmessage = "dies!", show_dead_message = 1)
	. = ..()
	if(held_light)
		held_light.on = 0
		held_light.update_icon()
