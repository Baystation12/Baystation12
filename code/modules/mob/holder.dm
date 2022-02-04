var/list/holder_mob_icon_cache = list()

//Helper object for picking dionaea (and other creatures) up.
/obj/item/holder
	name = "holder"
	desc = "You shouldn't ever see this."
	icon = 'icons/obj/objects.dmi'
	slot_flags = SLOT_HEAD | SLOT_HOLSTER

	sprite_sheets = list(
		SPECIES_VOX = 'icons/mob/species/vox/onmob_head_vox.dmi',
		SPECIES_VOX_ARMALIS = 'icons/mob/species/vox/onmob_head_vox_armalis.dmi'
		)

	origin_tech = null
	item_icons = list(
		slot_l_hand_str = 'icons/mob/onmob/items/lefthand_holder.dmi',
		slot_r_hand_str = 'icons/mob/onmob/items/righthand_holder.dmi',
		)
	pixel_y = 8

	var/last_holder

/obj/item/holder/New()
	..()
	START_PROCESSING(SSobj, src)

/obj/item/holder/proc/destroy_all()
	for(var/atom/movable/AM in src)
		qdel(AM)
	qdel(src)

/obj/item/holder/Destroy()
	for(var/atom/movable/AM in src)
		AM.forceMove(get_turf(src))
	last_holder = null
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/holder/Process()
	update_state()

/obj/item/holder/dropped()
	..()
	spawn(1)
		update_state()

/obj/item/holder/proc/update_state()
	if(last_holder != loc)
		for(var/mob/M in contents)
			unregister_all_movement(last_holder, M)

	if(istype(loc,/turf) || !(contents.len))
		for(var/mob/M in contents)
			var/atom/movable/mob_container = M
			mob_container.dropInto(loc)
			M.reset_view()
		qdel(src)
	else if(last_holder != loc)
		for(var/mob/M in contents)
			register_all_movement(loc, M)

	last_holder = loc

/obj/item/holder/onDropInto(var/atom/movable/AM)
	if(ismob(loc))   // Bypass our holding mob and drop directly to its loc
		return loc.loc
	return ..()

/obj/item/holder/GetIdCard()
	for(var/mob/M in contents)
		var/obj/item/I = M.GetIdCard()
		if(I)
			return I
	return null

/obj/item/holder/GetAccess()
	var/obj/item/I = GetIdCard()
	return I ? I.GetAccess() : ..()

/obj/item/holder/attack_self()
	for(var/mob/M in contents)
		M.show_inv(usr)

/obj/item/holder/attack(mob/target, mob/user)
	// Devour on click on self with holder
	if(target == user && istype(user,/mob/living/carbon))
		var/mob/living/carbon/M = user

		for(var/mob/victim in src.contents)
			M.devour(victim)

		update_state()

	..()

/obj/item/holder/proc/sync(var/mob/living/M)
	dir = 2
	overlays.Cut()
	icon = M.icon
	icon_state = M.icon_state
	item_state = M.item_state
	color = M.color
	name = M.name
	desc = M.desc
	overlays |= M.overlays
	var/mob/living/carbon/human/H = loc
	last_holder = H
	register_all_movement(H, M)

	update_held_icon()

//Mob specific holders.
/obj/item/holder/drone
	origin_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 5)

/obj/item/holder/mouse
	w_class = ITEM_SIZE_TINY

/obj/item/holder/borer
	origin_tech = list(TECH_BIO = 6)

//need own subtype to work with recipes
/obj/item/holder/corgi
	origin_tech = list(TECH_BIO = 4)

/obj/item/holder/possum
	origin_tech = list(TECH_BIO = 3)

/obj/item/holder/possum/poppy
	origin_tech = list(TECH_BIO = 3, TECH_ENGINEERING = 4)
	item_state = "poppy"

/obj/item/holder/attackby(obj/item/W as obj, mob/user as mob)
	for(var/mob/M in src.contents)
		M.attackby(W,user)

//Mob procs and vars for scooping up
/mob/living/var/holder_type

/mob/living/proc/get_scooped(var/mob/living/carbon/human/grabber, var/self_grab)
	if(!holder_type || buckled || pinned.len)
		return

	if(self_grab)
		if(src.incapacitated()) return
	else
		if(grabber.incapacitated()) return

	var/obj/item/holder/H = new holder_type(get_turf(src))

	if(self_grab)
		if(!grabber.equip_to_slot_if_possible(H, slot_back, TRYEQUIP_REDRAW | TRYEQUIP_SILENT))
			to_chat(src, "<span class='warning'>You can't climb onto [grabber]!</span>")
			return

		to_chat(grabber, "<span class='notice'>\The [src] clambers onto you!</span>")
		to_chat(src, "<span class='notice'>You climb up onto \the [grabber]!</span>")
	else
		if(!grabber.put_in_hands(H))
			to_chat(grabber, "<span class='warning'>Your hands are full!</span>")
			return

		to_chat(grabber, "<span class='notice'>You scoop up \the [src]!</span>")
		to_chat(src, "<span class='notice'>\The [grabber] scoops you up!</span>")

	src.forceMove(H)

	grabber.status_flags |= PASSEMOTES
	H.sync(src)
	return H

/mob/living/MouseDrop(var/mob/living/carbon/human/over_object)
	if(istype(over_object) && Adjacent(over_object) && (usr == src || usr == over_object) && over_object.a_intent == I_GRAB)
		if(scoop_check(over_object))
			get_scooped(over_object, (usr == src))
			return
	return ..()

/mob/living/proc/scoop_check(var/mob/living/scooper)
	return 1

/mob/living/carbon/human/scoop_check(var/mob/living/scooper)
	return (scooper.mob_size > src.mob_size && a_intent == I_HELP)
