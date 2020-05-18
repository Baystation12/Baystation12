/obj/item/inducer
	name = "inducer"
	desc = "A tool for inductively charging internal power cells."
	icon = 'icons/obj/tools.dmi'
	icon_state = "inducer-sci"
	item_state = "inducer-sci"
	force = 7
	var/powertransfer = 500
	var/coefficient = 0.9
	var/opened = FALSE
	var/failsafe = 0
	var/obj/item/weapon/cell/cell = /obj/item/weapon/cell
	var/recharging = FALSE
	origin_tech = list(TECH_POWER = 6, TECH_ENGINEERING = 4)
	matter = list(MATERIAL_STEEL = 1000, MATERIAL_GLASS = 700)
	slot_flags = SLOT_BELT

/obj/item/inducer/Initialize()
	. = ..()
	if(ispath(cell))
		cell = new cell(src)
	update_icon()

/obj/item/inducer/proc/induce(obj/item/weapon/cell/target)
	var/obj/item/weapon/cell/MyC = get_cell()
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

/obj/item/inducer/afterattack(obj/O, mob/living/carbon/user, var/proximity)
	if (!proximity || user.a_intent == I_HURT || CannotUse(user) || !recharge(O, user))
		return ..()

/obj/item/inducer/proc/CannotUse(mob/user)
	var/obj/item/weapon/cell/my_cell = get_cell()
	if(!istype(my_cell))
		to_chat(user, "<span class='warning'>\The [src] doesn't have a power cell installed!</span>")
		return TRUE
	if(my_cell.percent() <= 0)
		to_chat(user, "<span class='warning'>\The [src]'s battery is dead!</span>")
		return TRUE
	return FALSE


/obj/item/inducer/attackby(obj/item/W, mob/user)
	if(isScrewdriver(W))
		opened = !opened
		to_chat(user, "<span class='notice'>You [opened ? "open" : "close"] the battery compartment.</span>")
		update_icon()
	if(istype(W, /obj/item/weapon/cell))
		if (istype(W, /obj/item/weapon/cell/device))
			to_chat(user, "<span class='warning'>\The [src] only takes full-size power cells.</span>")
			return
		if(opened)
			if(!cell)
				if(!user.unEquip(W, src))
					return
				to_chat(user, "<span class='notice'>You insert \the [W] into \the [src].</span>")
				cell = W
				update_icon()
				return
			else
				to_chat(user, "<span class='notice'>\The [src] already has \a [cell] installed!</span>")
				return
	if(CannotUse(user) || recharge(W, user))
		return
	return ..()

/obj/item/inducer/proc/recharge(atom/A, mob/user)
	if(!isturf(A) && user.loc == A)
		return FALSE
	if(recharging)
		return TRUE
	else
		recharging = TRUE
	var/obj/item/weapon/cell/MyC = get_cell()
	var/obj/item/weapon/cell/C = A.get_cell()
	var/obj/O
	if(istype(A, /obj))
		O = A
	if(C)
		var/length = 10
		var/done_any = FALSE
		var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
		sparks.set_up(1, 1, user.loc)
		sparks.start()
		if(C.charge >= C.maxcharge)
			to_chat(user, "<span class='notice'>\The [A] is fully charged!</span>")
			recharging = FALSE
			return TRUE
		user.visible_message("\The [user] starts recharging \the [A] with \the [src].","<span class='notice'>You start recharging \the [A] with \the [src].</span>")
		if (istype(A, /obj/item/weapon/gun/energy))
			length = 30
			if (user.get_skill_value(SKILL_WEAPONS) <= SKILL_ADEPT)
				length += rand(10, 30)
		if (user.get_skill_value(SKILL_ELECTRICAL) < SKILL_ADEPT)
			length += rand(40, 60)
		while(C.charge < C.maxcharge)
			if(MyC.charge > max(0, MyC.charge*failsafe) && do_after(user, length, target = user))
				if(CannotUse(user))
					return TRUE
				if(QDELETED(C))
					return TRUE
				sparks.start()
				done_any = TRUE
				induce(C)
				if(O)
					O.update_icon()
			else
				qdel(sparks)
				break
		if(done_any) // Only show a message if we succeeded at least once
			user.visible_message("\The [user] recharged \the [A]!","<span class='notice'>You recharged \the [A]!</span>")
		recharging = FALSE
		return TRUE
	else
		to_chat(user, "<span class='warning'>No cell detected!</span>")
	recharging = FALSE

// used only on the borg one, but here in case we invent inducer guns idk
/obj/item/inducer/proc/safety()
	if (failsafe)
		return 1
	else
		return 0

/obj/item/inducer/attack(mob/M, mob/user)
	return


/obj/item/inducer/attack_self(mob/user)
	if(opened && cell)
		user.visible_message("\The [user] removes \the [cell] from \the [src]!","<span class='notice'>You remove \the [cell].</span>")
		cell.update_icon()
		user.put_in_hands(cell)
		cell = null
		update_icon()


/obj/item/inducer/examine(mob/living/M)
	. = ..()
	var/obj/item/weapon/cell/MyC = get_cell()
	if(MyC)
		to_chat(M, "<span class='notice'>Its display shows: [MyC.percent()]%.</span>")
	else
		to_chat(M,"<span class='notice'>Its display is dark.</span>")
	if(opened)
		to_chat(M,"<span class='notice'>Its battery compartment is open.</span>")

/obj/item/inducer/on_update_icon()
	overlays.Cut()
	if(opened)
		if(!get_cell())
			overlays += image(icon, "inducer-nobat")
		else
			overlays += image(icon,"inducer-bat")

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

/obj/item/inducer/borg/attackby(obj/item/W, mob/user)
	if(isScrewdriver(W))
		return
	. = ..()

/obj/item/inducer/borg/on_update_icon()
	. = ..()
	overlays += image("icons/obj/guns/gui.dmi","safety[safety()]")

/obj/item/inducer/borg/verb/toggle_safety(var/mob/user)
	set src in usr
	set category = "Object"
	set name = "Toggle Inducer Safety"
	if (safety())
		failsafe = 0
	else
		failsafe = 0.2
	update_icon()
	if(user)
		to_chat(user, "<span class='notice'>You switch your battery output failsafe [safety() ? "on" : "off"	].</span>")

/obj/item/inducer/borg/get_cell()
	return loc ? loc.get_cell() : null