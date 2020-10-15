GLOBAL_DATUM(unsc_overmind, /datum/npc_overmind/unsc)

/datum/npc_overmind/unsc
	overmind_name = "HighCOMM"
	constructor_types = list(/mob/living/simple_animal/hostile/builder_mob/unsc)
	combat_types = list(\
	/mob/living/simple_animal/hostile/unsc/marine,
	/mob/living/simple_animal/hostile/unsc/odst,
	)
	support_types = list(\
	/mob/living/simple_animal/hostile/unsc/spartan_two,
	)
	comms_channel = RADIO_SQUAD

/obj/structure/overmind_controller/unsc/create_overmind()
	if(!GLOB.unsc_overmind)
		GLOB.unsc_overmind = new()
		controlling_overmind =  GLOB.unsc_overmind
		GLOB.processing_objects |= GLOB.unsc_overmind
		GLOB.unsc_overmind.overmind_active = 1
		GLOB.unsc_overmind.reports.Cut() //We're likely activating the overmind here. Cut all previous reports out, they're likely outdated.

/obj/structure/overmind_controller/unsc/delete_overmind()
	GLOB.unsc_overmind.overmind_active = 0