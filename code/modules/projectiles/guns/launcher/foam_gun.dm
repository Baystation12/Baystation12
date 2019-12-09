/obj/item/weapon/gun/launcher/foam
	name = "foam blaster"
	desc = "The classic Jorf blaster!"
	icon = 'icons/obj/guns/foam.dmi'
	icon_state = "blaster"
	item_state = "foam_gun"
	force = 1
	w_class = ITEM_SIZE_SMALL
	obj_flags = null
	slot_flags = SLOT_BELT | SLOT_HOLSTER
	release_force = 1.5
	throw_distance = 6
	accuracy = 1
	one_hand_penalty = 0
	fire_sound = 'sound/weapons/foamblaster.ogg'
	fire_sound_text = "a pleasing 'pomp'"
	matter = list(MATERIAL_PLASTIC = 200)

	var/max_darts = 1
	var/list/darts = new/list()

/obj/item/weapon/gun/launcher/foam/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/foam_dart))
		if(darts.len < max_darts)
			if(!user.unEquip(I, src))
				return
			darts += I
			to_chat(user, SPAN_NOTICE("You slot \the [I] into \the [src]."))
		else
			to_chat(user, SPAN_WARNING("\The [src] can hold no more darts."))

/obj/item/weapon/gun/launcher/foam/consume_next_projectile()
	if(darts.len)
		var/obj/item/I = darts[1]
		darts -= I
		return I
	return null

/obj/item/weapon/gun/launcher/foam/CtrlAltClick(mob/user)
	if(darts.len && src.loc == user)
		to_chat(user, "You empty \the [src].")
		for(var/obj/item/foam_dart/D in darts)
			darts -= D
			D.dropInto(user.loc)
			D.mix_up()

/obj/item/weapon/gun/launcher/foam/burst
	name = "foam machine pistol"
	desc = "The Jorf Outlander, a machine pistol blaster, fires two darts in rapid succession. Holds 4 darts."
	icon_state = "pistol"
	w_class = ITEM_SIZE_NORMAL
	burst = 2
	fire_delay = 12
	one_hand_penalty = 1
	max_darts = 4

/obj/item/weapon/gun/launcher/foam/revolver
	name = "foam revolver"
	desc = "The Jorf Desperado is a revolver blaster, with a hammer action so you can fan the hammer like a real desperado! It holds 6 darts."
	icon_state = "revolver"
	w_class = ITEM_SIZE_NORMAL
	fire_delay = 4
	one_hand_penalty = 1
	max_darts = 6

/obj/item/weapon/gun/launcher/foam/revolver/tampered
	release_force = 3
	throw_distance = 12

/obj/item/weapon/gun/launcher/foam/revolver/tampered/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		to_chat(user, "The hammer is a lot more resistant than you'd expect.")

//the projectile
/obj/item/foam_dart
	name = "foam dart"
	desc = "An offical Jorf brand foam dart, for use only with offical Jorf brand foam dart launching products."
	icon = 'icons/obj/guns/foam.dmi'
	icon_state = "dart"
	w_class = ITEM_SIZE_TINY
	force = 0
	randpixel = 10
	throwforce = 0
	throw_range = 3
	does_spin = FALSE

/obj/item/foam_dart/Initialize()
	mix_up()
	. = ..()
	
/obj/item/foam_dart/proc/mix_up()
	pixel_x = rand(-randpixel, randpixel)
	pixel_y = rand(-randpixel, randpixel)
	set_dir(pick(GLOB.alldirs))

/obj/item/foam_dart/tampered
	throwforce = 4

/obj/item/foam_dart/tampered/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		to_chat(user, SPAN_WARNING("Closer inspection reveals some weights in the rubber dome."))

//boxes of the projectile
/obj/item/weapon/storage/box/foam_darts
	name = "box of foam darts"
	desc = "It's a box of offical Jorf brand foam darts, for use only with offical Jorf brand products."
	icon = 'icons/obj/guns/foam.dmi'
	icon_state = "dart_box"
	startswith = list(/obj/item/foam_dart = 14)

//preset boxes
/obj/item/weapon/storage/box/large/foam_gun
	name = "\improper Jorf blaster set"
	desc = "It's an official Jorf brand blaster, with three official Jorf brand darts!"
	icon = 'icons/obj/guns/foam.dmi'
	icon_state = "blaster_box"
	startswith = list(/obj/item/weapon/gun/launcher/foam,
					  /obj/item/foam_dart = 3)

/obj/item/weapon/storage/box/large/foam_gun/burst
	name = "\improper Jorf Outlander set"
	desc = "It's an official Jorf brand Outlander, with six official Jorf brand darts!"
	startswith = list(/obj/item/weapon/gun/launcher/foam/burst,
					  /obj/item/foam_dart = 6)

/obj/item/weapon/storage/box/large/foam_gun/revolver
	name = "\improper Jorf Desperado set"
	desc = "It's an official Jorf brand Desperado, with eight official Jorf brand darts!"
	startswith = list(/obj/item/weapon/gun/launcher/foam/revolver,
					  /obj/item/foam_dart = 8)

/obj/item/weapon/storage/box/large/foam_gun/revolver/tampered
	desc = "It's a Jorf brand Desperado, with fourteen Jorf brand darts!"
	startswith = list(/obj/item/weapon/gun/launcher/foam/revolver/tampered,
					  /obj/item/foam_dart/tampered = 14)