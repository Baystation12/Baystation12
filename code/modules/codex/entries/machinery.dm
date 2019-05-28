/datum/codex_entry/replicator
	associated_paths = list(/obj/machinery/food_replicator)
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

/datum/codex_entry/turret
	associated_paths = list(/obj/machinery/porta_turret)
	mechanics_text = "Controlled either via a panel on the turret, or a connected turret controller. When activated, turrets automatically target and fire on mobs that match a provided set of \
	conditions in the turret's controls. Different types of turrets fire different types of beams, depending on the weapon they were constructed from and their configured firemode. <br/>\
	Turrets do not target law bound synthetics."
	antag_text = "Turrets can be hacked (Emagged) with a cryptographic sequencer. Emagged turrets will shut down for 6 seconds to give you time to escape. After this, the turret will re-activate \
	and begin firing at any and every mob in sight (Except law bound synthetics), regardless of its previously configured settings."
