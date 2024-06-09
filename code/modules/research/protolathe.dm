/obj/machinery/r_n_d/protolathe
	name = "protolathe"
	desc = "Accessed by a connected core fabricator console, it produces items from various materials."
	icon_state = "protolathe"
	icon = 'icons/obj/machines/research/protolathe.dmi'
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_OPEN_CONTAINER

	idle_power_usage = 30
	active_power_usage = 5000
	base_type = /obj/machinery/r_n_d/protolathe
	construct_state = /singleton/machine_construction/default/panel_closed

	machine_name = "protolathe"
	machine_desc = "Uses raw materials to produce prototypes. Part of an R&D network."

	var/lathe_serial

	var/max_material_storage = 250000

	var/list/datum/design/queue = list()
	var/progress = 0

	var/mat_efficiency = 1
	var/speed = 1


/obj/machinery/r_n_d/protolathe/Initialize()
	. = ..()
	materials = default_material_composition.Copy()
	lathe_serial = "S[copytext(md5(ref(src)), 1, 5)]"


/obj/machinery/r_n_d/protolathe/examine(mob/user, distance)
	. = ..()
	if (distance < 2 || isobserver(user))
		to_chat(user, {"The serial "[lathe_serial]" is engraved by the material slots."})


/obj/machinery/r_n_d/protolathe/Process()
	..()
	if(inoperable())
		update_icon()
		return
	if(length(queue) == 0)
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
			visible_message(SPAN_NOTICE("[icon2html(src, viewers(get_turf(src)))] [src] flashes: insufficient materials: [getLackingMaterials(D)]."))
			busy = 0
			update_icon()

/obj/machinery/r_n_d/protolathe/RefreshParts()
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

	T = clamp(total_component_rating_of_type(/obj/item/stock_parts/manipulator), 0, 6)
	mat_efficiency = 1 - (T - 2) / 8
	speed = T / 2
	..()


/obj/machinery/r_n_d/protolathe/on_update_icon()
	ClearOverlays()
	if(panel_open)
		AddOverlays("[icon_state]_panel")
	if(is_powered())
		AddOverlays(emissive_appearance(icon, "[icon_state]_lights"))
		AddOverlays("[icon_state]_lights")
	if(busy)
		AddOverlays("[icon_state]_working")
		AddOverlays(emissive_appearance(icon, "[icon_state]_lights_working"))
		AddOverlays("[icon_state]_lights_working")

/obj/machinery/r_n_d/protolathe/state_transition(singleton/machine_construction/default/new_state)
	. = ..()
	if(istype(new_state) && linked_console)
		linked_console.linked_lathe = null
		linked_console = null

/obj/machinery/r_n_d/protolathe/components_are_accessible(path)
	return !busy && ..()

/obj/machinery/r_n_d/protolathe/cannot_transition_to(state_path)
	if(busy)
		return SPAN_NOTICE("\The [src] is busy. Please wait for completion of previous operation.")
	return ..()

/obj/machinery/r_n_d/protolathe/use_tool(obj/item/O, mob/living/user, list/click_params)
	if(busy)
		to_chat(user, SPAN_NOTICE("\The [src] is busy. Please wait for completion of previous operation."))
		return TRUE
	if((. = ..()))
		return
	if(O.is_open_container())
		return FALSE
	if(panel_open)
		to_chat(user, SPAN_NOTICE("You can't load \the [src] while it's opened."))
		return TRUE
	if(!linked_console)
		to_chat(user, SPAN_NOTICE("\The [src] must be linked to an R&D console first!"))
		return TRUE
	if(is_robot_module(O))
		return FALSE
	if(!istype(O, /obj/item/stack/material))
		to_chat(user, SPAN_NOTICE("You cannot insert this item into \the [src]!"))
		return TRUE
	if(inoperable())
		return TRUE

	if(TotalMaterials() + SHEET_MATERIAL_AMOUNT > max_material_storage)
		to_chat(user, SPAN_NOTICE("\The [src]'s material bin is full. Please remove material before adding more."))
		return TRUE

	var/obj/item/stack/material/stack = O

	var/amount = min(stack.get_amount(), round((max_material_storage - TotalMaterials()) / SHEET_MATERIAL_AMOUNT))

	var/image/I = image(icon, "protolathe_stack")
	I.color = stack.material.icon_colour
	AddOverlays(I)
	spawn(10)
		CutOverlays(I)

	busy = 1
	use_power_oneoff(max(1000, (SHEET_MATERIAL_AMOUNT * amount / 10)))
	if(do_after(user, 1.6 SECONDS, src, DO_PUBLIC_UNIQUE))
		if(stack.use(amount))
			to_chat(user, SPAN_NOTICE("You add [amount] sheet\s to \the [src]."))
			materials[stack.material.name] += amount * SHEET_MATERIAL_AMOUNT
	busy = 0
	updateUsrDialog()
	return TRUE

/obj/machinery/r_n_d/protolathe/proc/addToQueue(datum/design/D)
	queue += D
	return

/obj/machinery/r_n_d/protolathe/proc/removeFromQueue(index)
	if(!is_valid_index(index, queue))
		return
	queue.Cut(index, index + 1)

/obj/machinery/r_n_d/protolathe/proc/canBuild(datum/design/D)
	for(var/M in D.materials)
		if(materials[M] < D.materials[M] * mat_efficiency)
			return 0
	for(var/C in D.chemicals)
		if(!reagents.has_reagent(C, D.chemicals[C] * mat_efficiency))
			return 0
	return 1

/obj/machinery/r_n_d/protolathe/proc/build(datum/design/D)
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
		var/item_serial = new_item.GetSerial(src)
		if(linked_console.tape)
			var/message = {"Produced a "[new_item.name]""}
			if (item_serial)
				message += {" with serial "[item_serial]""}
			linked_console.tape.record_speech(message)
		if(mat_efficiency != 1) // No matter out of nowhere
			if(new_item.matter && length(new_item.matter) > 0)
				for(var/i in new_item.matter)
					new_item.matter[i] = new_item.matter[i] * mat_efficiency
