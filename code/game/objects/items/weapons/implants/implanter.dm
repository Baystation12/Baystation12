/obj/item/weapon/implanter
	name = "implanter"
	icon = 'icons/obj/items.dmi'
	icon_state = "implanter0"
	item_state = "syringe_0"
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_SMALL
	var/obj/item/weapon/implant/imp = null

/obj/item/weapon/implanter/New()
	if(ispath(imp))
		imp = new imp(src)
	..()
	update_icon()

/obj/item/weapon/implanter/update_icon()
	if (imp)
		icon_state = "implanter1"
	else
		icon_state = "implanter0"

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
		update_icon()
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

/obj/item/weapon/implanter/attackby(obj/item/weapon/I, mob/user)
	if(!imp && istype(I, /obj/item/weapon/implant))
		to_chat(usr, "<span class='notice'>You slide \the [I] into \the [src].</span>")
		user.drop_from_inventory(I,src)
		imp = I
		update_icon()
	else
		..()

/obj/item/weapon/implanter/attack(mob/M as mob, mob/user as mob)
	if (!istype(M, /mob/living/carbon))
		return
	if (user && src.imp)
		M.visible_message("<span class='warning'>[user] is attemping to implant [M].</span>")

		user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
		user.do_attack_animation(M)

		var/target_zone = user.zone_sel.selecting
		if(src.imp.can_implant(M, user, target_zone))
			if(do_after(user, 50, M) && src.imp.implant_in_mob(M, target_zone))
				M.visible_message("<span class='warning'>[M] has been implanted by [user].</span>")
				admin_attack_log(user, M, "Implanted using \the [src.name] ([src.imp.name])", "Implanted with \the [src.name] ([src.imp.name])", "used an implanter, [src.name] ([src.imp.name]), on")

				src.imp = null
				update_icon()

	return

/obj/item/weapon/implanter/loyalty
	name = "implanter-loyalty"
	imp = /obj/item/weapon/implant/loyalty

/obj/item/weapon/implanter/explosive
	name = "implanter (E)"
	imp = /obj/item/weapon/implant/explosive

/obj/item/weapon/implanter/adrenalin
	name = "implanter-adrenalin"
	imp = /obj/item/weapon/implant/adrenalin

/obj/item/weapon/implanter/freedom
	name = "implanter (F)"
	imp = /obj/item/weapon/implant/freedom

/obj/item/weapon/implanter/uplink
	name = "implanter (U)"
	imp = /obj/item/weapon/implant/uplink

/obj/item/weapon/implanter/compressed
	name = "implanter (C)"
	icon_state = "cimplanter1"
	desc = "The matter compressor safety is on."
	var/safe = 1
	imp = /obj/item/weapon/implant/compressed

/obj/item/weapon/implanter/compressed/update_icon()
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
		update_icon()

/obj/item/weapon/implanter/compressed/attack_self(var/mob/user)
	if(!imp || safe == 2)
		return ..()

	safe = !safe
	to_chat(user, "<span class='notice'>You [safe ? "enable" : "disable"] the matter compressor safety.</span>")
	src.desc = "The matter compressor safety is [safe ? "on" : "off"]."