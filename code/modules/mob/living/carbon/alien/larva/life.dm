#define MIN_LARVA_BLOOD_DRINK 50

//Larvae regenerate health and nutrition from plasma and alien weeds.
/mob/living/carbon/alien/larva/handle_environment(var/datum/gas_mixture/environment)
	if(!environment) return
	var/turf/T = get_turf(src)
	var/obj/effect/plant/plant = locate() in T
	if(environment.gas["phoron"] > 0 || (plant && plant.seed && plant.seed.name == "xenophage"))
		adjustBruteLoss(-1)
		adjustFireLoss(-1)
		adjustToxLoss(-1)
		adjustOxyLoss(-1)

// Maybe not the -best- place but it's semiappropriate and fitting.
// Drink the blood of your host!
/mob/living/carbon/alien/larva/handle_chemicals_in_body()
	var/mob/living/carbon/human/M = loc
	if(!istype(M))
		return
	if(M.vessel.total_volume > 0)
		M.vessel.trans_to(src,min(M.vessel.total_volume,MIN_LARVA_BLOOD_DRINK))
		update_progression()

#undef MIN_LARVA_BLOOD_DRINK