/obj/machinery/air_sensor
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "gsensor1"
	name = "Gas Sensor"

	anchored = 1
	var/state = 0
	var/frequency = 1441

	var/datum/radio_frequency/radio_connection
	var/datum/gas_mixture/sample

	var/constructed_path = /obj/machinery/air_sensor

	use_power = POWER_USE_IDLE

/obj/machinery/air_sensor/on_update_icon()
	if(!powered())
		icon_state = "gsensor0"
	else
		icon_state = "gsensor[use_power]"

/obj/machinery/air_sensor/Process()
	if(powered() && use_power)
		var/datum/signal/signal = new
		signal.transmission_method = 1 //radio signal
		signal.data["tag"] = id_tag
		signal.data["timestamp"] = world.time
		signal.data["gas"] = list()

		var/datum/gas_mixture/air_sample = return_air()
		sample = air_sample
		
		signal.data["pressure"] = num2text(round(air_sample.return_pressure(),0.1),)
		
		signal.data["temperature"] = round(air_sample.temperature,0.1)

		var/total_moles = air_sample.total_moles

		if(total_moles > 0)
			for(var/gas in air_sample.gas)				
				var/gaspercent = round(air_sample.gas["[gas]"]*100/total_moles,0.01)
				var/gas_list = list("symbol" = gas_data.symbol_html["[gas]"], "percent" = gaspercent)
				signal.data["gas"] += list(gas_list)

		signal.data["sigtype"] = "status"
		radio_connection.post_signal(src, signal, radio_filter = RADIO_ATMOSIA)

/obj/machinery/air_sensor/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = radio_controller.add_object(src, frequency, RADIO_ATMOSIA)

/obj/machinery/air_sensor/Initialize()
	set_frequency(frequency)	
	. = ..()

obj/machinery/air_sensor/Destroy()
	if(radio_controller)
		radio_controller.remove_object(src,frequency)
	. = ..()

/obj/machinery/air_sensor/proc/get_console_data()
	. = list()
	. += "<table>"
	. += "<tr><td><b>Name:</b></td><td>[name]</td>"
	. += "<tr><td><b>ID Tag:</b></td><td>[id_tag]</td><td><a href='?src=\ref[src];settag=\ref[id_tag]'>Set ID Tag</a></td></td></tr>"
	if(frequency%10)
		. += "<tr><td><b>Frequency:</b></td><td>[frequency/10]</td><td><a href='?src=\ref[src];setfreq=\ref[frequency]'>Set Frequency</a></td></td></tr>"
	else
		. += "<tr><td><b>Frequency:</b></td><td>[frequency/10].0</td><td><a href='?src=\ref[src];setfreq=\ref[frequency]'>Set Frequency</a></td></td></tr>"
	.+= "</table>"
	. = JOINTEXT(.)

/obj/machinery/air_sensor/OnTopic(mob/user, href_list, datum/topic_state/state)
	if((. = ..()))
		return
	if(href_list["settag"])	
		var/t = sanitizeSafe(input(user, "Enter the ID tag for [src.name]", src.name, id_tag), MAX_NAME_LEN)
		if(t && CanInteract(user, state))
			id_tag = t
			return TOPIC_REFRESH
		return TOPIC_HANDLED
	if(href_list["setfreq"])
		var/freq = input(user, "Enter the Frequency for [src.name]. Decimal will automatically be inserted", src.name, frequency) as num|null
		if(CanInteract(user, state))
			set_frequency(freq)
			return TOPIC_REFRESH
		return TOPIC_HANDLED

/obj/machinery/air_sensor/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(isMultitool(O))
		var/datum/browser/popup = new (user, "Vent Configuration Utility", "[src] Configuration Panel", 600, 200)
		popup.set_content(jointext(get_console_data(),"<br>"))
		popup.open()
		return
	else if(isWrench(O))
		var/obj/item/air_sensor/sensor = new /obj/item/air_sensor(src.loc)
		sensor.frequency = frequency
		sensor.id_tag = id_tag
		qdel(src)
	else if(isScrewdriver(O))
		var/F = input("What frequency would you like to set this to?", "Adjust Frequency", frequency) as num|null
		if(CanPhysicallyInteract(user))
			return
		if(user.get_active_hand() != O)
			return
		if(F)
			frequency = F
			set_frequency(F)
			to_chat(user, "<span class='notice'>The frequency of the sensor is now [frequency]</span>")