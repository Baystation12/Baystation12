
//cooling machine

/obj/machinery/atmospherics/binary/fusion_cooling
	name = "coolant manifold"
	desc = "A cooling device for starship fusion reactors."
	icon = 'fusion_drive.dmi'
	icon_state = "cooling_manifold"

	density = 1
	idle_power_usage = 150
	use_power = 0
	var/max_power_draw = 1000

	var/obj/machinery/power/fusion_drive/target_reactor

	var/cooling_efficiency = 0.1		//arbitrary number for balancing coolant effectiveness

/obj/machinery/atmospherics/binary/fusion_cooling/Initialize()
	..()

	target_reactor = locate() in get_step(src, turn(src.dir, -90))
	if(target_reactor)
		anchored = 1
		if(node1)
			node1.Initialize()
			node1.build_network()
		if(node2)
			node2.Initialize()
			node2.build_network()

		use_power = 1
		update_icon()

/obj/machinery/atmospherics/binary/fusion_cooling/attackby(var/obj/item/I, var/mob/living/user)
	if (istype(I,/obj/item/weapon/wrench))
		anchored = !anchored

		if(anchored)
			user.visible_message("[user] wrenches [src] to the floor.", \
				"You wrench [src] to the floor.")

			//setup atmos stuff
			Initialize()
		else
			user.visible_message("[user] unwrenches [src] from the floor.", \
				"You unwrench [src] from the floor.")

			//reset atmos stuff
			if(node1)
				node1.disconnect(src)
				qdel(network1)
			if(node2)
				node2.disconnect(src)
				qdel(network2)

			target_reactor = null
			use_power = 0
			update_icon()

		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)

/obj/machinery/atmospherics/binary/fusion_cooling/process()
	last_power_draw = 0
	last_flow_rate = 0

	if((stat & (NOPOWER|BROKEN)) || !use_power)
		return

	//handle cooling for the reactor core
	//most of this copied from /proc/pump_gas() in _atmospherics_helpers.dm
	last_flow_rate = 0
	last_power_draw = 0

	var/transfer_moles = air1.total_moles
	if(transfer_moles < MINIMUM_MOLES_TO_PUMP)
		return

	var/specific_power = calculate_specific_power(air1, air2) / ATMOS_PUMP_EFFICIENCY
	if(specific_power > 0)
		transfer_moles = min(transfer_moles, max_power_draw / specific_power)
	if(transfer_moles < MINIMUM_MOLES_TO_PUMP)
		return

	last_flow_rate = (transfer_moles / air1.total_moles) * air1.volume
	last_power_draw = specific_power * transfer_moles

	use_power(last_power_draw)

	var/datum/gas_mixture/coolant_flow = air1.remove(transfer_moles)
	if (!coolant_flow)
		return

	//cool the reactor down with our coolant flow
	if(target_reactor)
		//basic cooling gas = helium
		//helium amount = 1871 moles
		//helium specific heat = 100
		//in tests with a basic pipe network supplying a gas as coolant, approx 200 moles from the 1 full canister went through every 2nd tick
		//this means a heat capacity of 20,000 (per tick, lets assume)
		//:. let a coolant heat capacity of 20000 at temperature TCMB remove 200000 thermal energy
		//:. cooling_efficiency = 10

		//work out how much energy to transfer
		var/energy_transfer = coolant_flow.heat_capacity() * cooling_efficiency

		//if the coolant has heated up, dont transfer so much energy, or even heat up the reactor if the coolant is hotter than the reactor
		var/reactor_temp = target_reactor.heat_energy / target_reactor.internal_heat_capacity
		if(reactor_temp > TCMB)
			energy_transfer -= energy_transfer * (coolant_flow.temperature - TCMB) / reactor_temp

		energy_transfer = min(target_reactor.heat_energy - TCMB, energy_transfer)	//in case the reactor cant transfer that much energy
		energy_transfer = coolant_flow.add_thermal_energy(energy_transfer)				//in case the coolant cant transfer that much energy
		target_reactor.heat_energy -= energy_transfer

		target_reactor.cooled_last_cycle = energy_transfer

		if(debug)
			to_world("coolant flow modified reactor heat by [energy_transfer]")
			to_world("	[transfer_moles] moles flowing through")
			to_world("	coolant heat capacity of [coolant_flow.heat_capacity()]")
			to_world("	new reactor heat of [target_reactor.heat_energy]")

	air2.merge(coolant_flow)

	if(network1)
		network1.update = 1

	if(network2)
		network2.update = 1

/obj/machinery/atmospherics/binary/fusion_cooling/update_icon()
	overlays = list()
	if(anchored)
		overlays += "cooling_anchored"

/*
starting canister moles = (target_pressure * air_contents.volume) / (R_IDEAL_GAS_EQUATION * air_contents.temperature)
:. starting canister moles = (45 * 101.325 * 1000) / (8.31 * 293.15)
= 4559625 / 2436.0765
= 1871.7084623574013377658706530768

#define ONE_ATMOSPHERE 101.325
target_pressure = 45 * ONE_ATMOSPHERE
air_contents.volume = 1000
air_contents.volume = 45 * ONE_ATMOSPHERE
#define T20C 293.15
air_contents.temperature = T20C
#define R_IDEAL_GAS_EQUATION 8.31

//lets create a new gas type for coolant called... helium with a specific heat of 100
//this will be the baseline for all balancing

#define CELL_VOLUME 2500
#define MOLES_CELLSTANDARD (ONE_ATMOSPHERE*CELL_VOLUME/(T20C*R_IDEAL_GAS_EQUATION))
= (101.325 * 2500) / (293.15 * 8.31)
= 253312.5 / 2436.0765
= 103.98380346430007432032614739315

one standard breathable tile's atmosphere has 2060 heat capacity

*/

/obj/machinery/atmospherics/binary/fusion_cooling/verb/rotate_manifold()
	set name = "Rotate Exhaust Manifold (CW)"
	set category = "Object"
	set src in view(1)

	if(anchored)
		to_chat(usr,"<span class='notice'>You cannot rotate [src] as it is bolted down.</span>")
		return

	dir = turn(dir, 90)
