/obj/structure/bigDelivery
	desc = "A big wrapped package."
	name = "large parcel"
	icon = 'icons/obj/storage.dmi'
	icon_state = "deliverycloset"
	health_max = 5
	var/obj/wrapped = null
	density = TRUE
	var/sortTag = null
	mouse_drag_pointer = MOUSE_ACTIVE_POINTER
	var/examtext = null
	var/nameset = 0
	var/label_y
	var/label_x
	var/tag_x


/obj/structure/bigDelivery/Destroy()
	QDEL_NULL(wrapped)
	return ..()


/obj/structure/bigDelivery/damage_health(damage, damage_type, damage_flags, severity, skip_can_damage_check)
	// It's only paper. No protection for anything inside.
	var/content_damage = damage / length(contents)
	for (var/atom/victim as anything in contents)
		victim.damage_health(content_damage, damage_type, damage_flags, severity, skip_can_damage_check)
	return ..()


/obj/structure/bigDelivery/on_death()
	. = ..()
	visible_message(
		SPAN_WARNING("\The [src]'s wrapping falls away!")
	)
	if (wrapped)
		wrapped.dropInto(loc)
		wrapped = null
	for (var/atom/movable/victim as anything in contents)
		victim.dropInto(loc)
	qdel_self()


/obj/structure/bigDelivery/attack_robot(mob/user as mob)
	unwrap(user)

/obj/structure/bigDelivery/attack_hand(mob/user as mob)
	unwrap(user)


/obj/structure/bigDelivery/proc/unwrap(mob/user)
	if(Adjacent(user))
		// Destroy will drop our wrapped object on the turf, so let it.
		qdel(src)


/obj/structure/bigDelivery/use_tool(obj/item/tool, mob/user, list/click_params)
	// Destination Tagger - Tag
	if (istype(tool, /obj/item/device/destTagger))
		var/obj/item/device/destTagger/tagger = tool
		if (!tagger.currTag)
			USE_FEEDBACK_FAILURE("\The [tool] does not have a tag set.")
			return TRUE
		if (tagger.currTag == sortTag)
			USE_FEEDBACK_FAILURE("\The [src] is already tagged for [sortTag].")
			return TRUE
		sortTag = tagger.currTag
		update_icon()
		playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 1)
		user.visible_message(
			SPAN_NOTICE("\The [user] tags \the [src] with \a [tool]."),
			SPAN_NOTICE("You tag \the [src] as [sortTag] with \the [tool].")
		)
		return TRUE

	// Pen - Label
	if (istype(tool, /obj/item/pen))
		var/input = alert(user, "What would you like to alter?", "[name] - Label", "Title", "Description", "Cancel")
		if (input == "Cancel" || !user.use_sanity_check(src, tool))
			return TRUE
		if (input == "Title")
			var/new_title = input(user, "What would you like to set the label to?", "[name] - Label Title") as null|text
			new_title = sanitizeSafe(new_title, MAX_NAME_LEN)
			if (!new_title || !user.use_sanity_check(src, tool))
				return TRUE
			user.visible_message(
				SPAN_NOTICE("\The [user] updates \the [src]'s label with \a [tool]."),
				SPAN_NOTICE("You set \the [src]'s label title to '[new_title]' with \the [tool].")
			)
			SetName("[initial(name)] ([new_title])")
			update_icon()
			nameset = TRUE
		else if (input == "Description")
			var/new_desc = input(user, "What would you like to set the label to?", "[name] - Label Title") as null|text
			new_desc = sanitizeSafe(new_desc, MAX_NAME_LEN)
			if (!new_desc || !user.use_sanity_check(src, tool))
				return TRUE
			user.visible_message(
				SPAN_NOTICE("\The [user] updates \the [src]'s label with \a [tool]."),
				SPAN_NOTICE("You set \the [src]'s label description to '[new_desc]' with \the [tool].")
			)
			examtext = new_desc
			update_icon()
			nameset = TRUE
		return TRUE

	return ..()


/obj/structure/bigDelivery/on_update_icon()
	overlays.Cut()
	if(nameset || examtext)
		var/image/I = new/image('icons/obj/storage.dmi',"delivery_label")
		if(icon_state == "deliverycloset")
			I.pixel_x = 2
			if(label_y == null)
				label_y = rand(-6, 11)
			I.pixel_y = label_y
		else if(icon_state == "deliverycrate")
			if(label_x == null)
				label_x = rand(-8, 6)
			I.pixel_x = label_x
			I.pixel_y = -3
		overlays += I
	if(src.sortTag)
		var/image/I = new/image('icons/obj/storage.dmi',"delivery_tag")
		if(icon_state == "deliverycloset")
			if(tag_x == null)
				tag_x = rand(-2, 3)
			I.pixel_x = tag_x
			I.pixel_y = 9
		else if(icon_state == "deliverycrate")
			if(tag_x == null)
				tag_x = rand(-8, 6)
			I.pixel_x = tag_x
			I.pixel_y = -3
		overlays += I

/obj/structure/bigDelivery/examine(mob/user, distance)
	. = ..()
	if(distance <= 4)
		if(sortTag)
			to_chat(user, SPAN_NOTICE("It is labeled \"[sortTag]\""))
		if(examtext)
			to_chat(user, SPAN_NOTICE("It has a note attached which reads, \"[examtext]\""))

/obj/structure/bigDelivery/Destroy()
	if(wrapped) //sometimes items can disappear. For example, bombs. --rastaf0
		wrapped.dropInto(loc)
		if(istype(wrapped, /obj/structure/closet))
			var/obj/structure/closet/O = wrapped
			O.welded = 0
		wrapped = null
	var/turf/T = get_turf(src)
	for(var/atom/movable/AM in contents)
		AM.forceMove(T)
	return ..()

/obj/item/smallDelivery
	desc = "A small wrapped package."
	name = "small parcel"
	icon = 'icons/obj/storage.dmi'
	icon_state = "deliverycrate3"
	health_max = 5
	var/obj/item/wrapped = null
	var/sortTag = null
	var/examtext = null
	var/nameset = 0
	var/tag_x


/obj/item/smallDelivery/Destroy()
	QDEL_NULL(wrapped)
	return ..()


/obj/item/smallDelivery/damage_health(damage, damage_type, damage_flags, severity, skip_can_damage_check)
	// It's only paper. No protection for anything inside.
	for (var/atom/victim as anything in contents)
		victim.damage_health(damage, damage_type, damage_flags, severity, skip_can_damage_check)
	return ..()


/obj/item/smallDelivery/on_death()
	. = ..()
	visible_message(
		SPAN_WARNING("\The [src]'s wrapping falls away!")
	)
	if (wrapped)
		wrapped.dropInto(loc)
		wrapped = null
	for (var/atom/movable/victim as anything in contents)
		victim.dropInto(loc)
	qdel_self()


/obj/item/smallDelivery/proc/unwrap(mob/user)
	if (!Adjacent(user))
		return
	if (!length(contents))
		to_chat(user, SPAN_NOTICE("\The [src] was empty!"))
		qdel_self()
		return

	user.drop_from_inventory(src)
	user.put_in_hands(wrapped)
	wrapped = null
	// Take out any other items that might be in the package
	for(var/obj/item/I in src)
		user.put_in_hands(I)

	qdel(src)

/obj/item/smallDelivery/attack_robot(mob/user as mob)
	unwrap(user)

/obj/item/smallDelivery/attack_self(mob/user as mob)
	unwrap(user)

/obj/item/smallDelivery/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/device/destTagger))
		var/obj/item/device/destTagger/O = W
		if(O.currTag)
			if(src.sortTag != O.currTag)
				to_chat(user, SPAN_NOTICE("You have labeled the destination as [O.currTag]."))
				if(!src.sortTag)
					src.sortTag = O.currTag
					update_icon()
				else
					src.sortTag = O.currTag
				playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 1)
			else
				to_chat(user, SPAN_WARNING("The package is already labeled for [O.currTag]."))
		else
			to_chat(user, SPAN_WARNING("You need to set a destination first!"))

	else if(istype(W, /obj/item/pen))
		switch(alert("What would you like to alter?",,"Title","Description", "Cancel"))
			if("Title")
				var/str = sanitizeSafe(input(usr,"Label text?","Set label",""), MAX_NAME_LEN)
				if(!str || !length(str))
					to_chat(usr, SPAN_WARNING(" Invalid text."))
					return
				user.visible_message("\The [user] titles \the [src] with \a [W], marking down: \"[str]\"",\
				SPAN_NOTICE("You title \the [src]: \"[str]\""),\
				"You hear someone scribbling a note.")
				SetName("[name] ([str])")
				if(!examtext && !nameset)
					nameset = 1
					update_icon()
				else
					nameset = 1

			if("Description")
				var/str = sanitize(input(usr,"Label text?","Set label",""))
				if(!str || !length(str))
					to_chat(usr, SPAN_WARNING("Invalid text."))
					return
				if(!examtext && !nameset)
					examtext = str
					update_icon()
				else
					examtext = str
				user.visible_message("\The [user] labels \the [src] with \a [W], scribbling down: \"[examtext]\"",\
				SPAN_NOTICE("You label \the [src]: \"[examtext]\""),\
				"You hear someone scribbling a note.")
	return

/obj/item/smallDelivery/on_update_icon()
	overlays.Cut()
	if((nameset || examtext) && icon_state != "deliverycrate1")
		var/image/I = new/image('icons/obj/storage.dmi',"delivery_label")
		if(icon_state == "deliverycrate5")
			I.pixel_y = -1
		overlays += I
	if(src.sortTag)
		var/image/I = new/image('icons/obj/storage.dmi',"delivery_tag")
		switch(icon_state)
			if("deliverycrate1")
				I.pixel_y = -5
			if("deliverycrate2")
				I.pixel_y = -2
			if("deliverycrate3")
				I.pixel_y = 0
			if("deliverycrate4")
				if(tag_x == null)
					tag_x = rand(0,5)
				I.pixel_x = tag_x
				I.pixel_y = 3
			if("deliverycrate5")
				I.pixel_y = -3
		overlays += I

/obj/item/smallDelivery/examine(mob/user, distance)
	. = ..()
	if(distance <= 4)
		if(sortTag)
			to_chat(user, SPAN_NOTICE("It is labeled \"[sortTag]\""))
		if(examtext)
			to_chat(user, SPAN_NOTICE("It has a note attached which reads, \"[examtext]\""))

/obj/item/stack/package_wrap
	name = "package wrapper"
	desc = "Heavy duty brown paper used to wrap packages to protect them during shipping."
	singular_name = "sheet"
	max_amount = 25
	icon = 'icons/obj/items.dmi'
	icon_state = "deliveryPaper"
	w_class = ITEM_SIZE_NORMAL

/obj/item/stack/package_wrap/twenty_five
	amount = 25


/obj/item/c_tube
	name = "cardboard tube"
	desc = "A tube... of cardboard."
	icon = 'icons/obj/items.dmi'
	icon_state = "c_tube"
	throwforce = 1
	w_class = ITEM_SIZE_SMALL
	throw_speed = 4
	throw_range = 5

/obj/item/stack/package_wrap/afterattack(obj/target as obj, mob/user as mob, proximity)
	if(!proximity) return
	if(!istype(target))	//this really shouldn't be necessary (but it is).	-Pete
		return
	if(istype(target, /obj/item/smallDelivery) || istype(target,/obj/structure/bigDelivery) \
	|| istype(target, /obj/item/gift) || istype(target, /obj/item/evidencebag))
		return
	if(target.anchored)
		return
	if(target in user)
		return
	if(user in target) //no wrapping closets that you are inside - it's not physically possible
		return

	if (istype(target, /obj/item) && !(istype(target, /obj/item/storage) && !istype(target,/obj/item/storage/box)))
		var/obj/item/O = target
		if (src.get_amount() >= 1)
			var/obj/item/smallDelivery/P = new /obj/item/smallDelivery(get_turf(O.loc))	//Aaannd wrap it up!
			if(!istype(O.loc, /turf))
				if(user.client)
					user.client.screen -= O
			P.wrapped = O
			O.forceMove(P)
			P.w_class = O.w_class
			var/i = round(O.w_class)
			if(i in list(1,2,3,4,5))
				P.icon_state = "deliverycrate[i]"
				switch(i)
					if(1) P.SetName("tiny parcel")
					if(3) P.SetName("normal-sized parcel")
					if(4) P.SetName("large parcel")
					if(5) P.SetName("huge parcel")
			if(i < 1)
				P.icon_state = "deliverycrate1"
				P.SetName("tiny parcel")
			if(i > 5)
				P.icon_state = "deliverycrate5"
				P.SetName("huge parcel")
			P.add_fingerprint(usr)
			O.add_fingerprint(usr)
			src.add_fingerprint(usr)
			src.use(1)
			user.visible_message("\The [user] wraps \a [target] with \a [src].",\
			SPAN_NOTICE("You wrap \the [target], leaving [src.get_amount()] units of paper on \the [src]."),\
			"You hear someone taping paper around a small object.")
		else
			// Should be possible only to see this as a borg?
			to_chat(user, SPAN_WARNING("The synthesizer is out of paper."))
	else if (istype(target, /obj/structure/closet/crate))
		var/obj/structure/closet/crate/O = target
		if (src.get_amount() >= 3 && !O.opened)
			var/obj/structure/bigDelivery/P = new /obj/structure/bigDelivery(get_turf(O.loc))
			P.icon_state = "deliverycrate"
			P.wrapped = O
			O.forceMove(P)
			src.use(3)
			user.visible_message("\The [user] wraps \a [target] with \a [src].",\
			SPAN_NOTICE("You wrap \the [target], leaving [src.get_amount()] units of paper on \the [src]."),\
			"You hear someone taping paper around a large object.")
		else if(src.get_amount() < 3)
			to_chat(user, SPAN_WARNING("You need more paper."))
	else if (istype (target, /obj/structure/closet))
		var/obj/structure/closet/O = target
		if (src.get_amount() >= 3 && !O.opened)
			var/obj/structure/bigDelivery/P = new /obj/structure/bigDelivery(get_turf(O.loc))
			P.wrapped = O
			O.welded = 1
			O.forceMove(P)
			src.use(3)
			user.visible_message("\The [user] wraps \a [target] with \a [src].",\
			SPAN_NOTICE("You wrap \the [target], leaving [src.get_amount()] units of paper on \the [src]."),\
			"You hear someone taping paper around a large object.")
		else if(src.get_amount() < 3)
			to_chat(user, SPAN_WARNING("You need more paper."))
	else
		to_chat(user, SPAN_NOTICE("The object you are trying to wrap is unsuitable for the sorting machinery!"))

	return

/obj/item/device/destTagger
	name = "destination tagger"
	desc = "Used to set the destination of properly wrapped packages."
	icon = 'icons/obj/destination_tagger.dmi'
	icon_state = "dest_tagger"
	var/currTag = 0
	w_class = ITEM_SIZE_SMALL
	item_state = "electronic"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	matter = list(MATERIAL_STEEL = 100, MATERIAL_GLASS = 34)

/obj/item/device/destTagger/proc/openwindow(mob/user as mob)
	var/dat = "<tt><center><h1><b>TagMaster 2.3</b></h1></center>"

	dat += "<table style='width:100%; padding:4px;'><tr>"
	for(var/i = 1 to length(GLOB.tagger_locations))
		dat += "<td><a href='?src=\ref[src];nextTag=[GLOB.tagger_locations[i]]'>[GLOB.tagger_locations[i]]</a></td>"

		if (i%4==0)
			dat += "</tr><tr>"

	dat += "</tr></table><br>Current Selection: [currTag ? currTag : "None"]</tt>"
	dat += "<br><a href='?src=\ref[src];nextTag=CUSTOM'>Enter custom location.</a>"
	show_browser(user, dat, "window=destTagScreen;size=450x375")
	onclose(user, "destTagScreen")

/obj/item/device/destTagger/attack_self(mob/user as mob)
	openwindow(user)

/obj/item/device/destTagger/OnTopic(user, href_list, state)
	if(href_list["nextTag"] && (href_list["nextTag"] in GLOB.tagger_locations))
		src.currTag = href_list["nextTag"]
		to_chat(user, SPAN_NOTICE("You set [src] to <b>[src.currTag]</b>."))
		playsound(src.loc, 'sound/machines/chime.ogg', 50, 1)
		. = TOPIC_REFRESH
	if(href_list["nextTag"] == "CUSTOM")
		var/dest = input(user, "Please enter custom location.", "Location", src.currTag ? src.currTag : "None")
		if(CanUseTopic(user, state))
			if(dest && lowertext(dest) != "none")
				src.currTag = dest
				to_chat(user, SPAN_NOTICE("You designate a custom location on [src], set to <b>[src.currTag]</b>."))
				playsound(src.loc, 'sound/machines/chime.ogg', 50, 1)
			else
				src.currTag = 0
				to_chat(user, SPAN_NOTICE("You clear [src]'s custom location."))
				playsound(src.loc, 'sound/machines/chime.ogg', 50, 1)
			. = TOPIC_REFRESH
		else
			. = TOPIC_HANDLED

	if(. == TOPIC_REFRESH)
		openwindow(user)

/obj/machinery/disposal/deliveryChute
	name = "Delivery chute"
	desc = "A chute for big and small packages alike!"
	density = TRUE
	icon_state = "intake"

	var/c_mode = 0

/obj/machinery/disposal/deliveryChute/New()
	..()
	spawn(5)
		trunk = locate() in src.loc
		if(trunk)
			trunk.linked = src	// link the pipe trunk to self

/obj/machinery/disposal/deliveryChute/interact()
	return

/obj/machinery/disposal/deliveryChute/on_update_icon()
	return

/obj/machinery/disposal/deliveryChute/Bumped(atom/movable/AM) //Go straight into the chute
	if(istype(AM, /obj/item/projectile) || istype(AM, /obj/effect))	return
	switch(dir)
		if(NORTH)
			if(AM.loc.y != src.loc.y+1) return
		if(EAST)
			if(AM.loc.x != src.loc.x+1) return
		if(SOUTH)
			if(AM.loc.y != src.loc.y-1) return
		if(WEST)
			if(AM.loc.x != src.loc.x-1) return

	var/mob/living/L = AM
	if (istype(L) && L.ckey)
		log_and_message_admins("has flushed themselves down \the [src].", L)
	if(istype(AM, /obj))
		var/obj/O = AM
		O.forceMove(src)
	else if(istype(AM, /mob))
		var/mob/M = AM
		M.forceMove(src)
	src.flush()

/obj/machinery/disposal/deliveryChute/flush()
	flushing = 1
	flick("intake-closing", src)
	var/obj/structure/disposalholder/H = new()	// virtual holder object which actually
												// travels through the pipes.
	air_contents = new()		// new empty gas resv.

	sleep(10)
	playsound(src, 'sound/machines/disposalflush.ogg', 50, 0, 0)
	sleep(5) // wait for animation to finish

	if(prob(35))
		for(var/mob/living/carbon/human/L in src)
			var/list/obj/item/organ/external/crush = L.get_damageable_organs()
			if(!length(crush))
				return

			var/obj/item/organ/external/E = pick(crush)

			E.take_external_damage(45, used_weapon = "Blunt Trauma")
			to_chat(L, "\The [src]'s mechanisms crush your [E.name]!")

	H.init(src)	// copy the contents of disposer to holder

	H.start(src) // start the holder processing movement
	flushing = 0
	// now reset disposal state
	flush = 0
	if(mode == 2)	// if was ready,
		mode = 1	// switch to charging
	update_icon()
	return

/obj/machinery/disposal/deliveryChute/attackby(obj/item/I, mob/user)
	if(!I || !user)
		return

	if(isScrewdriver(I))
		if(c_mode==0)
			c_mode=1
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
			to_chat(user, "You remove the screws around the power connection.")
			return
		else if(c_mode==1)
			c_mode=0
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
			to_chat(user, "You attach the screws around the power connection.")
			return
	else if(isWelder(I) && c_mode==1)
		var/obj/item/weldingtool/W = I
		if(W.remove_fuel(1,user))
			to_chat(user, "You start slicing the floorweld off the delivery chute.")
			if(do_after(user, (I.toolspeed * 2) SECONDS, src, DO_REPAIR_CONSTRUCT))
				playsound(src.loc, 'sound/items/Welder2.ogg', 100, 1)
				if(!src || !W.isOn()) return
				to_chat(user, "You sliced the floorweld off the delivery chute.")
				var/obj/structure/disposalconstruct/C = new (loc, src)
				C.update()
				qdel(src)
			return
		else
			to_chat(user, "You need more welding fuel to complete this task.")
			return

/obj/machinery/disposal/deliveryChute/Destroy()
	if(trunk)
		trunk.linked = null
	..()

/obj/item/stack/package_wrap/cyborg
	name = "package wrapper synthesizer"
	icon = 'icons/obj/items.dmi'
	icon_state = "deliveryPaper"
	gender = NEUTER
	matter = null
	uses_charge = 1
	charge_costs = list(1)
	stacktype = /obj/item/stack/package_wrap
