datum/preferences
	var/current_tab = "General"

datum/preferences/proc/contentLoadout()
	var/data = {"

		<html><body>

		<nav class='vNav'>
		<ul>
		<li><a href='?src=\ref[src];page=1'>Character</a>
		<li><a href='?src=\ref[src];page=2'>Occupation</a>
		<li><a class='active' href='?src=\ref[src];page=3'>Loadout</a>
		<li><a href='?src=\ref[src];page=4'>Local Preferences</a>
		<li><hr>
		<li><a href='?src=\ref[src];page=9'>Records</a>
		<li><hr>
		<li><a href='?src=\ref[src];page=8'>Global Preferences</a>
		</ul>
		</nav>

		<nav class='hNav'>
		<ul>
		<li><a href='?src=\ref[src];save=1'>Save</a>
		<li><a href='?src=\ref[src];load=1'>Load</a>
		<li><a href='?src=\ref[src];delete=1'>Reset</a>
		<li><a href='?src=\ref[src];lock=1'>Lock</a>
		</ul>
		</nav>

		<div class='main' style='width:650px; overflow-y:auto;'>

		 "}
	var/total_cost = 0
	if(gear && gear.len)
		for(var/i = 1; i <= gear.len; i++)
			var/datum/gear/G = gear_datums[gear[i]]
			if(G)
				total_cost += G.cost

	var/fcolor =  "#3366CC"
	if(total_cost < MAX_GEAR_COST)
		fcolor = "#E67300"
	data += "<table align = 'center' width = 100%>"
	data += "<tr><td colspan=3><center>Loadout Slot: [gear_slot] (<a href='?src=\ref[src];prev_slot=1'>\<\<</a><b><font color = '[fcolor]'></font> </b><a href='?src=\ref[src];next_slot=1'>\>\></a>) | Loadout points spent: <b><font color = '[fcolor]'> [total_cost] / [MAX_GEAR_COST]</font></b> (<a href='?src=\ref[src];clear_loadout=1'>Clear Loadout</a>)</center></td></tr>"

	data += "<tr><td colspan=3><center><b>"
	var/firstcat = 1
	for(var/category in loadout_categories)

		if(firstcat)
			firstcat = 0
		else
			data += " |"

		var/datum/loadout_category/LC = loadout_categories[category]
		var/category_cost = 0
		for(var/gear in LC.gear)
			if(gear in gear)
				var/datum/gear/G = LC.gear[gear]
				category_cost += G.cost

		if(category == current_tab)
			data += "<a class='active' href='?src=\ref[src];select_category=[category]'>[category] - [category_cost]</a> "
		else
			if(category_cost)
				data += " <a href='?src=\ref[src];select_category=[category]'><font color = '#E67300'>[category] - [category_cost]</font></a> "
			else
				data += " <a href='?src=\ref[src];select_category=[category]'>[category] - 0</a> "

	data += "</b></center></td></tr>"

	var/datum/loadout_category/LC = loadout_categories[current_tab]
	data += "<tr><td colspan=3><hr></td></tr>"
	data += "<tr><td colspan=3><b><center>[LC.category]</center></b></td></tr>"
	data += "<tr><td colspan=3><hr></td></tr>"
	var/jobs = list()
	if(job_high || job_medium || job_low)
		if(job_high) //Is not a list like the others so a check just in case
			jobs += job_high
		jobs += job_medium
		jobs += job_low
	for(var/gear_name in LC.gear)
		if(!(gear_name in valid_gear_choices()))
			continue
		var/datum/gear/G = LC.gear[gear_name]
		var/ticked = (G.display_name in gear)
		data += "<tr style='vertical-align:top;'><td width=25%><a style='white-space:normal;' [ticked ? "class='linkOn' " : ""]href='?src=\ref[src];toggle_gear=[html_encode(G.display_name)]'>[G.display_name]</a></td>"
		data += "<td width = 10% style='vertical-align:top'>[G.cost]</td>"
		data += "<td><font size=2>[G.description]</font>"
		if(G.allowed_roles)
			data += "<br><i>"
			var/ind = 0
			for(var/J in jobs)
				if(J in G.allowed_roles)
					++ind
					if(ind > 1)
						data += ", "
					data += "<font color=55cc55>[J]</font>"
				else
					++ind
					if(ind > 1)
						data += ", "
					data += "<font color=cc5555>[J]</font>"
			data += "</i>"
		data+= "</tr>"
		if(ticked)
			data += "<tr><td colspan=3>"
			for(var/datum/gear_tweak/tweak in G.gear_tweaks)
				data += " <a href='?src=\ref[src];gear=[G.display_name];tweak=\ref[tweak]'>[tweak.get_contents(get_tweak_metadata(G, tweak))]</a>"
			data += "</td></tr>"
	data += {"</table>
		</div>

		<div class='secondary'>
		</div>

		<div class='background'>
		</div>

		</body></html>

		"}

	return data

/datum/preferences/proc/Topic3(var/href, var/list/href_list)

	if(href_list["page"])
		selected_menu = text2num(href_list["page"])

	else if(href_list["toggle_gear"])
		var/datum/gear/TG = gear_datums[href_list["toggle_gear"]]
		if(TG.display_name in gear)
			gear -= TG.display_name
		else
			var/total_cost = 0
			for(var/gear_name in gear)
				var/datum/gear/G = gear_datums[gear_name]
				if(istype(G)) total_cost += G.cost
			if((total_cost+TG.cost) <= MAX_GEAR_COST)
				gear += TG.display_name

	if(href_list["gear"] && href_list["tweak"])
		var/datum/gear/gear = gear_datums[href_list["gear"]]
		var/datum/gear_tweak/tweak = locate(href_list["tweak"])
		if(!tweak || !istype(gear) || !(tweak in gear.gear_tweaks))
			return
		var/metadata = tweak.get_metadata(user, get_tweak_metadata(gear, tweak))
		if(!metadata || !CanUseTopic(user))
			return
		set_tweak_metadata(gear, tweak, metadata)

	if(href_list["next_slot"] || href_list["prev_slot"])
		//Set the current slot in the gear list to the currently selected gear
		gear_list["[gear_slot]"] = gear
		//If we're moving up a slot..
		if(href_list["next_slot"])
			//change the current slot number
			gear_slot++
			if (gear_slot >= 4)
				gear_slot = 1
		//If we're moving down a slot..
		else if(href_list["prev_slot"])
			//change current slot one down
			gear_slot--
			if (gear_slot <= 0)
				gear_slot = 3
		// Set the currently selected gear to whatever's in the new slot
		if(gear_list["[gear_slot]"])
			gear = gear_list["[gear_slot]"]
		else
			gear = list()
			gear_list["[gear_slot]"] = list()

	else if(href_list["select_category"])
		current_tab = href_list["select_category"]

	else if(href_list["clear_loadout"])
		gear.Cut()