/obj/item/melee/whip
	name = "whip"
	desc = "A generic whip."
	icon = 'icons/obj/weapons/melee_physical.dmi'
	icon_state = "chain"
	item_state = "chain"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	force = 10
	throwforce = 7
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_COMBAT = 4)
	attack_verb = list("flicked", "whipped", "lashed")

/obj/item/melee/whip/abyssal
	name = "abyssal whip"
	desc = "A weapon from the abyss. Requires 70 attack to wield."
	icon_state = "whip"
	item_state = "whip"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	force = 16 //max hit with 60 strength and no equipment. Duel Arena no No forfeit - Snapshot
	throwforce = 7
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_COMBAT = 4)
	attack_verb = list("flicked", "whipped", "lashed")

/obj/item/melee/whip/tail
	name = "drake's tail"
	desc = "The tail of a large scaled creature, obviously evolved as some kind of whipping weapon. It's razor sharp and incredibly tough, though relatively lightweight."
	icon_state = "tailwhip"
	item_state = "whip"
	obj_flags = null
	force = 19
	edge = TRUE
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 5)

/obj/item/melee/whip/chainofcommand
	name = "chain of command"
	desc = "A tool used by great men to placate the frothing masses."
	attack_verb = list("flogged", "whipped", "lashed", "disciplined")
	icon_state = "chain"
	item_state = "whip"

/obj/item/material/sword/replica/officersword
	name = "fleet officer's sword"
	desc = "A polished sword issued to officers of the fleet."
	icon = 'icons/obj/weapons/melee_physical.dmi'
	icon_state = "officersword"
	item_state = "officersword"
	slot_flags = SLOT_BELT
	applies_material_colour = FALSE

/obj/item/material/sword/replica/officersword/pettyofficer
	name = "chief petty officer's cutlass"
	desc = "A polished cutlass issued to chief petty officers of the fleet."
	icon_state = "pettyofficersword"
	item_state = "pettyofficersword"

/obj/item/melee/powerfist/mounted
	icon_state = "powerfist"
	item_state = "powerfist"
	name = "hardsuit powerfist"
	icon = 'icons/obj/augment.dmi'
	desc = "Hardsuit gauntlet powered-up by servomotors. Capable of prying airlock open, but can't make people fly."
	base_parry_chance = 12
	force = 15
	attack_cooldown = SLOW_WEAPON_COOLDOWN
	hitsound = 'sound/effects/bang.ogg'
	attack_verb = list("smashed", "bludgeoned", "hammered", "battered")
	var/mob/living/creator

/obj/item/melee/powerfist/mounted/dropped()
	..()
	QDEL_IN(src, 0)


/obj/item/melee/powerfist/mounted/get_storage_cost()
	return ITEM_SIZE_NO_CONTAINER


/obj/item/melee/powerfist/mounted/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)


/obj/item/melee/powerfist/mounted/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()


/obj/item/melee/powerfist/mounted/attack_self(mob/user as mob)
	user.drop_from_inventory(src)


/obj/item/melee/powerfist/mounted/use_before(atom/target, mob/living/user, click_parameters)
	if (user.a_intent == I_HELP || !istype(target, /obj/machinery/door/airlock))
		return FALSE

	var/obj/machinery/door/airlock/A = target

	if (A.operating)
		return FALSE

	if (A.locked)
		to_chat(user, SPAN_WARNING("The airlock's bolts prevent it from being forced."))
		return TRUE

	if (A.welded)
		A.visible_message(SPAN_DANGER("\The [user] forces the fingers of \the [src] in through the welded metal, beginning to pry \the [A] open!"))
		if (do_after(user, 11 SECONDS, A, DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS) && !A.locked)
			A.welded = FALSE
			A.update_icon()
			playsound(A, 'sound/effects/bang.ogg', 100, 1)
			playsound(A, 'sound/machines/airlock_creaking.ogg', 100, 1)
			A.visible_message(SPAN_DANGER("\The [user] tears \the [A] open with \a [src]!"))
			addtimer(new Callback(A, /obj/machinery/door/airlock/.proc/open, TRUE), 0)
			A.set_broken(TRUE)
		return TRUE
	else
		A.visible_message(SPAN_DANGER("\The [user] pries the fingers of \a [src] in, beginning to force \the [A]!"))
		if ((MACHINE_IS_BROKEN(A) || !A.is_powered() || do_after(user, 8 SECONDS, A, DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS)) && !(A.operating || A.welded || A.locked))
			playsound(A, 'sound/machines/airlock_creaking.ogg', 100, 1)
			if (A.density)
				addtimer(new Callback(A, /obj/machinery/door/airlock/.proc/open, TRUE), 0)
				if(!MACHINE_IS_BROKEN(A) && A.is_powered())
					A.set_broken(TRUE)
				A.visible_message(SPAN_DANGER("\The [user] forces \the [A] open with \a [src]!"))
			else
				addtimer(new Callback(A, /obj/machinery/door/airlock/.proc/close, TRUE), 0)
				if (!MACHINE_IS_BROKEN(A) && A.is_powered())
					A.set_broken(TRUE)
				A.visible_message(SPAN_DANGER("\The [user] forces \the [A] closed with \a [src]!"))
		return TRUE
