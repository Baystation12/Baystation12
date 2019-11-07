#define SCENT_COOLDOWN 7 MINUTES

#define SCENT_INTENSITY_WEAK 0
#define SCENT_INTENSITY_NORMAL 1
#define SCENT_INTENSITY_STRONG 2

#define SCENT_DESC_ODOR        "odour"
#define SCENT_DESC_SMELL       "smell"
#define SCENT_DESC_FRAGRANCE   "fragrance"


/datum/extension/scent
	flags = EXTENSION_FLAG_IMMEDIATE

	var/scent = "something"
	var/intensity = SCENT_INTENSITY_WEAK
	var/descriptor = SCENT_DESC_SMELL //unambiguous descriptor of smell; food is generally good, sewage is generally bad. how 'nice' the scent is
	var/range = 1 //range in tiles

/datum/extension/scent/New()
	..()
	START_PROCESSING(SSprocessing, src)

/datum/extension/scent/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	..()

/datum/extension/scent/Process()
	if(!holder)
		crash_and_del()
		return
	emit_scent()

/datum/extension/scent/proc/crash_and_del()
	crash_with("Scent extension with scent '[scent]', intensity '[intensity]', descriptor '[descriptor]' and range of '[range]' attempted to emit_scent() without a holder. Deleting.")
	qdel(src)

/datum/extension/scent/proc/emit_scent()
	if(holder)
		for(var/mob/living/carbon/human/H in all_hearers(holder, range))
			var/turf/T = get_turf(H.loc)
			if(!T)
				continue
			if(H.stat != CONSCIOUS || H.failed_last_breath || H.wear_mask || H.head && H.head.permeability_coefficient < 1 || !T.return_air())
				continue
			if(H.last_smelt < world.time)
				switch(intensity)
					if(SCENT_INTENSITY_WEAK)
						to_chat(H, SPAN_SUBTLE("The subtle [descriptor] of [scent] tickles your nose..."))
					if(SCENT_INTENSITY_NORMAL)
						to_chat(H, SPAN_NOTICE("The [descriptor] of [scent] fills the air."))
					if(SCENT_INTENSITY_STRONG)
						to_chat(H, SPAN_WARNING("The unmistakable [descriptor] of [scent] bombards your nostrils."))
				H.last_smelt = world.time + SCENT_COOLDOWN
	else
		crash_and_del()