
/mob/living/simple_animal/npc/adjustBruteLoss(damage)
	..()
	if(damage)
		last_afraid = world.time

/mob/living/simple_animal/npc/adjustFireLoss(damage)
	..()
	if(damage)
		last_afraid = world.time

/mob/living/simple_animal/npc/adjustToxLoss(damage)
	..()
	if(damage)
		last_afraid = world.time

/mob/living/simple_animal/npc/adjustOxyLoss(damage)
	..()
	if(damage)
		last_afraid = world.time

/mob/living/simple_animal/npc/hit_with_weapon(obj/item/O, mob/living/user, var/effective_force, var/hit_zone)
	. = ..()

	for(var/i=0,i<5,i++)
		dir = get_dir(user,src)
		Move(get_step_away(src,user))
		sleep(1)