/obj/item/weapon/implanter
	name = "implanter"
	icon = 'icons/obj/items.dmi'
	icon_state = "implanter0"
	item_state = "syringe_0"
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_SMALL
	var/obj/item/weapon/implant/imp = null

/obj/item/weapon/implanter/proc/update()
	if (src.imp)
		src.icon_state = "implanter1"
	else
		src.icon_state = "implanter0"
	return

/obj/item/weapon/implanter/verb/remove_implant()
	set category = "Object"
	set name = "Remove implant"
	set src in usr

	if(issilicon(usr))
		return

	if(can_use(usr))
		if(!imp)
			to_chat(usr, "<span class='notice'>There is no implant to remove.</span>")
			return
		imp.forceMove(get_turf(src))
		usr.put_in_hands(imp)
		to_chat(usr, "<span class='notice'>You remove \the [imp] from \the [src].</span>")
		name = "implanter"
		imp = null
		update()
		return
	else
		to_chat(usr, "<span class='notice'>You cannot do this in your current condition.</span>")

/obj/item/weapon/implanter/proc/can_use()

	if(!ismob(loc))
		return 0

	var/mob/M = loc

	if(M.incapacitated())
		return 0
	if((src in M.contents) || (istype(loc, /turf) && in_range(src, M)))
		return 1
	return 0

/obj/item/weapon/implanter/attack(mob/M as mob, mob/user as mob)
	if (!istype(M, /mob/living/carbon))
		return
	if (user && src.imp)
		M.visible_message("<span class='warning'>[user] is attemping to implant [M].</span>")

		user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
		user.do_attack_animation(M)

		var/turf/T1 = get_turf(M)
		if (T1 && ((M == user) || do_after(user, 50, M)))
			if(user && M && (get_turf(M) == T1) && src && src.imp)
				M.visible_message("<span class='warning'>[M] has been implanted by [user].</span>")

				admin_attack_log(user, M, "Implanted using \the [src.name] ([src.imp.name])", "Implanted with \the [src.name] ([src.imp.name])", "used an implanter, [src.name] ([src.imp.name]), on")

				if(src.imp.implanted(M))
					src.imp.loc = M
					src.imp.imp_in = M
					src.imp.implanted = 1
					if (ishuman(M))
						var/mob/living/carbon/human/H = M
						var/obj/item/organ/external/affected = H.get_organ(user.zone_sel.selecting)
						affected.implants += src.imp
						imp.part = affected

						BITSET(H.hud_updateflag, IMPLOYAL_HUD)

				src.imp = null
				update()

	return

/obj/item/weapon/implanter/loyalty
	name = "implanter-loyalty"

/obj/item/weapon/implanter/loyalty/New()
	src.imp = new /obj/item/weapon/implant/loyalty( src )
	..()
	update()
	return

/obj/item/weapon/implanter/explosive
	name = "implanter (E)"

/obj/item/weapon/implanter/explosive/New()
	src.imp = new /obj/item/weapon/implant/explosive( src )
	..()
	update()
	return

/obj/item/weapon/implanter/adrenalin
	name = "implanter-adrenalin"

/obj/item/weapon/implanter/adrenalin/New()
	src.imp = new /obj/item/weapon/implant/adrenalin(src)
	..()
	update()
	return

/obj/item/weapon/implanter/compressed
	name = "implanter (C)"
	icon_state = "cimplanter1"
	desc = "The matter compressor safety is on."
	var/safe = 1

/obj/item/weapon/implanter/compressed/New()
	imp = new /obj/item/weapon/implant/compressed( src )
	..()
	update()
	return

/obj/item/weapon/implanter/compressed/update()
	if (imp)
		var/obj/item/weapon/implant/compressed/c = imp
		if(!c.scanned)
			icon_state = "cimplanter1"
		else
			icon_state = "cimplanter2"
	else
		icon_state = "cimplanter0"
	return

/obj/item/weapon/implanter/compressed/attack(mob/M as mob, mob/user as mob)
	var/obj/item/weapon/implant/compressed/c = imp
	if (!c)	return
	if (c.scanned == null)
		to_chat(user, "Please compress an object with the implanter first.")
		return
	..()

/obj/item/weapon/implanter/compressed/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity)
		return
	if(istype(A,/obj/item) && imp)
		var/obj/item/weapon/implant/compressed/c = imp
		if (c.scanned)
			if (!istype(A,/obj/item/weapon/storage))
				to_chat(user, "<span class='warning'>Something is already compressed inside the implant!</span>")
			return
		else if(safe)
			if (!istype(A,/obj/item/weapon/storage))
				to_chat(user, "<span class='warning'>The matter compressor safeties prevent you from doing that.</span>")
			return
		c.scanned = A
		if(istype(A.loc,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = A.loc
			H.remove_from_mob(A)
		else if(istype(A.loc,/obj/item/weapon/storage))
			var/obj/item/weapon/storage/S = A.loc
			S.remove_from_storage(A)
		A.loc.contents.Remove(A)
		safe = 2
		desc = "It currently contains some matter."
		update()

/obj/item/weapon/implanter/compressed/attack_self(var/mob/user)
	if(!imp || safe == 2)
		return ..()

	safe = !safe
	to_chat(user, "<span class='notice'>You [safe ? "enable" : "disable"] the matter compressor safety.</span>")
	src.desc = "The matter compressor safety is [safe ? "on" : "off"]."