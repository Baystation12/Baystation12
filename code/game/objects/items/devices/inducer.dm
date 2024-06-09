/obj/item/inducer
	name = "inducer"
	desc = "A tool for inductively charging internal power cells."
	icon = 'icons/obj/tools/inducers.dmi'
	icon_state = "inducer-sci"
	item_state = "inducer-sci"
	force = 7
	var/powertransfer = 500
	var/coefficient = 0.9
	var/opened = FALSE
	var/failsafe = 0
	var/obj/item/cell/cell = /obj/item/cell/standard
	var/recharging = FALSE
	origin_tech = list(TECH_POWER = 6, TECH_ENGINEERING = 4)
	matter = list(MATERIAL_STEEL = 1000, MATERIAL_GLASS = 700)
	slot_flags = SLOT_BELT

/obj/item/inducer/Initialize()
	. = ..()
	if(ispath(cell))
		cell = new cell(src)
	update_icon()

/obj/item/inducer/proc/induce(obj/item/cell/target)
	var/obj/item/cell/MyC = get_cell()
	var/missing = target.maxcharge - target.charge
	var/totransfer = min(min(MyC.charge,powertransfer), missing)
	target.give(totransfer*coefficient)
	MyC.use(totransfer)
	MyC.update_icon()
	target.update_icon()

/obj/item/inducer/get_cell()
	return cell

/obj/item/inducer/emp_act(severity)
	..()
	if(cell)
		cell.emp_act(severity)

/obj/item/inducer/use_after(obj/O, mob/living/user, click_parameters)
	if (!istype(O))
		return FALSE
	if (CannotUse(user) || !recharge(O, user))
		return TRUE

/obj/item/inducer/proc/CannotUse(mob/user)
	var/obj/item/cell/my_cell = get_cell()
	if(!istype(my_cell))
		to_chat(user, SPAN_WARNING("\The [src] doesn't have a power cell installed!"))
		return TRUE
	if(my_cell.percent() <= 0)
		to_chat(user, SPAN_WARNING("\The [src]'s battery is dead!"))
		return TRUE
	return FALSE


/obj/item/inducer/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(isScrewdriver(W))
		opened = !opened
		to_chat(user, SPAN_NOTICE("You [opened ? "open" : "close"] the battery compartment."))
		update_icon()
		return TRUE

	if(istype(W, /obj/item/cell))
		if (istype(W, /obj/item/cell/device))
			to_chat(user, SPAN_WARNING("\The [src] only takes full-size power cells."))
			return TRUE
		if(opened)
			if(!cell)
				if(!user.unEquip(W, src))
					FEEDBACK_UNEQUIP_FAILURE(user, W)
					return TRUE
				to_chat(user, SPAN_NOTICE("You insert \the [W] into \the [src]."))
				cell = W
				update_icon()
				return TRUE
			else
				to_chat(user, SPAN_NOTICE("\The [src] already has \a [cell] installed!"))
				return TRUE

	if(CannotUse(user) || recharge(W, user))
		return TRUE

	return ..()

/obj/item/inducer/proc/recharge(atom/A, mob/user)
	if(!isturf(A) && user.loc == A)
		return FALSE
	if(recharging)
		return TRUE
	else
		recharging = TRUE
	var/obj/item/cell/MyC = get_cell()
	var/obj/item/cell/C = A.get_cell()
	var/obj/O
	if(istype(A, /obj))
		O = A
	if(C)
		var/length = 10
		var/datum/effect/spark_spread/sparks = new /datum/effect/spark_spread()
		sparks.set_up(1, 1, user.loc)
		sparks.start()
		if(C.charge >= C.maxcharge)
			to_chat(user, SPAN_WARNING("\The [A] is already fully charged!"))
			recharging = FALSE
			return TRUE
		user.visible_message(
			SPAN_NOTICE("\The [user] starts recharging \the [A] with \the [src]."),
			SPAN_NOTICE("You start recharging \the [A] with \the [src].")
		)
		if (istype(A, /obj/item/gun/energy))
			length = 3 SECONDS
			if (user.get_skill_value(SKILL_WEAPONS) <= SKILL_TRAINED)
				length += rand(1, 3) SECONDS
		if (user.get_skill_value(SKILL_ELECTRICAL) < SKILL_TRAINED)
			length += rand(4, 6) SECONDS
		if(MyC.charge > max(0, MyC.charge*failsafe) && do_after(user, length, A, DO_PUBLIC_UNIQUE))
			if(CannotUse(user))
				return TRUE
			if(QDELETED(C))
				return TRUE
			sparks.start()
			induce(C)
			user.visible_message(
				SPAN_NOTICE("\The [user] recharges \the [A] with \the [src]."),
				SPAN_NOTICE("You recharge \the [A] with \the [src].")
			)
			if(O)
				O.update_icon()
		else
			qdel(sparks)
		recharging = FALSE
		return TRUE
	else
		to_chat(user, SPAN_WARNING("No cell detected!"))
	recharging = FALSE

// used only on the borg one, but here in case we invent inducer guns idk
/obj/item/inducer/proc/safety()
	if (failsafe)
		return 1
	else
		return 0

/obj/item/inducer/attack_self(mob/user)
	if(opened && cell)
		user.visible_message("\The [user] removes \the [cell] from \the [src]!",SPAN_NOTICE("You remove \the [cell]."))
		cell.update_icon()
		user.put_in_hands(cell)
		cell = null
		update_icon()


/obj/item/inducer/examine(mob/living/M)
	. = ..()
	var/obj/item/cell/MyC = get_cell()
	if(MyC)
		to_chat(M, SPAN_NOTICE("Its display shows: [MyC.percent()]%."))
	else
		to_chat(M,SPAN_NOTICE("Its display is dark."))
	if(opened)
		to_chat(M,SPAN_NOTICE("Its battery compartment is open."))

/obj/item/inducer/on_update_icon()
	ClearOverlays()
	if(opened)
		if(!get_cell())
			AddOverlays(image(icon, "inducer-nobat"))
		else
			AddOverlays(image(icon,"inducer-bat"))

/obj/item/inducer/Destroy()
	. = ..()
	if(!ispath(cell))
		QDEL_NULL(cell)

// module version

/obj/item/inducer/borg
	icon_state = "inducer-engi"
	item_state = "inducer-engi"
	failsafe = 0.2
	cell = null

/obj/item/inducer/borg/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(isScrewdriver(W))
		return FALSE
	return ..()

/obj/item/inducer/borg/on_update_icon()
	..()
	AddOverlays(image("icons/obj/guns/gui.dmi","safety[safety()]"))

/obj/item/inducer/borg/verb/toggle_safety(mob/user)
	set src in usr
	set category = "Object"
	set name = "Toggle Inducer Safety"
	if (safety())
		failsafe = 0
	else
		failsafe = 0.2
	update_icon()
	if(user)
		to_chat(user, SPAN_NOTICE("You switch your battery output failsafe [safety() ? "on" : "off"	]."))

/obj/item/inducer/borg/get_cell()
	return loc ? loc.get_cell() : null
