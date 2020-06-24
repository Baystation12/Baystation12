#define WASHER_STATE_CLOSED  1
#define WASHER_STATE_FULL    2
#define WASHER_STATE_RUNNING 4
#define WASHER_STATE_BLOODY  8

// WASHER_STATE_RUNNING implies WASHER_STATE_CLOSED | WASHER_STATE_FULL
// if you break this assumption, you must update the icon file
// other states are independent.

/obj/machinery/washing_machine
	name = "Washing Machine"
	icon = 'icons/obj/machines/washing_machine.dmi'
	icon_state = "wm_00"
	density = 1
	anchored = 1
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0
	var/state = 0
	var/gibs_ready = 0
	var/obj/crayon
	var/obj/item/weapon/reagent_containers/pill/detergent/detergent
	obj_flags = OBJ_FLAG_ANCHORABLE
	clicksound = "button"
	clickvol = 40

	// Power
	idle_power_usage = 10
	active_power_usage = 150

/obj/machinery/washing_machine/Destroy()
	QDEL_NULL(crayon)
	QDEL_NULL(detergent)
	. = ..()

/obj/machinery/washing_machine/verb/start()
	set name = "Start Washing"
	set category = "Object"
	set src in oview(1)

	if(!CanPhysicallyInteract(usr))
		return

	if(!anchored)
		to_chat(usr, "\The [src] must be secured to the floor.")
		return

	if(state & WASHER_STATE_RUNNING)
		to_chat(usr, "\The [src] is already running.")
		return
	if(!(state & WASHER_STATE_FULL))
		to_chat(usr, "Load \the [src] first!")
		return
	if(!(state & WASHER_STATE_CLOSED))
		to_chat(usr, "You must first close the machine.")
		return

	if(stat & NOPOWER)
		to_chat(usr, SPAN_WARNING("\The [src] is unpowered."))
		return

	state |= WASHER_STATE_RUNNING
	if(locate(/mob/living) in src)
		state |= WASHER_STATE_BLOODY

	update_use_power(POWER_USE_ACTIVE)
	update_icon()
	addtimer(CALLBACK(src, /obj/machinery/washing_machine/proc/wash), 20 SECONDS)

/obj/machinery/washing_machine/proc/wash()
	for(var/atom/A in (contents - component_parts))
		if(detergent)
			A.clean_blood()
		if(isitem(A))
			var/obj/item/I = A
			if(detergent)
				I.decontaminate()
			if(crayon && iscolorablegloves(I))
				var/obj/item/clothing/gloves/C = I
				C.color = crayon.color
			if(istype(A, /obj/item/clothing))
				var/obj/item/clothing/C = A
				C.ironed_state = WRINKLES_WRINKLY
				if(detergent)
					C.change_smell(SMELL_CLEAN)
					addtimer(CALLBACK(C, /obj/item/clothing/proc/change_smell), detergent.smell_clean_time, TIMER_UNIQUE | TIMER_OVERRIDE)
	QDEL_NULL(detergent)

	//Tanning!
	for(var/obj/item/stack/hairlesshide/HH in contents)
		var/obj/item/stack/wetleather/WL = new(src)
		WL.amount = HH.amount
		qdel(HH)

	update_use_power(POWER_USE_IDLE)
	if(locate(/mob/living) in src)
		gibs_ready = 1
	state &= ~WASHER_STATE_RUNNING
	update_icon()

/obj/machinery/washing_machine/verb/climb_out()
	set name = "Climb out"
	set category = "Object"
	set src in usr.loc

	if(!CanPhysicallyInteract(usr))
		return
	if(state & WASHER_STATE_CLOSED)
		to_chat(usr, SPAN_WARNING("\The [src] is closed."))
		return	
	if(!do_after(usr, 2 SECONDS, src))
		return
	if(!(state & WASHER_STATE_CLOSED))
		usr.dropInto(loc)

/obj/machinery/washing_machine/on_update_icon()
	icon_state = "wm_[state][panel_open]"

/obj/machinery/washing_machine/clean_blood()
	. = ..()
	state &= ~WASHER_STATE_BLOODY
	update_icon()	

/obj/machinery/washing_machine/components_are_accessible(path)
	return !(state & WASHER_STATE_RUNNING) && ..()

/obj/machinery/washing_machine/attackby(obj/item/weapon/W, mob/user)
	if(!(state & WASHER_STATE_CLOSED))
		if(!crayon && istype(W,/obj/item/weapon/pen/crayon))
			if(!user.unEquip(W, src))
				return
			crayon = W
			return TRUE
		if(!detergent && istype(W,/obj/item/weapon/reagent_containers/pill/detergent))
			if(!user.unEquip(W, src))
				return
			detergent = W
			return TRUE
	if(istype(W, /obj/item/weapon/holder)) // Mob holder
		for(var/mob/living/doggy in W)
			doggy.forceMove(src)
		qdel(W)
		state |= WASHER_STATE_FULL
		update_icon()
		return TRUE

	else if(istype(W,/obj/item/stack/hairlesshide) || \
		istype(W,/obj/item/clothing/under)  || \
		istype(W,/obj/item/clothing/mask)   || \
		istype(W,/obj/item/clothing/head)   || \
		istype(W,/obj/item/clothing/gloves) || \
		istype(W,/obj/item/clothing/shoes)  || \
		istype(W,/obj/item/clothing/suit)   || \
		istype(W,/obj/item/weapon/bedsheet) || \
		istype(W,/obj/item/underwear/))

		//YES, it's hardcoded... saves a var/can_be_washed for every single clothing item.
		if ( istype(W,/obj/item/clothing/suit/space ) )
			to_chat(user, "This item does not fit.")
			return
		if ( istype(W,/obj/item/clothing/suit/syndicatefake ) )
			to_chat(user, "This item does not fit.")
			return
		if ( istype(W,/obj/item/clothing/suit/cyborg_suit ) )
			to_chat(user, "This item does not fit.")
			return
		if ( istype(W,/obj/item/clothing/suit/bomb_suit ) )
			to_chat(user, "This item does not fit.")
			return
		if ( istype(W,/obj/item/clothing/suit/armor ) )
			to_chat(user, "This item does not fit.")
			return
		if ( istype(W,/obj/item/clothing/suit/armor ) )
			to_chat(user, "This item does not fit.")
			return
		if ( istype(W,/obj/item/clothing/mask/gas ) )
			to_chat(user, "This item does not fit.")
			return
		if ( istype(W,/obj/item/clothing/mask/smokable/cigarette ) )
			to_chat(user, "This item does not fit.")
			return
		if ( istype(W,/obj/item/clothing/head/syndicatefake ) )
			to_chat(user, "This item does not fit.")
			return
		if ( istype(W,/obj/item/clothing/head/helmet ) )
			to_chat(user, "This item does not fit.")
			return

		if(contents.len < 5)
			if(!(state & WASHER_STATE_CLOSED))
				if(!user.unEquip(W, src))
					return
				state |= WASHER_STATE_FULL
				update_icon()
			else
				to_chat(user, SPAN_NOTICE("You can't put the item in right now."))
		else
			to_chat(user, SPAN_NOTICE("\The [src] is full"))
		return TRUE

	if(state & WASHER_STATE_RUNNING)
		to_chat(user, SPAN_WARNING("\The [src] is currently running."))
		return TRUE

	return ..()

/obj/machinery/washing_machine/physical_attack_hand(mob/user)
	if(state & WASHER_STATE_RUNNING)
		to_chat(user, SPAN_WARNING("\The [src] is busy."))
		return TRUE
	if(state & WASHER_STATE_CLOSED)
		state &= ~WASHER_STATE_CLOSED
		if(gibs_ready)
			gibs_ready = 0
			var/mob/M = locate(/mob/living) in src
			if(M)
				M.gib()
		for(var/atom/movable/O in (contents - component_parts))
			O.dropInto(loc)
		state &= ~WASHER_STATE_FULL
		update_icon()
		crayon = null
		detergent = null
		return TRUE
	state |= WASHER_STATE_CLOSED
	update_icon()
	return TRUE

#undef WASHER_STATE_CLOSED
#undef WASHER_STATE_FULL
#undef WASHER_STATE_RUNNING
#undef WASHER_STATE_BLOODY
