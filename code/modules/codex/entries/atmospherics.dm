/datum/codex_entry/atmos_pipe
	associated_paths = list(/obj/machinery/atmospherics/pipe)
	mechanics_text = "This pipe, and all other pipes, can be connected or disconnected by a wrench.  The internal pressure of the pipe must \
	be below 300 kPa to do this.  More pipes can be obtained from the pipe dispenser."

//HE pipes
/datum/codex_entry/atmos_he
	associated_paths = list(/obj/machinery/atmospherics/pipe/simple/heat_exchanging)
	mechanics_text = "This radiates heat from the pipe's gas to space, cooling it down."

//Supply/Scrubber pipes
/datum/codex_entry/atmos_visible_scrub
	associated_paths = list(/obj/machinery/atmospherics/pipe/simple/visible/scrubbers)
	mechanics_text = "This is a special 'scrubber' pipe, which does not connect to 'normal' pipes.  If you want to connect it, use \
	a Universal Adapter pipe."

/datum/codex_entry/atmos_visible_supply
	associated_paths = list(/obj/machinery/atmospherics/pipe/simple/visible/supply)
	mechanics_text = "This is a special 'supply' pipe, which does not connect to 'normal' pipes.  If you want to connect it, use \
	a Universal Adapter pipe."

/datum/codex_entry/atmos_hidden_supply
	associated_paths = list(/obj/machinery/atmospherics/pipe/simple/hidden/supply)
	mechanics_text = "This is a special 'supply' pipe, which does not connect to 'normal' pipes.  If you want to connect it, use \
	a Universal Adapter pipe."

/datum/codex_entry/atmos_hidden_scrub
	associated_paths = list(/obj/machinery/atmospherics/pipe/simple/hidden/scrubbers)
	mechanics_text = "This is a special 'scrubber' pipe, which does not connect to 'normal' pipes.  If you want to connect it, use \
	a Universal Adapter pipe."

//Universal adapters
/datum/codex_entry/atmos_visible_universal
	associated_paths = list(/obj/machinery/atmospherics/pipe/simple/visible/universal)
	mechanics_text = "This allows you to connect 'normal' pipes, red 'scrubber' pipes, and blue 'supply' pipes."

/datum/codex_entry/atmos_hidden_universal
	associated_paths = list(/obj/machinery/atmospherics/pipe/simple/hidden/universal)
	mechanics_text = "This allows you to connect 'normal' pipes, red 'scrubber' pipes, and blue 'supply' pipes."

//Three way manifolds
/datum/codex_entry/atmos_manifold
	associated_paths = list(/obj/machinery/atmospherics/pipe/manifold)
	mechanics_text = "A normal pipe with three ends to connect to."

/datum/codex_entry/atmos_manifold_visible_scrub
	associated_paths = list(/obj/machinery/atmospherics/pipe/manifold/visible/scrubbers)
	mechanics_text = "This is a special 'scrubber' pipe, which does not connect to 'normal' pipes.  If you want to connect it, use \
	a Universal Adapter pipe."

/datum/codex_entry/atmos_manifold_visible_supply
	associated_paths = list(/obj/machinery/atmospherics/pipe/manifold/visible/supply)
	mechanics_text = "This is a special 'supply' pipe, which does not connect to 'normal' pipes.  If you want to connect it, use \
	a Universal Adapter pipe."

/datum/codex_entry/atmos_manifold_hidden_scrub
	associated_paths = list(/obj/machinery/atmospherics/pipe/manifold/hidden/scrubbers)
	mechanics_text = "This is a special 'scrubber' pipe, which does not connect to 'normal' pipes.  If you want to connect it, use \
	a Universal Adapter pipe."

/datum/codex_entry/atmos_manifold_hidden_supply
	associated_paths = list(/obj/machinery/atmospherics/pipe/manifold/hidden/supply)
	mechanics_text = "This is a special 'supply' pipe, which does not connect to 'normal' pipes.  If you want to connect it, use \
	a Universal Adapter pipe."

//Four way manifolds
/datum/codex_entry/atmos_manifold_manifold_four
	associated_paths = list(/obj/machinery/atmospherics/pipe/manifold4w)
	mechanics_text = "This is a four-way pipe."

/datum/codex_entry/atmos_manifold_manifold_four_visible_scrub
	associated_paths = list(/obj/machinery/atmospherics/pipe/manifold4w/visible/scrubbers)
	mechanics_text = "This is a special 'scrubber' pipe, which does not connect to 'normal' pipes.  If you want to connect it, use \
	a Universal Adapter pipe."

/datum/codex_entry/atmos_manifold_manifold_four_visible_supply
	associated_paths = list(/obj/machinery/atmospherics/pipe/manifold4w/hidden/supply)
	mechanics_text = "This is a special 'supply' pipe, which does not connect to 'normal' pipes.  If you want to connect it, use \
	a Universal Adapter pipe."

/datum/codex_entry/atmos_manifold_manifold_four_hidden_scrub
	associated_paths = list(/obj/machinery/atmospherics/pipe/manifold4w/hidden/scrubbers)
	mechanics_text = "This is a special 'scrubber' pipe, which does not connect to 'normal' pipes.  If you want to connect it, use \
	a Universal Adapter pipe."

//Endcaps
/datum/codex_entry/atmos_cap
	associated_paths = list(/obj/machinery/atmospherics/pipe/cap)
	mechanics_text = "This is a cosmetic attachment, as pipes currently do not spill their contents into the air."

//T-shaped valves
/datum/codex_entry/atmos_tvalve
	associated_paths = list(/obj/machinery/atmospherics/tvalve)
	mechanics_text = "Click this to toggle the mode.  The direction with the green light is where the gas will flow."

//Normal valves
/datum/codex_entry/atmos_valve
	associated_paths = list(/obj/machinery/atmospherics/valve)
	mechanics_text = "Click this to turn the valve.  If red, the pipes on each end are seperated.  Otherwise, they are connected."

//TEG ports
/datum/codex_entry/atmos_circulator
	associated_paths = list(/obj/machinery/atmospherics/binary/circulator)
	mechanics_text = "This generates electricity, depending on the difference in temperature between each side of the machine.  The meter in \
	the center of the machine gives an indicator of how much elecrtricity is being generated."

//Passive gates
/datum/codex_entry/atmos_gate
	associated_paths = list(/obj/machinery/atmospherics/binary/passive_gate)
	mechanics_text = "This is a one-way regulator, allowing gas to flow only at a specific pressure and flow rate.  If the light is green, it is flowing."

//Normal pumps (high power one inherits from this)
/datum/codex_entry/atmos_pump
	associated_paths = list(/obj/machinery/atmospherics/binary/pump)
	mechanics_text = "This moves gas from one pipe to another.  A higher target pressure demands more energy.  The side with the red end is the output."

//Vents
/datum/codex_entry/atmos_vent_pump
	associated_paths = list(/obj/machinery/atmospherics/unary/vent_pump)
	mechanics_text = "This pumps the contents of the attached pipe out into the atmosphere, if needed.  It can be controlled from an Air Alarm."

//Freezers
/datum/codex_entry/atmos_freezer
	associated_paths = list(/obj/machinery/atmospherics/unary/freezer)
	mechanics_text = "Cools down the gas of the pipe it is connected to.  It uses massive amounts of electricity while on. \
	It can be upgraded by replacing the capacitors, manipulators, and matter bins.  It can be deconstructed by screwing the maintenance panel open with a \
	screwdriver, and then using a crowbar."

//Heaters
/datum/codex_entry/atmos_heater
	associated_paths = list(/obj/machinery/atmospherics/unary/heater)
	mechanics_text = "Heats up the gas of the pipe it is connected to.  It uses massive amounts of electricity while on. \
	It can be upgraded by replacing the capacitors, manipulators, and matter bins.  It can be deconstructed by screwing the maintenance panel open with a \
	screwdriver, and then using a crowbar."

//Gas injectors
/datum/codex_entry/atmos_injector
	associated_paths = list(/obj/machinery/atmospherics/unary/outlet_injector)
	mechanics_text = "Outputs the pipe's gas into the atmosphere, similar to an airvent.  It can be controlled by a nearby atmospherics computer. \
	A green light on it means it is on."

//Scrubbers
/datum/codex_entry/atmos_vent_scrubber
	associated_paths = list(/obj/machinery/atmospherics/unary/vent_scrubber)
	mechanics_text = "This filters the atmosphere of harmful gas.  Filtered gas goes to the pipes connected to it, typically a scrubber pipe. \
	It can be controlled from an Air Alarm.  It can be configured to drain all air rapidly with a 'panic syphon' from an air alarm."

//Omni filters
/datum/codex_entry/atmos_omni_filter
	associated_paths = list(/obj/machinery/atmospherics/omni/filter)
	mechanics_text = "Filters gas from a custom input direction, with up to two filtered outputs and a 'everything else' \
	output.  The filtered output's arrows glow orange."

//Omni mixers
/datum/codex_entry/atmos_omni_mixer
	associated_paths = list(/obj/machinery/atmospherics/omni/mixer)
	mechanics_text = "Combines gas from custom input and output directions.  The percentage of combined gas can be defined."

//Canisters
/datum/codex_entry/atmos_canister
	display_name = "gas canister" // because otherwise it shows up as 'canister: [caution]'
	associated_paths = list(/obj/machinery/portable_atmospherics/canister)
	mechanics_text = "The canister can be connected to a connector port with a wrench.  Tanks of gas (the kind you can hold in your hand) \
	can be filled by the canister, by using the tank on the canister, increasing the release pressure, then opening the valve until it is full, and then close it.  \
	*DO NOT* remove the tank until the valve is closed.  A gas analyzer can be used to check the contents of the canister."
	antag_text = "Canisters can be damaged, spilling their contents into the air, or you can just leave the release valve open."

//Portable pumps
/datum/codex_entry/atmos_power_pump
	associated_paths = list(/obj/machinery/portable_atmospherics/powered/pump)
	mechanics_text = "Invaluable for filling air in a room rapidly after a breach repair.  The internal gas container can be filled by \
	connecting it to a connector port.  The pump can pump the air in (sucking) or out (blowing), at a specific target pressure.  The powercell inside can be \
	replaced by using a screwdriver, and then adding a new cell.  A tank of gas can also be attached to the air pump."

//Portable scrubbers
/datum/codex_entry/atmos_power_scrubber
	associated_paths = list(/obj/machinery/portable_atmospherics/powered/scrubber)
	mechanics_text = "Filters the air, placing harmful gases into the internal gas container.  The container can be emptied by \
	connecting it to a connector port.  The pump can pump the air in (sucking) or out (blowing), at a specific target pressure.  The powercell inside can be \
	replaced by using a screwdriver, and then adding a new cell.  A tank of gas can also be attached to the scrubber. "

//Meters
/datum/codex_entry/atmos_meter
	associated_paths = list(/obj/machinery/meter)
	mechanics_text = "Measures the volume and temperature of the pipe under the meter."

//Pipe dispensers
/datum/codex_entry/atmos_pipe_dispenser
	associated_paths = list(/obj/machinery/pipedispenser)
	mechanics_text = "This can be moved by using a wrench.  You will need to wrench it again when you want to use it.  You can put \
	excess (atmospheric) pipes into the dispenser, as well.  The dispenser requires electricity to function."

/datum/codex_entry/transfer_valve
	associated_paths = list(/obj/item/device/transfer_valve)
	mechanics_text = "This machine is used to merge the contents of two different gas tanks. Plug the tanks into the transfer, then open the valve to mix them together. You can also attach various assembly devices to trigger this process."
	antag_text = "With a tank of hot phoron and cold oxygen, this benign little atmospheric device becomes an incredibly deadly bomb. You don't want to be anywhere near it when it goes off."

/datum/codex_entry/gas_tank
	associated_paths = list(/obj/item/weapon/tank)
	mechanics_text = "These tanks are utilised to store any of the various types of gaseous substances. \
	They can be attached to various portable atmospheric devices to be filled or emptied. <br>\
	<br>\
	Each tank is fitted with an emergency relief valve. This relief valve will open if the tank is pressurised to over ~3000kPa or heated to over 173?C. \
	Normally the valve itself will close after expending most or all of the contents into the air, but can be forced open or closed with a screwdriver.<br>\
	<br>\
	Filling a tank such that experiences ~4000kPa of pressure will cause the tank to rupture, spilling out its contents and destroying the tank. \
	Tanks filled over ~5000kPa will rupture rather violently, exploding with significant force."
	antag_text = "Each tank may be incited to burn by attaching wires and an igniter assembly, though the igniter can only be used once and the mixture only burn if the igniter pushes a flammable gas mixture above the minimum burn temperature (126?C). \
	Wired and assembled tanks may be disarmed with a set of wirecutters. Any exploding or rupturing tank will generate shrapnel, assuming their relief valves have been welded beforehand. Even if not, they can be incited to expel hot gas on ignition if pushed above 173?C. \
	Relatively easy to make, the single tank bomb requries no tank transfer valve, and is still a fairly formidable weapon that can be manufactured from any tank."

/datum/codex_entry/gas_analyzer
	associated_paths = list(/obj/item/device/scanner/gas)
	mechanics_text = "A device that analyzes the gas contents of a tile or atmospherics devices. Has 3 modes: Default operates without \
	additional output data; Moles and volume shows the moles per gas in the mixture and the total moles and volume; Gas \
	traits and data describes the traits per gas, how it interacts with the world, and some of its property constants."