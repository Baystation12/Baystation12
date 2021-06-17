GLOBAL_DATUM_INIT(musical_config, /datum/musical_config, new)

/datum/musical_config
	var/highest_octave = 9
	var/lowest_octave = 0

	var/highest_transposition = 4
	var/lowest_transposition = -4

	var/longest_sustain_timer = 50
	var/gentlest_drop = 1.07
	var/steepest_drop = 10.0

	var/channels_per_instrument = 128
	var/max_lines = 1000
	var/max_line_length = 50
	var/max_events = 2400
	var/song_editor_lines_per_page = 20

	var/usage_info_channel_resolution = 1
	var/usage_info_event_resolution = 8

	var/env_settings_available = 1

	var/list/env_default = list(7.5, 1.0, -1000, -100, 0, 1.49, 0.83, 1.0, -2602, 0.0007, 200, 0.011, 0.25, 0.0, 0.25, 0.0, -5.0, 5000, 250.0, 0.0, 100, 100, 63)
	var/list/list/env_params_bounds = list(
			list(1, 100, 1),
			list(0, 1, 1),
			list(-10000, 0, 1),
			list(-10000, 0, 1),
			list(-10000, 0, 1),
			list(0.1, 20, 1),
			list(0.1, 2.0, 1),
			list(0.1, 2.0, 1),
			list(-10000, 1000, 0),
			list(0, 0.3, 1),
			list(-10000, 2000, 0),
			list(0, 0.1, 1),
			list(0.075, 0.25, 1),
			list(0, 1, 1),
			list(0.04, 4.0, 1),
			list(0, 1, 1),
			list(-100, 0.0, 1),
			list(1000, 20000, 0),
			list(20, 1000, 1),
			list(0, 10, 1),
			list(0, 100, 1),
			list(0, 100, 1),
			list(0, 256, 0))
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
- 1 - 'EnvSize' affects reverberation decay time
- 2 - 'EnvSize' affects reflection level
- 4 - 'EnvSize' affects initial reflection delay time
- 8 - 'EnvSize' affects reflections level
- 16 - 'EnvSize' affects late reverberation delay time
- 32 - AirAbsorptionHF affects DecayHFRatio
- 64 - 'EnvSize' affects echo time
- 128 - 'EnvSize' affects modulation time"})

	var/list/echo_default = list(0, 0, 0, 0, 0, 0.0, 0, 0.25, 1.5, 1.0, 0, 1.0, 0, 0.0, 0.0, 0.0, 1.0, 7)
	var/list/list/echo_params_bounds = list(
			list(-10000, 1000, 0),
			list(-10000, 0, 0),
			list(-10000, 1000, 0),
			list(-10000, 0, 0),
			list(-10000, 0, 0),
			list(0, 1, 1),
			list(-10000, 0, 0),
			list(0, 1, 1),
			list(0, 10, 1),
			list(0, 10, 1),
			list(-10000, 0, 0),
			list(0, 1, 1),
			list(-10000, 0, 0),
			list(0, 10, 1),
			list(0, 10, 1),
			list(0, 10, 1),
			list(0, 10, 1),
			list(0, 16, 0))
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
			- 1 - Automatic setting of 'Direct' due to distance from listener
			- 2 - Automatic setting of 'Room' due to distance from listener
			- 4 - Automatic setting of 'RoomHF' due to distance from listener"})

	var/list/n2t_int = list() // Instead of num2text it is used for faster access in n2t
	var/list/nn2no = list(0,2,4,5,7,9,11) // Maps note num onto note offset



/datum/musical_config/proc/n2t(key) // Used instead of num2text for faster access in sample_map
	if (!src.n2t_int.len)
		for (var/i=1, i<=127, i++)
			src.n2t_int += num2text(i)

	if (key==0)
		return "0" // Fuck you BYOND
	if (!isnum(key) || key < 0 || key>127 || round(key) != key)
		CRASH("n2t argument must be an integer from 0 to 127")
	return src.n2t_int[key]


/datum/musical_config/proc/environment_to_id(environment)
	if (environment in src.all_environments)
		return list_find(src.all_environments, environment) - 2
	return -1


/datum/musical_config/proc/id_to_environment(id)
	if (id >= -1 && id <= 26)
		return src.all_environments[id+2]
	return "None"


/datum/musical_config/proc/index_to_id(index)
	return max(min(index-2, 26), -1)


/datum/musical_config/proc/is_custom_env(id)
	return id_to_environment(id) == src.all_environments[28]


/datum/sample_pair
	var/sample
	var/deviation = 0

/datum/sample_pair/New(sample_file, deviation)
	src.sample = sample_file
	src.deviation = deviation