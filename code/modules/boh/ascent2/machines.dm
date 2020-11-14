/////////
/*
Ascent SMES -
This'll be in use until a proper reactor is created, and can be set up by players.
The current function is to allow proper storage and output of the reactor, to fuel various materials being added.
As it can't be deconstructed, this shouldn't be too much of an issue, as, again, it's a placeholder.
*/
/////////

//coil
/obj/item/weapon/stock_parts/smes_coil/ascent
	name = "superconductive capacitance coil"
	desc = "This device is constantly humming with incredible power. It'd be wise not to play about with it."
	ChargeCapacity = 1 GIGAWATTS
	IOCapacity = 5 GIGAWATTS

//unit
/obj/machinery/power/smes/buildable/ascent
	name = "mantid battery"
	desc = "Some kind of strange alien SMES technology. It crackles with power."
	icon = 'icons/obj/machines/power/mantid_smes.dmi'
	overlay_icon = 'icons/obj/machines/power/mantid_smes.dmi'
	uncreated_component_parts = list(
		/obj/item/weapon/stock_parts/smes_coil/ascent = 1)
	construct_state = /decl/machine_construction/default/no_deconstruct

/obj/machinery/power/shield_generator/ascent
	name = "superior shield generator"
	desc = "An incredibly powerful shield generator, capable of generating energy shields at insanely fast speeds."
	color = "#a33fbf"
	upkeep_multiplier = 0
	ai_control_disabled = 1
	idle_multiplier   = 0
	idle_valid_values = list(30)
	spinup_delay      = 0
	spinup_counter    = 0
	inefficency_counter = 0
	field_radius = 200
