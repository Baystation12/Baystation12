
/obj/machinery/overmap_comms
	name = "telecomms machine"
	icon = 'code/modules/halo/comms/machines/telecomms.dmi'
	icon_state = "error"
	density = 1
	anchored = 1
	var/icon_state_active = "error"
	var/icon_state_inactive = "error"
	desc = "An advanced machine for processing radio frequency signals."
	//var/datum/overmap_comms_network/my_network
	var/active = 1
	var/machine_type
	var/failure_timer = 0
	var/failure_reactivate = 0

/obj/machinery/overmap_comms/Initialize()
	if(!machine_type)
		machine_type = src.type
	. = ..()

	//apply the correct activation state
	active = !active
	toggle_active()

/obj/machinery/overmap_comms/attack_hand(var/mob/living/user)
	if(!istype(user,/mob/living))
		return

	//default behaviour of attack_hand will be to toggle the activation state
	//for more advanced interactions eg nanoui override this attack_hand proc in the children
	toggle_active(user)

/obj/machinery/overmap_comms/proc/toggle_active(var/mob/user)
	active = !active
	if(active)
		icon_state = icon_state_active
		//connect_to_network()
	else
		icon_state = icon_state_inactive
		/*if(my_network)
			my_network.remove_machine(src)*/
	to_chat(user,"<span class='info'>You [active ? "" : "de"]activate [src]</span>")

/obj/machinery/overmap_comms/emp_act(var/severity = 1)
	. = ..()
	failure_timer = severity * 10
	if(active)
		toggle_active()
		failure_reactivate = 1

/obj/machinery/overmap_comms/proc/energy_failure(var/duration)
	emp_act()
	failure_timer = duration

/obj/machinery/overmap_comms/process()
	. = ..()

	//slowly recover from EMP
	if(failure_timer)
		failure_timer = max(0, failure_timer - 1)
		if(!failure_timer && failure_reactivate)
			failure_reactivate = 0
			toggle_active()
			src.visible_message("\icon[src] <span class='info'>[src] finishes rebooting!</span>")

/obj/machinery/overmap_comms/examine(var/mob/user)
	. = ..()
	if(failure_timer)
		to_chat(user,"<span class='notice'>Something has temporarily overloaded its circuits!</span>")

/*
/obj/machinery/overmap_comms/proc/connect_to_network()
	if(!my_network)
		//see if there is already a network here
		for(var/obj/machinery/overmap_comms/other in view(7,src))
			if(other.my_network)
				other.my_network.add_machine(src)

	if(!my_network)
		//make a new network
		var/datum/overmap_comms_network/new_network = new()

		//this will include us
		for(var/obj/machinery/overmap_comms/other in view(7,src))
			new_network.add_machine(other)

//override these two procs in children for any custom behaviour
/obj/machinery/overmap_comms/proc/added_to_network(var/datum/overmap_comms_network/network)
/obj/machinery/overmap_comms/proc/removed_from_network(var/datum/overmap_comms_network/network)

/obj/machinery/overmap_comms/Destroy()
	if(my_network)
		my_network.remove_machine(src)

	. = ..()
*/