////////////////////HOLOSIGN///////////////////////////////////////
/obj/machinery/holosign
	name = "holosign"
	desc = "Small wall-mounted holographic projector."
	icon = 'icons/obj/holosign.dmi'
	icon_state = "sign_off"
	layer = ABOVE_OBJ_LAYER
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 70
	anchored = 1
	var/lit = 0
	var/id = null
	var/on_icon = "sign_on"
	var/_wifi_id
	var/datum/wifi/receiver/button/holosign/wifi_receiver

/obj/machinery/holosign/initialize()
	..()
	if(_wifi_id)
		wifi_receiver = new(_wifi_id, src)

/obj/machinery/holosign/Destroy()
	qdel(wifi_receiver)
	wifi_receiver = null
	return ..()

/obj/machinery/holosign/proc/toggle()
	if (stat & (BROKEN|NOPOWER))
		return
	lit = !lit
	use_power = lit ? 2 : 1
	update_icon()

//maybe add soft lighting? Maybe, though not everything needs it
/obj/machinery/holosign/update_icon()
	if (!lit || (stat & (BROKEN|NOPOWER)))
		icon_state = "sign_off"
	else
		icon_state = on_icon

/obj/machinery/holosign/surgery
	name = "surgery holosign"
	desc = "Small wall-mounted holographic projector. This one reads SURGERY."
	on_icon = "surgery"
////////////////////SWITCH///////////////////////////////////////

/obj/machinery/button/holosign
	name = "holosign switch"
	desc = "A remote control switch for holosign."
	icon = 'icons/obj/power.dmi'
	icon_state = "crema_switch"

/obj/machinery/button/holosign/attack_hand(mob/user as mob)
	if(..())
		return
	add_fingerprint(user)

	use_power(5)

	active = !active
	update_icon()

	for(var/obj/machinery/holosign/M in machines)
		if (M.id == src.id)
			spawn( 0 )
				M.toggle()
				return

	return

/obj/machinery/button/holosign/update_icon()
	icon_state = "light[active]"
	return