/datum/storage_ui/default
	var/list/is_seeing = new/list() //List of mobs which are currently seeing the contents of this item's storage

	var/obj/screen/storage/boxes
	var/obj/screen/storage/storage_start //storage UI
	var/obj/screen/storage/storage_continue
	var/obj/screen/storage/storage_end
	var/obj/screen/storage/stored_start
	var/obj/screen/storage/stored_continue
	var/obj/screen/storage/stored_end
	var/obj/screen/close/closer

/datum/storage_ui/default/New(var/storage)
	..()
	boxes = new /obj/screen/storage(  )
	boxes.name = "storage"
	boxes.master = storage
	boxes.icon_state = "block"
	boxes.screen_loc = "7,7 to 10,8"
	boxes.layer = HUD_BASE_LAYER

	storage_start = new /obj/screen/storage(  )
	storage_start.name = "storage"
	storage_start.master = storage
	storage_start.icon_state = "storage_start"
	storage_start.screen_loc = "7,7 to 10,8"
	storage_start.layer = HUD_BASE_LAYER
	storage_continue = new /obj/screen/storage(  )
	storage_continue.name = "storage"
	storage_continue.master = storage
	storage_continue.icon_state = "storage_continue"
	storage_continue.screen_loc = "7,7 to 10,8"
	storage_continue.layer = HUD_BASE_LAYER
	storage_end = new /obj/screen/storage(  )
	storage_end.name = "storage"
	storage_end.master = storage
	storage_end.icon_state = "storage_end"
	storage_end.screen_loc = "7,7 to 10,8"
	storage_end.layer = HUD_BASE_LAYER

	stored_start = new /obj //we just need these to hold the icon
	stored_start.icon_state = "stored_start"
	stored_start.layer = HUD_BASE_LAYER
	stored_continue = new /obj
	stored_continue.icon_state = "stored_continue"
	stored_continue.layer = HUD_BASE_LAYER
	stored_end = new /obj
	stored_end.icon_state = "stored_end"
	stored_end.layer = HUD_BASE_LAYER

	closer = new /obj/screen/close(  )
	closer.master = storage
	closer.icon_state = "x"
	closer.layer = HUD_BASE_LAYER

/datum/storage_ui/default/Destroy()
	close_all()
	qdel_null(boxes)
	qdel_null(storage_start)
	qdel_null(storage_continue)
	qdel_null(storage_end)
	qdel_null(stored_start)
	qdel_null(stored_continue)
	qdel_null(stored_end)
	qdel_null(closer)
	. = ..()

/datum/storage_ui/default/on_open(var/mob/user)
	if (user.s_active)
		user.s_active.close(user)

/datum/storage_ui/default/after_close(var/mob/user)
	user.s_active = null

/datum/storage_ui/default/on_insertion(var/mob/user)
	if(user.s_active)
		user.s_active.show_to(user)

/datum/storage_ui/default/on_pre_remove(var/mob/user, var/obj/item/W)
	for(var/mob/M in range(1, storage.loc))
		if (M.s_active == storage)
			if (M.client)
				M.client.screen -= W

/datum/storage_ui/default/on_post_remove(var/mob/user)
	if(user.s_active)
		user.s_active.show_to(user)

/datum/storage_ui/default/on_hand_attack(var/mob/user)
	for(var/mob/M in range(1))
		if (M.s_active == storage)
			storage.close(M)

/datum/storage_ui/default/show_to(var/mob/user)
	if(user.s_active != storage)
		for(var/obj/item/I in storage)
			if(I.on_found(user))
				return
	if(user.s_active)
		user.s_active.hide_from(user)
	user.client.screen -= boxes
	user.client.screen -= storage_start
	user.client.screen -= storage_continue
	user.client.screen -= storage_end
	user.client.screen -= closer
	user.client.screen -= storage.contents
	user.client.screen += closer
	user.client.screen += storage.contents
	if(storage.storage_slots)
		user.client.screen += boxes
	else
		user.client.screen += storage_start
		user.client.screen += storage_continue
		user.client.screen += storage_end
	is_seeing |= user
	user.s_active = storage

/datum/storage_ui/default/hide_from(var/mob/user)
	is_seeing -= user
	if(!user.client)
		return
	user.client.screen -= boxes
	user.client.screen -= storage_start
	user.client.screen -= storage_continue
	user.client.screen -= storage_end
	user.client.screen -= closer
	user.client.screen -= storage.contents
	if(user.s_active == storage)
		user.s_active = null

//Creates the storage UI
/datum/storage_ui/default/prepare_ui()
	//if storage slots is null then use the storage space UI, otherwise use the slots UI
	if(storage.storage_slots == null)
		space_orient_objs()
	else
		slot_orient_objs()

/datum/storage_ui/default/close_all()
	for(var/mob/M in can_see_contents())
		storage.close(M)
		. = 1

/datum/storage_ui/default/proc/can_see_contents()
	var/list/cansee = list()
	for(var/mob/M in is_seeing)
		if(M.s_active == storage && M.client)
			cansee |= M
		else
			is_seeing -= M
	return cansee

//This proc draws out the inventory and places the items on it. tx and ty are the upper left tile and mx, my are the bottm right.
//The numbers are calculated from the bottom-left The bottom-left slot being 1,1.
/datum/storage_ui/default/proc/orient_objs(tx, ty, mx, my)
	var/cx = tx
	var/cy = ty
	boxes.screen_loc = "[tx]:,[ty] to [mx],[my]"
	for(var/obj/O in storage.contents)
		O.screen_loc = "[cx],[cy]"
		O.hud_layerise()
		cx++
		if (cx > mx)
			cx = tx
			cy--
	closer.screen_loc = "[mx+1],[my]"
	return

//This proc determins the size of the inventory to be displayed. Please touch it only if you know what you're doing.
/datum/storage_ui/default/proc/slot_orient_objs()
	var/adjusted_contents = storage.contents.len
	var/row_num = 0
	var/col_count = min(7,storage.storage_slots) -1
	if (adjusted_contents > 7)
		row_num = round((adjusted_contents-1) / 7) // 7 is the maximum allowed width.
	arrange_item_slots(row_num, col_count)

//This proc draws out the inventory and places the items on it. It uses the standard position.
/datum/storage_ui/default/proc/arrange_item_slots(var/rows, var/cols)
	var/cx = 4
	var/cy = 2+rows
	boxes.screen_loc = "4:16,2:16 to [4+cols]:16,[2+rows]:16"

	for(var/obj/O in storage.contents)
		O.screen_loc = "[cx]:16,[cy]:16"
		O.maptext = ""
		O.hud_layerise()
		cx++
		if (cx > (4+cols))
			cx = 4
			cy--

	closer.screen_loc = "[4+cols+1]:16,2:16"

/datum/storage_ui/default/proc/space_orient_objs()

	var/baseline_max_storage_space = DEFAULT_BOX_STORAGE //storage size corresponding to 224 pixels
	var/storage_cap_width = 2 //length of sprite for start and end of the box representing total storage space
	var/stored_cap_width = 4 //length of sprite for start and end of the box representing the stored item
	var/storage_width = min( round( 224 * storage.max_storage_space/baseline_max_storage_space ,1) ,284) //length of sprite for the box representing total storage space

	storage_start.overlays.Cut()

	var/matrix/M = matrix()
	M.Scale((storage_width-storage_cap_width*2+3)/32,1)
	storage_continue.transform = M

	storage_start.screen_loc = "4:16,2:16"
	storage_continue.screen_loc = "4:[storage_cap_width+(storage_width-storage_cap_width*2)/2+2],2:16"
	storage_end.screen_loc = "4:[19+storage_width-storage_cap_width],2:16"

	var/startpoint = 0
	var/endpoint = 1

	for(var/obj/item/O in storage.contents)
		startpoint = endpoint + 1
		endpoint += storage_width * O.get_storage_cost()/storage.max_storage_space

		var/matrix/M_start = matrix()
		var/matrix/M_continue = matrix()
		var/matrix/M_end = matrix()
		M_start.Translate(startpoint,0)
		M_continue.Scale((endpoint-startpoint-stored_cap_width*2)/32,1)
		M_continue.Translate(startpoint+stored_cap_width+(endpoint-startpoint-stored_cap_width*2)/2 - 16,0)
		M_end.Translate(endpoint-stored_cap_width,0)
		stored_start.transform = M_start
		stored_continue.transform = M_continue
		stored_end.transform = M_end
		storage_start.overlays += stored_start
		storage_start.overlays += stored_continue
		storage_start.overlays += stored_end

		O.screen_loc = "4:[round((startpoint+endpoint)/2)+2],2:16"
		O.maptext = ""
		O.hud_layerise()

	closer.screen_loc = "4:[storage_width+19],2:16"

// Sets up numbered display to show the stack size of each stored mineral
// NOTE: numbered display is turned off currently because it's broken
/datum/storage_ui/default/sheetsnatcher/prepare_ui(var/mob/user)
	var/adjusted_contents = storage.contents.len

	var/row_num = 0
	var/col_count = min(7,storage.storage_slots) -1
	if (adjusted_contents > 7)
		row_num = round((adjusted_contents-1) / 7) // 7 is the maximum allowed width.
	arrange_item_slots(row_num, col_count)
	if(user && user.s_active)
		user.s_active.show_to(user)
