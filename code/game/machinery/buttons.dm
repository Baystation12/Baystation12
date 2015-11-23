/obj/machinery/button
	name = "button"
	icon = 'icons/obj/objects.dmi'
	icon_state = "launcherbtt"
	desc = "A remote control switch for something."
	var/id = null
	var/active = 0
	var/operating = 0
	anchored = 1.0
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 4
	var/_wifi_id
	var/_wifi_toggle = 0		//set this to 1 if you want the button to have both an on and off state, not just fire a single command
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
	return attack_hand(user)

/obj/machinery/button/attackby(obj/item/weapon/W, mob/user as mob)
	return attack_hand(user)

/obj/machinery/button/attack_hand(mob/living/user)
	..()
	activate(user)

/obj/machinery/button/proc/activate(mob/living/user)
	if(operating || !istype(wifi_sender))
		return

	operating = 1
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
	operating = 0

/obj/machinery/button/update_icon()
	if(active)
		icon_state = "launcheract"
	else
		icon_state = "launcherbtt"

//alternate button with the same functionality, except has a lightswitch sprite instead
/obj/machinery/button/alternate
	icon = 'icons/obj/power.dmi'
	icon_state = "light0"

/obj/machinery/button/alternate/update_icon()
	icon_state = "light[active]"

//-------------------------------
// Mass Driver Button
//  Passes the activate call to a mass driver wifi sender
//-------------------------------
/obj/machinery/button/mass_driver
	var/datum/wifi/sender/mass_driver/sender

/obj/machinery/button/mass_driver/initialize()
	..()
	sender = new(_wifi_id, src)

/obj/machinery/button/mass_driver/activate(mob/living/user)
	if(active || !istype(wifi_sender))
		return
	use_power(5)
	active = 1
	update_icon()
	sender.cycle()
	active = 0
	update_icon()

//-------------------------------
// Door Button
//-------------------------------
/obj/machinery/button/door
	var/datum/wifi/sender/door/sender

/obj/machinery/button/door/initialize()
	..()
	sender = new(_wifi_id, src)

/obj/machinery/button/door/activate(mob/living/user)
	if(operating || !istype(sender))
		return

	operating = 1
	use_power(5)
	active = !active
	update_icon()
	if(!active)
		sender.open()
	else
		sender.close()
	operating = 0
