/namespace/synthesized_instruments/ADSR_envelope
	// When a note is played, this is how volume changes no matter the duration. Goes to sustain cycle when it ends.
	var/list/attack_decay_cycle
	// This is how volume changes while the note is playing. It is looped for as long as needed. Decays into release cycle when the note had played for given time or critical duration was reached.
	var/list/sustain_cycle
	// This is how volume decays after note had played for its intended duration. Must end with 0 to signify end of sound.
	var/list/release_cycle
	// Used for UI to determine a proper menu for this kind of ADSR
	var/ADSR_type = -1


/namespace/synthesized_instruments/ADSR_envelope/New()
	src.attack_decay_cycle = list()
	src.sustain_cycle = list()
	src.release_cycle = list()

	if (src.type == /namespace/synthesized_instruments/ADSR_envelope)
		CRASH("[src.type] may not be created, as it is an abstract class")

	src.init_ADSR()


/namespace/synthesized_instruments/ADSR_envelope/proc/init_ADSR()
	CRASH("init_ADSR was not defined or was called by ..() in one of the subclasses")


/**
 * This should generate a volume multiplier list.
 *
 * @param user /mob User that called this proc.
 *
 * @return nothing
 */
/namespace/synthesized_instruments/ADSR_envelope/proc/generate_sustain(mob/user)
	return


/namespace/synthesized_instruments/ADSR_envelope/proc/_validate_cycles()
	. = 0
	if (0 == src.attack_decay_cycle.len)
		CRASH("Empty attack_decay_cycle")
	if (0 == src.sustain_cycle.len)
		CRASH("Empty sustain_cycle")
	if (0 == src.release_cycle.len)
		CRASH("Empty release_cycle")
	if (0 > src.release_cycle[src.release_cycle.len])
		CRASH("Release_cycle does not end with 0.0 volume mod")
	for (var/mult in src.attack_decay_cycle)
		if (0 >= mult)
			CRASH("One of volume multipliers in attack_decay_cycle is zero")
	for (var/mult in src.sustain_cycle)
		if (0 >= mult)
			CRASH("One of volume multipliers in sustain_cycle is zero")
	for (var/mul_indx = 1 to src.release_cycle.len-1)
		var/mult = src.release_cycle[mul_indx]
		if (0 >= mult)
			CRASH("Release cycle ends prematurely")
	. = 1
