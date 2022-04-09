/obj/machinery/computer/fusion/core_control
	name = "\improper R-UST Mk. 8 core control"
	ui_template = "fusion_core_control.tmpl"

/obj/machinery/computer/fusion/core_control/OnTopic(var/mob/user, var/href_list, var/datum/topic_state/state)

	if(href_list["toggle_active"] || href_list["str"])
		var/obj/machinery/power/fusion_core/C = locate(href_list["machine"])
		if(!istype(C))
			return TOPIC_NOACTION

		var/datum/local_network/lan = get_local_network()
		if(!lan || !lan.is_connected(C))
			return TOPIC_NOACTION

		if(!C.check_core_status())
			return TOPIC_NOACTION

		if(href_list["toggle_active"])
			if(!C.Startup()) //Startup() whilst the device is active will return null.
				if(!C.owned_field.is_shutdown_safe())
					if(alert(user, "Shutting down this fusion core without proper safety procedures will cause serious damage, do you wish to continue?", "Shut Down?", "Yes", "No") == "No")
						return TOPIC_NOACTION
				C.Shutdown()
			return TOPIC_REFRESH

		if(href_list["str"] && C)
			var/val = text2num(href_list["str"])
			if(!val) //Value is 0, which is manual entering.
				C.set_strength(input("Enter the new field power density (W.m^-3)", "Fusion Control", C.field_strength) as num)
			else
				C.set_strength(C.field_strength + val)
			return TOPIC_REFRESH

/obj/machinery/computer/fusion/core_control/build_ui_data()
	. = ..()
	var/datum/extension/local_network_member/fusion = get_extension(src, /datum/extension/local_network_member)
	var/datum/local_network/lan = fusion.get_local_network()
	var/list/cores = list()
	if(lan)
		var/list/fusion_cores = lan.get_devices(/obj/machinery/power/fusion_core)
		for(var/i = 1 to LAZYLEN(fusion_cores))
			var/list/core = list()
			var/obj/machinery/power/fusion_core/C = fusion_cores[i]
			core["id"] =          "#[i]"
			core["ref"] =         "\ref[C]"
			core["field"] =       !isnull(C.owned_field)
			core["power"] =       "[C.field_strength/10.0] tesla"
			core["size"] =        C.owned_field ? "[C.owned_field.size] meter\s" : "Field offline."
			core["instability"] = C.owned_field ? "[C.owned_field.percent_unstable * 100]%" : "Field offline."
			core["temperature"] = C.owned_field ? "[C.owned_field.plasma_temperature + 295]K" : "Field offline."
			core["powerstatus"] = "[C.avail()]/[C.active_power_usage] W"
			var/fuel_string = "<table width = '100%'>"
			if(C.owned_field && LAZYLEN(C.owned_field.reactants))
				for(var/reactant in C.owned_field.reactants)
					fuel_string += "<tr><td>[reactant]</td><td>[C.owned_field.reactants[reactant]]</td></tr>"
			else
				fuel_string += "<tr><td colspan = 2>Nothing.</td></tr>"
			fuel_string += "</table>"
			core["fuel"] = fuel_string

			cores += list(core)
	.["cores"] = cores
