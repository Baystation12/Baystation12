//Good luck. --BlueNexus

//Static version of the clamp
/obj/machinery/clamp
	name = "stasis clamp"
	desc = "A magnetic clamp which can halt the flow of gas in a pipe, via a localised stasis field."
	icon = 'icons/atmos/clamp.dmi'
	icon_state = "pclamp0"
	anchored = TRUE
	var/obj/machinery/atmospherics/pipe/target = null
	var/open = 1

	var/list/datum/pipe_network/network_nodes

/obj/machinery/clamp/Initialize(mapload, obj/machinery/atmospherics/pipe/to_attach = null)

	..()
	if(istype(to_attach))
		target = to_attach
	else
		target = locate(/obj/machinery/atmospherics/pipe) in loc
	if(target)
		target.clamp = src
		update_networks()
		dir = target.dir
	return 1

/obj/machinery/clamp/proc/update_networks()
	if(!target)
		return
	else
		for(var/obj/machinery/atmospherics/pipe/node in target.pipeline_expansion())
			var/datum/pipeline/PL = node.parent
			LAZYADD(network_nodes, PL.network)

/obj/machinery/clamp/physical_attack_hand(mob/user)
	if(!target)
		return FALSE
	if(!open)
		open()
	else
		close()
	to_chat(user, SPAN_NOTICE("You turn [open ? "off" : "on"] \the [src]"))
	return TRUE

/obj/machinery/clamp/Destroy()
	if(!open && !QDELING(target))
		open()
	target = null
	. = ..()

/obj/machinery/clamp/proc/open()
	if(open || !target)
		return 0

	target.build_network()


	for(var/datum/pipe_network/netnode in network_nodes)
		netnode.update = TRUE

	update_networks()

	open = TRUE
	icon_state = "pclamp0"
	target.in_stasis = FALSE
	target.try_leak()
	return 1

/obj/machinery/clamp/proc/close()
	if(!open)
		return 0

	qdel(target.parent)

	for(var/datum/pipe_network/netnode in network_nodes)
		qdel(netnode)
	network_nodes = null

	for(var/obj/machinery/atmospherics/pipe/node in target.pipeline_expansion())
		node.build_network()
		LAZYADD(network_nodes, node)
		var/datum/pipeline/P = node.parent
		P.build_pipeline(node)
		qdel(P)

	open = FALSE
	icon_state = "pclamp1"
	target.in_stasis = TRUE
	target.try_leak()
	return TRUE

/obj/machinery/clamp/proc/removal(var/atom/destination)
	var/obj/item/clamp/C = new/obj/item/clamp(destination)
	if(ishuman(destination))
		var/mob/living/carbon/human/H = destination
		H.put_in_hands(C)
	qdel(src)

/obj/machinery/clamp/MouseDrop(obj/over_object as obj)
	if(!usr)
		return

	if(open && over_object == usr && Adjacent(usr))
		to_chat(usr, "<span class='notice'>You begin to remove \the [src]...</span>")
		if (do_after(usr, 30, src))
			to_chat(usr, "<span class='notice'>You have removed \the [src].</span>")
			removal()
			return
	else
		to_chat(usr, "<span class='warning'>You can't remove \the [src] while it's active!</span>")


/obj/machinery/clamp/proc/detach()
	if (target && target.clamp == src)
		target.clamp = null
	new/obj/item/clamp(loc)
	qdel(src)

/obj/item/clamp
	name = "stasis clamp"
	desc = "A magnetic clamp which can halt the flow of gas in a pipe, via a localised stasis field."
	icon = 'icons/atmos/clamp.dmi'
	icon_state = "pclamp0"
	origin_tech = list(TECH_ENGINEERING = 4, TECH_MAGNET = 4)

/obj/item/clamp/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity)
		return

	if (istype(A, /obj/machinery/atmospherics/pipe))
		var/obj/machinery/atmospherics/pipe/simple/P = A
		if (P.clamp)
			to_chat(user, SPAN_WARNING("There is already \a [P.clamp] attached to \the [P]."))
			return

		to_chat(user, SPAN_NOTICE("You begin to attach \the [src] to \the [A]..."))
		if (do_after(user, 3 SECONDS, A, DO_REPAIR_CONSTRUCT))
			if (QDELETED(P))
				return
			if (P.clamp)
				to_chat(user, SPAN_WARNING("There is already \a [P.clamp] attached to \the [P]."))
				return
			if(!user.unEquip(src))
				return
			to_chat(user, SPAN_NOTICE("You have attached \the [src] to \the [A]."))
			new/obj/machinery/clamp(A.loc, A)
			qdel(src)
