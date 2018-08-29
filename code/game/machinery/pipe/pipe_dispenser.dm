/obj/machinery/pipedispenser
	name = "Pipe Dispenser"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "pipe_d"
	density = 1
	anchored = 1
	var/unwrenched = 0
	var/wait = 0
	var/list/recipes = list()

/obj/machinery/pipedispenser/Initialize()
	. = ..()
	for(var/D in typesof(/datum/pipe/pipe_dispenser) - /datum/pipe/pipe_dispenser)
		recipes += new D(src)

/obj/machinery/pipedispenser/proc/get_console_data()
	. = ..() + "<h1>Pipe Dispenser</h1>"
	var/result = ""
	for(var/datum/pipe/R in recipes)
		var/line = "[R.name]</td>"
		result += "<tr><td>[line]</td><td><a href='?src\ref[src];build=\ref[R]'>Dispense</a></td></tr>"
	. += "<table>[result]</table>"

/obj/machinery/pipedispenser/Topic(href, href_list)
	if((. = ..()))
		return
	if(href_list["build"])
		var/datum/pipe/P = locate(href_list["build"])
		build(P)

/obj/machinery/pipedispenser/attack_hand(user as mob)
	var/datum/browser/popup = new (user, "Pipe List", "[src] Control Panel")
	popup.set_content(jointext(get_console_data(),"<br>"))
	popup.open()

/obj/machinery/pipedispenser/proc/build(var/datum/pipe/D)
	if(D.build_path)
		var/obj/item/pipe/new_item = D.Fabricate(src)
		new_item.loc = loc
		new_item.pipe_type = D.pipe_type
		new_item.connect_types = D.connect_types
		new_item.color = D.pipe_color
		new_item.name = D.name
		new_item.desc = D.desc

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

// adding a pipe dispensers that spawn unhooked from the ground
/obj/machinery/pipedispenser/orderable
	anchored = 0
	unwrenched = 1

/obj/machinery/pipedispenser/disposal/orderable
	anchored = 0
	unwrenched = 1
