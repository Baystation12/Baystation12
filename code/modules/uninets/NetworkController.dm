// =
// = The Unified (-Type-Tree) cable Network System
// = Written by Sukasa with assistance from Googolplexed
// =
// = Cleans up the type tree and reduces future code maintenance
// = Also makes it easy to add new cable & network types
// =

// Unified cable Network System - Base Network Controller Class

/datum/controller/uninet_controller
	var/unified_network/network = null


/datum/controller/uninet_controller/New(unified_network/new_network)
	..()
	network = new_network

/datum/controller/uninet_controller/proc/attachNode(obj/node)
	return

/datum/controller/uninet_controller/proc/detachNode(obj/node)
	return

/datum/controller/uninet_controller/proc/addCable(obj/structure/cabling/cable)
	return

/datum/controller/uninet_controller/proc/removeCable(obj/structure/cabling/cable)
	return

/datum/controller/uninet_controller/proc/startSplit(unified_network/new_network)
	return

/datum/controller/uninet_controller/proc/finishSplit(unified_network/new_network)
	return

/datum/controller/uninet_controller/proc/cableCut(obj/structure/cabling/cable, mob/user)
	return

/datum/controller/uninet_controller/proc/cableBuilt(obj/structure/cabling/cable, mob/user)
	return

/datum/controller/uninet_controller/proc/initialize()
	return

/datum/controller/uninet_controller/proc/finalize()
	return

/datum/controller/uninet_controller/proc/beginMerge(unified_network/target_network, is_slave)
	return

/datum/controller/uninet_controller/proc/finishMerge()
	return

/datum/controller/uninet_controller/proc/deviceUsed(obj/item/device/device, obj/structure/cabling/cable, mob/user)
	return

/datum/controller/uninet_controller/proc/cableTouched(obj/structure/cabling/cable, mob/user)
	return

/datum/controller/uninet_controller/proc/process()
	return
