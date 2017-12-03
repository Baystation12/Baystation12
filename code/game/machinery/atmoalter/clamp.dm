//Good luck. --BlueNexus
//Yeah, just looking at this might kill you. --ZeroBits

//Static version of the clamp
/obj/machinery/clamp
	name = "stasis clamp"
	desc = "A magnetic clamp which can halt the flow of gas in a pipe, via a localised stasis field."
	icon = 'icons/atmos/clamp.dmi'
	icon_state = "pclamp0"
	anchored = 1.0
	var/obj/machinery/atmospherics/pipe/target = null
	var/open = 1
	var/nodes = 2

	var/datum/pipe_network/network_node1
	var/datum/pipe_network/network_node2
	var/datum/pipe_network/network_node3
	var/datum/pipe_network/network_node4

/obj/machinery/clamp/New(loc, var/obj/machinery/atmospherics/pipe/to_attach = null)
	..()
	if(istype(to_attach))
		target = to_attach
	else
		target = locate(/obj/machinery/atmospherics/pipe) in loc
	if(target)
		update_networks()
		dir = target.dir
	return 1

/obj/machinery/clamp/proc/update_networks()
	if(!target)
		return
	else
		nodes = 2
		var/obj/machinery/atmospherics/pipe/node1 = target.node1
		var/obj/machinery/atmospherics/pipe/node2 = target.node2
		if(istype(node1))
			var/datum/pipeline/P1 = node1.parent
			network_node1 = P1.network
		if(istype(node2))
			var/datum/pipeline/P2 = node2.parent
			network_node2 = P2.network

		var/obj/machinery/atmospherics/pipe/manifold4w/M4 = target
		if(istype(M4))
			nodes = 4
			var/obj/machinery/atmospherics/pipe/node3 = M4.node3
			var/obj/machinery/atmospherics/pipe/node4 = M4.node4

			if(istype(node3))
				var/datum/pipeline/P3 = node3.parent
				network_node3 = P3.network
			if(istype(node4))
				var/datum/pipeline/P4 = node4.parent
				network_node4 = P4.network
		else
			var/obj/machinery/atmospherics/pipe/manifold/MF = target
			if(istype(MF))
				nodes = 3
				var/obj/machinery/atmospherics/pipe/node3 = MF.node3

				if(istype(node3))
					var/datum/pipeline/P3 = node3.parent
					network_node3 = P3.network

/obj/machinery/clamp/attack_hand(var/mob/user)
	if(!target || !user)
		return
	if(!open)
		open()
	else
		close()
	to_chat(user, "<span class='notice'>You turn [open ? "off" : "on"] \the [src]</span>")

/obj/machinery/clamp/Destroy()
	if(!open)
		spawn(-1) open()
	. = ..()

/obj/machinery/clamp/proc/open()
	if(open || !target)
		return 0

	target.build_network()

	#define MERGE_IF_EXISTS(netA, netB) if(netA && netB) {netA.merge(netB) ; netB = netA}

	MERGE_IF_EXISTS(network_node1, network_node2)
	MERGE_IF_EXISTS(network_node1, network_node3)
	MERGE_IF_EXISTS(network_node1, network_node4)
	MERGE_IF_EXISTS(network_node2, network_node3)
	MERGE_IF_EXISTS(network_node2, network_node4)
	MERGE_IF_EXISTS(network_node3, network_node4)

	#undef MERGE_IF_EXISTS

	if(network_node1)
		network_node1.update = 1
	else if(network_node2)
		network_node2.update = 1
	else if(network_node3)
		network_node3.update = 1
	else if(network_node4)
		network_node4.update = 1

	update_networks()

	open = 1
	icon_state = "pclamp0"
	target.in_stasis = 0
	return 1

/obj/machinery/clamp/proc/close()
	if(!open)
		return 0

	qdel(target.parent)

	if(network_node1)
		qdel(network_node1)
	if(network_node2)
		qdel(network_node2)
	if(network_node3)
		qdel(network_node3)
	if(network_node4)
		qdel(network_node4)

	var/obj/machinery/atmospherics/pipe/node1 = null
	var/obj/machinery/atmospherics/pipe/node2 = null
	var/obj/machinery/atmospherics/pipe/node3 = null
	var/obj/machinery/atmospherics/pipe/node4 = null



	if(nodes==3)
		var/obj/machinery/atmospherics/pipe/manifold/MF = target
		MF.node1.build_network()
		node1 = MF.node1
		MF.node2.build_network()
		node2 = MF.node2
		MF.node3.build_network()
		node3 = MF.node3
	if(nodes==4)
		var/obj/machinery/atmospherics/pipe/manifold4w/M4 = target
		M4.node1.build_network()
		node1 = M4.node1
		M4.node2.build_network()
		node2 = M4.node2
		M4.node3.build_network()
		node3 = M4.node3
		M4.node4.build_network()
		node4 = M4.node4
	else
		target.node1.build_network()
		node1 = target.node1
		target.node2.build_network()
		node2 = target.node2

	if(istype(node1) && node1.parent)
		var/datum/pipeline/P1 = node1.parent
		P1.build_pipeline(node1)
		qdel(P1)
	if(istype(node2) && node2.parent)
		var/datum/pipeline/P2 = node2.parent
		P2.build_pipeline(node2)
		qdel(P2)
	if(istype(node3) && node3.parent)
		var/datum/pipeline/P3 = node3.parent
		P3.build_pipeline(node3)
		qdel(P3)
	if(istype(node4) && node4.parent)
		var/datum/pipeline/P4 = node4.parent
		P4.build_pipeline(node2)
		qdel(P4)

	open = 0
	icon_state = "pclamp1"
	target.in_stasis = 1

	return 1

/obj/machinery/clamp/MouseDrop(obj/over_object as obj)
	if(!usr)
		return

	if(open && over_object == usr && Adjacent(usr))
		to_chat(usr, "<span class='notice'>You begin to remove \the [src]...</span>")
		if (do_after(usr, 30, src))
			to_chat(usr, "<span class='notice'>You have removed \the [src].</span>")
			var/obj/item/clamp/C = new/obj/item/clamp(src.loc)
			C.forceMove(usr.loc)
			if(ishuman(usr))
				usr.put_in_hands(C)
			qdel(src)
			return
	else
		to_chat(usr, "<span class='warning'>You can't remove \the [src] while it's active!</span>")

/obj/item/clamp
	name = "stasis clamp"
	desc = "A magnetic clamp which can halt the flow of gas in a pipe, via a localised stasis field."
	icon = 'icons/atmos/clamp.dmi'
	icon_state = "pclamp0"
	origin_tech = list(TECH_ENGINEERING = 4, TECH_MAGNET = 4)

/obj/item/clamp/afterattack(var/atom/A, mob/user as mob, proximity)
	if(!proximity)
		return

	if (istype(A, /obj/machinery/atmospherics/pipe))
		to_chat(user, "<span class='notice'>You begin to attach \the [src] to \the [A]...</span>")
		if (do_after(user, 30, src))
			to_chat(user, "<span class='notice'>You have attached \the [src] to \the [A].</span>")
			new/obj/machinery/clamp(A.loc, A)
			user.drop_from_inventory(src)
			qdel(src)

