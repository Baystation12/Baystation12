////////////////////HOLOSIGN///////////////////////////////////////
/obj/machinery/holosign
	name = "holosign"
	desc = "Small wall-mounted holographic projector"
	icon = 'icons/obj/holosign.dmi'
	icon_state = "sign_off"
	layer = 4
	idle_power_usage = 2
	var/lit = 0
	var/id = null
	var/on_icon = "sign_on"

/obj/machinery/holosign/proc/toggle()
	if (stat & (BROKEN|NOPOWER))
		return
	lit = !lit
	update_icon()

/obj/machinery/holosign/process()
	if(lit)
		auto_use_power()

/obj/machinery/holosign/update_icon()
	if (!lit)
		icon_state = "sign_off"
	else
		icon_state = on_icon

/obj/machinery/holosign/power_change()
	if (stat & NOPOWER)
		lit = 0
	update_icon()

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
	icon_state = "light[active]"

	for(var/obj/machinery/holosign/M in machines)
		if (M.id == src.id)
			spawn( 0 )
				M.toggle()
				return

	return