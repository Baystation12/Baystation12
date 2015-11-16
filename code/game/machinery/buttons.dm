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
	var/datum/wifi/sender/button/wifi_sender

/obj/machinery/button/New()
	..()
	if(_wifi_id)
		wifi_sender = new(_wifi_id)

/obj/machinery/button/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/button/attackby(obj/item/weapon/W, mob/user as mob)	return src.attack_hand(user)

/obj/machinery/button/attack_hand(mob/living/user)
	..()
	if(wifi_sender)
		wifi_sender.activate(user)
