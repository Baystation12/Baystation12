//Larvae regenerate health and nutrition from plasma and alien weeds.
/mob/living/carbon/alien/larva/handle_environment()

	var/turf/T = loc
	if(!T) return
	var/datum/gas_mixture/environment = T.return_air()
	if(!environment) return

	if(environment.gas["phoron"] > 0 || locate(/obj/effect/alien/weeds) in T.contents)
		update_progression()
		adjustBruteLoss(-1)
		adjustFireLoss(-1)
		adjustToxLoss(-1)
		adjustOxyLoss(-1)