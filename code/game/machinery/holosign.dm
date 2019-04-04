////////////////////HOLOSIGN///////////////////////////////////////
/obj/machinery/holosign
	name = "holosign"
	desc = "Small wall-mounted holographic projector."
	icon = 'icons/obj/holosign.dmi'
	icon_state = "sign_off"
	layer = ABOVE_DOOR_LAYER
	idle_power_usage = 2
	active_power_usage = 70
	anchored = 1
	var/lit = 0
	var/id = null
	var/on_icon = "sign_on"
	var/_wifi_id
	var/datum/wifi/receiver/button/holosign/wifi_receiver

/obj/machinery/holosign/Initialize()
	. = ..()
	if(_wifi_id)
		wifi_receiver = new(_wifi_id, src)

/obj/machinery/holosign/Destroy()
	qdel(wifi_receiver)
	wifi_receiver = null
	return ..()

/obj/machinery/holosign/proc/toggle()
	if (inoperable())
		return
	lit = !lit
	update_use_power(lit ? POWER_USE_ACTIVE : POWER_USE_IDLE)
	update_icon()

/obj/machinery/holosign/on_update_icon()
	if (!lit || inoperable())
		icon_state = "sign_off"
		set_light(0)
	else
		icon_state = on_icon
		set_light(0.5, 0.5, 1, l_color = COLOR_CYAN_BLUE)

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

	active = !active
	use_power_oneoff(5)
	update_icon()

	for(var/obj/machinery/holosign/M in SSmachines.machinery)
		if (M.id == src.id)
			M.toggle()

/obj/machinery/button/holosign/on_update_icon()
	icon_state = "light[active]"