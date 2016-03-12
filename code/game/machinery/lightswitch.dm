// the light switch
// can have multiple per area
// can also operate on non-loc area through "otherarea" var
/obj/machinery/light_switch
	name = "light switch"
	desc = "It turns lights on and off. What are you, simple?"
	icon = 'icons/obj/power.dmi'
	icon_state = "light1"
	anchored = 1.0
	use_power = 1
	idle_power_usage = 20
	power_channel = LIGHT
	var/on = 1
	var/area/area = null
	var/otherarea = null

/obj/machinery/light_switch/New()
	..()
	spawn(5)
		src.area = get_area(src)

		if(otherarea)
			src.area = locate(text2path("/area/[otherarea]"))

		if(!name)
			name = "light switch ([area.name])"

		src.on = src.area.lightswitch
		updateicon()



/obj/machinery/light_switch/proc/updateicon()
	if(stat & NOPOWER)
		icon_state = "light-p"
		set_light(0)
		layer = OBJ_LAYER
	else
		icon_state = "light[on]"
		set_light(2, 1.5, on ? "#82FF4C" : "#F86060")
		layer = LIGHTING_LAYER+0.1

/obj/machinery/light_switch/examine(mob/user)
	if(..(user, 1))
		user << "A light switch. It is [on? "on" : "off"]."

/obj/machinery/light_switch/attack_hand(mob/user)

	on = !on

	area.lightswitch = on
	area.updateicon()

	for(var/obj/machinery/light_switch/L in area)
		L.on = on
		L.updateicon()

	area.power_change()

/obj/machinery/light_switch/power_change()

	if(!otherarea)
		if(powered(LIGHT))
			stat &= ~NOPOWER
		else
			stat |= NOPOWER

		updateicon()

/obj/machinery/light_switch/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return
	power_change()
	..(severity)
