/obj/machinery/pipedispenser
	name = "Pipe Dispenser"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "pipe_d"
	density = 1
	anchored = 1
	var/unwrenched = 0
	var/wait = 0
	var/list/categories = list(
		/datum/pipe/pipe_dispenser/simple,
		/datum/pipe/pipe_dispenser/scrubber,
		/datum/pipe/pipe_dispenser/supply,
		/datum/pipe/pipe_dispenser/fuel,
		/datum/pipe/pipe_dispenser/device,
		/datum/pipe/pipe_dispenser/he)
	var/pipe_color = "white"

/obj/machinery/pipedispenser/Initialize()
	. = ..()
	for(var/category_type in categories)
		for(var/recipe_type in subtypesof(category_type))
			LAZYADD(categories[category_type], new recipe_type(src))

/obj/machinery/pipedispenser/proc/get_console_data()
	. = list()
	. += "<table><tr><td>Color</td><td><a href='?src=\ref[src];color=\ref[src]'><font color = '[pipe_color]'>[pipe_color]</font></a></td></tr>"
	for(var/category in categories)
		var/datum/pipe/cat = category
		. += "<tr><td><font color = '#517087'><strong>[initial(cat.category)]</strong></font></td></tr>"
		for(var/datum/pipe/pipe in categories[category])
			var/line = "[pipe.name]</td>"
			. += "<tr><td>[line]<td><a href='?src=\ref[src];build=\ref[pipe]'>Dispense</a></td><td><a href='?src=\ref[src];buildfive=\ref[pipe]'>5x</a></td><td><a href='?src=\ref[src];buildten=\ref[pipe]'>10x</a></td></tr>"
	.+= "</table>"
	. = JOINTEXT(.)

/obj/machinery/pipedispenser/Topic(href, href_list)
	if((. = ..()))
		return
	if(href_list["build"])
		var/datum/pipe/P = locate(href_list["build"])
		P.Build(P, pipe_color, src.loc)
	if(href_list["buildfive"])
		var/datum/pipe/P = locate(href_list["buildfive"])
		for(var/I = 5;I > 0;I -= 1)
			P.Build(P, pipe_color, src.loc)
	if(href_list["buildten"])
		var/datum/pipe/P = locate(href_list["buildten"])
		for(var/I = 10;I > 0;I -= 1)
			P.Build(P, pipe_color, src.loc)
	if(href_list["color"])
		var/choice = input(usr, "What color do you want pipes to have?") as null|anything in pipe_colors
		if(!choice)
			return 1
		pipe_color = choice
		updateUsrDialog()

/obj/machinery/pipedispenser/attack_hand(user as mob)
	var/datum/browser/popup = new (user, "Pipe List", "[src] Control Panel")
	popup.set_content(jointext(get_console_data(),"<br>"))
	popup.open()

/obj/machinery/pipedispenser/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if (istype(W, /obj/item/pipe) || istype(W, /obj/item/pipe_meter))
		if(!user.unEquip(W))
			return
		to_chat(usr, "<span class='notice'>You put \the [W] back into \the [src].</span>")
		add_fingerprint(usr)
		qdel(W)
		return
	else if(isWrench(W))
		add_fingerprint(usr)
		if (unwrenched==0)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
			to_chat(user, "<span class='notice'>You begin to unfasten \the [src] from the floor...</span>")
			if (do_after(user, 40, src))
				user.visible_message( \
					"<span class='notice'>\The [user] unfastens \the [src].</span>", \
					"<span class='notice'>You have unfastened \the [src]. Now it can be pulled somewhere else.</span>", \
					"You hear ratchet.")
				src.anchored = 0
				src.stat |= MAINT
				src.unwrenched = 1
				if (usr.machine==src)
					usr << browse(null, "window=pipedispenser")
		else /*if (unwrenched==1)*/
			playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
			to_chat(user, "<span class='notice'>You begin to fasten \the [src] to the floor...</span>")
			if (do_after(user, 20, src))
				user.visible_message( \
					"<span class='notice'>\The [user] fastens \the [src].</span>", \
					"<span class='notice'>You have fastened \the [src]. Now it can dispense pipes.</span>", \
					"You hear ratchet.")
				src.anchored = 1
				src.stat &= ~MAINT
				src.unwrenched = 0
				power_change()
	else
		return ..()

/obj/machinery/pipedispenser/disposal
	name = "Disposal Pipe Dispenser"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "pipe_d"
	density = 1
	anchored = 1.0

//Allow you to drag-drop disposal pipes into it
/obj/machinery/pipedispenser/disposal/MouseDrop_T(var/obj/structure/disposalconstruct/pipe as obj, mob/user as mob)
	if(!CanPhysicallyInteract(user))
		return

	if (!istype(pipe) || get_dist(src,pipe) > 1 )
		return

	if (pipe.anchored)
		return

	qdel(pipe)

/obj/machinery/pipedispenser/disposal/attack_hand(user as mob)
	if(..())
		return

///// Z-Level stuff
	var/dat = {"<b>Disposal Pipes</b><br><br>
<A href='?src=\ref[src];dmake=0'>Pipe</A><BR>
<A href='?src=\ref[src];dmake=1'>Bent Pipe</A><BR>
<A href='?src=\ref[src];dmake=2'>Junction</A><BR>
<A href='?src=\ref[src];dmake=3'>Y-Junction</A><BR>
<A href='?src=\ref[src];dmake=4'>Trunk</A><BR>
<A href='?src=\ref[src];dmake=5'>Bin</A><BR>
<A href='?src=\ref[src];dmake=6'>Outlet</A><BR>
<A href='?src=\ref[src];dmake=7'>Chute</A><BR>
<A href='?src=\ref[src];dmake=21'>Upwards</A><BR>
<A href='?src=\ref[src];dmake=22'>Downwards</A><BR>
<A href='?src=\ref[src];dmake=8'>Sorting</A><BR>
<A href='?src=\ref[src];dmake=9'>Sorting (Wildcard)</A><BR>
<A href='?src=\ref[src];dmake=10'>Sorting (Untagged)</A><BR>
<A href='?src=\ref[src];dmake=11'>Tagger</A><BR>
<A href='?src=\ref[src];dmake=12'>Tagger (Partial)</A><BR>
<A href='?src=\ref[src];dmake=13'>Diversion</A><BR>
<A href='?src=\ref[src];dmake=14'>Diversion Switch</A><BR>
"}
///// Z-Level stuff

	user << browse("<HEAD><TITLE>[src]</TITLE></HEAD><TT>[dat]</TT>", "window=pipedispenser")
	return

// 0=straight, 1=bent, 2=junction-j1, 3=junction-j2, 4=junction-y, 5=trunk


/obj/machinery/pipedispenser/disposal/Topic(href, href_list, state = GLOB.physical_state)
	if((. = ..()) || unwrenched)
		usr << browse(null, "window=pipedispenser")
		return

	if(href_list["dmake"])
		if(!wait)
			var/p_type = text2num(href_list["dmake"])
			if(p_type == 15)
				new /obj/machinery/disposal_switch (get_turf(src))
			else
				var/obj/structure/disposalconstruct/C = new (src.loc)
				switch(p_type)
					if(0)
						C.ptype = 0
					if(1)
						C.ptype = 1
					if(2)
						C.ptype = 2
					if(3)
						C.ptype = 4
					if(4)
						C.ptype = 5
					if(5)
						C.ptype = 6
						C.set_density(1)
					if(6)
						C.ptype = 7
						C.set_density(1)
					if(7)
						C.ptype = 8
						C.set_density(1)
					if(8)
						C.ptype = 9
						C.subtype = 0
					if(9)
						C.ptype = 9
						C.subtype = 1
					if(10)
						C.ptype = 9
						C.subtype = 2
					if(11)
						C.ptype = 13
					if(12)
						C.ptype = 14
					if(13)
						C.ptype = 15
///// Z-Level stuff
					if(21)
						C.ptype = 11
					if(22)
						C.ptype = 12
///// Z-Level stuff
				C.update()
			wait = 1
			spawn(15)
				wait = 0
	return

// adding a pipe dispensers that spawn unhooked from the ground
/obj/machinery/pipedispenser/orderable
	anchored = 0
	unwrenched = 1

/obj/machinery/pipedispenser/disposal/orderable
	anchored = 0
	unwrenched = 1
