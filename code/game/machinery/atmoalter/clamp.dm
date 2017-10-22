//Good luck. --BlueNexus

//Static version of the clamp
/obj/machinery/clamp
	name = "stasis clamp"
	desc = "A magnetic clamp which can halt the flow of gas in a pipe, via a localised stasis field."
	icon = 'icons/atmos/clamp.dmi'
	icon_state = "pclamp0"
	anchored = 1.0
	var/obj/machinery/atmospherics/pipe/simple/target = null
	var/open = 1

	var/datum/pipe_network/network_node1
	var/datum/pipe_network/network_node2

/obj/machinery/clamp/New(loc, var/obj/machinery/atmospherics/pipe/simple/to_attach = null)
	..()
	if(istype(to_attach))
		target = to_attach
	else
		target = locate(/obj/machinery/atmospherics/pipe/simple) in loc
	if(target)
		update_networks()
		dir = target.dir
	return 1

/obj/machinery/clamp/proc/update_networks()
	if(!target)
		return
	else
		var/obj/machinery/atmospherics/pipe/node1 = target.node1
		var/obj/machinery/atmospherics/pipe/node2 = target.node2
		if(istype(node1))
			var/datum/pipeline/P1 = node1.parent
			network_node1 = P1.network
		if(istype(node2))
			var/datum/pipeline/P2 = node2.parent
			network_node2 = P2.network

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
	if(open)
		return 0

	target.build_network()


	if(network_node1&&network_node2)
		network_node1.merge(network_node2)
		network_node2 = network_node1

	if(network_node1)
		network_node1.update = 1
	else if(network_node2)
		network_node2.update = 1

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

	var/obj/machinery/atmospherics/pipe/node1 = null
	var/obj/machinery/atmospherics/pipe/node2 = null

	if(target.node1)
		target.node1.build_network()
		node1 = target.node1
	if(target.node2)
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
//  P1.build_network()
//  P2.build_network()




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

/obj/item/clamp/afterattack(var/atom/A, mob/user as mob, proximity)
	if(!proximity)
		return

	if (istype(A, /obj/machinery/atmospherics/pipe/simple))
		to_chat(user, "<span class='notice'>You begin to attach \the [src] to \the [A]...</span>")
		if (do_after(user, 30, src))
			to_chat(user, "<span class='notice'>You have attached \the [src] to \the [A].</span>")
			new/obj/machinery/clamp(A.loc, A)
			user.drop_from_inventory(src)
			qdel(src)

