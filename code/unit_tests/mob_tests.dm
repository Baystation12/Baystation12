/*
 *
 *  Mob Unit Tests.
 *  Human suffocation in Space.
 *  Human 
 *
 */

// 
// Tests Life() and mob breathing in space.

datum/unit_test/human_breath
	name = "MOB: Human Suffocates in Space"
	var/starting_oxyloss = null
	var/ending_oxyloss = null
	var/mob/living/carbon/human/H
	async = 1
	

datum/unit_test/human_breath/start_test()
	var/turf/T = locate(20,20,1) //TODO:  Find better way.

	if(!istype(T, /turf/space))	//If the above isn't a space turf then we force it to find one will most likely pick 1,1,1
		T = locate(/turf/space)

	H = new(T)

	starting_oxyloss = H.getOxyLoss()

	return 1

datum/unit_test/human_breath/check_result()

	if(H.life_tick < 10) 	// Finish Condition
		return 0	// Return 0 to try again later.

	ending_oxyloss = H.getOxyLoss()

	if(starting_oxyloss < ending_oxyloss)
		pass("Oxyloss = [ending_oxyloss]")
	else
		fail("Mob is not taking oxygen damage.  Oxyloss is [ending_oxyloss]")
	
	qdel(H)
	return 1	// return 1 to show we're done.

// ============================================================================

