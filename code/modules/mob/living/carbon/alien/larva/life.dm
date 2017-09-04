#define MIN_LARVA_BLOOD_DRINK 0.5

//Larvae regenerate health and nutrition from plasma and alien weeds.
/mob/living/carbon/alien/larva/handle_environment(var/datum/gas_mixture/environment)

	if(!environment) return

	var/turf/T = get_turf(src)
	var/obj/effect/plant/plant = locate() in T
	if(environment.gas["phoron"] > 0 || (plant && plant.seed.type == /datum/seed/xenomorph))
		update_progression()
		adjustBruteLoss(-1)
		adjustFireLoss(-1)
		adjustToxLoss(-1)
		adjustOxyLoss(-1)

// Maybe not the -best- place but it's semiappropriate and fitting.
// Drink the blood of your host!
/mob/living/carbon/alien/larva/handle_chemicals_in_body()
	if(!loc)
		return
	if(!istype(loc, /obj/item/weapon/holder))
		return
	var/mob/living/carbon/human/M = loc.loc //ergh, replace with a flag sometime
	if(!istype(M))
		return
	if(M.vessel.total_volume > 0)
		M.vessel.trans_to(src,min(M.vessel.total_volume,MIN_LARVA_BLOOD_DRINK))
		update_progression()
	else
		to_chat(src, "<span class='danger'>This host is depleted of blood...</span>")
		leave_host()

#undef MIN_LARVA_BLOOD_DRINK
