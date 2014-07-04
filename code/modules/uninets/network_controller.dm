// =
// = The Unified (-Type-Tree) Cable Network System
// = Written by Sukasa with assistance from Googolplexed
// =
// = Cleans up the type tree and reduces future code maintenance
// = Also makes it easy to add new link & network types
// =

// Unified link Network System - Base Network Controller Class

/datum/controller/uninet_controller
	var/unified_network/network = null


/datum/controller/uninet_controller/New(unified_network/new_network)
	..()
	network = new_network

/datum/controller/uninet_controller/proc/attachNode(obj/node)
	return

/datum/controller/uninet_controller/proc/detachNode(obj/node)
	return

/datum/controller/uninet_controller/proc/addLink(obj/structure/uninet_link/link)
	return

/datum/controller/uninet_controller/proc/removeLinks(obj/structure/uninet_link/link)
	return

/datum/controller/uninet_controller/proc/startSplit(unified_network/new_network)
	return

/datum/controller/uninet_controller/proc/finishSplit(unified_network/new_network)
	return

/datum/controller/uninet_controller/proc/linkCut(obj/structure/uninet_link/link, mob/user)
	return

/datum/controller/uninet_controller/proc/linkBuilt(obj/structure/uninet_link/link, mob/user)
	return

/datum/controller/uninet_controller/proc/initialize()
	return

/datum/controller/uninet_controller/proc/finalize()
	return

/datum/controller/uninet_controller/proc/beginMerge(unified_network/target_network, is_slave)
	return

/datum/controller/uninet_controller/proc/finishMerge()
	return

/datum/controller/uninet_controller/proc/deviceUsed(obj/item/device/device, obj/structure/uninet_link/link, mob/user)
	return

/datum/controller/uninet_controller/proc/linkTouched(obj/structure/uninet_link/link, mob/user)
	return

/datum/controller/uninet_controller/proc/process()
	return
