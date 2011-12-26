/obj/effect/bigDelivery
	desc = "A big wrapped package."
	name = "large parcel"
	icon = 'storage.dmi'
	icon_state = "deliverycrate"
	var/obj/wrapped = null
	density = 1
	var/sortTag = 0
	flags = FPRINT
	mouse_drag_pointer = MOUSE_ACTIVE_POINTER


	attack_hand(mob/user as mob)
		if (src.wrapped) //sometimes items can disappear. For example, bombs. --rastaf0
			src.wrapped.loc = (get_turf(src.loc))
			if (istype(src.wrapped,/obj/structure/closet))
				var/obj/structure/closet/O = src.wrapped
				O.welded = 0
		del(src)
		return

	attackby(obj/item/W as obj, mob/user as mob)
		if(istype(W, /obj/item/device/destTagger))
			var/obj/item/device/destTagger/O = W
			user << "\blue *TAGGED*"
			src.sortTag = O.currTag
		return

/obj/item/smallDelivery
	desc = "A small wrapped package."
	name = "small parcel"
	icon = 'storage.dmi'
	icon_state = "deliverycrateSmall"
	var/obj/item/wrapped = null
	var/sortTag = 0
	flags = FPRINT


	attack_hand(mob/user as mob)
		if (src.wrapped) //sometimes items can disappear. For example, bombs. --rastaf0
			src.wrapped.loc = (get_turf(src.loc))

		del(src)
		return

	attackby(obj/item/W as obj, mob/user as mob)
		if(istype(W, /obj/item/device/destTagger))
			var/obj/item/device/destTagger/O = W
			user << "\blue *TAGGED*"
			src.sortTag = O.currTag
		return



/obj/item/weapon/packageWrap
	name = "package wrapper"
	icon = 'items.dmi'
	icon_state = "deliveryPaper"
	var/amount = 25.0


	attack(target as obj, mob/user as mob)

		user.attack_log += text("\[[time_stamp()]\] <font color='blue'>Has used [src.name] on \ref[target]</font>")

		if (istype(target, /obj/item))
			var/obj/item/O = target
			if (src.amount > 1)
				var/obj/item/smallDelivery/P = new /obj/item/smallDelivery(get_turf(O.loc))
				P.wrapped = O
				O.loc = P
				src.amount -= 1
		else if (istype(target, /obj/structure/closet/crate))
			var/obj/structure/closet/crate/O = target
			if (src.amount > 3)
				var/obj/effect/bigDelivery/P = new /obj/effect/bigDelivery(get_turf(O.loc))
				P.wrapped = O
				O.loc = P
				src.amount -= 3
			else
				user << "\blue You need more paper."
		else if (istype (target, /obj/structure/closet))
			var/obj/structure/closet/O = target
			if (src.amount > 3)
				var/obj/effect/bigDelivery/P = new /obj/effect/bigDelivery(get_turf(O.loc))
				P.wrapped = O
				O.close()
				O.welded = 1
				O.loc = P
				src.amount -= 3

		else
			user << "\blue The object you are trying to wrap is unsuitable for the sorting machinery!"
		if (src.amount <= 0)
			new /obj/item/weapon/c_tube( src.loc )
			//SN src = null
			del(src)
			return
		return

/obj/item/device/destTagger
	name = "destination tagger"
	desc = "Used to set the destination of properly wrapped packages."
	icon_state = "forensic0"
	var/currTag = 0
	var/list/locationList = list("Disposals",
	"Cargo Bay", "QM Office", "Engineering", "CE Office",
	"Atmospherics", "Security", "HoS Office", "Medbay",
	"CMO Office", "Chemistry", "Research", "RD Office",
	"Robotics", "HoP Office", "Library", "Chapel", "Theatre",
	"Bar", "Kitchen", "Hydroponics", "Janitor Closet",)
	//The whole system for the sorttype var is determined based on the order of this list,
	//disposals must always be 1, since anything that's untagged will automatically go to disposals, or sorttype = 1 --Superxpdude

	//If you don't want to fuck up disposals, add to this list, and don't change the order.
	//If you insist on changing the order, you'll have to change every sort junction to reflect the new order. --Pete

	w_class = 1
	item_state = "electronic"
	flags = FPRINT | TABLEPASS | ONBELT | CONDUCT

	attack_self(mob/user as mob)
		var/dat = "<TT><B>TagMaster 2.2</B><BR><BR>"
		if (src.currTag == 0)
			dat += "<br>Current Selection: None<br>"
		else
			dat += "<br>Current Selection: [locationList[currTag]]<br><br>"
		for (var/i = 1, i <= locationList.len, i++)
			dat += "<A href='?src=\ref[src];nextTag=[i]'>[locationList[i]]</A>"
			if (i%4==0)
				dat += "<br>"
			else
				dat += "	"
		user << browse(dat, "window=destTagScreen")
		onclose(user, "destTagScreen")
		return

	Topic(href, href_list)
		src.add_fingerprint(usr)
		if(href_list["nextTag"])
			var/n = text2num(href_list["nextTag"])
			src.currTag = n
		src.updateUsrDialog()


/*
	attack(target as obj, mob/user as mob)
		user << "/blue *TAGGED*"
		target.sortTag = src.currTag

	attack(target as obj, mob/user as mob)
		user << "/blue You can only tag properly wrapped delivery packages!"
*/
	attack(target as obj, mob/user as mob)
		if (istype(target, /obj/effect/bigDelivery))
			user << "\blue *TAGGED*"
			var/obj/effect/bigDelivery/O = target
			O.sortTag = src.currTag
		else if (istype(target, /obj/item/smallDelivery))
			user << "\blue *TAGGED*"
			var/obj/item/smallDelivery/O = target
			O.sortTag = src.currTag
		else
			user << "\blue You can only tag properly wrapped delivery packages!"
		return

/obj/machinery/disposal/deliveryChute
	name = "Delivery chute"
	desc = "A chute for big and small packages alike!"
	density = 0
	icon_state = "intake"

	interact()
		return

	HasEntered(AM as mob|obj) //Go straight into the chute
		if (istype(AM, /obj))
			var/obj/O = AM
			O.loc = src
		else if (istype(AM, /mob))
			var/mob/M = AM
			M.loc = src
		src.flush()

	flush()
		flushing = 1
		flick("intake-closing", src)
		var/deliveryCheck = 0
		var/obj/structure/disposalholder/H = new()	// virtual holder object which actually
											// travels through the pipes.
		for(var/obj/effect/bigDelivery/O in src)
			deliveryCheck = 1
			if(O.sortTag == 0)
				O.sortTag = 1
		for(var/obj/item/smallDelivery/O in src)
			deliveryCheck = 1
			if (O.sortTag == 0)
				O.sortTag = 1
		if(deliveryCheck == 0)
			H.destinationTag = 1


		H.init(src)	// copy the contents of disposer to holder

		air_contents = new()		// new empty gas resv.

		sleep(10)
		playsound(src, 'disposalflush.ogg', 50, 0, 0)
		sleep(5) // wait for animation to finish


		H.start(src) // start the holder processing movement
		flushing = 0
		// now reset disposal state
		flush = 0
		if(mode == 2)	// if was ready,
			mode = 1	// switch to charging
		update()
		return