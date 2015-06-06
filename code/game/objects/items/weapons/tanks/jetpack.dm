//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/weapon/tank/jetpack
	name = "jetpack (empty)"
	desc = "A tank of compressed gas for use as propulsion in zero-gravity areas. Use with caution."
	icon_state = "jetpack"
	w_class = 4.0
	item_state = "jetpack"
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD
	var/datum/effect/effect/system/ion_trail_follow/ion_trail
	var/on = 0.0
	var/stabilization_on = 0
	var/volume_rate = 500              //Needed for borg jetpack transfer
	action_button_name = "Toggle Jetpack"

/obj/item/weapon/tank/jetpack/New()
	..()
	src.ion_trail = new /datum/effect/effect/system/ion_trail_follow()
	src.ion_trail.set_up(src)

/obj/item/weapon/tank/jetpack/examine(mob/user)
	if(!..(user, 0))
		return

	if(air_contents.gas["oxygen"] < 10)
		user << text("<span class='danger'>The meter on \the [src] indicates you are almost out of air!</span>")
		playsound(user, 'sound/effects/alert.ogg', 50, 1)

/obj/item/weapon/tank/jetpack/verb/toggle_rockets()
	set name = "Toggle Jetpack Stabilization"
	set category = "Object"
	src.stabilization_on = !( src.stabilization_on )
	usr << "You toggle the stabilization [stabilization_on? "on":"off"]."

/obj/item/weapon/tank/jetpack/verb/toggle()
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

	usr << "You toggle the thrusters [on? "on":"off"]."

/obj/item/weapon/tank/jetpack/proc/allow_thrust(num, mob/living/user as mob)
	if(!(src.on))
		return 0
	if((num < 0.005 || src.air_contents.total_moles < num))
		src.ion_trail.stop()
		return 0

	var/datum/gas_mixture/G = src.air_contents.remove(num)

	var/allgases = G.gas["carbon_dioxide"] + G.gas["nitrogen"] + G.gas["oxygen"] + G.gas["phoron"]
	if(allgases >= 0.005)
		return 1

	qdel(G)
	return

/obj/item/weapon/tank/jetpack/ui_action_click()
	toggle()


/obj/item/weapon/tank/jetpack/void
	name = "void jetpack (oxygen)"
	desc = "It works well in a void."
	icon_state = "jetpack-void"
	item_state =  "jetpack-void"

/obj/item/weapon/tank/jetpack/void/New()
	..()
	air_contents.adjust_gas("oxygen", (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))
	return

/obj/item/weapon/tank/jetpack/oxygen
	name = "jetpack (oxygen)"
	desc = "A tank of compressed oxygen for use as propulsion in zero-gravity areas. Use with caution."
	icon_state = "jetpack"
	item_state = "jetpack"

/obj/item/weapon/tank/jetpack/oxygen/New()
	..()
	air_contents.adjust_gas("oxygen", (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))
	return

/obj/item/weapon/tank/jetpack/carbondioxide
	name = "jetpack (carbon dioxide)"
	desc = "A tank of compressed carbon dioxide for use as propulsion in zero-gravity areas. Painted black to indicate that it should not be used as a source for internals."
	distribute_pressure = 0
	icon_state = "jetpack-black"
	item_state =  "jetpack-black"

/obj/item/weapon/tank/jetpack/carbondioxide/New()
	..()
	src.ion_trail = new /datum/effect/effect/system/ion_trail_follow()
	src.ion_trail.set_up(src)
	//src.air_contents.carbon_dioxide = (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C)
	air_contents.adjust_gas("carbon_dioxide", (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))
	return

/obj/item/weapon/tank/jetpack/carbondioxide/examine(mob/user)
	if(!..(0))
		return

	if(air_contents.gas["carbon_dioxide"] < 10)
		user << text("<span class='danger'>The meter on \the [src] indicates you are almost out of carbon dioxide!</span>")
		playsound(user, 'sound/effects/alert.ogg', 50, 1)
	return

/obj/item/weapon/tank/jetpack/rig
	name = "jetpack"
	var/obj/item/weapon/rig/holder

/obj/item/weapon/tank/jetpack/rig/examine()
	usr << "It's a jetpack. If you can see this, report it on the bug tracker."
	return 0

/obj/item/weapon/tank/jetpack/rig/allow_thrust(num, mob/living/user as mob)

	if(!(src.on))
		return 0

	if(!istype(holder) || !holder.air_supply)
		return 0

	var/obj/item/weapon/tank/pressure_vessel = holder.air_supply

	if((num < 0.005 || pressure_vessel.air_contents.total_moles < num))
		src.ion_trail.stop()
		return 0

	var/datum/gas_mixture/G = pressure_vessel.air_contents.remove(num)

	var/allgases = G.gas["carbon_dioxide"] + G.gas["nitrogen"] + G.gas["oxygen"] + G.gas["phoron"]
	if(allgases >= 0.005)
		return 1
	qdel(G)
	return
