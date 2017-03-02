/obj/machinery/button/toggle/aoverride
	name = "airlock override"
	icon = 'maps/dreyfus/icons/override.dmi'
	icon_state = "intact"
	var/covered = 1
	var/toggled = 0

/obj/machinery/button/toggle/aoverride/update_icon()
	if(covered)
		icon_state = "intact"
	if(toggled)
		icon_state = "on"
	else
		icon_state = "off"

/obj/machinery/button/toggle/aoverride/initialize()
	if(_wifi_id)
		wifi_sender = new/datum/wifi/sender/door(_wifi_id, src)
	..()

/obj/machinery/button/toggle/aoverride/attackby(var/obj/item/C, var/mob/user)
	if(istype(C, /obj/item/weapon/weldingtool/))
		if(!C.isOn())
			return
		if(!C.remove_fuel(0,user))
			to_chat(user, "<span class='notice'>You need more welding fuel to complete this task.</span>")
			return
		else
			covered = 0
			playsound(src, 'sound/items/Welder.ogg', 100, 1)
			src.update_icon()
			to_chat(user, "You cut the cover.")
			return
	else
		return

/obj/machinery/button/toggle/aoverride/activate(mob/living/user)
	if(covered || toggled)
		return

	if(operating || !istype(wifi_sender))
		return

	toggled = 1
	operating = 1
	active = !active
	update_icon()
	to_chat(user, "You activate the airlock's manual override.")
	if(active)
		wifi_sender.activate("unelectrify")
		wifi_sender.activate("unlock")
	operating = 0