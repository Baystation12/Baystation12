/obj/structure/bigDelivery
	desc = "A big wrapped package."
	name = "large parcel"
	icon = 'icons/obj/storage.dmi'
	icon_state = "deliverycloset"
	var/obj/wrapped = null
	density = 1
	var/sortTag = null
	flags = FPRINT | NOBLUDGEON
	mouse_drag_pointer = MOUSE_ACTIVE_POINTER
	var/examtext = null
	var/nameset = 0
	var/label_y
	var/label_x
	var/tag_x

	attack_hand(mob/user as mob)
		if(wrapped) //sometimes items can disappear. For example, bombs. --rastaf0
			wrapped.loc = (get_turf(src.loc))
			if(istype(wrapped, /obj/structure/closet))
				var/obj/structure/closet/O = wrapped
				O.welded = 0
		del(src)
		return

	attackby(obj/item/W as obj, mob/user as mob)
		if(istype(W, /obj/item/device/destTagger))
			var/obj/item/device/destTagger/O = W
			if(O.currTag)
				if(src.sortTag != O.currTag)
					user << "<span class='notice'>You have labeled the destination as [O.currTag].</span>"
					if(!src.sortTag)
						src.sortTag = O.currTag
						update_icon()
					else
						src.sortTag = O.currTag
					playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 1)
				else
					user << "<span class='warning'>The package is already labeled for [O.currTag].</span>"
			else
				user << "<span class='warning'>You need to set a destination first!</span>"

		else if(istype(W, /obj/item/weapon/pen))
			switch(alert("What would you like to alter?",,"Title","Description", "Cancel"))
				if("Title")
					var/str = trim(copytext(sanitize(input(usr,"Label text?","Set label","")),1,MAX_NAME_LEN))
					if(!str || !length(str))
						usr << "<span class='warning'> Invalid text.</span>"
						return
					user.visible_message("\The [user] titles \the [src] with \a [W], marking down: \"[str]\"",\
					"<span class='notice'>You title \the [src]: \"[str]\"</span>",\
					"You hear someone scribbling a note.")
					name = "[name] ([str])"
					if(!examtext && !nameset)
						nameset = 1
						update_icon()
					else
						nameset = 1
				if("Description")
					var/str = trim(copytext(sanitize(input(usr,"Label text?","Set label","")),1,MAX_MESSAGE_LEN))
					if(!str || !length(str))
						usr << "\red Invalid text."
						return
					if(!examtext && !nameset)
						examtext = str
						update_icon()
					else
						examtext = str
					user.visible_message("\The [user] labels \the [src] with \a [W], scribbling down: \"[examtext]\"",\
					"<span class='notice'>You label \the [src]: \"[examtext]\"</span>",\
					"You hear someone scribbling a note.")
		return

	update_icon()
		overlays = new()
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

	examine()
		..()
		if(src in oview(4))
			if(sortTag)
				usr << "<span class='notice'>It is labeled \"[sortTag]\"</span>"
			if(examtext)
				usr << "<span class='notice'>It has a note attached which reads, \"[examtext]\"</span>"
		return

/obj/item/smallDelivery
	desc = "A small wrapped package."
	name = "small parcel"
	icon = 'icons/obj/storage.dmi'
	icon_state = "deliverycrate3"
	var/obj/item/wrapped = null
	var/sortTag = null
	flags = FPRINT
	var/examtext = null
	var/nameset = 0
	var/tag_x

	attack_self(mob/user as mob)
		if (src.wrapped) //sometimes items can disappear. For example, bombs. --rastaf0
			wrapped.loc = user.loc
			if(ishuman(user))
				user.put_in_hands(wrapped)
			else
				wrapped.loc = get_turf(src)

		del(src)
		return

	attackby(obj/item/W as obj, mob/user as mob)
		if(istype(W, /obj/item/device/destTagger))
			var/obj/item/device/destTagger/O = W
			if(O.currTag)
				if(src.sortTag != O.currTag)
					user << "<span class='notice'>You have labeled the destination as [O.currTag].</span>"
					if(!src.sortTag)
						src.sortTag = O.currTag
						update_icon()
					else
						src.sortTag = O.currTag
					playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 1)
				else
					user << "<span class='warning'>The package is already labeled for [O.currTag].</span>"
			else
				user << "<span class='warning'>You need to set a destination first!</span>"

		else if(istype(W, /obj/item/weapon/pen))
			switch(alert("What would you like to alter?",,"Title","Description", "Cancel"))
				if("Title")
					var/str = trim(copytext(sanitize(input(usr,"Label text?","Set label","")),1,MAX_NAME_LEN))
					if(!str || !length(str))
						usr << "<span class='warning'> Invalid text.</span>"
						return
					user.visible_message("\The [user] titles \the [src] with \a [W], marking down: \"[str]\"",\
					"<span class='notice'>You title \the [src]: \"[str]\"</span>",\
					"You hear someone scribbling a note.")
					name = "[name] ([str])"
					if(!examtext && !nameset)
						nameset = 1
						update_icon()
					else
						nameset = 1

				if("Description")
					var/str = trim(copytext(sanitize(input(usr,"Label text?","Set label","")),1,MAX_MESSAGE_LEN))
					if(!str || !length(str))
						usr << "\red Invalid text."
						return
					if(!examtext && !nameset)
						examtext = str
						update_icon()
					else
						examtext = str
					user.visible_message("\The [user] labels \the [src] with \a [W], scribbling down: \"[examtext]\"",\
					"<span class='notice'>You label \the [src]: \"[examtext]\"</span>",\
					"You hear someone scribbling a note.")
		return

	update_icon()
		overlays = new()
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

	examine()
		..()
		if(src in oview(4))
			if(sortTag)
				usr << "<span class='notice'>It is labeled \"[sortTag]\"</span>"
			if(examtext)
				usr << "<span class='notice'>It has a note attached which reads, \"[examtext]\"</span>"
		return

/obj/item/weapon/packageWrap
	name = "package wrapper"
	icon = 'icons/obj/items.dmi'
	icon_state = "deliveryPaper"
	w_class = 3.0
	var/amount = 25.0


	afterattack(var/obj/target as obj, mob/user as mob, proximity)
		if(!proximity) return
		if(!istype(target))	//this really shouldn't be necessary (but it is).	-Pete
			return
		if(istype(target, /obj/item/smallDelivery) || istype(target,/obj/structure/bigDelivery) \
		|| istype(target, /obj/item/weapon/gift) || istype(target, /obj/item/weapon/evidencebag))
			return
		if(target.anchored)
			return
		if(target in user)
			return
		if(user in target) //no wrapping closets that you are inside - it's not physically possible
			return

		user.attack_log += text("\[[time_stamp()]\] <font color='blue'>Has used [src.name] on \ref[target]</font>")


		if (istype(target, /obj/item) && !(istype(target, /obj/item/weapon/storage) && !istype(target,/obj/item/weapon/storage/box)))
			var/obj/item/O = target
			if (src.amount > 1)
				var/obj/item/smallDelivery/P = new /obj/item/smallDelivery(get_turf(O.loc))	//Aaannd wrap it up!
				if(!istype(O.loc, /turf))
					if(user.client)
						user.client.screen -= O
				P.wrapped = O
				O.loc = P
				var/i = round(O.w_class)
				if(i in list(1,2,3,4,5))
					P.icon_state = "deliverycrate[i]"
					switch(i)
						if(1) P.name = "tiny parcel"
						if(3) P.name = "normal-sized parcel"
						if(4) P.name = "large parcel"
						if(5) P.name = "huge parcel"
				if(i < 1)
					P.icon_state = "deliverycrate1"
					P.name = "tiny parcel"
				if(i > 5)
					P.icon_state = "deliverycrate5"
					P.name = "huge parcel"
				P.add_fingerprint(usr)
				O.add_fingerprint(usr)
				src.add_fingerprint(usr)
				src.amount -= 1
				user.visible_message("\The [user] wraps \a [target] with \a [src].",\
				"<span class='notice'>You wrap \the [target], leaving [amount] units of paper on \the [src].</span>",\
				"You hear someone taping paper around a small object.")
		else if (istype(target, /obj/structure/closet/crate))
			var/obj/structure/closet/crate/O = target
			if (src.amount > 3 && !O.opened)
				var/obj/structure/bigDelivery/P = new /obj/structure/bigDelivery(get_turf(O.loc))
				P.icon_state = "deliverycrate"
				P.wrapped = O
				O.loc = P
				src.amount -= 3
				user.visible_message("\The [user] wraps \a [target] with \a [src].",\
				"<span class='notice'>You wrap \the [target], leaving [amount] units of paper on \the [src].</span>",\
				"You hear someone taping paper around a large object.")
			else if(src.amount < 3)
				user << "<span class='warning'>You need more paper.</span>"
		else if (istype (target, /obj/structure/closet))
			var/obj/structure/closet/O = target
			if (src.amount > 3 && !O.opened)
				var/obj/structure/bigDelivery/P = new /obj/structure/bigDelivery(get_turf(O.loc))
				P.wrapped = O
				O.welded = 1
				O.loc = P
				src.amount -= 3
				user.visible_message("\The [user] wraps \a [target] with \a [src].",\
				"<span class='notice'>You wrap \the [target], leaving [amount] units of paper on \the [src].</span>",\
				"You hear someone taping paper around a large object.")
			else if(src.amount < 3)
				user << "<span class='warning'>You need more paper.</span>"
		else
			user << "\blue The object you are trying to wrap is unsuitable for the sorting machinery!"
		if (src.amount <= 0)
			new /obj/item/weapon/c_tube( src.loc )
			del(src)
			return
		return

	examine()
		if(src in usr)
			usr << "\blue There are [amount] units of package wrap left!"
		..()
		return


/obj/item/device/destTagger
	name = "destination tagger"
	desc = "Used to set the destination of properly wrapped packages."
	icon_state = "dest_tagger"
	var/currTag = 0

	w_class = 2
	item_state = "electronic"
	flags = FPRINT | TABLEPASS | CONDUCT
	slot_flags = SLOT_BELT

	proc/openwindow(mob/user as mob)
		var/dat = "<tt><center><h1><b>TagMaster 2.3</b></h1></center>"

		dat += "<table style='width:100%; padding:4px;'><tr>"
		for(var/i = 1, i <= tagger_locations.len, i++)
			dat += "<td><a href='?src=\ref[src];nextTag=[tagger_locations[i]]'>[tagger_locations[i]]</a></td>"

			if (i%4==0)
				dat += "</tr><tr>"

		dat += "</tr></table><br>Current Selection: [currTag ? currTag : "None"]</tt>"

		user << browse(dat, "window=destTagScreen;size=450x350")
		onclose(user, "destTagScreen")

	attack_self(mob/user as mob)
		openwindow(user)
		return

	Topic(href, href_list)
		src.add_fingerprint(usr)
		if(href_list["nextTag"] && href_list["nextTag"] in tagger_locations)
			src.currTag = href_list["nextTag"]
		openwindow(usr)

/obj/machinery/disposal/deliveryChute
	name = "Delivery chute"
	desc = "A chute for big and small packages alike!"
	density = 1
	icon_state = "intake"

	var/c_mode = 0

	New()
		..()
		spawn(5)
			trunk = locate() in src.loc
			if(trunk)
				trunk.linked = src	// link the pipe trunk to self

	interact()
		return

	update()
		return

	Bumped(var/atom/movable/AM) //Go straight into the chute
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

		if(istype(AM, /obj))
			var/obj/O = AM
			O.loc = src
		else if(istype(AM, /mob))
			var/mob/M = AM
			M.loc = src
		src.flush()

	flush()
		flushing = 1
		flick("intake-closing", src)
		var/obj/structure/disposalholder/H = new()	// virtual holder object which actually
													// travels through the pipes.
		air_contents = new()		// new empty gas resv.

		sleep(10)
		playsound(src, 'sound/machines/disposalflush.ogg', 50, 0, 0)
		sleep(5) // wait for animation to finish

		H.init(src)	// copy the contents of disposer to holder

		H.start(src) // start the holder processing movement
		flushing = 0
		// now reset disposal state
		flush = 0
		if(mode == 2)	// if was ready,
			mode = 1	// switch to charging
		update()
		return

	attackby(var/obj/item/I, var/mob/user)
		if(!I || !user)
			return

		if(istype(I, /obj/item/weapon/screwdriver))
			if(c_mode==0)
				c_mode=1
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
				user << "You remove the screws around the power connection."
				return
			else if(c_mode==1)
				c_mode=0
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
				user << "You attach the screws around the power connection."
				return
		else if(istype(I,/obj/item/weapon/weldingtool) && c_mode==1)
			var/obj/item/weapon/weldingtool/W = I
			if(W.remove_fuel(0,user))
				playsound(src.loc, 'sound/items/Welder2.ogg', 100, 1)
				user << "You start slicing the floorweld off the delivery chute."
				if(do_after(user,20))
					if(!src || !W.isOn()) return
					user << "You sliced the floorweld off the delivery chute."
					var/obj/structure/disposalconstruct/C = new (src.loc)
					C.ptype = 8 // 8 =  Delivery chute
					C.update()
					C.anchored = 1
					C.density = 1
					del(src)
				return
			else
				user << "You need more welding fuel to complete this task."
				return
