//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/tank/jetpack
	name = "jetpack (empty)"
	desc = "A tank of compressed gas for use as propulsion in zero-gravity areas. Use with caution."
	icon_state = "jetpack"
	gauge_icon = null
	w_class = ITEM_SIZE_HUGE
	tank_size = TANK_SIZE_HUGE
	item_state = "jetpack"
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD
	var/datum/effect/effect/system/trail/ion/ion_trail
	var/on = 0.0
	var/stabilization_on = 0
	var/volume_rate = 500              //Needed for borg jetpack transfer
	action_button_name = "Toggle Jetpack"

/obj/item/tank/jetpack/Initialize()
	. = ..()
	ion_trail = new /datum/effect/effect/system/trail/ion()
	ion_trail.set_up(src)

/obj/item/tank/jetpack/Destroy()
	qdel(ion_trail)
	..()

/obj/item/tank/jetpack/examine(mob/living/user)
	. = ..()
	if(air_contents.total_moles < 5)
		to_chat(user, "<span class='danger'>The meter on \the [src] indicates you are almost out of gas!</span>")

/obj/item/tank/jetpack/verb/toggle_rockets()
	set name = "Toggle Jetpack Stabilization"
	set category = "Object"
	src.stabilization_on = !( src.stabilization_on )
	to_chat(usr, "You toggle the stabilization [stabilization_on? "on":"off"].")

/obj/item/tank/jetpack/verb/toggle()
	set name = "Toggle Jetpack"
	set category = "Object"

	on = !on
	if(on)
		icon_state = "[icon_state]-on"
		ion_trail.start()
	else
		icon_state = initial(icon_state)
		ion_trail.stop()

	if (ismob(usr))
		var/mob/M = usr
		M.update_inv_back()
		M.update_action_buttons()

	to_chat(usr, "You toggle the thrusters [on? "on":"off"].")

/obj/item/tank/jetpack/proc/allow_thrust(num, mob/living/user)
	if(!(src.on))
		return 0
	if((num < 0.005 || src.air_contents.total_moles < num))
		src.ion_trail.stop()
		return 0

	var/datum/gas_mixture/G = remove_air(num)

	if(G.total_moles >= 0.005)
		return 1

	qdel(G)

/obj/item/tank/jetpack/ui_action_click()
	toggle()


/obj/item/tank/jetpack/void
	name = "void jetpack (oxygen)"
	desc = "It works well in a void."
	icon_state = "jetpack-void"
	item_state =  "jetpack-void"
	starting_pressure = list(GAS_OXYGEN = 6*ONE_ATMOSPHERE)

/obj/item/tank/jetpack/oxygen
	name = "jetpack (oxygen)"
	desc = "A tank of compressed oxygen for use as propulsion in zero-gravity areas. Use with caution."
	icon_state = "jetpack"
	item_state = "jetpack"
	starting_pressure = list(GAS_OXYGEN = 6*ONE_ATMOSPHERE)

/obj/item/tank/jetpack/carbondioxide
	name = "jetpack (carbon dioxide)"
	desc = "A tank of compressed carbon dioxide for use as propulsion in zero-gravity areas. Painted black to indicate that it should not be used as a source for internals."
	distribute_pressure = 0
	icon_state = "jetpack-black"
	item_state =  "jetpack-black"
	starting_pressure = list(GAS_CO2 = 6*ONE_ATMOSPHERE)

/obj/item/tank/jetpack/rig
	name = "jetpack"
	var/obj/item/rig/holder

/obj/item/tank/jetpack/rig/examine()
	. = ..()
	CRASH("A [name] was examined")

/obj/item/tank/jetpack/rig/allow_thrust(num, mob/living/user as mob)

	if(!(src.on))
		return 0

	if(!istype(holder) || !holder.air_supply)
		return 0

	var/obj/item/tank/pressure_vessel = holder.air_supply

	if((num < 0.005 || pressure_vessel.air_contents.total_moles < num))
		src.ion_trail.stop()
		return 0

	var/datum/gas_mixture/G = pressure_vessel.remove_air(num)

	if(G.total_moles >= 0.005)
		return 1
	qdel(G)
