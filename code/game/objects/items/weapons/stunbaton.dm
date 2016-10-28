//replaces our stun baton code with /tg/station's code
/obj/item/weapon/melee/baton
	name = "stunbaton"
	desc = "A stun baton for incapacitating people with."
	icon_state = "stunbaton"
	item_state = "baton"
	slot_flags = SLOT_BELT
	force = 15
	sharp = 0
	edge = 0
	throwforce = 7
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_COMBAT = 2)
	attack_verb = list("beaten")
	var/stunforce = 0
	var/agonyforce = 60
	var/status = 0		//whether the thing is on or not
	var/obj/item/weapon/cell/bcell
	var/hitcost = 10

/obj/item/weapon/melee/baton/loaded
	bcell = /obj/item/weapon/cell/device/high

/obj/item/weapon/melee/baton/New()
	if(ispath(bcell))
		bcell = new bcell(src)
		update_icon()
	..()

/obj/item/weapon/melee/baton/Destroy()
	if(bcell && !ispath(bcell))
		qdel(bcell)
		bcell = null
	return ..()

/obj/item/weapon/melee/baton/proc/deductcharge(var/chrgdeductamt)
	if(bcell)
		if(bcell.checked_use(chrgdeductamt))
			return 1
		else
			status = 0
			update_icon()
			return 0
	return null

/obj/item/weapon/melee/baton/update_icon()
	if(status)
		icon_state = "[initial(name)]_active"
	else if(!bcell)
		icon_state = "[initial(name)]_nocell"
	else
		icon_state = "[initial(name)]"

	if(icon_state == "[initial(name)]_active")
		set_light(1.5, 2, "#FF6A00")
	else
		set_light(0)

/obj/item/weapon/melee/baton/examine(mob/user)
	if(!..(user, 1))
		return

	if(bcell)
		to_chat(user, "<span class='notice'>The baton is [round(bcell.percent())]% charged.</span>")
	if(!bcell)
		to_chat(user, "<span class='warning'>The baton does not have a power source installed.</span>")

/obj/item/weapon/melee/baton/attackby(obj/item/weapon/W, mob/user)
	if(istype(W, /obj/item/weapon/cell/device))
		if(!bcell && user.unEquip(W))
			W.forceMove(src)
			bcell = W
			to_chat(user, "<span class='notice'>You install a cell into the [src].</span>")
			update_icon()
		else
			to_chat(user, "<span class='notice'>[src] already has a cell.</span>")
	else if(istype(W, /obj/item/weapon/screwdriver))
		if(bcell)
			bcell.update_icon()
			bcell.dropInto(loc)
			bcell = null
			to_chat(user, "<span class='notice'>You remove the cell from the [src].</span>")
			status = 0
			update_icon()
	else
		..()

/obj/item/weapon/melee/baton/attack_self(mob/user)
	set_status(!status, user)
	add_fingerprint(user)

/obj/item/weapon/melee/baton/proc/set_status(var/newstatus, mob/user)
	if(bcell && bcell.charge > hitcost)
		if(status != newstatus)
			status = newstatus
			to_chat(user, "<span class='notice'>[src] is now [status ? "on" : "off"].</span>")
			playsound(loc, "sparks", 75, 1, -1)
			update_icon()
	else
		status = 0
		if(!bcell)
			to_chat(user, "<span class='warning'>[src] does not have a power source!</span>")
		else
			to_chat(user,  "<span class='warning'>[src] is out of charge.</span>")
/obj/item/weapon/melee/baton/attack(mob/M, mob/user)
	if(status && (CLUMSY in user.mutations) && prob(50))
		to_chat(user, "<span class='danger'>You accidentally hit yourself with the [src]!</span>")
		user.Weaken(30)
		deductcharge(hitcost)
		return
	return ..()

/obj/item/weapon/melee/baton/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	if(isrobot(target))
		return ..()

	var/agony = agonyforce
	var/stun = stunforce
	var/obj/item/organ/external/affecting = null
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		affecting = H.get_organ(hit_zone)

	if(user.a_intent == I_HURT || user.a_intent == I_DISARM)
		. = ..()
		if (!.)	//item/attack() does it's own messaging and logs
			return 0	// item/attack() will return 1 if they hit, 0 if they missed.

		//whacking someone causes a much poorer electrical contact than deliberately prodding them.
		stun *= 0.5
		if(status)		//Checks to see if the stunbaton is on.
			agony *= 0.5	//whacking someone causes a much poorer contact than prodding them.
		else
			agony = 0	//Shouldn't really stun if it's off, should it?
		//we can't really extract the actual hit zone from ..(), unfortunately. Just act like they attacked the area they intended to.
	else if(!status)
		if(affecting)
			target.visible_message("<span class='warning'>[target] has been prodded in the [affecting.name] with [src] by [user]. Luckily it was off.</span>")
		else
			target.visible_message("<span class='warning'>[target] has been prodded with [src] by [user]. Luckily it was off.</span>")
	else
		if(affecting)
			target.visible_message("<span class='danger'>[target] has been prodded in the [affecting.name] with [src] by [user]!</span>")
		else
			target.visible_message("<span class='danger'>[target] has been prodded with [src] by [user]!</span>")
		playsound(loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)

	//stun effects
	if(status)
		target.stun_effect_act(stun, agony, hit_zone, src)
		msg_admin_attack("[key_name(user)] stunned [key_name(target)] with the [src].")

		deductcharge(hitcost)

		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			H.forcesay(hit_appends)

	return 0

/obj/item/weapon/melee/baton/emp_act(severity)
	if(bcell)
		bcell.emp_act(severity)	//let's not duplicate code everywhere if we don't have to please.
	..()

//secborg stun baton module
/obj/item/weapon/melee/baton/robot/attack_self(mob/user)
	//try to find our power cell
	var/mob/living/silicon/robot/R = loc
	if (istype(R))
		if(bcell && bcell != R.cell)
			bcell.dropInto(loc)
		bcell = R.cell
		hitcost = hitcost * 10
	return ..()

/obj/item/weapon/melee/baton/robot/attackby(obj/item/weapon/W, mob/user)
	return

//Makeshift stun baton. Replacement for stun gloves.
/obj/item/weapon/melee/baton/cattleprod
	name = "stunprod"
	desc = "An improvised stun baton."
	icon_state = "stunprod_nocell"
	item_state = "prod"
	force = 3
	throwforce = 5
	stunforce = 0
	agonyforce = 60	//same force as a stunbaton, but uses way more charge.
	hitcost = 25
	attack_verb = list("poked")
	slot_flags = null
