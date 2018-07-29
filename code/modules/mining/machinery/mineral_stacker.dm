/obj/machinery/mineral/stacking_machine
	name = "stacking machine"
	icon_state = "stacker"
	console = /obj/machinery/computer/mining
	input_turf =  EAST
	output_turf = WEST
	var/stack_amt = 50
	var/list/stacks

/obj/machinery/mineral/stacking_machine/Initialize()
	stacks = list()
	. = ..()

/obj/machinery/mineral/stacking_machine/Process()
	if(input_turf)
		for(var/obj/item/I in input_turf)
			if(istype(I, /obj/item/stack/material))
				var/obj/item/stack/material/S = I
				if(S.material && S.material.stack_type)
					if(isnull(stacks[S.material.name]))
						stacks[S.material.name] = 0
					stacks[S.material.name] += S.amount
					qdel(S)
					continue
			if(output_turf)
				I.forceMove(output_turf)

	if(output_turf)
		for(var/sheet in stacks)
			if(stacks[sheet] >= stack_amt)
				var/material/stackmat = SSmaterials.get_material_by_name(sheet)
				new stackmat.stack_type(output_turf, amount = stack_amt, stackmat.name)
				stacks[sheet] -= stack_amt

/obj/machinery/mineral/stacking_machine/get_console_data()
	. = ..()
	. += "Stacking: [stack_amt] <a href='?src=\ref[src];change_stack=1'>\[change\]</a>"
	for(var/stacktype in stacks)
		if(stacks[stacktype] > 0)
			var/line = "=== [capitalize(stacktype)] - [stacks[stacktype]] "
			while(length(line) < 40) line += "="
			line += " <A href='?src=\ref[src];release_stack=[stacktype]'>\[release\]</a>"
			. += line

/obj/machinery/mineral/stacking_machine/Topic(href, href_list)
	. = ..()
	if(can_use(usr))
		if(href_list["change_stack"])
			var/choice = input("What would you like to set the stack amount to?") as null|anything in list(1,5,10,20,50)
			if(!choice) return
			stack_amt = choice
			. = TRUE
		else if(href_list["release_stack"] && stacks[href_list["release_stack"]] > 0)
			var/material/stackmat = SSmaterials.get_material_by_name(href_list["release_stack"])
			new stackmat.stack_type(output_turf, amount = stacks[href_list["release_stack"]], stackmat.name)
			stacks[href_list["release_stack"]] = 0
			. = TRUE
		if(. && console)
			console.updateUsrDialog()