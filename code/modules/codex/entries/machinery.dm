/datum/codex_entry/replicator
	associated_paths = list(/obj/machinery/fabricator/replicator)
	mechanics_text = "The food replicator is operated through voice commands. To inquire available dishes on the menu, say 'menu'. To dispense a dish, say the name of the dish listed in its menu. \
	Dishes can only be produced as long as the replicator has biomass. To check on the biomass level of the replicator, say 'status'. Various food items or plants may be inserted to refill biomass."

/datum/codex_entry/emitter
	associated_paths = list(/obj/machinery/power/emitter)
	mechanics_text = "You must secure this in place with a wrench and weld it to the floor before using it. The emitter will only fire if it is installed above a cable endpoint. Clicking will toggle it on and off, at which point, so long as it remains powered, it will fire in a single direction in bursts of four."
	lore_text = "Lasers like this one have been in use for ages, in applications such as mining, cutting, and in the startup sequence of many advanced space station and starship engines."
	antag_text = "This baby is capable of slicing through walls, sealed lockers, and people."

/datum/codex_entry/diffuser_machine
	associated_paths = list(/obj/machinery/shield_diffuser)
	mechanics_text = "This device disrupts shields on directly adjacent tiles (in a + shaped pattern). They are commonly installed around exterior airlocks to prevent shields from blocking EVA access."

/datum/codex_entry/conveyor_construct
	associated_paths = list(/obj/machinery/conveyor, /obj/item/conveyor_construct)
	mechanics_text = "This device must be connected to a switch assembly before placement by clicking the switch on the conveyor belt assembly. When active it will move objects on top of it to the adjacent space based on its direction and if it is running in forward or reverse mode. Can be removed with a crowbar."

/datum/codex_entry/conveyor_construct
	associated_paths = list(/obj/machinery/conveyor_switch,/obj/machinery/conveyor_switch/oneway,/obj/item/conveyor_switch_construct,/obj/item/conveyor_switch_construct/oneway)
	mechanics_text = "This device can connect to a number of conveyor belts and control their movement. A two-way switch will allow you to make the conveyors run in forward and reverse mode, the one-way switch will only allow one direction. Can be removed with a crowbar."

/datum/codex_entry/drone_pad
	associated_paths = list(/obj/machinery/drone_pad)
	mechanics_text = "This machine serves as a delivery point for payloads. Each additional pad in a network can handle an additional delivery. Use a multitool to set the network."
