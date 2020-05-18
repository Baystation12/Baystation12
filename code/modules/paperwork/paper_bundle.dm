/obj/item/weapon/paper_bundle
	name = "paper bundle"
	gender = NEUTER
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "paper"
	item_state = "paper"
	randpixel = 8
	throwforce = 0
	w_class = ITEM_SIZE_SMALL
	throw_range = 2
	throw_speed = 1
	layer = ABOVE_OBJ_LAYER
	attack_verb = list("bapped")
	var/page = 1    // current page
	var/list/pages = list()  // Ordered list of pages as they are to be displayed. Can be different order than src.contents.


/obj/item/weapon/paper_bundle/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(!istype(W))
		return
	var/obj/item/weapon/paper/paper = W
	if(istype(paper) && !paper.can_bundle())
		return //non-paper or bundlable paper only
	if (istype(W, /obj/item/weapon/paper/carbon))
		var/obj/item/weapon/paper/carbon/C = W
		if (!C.iscopy && !C.copied)
			to_chat(user, "<span class='notice'>Take off the carbon copy first.</span>")
			add_fingerprint(user)
			return
	// adding sheets
	if(istype(W, /obj/item/weapon/paper) || istype(W, /obj/item/weapon/photo))
		insert_sheet_at(user, pages.len+1, W)

	// burning
	else if(istype(W, /obj/item/weapon/flame))
		burnpaper(W, user)

	// merging bundles
	else if(istype(W, /obj/item/weapon/paper_bundle))
		for(var/obj/O in W)
			O.forceMove(src)
			O.add_fingerprint(user)
			pages.Add(O)

		to_chat(user, "<span class='notice'>You add \the [W.name] to [(src.name == "paper bundle") ? "the paper bundle" : src.name].</span>")
		qdel(W)
	else
		if(istype(W, /obj/item/weapon/tape_roll))
			return 0
		if(istype(W, /obj/item/weapon/pen))
			show_browser(user, "", "window=[name]") //Closes the dialog
		var/obj/P = pages[page]
		P.attackby(W, user)

	update_icon()
	attack_self(user) //Update the browsed page.
	add_fingerprint(user)
	return

/obj/item/weapon/paper_bundle/proc/insert_sheet_at(mob/user, var/index, obj/item/weapon/sheet)
	if (!user.unEquip(sheet, src))
		return
	var/bundle_name = "paper bundle"
	var/sheet_name = istype(sheet, /obj/item/weapon/photo) ? "photo" : "sheet of paper"
	bundle_name = (bundle_name == name) ? "the [bundle_name]" : name
	sheet_name = (sheet_name == sheet.name) ? "the [sheet_name]" : sheet.name
	
	to_chat(user, "<span class='notice'>You add [sheet_name] to [bundle_name].</span>")
	pages.Insert(index, sheet)
	if(index <= page)
		page++

/obj/item/weapon/paper_bundle/proc/burnpaper(obj/item/weapon/flame/P, mob/user)
	var/class = "warning"

	if(P.lit && !user.restrained())
		if(istype(P, /obj/item/weapon/flame/lighter/zippo))
			class = "rose>"

		user.visible_message("<span class='[class]'>[user] holds \the [P] up to \the [src], it looks like \he's trying to burn it!</span>", \
		"<span class='[class]'>You hold \the [P] up to \the [src], burning it slowly.</span>")

		spawn(20)
			if(get_dist(src, user) < 2 && user.get_active_hand() == P && P.lit)
				user.visible_message("<span class='[class]'>[user] burns right through \the [src], turning it to ash. It flutters through the air before settling on the floor in a heap.</span>", \
				"<span class='[class]'>You burn right through \the [src], turning it to ash. It flutters through the air before settling on the floor in a heap.</span>")

				if(user.get_inactive_hand() == src)
					user.drop_from_inventory(src)

				new /obj/effect/decal/cleanable/ash(src.loc)
				qdel(src)

			else
				to_chat(user, "<span class='warning'>You must hold \the [P] steady to burn \the [src].</span>")

/obj/item/weapon/paper_bundle/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		src.show_content(user)
	else
		to_chat(user, "<span class='notice'>It is too far away.</span>")

/obj/item/weapon/paper_bundle/proc/show_content(mob/user as mob)
	var/dat
	var/obj/item/weapon/W = pages[page]

	// first
	if(page == 1)
		dat+= "<DIV STYLE='float:left; text-align:left; width:33.33333%'><A href='?src=\ref[src];prev_page=1'>Front</A></DIV>"
		dat+= "<DIV STYLE='float:left; text-align:center; width:33.33333%'><A href='?src=\ref[src];remove=1'>Remove [(istype(W, /obj/item/weapon/paper)) ? "paper" : "photo"]</A></DIV>"
		dat+= "<DIV STYLE='float:left; text-align:right; width:33.33333%'><A href='?src=\ref[src];next_page=1'>Next Page</A></DIV><BR><HR>"
	// last
	else if(page == pages.len)
		dat+= "<DIV STYLE='float:left; text-align:left; width:33.33333%'><A href='?src=\ref[src];prev_page=1'>Previous Page</A></DIV>"
		dat+= "<DIV STYLE='float:left; text-align:center; width:33.33333%'><A href='?src=\ref[src];remove=1'>Remove [(istype(W, /obj/item/weapon/paper)) ? "paper" : "photo"]</A></DIV>"
		dat+= "<DIV STYLE='float;left; text-align:right; with:33.33333%'><A href='?src=\ref[src];next_page=1'>Back</A></DIV><BR><HR>"
	// middle pages
	else
		dat+= "<DIV STYLE='float:left; text-align:left; width:33.33333%'><A href='?src=\ref[src];prev_page=1'>Previous Page</A></DIV>"
		dat+= "<DIV STYLE='float:left; text-align:center; width:33.33333%'><A href='?src=\ref[src];remove=1'>Remove [(istype(W, /obj/item/weapon/paper)) ? "paper" : "photo"]</A></DIV>"
		dat+= "<DIV STYLE='float:left; text-align:right; width:33.33333%'><A href='?src=\ref[src];next_page=1'>Next Page</A></DIV><BR><HR>"

	if(istype(pages[page], /obj/item/weapon/paper))
		var/obj/item/weapon/paper/P = W
		dat+= "<HTML><HEAD><TITLE>[P.name]</TITLE></HEAD><BODY>[P.show_info(user)][P.stamps]</BODY></HTML>"
		show_browser(user, dat, "window=[name]")
	else if(istype(pages[page], /obj/item/weapon/photo))
		var/obj/item/weapon/photo/P = W
		dat += "<html><head><title>[P.name]</title></head><body style='overflow:hidden'>"
		dat += "<div> <img src='tmp_photo.png' width = '180'[P.scribble ? "<div> Written on the back:<br><i>[P.scribble]</i>" : null ]</body></html>"
		send_rsc(user, P.img, "tmp_photo.png")
		show_browser(user, JOINTEXT(dat), "window=[name]")

/obj/item/weapon/paper_bundle/attack_self(mob/user as mob)
	src.show_content(user)
	add_fingerprint(user)
	update_icon()
	return

/obj/item/weapon/paper_bundle/Topic(href, href_list)
	if(..())
		return 1
	if((src in usr.contents) || (istype(src.loc, /obj/item/weapon/folder) && (src.loc in usr.contents)))
		usr.set_machine(src)
		var/obj/item/weapon/in_hand = usr.get_active_hand()
		if(href_list["next_page"])
			if(in_hand && (istype(in_hand, /obj/item/weapon/paper) || istype(in_hand, /obj/item/weapon/photo)))
				insert_sheet_at(usr, page+1, in_hand)
			else if(page != pages.len)
				page++
				playsound(src.loc, "pageturn", 50, 1)
		if(href_list["prev_page"])
			if(in_hand && (istype(in_hand, /obj/item/weapon/paper) || istype(in_hand, /obj/item/weapon/photo)))
				insert_sheet_at(usr, page, in_hand)
			else if(page > 1)
				page--
				playsound(src.loc, "pageturn", 50, 1)
		if(href_list["remove"])
			var/obj/item/weapon/W = pages[page]
			usr.put_in_hands(W)
			pages.Remove(pages[page])

			to_chat(usr, "<span class='notice'>You remove the [W.name] from the bundle.</span>")

			if(pages.len <= 1)
				var/obj/item/weapon/paper/P = src[1]
				usr.drop_from_inventory(src)
				usr.put_in_hands(P)
				qdel(src)

				return

			if(page > pages.len)
				page = pages.len

			update_icon()

		src.attack_self(usr)
		updateUsrDialog()
	else
		to_chat(usr, "<span class='notice'>You need to hold it in hands!</span>")

/obj/item/weapon/paper_bundle/verb/rename()
	set name = "Rename bundle"
	set category = "Object"
	set src in usr

	var/n_name = sanitizeSafe(input(usr, "What would you like to label the bundle?", "Bundle Labelling", null)  as text, MAX_NAME_LEN)
	if((loc == usr || loc.loc && loc.loc == usr) && usr.stat == 0)
		SetName("[(n_name ? text("[n_name]") : "paper")]")
	add_fingerprint(usr)
	return


/obj/item/weapon/paper_bundle/verb/remove_all()
	set name = "Loose bundle"
	set category = "Object"
	set src in usr

	to_chat(usr, "<span class='notice'>You loosen the bundle.</span>")
	for(var/obj/O in src)
		O.dropInto(usr.loc)
		O.reset_plane_and_layer()
		O.add_fingerprint(usr)
	qdel(src)


/obj/item/weapon/paper_bundle/on_update_icon()
	var/obj/item/weapon/paper/P = pages[1]
	icon_state = P.icon_state
	overlays = P.overlays
	underlays.Cut()
	var/i = 0
	var/photo
	for(var/obj/O in src)
		var/image/img = image('icons/obj/bureaucracy.dmi')
		if(istype(O, /obj/item/weapon/paper))
			img.icon_state = O.icon_state
			img.pixel_x -= min(1*i, 2)
			img.pixel_y -= min(1*i, 2)
			pixel_x = min(0.5*i, 1)
			pixel_y = min(  1*i, 2)
			underlays += img
			i++
		else if(istype(O, /obj/item/weapon/photo))
			var/obj/item/weapon/photo/Ph = O
			img = Ph.tiny
			photo = 1
			overlays += img
	if(i>1)
		desc =  "[i] papers clipped to each other."
	else
		desc = "A single sheet of paper."
	if(photo)
		desc += "\nThere is a photo attached to it."
	overlays += image('icons/obj/bureaucracy.dmi', "clip")
	return
