/*
	Telekinesis

	This needs more thinking out, but I might as well.
*/
var/const/tk_maxrange = 15

/*
	Telekinetic attack:

	By default, emulate the user's unarmed attack
*/
/atom/proc/attack_tk(mob/user)
	if(user.stat) return
	user.UnarmedAttack(src,0) // attack_hand, attack_paw, etc
	return

/*
	This is similar to item attack_self, but applies to anything
	that you can grab with a telekinetic grab.

	It is used for manipulating things at range, for example, opening and closing closets.
	There are not a lot of defaults at this time, add more where appropriate.
*/
/atom/proc/attack_self_tk(mob/user)
	return

/obj/attack_tk(mob/user)
	if(user.stat) return
	if(anchored)
		..()
		return

	var/obj/item/tk_grab/O = new(src)
	user.put_in_active_hand(O)
	O.host = user
	O.focus_object(src)
	return

/obj/item/attack_tk(mob/user)
	if(user.stat || !isturf(loc)) return
	if((TK in user.mutations) && !user.get_active_hand()) // both should already be true to get here
		var/obj/item/tk_grab/O = new(src)
		user.put_in_active_hand(O)
		O.host = user
		O.focus_object(src)
	else
		warning("Strange attack_tk(): TK([TK in user.mutations]) empty hand([!user.get_active_hand()])")
	return


/mob/attack_tk(mob/user)
	return // needs more thinking about

/*
	TK Grab Item (the workhorse of old TK)

	* If you have not grabbed something, do a normal tk attack
	* If you have something, throw it at the target.  If it is already adjacent, do a normal attackby()
	* If you click what you are holding, or attack_self(), do an attack_self_tk() on it.
	* Deletes itself if it is ever not in your hand, or if you should have no access to TK.
*/
/obj/item/tk_grab
	name = "Telekinetic Grab"
	desc = "Magic"
	icon = 'icons/obj/magic.dmi'//Needs sprites
	icon_state = "2"
	flags = NOBLUDGEON
	//item_state = null
	w_class = 10.0
	layer = 20

	var/last_throw = 0
	var/atom/movable/focus = null
	var/mob/living/host = null

/obj/item/tk_grab/dropped(mob/user as mob)
	if(focus && user && loc != user && loc != user.loc) // drop_item() gets called when you tk-attack a table/closet with an item
		if(focus.Adjacent(loc))
			focus.loc = loc
	loc = null
	spawn(1)
		qdel(src)
	return

//stops TK grabs being equipped anywhere but into hands
/obj/item/tk_grab/equipped(var/mob/user, var/slot)
	if( (slot == slot_l_hand) || (slot== slot_r_hand) )	return
	qdel(src)
	return

/obj/item/tk_grab/attack_self(mob/user as mob)
	if(focus)
		focus.attack_self_tk(user)

/obj/item/tk_grab/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, proximity)//TODO: go over this
	if(!target || !user)	return
	if(last_throw+3 > world.time)	return
	if(!host || host != user)
		qdel(src)
		return
	if(!(TK in host.mutations))
		qdel(src)
		return
	if(isobj(target) && !isturf(target.loc))
		return

	var/d = get_dist(user, target)
	if(focus) d = max(d,get_dist(user,focus)) // whichever is further
	switch(d)
		if(0)
			;
		if(1 to 5) // not adjacent may mean blocked by window
			if(!proximity)
				user.setMoveCooldown(2)
		if(5 to 7)
			user.setMoveCooldown(5)
		if(8 to tk_maxrange)
			user.setMoveCooldown(10)
		else
			user << "<span class='notice'>Your mind won't reach that far.</span>"
			return

	if(!focus)
		focus_object(target, user)
		return

	if(target == focus)
		target.attack_self_tk(user)
		return // todo: something like attack_self not laden with assumptions inherent to attack_self


	if(!istype(target, /turf) && istype(focus,/obj/item) && target.Adjacent(focus))
		var/obj/item/I = focus
		var/resolved = target.attackby(I, user, user:get_organ_target())
		if(!resolved && target && I)
			I.afterattack(target,user,1) // for splashing with beakers
	else
		apply_focus_overlay()
		focus.throw_at(target, 10, 1, user)
		last_throw = world.time
	return

/obj/item/tk_grab/attack(mob/living/M as mob, mob/living/user as mob, def_zone)
	return


/obj/item/tk_grab/proc/focus_object(var/obj/target, var/mob/living/user)
	if(!istype(target,/obj))	return//Cant throw non objects atm might let it do mobs later
	if(target.anchored || !isturf(target.loc))
		qdel(src)
		return
	focus = target
	update_icon()
	apply_focus_overlay()
	return

/obj/item/tk_grab/proc/apply_focus_overlay()
	if(!focus)	return
	var/obj/effect/overlay/O = PoolOrNew(/obj/effect/overlay, locate(focus.x,focus.y,focus.z))
	O.name = "sparkles"
	O.anchored = 1
	O.density = 0
	O.layer = FLY_LAYER
	O.set_dir(pick(cardinal))
	O.icon = 'icons/effects/effects.dmi'
	O.icon_state = "nothing"
	flick("empdisable",O)
	spawn(5)
		qdel(O)
	return

/obj/item/tk_grab/update_icon()
	overlays.Cut()
	if(focus && focus.icon && focus.icon_state)
		overlays += icon(focus.icon,focus.icon_state)
	return
