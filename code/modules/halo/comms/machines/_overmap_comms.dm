
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