//
//        DOOR CHARGE
//

/obj/item/door_charge
	name = "door charge"
	desc = "This is a booby trap, planted on doors. When door opens, it will explode!."
	gender = PLURAL
	icon = 'mods/antagonists/icons/obj/door_charge.dmi'
	icon_state = "door_charge"
	item_state = "door_charge"
	item_flags = ITEM_FLAG_NO_BLUDGEON
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_ESOTERIC = 4)
	var/ready = 0

/obj/item/door_charge/use_after(atom/movable/target, mob/user)
	if (ismob(target) || !istype(target, /obj/machinery/door/airlock))
		return FALSE

	to_chat(user, "Planting explosives...")
	user.do_attack_animation(target)

	if(do_after(user, 50, target) && in_range(user, target))
		if(!user.unequip_item())
			return TRUE

		forceMove(target)

		log_and_message_admins("planted \a [src] on \the [target].")

		to_chat(user, "Bomb has been planted.")

		GLOB.density_set_event.register(target, src, .proc/explode)

	return TRUE


/obj/item/door_charge/proc/explode(obj/machinery/door/airlock/airlock)
	if(!airlock.density)
		explosion(get_turf(airlock), -1, 1, 2, 3)
		airlock.ex_act(1)
		qdel(src)

//
//        Uplink part
//

/datum/uplink_item/item/tools/door_charge
	name = "Door Charge"
	desc = "Special explosive, which can be planted on doors and will explode when somebody will open this door."
	item_cost = 14
	path = /obj/item/door_charge

//
//        BLUESPACE JAUNTER
//

/obj/item/device/syndietele
	name = "strange sensor"
	desc = "Looks like regular powernet sensor, but this one almost black and have spooky red light blinking"
	icon = 'mods/antagonists/icons/obj/syndiejaunter.dmi'
	icon_state = "beacon"
	item_state = "signaler"
	origin_tech = list(TECH_BLUESPACE = 4, TECH_ESOTERIC = 3)

	w_class = ITEM_SIZE_SMALL

/obj/item/device/syndiejaunter
	name = "strange device"
	desc = "This thing looks like remote. Almost black, with red button and status display."
	icon = 'mods/antagonists/icons/obj/syndiejaunter.dmi'
	icon_state = "jaunter"
	item_state = "jaunter"
	w_class = ITEM_SIZE_SMALL
	var/obj/item/device/syndietele/beacon
	var/usable = 1
	var/image/cached_usable

/obj/item/device/syndiejaunter/examine(mob/user, distance)
	. = ..()
	to_chat(user, SPAN_NOTICE("Display is [usable ? "online and shows number [usable]" : "offline"]."))
/obj/item/device/syndiejaunter/Initialize()
	. = ..()
	update_icon()

/obj/item/device/syndiejaunter/on_update_icon()
	. = ..()
	if(usable)
		AddOverlays(image(icon, "usable"))
	else
		ClearOverlays()

/obj/item/device/syndiejaunter/attack_self(mob/user)
	if(!istype(beacon) || !usable)
		return 0

	animated_teleportation(user, beacon)
	usable = max(usable - 1, 0)
	update_icon()

/obj/item/device/syndiejaunter/use_after(atom/target, mob/user)
	if(istype(target,/obj/item/device/syndietele))
		beacon = target
		to_chat(user, "You succesfully linked [src] to [target]!")
	else
		to_chat(user, "You can't link [src] to [target]!")
	update_icon()

//
//        Uplink part
//

/obj/item/storage/box/syndie_kit/jaunter
	startswith = list(/obj/item/device/syndietele,
					  /obj/item/device/syndiejaunter)

/datum/uplink_item/item/tools/jaunter
	name = "Bluespace Jaunter"
	item_cost = 42
	path = /obj/item/storage/box/syndie_kit/jaunter
	desc = "Disposable one way teleportation device. Use with care. Don't forget to link jaunter to the beacon!"


//
//        Psi Amp - Uplink part (Here because turned off by Bay12)
//

/datum/uplink_item/item/visible_weapons/psi_amp
	name = "Cerebroenergetic Psionic Amplifier"
	item_cost = 50
	path = /obj/item/clothing/head/helmet/space/psi_amp/lesser
	desc = "A powerful, illegal psi-amp. Boosts latent psi-faculties to extremely high levels."
