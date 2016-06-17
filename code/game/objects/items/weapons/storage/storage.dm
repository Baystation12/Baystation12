// To clarify:
// For use_to_pickup and allow_quick_gather functionality,
// see item/attackby() (/game/objects/items.dm)
// Do not remove this functionality without good reason, cough reagent_containers cough.
// -Sayu


/obj/item/weapon/storage
	name = "storage"
	icon = 'icons/obj/storage.dmi'
	w_class = 3
	var/list/can_hold = new/list() //List of objects which this item can store (if set, it can't store anything else)
	var/list/cant_hold = new/list() //List of objects which this item can't store (in effect only if can_hold isn't set)
	var/list/is_seeing = new/list() //List of mobs which are currently seeing the contents of this item's storage
	var/max_w_class = 2 //Max size of objects that this object can store (in effect only if can_hold isn't set)
	var/max_storage_space = null //Total storage cost of items this can hold. Will be autoset based on storage_slots if left null.
	var/storage_slots = null //The number of storage slots in this container.
	var/obj/screen/storage/boxes = null
	var/obj/screen/storage/storage_start = null //storage UI
	var/obj/screen/storage/storage_continue = null
	var/obj/screen/storage/storage_end = null
	var/obj/screen/storage/stored_start = null
	var/obj/screen/storage/stored_continue = null
	var/obj/screen/storage/stored_end = null
	var/obj/screen/close/closer = null
	var/use_to_pickup	//Set this to make it possible to use this item in an inverse way, so you can have the item in your hand and click items on the floor to pick them up.
	var/allow_quick_empty	//Set this variable to allow the object to have the 'empty' verb, which dumps all the contents on the floor.
	var/allow_quick_gather	//Set this variable to allow the object to have the 'toggle mode' verb, which quickly collects all items from a tile.
	var/collection_mode = 1;  //0 = pick one at a time, 1 = pick all on tile
	var/use_sound = "rustle"	//sound played when used. null for no sound.

	//initializes the contents of the storage with some items based on an assoc list. The assoc key must be an item path,
	//the assoc value can either be the quantity, or a list whose first value is the quantity and the rest are args.
	var/list/startswith

/obj/item/weapon/storage/Destroy()
	close_all()
	qdel(boxes)
	qdel(src.storage_start)
	qdel(src.storage_continue)
	qdel(src.storage_end)
	qdel(src.stored_start)
	qdel(src.stored_continue)
	qdel(src.stored_end)
	qdel(closer)
	..()

/obj/item/weapon/storage/MouseDrop(obj/over_object as obj)
	if(!canremove)
		return

	if (ishuman(usr) || issmall(usr)) //so monkeys can take off their backpacks -- Urist
		if(over_object == usr && Adjacent(usr)) // this must come before the screen objects only block
			src.open(usr)
			return

		if (!( istype(over_object, /obj/screen) ))
			return ..()

		if (usr.incapacitated())
			return

		//makes sure that the storage is equipped, so that we can't drag it into our hand from miles away.
		if (!usr.contains(src))
			return

		src.add_fingerprint(usr)
		if(usr.unEquip(src))
			switch(over_object.name)
				if("r_hand")
					usr.put_in_r_hand(src)
				if("l_hand")
					usr.put_in_l_hand(src)


/obj/item/weapon/storage/proc/return_inv()

	var/list/L = list(  )

	L += src.contents

	for(var/obj/item/weapon/storage/S in src)
		L += S.return_inv()
	for(var/obj/item/weapon/gift/G in src)
		L += G.gift
		if (istype(G.gift, /obj/item/weapon/storage))
			L += G.gift:return_inv()
	return L

/obj/item/weapon/storage/proc/show_to(mob/user as mob)
	if(user.s_active != src)
		for(var/obj/item/I in src)
			if(I.on_found(user))
				return
	if(user.s_active)
		user.s_active.hide_from(user)
	user.client.screen -= src.boxes
	user.client.screen -= src.storage_start
	user.client.screen -= src.storage_continue
	user.client.screen -= src.storage_end
	user.client.screen -= src.closer
	user.client.screen -= src.contents
	user.client.screen += src.closer
	user.client.screen += src.contents
	if(storage_slots)
		user.client.screen += src.boxes
	else
		user.client.screen += src.storage_start
		user.client.screen += src.storage_continue
		user.client.screen += src.storage_end
	user.s_active = src
	is_seeing |= user
	return

/obj/item/weapon/storage/proc/hide_from(mob/user as mob)

	if(!user.client)
		return
	user.client.screen -= src.boxes
	user.client.screen -= src.storage_start
	user.client.screen -= src.storage_continue
	user.client.screen -= src.storage_end
	user.client.screen -= src.closer
	user.client.screen -= src.contents
	if(user.s_active == src)
		user.s_active = null
	is_seeing -= user

/obj/item/weapon/storage/proc/open(mob/user as mob)
	if (src.use_sound)
		playsound(src.loc, src.use_sound, 50, 1, -5)

	orient2hud(user)
	if (user.s_active)
		user.s_active.close(user)
	show_to(user)

/obj/item/weapon/storage/proc/close(mob/user as mob)
	src.hide_from(user)
	user.s_active = null
	return

/obj/item/weapon/storage/proc/close_all()
	for(var/mob/M in can_see_contents())
		close(M)
		. = 1

/obj/item/weapon/storage/proc/can_see_contents()
	var/list/cansee = list()
	for(var/mob/M in is_seeing)
		if(M.s_active == src && M.client)
			cansee |= M
		else
			is_seeing -= M
	return cansee

//This proc draws out the inventory and places the items on it. tx and ty are the upper left tile and mx, my are the bottm right.
//The numbers are calculated from the bottom-left The bottom-left slot being 1,1.
/obj/item/weapon/storage/proc/orient_objs(tx, ty, mx, my)
	var/cx = tx
	var/cy = ty
	src.boxes.screen_loc = "[tx]:,[ty] to [mx],[my]"
	for(var/obj/O in src.contents)
		O.screen_loc = "[cx],[cy]"
		O.layer = SCREEN_LAYER+0.01
		cx++
		if (cx > mx)
			cx = tx
			cy--
	src.closer.screen_loc = "[mx+1],[my]"
	return

//This proc determins the size of the inventory to be displayed. Please touch it only if you know what you're doing.
/obj/item/weapon/storage/proc/slot_orient_objs()
	var/adjusted_contents = contents.len
	var/row_num = 0
	var/col_count = min(7,storage_slots) -1
	if (adjusted_contents > 7)
		row_num = round((adjusted_contents-1) / 7) // 7 is the maximum allowed width.
	src.arrange_item_slots(row_num, col_count)

//This proc draws out the inventory and places the items on it. It uses the standard position.
/obj/item/weapon/storage/proc/arrange_item_slots(var/rows, var/cols)
	var/cx = 4
	var/cy = 2+rows
	src.boxes.screen_loc = "4:16,2:16 to [4+cols]:16,[2+rows]:16"

	for(var/obj/O in contents)
		O.screen_loc = "[cx]:16,[cy]:16"
		O.maptext = ""
		O.layer = SCREEN_LAYER+0.01
		cx++
		if (cx > (4+cols))
			cx = 4
			cy--

	src.closer.screen_loc = "[4+cols+1]:16,2:16"
	return

/obj/item/weapon/storage/proc/space_orient_objs()

	var/baseline_max_storage_space = DEFAULT_BOX_STORAGE //storage size corresponding to 224 pixels
	var/storage_cap_width = 2 //length of sprite for start and end of the box representing total storage space
	var/stored_cap_width = 4 //length of sprite for start and end of the box representing the stored item
	var/storage_width = min( round( 224 * max_storage_space/baseline_max_storage_space ,1) ,284) //length of sprite for the box representing total storage space

	storage_start.overlays.Cut()

	var/matrix/M = matrix()
	M.Scale((storage_width-storage_cap_width*2+3)/32,1)
	src.storage_continue.transform = M

	src.storage_start.screen_loc = "4:16,2:16"
	src.storage_continue.screen_loc = "4:[storage_cap_width+(storage_width-storage_cap_width*2)/2+2],2:16"
	src.storage_end.screen_loc = "4:[19+storage_width-storage_cap_width],2:16"

	var/startpoint = 0
	var/endpoint = 1

	for(var/obj/item/O in contents)
		startpoint = endpoint + 1
		endpoint += storage_width * O.get_storage_cost()/max_storage_space

		var/matrix/M_start = matrix()
		var/matrix/M_continue = matrix()
		var/matrix/M_end = matrix()
		M_start.Translate(startpoint,0)
		M_continue.Scale((endpoint-startpoint-stored_cap_width*2)/32,1)
		M_continue.Translate(startpoint+stored_cap_width+(endpoint-startpoint-stored_cap_width*2)/2 - 16,0)
		M_end.Translate(endpoint-stored_cap_width,0)
		src.stored_start.transform = M_start
		src.stored_continue.transform = M_continue
		src.stored_end.transform = M_end
		storage_start.overlays += src.stored_start
		storage_start.overlays += src.stored_continue
		storage_start.overlays += src.stored_end

		O.screen_loc = "4:[round((startpoint+endpoint)/2)+2],2:16"
		O.maptext = ""
		O.layer = SCREEN_LAYER+0.01

	src.closer.screen_loc = "4:[storage_width+19],2:16"
	return

/datum/numbered_display
	var/obj/item/sample_object
	var/number

	New(obj/item/sample as obj)
		if(!istype(sample))
			qdel(src)
		sample_object = sample
		number = 1

//Creates the storage UI
/obj/item/weapon/storage/proc/orient2hud(mob/user as mob)
	//if storage slots is null then use the storage space UI, otherwise use the slots UI
	if(storage_slots == null)
		src.space_orient_objs()
	else
		src.slot_orient_objs()
	return

/obj/item/weapon/storage/proc/storage_space_used()
	. = 0
	for(var/obj/item/I in contents)
		. += I.get_storage_cost()

//This proc return 1 if the item can be picked up and 0 if it can't.
//Set the stop_messages to stop it from printing messages
/obj/item/weapon/storage/proc/can_be_inserted(obj/item/W, mob/user, stop_messages = 0)
	if(!istype(W)) return //Not an item

	if(user && user.isEquipped(W) && !user.canUnEquip(W))
		return 0

	if(src.loc == W)
		return 0 //Means the item is already in the storage item
	if(storage_slots != null && contents.len >= storage_slots)
		if(!stop_messages)
			user << "<span class='notice'>\The [src] is full, make some space.</span>"
		return 0 //Storage item is full

	if(W.anchored)
		return 0

	if(can_hold.len)
		if(!is_type_in_list(W, can_hold))
			if(!stop_messages && ! istype(W, /obj/item/weapon/hand_labeler))
				user << "<span class='notice'>\The [src] cannot hold [W].</span>"
			return 0
		var/max_instances = can_hold[W.type]
		if(max_instances && instances_of_type_in_list(W, contents) >= max_instances)
			if(!stop_messages && !istype(W, /obj/item/weapon/hand_labeler))
				user << "<span class='notice'>\The [src] has no more space specifically for [W].</span>"
			return 0

	if(cant_hold.len && is_type_in_list(W, cant_hold))
		if(!stop_messages)
			user << "<span class='notice'>\The [src] cannot hold [W].</span>"
		return 0

	if (max_w_class != null && W.w_class > max_w_class)
		if(!stop_messages)
			user << "<span class='notice'>\The [W] is too big for this [src.name].</span>"
		return 0

	var/total_storage_space = W.get_storage_cost()
	if(total_storage_space == DO_NOT_STORE)
		if(!stop_messages)
			user << "<span class='notice'>\The [W] cannot be placed in [src].</span>"
		return 0

	total_storage_space += storage_space_used() //Adds up the combined w_classes which will be in the storage item if the item is added to it.
	if(total_storage_space > max_storage_space)
		if(!stop_messages)
			user << "<span class='notice'>\The [src] is too full, make some space.</span>"
		return 0


//Commented out so that trash bags can fit in backpacks and hold storage items.
//This means that storage items with max_w_class greater than their own w_class
//can now be exploited for infinite storage, so don't let players have those okay?
/*
	if(istype(W, /obj/item/weapon/storage))
		var/obj/item/weapon/storage/other = W
		if(other.w_class > src.w_class || other.max_w_class >= src.w_class)
			if(!stop_messages)
				usr << "<span class='notice'>\The [src] cannot hold [W].</span>"
			return 0 //To prevent infinite storage exploits
*/

	return 1

//This proc handles items being inserted. It does not perform any checks of whether an item can or can't be inserted. That's done by can_be_inserted()
//The stop_warning parameter will stop the insertion message from being displayed. It is intended for cases where you are inserting multiple items at once,
//such as when picking up all the items on a tile with one click.
/obj/item/weapon/storage/proc/handle_item_insertion(obj/item/W as obj, prevent_warning = 0)
	if(!istype(W)) return 0
	if(usr)
		usr.remove_from_mob(W)
		usr.update_icons()	//update our overlays
	W.forceMove(src)
	W.on_enter_storage(src)
	if(usr)
		add_fingerprint(usr)

		if(!prevent_warning)
			for(var/mob/M in viewers(usr, null))
				if (M == usr)
					usr << "<span class='notice'>You put \the [W] into [src].</span>"
				else if (M in range(1)) //If someone is standing close enough, they can tell what it is... TODO replace with distance check
					M.show_message("<span class='notice'>\The [usr] puts [W] into [src].</span>")
				else if (W && W.w_class >= NORMAL_ITEM) //Otherwise they can only see large or normal items from a distance...
					M.show_message("<span class='notice'>\The [usr] puts [W] into [src].</span>")

		src.orient2hud(usr)
		if(usr.s_active)
			usr.s_active.show_to(usr)
	update_icon()
	return 1

//Call this proc to handle the removal of an item from the storage item. The item will be moved to the atom sent as new_target
/obj/item/weapon/storage/proc/remove_from_storage(obj/item/W as obj, atom/new_location)
	if(!istype(W)) return 0

	for(var/mob/M in range(1, src.loc))
		if (M.s_active == src)
			if (M.client)
				M.client.screen -= W

	if(new_location)
		if(ismob(loc))
			W.dropped(usr)
		if(ismob(new_location))
			W.layer = SCREEN_LAYER+0.01
		else
			W.layer = initial(W.layer)
		W.loc = new_location
	else
		W.loc = get_turf(src)

	if(usr)
		src.orient2hud(usr)
		if(usr.s_active)
			usr.s_active.show_to(usr)
	if(W.maptext)
		W.maptext = ""
	W.on_exit_storage(src)
	update_icon()
	return 1

//This proc is called when you want to place an item into the storage item.
/obj/item/weapon/storage/attackby(obj/item/W as obj, mob/user as mob)
	..()

	if(isrobot(user))
		return //Robots can't interact with storage items.

	if(istype(W, /obj/item/device/lightreplacer))
		var/obj/item/device/lightreplacer/LP = W
		var/amt_inserted = 0
		var/turf/T = get_turf(user)
		for(var/obj/item/weapon/light/L in src.contents)
			if(L.status == 0)
				if(LP.uses < LP.max_uses)
					LP.AddUses(1)
					amt_inserted++
					remove_from_storage(L, T)
					qdel(L)
		if(amt_inserted)
			user << "You inserted [amt_inserted] light\s into \the [LP.name]. You have [LP.uses] light\s remaining."
			return

	if(!can_be_inserted(W, user))
		return

	if(istype(W, /obj/item/weapon/tray))
		var/obj/item/weapon/tray/T = W
		if(T.calc_carry() > 0)
			if(prob(85))
				user << "<span class='warning'>The tray won't fit in [src].</span>"
				return
			else
				if(user.unEquip(W))
					user << "<span class='warning'>God damnit!</span>"

	W.add_fingerprint(user)
	return handle_item_insertion(W)

/obj/item/weapon/storage/attack_hand(mob/user as mob)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.l_store == src && !H.get_active_hand())	//Prevents opening if it's in a pocket.
			H.put_in_hands(src)
			H.l_store = null
			return
		if(H.r_store == src && !H.get_active_hand())
			H.put_in_hands(src)
			H.r_store = null
			return

	if (src.loc == user)
		src.open(user)
	else
		..()
		for(var/mob/M in range(1))
			if (M.s_active == src)
				src.close(M)
	src.add_fingerprint(user)
	return

/obj/item/weapon/storage/verb/toggle_gathering_mode()
	set name = "Switch Gathering Method"
	set category = "Object"

	collection_mode = !collection_mode
	switch (collection_mode)
		if(1)
			usr << "[src] now picks up all items in a tile at once."
		if(0)
			usr << "[src] now picks up one item at a time."


/obj/item/weapon/storage/verb/quick_empty()
	set name = "Empty Contents"
	set category = "Object"

	if((!ishuman(usr) && (src.loc != usr)) || usr.stat || usr.restrained())
		return

	var/turf/T = get_turf(src)
	hide_from(usr)
	for(var/obj/item/I in contents)
		remove_from_storage(I, T)

/obj/item/weapon/storage/New()
	..()
	if(allow_quick_empty)
		verbs += /obj/item/weapon/storage/verb/quick_empty
	else
		verbs -= /obj/item/weapon/storage/verb/quick_empty

	if(allow_quick_gather)
		verbs += /obj/item/weapon/storage/verb/toggle_gathering_mode
	else
		verbs -= /obj/item/weapon/storage/verb/toggle_gathering_mode

	if(isnull(max_storage_space) && !isnull(storage_slots))
		max_storage_space = storage_slots*base_storage_cost(max_w_class)

	spawn(5)
		var/total_storage_space = 0
		for(var/obj/item/I in contents)
			total_storage_space += I.get_storage_cost()
		max_storage_space = max(total_storage_space,max_storage_space) //prevents spawned containers from being too small for their contents

	src.boxes = new /obj/screen/storage(  )
	src.boxes.name = "storage"
	src.boxes.master = src
	src.boxes.icon_state = "block"
	src.boxes.screen_loc = "7,7 to 10,8"
	src.boxes.layer = SCREEN_LAYER

	src.storage_start = new /obj/screen/storage(  )
	src.storage_start.name = "storage"
	src.storage_start.master = src
	src.storage_start.icon_state = "storage_start"
	src.storage_start.screen_loc = "7,7 to 10,8"
	src.storage_start.layer = SCREEN_LAYER
	src.storage_continue = new /obj/screen/storage(  )
	src.storage_continue.name = "storage"
	src.storage_continue.master = src
	src.storage_continue.icon_state = "storage_continue"
	src.storage_continue.screen_loc = "7,7 to 10,8"
	src.storage_continue.layer = SCREEN_LAYER
	src.storage_end = new /obj/screen/storage(  )
	src.storage_end.name = "storage"
	src.storage_end.master = src
	src.storage_end.icon_state = "storage_end"
	src.storage_end.screen_loc = "7,7 to 10,8"
	src.storage_end.layer = SCREEN_LAYER

	src.stored_start = new /obj //we just need these to hold the icon
	src.stored_start.icon_state = "stored_start"
	src.stored_start.layer = SCREEN_LAYER
	src.stored_continue = new /obj
	src.stored_continue.icon_state = "stored_continue"
	src.stored_continue.layer = SCREEN_LAYER
	src.stored_end = new /obj
	src.stored_end.icon_state = "stored_end"
	src.stored_end.layer = SCREEN_LAYER

	src.closer = new /obj/screen/close(  )
	src.closer.master = src
	src.closer.icon_state = "x"
	src.closer.layer = SCREEN_LAYER
	orient2hud()

	if(startswith)
		for(var/item_path in startswith)
			var/list/data = startswith[item_path]
			if(islist(data))
				var/qty = data[1]
				var/list/argsl = data.Copy()
				argsl[1] = src
				for(var/i in 1 to qty)
					new item_path(arglist(argsl))
			else
				for(var/i in 1 to (isnull(data)? 1 : data))
					new item_path(src)
		update_icon()

/obj/item/weapon/storage/emp_act(severity)
	if(!istype(src.loc, /mob/living))
		for(var/obj/O in contents)
			O.emp_act(severity)
	..()

/obj/item/weapon/storage/attack_self(mob/user as mob)
	//Clicking on itself will empty it, if it has the verb to do that.
	if(user.get_active_hand() == src)
		if(src.verbs.Find(/obj/item/weapon/storage/verb/quick_empty))
			src.quick_empty()
			return 1

/obj/item/weapon/storage/proc/make_exact_fit()
	storage_slots = contents.len

	can_hold.Cut()
	max_w_class = 0
	max_storage_space = 0
	for(var/obj/item/I in src)
		can_hold[I.type]++
		max_w_class = max(I.w_class, max_w_class)
		max_storage_space += I.get_storage_cost()

//Returns the storage depth of an atom. This is the number of storage items the atom is contained in before reaching toplevel (the area).
//Returns -1 if the atom was not found on container.
/atom/proc/storage_depth(atom/container)
	var/depth = 0
	var/atom/cur_atom = src

	while (cur_atom && !(cur_atom in container.contents))
		if (isarea(cur_atom))
			return -1
		if (istype(cur_atom.loc, /obj/item/weapon/storage))
			depth++
		cur_atom = cur_atom.loc

	if (!cur_atom)
		return -1	//inside something with a null loc.

	return depth

//Like storage depth, but returns the depth to the nearest turf
//Returns -1 if no top level turf (a loc was null somewhere, or a non-turf atom's loc was an area somehow).
/atom/proc/storage_depth_turf()
	var/depth = 0
	var/atom/cur_atom = src

	while (cur_atom && !isturf(cur_atom))
		if (isarea(cur_atom))
			return -1
		if (istype(cur_atom.loc, /obj/item/weapon/storage))
			depth++
		cur_atom = cur_atom.loc

	if (!cur_atom)
		return -1	//inside something with a null loc.

	return depth

/obj/item/proc/get_storage_cost()
	//If you want to prevent stuff above a certain w_class from being stored, use max_w_class
	return base_storage_cost(w_class)
