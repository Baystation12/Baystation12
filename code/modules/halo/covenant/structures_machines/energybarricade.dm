
/obj/item/energybarricade
	name = "energy barricade (packed)"
	desc = "A shimmering curved shield for Covenant footsoldiers to take cover behind. This one is deactivated for transport."
	icon = 'energybarricade.dmi'
	icon_state = "barricade"
	var/shield_type = /obj/structure/energybarricade

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
				E = new shield_type(T, newdir = user.dir)
				qdel(src)




/obj/structure/energybarricade
	name = "energy barricade"
	desc = "A shimmering curved shield for Covenant footsoldiers to take cover behind."
	icon = 'energybarricade.dmi'
	icon_state = "3"
	var/fail_state = "0"
	anchored = 1
	var/shield_health = 0
	var/max_shield = 300
	var/recharge_time = 50
	var/time_recharged = 50
	var/can_deconstruct = 1
	var/processing = 0
	var/recharge_per_tick = 30
	var/blocks_air = 0
	var/blocks_mobs = 1
	var/item_type = /obj/item/energybarricade
	var/list/climbing = list()

/obj/structure/energybarricade/New(var/newdir)
	dir = newdir
	. = ..()
	if(src.dir == NORTH)
		src.plane = OBJ_PLANE
	else
		src.plane = ABOVE_HUMAN_PLANE
	icon_state = fail_state
	processing = 1
	GLOB.processing_objects.Add(src)

	if(blocks_air)
		update_nearby_tiles(1)

/obj/structure/energybarricade/process()
	if(world.time >= time_recharged)
		//come back to full after being dropped
		if(shield_health <= 0)
			shield_health = max_shield
			update_icon()
			processing = 0
			GLOB.processing_objects.Remove(src)

			if(blocks_air)
				update_nearby_tiles()

		//recharge a little
		else if(shield_health < max_shield)
			shield_health += recharge_per_tick
			update_icon()

		//we are done recharging
		if(shield_health >= max_shield)
			shield_health = max_shield
			processing = 0
			GLOB.processing_objects.Remove(src)

/obj/structure/energybarricade/CanPass(atom/movable/A, turf/T, height=1.5, air_group = 0)

	//can mobs pass unhindered using advanced alien technology?
	if(ismob(A) && !blocks_mobs)
		return ..()

	//block movement from some directions if we are active
	if(A && T && shield_health > 0 && !(A in climbing) && A.elevation == elevation)
		var/turf/front_turf = get_step(src, dir)

		//movement in front of the shield
		if(front_turf == T)
			to_chat(A,"<span class='warning'>[src] blocks your way.</span>")
			return 0

	//do we seal off air on this turf?
	if(blocks_air && air_group)
		return shield_health <= 0

	return ..()

/obj/structure/energybarricade/CheckExit(atom/movable/O as mob|obj, target as turf)
	//can mobs pass unhindered using advanced alien technology?
	if(ismob(O) && !blocks_mobs)
		return ..()

	//directional blocking
	if(get_dir(O.loc, target) == dir && shield_health > 0 && !(O in climbing))
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
				var/atom/movable/A = new item_type(src.loc)
				qdel(src)
				user.visible_message("<span class='info'>[user] finishes deactivating [src] and packs it for transport.</span>")

				if(blocks_air)
					A.update_nearby_tiles()
		else
			to_chat(user,"<span class='info'>You must be closer to [src] to do this.</span>")
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
			if(blocks_air)
				update_nearby_tiles()

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
		icon_state = fail_state

/obj/structure/energybarricade/Destroy()
	if(blocks_air && src.loc)
		update_nearby_tiles()
	. = ..()

/obj/structure/energybarricade/verb/move_past()
	set name = "Slip Past"
	set category = "IC"
	set src in view(1)
	var/mob/living/user = usr
	if(istype(user))
		if(user.loc != src.loc)
			user.dir = get_dir(user, src)
		var/olddir = user.dir
		user.visible_message("\icon[user] <span class='warning'>[user] begins to slip past [src].</span>")
		if(do_after(user, 3 SECONDS, src, same_direction = 1))
			user.visible_message("\icon[user] <span class='info'>[user] slips past [src].</span>")
			climbing.Add(user)
			user.Move(get_step(user,olddir))
			climbing.Remove(user)
