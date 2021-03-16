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

/datum/codex_entry/vr
	associated_paths = list(/obj/machinery/vr_pod)
	mechanics_text = "<p>VR pods are full-body beds that can send a user into virtual reality. While in VR, you'll effectively control a different person inside a virtual space, bringing along none of your belongings and being unable to see or hear around your normal self.</p>\
	\
	<p>VR affords a great deal of freedom. Several new verbs, found in the VR tab, allow you to do things such as heal your virtual body, as well as maxing out all of your skills. It's an ideal place to test out and learn new things before you do them in person. You'll be able to interact with anyone else that's using VR in the same area, as well.</p>\
	\
	<p>When you exit VR, you'll drop all the items your digital body had so that they aren't removed from the simulation. You'll be forced out if your pod is opened or if your virtual body dies. Obviously, dying in real life will cancel your VR session.</p>"

	lore_text = "<p>VR tech really took off after the 21st century, but simulating entire detailed worlds takes a lot of processing power and is mostly a novelty. It's possible in some places - usually tourist destinations - but nothing of the sort in this humble little pod. Simulated environments are an excellent place for hands-on training and experience without risking danger in the real world, and are especially useful for learning delicate procedures like surgery without any risk of collateral damage.</p>\
	\
	<p>This design is manufactured by Ward-Takahashi. It's unassuming on the outside and inside, but it works by physically intercepting and altering the stimuli your brain receives to effectively shift your entire perception into that of your virtual body, making it feel like you're really there. This is also why you're incapable of seeing, hearing, or feeling anything from your normal body when you're in VR - with a few exceptions.</p>"

	antag_text = "<p>If you're looking for a place for a covert meeting or discussion where nobody can spy on you without having to make themselves known, a VR room might be just the thing you need.</p>\
	\
	<p>Under normal circumstances, the pod's design provides a complete separation between the stimuli of the an occupant and their virtual self. However, settings exist to allow partial or full mirroring of some things. This is usually used to help ease people into using VR, but with the right tools, you could do other things with it. Like hurting people.</p>"
