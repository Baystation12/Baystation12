/obj/structure/noticeboard
	name = "notice board"
	desc = "A board for pinning important notices upon."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "nboard00"
	density = FALSE
	anchored = TRUE
	layer = ABOVE_WINDOW_LAYER
	var/list/notices
	var/base_icon_state = "nboard0"
	var/const/max_notices = 5

/obj/structure/noticeboard/Initialize()

	. = ..()

	// Grab any mapped notices.
	notices = list()
	for(var/obj/item/paper/note in get_turf(src))
		note.forceMove(src)
		LAZYADD(notices, note)
		if(LAZYLEN(notices) >= max_notices)
			break

	// Automatically place noticeboards that aren't mapped to specific positions.
	if(pixel_x == 0 && pixel_y == 0)

		var/turf/here = get_turf(src)
		var/placing = 0
		for(var/checkdir in GLOB.cardinal)
			var/turf/T = get_step(here, checkdir)
			if(T.density)
				placing = checkdir
				break
			for(var/thing in T)
				var/atom/A = thing
				if(A.simulated && !A.CanPass(src, T))
					placing = checkdir
					break

		switch(placing)
			if(NORTH)
				pixel_x = 0
				pixel_y = 32
			if(SOUTH)
				pixel_x = 0
				pixel_y = -32
			if(EAST)
				pixel_x = 32
				pixel_y = 0
			if(WEST)
				pixel_x = -32
				pixel_y = 0

	update_icon()

/obj/structure/noticeboard/proc/add_paper(var/atom/movable/paper, var/skip_icon_update)
	if(istype(paper))
		LAZYDISTINCTADD(notices, paper)
		paper.forceMove(src)
		if(!skip_icon_update)
			update_icon()

/obj/structure/noticeboard/proc/remove_paper(var/atom/movable/paper, var/skip_icon_update)
	if(istype(paper) && paper.loc == src)
		paper.dropInto(loc)
		LAZYREMOVE(notices, paper)
		SSpersistence.forget_value(paper, /datum/persistent/paper)
		if(!skip_icon_update)
			update_icon()

/obj/structure/noticeboard/proc/dismantle()
	for(var/thing in notices)
		remove_paper(thing, skip_icon_update = TRUE)
	new /obj/item/stack/material(get_turf(src), 10, MATERIAL_WOOD)
	qdel(src)

/obj/structure/noticeboard/Destroy()
	QDEL_NULL_LIST(notices)
	. = ..()

/obj/structure/noticeboard/ex_act(var/severity)
	dismantle()

/obj/structure/noticeboard/on_update_icon()
	icon_state = "[base_icon_state][LAZYLEN(notices)]"

/obj/structure/noticeboard/attackby(var/obj/item/thing, var/mob/user)
	if(isScrewdriver(thing))
		var/choice = input("Which direction do you wish to place the noticeboard?", "Noticeboard Offset") as null|anything in list("North", "South", "East", "West")
		if(choice && Adjacent(user) && thing.loc == user && !user.incapacitated())
			playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)
			switch(choice)
				if("North")
					pixel_x = 0
					pixel_y = 32
				if("South")
					pixel_x = 0
					pixel_y = -32
				if("East")
					pixel_x = 32
					pixel_y = 0
				if("West")
					pixel_x = -32
					pixel_y = 0
		return
	else if(isWrench(thing))
		visible_message(SPAN_WARNING("\The [user] begins dismantling \the [src]."))
		playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
		if(do_after(user, 50, src))
			visible_message(SPAN_DANGER("\The [user] has dismantled \the [src]!"))
			dismantle()
		return
	else if(istype(thing, /obj/item/paper) || istype(thing, /obj/item/photo))
		if(jobban_isbanned(user, "Graffiti"))
			to_chat(user, SPAN_WARNING("You are banned from leaving persistent information across rounds."))
		else
			if(LAZYLEN(notices) < max_notices && user.unEquip(thing, src))
				add_fingerprint(user)
				add_paper(thing)
				to_chat(user, SPAN_NOTICE("You pin \the [thing] to \the [src]."))
				SSpersistence.track_value(thing, /datum/persistent/paper)
			else
				to_chat(user, SPAN_WARNING("You hesitate, certain \the [thing] will not be seen among the many others already attached to \the [src]."))
		return
	..()

/obj/structure/noticeboard/attack_ai(var/mob/user)
	examine(user)

/obj/structure/noticeboard/attack_hand(var/mob/user)
	examine(user)

/obj/structure/noticeboard/examine(mob/user)
	. = ..()
	var/list/dat = list("<table>")
	for(var/thing in notices)
		LAZYADD(dat, "<tr><td>[thing]</td><td>")
		if(istype(thing, /obj/item/paper))
			LAZYADD(dat, "<a href='?src=\ref[src];read=\ref[thing]'>Read</a><a href='?src=\ref[src];write=\ref[thing]'>Write</a>")
		else if(istype(thing, /obj/item/photo))
			LAZYADD(dat, "<a href='?src=\ref[src];look=\ref[thing]'>Look</a>")
		LAZYADD(dat, "<a href='?src=\ref[src];remove=\ref[thing]'>Remove</a></td></tr>")
	var/datum/browser/popup = new(user, "noticeboard-\ref[src]", "Noticeboard")
	popup.set_content(jointext(dat, null))
	popup.open()

/obj/structure/noticeboard/OnTopic(var/mob/user, var/list/href_list)

	if(href_list["read"])
		var/obj/item/paper/P = locate(href_list["read"])
		if(P && P.loc == src)
			P.show_content(user)
		. = TOPIC_HANDLED

	if(href_list["look"])
		var/obj/item/photo/P = locate(href_list["look"])
		if(P && P.loc == src)
			P.show(user)
		. = TOPIC_HANDLED

	if(href_list["remove"])
		remove_paper(locate(href_list["remove"]))
		add_fingerprint(user)
		. = TOPIC_REFRESH

	if(href_list["write"])
		var/obj/item/P = locate(href_list["write"])
		if(!P)
			return
		var/obj/item/pen/pen = user.r_hand
		if(!istype(pen))
			pen = user.l_hand
		if(istype(pen))
			add_fingerprint(user)
			P.attackby(pen, user)
		else
			to_chat(user, SPAN_WARNING("You need a pen to write on \the [P]."))
		. = TOPIC_REFRESH

	if(. == TOPIC_REFRESH)
		interact(user)

/obj/structure/noticeboard/anomaly
	icon_state = "nboard05"

/obj/structure/noticeboard/anomaly/Initialize()
	. = ..()
	var/obj/item/paper/P = new()
	P.SetName("Memo RE: proper analysis procedure")
	P.info = "<br>We keep test dummies in pens here for a reason, so standard procedure should be to activate newfound alien artifacts and place the two in close proximity. Promising items I might even approve monkey testing on."
	P.stamped = list(/obj/item/stamp/rd)
	P.overlays = list("paper_stamped_rd")
	add_paper(P, skip_icon_update = TRUE)

	P = new()
	P.SetName("Memo RE: materials gathering")
	P.info = "Corasang,<br>the hands-on approach to gathering our samples may very well be slow at times, but it's safer than allowing the blundering miners to roll willy-nilly over our dig sites in their mechs, destroying everything in the process. And don't forget the escavation tools on your way out there!<br>- R.W"
	P.stamped = list(/obj/item/stamp/rd)
	P.overlays = list("paper_stamped_rd")
	add_paper(P, skip_icon_update = TRUE)

	P = new()
	P.SetName("Memo RE: ethical quandaries")
	P.info = "Darion-<br><br>I don't care what his rank is, our business is that of science and knowledge - questions of moral application do not come into this. Sure, so there are those who would employ the energy-wave particles my modified device has managed to abscond for their own personal gain, but I can hardly see the practical benefits of some of these artifacts our benefactors left behind. Ward--"
	P.stamped = list(/obj/item/stamp/rd)
	P.overlays = list("paper_stamped_rd")
	add_paper(P, skip_icon_update = TRUE)

	P = new()
	P.SetName("READ ME! Before you people destroy any more samples")
	P.info = "how many times do i have to tell you people, these xeno-arch samples are del-i-cate, and should be handled so! careful application of a focussed, concentrated heat or some corrosive liquids should clear away the extraneous carbon matter, while application of an energy beam will most decidedly destroy it entirely - like someone did to the chemical dispenser! W, <b>the one who signs your paychecks</b>"
	P.stamped = list(/obj/item/stamp/rd)
	P.overlays = list("paper_stamped_rd")
	add_paper(P, skip_icon_update = TRUE)

	P = new()
	P.SetName("Reminder regarding the anomalous material suits")
	P.info = "Do you people think the anomaly suits are cheap to come by? I'm about a hair trigger away from instituting a log book for the damn things. Only wear them if you're going out for a dig, and for god's sake don't go tramping around in them unless you're field testing something, R"
	P.stamped = list(/obj/item/stamp/rd)
	P.overlays = list("paper_stamped_rd")
	add_paper(P)
