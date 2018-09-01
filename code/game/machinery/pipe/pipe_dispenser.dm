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
/*
	for(var/simple in subtypesof(/datum/pipe/pipe_dispenser/simple))
		categories["simple_recipes"] += new simple(src)
	for(var/scrub in subtypesof(/datum/pipe/pipe_dispenser/scrubber))
		categories["scrubber_recipes"] += new scrub(src)
	for(var/supply in subtypesof(/datum/pipe/pipe_dispenser/supply))
		categories["supply_recipes"] += new supply(src)
	for(var/fuel in subtypesof(/datum/pipe/pipe_dispenser/fuel))
		categories["fuel_recipes"] += new fuel(src)
	for(var/device in subtypesof(/datum/pipe/pipe_dispenser/device))
		categories["device_recipes"] += new device(src)
	for(var/he in subtypesof(/datum/pipe/pipe_dispenser/he))
		categories["he_recipes"] += new he(src)*/

/obj/machinery/pipedispenser/proc/get_console_data()
	. = list()
	. += "<table><tr><td>Color</td><td><a href='?src=\ref[src];color=\ref[src]'><font color = '[pipe_color]'>[pipe_color]</font></a></td></tr>"
	for(var/category in categories)
		var/datum/pipe/cat = category
		. += "<tr><td><font color = '#517087'><strong>[initial(cat.category)]</strong></font></td></tr>"
		for(var/datum/pipe/pipe in categories[category])
			var/line = "[pipe.name]</td>"
			. += "<tr><td>[line]<td><a href='?src=\ref[src];build=\ref[pipe]'>Dispense</a></td><td><a href='?src=\ref[src];buildfive=\ref[pipe]'>5x</a></td><td><a href='?src=\ref[src];buildten=\ref[pipe]'>10x</a></td></tr>"
	//. += "<tr><td><font color = '#517087'><strong>Regular Pipes</strong></font></td></tr>"
	/*var/result = ""

	for(var/datum/pipe/simple in categories["simple_recipes"])
		var/line = "[simple.name]</td>"
		result += "<tr><td>[line]<td><a href='?src=\ref[src];build=\ref[simple]'>Dispense</a></td><td><a href='?src=\ref[src];buildfive=\ref[simple]'>5x</a></td><td><a href='?src=\ref[src];buildten=\ref[simple]'>10x</a></td></tr>"
	. += "[result]"
	result = ""
	. += "<tr><td><font color = '#517087'><strong>Supply Pipes</strong></font></td></tr>"
	for(var/datum/pipe/supply in categories["supply_recipes"])
		var/line = "[supply.name]</td>"
		result += "<tr><td>[line]<td><a href='?src=\ref[src];build=\ref[supply]'>Dispense</a></td><td><a href='?src=\ref[src];buildfive=\ref[supply]'>5x</a></td><td><a href='?src=\ref[src];buildten=\ref[supply]'>10x</a></td></tr>"
	. += "[result]"
	result = ""
	. += "<tr><td><font color = '#517087'><strong>Scrubber Pipes</strong></font></td></tr>"
	for(var/datum/pipe/scrubber in categories["scrubber_recipes"])
		var/line = "[scrubber.name]</td>"
		result += "<tr><td>[line]<td><a href='?src=\ref[src];build=\ref[scrubber]'>Dispense</a></td><td><a href='?src=\ref[src];buildfive=\ref[scrubber]'>5x</a></td><td><a href='?src=\ref[src];buildten=\ref[scrubber]'>10x</a></td></tr>"
	. += "[result]"
	result = ""
	. += "<tr><td><font color = '#517087'><strong>Fuel Pipes</strong></font></td></tr>"
	for(var/datum/pipe/fuel in categories["fuel_recipes"])
		var/line = "[fuel.name]</td>"
		result += "<tr><td>[line]<td><a href='?src=\ref[src];build=\ref[fuel]'>Dispense</a></td><td><a href='?src=\ref[src];buildfive=\ref[fuel]'>5x</a></td><td><a href='?src=\ref[src];buildten=\ref[fuel]'>10x</a></td></tr>"
	. += "[result]"
	result = ""
	. += "<tr><td><font color = '#517087'><strong>Heat Exchange</strong></font></td></tr>"
	for(var/datum/pipe/he in categories["he_recipes"])
		var/line = "[he.name]</td>"
		result += "<tr><td>[line]<td><a href='?src=\ref[src];build=\ref[he]'>Dispense</a></td><td><a href='?src=\ref[src];buildfive=\ref[he]'>5x</a></td><td><a href='?src=\ref[src];buildten=\ref[he]'>10x</a></td></tr>"
	. += "[result]"
	result = ""
	. += "<tr><td><font color = '#517087'><strong>Devices</strong></font></td></tr>"
	for(var/datum/pipe/devices in categories["device_recipes"])
		var/line = "[devices.name]</td>"
		result += "<tr><td>[line]<td><a href='?src=\ref[src];build=\ref[devices]'>Dispense</a></td><td><a href='?src=\ref[src];buildfive=\ref[devices]'>5x</a></td><td><a href='?src=\ref[src];buildten=\ref[devices]'>10x</a></td></tr>"
	. += "[result]"*/
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
			return
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

// adding a pipe dispensers that spawn unhooked from the ground
/obj/machinery/pipedispenser/orderable
	anchored = 0
	unwrenched = 1

/obj/machinery/pipedispenser/disposal/orderable
	anchored = 0
	unwrenched = 1
