//replaces our stun baton code with /tg/station's code
/obj/item/melee/baton
	icon = 'icons/obj/weapons/melee_physical.dmi'
	name = "stunbaton"
	desc = "A stun baton for incapacitating people with."
	icon_state = "stunbaton"
	item_state = "baton"
	slot_flags = SLOT_BELT
	force = 15
	throwforce = 7
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_COMBAT = 2)
	attack_verb = list("beat", "whacked")
	base_parry_chance = 30
	attack_ignore_harm_check = TRUE
	var/stunforce = 0
	var/agonyforce = 30
	var/status = 0		//whether the thing is on or not
	var/obj/item/cell/bcell
	var/hitcost = 7

/obj/item/melee/baton/loaded
	bcell = /obj/item/cell/device/high

/obj/item/melee/baton/New()
	if(ispath(bcell))
		bcell = new bcell(src)
		update_icon()
	..()

/obj/item/melee/baton/Destroy()
	if(bcell && !ispath(bcell))
		qdel(bcell)
		bcell = null
	return ..()

/obj/item/melee/baton/get_cell()
	return bcell

/obj/item/melee/baton/proc/update_status()
	if(bcell.charge < hitcost)
		status = 0
		update_icon()

/obj/item/melee/baton/proc/deductcharge(chrgdeductamt)
	if(bcell)
		if(bcell.checked_use(chrgdeductamt))
			update_status()
			return 1
		else
			status = 0
			update_icon()
			return 0
	return null

/obj/item/melee/baton/on_update_icon()
	if(status)
		icon_state = "[initial(name)]_active"
	else if(!bcell)
		icon_state = "[initial(name)]_nocell"
	else
		icon_state = "[initial(name)]"

	if(icon_state == "[initial(name)]_active")
		set_light(1.5, 2, "#ff6a00")
	else
		set_light(0)

/obj/item/melee/baton/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		examine_cell(user)

// Addition made by Techhead0, thanks for fullfilling the todo!
/obj/item/melee/baton/proc/examine_cell(mob/user)
	if(bcell)
		to_chat(user, SPAN_NOTICE("The baton is [round(bcell.percent())]% charged."))
	if(!bcell)
		to_chat(user, SPAN_WARNING("The baton does not have a power source installed."))

/obj/item/melee/baton/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/cell/device))
		if(!bcell && user.unEquip(W))
			W.forceMove(src)
			bcell = W
			to_chat(user, SPAN_NOTICE("You install a cell into the [src]."))
			update_icon()
		else
			to_chat(user, SPAN_NOTICE("[src] already has a cell."))
	else if(isScrewdriver(W))
		if(bcell)
			bcell.update_icon()
			bcell.dropInto(loc)
			bcell = null
			to_chat(user, SPAN_NOTICE("You remove the cell from the [src]."))
			status = 0
			update_icon()
	else
		..()

/obj/item/melee/baton/attack_self(mob/user)
	set_status(!status, user)
	add_fingerprint(user)

/obj/item/melee/baton/throw_impact(atom/hit_atom, datum/thrownthing/TT)
	if(istype(hit_atom,/mob/living))
		apply_hit_effect(hit_atom, hit_zone = ran_zone(TT.target_zone, 30))//more likely to hit the zone you target!
	else
		..()

/obj/item/melee/baton/proc/set_status(newstatus, mob/user)
	if(bcell && bcell.charge >= hitcost)
		if(status != newstatus)
			change_status(newstatus)
			to_chat(user, SPAN_NOTICE("[src] is now [status ? "on" : "off"]."))
			playsound(loc, "sparks", 75, 1, -1)
	else
		change_status(0)
		if(!bcell)
			to_chat(user, SPAN_WARNING("[src] does not have a power source!"))
		else
			to_chat(user,  SPAN_WARNING("[src] is out of charge."))

// Proc to -actually- change the status, and update the icons as well.
// Also exists to ease "helpful" admin-abuse in case an bug prevents attack_self
// to occur would appear. Hopefully it wasn't necessary.
/obj/item/melee/baton/proc/change_status(s)
	if (status != s)
		status = s
		update_icon()

/obj/item/melee/baton/use_before(mob/M, mob/user)
	. = FALSE
	if (!istype(M))
		return FALSE
	if (status && (MUTATION_CLUMSY in user.mutations) && prob(50))
		to_chat(user, SPAN_DANGER("You accidentally hit yourself with the [src]!"))
		user.Weaken(30)
		deductcharge(hitcost)
		return TRUE
	if (user.a_intent != I_HURT) //If not harm-batonning; bypass use_weapon entirely and just apply stun effect. Set cooldowns since bypassing use_weapon.
		user.setClickCooldown(user.get_attack_speed(src))
		user.do_attack_animation(M)
		apply_hit_effect(M, user, user.zone_sel? user.zone_sel.selecting : ran_zone())
		return TRUE

/obj/item/melee/baton/apply_hit_effect(mob/living/target, mob/living/user, hit_zone)
	if(isrobot(target))
		return ..()

	var/agony = agonyforce
	var/stun = stunforce
	var/obj/item/organ/external/affecting = null
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		affecting = H.get_organ(hit_zone)
	var/abuser =  user ? "" : "by \the [user]"
	if (user && user.a_intent == I_HURT)
		if (!..())
			return FALSE

		//whacking someone causes a much poorer electrical contact than deliberately prodding them.
		stun *= 0.5
		if (status)		//Checks to see if the stunbaton is on.
			agony *= 0.5	//whacking someone causes a much poorer contact than prodding them.
		else
			agony = 0	//Shouldn't really stun if it's off, should it?
		//we can't really extract the actual hit zone from ..(), unfortunately. Just act like they attacked the area they intended to.
	else if (!status)
		if (affecting)
			target.visible_message(SPAN_WARNING("\The [target] has been prodded in the \the [affecting.name] with \the [src][abuser]. Luckily \the [src] was off."))
		else
			target.visible_message(SPAN_WARNING("\The [target] has been prodded with \the[src][abuser]. Luckily \the [src] was off."))
	else
		if (affecting)
			target.visible_message(SPAN_DANGER("\The [target] has been prodded in the \the [affecting.name] with \the [src]!"))
		else
			target.visible_message(SPAN_DANGER("\The [target] has been prodded with \the [src][abuser]!"))
		playsound(loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)

	//stun effects
	if (status)
		target.stun_effect_act(stun, agony, hit_zone, src)
		msg_admin_attack("[key_name(user)] stunned [key_name(target)] with the [src].")
		deductcharge(hitcost)

		if (ishuman(target))
			var/mob/living/carbon/human/H = target
			H.forcesay(GLOB.hit_appends)
	return TRUE

/obj/item/melee/baton/emp_act(severity)
	if(bcell)
		bcell.emp_act(severity)	//let's not duplicate code everywhere if we don't have to please.
	..()

// Stunbaton module for Security synthetics
/obj/item/melee/baton/robot
	bcell = null
	hitcost = 20
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_NO_TOOLS

// Addition made by Techhead0, thanks for fullfilling the todo!
/obj/item/melee/baton/robot/examine_cell(mob/user)
	to_chat(user, SPAN_NOTICE("The baton is running off an external power supply."))

// Override proc for the stun baton module, found in PC Security synthetics
// Refactored to fix #14470 - old proc defination increased the hitcost beyond
// usability without proper checks.
// Also hard-coded to be unuseable outside their righteous synthetic owners.
/obj/item/melee/baton/robot/attack_self(mob/user)
	var/mob/living/silicon/robot/R = isrobot(user) ? user : null // null if the user is NOT a robot
	update_cell(R) // takes both robots and null
	if (R)
		return ..()
	else	// Stop pretending and get out of your cardborg suit, human.
		to_chat(user, SPAN_WARNING("You don't seem to be able interacting with this by yourself.."))
		add_fingerprint(user)
	return 0

/obj/item/melee/baton/robot/apply_hit_effect(mob/living/target, mob/living/user, hit_zone)
	update_cell(isrobot(user) ? user : null) // update the status before we apply the effects
	return ..()

// Updates the baton's cell to use user's own cell
// Otherwise, if null (when the user isn't a robot), render it unuseable
/obj/item/melee/baton/robot/proc/update_cell(mob/living/silicon/robot/user)
	if (!user)
		bcell = null
		set_status(0)
	else if (!bcell || bcell != user.cell)
		bcell = user.cell // if it is null, nullify it anyway

// Traitor variant for Engineering synthetics.
/obj/item/melee/baton/robot/electrified_arm
	name = "electrified arm"
	icon = 'icons/obj/gripper.dmi'
	icon_state = "electrified_arm"

/obj/item/melee/baton/robot/electrified_arm/on_update_icon()
	if(status)
		icon_state = "electrified_arm_active"
		set_light(1.5, 2, "#006aff")
	else
		icon_state = "electrified_arm"
		set_light(0)

//Makeshift stun baton. Replacement for stun gloves.
/obj/item/melee/baton/cattleprod
	name = "stunprod"
	desc = "An improvised stun baton."
	icon = 'icons/obj/weapons/melee_physical.dmi'
	icon_state = "stunprod_nocell"
	item_state = "prod"
	force = 3
	throwforce = 5
	stunforce = 0
	agonyforce = 60	//same force as a stunbaton, but uses way more charge.
	hitcost = 25
	attack_verb = list("poked")
	slot_flags = null
