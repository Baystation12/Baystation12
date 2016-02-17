/obj/item/device/assembly/explosive/emexplosive
	name = "emp device"
	desc = "An explosive device that sends out an electromagnetic pulse to distrupt nearby electronic devices"
	icon_state = "empdevice"
	used = 0
//	holder_attackby = list(/obj/item/weapon/screwdriver)
	wires = WIRE_DIRECT_RECEIVE | WIRE_PROCESS_RECEIVE | WIRE_PROCESS_ACTIVATE | WIRE_POWER_RECEIVE
	wire_num = 4
	dangerous = 1

	var/power_cost = 750
	var/delay = 0

/obj/item/device/assembly/explosive/emexplosive/activate()
	spawn(delay*10)
		if(WIRE_PROCESS_ACTIVATE || prob(40))
			boom()

/obj/item/device/assembly/explosive/emexplosive/igniter_act()
	return

/obj/item/device/assembly/explosive/emexplosive/get_data()
	return list("Warmup Period", delay)

/obj/item/device/assembly/explosive/emexplosive/Topic(href, href_list)
	if(href_list["option"] == "Warmup Period")
		var/inp = text2num(input(usr, "What would you like to set the warmup period to?", "EMP"))
		if(inp)
			delay = inp
			power = 1 + (delay * 0.0167)
		else
			delay = 0
			power = 1


/obj/item/device/assembly/explosive/emexplosive/attackby(var/obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/weapon/screwdriver))
		if(used)
			user << "\blue You reset \the [src]"
			used = 0
/obj/item/device/assembly/explosive/emexplosive/process_activation()
	if(!draw_power(power_cost)) return 0
	..()

/obj/item/device/assembly/explosive/emexplosive/boom()
	if(empulse(src, 4*power, 10*power))
		used = 1
		power_cost *= 1.75


