/obj/item/device/chameleon
	name = "chameleon projector"
	icon = 'icons/obj/tools/chameleon_projector.dmi'
	icon_state = "shield0"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	item_state = "electronic"
	throwforce = 5.0
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_ESOTERIC = 4, TECH_MAGNET = 4)
	var/can_use = 1
	var/obj/dummy/chameleon/active_dummy = null
	var/saved_item = /obj/item/trash/cigbutt
	var/saved_icon = 'icons/obj/clothing/obj_mask.dmi'
	var/saved_icon_state = "cigbutt"
	var/saved_overlays

/obj/item/device/chameleon/dropped()
	disrupt()
	..()

/obj/item/device/chameleon/equipped()
	disrupt()
	..()

/obj/item/device/chameleon/attack_self()
	toggle()

/obj/item/device/chameleon/use_after(atom/target, mob/living/user, click_parameters)
	if(!active_dummy)
		if(istype(target,/obj/item) && !istype(target, /obj/item/disk/nuclear))
			playsound(get_turf(src), 'sound/weapons/flash.ogg', 100, 1, -6)
			to_chat(user, SPAN_NOTICE("Scanned [target]."))
			saved_item = target.type
			saved_icon = target.icon
			saved_icon_state = target.icon_state
			saved_overlays = target.overlays.Copy()
			return TRUE

/obj/item/device/chameleon/proc/toggle()
	if(!can_use || !saved_item) return
	if(active_dummy)
		eject_all()
		playsound(get_turf(src), 'sound/effects/pop.ogg', 100, 1, -6)
		qdel(active_dummy)
		active_dummy = null
		to_chat(usr, SPAN_NOTICE("You deactivate the [src]."))
		var/obj/overlay/T = new /obj/overlay(get_turf(src))
		T.icon = 'icons/effects/effects.dmi'
		flick("emppulse",T)
		QDEL_IN(T, 8)
	else
		playsound(get_turf(src), 'sound/effects/pop.ogg', 100, 1, -6)
		var/obj/O = new saved_item(src)
		if(!O) return
		var/obj/dummy/chameleon/C = new /obj/dummy/chameleon(usr.loc)
		C.activate(O, usr, saved_icon, saved_icon_state, saved_overlays, src)
		qdel(O)
		to_chat(usr, SPAN_NOTICE("You activate the [src]."))
		var/obj/overlay/T = new/obj/overlay(get_turf(src))
		T.icon = 'icons/effects/effects.dmi'
		flick("emppulse",T)
		QDEL_IN(T, 8)

/obj/item/device/chameleon/proc/disrupt(delete_dummy = 1)
	if(active_dummy)
		var/datum/effect/spark_spread/spark_system = new /datum/effect/spark_spread
		spark_system.set_up(5, 0, src)
		spark_system.attach(src)
		spark_system.start()
		eject_all()
		if(delete_dummy)
			qdel(active_dummy)
		active_dummy = null
		can_use = 0
		spawn(50) can_use = 1

/obj/item/device/chameleon/proc/eject_all()
	for(var/atom/movable/A in active_dummy)
		A.forceMove(active_dummy.loc)
		if(ismob(A))
			var/mob/M = A
			M.reset_view(null)

/obj/dummy/chameleon
	name = ""
	desc = ""
	density = FALSE
	anchored = TRUE
	var/can_move = 1
	var/obj/item/device/chameleon/master = null

/obj/dummy/chameleon/proc/activate(obj/O, mob/M, new_icon, new_iconstate, new_overlays, obj/item/device/chameleon/C)
	name = O.name
	desc = O.desc
	icon = new_icon
	icon_state = new_iconstate
	SetOverlays(new_overlays)
	set_dir(O.dir)
	M.forceMove(src)
	master = C
	master.active_dummy = src


/obj/dummy/chameleon/use_tool(obj/item/tool, mob/user, list/click_params)
	. = ..()
	if (.)
		return

	// Interaction always handled - `post_use_item()` handles the reveal of hidden mobs.
	user.visible_message(
		SPAN_NOTICE("\The [user] taps \the [src] with \a [tool]."),
		SPAN_NOTICE("You tap \the [src] with \the [tool].")
	)
	return TRUE


/obj/dummy/chameleon/post_use_item(obj/item/tool, mob/user, interaction_handled, use_call, click_params)
	. = ..()
	if (interaction_handled)
		var/list/revealed = list()
		for (var/hidden as anything in src)
			to_chat(hidden, SPAN_WARNING("Your [master] deactivates."))
			revealed += "\the [hidden]"
		visible_message(
			SPAN_WARNING("\The [src] flashes and [english_list(revealed)] appear[length(revealed) == 1 ? "s" : null]!")
		)
		master.disrupt()


/obj/dummy/chameleon/attack_hand()
	for(var/mob/M in src)
		to_chat(M, SPAN_WARNING("Your chameleon-projector deactivates."))
	master.disrupt()

/obj/dummy/chameleon/ex_act()
	for(var/mob/M in src)
		to_chat(M, SPAN_WARNING("Your chameleon-projector deactivates."))
	master.disrupt()

/obj/dummy/chameleon/bullet_act()
	for(var/mob/M in src)
		to_chat(M, SPAN_WARNING("Your chameleon-projector deactivates."))
	..()
	master.disrupt()

/obj/dummy/chameleon/relaymove(mob/user, direction)
	if(!has_gravity())
		return //No magical space movement!

	if(can_move)
		can_move = 0
		switch(user.bodytemperature)
			if(300 to INFINITY)
				spawn(10) can_move = 1
			if(295 to 300)
				spawn(13) can_move = 1
			if(280 to 295)
				spawn(16) can_move = 1
			if(260 to 280)
				spawn(20) can_move = 1
			else
				spawn(25) can_move = 1
		if(isturf(loc))
			step(src, direction)
	return

/obj/dummy/chameleon/Destroy()
	master.disrupt(0)
	..()
