GLOBAL_DATUM_INIT(synthesized_instruments, /namespace/synthesized_instruments/hub, new)

/namespace/synthesized_instruments/hub
	var/namespace/synthesized_instruments/bounds/bounds = new
	var/namespace/synthesized_instruments/constants/constants = new
	var/namespace/synthesized_instruments/enums/enums = new
	var/namespace/synthesized_instruments/flags/flags = new
	var/namespace/synthesized_instruments/environment/environment = new
	var/namespace/synthesized_instruments/echo/echo = new
	var/namespace/synthesized_instruments/functions/functions = new
	var/namespace/synthesized_instruments/shared/shared = new



/namespace/synthesized_instruments/bounds
	// Specifies min and max octave possible. Should be a subset of 0..9 interval.
	var/namespace/synthesized_instruments/bound/octave_bounds = new {min = 0; max = 9; is_integer = 1}
	// Specifies min and max transposition possible. No point in having it outside of -9 to 9.
	var/namespace/synthesized_instruments/bound/transposition_bounds = new {min = -9; max = 9; is_integer = 1}



/namespace/synthesized_instruments/constants
	// How many channels are taken by a single instrument. Directly limits the amount of instruments in the world
	var/max_channels_per_instrument = 128
	// Self-explanatory
	var/max_lines_in_song = 1000
	// Self-explanatory
	var/max_length_of_line_in_song = 50
	// How many events one instruments can queue
	var/max_events_per_instrument = 2400
	// Self-explanatory
	var/lines_per_page_in_song_editor = 20
	// Specifies the minimum change in channel usage to update NanoUI Usage Info window
	var/usage_info_channel_resolution = 1
	// Same as above, but for events
	var/usage_info_event_resolution = 8
	// All sound samples should AT LEAST be this long. In tenth of a second.
	var/const/sample_duration = 50
	var/_sample_duration_ticks


/namespace/synthesized_instruments/constants/New()
	src._sample_duration_ticks = ceil(src.sample_duration / world.tick_lag)



/namespace/synthesized_instruments/flags
	// Specifies if environment feature is available. Disabled for now due to being broken.
	var/env_settings_available = 0



/namespace/synthesized_instruments/environment
	// Default value for env
	var/list/env_default = list(7.5, 1.0, -1000, -100, 0, 1.49, 0.83, 1.0, -2602, 0.0007, 200, 0.011, 0.25, 0.0, 0.25, 0.0, -5.0, 5000, 250.0, 0.0, 100, 100, 63)
	// Self-explanatory. First value is lower bound, second is upper bound and third is whether the value is real or integer.
	var/list/namespace/synthesized_instruments/bound/env_params_bounds = newlist(
			{min = 1.0; max = 100.0; is_integer = 0}, // 1
			{min = 0.0; max = 1.0; is_integer = 0}, // 2
			{min = -10000; max = 0; is_integer = 1}, // 3
			{min = -10000; max = 0; is_integer = 1}, // 4
			{min = -10000; max = 0; is_integer = 1}, // 5
			{min = 0.1; max = 20; is_integer = 0}, // 6
			{min = 0.1; max = 2.0; is_integer = 0}, // 7
			{min = 0.1; max = 2.0; is_integer = 0}, // 8
			{min = -10000; max = 1000; is_integer = 1}, // 9
			{min = 0.0; max = 0.3; is_integer = 0}, // 10
			{min = -10000; max = 2000; is_integer = 1}, // 11
			{min = 0.1; max = 0; is_integer = 0}, // 12
			{min = 0.075; max = 0.250; is_integer = 0}, // 13
			{min = 0.0; max = 1.0; is_integer = 0}, // 14
			{min = 0.04; max = 4.0; is_integer = 0}, // 15
			{min = 0.0; max = 1.0; is_integer = 0}, // 16
			{min = -100.0; max = 0.0; is_integer = 0}, // 17
			{min = 1000.0; max = 20000.0; is_integer = 0}, // 18
			{min = 20.0; max = 1000.0; is_integer = 0}, // 19
			{min = 0.0; max = 10.0; is_integer = 0}, // 20
			{min = 0.0; max = 100.0; is_integer = 0}, // 21
			{min = 0.0; max = 100.0; is_integer = 0}, // 22
			{min = 0x00; max = 0xFF; is_integer = 1}) // 23
	// Ditto
	var/list/all_environments = list(
			"None",
			"Generic",
			"Padded cell",
			"Room",
			"Bathroom",
			"Living Room",
			"Stone Room",
			"Auditorium",
			"Concert Hall",
			"Cave",
			"Arena",
			"Hangar",
			"Carpetted Hallway",
			"Hallway",
			"Stone Coridor",
			"Alley",
			"Forest",
			"City",
			"Mountains",
			"Quarry",
			"Plain",
			"Parking Lot",
			"Sewer Pipe",
			"Underwater",
			"Drugged",
			"Dizzy",
			"Psychotic",
			"Custom")
	// Wrryyyy
	var/list/env_param_names = list(
			"Env. Size",
			"Env. Diff.",
			"Room",
			"Room (High Frequency)",
			"Room (Low Frequency)",
			"Decay Time",
			"Decay (High Frequency Ratio)",
			"Decay (Low Frequency Ratio)",
			"Reflections",
			"Reflections Delay",
			"Reverb",
			"Reverb Delay",
			"Echo Time",
			"Echo Depth",
			"Modulation Time",
			"Modulation Depth",
			"Air Absorption (High Frequency)",
			"High Frequency Reference",
			"Low Frequency Reference",
			"Room Rolloff Factor",
			"Diffusion",
			"Density",
			"Flags")
	// WRYYYYYY
	var/list/env_param_desc = list(
			"environment size in meters",
			"environment diffusion",
			"room effect level (at mid frequencies)",
			"relative room effect level at high frequencies",
			"relative room effect level at low frequencies",
			"reverberation decay time at mid frequencies",
			"high-frequency to mid-frequency decay time ratio",
			"low-frequency to mid-frequency decay time ratio",
			"early reflections level relative to room effect",
			"initial reflection delay time",
			"late reverberation level relative to room effect",
			"late reverberation delay time relative to initial reflection",
			"echo time",
			"echo depth",
			"modulation time",
			"modulation depth",
			"change in level per meter at high frequencies",
			"reference high frequency (hz)",
			"reference low frequency (hz)",
			"like rolloffscale in System::set3DSettings but for reverb room size effect",
			"Value that controls the echo density in the late reverberation decay.",
			"Value that controls the modal density in the late reverberation decay",
			{"
Bit flags that modify the behavior of above properties
•1 - 'EnvSize' affects reverberation decay time
•2 - 'EnvSize' affects reflection level
•4 - 'EnvSize' affects initial reflection delay time
•8 - 'EnvSize' affects reflections level
•16 - 'EnvSize' affects late reverberation delay time
•32 - AirAbsorptionHF affects DecayHFRatio
•64 - 'EnvSize' affects echo time
•128 - 'EnvSize' affects modulation time"})



/namespace/synthesized_instruments/echo
	// Default value for echo
	var/list/echo_default = list(0, 0, 0, 0, 0, 0.0, 0, 0.25, 1.5, 1.0, 0, 1.0, 0, 0.0, 0.0, 0.0, 1.0, 7)
	// Self-explanatory. First value is lower bound, second is upper bound and third is whether the value is real or integer.
	var/list/namespace/synthesized_instruments/bound/echo_params_bounds = newlist(
			{min = -10000; max = 1000; is_integer = 1}, // 1
			{min = -10000; max = 0; is_integer = 1}, // 2
			{min = -10000; max = 1000; is_integer = 1}, // 3
			{min = -10000; max = 0; is_integer = 1}, // 4
			{min = -10000; max = 0; is_integer = 1}, // 5
			{min = 0.0; max = 1.0; is_integer = 0}, // 6
			{min = -10000; max = 0; is_integer = 1}, // 7
			{min = 0.0; max = 1.0; is_integer = 0}, // 8
			{min = 0.0; max = 10.0; is_integer = 0}, // 9
			{min = 0.0; max = 10.0; is_integer = 0}, // 10
			{min = -10000; max = 0; is_integer = 1}, // 11
			{min = 0.0; max = 1.0; is_integer = 0}, // 12
			{min = -10000, max = 0, is_integer = 1}, // 13
			{min = 0.0, max = 10.0, is_integer = 0}, // 14
			{min = 0.0, max = 10.0, is_integer = 0}, // 15
			{min = 0.0, max = 10.0, is_integer = 0}, // 16
			{min = 0.0, max = 10.0, is_integer = 0}, // 17
			{min = 0x0, max = 0x8, is_integer = 1}) // 18
	// Alpha
	var/list/echo_param_names = list(
			"Direct",
			"Direct (High Frequency)",
			"Room",
			"Room (High Frequency)",
			"Obstruction",
			"Obstruction (Low Frequency Ratio)",
			"Occlusion",
			"Occlusion (Low Frequency Ratio)",
			"Occlusion (Room Ratio)",
			"Occlusion (Direct Ratio)",
			"Exclusion",
			"Exclusion (Low Frequency Ratio)",
			"Outside Volume (High Frequency)",
			"Doppler Factor",
			"Rolloff Factor",
			"Room Rolloff Factor",
			"Air Absorption Factor",
			"Flags")
	// Beta
	var/list/echo_param_desc = list(
			"direct path level (at low and mid frequencies)",
			"relative direct path level at high frequencies ",
			"room effect level (at low and mid frequencies)",
			"relative room effect level at high frequencies",
			"main obstruction control (attenuation at high frequencies)",
			"obstruction low-frequency level re. main control",
			"main occlusion control (attenuation at high frequencies)",
			"occlusion low-frequency level re. main control",
			"relative occlusion control for room effect",
			"relative occlusion control for direct path",
			"main exlusion control (attenuation at high frequencies)",
			"exclusion low-frequency level re. main control",
			"outside sound cone level at high frequencies",
			"like DS3D flDopplerFactor but per source",
			"like DS3D flRolloffFactor but per source",
			"like DS3D flRolloffFactor but for room effect",
			"multiplies AirAbsorptionHF member of environment reverb properties.",
			{"
			Bit flags that modify the behavior of properties
			•1 - Automatic setting of 'Direct' due to distance from listener
			•2 - Automatic setting of 'Room' due to distance from listener
			•4 - Automatic setting of 'RoomHF' due to distance from listener"})



/namespace/synthesized_instruments/shared
	// Global list of available channels.
	var/list/_free_channels



/namespace/synthesized_instruments/shared/New()
	src._free_channels = list()
	var/s_type = /namespace/synthesized_instruments/player
	var/reserved_channels = initial(s_type:reserved_channels) // Good ol' hacks

	for (var/i=1 to synthesized_instruments.enums.BYOND_MAX_CHANNELS)
		if (i in reserved_channels) continue
		src._free_channels += i



/namespace/synthesized_instruments/enums
	var/const/MIN_ENV_ID = -1
	var/const/CUSTOM_ENV_INDEX = 28
	var/const/CUSTOM_ENV_ID = 26
	var/const/INDEX_TO_ID_DIFF = 2
	var/const/BYOND_MAX_CHANNELS = 1024

	var/const/LINEAR_ADSR = 0
	var/const/EXPONENTIAL_ADSR = 1
	// Just in case someone implement other kinds of ADSR
	var/const/CUSTOM_ADSR = 2



/namespace/synthesized_instruments/functions/proc/environment_to_id(environment)
	if (environment in src.all_environments)
		return src.all_environments.Find(environment) - synthesized_instruments.enums.INDEX_TO_ID_DIFF
	return synthesized_instruments.enums.MIN_ENV_ID


/namespace/synthesized_instruments/functions/proc/id_to_environment(id)
	if (synthesized_instruments.enums.MIN_ENV_ID <= id && synthesized_instruments.enums.CUSTOM_ENV_ID >= id)
		return src.all_environments[id+synthesized_instruments.enums.INDEX_TO_ID_DIFF]
	return "None"


/namespace/synthesized_instruments/functions/proc/index_to_id(index)
	var/bounded = min(index-synthesized_instruments.enums.INDEX_TO_ID_DIFF, synthesized_instruments.enums.CUSTOM_ENV_ID)
	bounded = max(bounded, synthesized_instruments.enums.MIN_ENV_ID)
	return bounded


/namespace/synthesized_instruments/functions/proc/is_custom_env(id)
	return src.id_to_environment(id) == "Custom"


/namespace/synthesized_instruments/functions/proc/sanitize_tempo(new_tempo)
	new_tempo = abs(new_tempo)
	return max(round(new_tempo, world.tick_lag), world.tick_lag)



/namespace/synthesized_instruments/sample_pair
	var/sample
	var/deviation = 0

	New(sample_file, deviation)
		src.sample = sample_file
		src.deviation = deviation



/namespace/synthesized_instruments/bound
	var/min = 0
	var/max = 0
	var/is_integer = 0


/namespace/synthesized_instruments/bound/proc/in_bounds(val)
	return (val in src.min to src.max) && (round(val) == val)



/*
/datum/musical_config/proc/fast_num2text(key) // Used instead of num2text for faster access in sample_map
	if (!src.num2text_cached.len)
		CRASH("num2text_cached did not initialize properly")

	if (0 == key)
		return "0" // Fuck you BYOND

	if (!isnum(key) || 0 > key || 127 < key)
		CRASH("n2t argument must be an integer from 0 to 127")

	return src.num2text_cached[key]

Even though it is 3 times as fast as stock num2text, it only gives marginable performance boost
Dumbing down this section.
*/