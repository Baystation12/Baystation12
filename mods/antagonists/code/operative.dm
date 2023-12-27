///Ninja equipment loadouts. Placed here because author overrided them using Torch files. Now we overriding this again for some QoL stuff.
/obj/structure/closet/crate/ninja/sol
	name = "sol equipment crate"
	desc = "A tactical equipment crate."

/obj/structure/closet/crate/ninja/sol/WillContain()
	return list(
		/obj/item/rig/light/ninja/sol,
		/obj/item/gun/projectile/pistol/m22f,
		/obj/item/ammo_magazine/pistol/double = 2,
		/obj/item/clothing/under/scga/utility/urban,
		/obj/item/clothing/shoes/swat,
		/obj/item/clothing/accessory/scga_rank/e6,
		/obj/item/device/encryptionkey/away_scg_patrol
	)

/obj/structure/closet/crate/ninja/gcc
	name = "gcc equipment crate"
	desc = "A heavy equipment crate."

/obj/structure/closet/crate/ninja/gcc/WillContain()
	return list(
		/obj/item/rig/light/ninja/gcc,
		/obj/item/rig_module/mounted/power_fist,
		/obj/item/gun/projectile/pistol/optimus,
		/obj/item/ammo_magazine/pistol/double = 2,
		/obj/item/ammo_magazine/box/minigun = 2,
		/obj/item/clothing/under/iccgn/utility,
		/obj/item/clothing/shoes/iccgn/utility,
		/obj/item/clothing/accessory/iccgn_rank/or6,
		/obj/item/device/encryptionkey/iccgn
	)

/obj/structure/closet/crate/ninja/corpo
	name = "corporate equipment crate"
	desc = "A patented equipment crate."

/obj/structure/closet/crate/ninja/corpo/WillContain()
	return list(
		/obj/item/rig/light/ninja/corpo,
		/obj/item/gun/energy/gun,
		/obj/item/inducer,
		/obj/item/clothing/under/rank/security/corp,
		/obj/item/clothing/shoes/swat,
		/obj/item/clothing/accessory/badge/holo,
		/obj/item/storage/box/syndie_kit/jaunter
	)

/obj/structure/closet/crate/ninja/merc
	name = "mercenary equipment crate"
	desc = "A traitorous equipment crate."

/obj/structure/closet/crate/ninja/merc/WillContain()
	return list(
		/obj/item/rig/merc/ninja,
		/obj/item/gun/projectile/revolver/medium,
		/obj/item/ammo_magazine/speedloader = 2,
		/obj/item/clothing/under/syndicate/combat,
		/obj/item/clothing/shoes/swat,
		/obj/item/clothing/mask/gas/syndicate,
		/obj/item/storage/backpack/dufflebag/syndie_kit/plastique,
		/obj/item/storage/box/anti_photons,
		/obj/item/device/encryptionkey/syndicate,
		/obj/item/card/emag
	)

// Powerfist item

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

// Powerfist module

/obj/item/rig_module/mounted/power_fist

	name = "hand-mounted powerfists"
	desc = "A pair of heavy powerfists to be installed into a hardsuit gauntlets."
	icon_state = "module"

	suit_overlay_active = null

	activate_string = "Power up Fist"
	deactivate_string = "Power off Fist"

	interface_name = "hand-mounted powerfists"
	interface_desc = "A pair of heavy powerfists to be installed into a hardsuit gauntlets."

	usable = 0
	selectable = 0
	toggleable = 1
	use_power_cost = 10 KILOWATTS
	active_power_cost = 5 KILOWATTS
	passive_power_cost = 0

/obj/item/rig_module/mounted/power_fist/Process()

	if(holder && holder.wearer)
		if(!(locate(/obj/item/melee/powerfist/mounted) in holder.wearer))
			deactivate()
			return 0

	return ..()

/obj/item/rig_module/mounted/power_fist/activate()
	var/mob/living/M = holder.wearer

	if (!M.HasFreeHand())
		to_chat(M, SPAN_DANGER("Your hands are full."))
		deactivate()
		return

	var/obj/item/melee/powerfist/mounted/blade = new(M)
	M.put_in_hands(blade)

	if(!..())
		return 0

/obj/item/rig_module/mounted/power_fist/deactivate()

	..()

	var/mob/living/M = holder.wearer

	if(!M)
		return

	for(var/obj/item/melee/powerfist/mounted/blade in M.contents)
		qdel(blade)
