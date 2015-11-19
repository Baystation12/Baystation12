/obj/machinery/button
	name = "button"
	icon = 'icons/obj/objects.dmi'
	icon_state = "launcherbtt"
	desc = "A remote control switch for something."
	var/id = null
	var/active = 0
	anchored = 1.0
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 4
	var/_wifi_id
	var/_wifi_toggle = 0
	var/datum/wifi/sender/button/wifi_sender

/obj/machinery/button/initialize()
	..()
	update_icon()
	if(_wifi_id)
		wifi_sender = new(_wifi_id, src)

/obj/machinery/button/Destroy()
	qdel(wifi_sender)
	wifi_sender = null
	return..()

/obj/machinery/button/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/button/attackby(obj/item/weapon/W, mob/user as mob)	return src.attack_hand(user)

/obj/machinery/button/attack_hand(mob/living/user)
	..()

	if(!wifi_sender)
		return

	use_power(5)

	if(_wifi_toggle)
		active = !active
		if(active)
			wifi_sender.activate(user)
		else
			wifi_sender.deactivate(user)
		update_icon()
	else
		active = 1
		update_icon()
		wifi_sender.activate(user)
		sleep(10)
		active = 0
		update_icon()

/obj/machinery/button/update_icon()
	if(active)
		icon_state = "launcheract"
	else
		icon_state = "launcherbtt"

/obj/machinery/button/toggle
	icon = 'icons/obj/power.dmi'
	icon_state = "light0"
	_wifi_toggle = 1

/obj/machinery/button/toggle/update_icon()
	icon_state = "light[active]"
