
/obj/machinery/overmap_comms/receiver
	name = "radio receiver dish"
	icon_state = "broadcast receiver"
	icon_state_active = "broadcast receiver"
	icon_state_inactive = "broadcast receiver_off"
	desc = "This machine has a dish-like shape and green lights. It is designed to detect and recieve radio signals."

/obj/machinery/overmap_comms/receiver/receive_signal(var/datum/signal/signal,var/recieve_method, recieve_param)


/obj/machinery/overmap_comms/receiver/proc/get_range_extension(var/datum/signal/signal)
	if(!active)
		return 0

	. = my_network.do_broadcast(signal)


/obj/machinery/overmap_comms/receiver/toggle_active()
	. = ..()

	var/turf/my_turf = get_turf(src)
	var/obj/effect/overmap/my_sector = map_sectors["[my_turf.z]"]
	if(active)
		my_sector.telecomms_receivers.Add(src)
	else
		my_sector.telecomms_receivers.Remove(src)
