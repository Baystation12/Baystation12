//Also contains /obj/structure/closet/body_bag because I doubt anyone would think to look for bodybags in /object/structures

/obj/item/bodybag
	name = "body bag"
	desc = "A folded bag designed for the storage and transportation of cadavers."
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "bodybag_folded"
	w_class = ITEM_SIZE_SMALL

	attack_self(mob/user)
		var/obj/structure/closet/body_bag/R = new /obj/structure/closet/body_bag(user.loc)
		R.add_fingerprint(user)
		qdel(src)


/obj/item/weapon/storage/box/bodybags
	name = "body bags"
	desc = "This box contains body bags."
	icon_state = "bodybags"
	New()
		..()
		new /obj/item/bodybag(src)
		new /obj/item/bodybag(src)
		new /obj/item/bodybag(src)
		new /obj/item/bodybag(src)
		new /obj/item/bodybag(src)
		new /obj/item/bodybag(src)
		new /obj/item/bodybag(src)


/obj/structure/closet/body_bag
	name = "body bag"
	desc = "A plastic bag designed for the storage and transportation of cadavers."
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "bodybag_closed"
	icon_closed = "bodybag_closed"
	icon_opened = "bodybag_open"
	open_sound = 'sound/items/zip.ogg'
	close_sound = 'sound/items/zip.ogg'
	var/item_path = /obj/item/bodybag
	density = 0
	storage_capacity = (MOB_MEDIUM * 2) - 1
	var/contains_body = 0

/obj/structure/closet/body_bag/attackby(W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/pen))
		var/t = input(user, "What would you like the label to be?", text("[]", src.name), null)  as text
		if (user.get_active_hand() != W)
			return
		if (!in_range(src, user) && src.loc != user)
			return
		t = sanitizeSafe(t, MAX_NAME_LEN)
		if (t)
			src.name = "body bag - "
			src.name += t
			src.overlays += image(src.icon, "bodybag_label")
		else
			src.name = "body bag"
	//..() //Doesn't need to run the parent. Since when can fucking bodybags be welded shut? -Agouri
		return
	else if(istype(W, /obj/item/weapon/wirecutters))
		src.name = "body bag"
		src.overlays.Cut()
		to_chat(user, "You cut the tag off \the [src].")
		return
	else if(istype(W, /obj/item/device/healthanalyzer/) && !opened)
		if(contains_body)
			var/obj/item/device/healthanalyzer/HA = W
			for(var/mob/living/L in contents)
				HA.scan_mob(L, user)
		else
			to_chat(user, "\The [W] reports that \the [src] is empty.")
		return

/obj/structure/closet/body_bag/store_mobs(var/stored_units)
	contains_body = ..()
	return contains_body

/obj/structure/closet/body_bag/close()
	if(..())
		set_density(0)
		return 1
	return 0

/obj/structure/closet/body_bag/MouseDrop(over_object, src_location, over_location)
	..()
	if((over_object == usr && (in_range(src, usr) || usr.contents.Find(src))))
		if(!ishuman(usr))	return
		if(opened)	return 0
		if(contents.len)	return 0
		visible_message("[usr] folds up the [src.name]")
		new item_path(get_turf(src))
		spawn(0)
			qdel(src)
		return

/obj/structure/closet/body_bag/update_icon()
	if(opened)
		icon_state = icon_opened
	else
		if(contains_body > 0)
			icon_state = "bodybag_closed1"
		else
			icon_state = icon_closed


/obj/item/bodybag/cryobag
	name = "stasis bag"
	desc = "A folded, non-reusable bag designed to prevent additional damage to an occupant, especially useful if short on time or in \
	a hostile enviroment."
	icon = 'icons/obj/cryobag.dmi'
	icon_state = "bodybag_folded"
	origin_tech = list(TECH_BIO = 4)

/obj/item/bodybag/cryobag/attack_self(mob/user)
	var/obj/structure/closet/body_bag/cryobag/R = new /obj/structure/closet/body_bag/cryobag(user.loc)
	R.add_fingerprint(user)
	qdel(src)

/obj/structure/closet/body_bag/cryobag
	name = "stasis bag"
	desc = "A non-reusable plastic bag designed to prevent additional damage to an occupant, especially useful if short on time or in \
	a hostile enviroment."
	icon = 'icons/obj/cryobag.dmi'
	item_path = /obj/item/bodybag/cryobag
	store_misc = 0
	store_items = 0
	var/used = 0
	var/obj/item/weapon/tank/tank = null

/obj/structure/closet/body_bag/cryobag/New()
	tank = new /obj/item/weapon/tank/emergency/oxygen(null) //It's in nullspace to prevent ejection when the bag is opened.
	..()

/obj/structure/closet/body_bag/cryobag/Destroy()
	qdel(tank)
	tank = null
	return ..()

/obj/structure/closet/body_bag/cryobag/open()
	. = ..()
	if(used)
		var/obj/item/O = new/obj/item(src.loc)
		O.name = "used stasis bag"
		O.icon = src.icon
		O.icon_state = "bodybag_used"
		O.desc = "Pretty useless now.."
		qdel(src)

/obj/structure/closet/body_bag/cryobag/Entered(atom/movable/AM)
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		H.in_stasis = 1
		src.used = 1
	..()

/obj/structure/closet/body_bag/cryobag/Exited(atom/movable/AM)
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		H.in_stasis = 0
	..()

/obj/structure/closet/body_bag/cryobag/return_air() //Used to make stasis bags protect from vacuum.
	if(tank)
		return tank.air_contents
	..()

/obj/structure/closet/body_bag/cryobag/examine(mob/user)
	. = ..()
	if(Adjacent(user)) //The bag's rather thick and opaque from a distance.
		to_chat(user, "<span class='info'>You peer into \the [src].</span>")
		for(var/mob/living/L in contents)
			L.examine(user)
