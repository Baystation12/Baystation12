/obj/machinery/disposal/deliveryChute
	name = "Delivery chute"
	desc = "A chute for big and small packages alike!"
	density = TRUE
	icon_state = "intake"
	var/build_state


/obj/machinery/disposal/deliveryChute/Destroy()
	if (trunk)
		trunk.linked = null
	return ..()


/obj/machinery/disposal/deliveryChute/Initialize()
	. = ..()
	trunk = locate() in loc
	if (trunk)
		trunk.linked = src


/obj/machinery/disposal/deliveryChute/interact()
	return


/obj/machinery/disposal/deliveryChute/on_update_icon()
	return


/obj/machinery/disposal/deliveryChute/Bumped(atom/movable/movable)
	if (istype(AM, /obj/item/projectile) || istype(AM, /obj/effect))
		return
	switch(dir)
		if (NORTH)
			if (AM.loc.y != loc.y + 1)
				return
		if (EAST)
			if (AM.loc.x != loc.x + 1)
				return
		if (SOUTH)
			if (AM.loc.y != loc.y - 1)
				return
		if (WEST)
			if (AM.loc.x != loc.x - 1)
				return
	if (isobj(movable))
		movable.forceMove(src)
	else if (ismob(movable))
		movable.forceMove(src)
		var/mob/mob = movable
		if (mob.ckey)
			log_and_message_admins("has been flushed down \the [src].", mob)
	flush()


/obj/machinery/disposal/deliveryChute/flush()
	var/obj/structure/disposalholder/holder = ..()
	for (var/mob/living/living as anything in holder.held_mobs)
		if (prob(50))
			continue
		if (ishuman(living))
			var/mob/living/carbon/human/human = living
			var/obj/item/organ/external/limb = human.get_damageable_organs()
			if (!length(limb))
				continue
			limb = pick(limb)
			limb.take_external_damage(50, used_weapon = "Blunt Trauma")
			visible_message("\The [src] crushes \the [human]'s [limb.name]!")
			continue
		living.apply_damage(50, used_weapon = "Blunt Trauma")
		visible_message("\The [src] crushes \the [living]!")


/obj/machinery/disposal/deliveryChute/attackby(obj/item/I, mob/user)
	if(!I || !user)
		return

	if(isScrewdriver(I))
		if(c_mode==0)
			c_mode=1
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
			to_chat(user, "You remove the screws around the power connection.")
			return
		else if(c_mode==1)
			c_mode=0
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
			to_chat(user, "You attach the screws around the power connection.")
			return
	else if(isWelder(I) && c_mode==1)
		var/obj/item/weldingtool/W = I
		if(W.remove_fuel(1,user))
			to_chat(user, "You start slicing the floorweld off the delivery chute.")
			if(do_after(user, (I.toolspeed * 2) SECONDS, src, DO_REPAIR_CONSTRUCT))
				playsound(src.loc, 'sound/items/Welder2.ogg', 100, 1)
				if(!src || !W.isOn()) return
				to_chat(user, "You sliced the floorweld off the delivery chute.")
				var/obj/structure/disposalconstruct/C = new (loc, src)
				C.update()
				qdel(src)
			return
		else
			to_chat(user, "You need more welding fuel to complete this task.")
			return
