/obj/machinery/resleever
	name = "neural lace resleever"
	desc = "It's a machine that allows neural laces to be sleeved into new bodies."
	icon = 'icons/obj/Cryogenic2.dmi'

	anchored = 1
	density = 1
	use_power = 1
	idle_power_usage = 4
	active_power_usage = 4000 // 4 Kw. A CT scan machine uses 1-15 kW depending on the model and equipment involved.
	req_access = list(access_medical)

	icon_state = "body_scanner_0"
	var/empty_state = "body_scanner_0"
	var/occupied_state = "body_scanner_1"
	var/allow_occupant_types = list(/mob/living/carbon/human)
	var/disallow_occupant_types = list()

	var/mob/living/carbon/human/occupant = null
	var/obj/item/organ/internal/stack/lace = null

	var/resleeving = 0
	var/remaining = 0
	var/timetosleeve = 120

	var/occupant_name = null // Put in seperate var to prevent runtime.
	var/lace_name = null

/obj/machinery/resleever/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/stack/cable_coil(src, 2)
	component_parts += new /obj/item/weapon/stock_parts/scanning_module(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src, 3)
	component_parts += new /obj/item/weapon/stock_parts/console_screen(src)

	RefreshParts()
	update_icon()

/obj/machinery/resleever/Destroy()
	eject_occupant()
	eject_lace()
	return ..()


obj/machinery/resleever/process()

	if(occupant)
		occupant.Paralyse(4) // We need to always keep the occupant sleeping if they're in here.
	if(stat & (NOPOWER|BROKEN) || !anchored)
		update_use_power(0)
		return
	if(resleeving)
		update_use_power(2)
		if(remaining < timetosleeve)
			remaining += 1

			if(remaining == 90) // 30 seconds left
				to_chat(occupant, "<span class='notice'>You feel a wash of sensation as your senses begin to flood your mind. You will come to soon.</span>")
		else
			remaining = 0
			resleeving = 0
			update_use_power(1)
			eject_occupant()
			playsound(loc, 'sound/machines/ping.ogg', 100, 1)
			visible_message("\The [src] pings as it completes its procedure!", 3)
			return
	update_use_power(0)
	return

/obj/machinery/resleever/proc/isOccupiedEjectable()
	if(occupant)
		if(!resleeving)
			return 1
	return 0

/obj/machinery/resleever/proc/isLaceEjectable()
	if(lace)
		if(!resleeving)
			return 1
	return 0

/obj/machinery/resleever/proc/readyToBegin()
	if(lace && occupant)
		if(!resleeving)
			return 1
	return 0

/obj/machinery/resleever/attack_ai(mob/user as mob)

	add_hiddenprint(user)
	return attack_hand(user)


/obj/machinery/resleever/attack_hand(mob/user as mob)
	if(!anchored)
		return

	if(stat & (NOPOWER|BROKEN))
		to_chat(usr, "\The [src] doesn't appear to function.")
		return

	tg_ui_interact(user)

/obj/machinery/resleever/ui_status(mob/user, datum/ui_state/state)
	if(!anchored || inoperable())
		return UI_CLOSE
	return ..()


/obj/machinery/resleever/tg_ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, datum/tgui/master_ui = null, datum/ui_state/state = default_state)
	ui = tgui_process.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "resleever", "Neural Lace Resleever", 300, 300, master_ui, state)
		ui.open()

/obj/machinery/resleever/ui_data()
	var/list/data = list(
		"name" = occupant_name,
		"lace" = lace_name,
		"isOccupiedEjectable" = isOccupiedEjectable(),
		"isLaceEjectable" = isLaceEjectable(),
		"active" = resleeving,
		"remaining" = remaining,
		"timetosleeve" = 120,
		"ready" = readyToBegin()
	)

	return data

/obj/machinery/resleever/ui_act(action, params)
	if(..())
		return TRUE
	switch(action)
		if("begin")
			sleeve()
			resleeving = 1
		if("eject")
			eject_occupant()
		if("ejectlace")
			eject_lace()
	update_icon()
	return TRUE

/obj/machinery/resleever/proc/sleeve()
	if(lace && occupant)
		var/obj/item/organ/O = occupant.get_organ(lace.parent_organ)
		if(istype(O))
			lace.status &= ~ORGAN_CUT_AWAY //ensure the lace is properly attached
			lace.replaced(occupant, O)
			lace = null
			lace_name = null
	else
		return

/obj/machinery/resleever/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(default_deconstruction_screwdriver(user, W))
		if(occupant)
			to_chat(user, "<span class='warning'>You need to remove the occupant first!</span>")
			return
	if(default_deconstruction_crowbar(user, W))
		if(occupant)
			to_chat(user, "<span class='warning'>You need to remove the occupant first!</span>")
			return
	if(default_part_replacement(user, W))
		if(occupant)
			to_chat(user, "<span class='warning'>You need to remove the occupant first!</span>")
			return
	if(istype(W, /obj/item/organ/internal/stack))
		if(isnull(lace))
			to_chat(user, "<span class='notice'>You insert \the [W] into [src].</span>")
			user.drop_from_inventory(W)
			lace = W
			W.forceMove(src)
			if(lace.backup)
				lace_name = lace.backup.name
		else
			to_chat(user, "<span class='warning'>\The [src] already has a neural lace inside it!</span>")
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
			to_chat(user, "<span class='warning'>Can not do that while [src] is occupied.</span>")

	else if(istype(W, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/grab = W
		if(occupant)
			to_chat(user, "<span class='notice'>\The [src] is in use.</span>")
			return

		if(!ismob(grab.affecting))
			return

		if(!check_occupant_allowed(grab.affecting))
			return

		var/mob/M = grab.affecting

		visible_message("[user] starts putting [grab.affecting:name] into \the [src].", 3)

		if(do_after(user, 20, src))
			if(!M || !grab || !grab.affecting) return

			M.forceMove(src)

			occupant = M
			occupant_name = occupant.name
			update_icon()
			if(M.client)
				M.client.perspective = EYE_PERSPECTIVE
				M.client.eye = src

/obj/machinery/resleever/proc/eject_occupant()
	if(!(occupant))
		return
	occupant.forceMove(loc)
	if(occupant.client)
		occupant.reset_view(null)
	occupant = null
	occupant_name = null
	update_icon()

/obj/machinery/resleever/proc/eject_lace()
	if(!(lace))
		return
	lace.forceMove(loc)
	lace = null
	lace_name = null

/obj/machinery/resleever/emp_act(severity)
	//if(prob(100/severity))
		//malfunction() //NOT DEFINED YET
	..()



/obj/machinery/resleever/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/atom/movable/A as mob|obj in src)
				A.forceMove(loc)
				ex_act(severity)
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				for(var/atom/movable/A as mob|obj in src)
					A.forceMove(loc)
					ex_act(severity)
				qdel(src)
				return
		if(3.0)
			if(prob(25))
				for(var/atom/movable/A as mob|obj in src)
					A.forceMove(loc)
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
