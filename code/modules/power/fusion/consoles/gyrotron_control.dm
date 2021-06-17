/obj/machinery/computer/fusion/gyrotron
	name = "gyrotron control console"
	icon_keyboard = "med_key"
	icon_screen = "gyrotron_screen"
	light_color = COLOR_BLUE
	ui_template = "fusion_gyrotron_control.tmpl"

/obj/machinery/computer/fusion/gyrotron/OnTopic(var/mob/user, var/href_list, var/datum/topic_state/state)

	if(href_list["modifypower"] || href_list["modifyrate"] || href_list["toggle"])

		var/obj/machinery/power/emitter/gyrotron/G = locate(href_list["machine"])
		if(!istype(G))
			return TOPIC_NOACTION

		var/datum/local_network/lan = get_local_network()
		var/list/gyrotrons = lan.get_devices(/obj/machinery/power/emitter/gyrotron)
		if(!lan || !gyrotrons || !gyrotrons[G])
			return TOPIC_NOACTION

		if(href_list["modifypower"])
			var/new_val = input("Enter new emission power level (1 - 50)", "Modifying power level", G.mega_energy) as num
			if(!istype(G))
				return TOPIC_NOACTION
			if(!new_val)
				to_chat(user, SPAN_WARNING("That's not a valid number."))
				return TOPIC_NOACTION
			G.mega_energy = Clamp(new_val, 1, 50)
			G.change_power_consumption(G.mega_energy * 1500, POWER_USE_ACTIVE)
			return TOPIC_REFRESH

		if(href_list["modifyrate"])
			var/new_val = input("Enter new emission delay between 2 and 10 seconds.", "Modifying emission rate", G.rate) as num
			if(!istype(G))
				return TOPIC_NOACTION
			if(!new_val)
				to_chat(user, SPAN_WARNING("That's not a valid number."))
				return TOPIC_NOACTION
			G.rate = Clamp(new_val, 2, 10)
			return TOPIC_REFRESH

		if(href_list["toggle"])
			G.activate(user)
			return TOPIC_REFRESH

/obj/machinery/computer/fusion/gyrotron/build_ui_data()
	. = ..()
	var/datum/extension/local_network_member/fusion = get_extension(src, /datum/extension/local_network_member)
	var/datum/local_network/lan = fusion.get_local_network()
	var/list/gyrotrons = list()
	if(lan && gyrotrons)
		var/list/lan_gyrotrons = lan.get_devices(/obj/machinery/power/emitter/gyrotron)
		for(var/i = 1 to LAZYLEN(lan_gyrotrons))
			var/list/gyrotron = list()
			var/obj/machinery/power/emitter/gyrotron/G = lan_gyrotrons[i]
			gyrotron["id"] =        "#[i]"
			gyrotron["ref"] =       "\ref[G]" 
			gyrotron["active"] =    G.active
			gyrotron["firedelay"] = G.rate
			gyrotron["energy"] = G.mega_energy
			gyrotrons += list(gyrotron)
	.["gyrotrons"] = gyrotrons

