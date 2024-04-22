#define PULSE_NUMBER_NONE 0
#define PULSE_NUMBER_SLOW 50
#define PULSE_NUMBER_NORM 75
#define PULSE_NUMBER_FAST 105
#define PULSE_NUMBER_2FAST 140
#define PULSE_NUMBER_THREADY PULSE_MAX_BPM


/mob/living/carbon/human/get_pulse_as_number()
	var/obj/item/organ/internal/heart/heart_organ = internal_organs_by_name[BP_HEART]
	if(!heart_organ)
		return PULSE_NUMBER_NONE

	var/raw_pulse_number
	switch(pulse())
		if(PULSE_NONE)
			return PULSE_NUMBER_NONE
		if(PULSE_SLOW)
			raw_pulse_number = PULSE_NUMBER_SLOW
		if(PULSE_NORM)
			raw_pulse_number = PULSE_NUMBER_NORM
		if(PULSE_FAST)
			raw_pulse_number = PULSE_NUMBER_FAST
		if(PULSE_2FAST)
			raw_pulse_number = PULSE_NUMBER_2FAST
		if(PULSE_THREADY)
			return PULSE_NUMBER_THREADY
	return ((raw_pulse_number * (2 - species.blood_volume / SPECIES_BLOOD_DEFAULT)) + (raw_pulse_number * rand(-0.2, 0.2)))


#undef PULSE_NUMBER_NONE
#undef PULSE_NUMBER_SLOW
#undef PULSE_NUMBER_NORM
#undef PULSE_NUMBER_FAST
#undef PULSE_NUMBER_2FAST
#undef PULSE_NUMBER_THREADY
