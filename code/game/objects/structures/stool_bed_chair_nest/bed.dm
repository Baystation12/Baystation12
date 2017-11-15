/* Beds... get your mind out of the gutter, they're for sleeping!
 * Contains:
 * 		Beds
 *		Roller beds
 */

/*
 * Beds
 */
/obj/structure/bed
	name = "bed"
	desc = "This is used to lie in, sleep in or strap on."
	icon = 'icons/obj/furniture.dmi'
	icon_state = "bed"
	anchored = 1
	can_buckle = 1
	buckle_dir = SOUTH
	buckle_lying = 1
	var/material/material
	var/material/padding_material
	var/base_icon = "bed"
	var/material_alteration = MATERIAL_ALTERATION_ALL

/obj/structure/bed/New(var/newloc, var/new_material, var/new_padding_material)
	..(newloc)
	color = null
	if(!new_material)
		new_material = DEFAULT_WALL_MATERIAL
	material = get_material_by_name(new_material)
	if(!istype(material))
		qdel(src)
		return
	if(new_padding_material)
		padding_material = get_material_by_name(new_padding_material)
	update_icon()

/obj/structure/bed/get_material()
	return material

// Reuse the cache/code from stools, todo maybe unify.
/obj/structure/bed/update_icon()
	// Prep icon.
	icon_state = ""
	overlays.Cut()
	// Base icon.
	var/cache_key = "[base_icon]-[material.name]"
	if(isnull(stool_cache[cache_key]))
		var/image/I = image('icons/obj/furniture.dmi', base_icon)
		if(material_alteration & MATERIAL_ALTERATION_COLOR)
			I.color = material.icon_colour
		stool_cache[cache_key] = I
	overlays |= stool_cache[cache_key]
	// Padding overlay.
	if(padding_material)
		var/padding_cache_key = "[base_icon]-padding-[padding_material.name]"
		if(isnull(stool_cache[padding_cache_key]))
			var/image/I =  image(icon, "[base_icon]_padding")
			if(material_alteration & MATERIAL_ALTERATION_COLOR)
				I.color = padding_material.icon_colour
			stool_cache[padding_cache_key] = I
		overlays |= stool_cache[padding_cache_key]

	// Strings.
	if(material_alteration & MATERIAL_ALTERATION_NAME)
		name = padding_material ? "[padding_material.adjective_name] [initial(name)]" : "[material.adjective_name] [initial(name)]" //this is not perfect but it will do for now.

	if(material_alteration & MATERIAL_ALTERATION_DESC)
		desc = initial(desc)
		desc += padding_material ? " It's made of [material.use_name] and covered with [padding_material.use_name]." : " It's made of [material.use_name]."

/obj/structure/bed/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	else
		return ..()

/obj/structure/bed/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return
		if(3.0)
			if (prob(5))
				qdel(src)
				return

/obj/structure/bed/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(iswrench(W))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		dismantle()
		qdel(src)
	else if(istype(W,/obj/item/stack))
		if(padding_material)
			to_chat(user, "\The [src] is already padded.")
			return
		var/obj/item/stack/C = W
		if(C.get_amount() < 1) // How??
			user.drop_from_inventory(C)
			qdel(C)
			return
		var/padding_type //This is awful but it needs to be like this until tiles are given a material var.
		if(istype(W,/obj/item/stack/tile/carpet))
			padding_type = "carpet"
		else if(istype(W,/obj/item/stack/material))
			var/obj/item/stack/material/M = W
			if(M.material && (M.material.flags & MATERIAL_PADDING))
				padding_type = "[M.material.name]"
		if(!padding_type)
			to_chat(user, "You cannot pad \the [src] with that.")
			return
		C.use(1)
		if(!istype(src.loc, /turf))
			user.drop_from_inventory(src)
			src.loc = get_turf(src)
		to_chat(user, "You add padding to \the [src].")
		add_padding(padding_type)
		return

	else if(iswirecutter(W))
		if(!padding_material)
			to_chat(user, "\The [src] has no padding to remove.")
			return
		to_chat(user, "You remove the padding from \the [src].")
		playsound(src, 'sound/items/Wirecutter.ogg', 100, 1)
		remove_padding()

	else if(istype(W, /obj/item/grab))
		var/obj/item/grab/G = W
		var/mob/living/affecting = G.affecting
		user.visible_message("<span class='notice'>[user] attempts to buckle [affecting] into \the [src]!</span>")
		if(do_after(user, 20, src))
			if(user_buckle_mob(affecting, user))
				qdel(W)
	else
		..()

/obj/structure/bed/proc/remove_padding()
	if(padding_material)
		padding_material.place_sheet(get_turf(src))
		padding_material = null
	update_icon()

/obj/structure/bed/proc/add_padding(var/padding_type)
	padding_material = get_material_by_name(padding_type)
	update_icon()

/obj/structure/bed/proc/dismantle()
	material.place_sheet(get_turf(src))
	if(padding_material)
		padding_material.place_sheet(get_turf(src))

/obj/structure/bed/psych
	name = "psychiatrist's couch"
	desc = "For prime comfort during psychiatric evaluations."
	icon_state = "psychbed"
	base_icon = "psychbed"

/obj/structure/bed/psych/New(var/newloc)
	..(newloc,"wood","leather")

/obj/structure/bed/padded/New(var/newloc)
	..(newloc,"plastic","cotton")

/obj/structure/bed/alien
	name = "resting contraption"
	desc = "This looks similar to contraptions from earth. Could aliens be stealing our technology?"

/obj/structure/bed/alien/New(var/newloc)
	..(newloc,"resin")

/obj/structure/bed/bogani
	name = "alien bed"
	desc = "a strange looking bed, not from something you've seen before."
	icon_state = "bogbed"


/*
 * Roller beds
 */
/obj/structure/bed/roller
	name = "roller bed"
	icon = 'icons/obj/rollerbed.dmi'
	icon_state = "down"
	anchored = 0
	buckle_pixel_shift = "x=0;y=6"

/obj/structure/bed/roller/update_icon()
	return // Doesn't care about material or anything else.

/obj/structure/bed/roller/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(iswrench(W) || istype(W,/obj/item/stack) || iswirecutter(W))
		return
	else if(istype(W,/obj/item/roller_holder))
		if(buckled_mob)
			user_unbuckle_mob(user)
		else
			visible_message("[user] collapses \the [src.name].")
			new/obj/item/roller(get_turf(src))
			spawn(0)
				qdel(src)
		return
	..()

/obj/item/roller
	name = "roller bed"
	desc = "A collapsed roller bed that can be carried around."
	icon = 'icons/obj/rollerbed.dmi'
	icon_state = "folded"
	item_state = "rbed"
	slot_flags = SLOT_BACK
	w_class = ITEM_SIZE_HUGE // Can't be put in backpacks. Oh well. For now.

/obj/item/roller/attack_self(mob/user)
		var/obj/structure/bed/roller/R = new /obj/structure/bed/roller(user.loc)
		R.add_fingerprint(user)
		qdel(src)

/obj/item/roller/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if(istype(W,/obj/item/roller_holder))
		var/obj/item/roller_holder/RH = W
		if(!RH.held)
			to_chat(user, "<span class='notice'>You collect the roller bed.</span>")
			src.forceMove(RH)
			RH.held = src
			return

	..()

/obj/item/roller_holder
	name = "roller bed rack"
	desc = "A rack for carrying a collapsed roller bed."
	icon = 'icons/obj/rollerbed.dmi'
	icon_state = "folded"
	var/obj/item/roller/held

/obj/item/roller_holder/New()
	..()
	held = new /obj/item/roller(src)

/obj/item/roller_holder/attack_self(mob/user as mob)

	if(!held)
		to_chat(user, "<span class='notice'>The rack is empty.</span>")
		return

	to_chat(user, "<span class='notice'>You deploy the roller bed.</span>")
	var/obj/structure/bed/roller/R = new /obj/structure/bed/roller(user.loc)
	R.add_fingerprint(user)
	qdel(held)
	held = null


/obj/structure/bed/roller/proc/move_buckled()
	if(buckled_mob)
		if(buckled_mob.buckled == src)
			buckled_mob.forceMove(src.loc)
		else
			buckled_mob = null

/obj/structure/bed/roller/post_buckle_mob(mob/living/M as mob)
	if(M == buckled_mob)
		set_density(1)
		icon_state = "up"
	else
		set_density(0)
		icon_state = "down"

	return ..()

/obj/structure/bed/roller/buckle_mob()
	. = ..()
	if(.)
		GLOB.moved_event.register(src, src, /obj/structure/bed/roller/proc/move_buckled)

/obj/structure/bed/roller/unbuckle_mob()
	GLOB.moved_event.unregister(src, src)
	return ..()

/obj/structure/bed/roller/MouseDrop(over_object, src_location, over_location)
	..()
	if((over_object == usr && (in_range(src, usr) || usr.contents.Find(src))))
		if(!ishuman(usr))	return
		if(buckled_mob)	return 0
		visible_message("[usr] collapses \the [src.name].")
		new/obj/item/roller(get_turf(src))
		spawn(0)
			qdel(src)
		return
