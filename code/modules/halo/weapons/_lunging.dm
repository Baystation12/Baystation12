
/obj/item
	var/parry_slice_objects = 0 //Does this melee weapon, when parried, slice through the object?

	var/lunge_dist = 0
	var/lunge_delay = 5 SECONDS
	var/next_leapwhen = 0

/obj/item/proc/get_lunge_dist(var/mob/user)
	return lunge_dist

/obj/item/afterattack(var/atom/target,var/mob/user)
	. = ..()
	if(get_lunge_dist(user) == 0 || user.loc.Adjacent(target) || istype(user.loc,/obj/vehicles))
		return
	if(world.time < next_leapwhen)
		to_chat(user,"<span class = 'notice'>You're still recovering from the last lunge!</span>")
		return
	if(!istype(target,/mob))
		if(istype(target,/turf))
			var/turf/targ_turf = target
			var/list/turf_mobs = list()
			for(var/mob/m in targ_turf.contents)
				turf_mobs += m
			if(turf_mobs.len > 0)
				target = pick(turf_mobs)
			else
				to_chat(user,"<span class = 'notice'>You can't leap at non-mobs!</span>")
				return
		else
			to_chat(user,"<span class = 'notice'>You can't leap at non-mobs!</span>")
			return
	if(!(target in view(7,user.loc)))
		to_chat(user,"<span class = 'notice'>That's not in your view!</span>")
		return
	if(get_dist(user,target) <= get_lunge_dist(user))
		user.visible_message("<span class = 'danger'>[user] lunges forward, [src] in hand, ready to strike!</span>")
		var/image/user_image = image(user)
		user_image.dir = user.dir
		for(var/i = 0 to get_dist(user,target))
			var/obj/after_image = new /obj/effect/esword_path
			if(i == 0)
				after_image.loc = user.loc
			else
				after_image.loc = get_step(user,get_dir(user,target))
				if(!user.Move(after_image.loc))
					break
			after_image.dir = user.dir
			after_image.overlays += user_image
			spawn(5)
				qdel(after_image)
		if(user.Adjacent(target) && ismob(target))
			attack(target,user)
		var/mob/living/carbon/human/h = user
		if(h)
			var/obj/item/lefthand = h.r_hand
			var/obj/item/righthand = h.l_hand
			if(istype(lefthand) && lefthand.lunge_dist)
				lefthand.next_leapwhen = world.time + lunge_delay
			if(istype(righthand) && righthand.lunge_dist)
				righthand.next_leapwhen = world.time + lunge_delay

		else
			next_leapwhen = world.time + lunge_delay
