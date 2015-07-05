/*///////////////Circuit Imprinter (By Darem)////////////////////////
	Used to print new circuit boards (for computers and similar systems) and AI modules. Each circuit board pattern are stored in
a /datum/desgin on the linked R&D console. You can then print them out in a fasion similar to a regular lathe. However, instead of
using metal and glass, it uses glass and reagents (usually sulphuric acid).
*/

/obj/machinery/r_n_d/circuit_imprinter
	name = "Circuit Imprinter"
	icon_state = "circuit_imprinter"
	flags = OPENCONTAINER

	var/list/materials = list("metal" = 0, "glass" = 0, "gold" = 0, "silver" = 0, "phoron" = 0, "uranium" = 0, "diamond" = 0)
	var/list/datum/design/queue = list()
	var/progress = 0

	var/max_material_storage = 75000
	var/mat_efficiency = 1
	var/speed = 1

	use_power = 1
	idle_power_usage = 30
	active_power_usage = 2500

/obj/machinery/r_n_d/circuit_imprinter/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/circuit_imprinter(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
	component_parts += new /obj/item/weapon/reagent_containers/glass/beaker(src)
	component_parts += new /obj/item/weapon/reagent_containers/glass/beaker(src)
	RefreshParts()

/obj/machinery/r_n_d/circuit_imprinter/process()
	..()
	if(stat)
		update_icon()
		return
	if(queue.len == 0)
		busy = 0
		update_icon()
		return
	var/datum/design/D = queue[1]
	if(canBuild(D))
		busy = 1
		progress += speed
		if(progress >= D.time)
			build(D)
			progress = 0
			removeFromQueue(1)
			if(linked_console)
				linked_console.updateUsrDialog()
		update_icon()
	else
		if(busy)
			visible_message("<span class='notice'>\icon [src] flashes: insufficient materials: [getLackingMaterials(D)].</span>")
			busy = 0
			update_icon()

/obj/machinery/r_n_d/circuit_imprinter/RefreshParts()
	var/T = 0
	for(var/obj/item/weapon/reagent_containers/glass/G in component_parts)
		T += G.reagents.maximum_volume
	create_reagents(T)
	max_material_storage = 0
	for(var/obj/item/weapon/stock_parts/matter_bin/M in component_parts)
		max_material_storage += M.rating * 75000
	T = 0
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		T += M.rating
	mat_efficiency = 1 - (T - 1) / 4
	speed = T

/obj/machinery/r_n_d/circuit_imprinter/update_icon()
	if(panel_open)
		icon_state = "circuit_imprinter_t"
	else if(busy)
		icon_state = "circuit_imprinter_ani"
	else
		icon_state = "circuit_imprinter"

/obj/machinery/r_n_d/circuit_imprinter/blob_act()
	if(prob(50))
		qdel(src)

/obj/machinery/r_n_d/circuit_imprinter/proc/TotalMaterials()
	var/t = 0
	for(var/f in materials)
		t += materials[f]
	return t

/obj/machinery/r_n_d/circuit_imprinter/dismantle()
	for(var/obj/I in component_parts)
		if(istype(I, /obj/item/weapon/reagent_containers/glass/beaker))
			reagents.trans_to_obj(I, reagents.total_volume)
	for(var/f in materials)
		if(materials[f] >= SHEET_MATERIAL_AMOUNT)
			var/path = getMaterialType(f)
			if(path)
				var/obj/item/stack/S = new f(loc)
				S.amount = round(materials[f] / SHEET_MATERIAL_AMOUNT)
	..()

/obj/machinery/r_n_d/circuit_imprinter/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(busy)
		user << "<span class='notice'>\The [src] is busy. Please wait for completion of previous operation.</span>"
		return 1
	if(default_deconstruction_screwdriver(user, O))
		if(linked_console)
			linked_console.linked_imprinter = null
			linked_console = null
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return
	if(panel_open)
		user << "<span class='notice'>You can't load \the [src] while it's opened.</span>"
		return 1
	if(!linked_console)
		user << "\The [src] must be linked to an R&D console first."
		return 1
	if(O.is_open_container())
		return 0
	if(!istype(O, /obj/item/stack/material/glass) && !istype(O, /obj/item/stack/material/gold) && !istype(O, /obj/item/stack/material/diamond) && !istype(O, /obj/item/stack/material/uranium))
		user << "<span class='notice'>You cannot insert this item into \the [src].</span>"
		return 1
	if(stat)
		return 1

	if(TotalMaterials() + SHEET_MATERIAL_AMOUNT > max_material_storage)
		user << "<span class='notice'>\The [src]'s material bin is full. Please remove material before adding more.</span>"
		return 1

	var/obj/item/stack/stack = O

	var/amount = round(input("How many sheets do you want to add?") as num)
	if(!O)
		return
	if(amount <= 0)//No negative numbers
		return
	if(amount > stack.get_amount())
		amount = stack.get_amount()
	if(max_material_storage - TotalMaterials() < (amount * SHEET_MATERIAL_AMOUNT)) //Can't overfill
		amount = min(stack.get_amount(), round((max_material_storage - TotalMaterials()) / SHEET_MATERIAL_AMOUNT))

	busy = 1
	use_power(max(1000, (SHEET_MATERIAL_AMOUNT * amount / 10)))
	var/stacktype = stack.type
	var/t = getMaterialName(stacktype)
	if(t)
		if(do_after(usr, 16))
			if(stack.use(amount))
				user << "<span class='notice'>You add [amount] sheets to \the [src].</span>"
				materials[t] += amount * SHEET_MATERIAL_AMOUNT
	busy = 0
	updateUsrDialog()

/obj/machinery/r_n_d/circuit_imprinter/proc/addToQueue(var/datum/design/D)
	queue += D
	return

/obj/machinery/r_n_d/circuit_imprinter/proc/removeFromQueue(var/index)
	queue.Cut(index, index + 1)
	return

/obj/machinery/r_n_d/circuit_imprinter/proc/canBuild(var/datum/design/D)
	for(var/M in D.materials)
		if(materials[M] < D.materials[M])
			return 0
	for(var/C in D.chemicals)
		if(!reagents.has_reagent(C, D.chemicals[C]))
			return 0
	return 1

/obj/machinery/r_n_d/circuit_imprinter/proc/getLackingMaterials(var/datum/design/D)
	var/ret = ""
	for(var/M in D.materials)
		if(materials[M] < D.materials[M])
			if(ret != "")
				ret += ", "
			ret += "[D.materials[M] - materials[M]] [M]"
	for(var/C in D.chemicals)
		if(!reagents.has_reagent(C, D.chemicals[C]))
			if(ret != "")
				ret += ", "
			ret += C
	return ret

/obj/machinery/r_n_d/circuit_imprinter/proc/build(var/datum/design/D)
	var/power = active_power_usage
	for(var/M in D.materials)
		power += round(D.materials[M] / 5)
	power = max(active_power_usage, power)
	use_power(power)
	for(var/M in D.materials)
		materials[M] = max(0, materials[M] - D.materials[M] * mat_efficiency)
	for(var/C in D.chemicals)
		reagents.remove_reagent(C, D.chemicals[C] * mat_efficiency)

	if(D.build_path)
		var/obj/new_item = new D.build_path(src)
		new_item.loc = loc
		if(mat_efficiency != 1) // No matter out of nowhere
			if(new_item.matter && new_item.matter.len > 0)
				for(var/i in new_item.matter)
					new_item.matter[i] = new_item.matter[i] * mat_efficiency
