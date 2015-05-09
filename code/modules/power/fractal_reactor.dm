// ###############################################################################
// # ITEM: FRACTAL ENERGY REACTOR                                                #
// # FUNCTION: Generate infinite electricity. Used for map testing.              #
// ###############################################################################

/obj/machinery/power/fractal_reactor
	name = "Fractal Energy Reactor"
	desc = "This thing drains power from fractal-subspace." // (DEBUG ITEM: INFINITE POWERSOURCE FOR MAP TESTING. CONTACT DEVELOPERS IF FOUND.)"
	icon = 'icons/obj/power.dmi'
	icon_state = "tracker" //ICON stolen from solar tracker. There is no need to make new texture for debug item
	anchored = 1
	density = 1
	var/power_generation_rate = 1000000 //Defaults to 1MW of power.
	var/powernet_connection_failed = 0
	var/mapped_in = 0					//Do not announce creation when it's mapped in.

	// This should be only used on Dev for testing purposes.
/obj/machinery/power/fractal_reactor/New()
	..()
	if(!mapped_in)
		world << "<b>\red WARNING: \black Map testing power source activated at: X:[src.loc.x] Y:[src.loc.y] Z:[src.loc.z]</b>"

/obj/machinery/power/fractal_reactor/process()
	if(!powernet && !powernet_connection_failed)
		if(!connect_to_network())
			powernet_connection_failed = 1
			spawn(150) // Error! Check again in 15 seconds.
				powernet_connection_failed = 0
	add_avail(power_generation_rate)