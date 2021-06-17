#define ORE_DISABLED 0
#define ORE_SMELT    1
#define ORE_COMPRESS 2
#define ORE_ALLOY    3

/obj/machinery/mineral/processing_unit
	name = "mineral processor"
	icon_state = "furnace_0"
	console = /obj/machinery/computer/mining
	input_turf =  NORTH
	output_turf = SOUTH

	machine_name = "ore processor"
	machine_desc = "Essentially a glorified furnace, ore processors can smelt, compress, or alloy raw minerals into new forms. Improper processing will result in useless slag!"

	var/sheets_per_tick = 10
	var/list/ores_processing
	var/list/ores_stored
	var/report_all_ores
	var/active = FALSE

/obj/machinery/mineral/processing_unit/Initialize()
	ores_processing = list()
	ores_stored = list()
	for(var/orename in SSmaterials.processable_ores)
		ores_processing[orename] = 0
		ores_stored[orename] = 0
	. = ..()

/obj/machinery/mineral/processing_unit/Process()
	if(!active)
		return

	//Grab some more ore to process this tick.
	if(input_turf)
		for(var/obj/item/I in recursive_content_check(input_turf, sight_check = FALSE, include_mobs = FALSE))
			if(QDELETED(I) || !I.simulated || I.anchored)
				continue
			if(LAZYLEN(I.matter))
				for(var/o_material in I.matter)
					if(!isnull(ores_stored[o_material]))
						ores_stored[o_material] += I.matter[o_material]
						qdel(I)

	//Process our stored ores and spit out sheets.
	if(output_turf)
		var/sheets = 0
		var/list/attempt_to_alloy = list()
		for(var/metal in ores_stored)

			if(sheets >= sheets_per_tick)
				break

			if(ores_stored[metal] <= 0 || ores_processing[metal] == ORE_DISABLED)
				continue

			var/material/M = SSmaterials.get_material_by_name(metal)
			var/result = 0 // For reference: a positive result indicates sheets were produced,
			               // and a negative result indicates slag was produced.
			var/ore_mode = ores_processing[metal]
			if(ore_mode == ORE_ALLOY)
				if(SSmaterials.alloy_components[metal])
					attempt_to_alloy[metal] = TRUE
				else
					result = min(sheets_per_tick - sheets, Floor(ores_processing[metal] / M.units_per_sheet))
					ores_processing[metal] -= result * M.units_per_sheet
					result = -(result)
			else if(ore_mode == ORE_COMPRESS)
				result = attempt_compression(M, sheets_per_tick - sheets)
			else if(ore_mode == ORE_SMELT)
				result = attempt_smelt(M, sheets_per_tick - sheets)

			sheets += abs(result)
			while(result < 0)
				new /obj/item/ore(output_turf, MATERIAL_WASTE)
				result++

		// Try to make any available alloys.
		if(LAZYLEN(attempt_to_alloy))

			var/list/making_alloys = list()
			for(var/thing in SSmaterials.alloy_products)
				var/material/M = thing
				var/failed = FALSE
				for(var/otherthing in M.alloy_materials)
					if(!attempt_to_alloy[otherthing] || ores_stored[otherthing] < M.alloy_materials[otherthing])
						failed = TRUE
						break
				if(!failed) making_alloys += M

			for(var/thing in making_alloys)
				if(sheets >= sheets_per_tick) break
				var/material/M = thing
				var/making
				for(var/otherthing in M.alloy_materials)
					var/_make = Floor(ores_stored[otherthing] / M.alloy_materials[otherthing])
					if(isnull(making) || making > _make)
						making = _make
				making = min(sheets_per_tick-sheets, making)
				for(var/otherthing in M.alloy_materials)
					ores_stored[otherthing] -= making * M.alloy_materials[otherthing]
				if(making > 0)
					M.place_sheet(output_turf, making)
					break

/obj/machinery/mineral/processing_unit/proc/attempt_smelt(var/material/metal, var/max_result)
	. = Clamp(Floor(ores_stored[metal.name]/metal.units_per_sheet),1,max_result)
	ores_stored[metal.name] -= . * metal.units_per_sheet
	var/material/M = SSmaterials.get_material_by_name(metal.ore_smelts_to)
	if(istype(M))
		M.place_sheet(output_turf, .)
	else
		. = -(.)

/obj/machinery/mineral/processing_unit/proc/attempt_compression(var/material/metal, var/max_result)
	var/making = Clamp(Floor(ores_stored[metal.name]/metal.units_per_sheet),1,max_result)
	if(making >= 2)
		ores_stored[metal.name] -= making * metal.units_per_sheet
		. = Floor(making * 0.5)
		var/material/M = SSmaterials.get_material_by_name(metal.ore_compresses_to)
		if(istype(M))
			M.place_sheet(output_turf, .)
		else
			. = -(.)
	else
		. = 0

/obj/machinery/mineral/processing_unit/get_console_data()
	. = ..() + "<h1>Mineral Processing</h1>"
	var/result = ""
	for(var/ore in ores_processing)
		if(!ores_stored[ore] && !report_all_ores) continue
		var/material/M = SSmaterials.get_material_by_name(ore)
		var/line = "[capitalize(M.display_name)]</td><td>[Floor(ores_stored[ore] / M.units_per_sheet)] ([ores_stored[ore]]u)"
		var/status_string
		if(ores_processing[ore])
			switch(ores_processing[ore])
				if(ORE_DISABLED)
					status_string = "<font color='red'>not processing</font>"
				if(ORE_SMELT)
					status_string = "<font color='orange'>smelting</font>"
				if(ORE_COMPRESS)
					status_string = "<font color='blue'>compressing</font>"
				if(ORE_ALLOY)
					status_string = "<font color='gray'>alloying</font>"
		else
			status_string = "<font color='red'>not processing</font>"
		result += "<tr><td>[line]</td><td><a href='?src=\ref[src];toggle_smelting=[ore]'>[status_string]</a></td></tr>"
	. += "<table>[result]</table>"
	. += "Currently displaying [report_all_ores ? "all ore types" : "only available ore types"]. <A href='?src=\ref[src];toggle_ores=1'>[report_all_ores ? "Show less" : "Show more"]</a>"
	. += "The ore processor is currently <A href='?src=\ref[src];toggle_power=1'>[(active ? "enabled" : "disabled")].</a>"

/obj/machinery/mineral/processing_unit/Topic(href, href_list)
	if((. = ..()))
		return
	if(href_list["toggle_smelting"])
		var/choice = input("What setting do you wish to use for processing [href_list["toggle_smelting"]]?") as null|anything in list("Smelting","Compressing","Alloying","Nothing")
		if(!choice) return
		switch(choice)
			if("Nothing")     choice = ORE_DISABLED
			if("Smelting")    choice = ORE_SMELT
			if("Compressing") choice = ORE_COMPRESS
			if("Alloying")    choice = ORE_ALLOY
		ores_processing[href_list["toggle_smelting"]] = choice
		. = TRUE
	else if(href_list["toggle_power"])
		active = !active
		update_icon()
		. = TRUE
	else if(href_list["toggle_ores"])
		report_all_ores = !report_all_ores
		. = TRUE
	if(. && console)
		console.updateUsrDialog()

/obj/machinery/mineral/processing_unit/on_update_icon()
	overlays.Cut()
	if(active)
		icon_state = "furnace_1"
	else
		icon_state = "furnace_0"

#undef ORE_DISABLED
#undef ORE_SMELT
#undef ORE_COMPRESS
#undef ORE_ALLOY