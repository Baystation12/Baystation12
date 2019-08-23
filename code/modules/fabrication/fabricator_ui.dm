/obj/machinery/fabricator/interact(mob/user)
	user.set_machine(src)

	var/list/dat = list()
	dat += "<center><h1>[capitalize(name)] Control Panel</h1><hr/>"

	if(is_functioning())

		// Material table.
		if(length(base_storage_capacity))
			dat += "<table width = '100%'>"
			var/material_top = "<tr>"
			var/material_bottom = "<tr>"
			for(var/material in stored_material)
				material_top += "<td width = '25%' align = center><b>[capitalize(stored_substances_to_names[material])]</b></td>"
				material_bottom += "<td width = '25%' align = center>[stored_material[material]]<b>/[storage_capacity[material]]</b>"
				material_bottom += "<br><a href='?src=\ref[src];eject_mat=[stored_substances_to_names[material]]'>[ispath(material, /material) ? "Eject" : "Flush"]</a>"
				material_bottom += "</td>"
			dat += "[material_top]</tr>[material_bottom]</tr></table><hr>"

		// Build table.
		dat += "<h2>Current Builds</h2>"
		dat += "<table width = '100%'>"
		dat += "<tr>"
		dat += "<td><b>Build</b></td>"
		dat += "<td><b>Number</b></td>"
		dat += "<td><b>Status</b></td>"
		dat += "</tr>"
		if(currently_building)
			dat += "<tr>"
			dat += "<td>[currently_building.target_recipe.name]</td>"
			dat += "<td>x[currently_building.multiplier]</td>"
			dat += "<td>[100-round((currently_building.remaining_time/currently_building.target_recipe.build_time)*100)]%</td>"
			dat += "</tr>"
		else
			dat += "<tr>"
			dat += "<td colspan = 3>"
			dat += "<p><center>Nothing building.</center></p>"
			dat += "</td>"
			dat += "</tr>"
		if(length(queued_orders))
			for(var/datum/fabricator_build_order/order in queued_orders)
				dat += "<tr>"
				dat += "<td>[order.target_recipe.name]</td>"
				dat += "<td>x[order.multiplier]</td>"
				dat += "<td><a href ='?src=\ref[src];cancel=\ref[order]'>Cancel</a></td>"
				dat += "</tr>"
		else
			dat += "<tr><td colspan = 3>"
			dat += "<p><center>Nothing queued.</center></p>"
			dat += "</td></tr>"
		dat += "</table>"

		// Build controls.
		dat += "<h2>Printable Designs</h2><h3>Showing: <a href='?src=\ref[src];change_category=1'>[show_category]</a>.</h3></center><table width = '100%'>"
		for(var/datum/fabricator_recipe/R in SSfabrication.get_recipes(fabricator_class))
			if(R.hidden && !(fab_status_flags & FAB_HACKED) || (show_category != "All" && show_category != R.category))
				continue
			var/can_make = 1
			var/material_string = ""
			var/multiplier_string = ""
			var/max_sheets
			if(!length(R.resources))
				material_string = "No resources required.</td>"
			else
				//Make sure it's buildable and list required resources.
				var/list/material_components = list()
				for(var/material in R.resources)
					var/sheets = round(stored_material[material]/round(R.resources[material]*mat_efficiency))
					if(isnull(max_sheets) || max_sheets > sheets)
						max_sheets = sheets
					if(stored_material[material] < round(R.resources[material]*mat_efficiency))
						can_make = 0
					material_components += "[round(R.resources[material] * mat_efficiency)] [stored_substances_to_names[material]]"
				material_string = "[jointext(material_components, ", ")].<br></td>"

				//Build list of multipliers for sheets.
				if(ispath(R.path, /obj/item/stack))
					var/obj/item/stack/R_stack = R.path
					max_sheets = min(max_sheets, initial(R_stack.max_amount))
					//do not allow lathe to print more sheets than the max amount that can fit in one stack
					if(max_sheets && max_sheets > 0)
						multiplier_string  += "<br>"
						for(var/i = 5;i<max_sheets;i*=2) //5,10,20,40...
							multiplier_string  += "<a href='?src=\ref[src];make=\ref[R];multiplier=[i]'>\[x[i]\]</a>"
						multiplier_string += "<a href='?src=\ref[src];make=\ref[R];multiplier=[max_sheets]'>\[x[max_sheets]\]</a>"

			dat += "<tr><td width = 180>[R.hidden ? "<font color = 'red'>*</font>" : ""]<b>[can_make ? "<a href='?src=\ref[src];make=\ref[R];multiplier=1'>" : ""][R.name][can_make ? "</a>" : ""]</b>[R.hidden ? "<font color = 'red'>*</font>" : ""][multiplier_string]</td><td align = right>[material_string]</tr>"

		dat += "</table><hr>"

	var/datum/browser/popup = new(user, "fab_[base_icon_state]", "[capitalize(name)]", 450, 600)
	popup.set_content(jointext(dat, ""))
	popup.open()
