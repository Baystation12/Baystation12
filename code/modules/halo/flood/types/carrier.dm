
/mob/living/simple_animal/hostile/flood/carrier
	name = "Flood carrier"
	icon = 'code/modules/halo/flood/flood_carrier.dmi'
	icon_state = "anim"
	icon_living = "anim"
	icon_dead = ""
	//
	move_to_delay = 30
	health = 10
	maxHealth = 10
	melee_damage_lower = 5
	melee_damage_upper = 15
	break_stuff_probability = 10

/mob/living/simple_animal/hostile/flood/carrier/AttackingTarget()
	if(!Adjacent(target_mob))
		return

	health = 0

/mob/living/simple_animal/hostile/flood/carrier/Move()
	. = ..()
	if(health <= 0)
		death()
		return

/mob/living/simple_animal/hostile/flood/carrier/death(gibbed, deathmessage = "bursts!")
	to_chat(src,"<span class='danger'>You burst, propelling flood infestors in all directions!</span>")
	src.visible_message("<span class='danger'>[src] bursts, propelling flood infestors in all directions!</span>")
	playsound(src.loc, 'sound/weapons/heavysmash.ogg', 50, 0, 0)
	icon_state = "burst"

	var/turf/spawn_turf = src.loc
	spawn(0)
		var/sporesleft = rand(3,9)
		while(sporesleft > 0)
			var/mob/living/simple_animal/hostile/flood/infestor/S = new(spawn_turf)
			sporesleft -= 1
			walk_towards(S, pick(range(7, spawn_turf)), 0, 1)
			if(our_overmind)
				our_overmind.combat_troops.Add(S)
			spawn(30)
				if(S)
					walk(S, 0)

	spawn(3)
		qdel(src)
	return ..(0,deathmessage)
