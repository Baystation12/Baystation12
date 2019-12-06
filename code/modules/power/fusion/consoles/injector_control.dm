/obj/machinery/computer/fusion/fuel_control
	name = "fuel injection control computer"
	icon_keyboard = "rd_key"
	icon_screen = "fuel_screen"
	ui_template = "fusion_injector_control.tmpl"

/obj/machinery/computer/fusion/fuel_control/OnTopic(var/mob/user, var/href_list, var/datum/topic_state/state)
	if(href_list["toggle_injecting"])
		var/obj/machinery/fusion_fuel_injector/I = locate(href_list["toggle_injecting"])
		if(!istype(I))
			return TOPIC_NOACTION
		var/datum/local_network/lan = get_local_network()
		var/list/fuel_injectors = lan.get_devices(/obj/machinery/fusion_fuel_injector)
		if(!lan || !fuel_injectors || !fuel_injectors[I])
			return TOPIC_NOACTION
		if(I.injecting)
			I.StopInjecting()
		else
			I.BeginInjecting()
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
			injector["fueltype"] =  "[I.cur_assembly ? I.cur_assembly.fuel_type : "no fuel inserted"]"
			injector["depletion"] = "[I.cur_assembly ? (I.cur_assembly.percent_depleted * 100) : 100]%"
			injectors += list(injector)
	.["injectors"] = injectors
