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
	w_class = 3
	origin_tech = "combat=2"
	attack_verb = list("beaten")
	var/stunforce = 0
	var/agonyforce = 60
	var/status = 0		//whether the thing is on or not
	var/obj/item/weapon/cell/bcell = null
	var/hitcost = 1000	//oh god why do power cells carry so much charge? We probably need to make a distinction between "industrial" sized power cells for APCs and power cells for everything else.

/obj/item/weapon/melee/baton/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is putting the live [name] in \his mouth! It looks like \he's trying to commit suicide.</span>")
	return (FIRELOSS)

/obj/item/weapon/melee/baton/New()
	..()
	update_icon()
	return

/obj/item/weapon/melee/baton/loaded/New() //this one starts with a cell pre-installed.
	..()
	bcell = new/obj/item/weapon/cell/high(src)
	update_icon()
	return

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

/obj/item/weapon/melee/baton/examine(mob/user)
	if(!..(user, 1))
		return

	if(bcell)
		user <<"<span class='notice'>The baton is [round(bcell.percent())]% charged.</span>"
	if(!bcell)
		user <<"<span class='warning'>The baton does not have a power source installed.</span>"

/obj/item/weapon/melee/baton/attackby(obj/item/weapon/W, mob/user)
	if(istype(W, /obj/item/weapon/cell))
		if(!bcell)
			user.drop_item()
			W.loc = src
			bcell = W
			user << "<span class='notice'>You install a cell in [src].</span>"
			update_icon()
		else
			user << "<span class='notice'>[src] already has a cell.</span>"

	else if(istype(W, /obj/item/weapon/screwdriver))
		if(bcell)
			bcell.update_icon()
			bcell.loc = get_turf(src.loc)
			bcell = null
			user << "<span class='notice'>You remove the cell from the [src].</span>"
			status = 0
			update_icon()
			return
		..()
	return

/obj/item/weapon/melee/baton/attack_self(mob/user)
	if(bcell && bcell.charge > hitcost)
		status = !status
		user << "<span class='notice'>[src] is now [status ? "on" : "off"].</span>"
		playsound(loc, "sparks", 75, 1, -1)
		update_icon()
	else
		status = 0
		if(!bcell)
			user << "<span class='warning'>[src] does not have a power source!</span>"
		else
			user << "<span class='warning'>[src] is out of charge.</span>"
	add_fingerprint(user)


/obj/item/weapon/melee/baton/attack(mob/M, mob/user)
	if(status && (CLUMSY in user.mutations) && prob(50))
		user << "span class='danger'>You accidentally hit yourself with the [src]!</span>"
		user.Weaken(30)
		deductcharge(hitcost)
		return

	if(isrobot(M))
		..()
		return

	var/agony = agonyforce
	var/stun = stunforce
	var/mob/living/L = M

	var/target_zone = check_zone(user.zone_sel.selecting)
	if(user.a_intent == I_HURT)
		if (!..())	//item/attack() does it's own messaging and logs
			return 0	// item/attack() will return 1 if they hit, 0 if they missed.
		agony *= 0.5	//whacking someone causes a much poorer contact than prodding them.
		stun *= 0.5
		//we can't really extract the actual hit zone from ..(), unfortunately. Just act like they attacked the area they intended to.
	else
		//copied from human_defense.dm - human defence code should really be refactored some time.
		if (ishuman(L))
			user.lastattacked = L	//are these used at all, if we have logs?
			L.lastattacker = user

			if (user != L) // Attacking yourself can't miss
				target_zone = get_zone_with_miss_chance(user.zone_sel.selecting, L)

			if(!target_zone)
				L.visible_message("\red <B>[user] misses [L] with \the [src]!")
				return 0

			var/mob/living/carbon/human/H = L
			var/obj/item/organ/external/affecting = H.get_organ(target_zone)
			if (affecting)
				if(!status)
					L.visible_message("<span class='warning'>[L] has been prodded in the [affecting.name] with [src] by [user]. Luckily it was off.</span>")
					return 1
				else
					H.visible_message("<span class='danger'>[L] has been prodded in the [affecting.name] with [src] by [user]!</span>")
		else
			if(!status)
				L.visible_message("<span class='warning'>[L] has been prodded with [src] by [user]. Luckily it was off.</span>")
				return 1
			else
				L.visible_message("<span class='danger'>[L] has been prodded with [src] by [user]!</span>")

	//stun effects
	L.stun_effect_act(stun, agony, target_zone, src)

	playsound(loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)
	msg_admin_attack("[key_name(user)] stunned [key_name(L)] with the [src].")

	deductcharge(hitcost)

	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		H.forcesay(hit_appends)

	return 1

/obj/item/weapon/melee/baton/emp_act(severity)
	if(bcell)
		bcell.emp_act(severity)	//let's not duplicate code everywhere if we don't have to please.
	..()

//secborg stun baton module
/obj/item/weapon/melee/baton/robot/attack_self(mob/user)
	//try to find our power cell
	var/mob/living/silicon/robot/R = loc
	if (istype(R))
		bcell = R.cell
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
	hitcost = 2500
	attack_verb = list("poked")
	slot_flags = null
