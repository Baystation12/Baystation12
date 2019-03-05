
/obj/item/energybarricade
	name = "energy barricade (packed)"
	desc = "A shimmering curved shield for Covenant footsoldiers to take cover behind. This one is deactivated for transport."
	icon = 'energybarricade.dmi'
	icon_state = "item"

/obj/item/energybarricade/attack_self(var/mob/user)
	if(user)
		var/turf/T = get_turf(user)
		var/obj/structure/energybarricade/E = locate() in T
		if(E)
			user.visible_message("<span class='notice'>There is already [E] there!</span>")
		else
			user.visible_message("<span class='info'>[user] begins setting up [src].</span>")
			if(do_after(user, 30, src.loc))
				user.visible_message("<span class='info'>[user] finishes setting up [src].</span>")
				user.drop_item()
				T = get_turf(user)
				E = new(T, newdir = user.dir)
				qdel(src)




/obj/structure/energybarricade
	name = "energy barricade"
	desc = "A shimmering curved shield for Covenant footsoldiers to take cover behind."
	icon = 'energybarricade.dmi'
	icon_state = "3"
	anchored = 1
	var/shield_health = 0
	var/max_shield = 750
	var/recharge_time = 50
	var/time_recharged = 50
	var/can_deconstruct = 1
	var/processing = 0
	var/recharge_per_tick = 34

/obj/structure/energybarricade/New(var/newdir)
	dir = newdir
	. = ..()
	if(src.dir == NORTH)
		src.plane = OBJ_PLANE
	else
		src.plane = ABOVE_HUMAN_PLANE
	icon_state = "0"
	processing = 1
	GLOB.processing_objects.Add(src)

/obj/structure/energybarricade/process()
	if(world.time >= time_recharged)
		//come back to full after being dropped
		if(shield_health <= 0)
			shield_health = max_shield
			update_icon()
			processing = 0
			GLOB.processing_objects.Remove(src)

		//recharge a little
		else if(shield_health < max_shield)
			shield_health += recharge_per_tick
			update_icon()

		//we are done recharging
		if(shield_health >= max_shield)
			shield_health = max_shield
			processing = 0
			GLOB.processing_objects.Remove(src)

/obj/structure/energybarricade/CanPass(atom/A, turf/T)
	. = ..()

	//block movement from some directions if we are active
	if(shield_health > 0 && A && T)
		var/turf/front_turf = get_step(src, dir)

		//movement in front of the shield
		if(front_turf == T)
			to_chat(A,"<span class='warning'>[src] blocks your way.</span>")
			return 0

/obj/structure/energybarricade/CheckExit(atom/movable/O as mob|obj, target as turf)
	if(get_dir(O.loc, target) == dir)
		to_chat(O,"<span class='warning'>[src] blocks your way.</span>")
		return 0
	return ..()

/obj/structure/energybarricade/attack_hand(var/mob/user)
	//deconstruct the shield if we are behind it
	if(can_deconstruct)
		if(user.loc == src.loc)
			user.visible_message("<span class='info'>[user] begins deactivating [src] and begin packing it for transport.</span>")

			//spend some time breaking down the shield
			if(do_after(user, recharge_time, src))
				GLOB.processing_objects.Remove(src)
				new /obj/item/energybarricade(src.loc)
				qdel(src)
				user.visible_message("<span class='info'>[user] finishes deactivating [src] and packs it for transport.</span>")
		else
			to_chat(user,"<span class='info'>You must be behind [src] to do this.</span>")
	else
		to_chat(user,"<span class='info'>This one has been permanently secured and cannot be deactivated.</span>")

/obj/structure/energybarricade/bullet_act(obj/item/projectile/P, def_zone)
	. = ..()
	take_damage(P.damage)

/obj/structure/energybarricade/attackby(var/obj/item/I, var/mob/living/user)
	. =  ..()
	take_damage(I.force)

/obj/structure/energybarricade/proc/take_damage(var/damage)
	if(damage > 0)
		shield_health -= damage
		time_recharged = world.time + recharge_time
		update_icon()

		if(shield_health < 0)
			shield_health = 0

			//longer time to come back up
			time_recharged += recharge_time * 2

		if(!processing)
			processing = 1
			GLOB.processing_objects.Add(src)

/obj/structure/energybarricade/update_icon()
	var/shield_ratio = shield_health/max_shield
	if(shield_ratio > 0.66)
		icon_state = "3"
	else if(shield_ratio > 0.33)
		icon_state = "2"
	else if(shield_ratio > 0)
		icon_state = "1"
	else
		icon_state = "0"
