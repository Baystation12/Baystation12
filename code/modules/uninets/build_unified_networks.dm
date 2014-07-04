// =
// = The Unified (-Type-Tree) Cable Network System
// = Written by Sukasa with assistance from Googolplexed
// =
// = Cleans up the type tree and reduces future code maintenance
// = Also makes it easy to add new link & network types
// =

// Unified link Network System - Master Network Construction Functions

/proc/makeUnifiedNetworks() //Stick this in your pipe and smoke it, Exadv1!
	for(var/obj/structure/uninet_link/link in world)
		if(!link.networks[link.type])
			var/unified_network/new_network = createUnifiedNetwork(link.type)
			new_network.buildFrom(link, link.network_controller_type)

/proc/handleUNExplosionDamage()
	//TODO
