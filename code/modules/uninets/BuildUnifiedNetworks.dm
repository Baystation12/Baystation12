// =
// = The Unified (-Type-Tree) cable Network System
// = Written by Sukasa with assistance from Googolplexed
// =
// = Cleans up the type tree and reduces future code maintenance
// = Also makes it easy to add new cable & network types
// =

// Unified cable Network System - Master Network Construction Functions

/proc/makeUnifiedNetworks() //Stick this in your pipe and smoke it, Exadv1!
	for(var/obj/structure/cabling/cable in world)
		if(!cable.networks[cable.type])
			var/unified_network/new_network = createUnifiedNetwork(cable.type)
			new_network.buildFrom(cable, cable.network_controller_type)

/proc/handleUNExplosionDamage()
	//TODO
