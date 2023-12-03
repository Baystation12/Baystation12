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

//
//        HOLOBOMBS
//

/obj/item/device/holobomb
	name = "holobomb"
	desc = "A small explosive charge with a holoprojector designed to disable the curious guards."
	icon = 'mods/antagonists/icons/obj/holobomb.dmi'
	icon_state = "minibomb"
	item_state = "nothing"
	slot_flags = SLOT_EARS
	w_class = ITEM_SIZE_SMALL
	var/active = FALSE
	var/mode = 0

/obj/item/device/holobomb/afterattack(obj/item/target, mob/user , proximity)
	if(!proximity)
		return
	if(!target)
		return
	if(target.w_class <= w_class)
		name = target.name
		desc = target.desc
		icon = target.icon
		color = target.color
		icon_state = target.icon_state
		active = TRUE
		to_chat(user, "\The [src] is now active.")
		playsound(get_turf(src), 'sound/weapons/flash.ogg', 100, 1, -6)
		update_icon()
	else
		to_chat(user, "\The [target] is too big for \the [src] hologramm")

/obj/item/device/holobomb/attack_self(mob/user)
	trigger(user)

/obj/item/device/holobomb/emp_act()
	..()
	trigger()

/obj/item/device/holobomb/attack_hand(mob/user)
	. = ..()
	if(!mode)
		trigger(user)

/obj/item/device/holobomb/proc/switch_mode(mob/user)
	mode = !mode
	if(mode)
		to_chat(user, "Mode 1.Now \the [src] will explode upon activation.")
	else
		to_chat(user, "Mode 2. Now \the [src] will explode as soon as they pick it up or upon activation.")

/obj/item/device/holobomb/proc/trigger(mob/user)
	if(!active)
		switch_mode(user)
		return
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(!user)
		return
	var/obj/item/organ/external/O = H.get_organ(pick(BP_L_HAND, BP_R_HAND))
	if(!O)
		return

	var/dam = rand(35, 45)
	H.visible_message("<span class='danger'>\The [src] in \the [H]'s hand explodes with a loud bang!</span>")
	H.apply_damage(dam, DAMAGE_BRUTE, O, damage_flags = DAMAGE_FLAG_SHARP, used_weapon = "explode")
	explosion(src.loc, 0,0,1,1)
	H.Stun(5)
	qdel(src)

/obj/item/paper/holobomb
	name = "instruction"
	info = "Бомба имеет два режима. В первом она взрывается при попытке \"ипользовать\" её, во втором при прикосновении. Для начала работы с бомбой выберете режим и просканируйте нужный вам небольшой предмет. Всё, бомба взведена, удачи! И помните, после активации режим бомбы лучше не менять."

/obj/item/storage/box/syndie_kit/holobombs
	name = "box of holobombs"
	desc = "A box containing 5 experimental holobombs."
	icon_state = "flashbang"
	startswith = list(/obj/item/device/holobomb = 5, /obj/item/paper/holobomb = 1)

//
//        Holobombs - Uplink part
//

/datum/uplink_item/item/tools/holobomb
	name = "Box of holobombs"
	item_cost = 32
	path =/obj/item/storage/box/syndie_kit/holobombs
	desc = "Contains 5 holobomb and instruction. \
			A bomb that changes appearance, and can destroy some hands."
