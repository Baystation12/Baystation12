/obj/machinery/resleever
	name = "neural lace resleever"
	desc = "It's a machine that allows neural laces to be sleeved into new bodies."
	icon = 'icons/obj/Cryogenic2.dmi'

	anchored = 1
	density = 1
	use_power = 1
	idle_power_usage = 40
	req_access = list(access_medical)

	icon_state = "body_scanner_0"
	var/empty_state = "body_scanner_0"
	var/occupied_state = "body_scanner_1"
	var/allow_occupant_types = list(/mob/living/carbon/human)
	var/disallow_occupant_types = list()

	var/mob/living/carbon/human/occupant = null
	var/obj/item/organ/internal/stack/lace = null

	var/remaining = 0
	var/timetosleeve = 120

/obj/machinery/resleever/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/stack/cable_coil(src, 2)
	component_parts += new /obj/item/weapon/stock_parts/scanning_module(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src, 3)
	component_parts += new /obj/item/weapon/stock_parts/console_screen(src)

	RefreshParts()
	update_icon()


/obj/machinery/resleever/attack_ai(mob/user as mob)

	add_hiddenprint(user)
	return attack_hand(user)


/obj/machinery/resleever/attack_hand(mob/user as mob)
	return


/obj/machinery/resleever/proc/sleeve()
	if(lace && occupant)
		var/obj/item/organ/I = occupant.organs_by_name["head"]
		lace.replaced(occupant, I)
		lace = null
		playsound(loc, 'sound/machines/ping.ogg', 100, 1)
		visible_message("\The [src] pings as it completes its procedure!", 3)
		eject_occupant()
	else
		return

/obj/machinery/resleever/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(default_deconstruction_screwdriver(user, W))
		if(occupant)
			user << "<span class='warning'>You need to remove the occupant first!</span>"
			return
	if(default_deconstruction_crowbar(user, W))
		if(occupant)
			user << "<span class='warning'>You need to remove the occupant first!</span>"
			return
	if(default_part_replacement(user, W))
		if(occupant)
			user << "<span class='warning'>You need to remove the occupant first!</span>"
			return
	if(istype(W, /obj/item/organ/internal/stack))
		if(isnull(lace))
			user << "<span class='notice'>You insert \the [W] into [src].</span>"
			user.drop_from_inventory(W)
			lace = W
			W.loc = src
		else
			user << "<span class='warning'>\The [src] already has a neural lace inside it!</span>"
			return
	else if(istype(W, /obj/item/weapon/wrench))
		if(isnull(occupant))
			if(anchored)
				anchored = 0
				user.visible_message("[user] unsecures [src] from the floor.", "You unsecure [src] from the floor.")
			else
				anchored = 1
				user.visible_message("[user] secures [src] to the floor.", "You secure [src] to the floor.")
			playsound(loc, 'sound/items/Ratchet.ogg', 100, 1)
		else
			user << "<span class='warning'>Can not do that while [src] is occupied.</span>"

	else if(istype(W, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/grab = W
		if(occupant)
			user << "<span class='notice'>\The [src] is in use.</span>"
			return

		if(!ismob(grab.affecting))
			return

		if(!check_occupant_allowed(grab.affecting))
			return

		var/mob/M = W:affecting

		visible_message("[user] starts putting [grab.affecting:name] into \the [src].", 3)

		if(do_after(user, 20, src))
			if(!M || !grab || !grab.affecting) return

			M.forceMove(src)

			occupant = M
			update_icon()
			if(M.client)
				M.client.perspective = EYE_PERSPECTIVE
				M.client.eye = src


/obj/machinery/resleever/verb/eject()
	set name = "Eject Resleever"
	set category = "Object"
	set src in oview(1)

	if(usr.stat != 0)
		return
	eject_occupant()
	add_fingerprint(usr)
	return

/obj/machinery/resleever/proc/eject_occupant()
	if(!(occupant))
		return
	occupant.loc = loc
	if(occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	occupant = null
	update_icon()

/obj/machinery/resleever/proc/eject_lace()
	if(!(lace))
		return
	lace.loc = loc
	lace = null

/obj/machinery/resleever/emp_act(severity)
	//if(prob(100/severity))
		//malfunction() //NOT DEFINED YET
	..()



/obj/machinery/resleever/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/atom/movable/A as mob|obj in src)
				A.loc = loc
				ex_act(severity)
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = loc
					ex_act(severity)
				qdel(src)
				return
		if(3.0)
			if(prob(25))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = loc
					ex_act(severity)
				qdel(src)
				return
		else
	return

/obj/machinery/resleever/update_icon()
	..()
	icon_state = empty_state
	if(occupant)
		icon_state = occupied_state


/obj/machinery/resleever/proc/check_occupant_allowed(mob/M)
	var/correct_type = 0
	for(var/type in allow_occupant_types)
		if(istype(M, type))
			correct_type = 1
			break

	if(!correct_type) return 0

	for(var/type in disallow_occupant_types)
		if(istype(M, type))
			return 0

	return 1