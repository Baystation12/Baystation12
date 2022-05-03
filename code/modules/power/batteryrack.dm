// Cell rack PSU, similar to SMES, but uses power cells to store power.
// Lacks detailed control of input/output values, and has generally much worse capacity.
#define PSU_OFFLINE 0
#define PSU_OUTPUT 1
#define PSU_INPUT 2
#define PSU_AUTO 3

#define PSU_MAXCELLS 9 // Capped to 9 cells due to sprite limitation

/obj/machinery/power/smes/batteryrack
	name = "power cell rack PSU"
	desc = "A rack of power cells working as a PSU."
	icon = 'icons/obj/cellrack.dmi'
	icon_state = "rack"
	capacity = 0
	charge = 0
	should_be_mapped = 1
	base_type = /obj/machinery/power/smes/batteryrack
	maximum_component_parts = list(/obj/item/stock_parts = 15)

	machine_name = "battery rack PSU"
	machine_desc = "A very simple power storage solution: several power cells on a rack. About as basic as you can get."

	var/max_transfer_rate = 0							// Maximal input/output rate. Determined by used capacitors when building the device.
	var/mode = PSU_OFFLINE								// Current inputting/outputting mode
	var/list/internal_cells = list()					// Cells stored in this PSU
	var/max_cells = 3									// Maximal amount of stored cells at once. Capped at 9.
	var/previous_charge = 0								// Charge previous tick.
	var/equalise = 0									// If true try to equalise charge between cells
	var/icon_update = 0									// Timer in ticks for icon update.
	var/ui_tick = 0

/obj/machinery/power/smes/batteryrack/RefreshParts()
	var/capacitor_efficiency = clamp(total_component_rating_of_type(/obj/item/stock_parts/capacitor), 0, 10)
	var/maxcells = 3 * total_component_rating_of_type(/obj/item/stock_parts/matter_bin)

	max_transfer_rate = 10000 * capacitor_efficiency // 30kw - 90kw depending on used capacitors.
	max_cells = min(PSU_MAXCELLS, maxcells)
	input_level = max_transfer_rate
	output_level = max_transfer_rate
	..()

/obj/machinery/power/smes/batteryrack/Destroy()
	for(var/obj/item/cell/C in internal_cells)
		qdel(C)
	internal_cells = null
	return ..()

/obj/machinery/power/smes/batteryrack/on_update_icon()
	overlays.Cut()
	icon_update = 0

	var/cellcount = 0
	var/charge_level = clamp(round(Percentage() / 12), 0, 7)


	overlays += "charge[charge_level]"

	if(!panel_open)
		icon_state = "rack-closed"
	else
		icon_state = "rack"
		for(var/obj/item/cell/C as anything in internal_cells)
			if (++cellcount > max_cells)
				break
			overlays += "cell[cellcount]"
			if(C.fully_charged())
				overlays += "cell[cellcount]f"
			else if(!C.charge)
				overlays += "cell[cellcount]e"

// Recalculate maxcharge and similar variables.
/obj/machinery/power/smes/batteryrack/proc/update_maxcharge()
	var/newmaxcharge = 0
	for(var/obj/item/cell/C in internal_cells)
		newmaxcharge += C.maxcharge

	capacity = newmaxcharge
	charge = clamp(charge, 0, newmaxcharge)


// Sets input/output depending on our "mode" var.
/obj/machinery/power/smes/batteryrack/proc/update_io(var/newmode)
	mode = newmode
	switch(mode)
		if(PSU_OFFLINE)
			input_attempt = 0
			output_attempt = 0
		if(PSU_INPUT)
			input_attempt = 1
			output_attempt = 0
		if(PSU_OUTPUT)
			input_attempt = 0
			output_attempt = 1
		if(PSU_AUTO)
			input_attempt = 1
			output_attempt = 1

// Store charge in the power cells, instead of using the charge var. Amount is in joules.
/obj/machinery/power/smes/batteryrack/add_charge(var/amount)
	amount *= CELLRATE // Convert to CELLRATE first.
	if(equalise)
		// Now try to get least charged cell and use the power from it.
		var/obj/item/cell/CL = get_least_charged_cell()
		if(!CL)
			return //no cells
		amount -= CL.give(amount)
		if(!amount)
			return
	// We're still here, so it means the least charged cell was full OR we don't care about equalising the charge. Give power to other cells instead.
	for(var/obj/item/cell/C in internal_cells)
		amount -= C.give(amount)
		// No more power to input so return.
		if(!amount)
			return


/obj/machinery/power/smes/batteryrack/remove_charge(var/amount)
	amount *= CELLRATE // Convert to CELLRATE first.
	if(equalise)
		// Now try to get most charged cell and use the power from it.
		var/obj/item/cell/CL = get_most_charged_cell()
		amount -= CL.use(amount)
		if(!amount)
			return
	// We're still here, so it means the most charged cell didn't have enough power OR we don't care about equalising the charge. Use power from other cells instead.
	for(var/obj/item/cell/C in internal_cells)
		amount -= C.use(amount)
		// No more power to output so return.
		if(!amount)
			return

// Helper procs to get most/least charged cells.
/obj/machinery/power/smes/batteryrack/proc/get_most_charged_cell()
	var/obj/item/cell/CL = null
	for(var/obj/item/cell/C in internal_cells)
		if(CL == null)
			CL = C
		else if(CL.percent() < C.percent())
			CL = C
	return CL
/obj/machinery/power/smes/batteryrack/proc/get_least_charged_cell()
	var/obj/item/cell/CL = null
	for(var/obj/item/cell/C in internal_cells)
		if(CL == null)
			CL = C
		else if(CL.percent() > C.percent())
			CL = C
	return CL

/obj/machinery/power/smes/batteryrack/proc/insert_cell(var/obj/item/cell/C, var/mob/user)
	if(!istype(C))
		return 0

	if(internal_cells.len >= max_cells)
		return 0
	if(user && !user.unEquip(C))
		return 0
	internal_cells.Add(C)
	C.forceMove(src)
	RefreshParts()
	update_maxcharge()
	update_icon()
	return 1


/obj/machinery/power/smes/batteryrack/Process()
	charge = 0
	for(var/obj/item/cell/C in internal_cells)
		charge += C.charge

	..()
	ui_tick = !ui_tick
	icon_update++

	// Don't update icon too much, prevents unnecessary processing.
	if(icon_update >= 10)
		update_icon()
	// Try to balance charge between stored cells. Capped at max_transfer_rate per tick.
	// Take power from most charged cell, and give it to least charged cell.
	if(equalise)
		var/obj/item/cell/least = get_least_charged_cell()
		var/obj/item/cell/most = get_most_charged_cell()
		// Don't bother equalising charge between two same cells. Also ensure we don't get NULLs or wrong types. Don't bother equalising when difference between charges is tiny.
		if(!least || !most || least.percent() == most.percent())
			return
		var/percentdiff = (most.percent() - least.percent()) / 2 // Transfer only 50% of power. The reason is that it could lead to situations where least and most charged cells would "swap places" (45->50% and 50%->45%)
		var/celldiff
		// Take amount of power to transfer from the cell with smaller maxcharge
		if(most.maxcharge > least.maxcharge)
			celldiff = (least.maxcharge / 100) * percentdiff
		else
			celldiff = (most.maxcharge / 100) * percentdiff
		celldiff = clamp(celldiff, 0, max_transfer_rate * CELLRATE)
		// Ensure we don't transfer more energy than the most charged cell has, and that the least charged cell can input.
		celldiff = min(min(celldiff, most.charge), least.maxcharge - least.charge)
		least.give(most.use(celldiff))

/obj/machinery/power/smes/batteryrack/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]

	data["mode"] = mode
	data["transfer_max"] = max_transfer_rate
	data["output_load"] = round(output_used)
	data["input_load"] = round(input_available)
	data["equalise"] = equalise
	data["blink_tick"] = ui_tick
	data["cells_max"] = max_cells
	data["cells_cur"] = internal_cells.len
	var/list/cells = list()
	var/cell_index = 1
	for(var/obj/item/cell/C in internal_cells)
		var/list/cell[0]
		cell["slot"] = cell_index
		cell["used"] = 1
		cell["percentage"] = round(C.percent(), 0.01)
		cell_index++
		cells += list(cell)
	while(cell_index <= PSU_MAXCELLS)
		var/list/cell[0]
		cell["slot"] = cell_index
		cell["used"] = 0
		cell_index++
		cells += list(cell)
	data["cells_list"] = cells

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "psu.tmpl", "Cell Rack PSU", 500, 430)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/power/smes/batteryrack/dismantle()
	for(var/obj/item/cell/C in internal_cells)
		C.dropInto(loc)
		internal_cells -= C
	return ..()

/obj/machinery/power/smes/batteryrack/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if(..())
		return TRUE
	if(istype(W, /obj/item/cell)) // ID Card, try to insert it.
		if(insert_cell(W, user))
			to_chat(user, "You insert \the [W] into \the [src].")
		else
			to_chat(user, "\The [src] has no empty slot for \the [W]")

/obj/machinery/power/smes/batteryrack/interface_interact(var/mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/power/smes/batteryrack/inputting()
	return

/obj/machinery/power/smes/batteryrack/outputting()
	return

/obj/machinery/power/smes/batteryrack/Topic(href, href_list)
	// ..() would respond to those topic calls, but we don't want to use them at all.
	// Calls to these shouldn't occur anyway, due to usage of different nanoUI, but
	// it's here in case someone decides to try hrefhacking/modified templates.
	if(href_list["input"] || href_list["output"])
		return 1

	if(..())
		return 1
	if( href_list["disable"] )
		update_io(0)
		return 1
	else if( href_list["enable"] )
		update_io(clamp(text2num(href_list["enable"]), 1, 3))
		return 1
	else if( href_list["equaliseon"] )
		equalise = 1
		return 1
	else if( href_list["equaliseoff"] )
		equalise = 0
		return 1
	else if( href_list["ejectcell"] )
		var/slot_number = text2num(href_list["ejectcell"])
		if(slot_number != clamp(round(slot_number), 1, length(internal_cells)))
			return 1
		var/obj/item/cell/C = internal_cells[slot_number]

		C.dropInto(loc)
		internal_cells -= C
		update_icon()
		RefreshParts()
		update_maxcharge()
		return 1
