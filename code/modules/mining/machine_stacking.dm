/**********************Mineral stacking unit console**************************/

/obj/machinery/mineral/stacking_unit_console
	name = "stacking machine console"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "console"
	density = 1
	anchored = 1
	var/obj/machinery/mineral/stacking_machine/machine = null
	var/machinedir = SOUTHEAST

/obj/machinery/mineral/stacking_unit_console/New()

	..()

	spawn(7)
		src.machine = locate(/obj/machinery/mineral/stacking_machine, get_step(src, machinedir))
		if (machine)
			machine.console = src
		else
			qdel(src)

/obj/machinery/mineral/stacking_unit_console/attack_hand(mob/user)
	add_fingerprint(user)
	interact(user)

/obj/machinery/mineral/stacking_unit_console/interact(mob/user)
	user.set_machine(src)

	var/dat

	dat += text("<h1>Stacking unit console</h1><hr><table>")

	for(var/stacktype in machine.held_items)
		var/obj/item/stack/S = machine.held_items[stacktype]
		if(!S)
			machine.held_items -= stacktype
		else
			dat += "<tr><td width = 150><b>[capitalize(S.name)]:</b></td><td width = 30>[S.amount]</td><td width = 50><A href='?src=\ref[src];release_stack=[stacktype]'>\[release\]</a></td></tr>"
	dat += "</table><hr>"
	dat += text("<br>Stacking: [machine.stack_amt] <A href='?src=\ref[src];change_stack=1'>\[change\]</a><br><br>")

	user << browse("[dat]", "window=console_stacking_machine")
	onclose(user, "console_stacking_machine")


/obj/machinery/mineral/stacking_unit_console/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["change_stack"])
		var/choice = input("What would you like to set the stack amount to?") as null|anything in list(1,5,10,20,50)
		if(!choice) return
		machine.stack_amt = choice

	if(href_list["release_stack"])
		var/stacktype = href_list["release_stack"]
		if(machine.held_items[stacktype])
			var/obj/item/stack/material/held_stack = machine.held_items[stacktype]
			machine.try_produce_stack(held_stack, held_stack.amount)

	src.add_fingerprint(usr)
	src.updateUsrDialog()

	return

/**********************Mineral stacking unit**************************/


/obj/machinery/mineral/stacking_machine
	name = "stacking machine"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "stacker"
	density = 1
	anchored = 1.0
	var/obj/machinery/mineral/stacking_unit_console/console
	var/obj/machinery/mineral/input = null
	var/obj/machinery/mineral/output = null
	var/held_items = list()
	var/stack_amt = 50; // Amount to stack before releassing
	var/list/loading = list()

/obj/machinery/mineral/stacking_machine/New()
	..()

	spawn( 5 )
		for (var/dir in GLOB.cardinal)
			src.input = locate(/obj/machinery/mineral/input, get_step(src, dir))
			if(src.input) break
		for (var/dir in GLOB.cardinal)
			src.output = locate(/obj/machinery/mineral/output, get_step(src, dir))
			if(src.output) break
		return
	return

/obj/machinery/mineral/stacking_machine/process()
	if (src.output && src.input)
		for(var/obj/item/O in loading)
			if(istype(O, /obj/item/stack/material))
				var/obj/item/stack/material/S = O
				var/obj/item/stack/material/held_stack
				if(held_items[S.default_type])
					held_stack = held_items[S.default_type]
					held_stack.amount += S.amount
					qdel(S)
				else
					held_stack = S
					held_stack.loc = src
					held_items[S.default_type] = held_stack
				try_produce_stack(held_stack)
			else
				O.loc = output.loc

		//delay 1 tick in grabbing resources
		loading.Cut()
		var/turf/T = get_turf(input)
		for(var/obj/item/O in T.contents)
			loading += O


	if(console)
		console.updateUsrDialog()
	return

/obj/machinery/mineral/stacking_machine/proc/try_produce_stack(var/obj/item/stack/material/held_stack, var/release_amount = stack_amt)
	if(release_amount > 0 && held_stack.amount >= release_amount)
		var/obj/item/stack/material/new_stack = new held_stack.stacktype(get_turf(output), release_amount)
		new_stack.update_strings()
		held_stack.amount -= release_amount
		src.visible_message("\icon[src] <span class='info'>[src] releases a stack of [new_stack].</span>")
		if(held_stack.amount <= 0)
			held_items -= held_stack.default_type
			qdel(held_stack)
		return 1
