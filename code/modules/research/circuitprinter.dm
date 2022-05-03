/*///////////////Circuit Imprinter (By Darem)////////////////////////
	Used to print new circuit boards (for computers and similar systems) and AI modules. Each circuit board pattern are stored in
a /datum/desgin on the linked R&D console. You can then print them out in a fasion similar to a regular lathe. However, instead of
using metal and glass, it uses glass and reagents (usually sulphuric acid).
*/

/obj/machinery/r_n_d/circuit_imprinter
	name = "circuit imprinter"
	desc = "Accessed by a connected core fabricator console, it produces circuits from various materials and sulphuric acid."
	icon_state = "circuit_imprinter"
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	base_type = /obj/machinery/r_n_d/circuit_imprinter
	construct_state = /decl/machine_construction/default/panel_closed

	var/list/datum/design/queue = list()
	var/progress = 0

	var/max_material_storage = 100000
	var/mat_efficiency = 1
	var/speed = 1

	idle_power_usage = 30
	active_power_usage = 2500

	machine_name = "circuit imprinter"
	machine_desc = "Creates circuit boards by etching raw sheets of material with sulphuric acid. Part of an R&D network."

/obj/machinery/r_n_d/circuit_imprinter/New()
	materials = default_material_composition.Copy()

	..()

/obj/machinery/r_n_d/circuit_imprinter/Process()
	..()
	if(stat & (BROKEN | NOPOWER))
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
			visible_message("<span class='notice'>[icon2html(src, viewers(get_turf(src)))] [src] flashes: insufficient materials: [getLackingMaterials(D)].</span>")
			busy = 0
			update_icon()

/obj/machinery/r_n_d/circuit_imprinter/RefreshParts()
	var/T = 0
	var/obj/item/stock_parts/building_material/mat = get_component_of_type(/obj/item/stock_parts/building_material)
	if(mat)
		for(var/obj/item/reagent_containers/glass/G in mat.materials)
			T += G.volume
		if(!reagents)
			create_reagents(T)
		else
			reagents.maximum_volume = T

	max_material_storage = 75000 * clamp(total_component_rating_of_type(/obj/item/stock_parts/matter_bin), 0, 10)

	T = clamp(total_component_rating_of_type(/obj/item/stock_parts/manipulator), 0, 3)
	mat_efficiency = 1 - (T - 1) / 4
	speed = T
	..()

/obj/machinery/r_n_d/circuit_imprinter/on_update_icon()
	if(panel_open)
		icon_state = "circuit_imprinter_t"
	else if(busy)
		icon_state = "circuit_imprinter_ani"
	else
		icon_state = "circuit_imprinter"

/obj/machinery/r_n_d/circuit_imprinter/state_transition(var/decl/machine_construction/default/new_state)
	. = ..()
	if(istype(new_state) && linked_console)
		linked_console.linked_imprinter = null
		linked_console = null

/obj/machinery/r_n_d/circuit_imprinter/components_are_accessible(path)
	return !busy && ..()

/obj/machinery/r_n_d/circuit_imprinter/cannot_transition_to(state_path)
	if(busy)
		return SPAN_NOTICE("\The [src] is busy. Please wait for completion of previous operation.")
	return ..()

/obj/machinery/r_n_d/circuit_imprinter/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(busy)
		to_chat(user, "<span class='notice'>\The [src] is busy. Please wait for completion of previous operation.</span>")
		return 1
	if(component_attackby(O, user))
		return TRUE
	if(panel_open)
		to_chat(user, "<span class='notice'>You can't load \the [src] while it's opened.</span>")
		return 1
	if(!linked_console)
		to_chat(user, "\The [src] must be linked to an R&D console first.")
		return 1
	if(O.is_open_container())
		return 0
	if(is_robot_module(O))
		return 0
	if(!istype(O, /obj/item/stack/material))
		to_chat(user, "<span class='notice'>You cannot insert this item into \the [src]!</span>")
		return 0
	if(stat & (BROKEN | NOPOWER))
		return 1

	if(TotalMaterials() + SHEET_MATERIAL_AMOUNT > max_material_storage)
		to_chat(user, "<span class='notice'>\The [src]'s material bin is full. Please remove material before adding more.</span>")
		return 1

	var/obj/item/stack/material/stack = O
	var/amount = min(stack.get_amount(), round((max_material_storage - TotalMaterials()) / SHEET_MATERIAL_AMOUNT))

	busy = 1
	use_power_oneoff(max(1000, (SHEET_MATERIAL_AMOUNT * amount / 10)))

	var/t = stack.material.name
	if(t)
		if(do_after(usr, 1.6 SECONDS, src, DO_PUBLIC_UNIQUE))
			if(stack.use(amount))
				to_chat(user, "<span class='notice'>You add [amount] sheet\s to \the [src].</span>")
				materials[t] += amount * SHEET_MATERIAL_AMOUNT
	busy = 0
	updateUsrDialog()

/obj/machinery/r_n_d/circuit_imprinter/proc/addToQueue(var/datum/design/D)
	queue += D
	return

/obj/machinery/r_n_d/circuit_imprinter/proc/removeFromQueue(var/index)
	if(!is_valid_index(index, queue))
		return
	queue.Cut(index, index + 1)

/obj/machinery/r_n_d/circuit_imprinter/proc/canBuild(var/datum/design/D)
	for(var/M in D.materials)
		if(materials[M] <= D.materials[M] * mat_efficiency)
			return 0
	for(var/C in D.chemicals)
		if(!reagents.has_reagent(C, D.chemicals[C] * mat_efficiency))
			return 0
	return 1

/obj/machinery/r_n_d/circuit_imprinter/proc/build(var/datum/design/D)
	var/power = active_power_usage
	for(var/M in D.materials)
		power += round(D.materials[M] / 5)
	power = max(active_power_usage, power)
	use_power_oneoff(power)
	for(var/M in D.materials)
		materials[M] = max(0, materials[M] - D.materials[M] * mat_efficiency)
	for(var/C in D.chemicals)
		reagents.remove_reagent(C, D.chemicals[C] * mat_efficiency)

	if(D.build_path)
		var/obj/new_item = D.Fabricate(loc, src)
		if(mat_efficiency != 1) // No matter out of nowhere
			if(new_item.matter && new_item.matter.len > 0)
				for(var/i in new_item.matter)
					new_item.matter[i] = new_item.matter[i] * mat_efficiency
