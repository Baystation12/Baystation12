/obj/machinery/washing_machine
	name = "Washing Machine"
	icon = 'icons/obj/machines/washing_machine.dmi'
	icon_state = "wm_10"
	density = 1
	anchored = 1.0
	var/state = 1
	//1 = empty, open door
	//2 = empty, closed door
	//3 = full, open door
	//4 = full, closed door
	//5 = running
	//6 = blood, open door
	//7 = blood, closed door
	//8 = blood, running
	var/panel = 0
	//0 = closed
	//1 = open
	var/hacked = 1 //Bleh, screw hacking, let's have it hacked by default.
	//0 = not hacked
	//1 = hacked
	var/gibs_ready = 0
	var/obj/crayon
	var/obj/item/weapon/reagent_containers/pill/detergent/detergent
	obj_flags = OBJ_FLAG_ANCHORABLE
	clicksound = "button"
	clickvol = 40

	// Power
	use_power = 1
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

	if(!istype(usr, /mob/living)) //ew ew ew usr, but it's the only way to check.
		return

	if(!anchored)
		to_chat(usr, "\The [src] must be secured to the floor.")
		return

	if( state != 4 )
		to_chat(usr, "\The [src] cannot run in this state.")
		return

	if(!powered())
		to_chat(usr, SPAN_WARNING("\The [src] is unpowered."))
		return

	if( locate(/mob,contents) )
		state = 8
	else
		state = 5
	use_power = 2
	update_icon()
	addtimer(CALLBACK(src, /obj/machinery/washing_machine/proc/wash), 20 SECONDS, TIMER_UNIQUE)

/obj/machinery/washing_machine/proc/wash()
	for(var/atom/A in contents)
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
	for(var/obj/item/stack/material/hairlesshide/HH in contents)
		var/obj/item/stack/material/wetleather/WL = new(src)
		WL.amount = HH.amount
		qdel(HH)

	use_power = 1
	if( locate(/mob,contents) )
		state = 7
		gibs_ready = 1
	else
		state = 4
	update_icon()

/obj/machinery/washing_machine/verb/climb_out()
	set name = "Climb out"
	set category = "Object"
	set src in usr.loc

	sleep(20)
	if(state in list(1,3,6) )
		usr.dropInto(loc)

/obj/machinery/washing_machine/on_update_icon()
	icon_state = "wm_[state][panel]"

/obj/machinery/washing_machine/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/pen/crayon))
		if(state in list(1, 3, 6))
			if(!crayon)
				if(!user.unEquip(W, src))
					return
				crayon = W
			else
				..()
		else
			..()
	else if(istype(W,/obj/item/weapon/reagent_containers/pill/detergent))
		if(state in list(1, 3, 6))
			if(!detergent)
				if(!user.unEquip(W, src))
					return
				detergent = W
			else
				..()
		else
			..()
	else if((obj_flags & OBJ_FLAG_ANCHORABLE) && isWrench(W))
		if(state in list( 5, 8 ))
			to_chat(user, SPAN_WARNING("\The [src] is currently running."))
			return
		else
			wrench_floor_bolts(user)
			use_power = anchored
			power_change()
			return
	else if(istype(W,/obj/item/grab))
		if((state == 1) && hacked)
			var/obj/item/grab/G = W
			if(ishuman(G.assailant) && iscorgi(G.affecting))
				G.affecting.forceMove(src)
				qdel(G)
				state = 3
		else
			..()
	else if(istype(W,/obj/item/stack/material/hairlesshide) || \
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
			if ( state in list(1, 3) )
				if(!user.unEquip(W, src))
					return
				state = 3
			else
				to_chat(user, SPAN_NOTICE("You can't put the item in right now."))
		else
			to_chat(user, SPAN_NOTICE("\The [src] is full"))
	else
		..()
	update_icon()

/obj/machinery/washing_machine/attack_hand(mob/user as mob)
	switch(state)
		if(1)
			state = 2
		if(2)
			state = 1
			for(var/atom/movable/O in contents)
				O.forceMove(loc)
			crayon = null
			detergent = null
		if(3)
			state = 4
		if(4)
			state = 3
			for(var/atom/movable/O in contents)
				O.dropInto(loc)
			crayon = null
			detergent = null
			state = 1
		if(5)
			to_chat(user, SPAN_WARNING("\The [src] is busy."))
		if(6)
			state = 7
		if(7)
			if(gibs_ready)
				gibs_ready = 0
				if(locate(/mob,contents))
					var/mob/M = locate(/mob,contents)
					M.gib()
			for(var/atom/movable/O in contents)
				O.forceMove(src.loc)
			crayon = null
			detergent = null
			state = 1

	update_icon()
