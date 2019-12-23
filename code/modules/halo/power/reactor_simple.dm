#define FUEL_UNIT_POWER_PRODUCE 1.5 KILOWATTS

//A simple fusion drive that just eats fuel quickly and requires periodic refuelling//
/obj/machinery/power/fusion_drive_simple
	name = "Mark II Hanley-Messer Fusion Drive"
	desc = "A fusion reactor for powering starships."
	icon = 'code/modules/halo/power/fusion_drive.dmi'
	icon_state = "reactor0"
	var/obj/item/fusion_fuel/held_fuel
	var/fuel_consumption_rate = 12
	var/next_fuel_tick = 0

/obj/machinery/power/fusion_drive/Initialize()
	..()
	. = INITIALIZE_HINT_NORMAL
	update_icon()
	connect_to_network()

/obj/machinery/power/fusion_drive_simple/ex_act()
	eject_fuel()
	return

/obj/machinery/power/fusion_drive_simple/process()
	if(held_fuel && held_fuel.fuel_left > 0)
		held_fuel.fuel_left = max(held_fuel.fuel_left - fuel_consumption_rate, 0)

		add_avail(fuel_consumption_rate * FUEL_UNIT_POWER_PRODUCE)

/obj/machinery/power/fusion_drive_simple/proc/eject_fuel()
	if(held_fuel)
		visible_message("\icon[src] [src] ejects it's fuel packet.")
		held_fuel.loc = src.loc
		held_fuel = null
		icon_state = "reactor0"
		update_icon()

/obj/machinery/power/fusion_drive_simple/attackby(var/obj/item/I, var/mob/living/user)
	if(istype(I, /obj/item/fusion_fuel))
		if(held_fuel)
			to_chat(user,"<span class='warning'>There is already a fuel packet in there.</span>")
		else
			user.drop_item()
			I.loc = src
			held_fuel = I
			icon_state = "reactor1"
			update_icon()
			if(isnull(powernet))
				connect_to_network()

/obj/machinery/power/fusion_drive_simple/update_icon()
	overlays.Cut()
	var/fuelval = 0
	if(held_fuel)
		fuelval = min(round(8 * held_fuel.fuel_left / held_fuel.max_fuel), 8)
	var/image/fuel_overlay = new('fusion_drive.dmi', "fuel[fuelval]")
	overlays += fuel_overlay

/obj/machinery/power/fusion_drive_simple/verb/verb_eject_fuel()
	set name = "Eject Fuel Packet"
	set category = "Object"
	set src in range(1)
	if(!istype(usr,/mob/living))
		return
	eject_fuel()

/obj/machinery/power/fusion_drive_simple/Destroy()
	disconnect_from_network()
	. = ..()