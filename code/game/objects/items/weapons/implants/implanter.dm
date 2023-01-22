/obj/item/implanter
	name = "implanter"
	icon = 'icons/obj/items.dmi'
	icon_state = "implanter0"
	item_state = "syringe_0"
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_SMALL
	matter = list(MATERIAL_ALUMINIUM = 1000, MATERIAL_GLASS = 1000)
	var/obj/item/implant/imp = null

/obj/item/implanter/New()
	if(ispath(imp))
		imp = new imp(src)
	..()
	update_icon()

/obj/item/implanter/on_update_icon()
	if (imp)
		icon_state = "implanter1"
	else
		icon_state = "implanter0"

/obj/item/implanter/proc/can_use()

	if(!ismob(loc))
		return 0

	var/mob/M = loc

	if(M.incapacitated())
		return 0
	if((src in M.contents) || (istype(loc, /turf) && in_range(src, M)))
		return 1
	return 0

/obj/item/implanter/attackby(obj/item/I, mob/user)
	if(!imp && istype(I, /obj/item/implant) && user.unEquip(I,src))
		to_chat(usr, "<span class='notice'>You slide \the [I] into \the [src].</span>")
		imp = I
		update_icon()
	else
		..()

/obj/item/implanter/attack(mob/M as mob, mob/user as mob)
	if (!istype(M, /mob/living/carbon))
		return
	if (user && src.imp)
		M.visible_message("<span class='warning'>[user] is attemping to implant [M].</span>")

		user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
		user.do_attack_animation(M)

		var/target_zone = user.zone_sel.selecting
		if(src.imp.can_implant(M, user, target_zone))
			var/imp_name = imp.name

			if(do_after(user, 5 SECONDS, M, DO_EQUIP) && src.imp?.implant_in_mob(M, target_zone))
				M.visible_message("<span class='warning'>[M] has been implanted by [user].</span>")
				admin_attack_log(user, M, "Implanted using \the [src] ([imp_name])", "Implanted with \the [src] ([imp_name])", "used an implanter, \the [src] ([imp_name]), on")

				src.imp = null
				update_icon()

	return
