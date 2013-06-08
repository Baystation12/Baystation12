//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/tk_grab
	name = "Telekinetic Grab"
	desc = "Magic"
	icon = 'icons/obj/magic.dmi'//Needs sprites
	icon_state = "2"
	flags = USEDELAY
	//item_state = null
	w_class = 10.0
	layer = 20

	var/last_throw = 0
	var/obj/focus = null
	var/mob/living/host = null


	dropped(mob/user as mob)
		del(src)
		return


	//stops TK grabs being equipped anywhere but into hands
	equipped(var/mob/user, var/slot)
		if( (slot == slot_l_hand) || (slot== slot_r_hand) )	return
		del(src)
		return

/*
	attack_self(mob/user as mob)
		if(!istype(focus,/obj/item))	return
		if(!check_path())	return//No clear path

		user.put_in_hands(focus)
		add_fingerprint(user)
		user.update_inv_l_hand(0)
		user.update_inv_r_hand()
		spawn(0)
			del(src)
		return
*/

	afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, flag)//TODO: go over this
		if(!target || !user)	return
		if(last_throw+3 > world.time)	return
		if(!host)
			del(src)
			return
		if(!(TK in host.mutations))
			del(src)
			return
		if(isobj(target))
			if(!target.loc || !isturf(target.loc))
				del(src)
				return
		if(!focus)
			focus_object(target, user)
			return
		var/focusturf = get_turf(focus)
		if(get_dist(focusturf, target) <= 1 && !istype(target, /turf))
			target.attackby(focus, user, user:get_organ_target())

		else if(get_dist(focusturf, target) <= 16)
			apply_focus_overlay()
			focus.throw_at(target, 10, 1)
			last_throw = world.time
		return


	proc/focus_object(var/obj/target, var/mob/living/user)
		if(!istype(target,/obj))	return//Cant throw non objects atm might let it do mobs later
		if(target.anchored)
			target.attack_hand(user) // you can use shit now!
			return//No throwing anchored things
		if(!isturf(target.loc))
			return
		focus = target
		update_icon()
		apply_focus_overlay()
		return


	proc/apply_focus_overlay()
		if(!focus)	return
		var/obj/effect/overlay/O = new /obj/effect/overlay(locate(focus.x,focus.y,focus.z))
		O.name = "sparkles"
		O.anchored = 1
		O.density = 0
		O.layer = FLY_LAYER
		O.dir = pick(cardinal)
		O.icon = 'icons/effects/effects.dmi'
		O.icon_state = "nothing"
		flick("empdisable",O)
		spawn(5)
			O.delete()
		return


	update_icon()
		overlays.Cut()
		if(focus && focus.icon && focus.icon_state)
			overlays += icon(focus.icon,focus.icon_state)
		return

/*Not quite done likely needs to use something thats not get_step_to
	proc/check_path()
		var/turf/ref = get_turf(src.loc)
		var/turf/target = get_turf(focus.loc)
		if(!ref || !target)	return 0
		var/distance = get_dist(ref, target)
		if(distance >= 10)	return 0
		for(var/i = 1 to distance)
			ref = get_step_to(ref, target, 0)
		if(ref != target)	return 0
		return 1
*/

//equip_to_slot_or_del(obj/item/W, slot, del_on_fail = 1)
/*
		if(istype(user, /mob/living/carbon))
			if(user:mutations & TK && get_dist(source, user) <= 7)
				if(user:get_active_hand())	return 0
				var/X = source:x
				var/Y = source:y
				var/Z = source:z

*/

