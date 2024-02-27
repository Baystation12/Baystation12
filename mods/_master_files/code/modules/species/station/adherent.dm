/datum/species/adherent/New()
	LAZYINITLIST(inherent_verbs)
	inherent_verbs += /mob/living/carbon/human/proc/toggle_emergency_discharge
	..()
