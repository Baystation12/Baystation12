
/obj/machinery/overmap_comms/broadcaster
	name = "radio broadcast dish"
	icon_state = "broadcaster"
	icon_state_active = "broadcaster"
	icon_state_inactive = "broadcaster_off"
	desc = "A dish-shaped machine used to broadcast radio signals over long range."

/obj/machinery/overmap_comms/broadcaster/proc/broadcast_signal()
	flick("broadcaster_send", src)
