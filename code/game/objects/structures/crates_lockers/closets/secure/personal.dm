/obj/structure/closet/secure_closet/personal
	name = "personal closet"
	desc = "It's a secure locker for personnel. The first card swiped gains control."
	req_access = list(access_all_personal_lockers)
	var/registered_name = null

/obj/structure/closet/secure_closet/personal/WillContain()
	return list(
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack, /obj/item/weapon/storage/backpack/satchel_norm)),
		/obj/item/device/radio/headset
	)

/obj/structure/closet/secure_closet/personal/empty/WillContain()
	return

/obj/structure/closet/secure_closet/personal/patient
	name = "patient's closet"
/obj/structure/closet/secure_closet/personal/patient/WillContain()
	return

/obj/structure/closet/secure_closet/personal/cabinet
	icon_state = "cabinetdetective"
	icon_closed = "cabinetdetective"
	icon_locked = "cabinetdetective_locked"
	icon_opened = "cabinetdetective_open"
	icon_broken = "cabinetdetective_broken"
	icon_off = "cabinetdetective_broken"

/obj/structure/closet/secure_closet/personal/cabinet/WillContain()
	return list(/obj/item/weapon/storage/backpack/satchel/withwallet, /obj/item/device/radio/headset)

/obj/structure/closet/secure_closet/personal/attackby(var/obj/item/weapon/W, var/mob/user)
	if (src.opened)
		..()
	else if(W.GetIdCard())
		var/obj/item/weapon/card/id/I = W.GetIdCard()

		if(!I || !I.registered_name)
			return
		if(togglelock(user, I))
			if(!src.registered_name)
				src.registered_name = I.registered_name
				src.name += " ([I.registered_name])"
				src.desc = "Owned by [I.registered_name]."
		else
			to_chat(user, "<span class='warning'>Access Denied</span>")
	else
		..()

/obj/structure/closet/secure_closet/personal/CanToggleLock(var/mob/user, var/obj/item/weapon/card/id/id_card)
	return ..() || (istype(id_card) && id_card.registered_name && (!registered_name || (registered_name == id_card.registered_name)))

/obj/structure/closet/secure_closet/personal/verb/reset()
	set src in oview(1) // One square distance
	set category = "Object"
	set name = "Reset Lock"
	if(!CanPhysicallyInteract(usr)) // Don't use it if you're not able to! Checks for stuns, ghost and restrain
		return
	if(ishuman(usr))
		src.add_fingerprint(usr)
		if (src.locked || !src.registered_name)
			to_chat(usr, "<span class='warning'>You need to unlock it first.</span>")
		else if (src.broken)
			to_chat(usr, "<span class='warning'>It appears to be broken.</span>")
		else
			if (src.opened)
				if(!src.close())
					return
			src.locked = 1
			src.icon_state = src.icon_locked
			src.registered_name = null
			src.name = initial(name)
			src.desc = initial(desc)
