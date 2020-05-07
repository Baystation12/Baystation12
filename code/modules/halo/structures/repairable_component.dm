
/obj/structure/repair_component
	name = "Repairable Component"
	anchored = 1
	density = 1

	var/repair_into //A typepath pointing to what we should actually spawn when repaired.

	var/list/repair_tools = list()
	var/list/tool_names = list() //autopopulated, typepath = name
	var/list/repair_materials = list() //material name = amount needed
	var/list/repair_order = list()

/obj/structure/repair_component/New()
	. = ..()
	for(var/type in repair_tools)
		var/obj/n = new type (null)
		tool_names[type] = n.name
	if(repair_order.len == 0)
		var/list/remaining_items = repair_tools + repair_materials
		while(remaining_items.len != 0)
			var/add = pick(remaining_items)
			repair_order += add
			remaining_items -= add

/obj/structure/repair_component/examine(var/mob/examiner)
	. = ..()
	if(repair_order.len > 0)
		var/msg = "The next repair item is [tool_names[curr_item()]]"
		if(requires_material())
			msg = "The next repair item is [repair_materials[curr_item()]] x [curr_item()]"
		to_chat(examiner,"<span class = 'notice'>[msg]</span>")

/obj/structure/repair_component/proc/requires_material()
	if(ispath(curr_item()))
		return 0
	return 1

/obj/structure/repair_component/proc/curr_item()
	return repair_order[1]

/obj/structure/repair_component/proc/finalise_repair()
	. = new repair_into (loc)

/obj/structure/repair_component/attackby(var/atom/a,var/mob/user)
	if(repair_order.len == 0)
		return
	if(requires_material())
		var/obj/item/stack/material/s = a
		if(!istype(s))
			to_chat(user,"<span class = 'notice'>[src] needs materials to repair!</span>")
			return
		if(s.material.name != curr_item())
			to_chat(user,"<span class = 'notice'>[src] doesn't need [s.material.name] for repairs right now!</span>")
			return
		if(s.amount < repair_materials[curr_item()])
			to_chat(user, "<span class = 'notice'>You don't have enough of [s.material.name] to repair [src]</span>")
			return
	else
		if(!istype(a,curr_item()))
			return
	visible_message("<span class = 'notice'>[user] starts repairing [src] with [a]</span>")
	if(!do_after(user,rand(1 SECOND, 5 SECONDS)))
		return
	if(requires_material())
		var/obj/item/stack/material/s = a
		if(!s.use(repair_materials[curr_item()]))
			return
	visible_message("<span class = 'notice'>[user] repairs [src] with [a]</span>")
	repair_order -= curr_item()
	if(repair_order.len == 0)
		if(finalise_repair())
			qdel(src)