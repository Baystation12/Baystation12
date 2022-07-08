/obj/machinery/computer/fusion/fuel_control
	name = "fuel injection control computer"
	icon_keyboard = "rd_key"
	icon_screen = "fuel_screen"
	ui_template = "fusion_injector_control.tmpl"

/obj/machinery/computer/fusion/fuel_control/OnTopic(var/mob/user, var/href_list, var/datum/topic_state/state)
	var/datum/local_network/lan = get_local_network()
	var/list/fuel_injectors = lan.get_devices(/obj/machinery/fusion_fuel_injector)

	if(href_list["global_toggle"])
		if(!lan || !fuel_injectors)
			return TOPIC_NOACTION

		for(var/obj/machinery/fusion_fuel_injector/F in fuel_injectors)
			if(F.injecting)
				F.StopInjecting()
			else
				F.BeginInjecting()
		return TOPIC_REFRESH

	if(href_list["global_rate"])
		if(!lan || !fuel_injectors)
			return TOPIC_NOACTION
		var/new_injection_rate = input("Enter a new injection rate between 1 and 100. This will affect all injectors!", "Modifying injection rate") as null|num
		var/new_injection_clamped = clamp(new_injection_rate, 1, 100) / 100
		if(!new_injection_rate)
			return TOPIC_NOACTION
		if(!CanInteract(user,state))
			return TOPIC_NOACTION
		for(var/obj/machinery/fusion_fuel_injector/F as anything in fuel_injectors)
			F.injection_rate = new_injection_clamped
		return TOPIC_REFRESH

	if(href_list["toggle_injecting"] || href_list["injection_rate"])
		var/obj/machinery/fusion_fuel_injector/I = locate((href_list["toggle_injecting"] || href_list["machine"]))
		if(!istype(I) || !lan || !fuel_injectors || !fuel_injectors[I])
			return TOPIC_NOACTION

		if(href_list["toggle_injecting"])
			if(I.injecting)
				I.StopInjecting()
			else
				I.BeginInjecting()

		if(href_list["injection_rate"])
			var/new_injection_rate = input("Enter a new injection rate between 1 and 100.", "Modifying injection rate", I.injection_rate) as null|num
			if(!istype(I))
				return TOPIC_NOACTION
			if(!new_injection_rate)
				return TOPIC_NOACTION
			if(!CanInteract(user,state))
				return TOPIC_NOACTION
			I.injection_rate = clamp(new_injection_rate, 1, 100) / 100
		return TOPIC_REFRESH

/obj/machinery/computer/fusion/fuel_control/build_ui_data()
	. = ..()
	var/datum/extension/local_network_member/fusion = get_extension(src, /datum/extension/local_network_member)
	var/datum/local_network/lan = fusion.get_local_network()
	var/list/injectors = list()
	if(lan)
		var/list/fuel_injectors = lan.get_devices(/obj/machinery/fusion_fuel_injector)
		for(var/i = 1 to LAZYLEN(fuel_injectors))
			var/list/injector = list()
			var/obj/machinery/fusion_fuel_injector/I = fuel_injectors[i]
			injector["id"] =       "#[i]"
			injector["ref"] =       "\ref[I]"
			injector["injecting"] =  I.injecting
			injector["fueltype"] =  "[I.cur_assembly ? I.cur_assembly.fuel_type : "No Fuel Inserted"]"
			injector["depletion"] = "[I.cur_assembly ? (I.cur_assembly.percent_depleted * 100) : 100]%"
			injector["injection_rate"] = "[I.injection_rate * 100]%"
			injectors += list(injector)
	.["injectors"] = injectors
