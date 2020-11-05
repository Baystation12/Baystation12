
GLOBAL_DATUM(covenant_overmind, /datum/npc_overmind/covenant)

/datum/npc_overmind/covenant
	overmind_name = "Holy Communications Array"
	constructor_types = list(/mob/living/simple_animal/hostile/builder_mob/cov)
	combat_types = list(\
	/mob/living/simple_animal/hostile/covenant/elite/ultra,
	/mob/living/simple_animal/hostile/covenant/elite/zealot,
	/mob/living/simple_animal/hostile/covenant/drone/ranged
	)
	support_types = list(\
	/mob/living/simple_animal/hostile/covenant/elite/major,
	/mob/living/simple_animal/hostile/covenant/grunt/heavy,
	/mob/living/simple_animal/hostile/covenant/jackal/sniper
	)
	comms_channel = RADIO_COV

/obj/structure/overmind_controller/covenant/create_overmind()
	if(!GLOB.covenant_overmind)
		GLOB.covenant_overmind = new()
		controlling_overmind =  GLOB.covenant_overmind
		GLOB.processing_objects |= GLOB.covenant_overmind
		GLOB.covenant_overmind.overmind_active = 1
		GLOB.covenant_overmind.reports.Cut() //We're likely activating the overmind here. Cut all previous reports out, they're likely outdated.

/obj/structure/overmind_controller/covenant/delete_overmind()
	GLOB.covenant_overmind.overmind_active = 0
