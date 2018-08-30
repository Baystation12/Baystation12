/obj/machinery/pipedispenser
	name = "Pipe Dispenser"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "pipe_d"
	density = 1
	anchored = 1
	var/unwrenched = 0
	var/wait = 0
	var/list/simple_recipes = list()
	var/list/scrubber_recipes = list()
	var/list/supply_recipes = list()
	var/list/fuel_recipes = list()
	var/list/device_recipes = list()
	var/list/he_recipes = list()

/obj/machinery/pipedispenser/Initialize()
	. = ..()
	for(var/simple in typesof(/datum/pipe/pipe_dispenser/simple) - /datum/pipe/pipe_dispenser/simple)
		simple_recipes += new simple(src)
	for(var/scrub in typesof(/datum/pipe/pipe_dispenser/scrubber) - /datum/pipe/pipe_dispenser/scrubber)
		scrubber_recipes += new scrub(src)
	for(var/supply in typesof(/datum/pipe/pipe_dispenser/supply) - /datum/pipe/pipe_dispenser/supply)
		supply_recipes += new supply(src)
	for(var/fuel in typesof(/datum/pipe/pipe_dispenser/fuel) - /datum/pipe/pipe_dispenser/fuel)
		fuel_recipes += new fuel(src)
	for(var/device in typesof(/datum/pipe/pipe_dispenser/device) - /datum/pipe/pipe_dispenser/device)
		device_recipes += new device(src)
	for(var/he in typesof(/datum/pipe/pipe_dispenser/he) - /datum/pipe/pipe_dispenser/he)
		he_recipes += new he(src)

/obj/machinery/pipedispenser/proc/get_console_data()
	. = ..() + "<table><tr><td><h3>Regular Pipes</h3></td></tr>"
	var/result = ""
	for(var/datum/pipe/simple in simple_recipes)
		var/line = "[simple.name]</td>"
		result += "<tr><td>[line]<td><a href='?src=\ref[src];build=\ref[simple]'>Dispense</a></td></tr>"
	. += "[result]"
	result = ""
	. += "<tr><td><h3>Supply Pipes</h3></td></tr>"
	for(var/datum/pipe/supply in supply_recipes)
		var/line = "[supply.name]</td>"
		result += "<tr><td>[line]<td><a href='?src=\ref[src];build=\ref[supply]'>Dispense</a></td></tr>"
	. += "[result]"
	result = ""
	. += "<tr><td><h3>Scrubber Pipes</h3></td></tr>"
	for(var/datum/pipe/scrubber in scrubber_recipes)
		var/line = "[scrubber.name]</td>"
		result += "<tr><td>[line]<td><a href='?src=\ref[src];build=\ref[scrubber]'>Dispense</a></td></tr>"
	. += "[result]"
	result = ""
	. += "<tr><td><h3>Fuel Pipes</h3></td></tr>"
	for(var/datum/pipe/fuel in fuel_recipes)
		var/line = "[fuel.name]</td>"
		result += "<tr><td>[line]<td><a href='?src=\ref[src];build=\ref[fuel]'>Dispense</a></td></tr>"
	. += "[result]"
	result = ""
	. += "<tr><td><h3>Heat Exchange</h3></td></tr>"
	for(var/datum/pipe/he in he_recipes)
		var/line = "[he.name]</td>"
		result += "<tr><td>[line]<td><a href='?src=\ref[src];build=\ref[he]'>Dispense</a></td></tr>"
	. += "[result]"
	result = ""
	. += "<tr><td><h3>Devices</h3></td></tr>"
	for(var/datum/pipe/devices in device_recipes)
		var/line = "[devices.name]</td>"
		result += "<tr><td>[line]<td><a href='?src=\ref[src];build=\ref[devices]'>Dispense</a></td></tr>"
	. += "[result]"
	.+= "</table>"

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
		if(D.pipe_type != null)
			new_item.pipe_type = D.pipe_type
		if(D.connect_types != null)
			new_item.connect_types = D.connect_types
		if(D.pipe_color != null)
			new_item.color = D.pipe_color
		new_item.name = D.name
		new_item.desc = D.desc
		new_item.dir = D.dir
		new_item.icon_state = D.icon_state

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
