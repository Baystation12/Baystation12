/namespace/synthesized_instruments/instrument
	var/name = "Generic instrument"  // Name of the instrument
	var/id = null  // Used everywhere to distinguish between categories and actual data and to identify instruments
	var/category = null  // Used to categorize instruments
	var/list/samples = list()  // Write here however many samples, follow this syntax: "%note num%"='%sample file%' eg. "27"='synthesizer/e2.ogg'. Key must never be lower than 0 and higher than 127
	var/list/namespace/synthesized_instruments/sample_pair/sample_map = list()  // Used to modulate sounds, don't fill yourself


/namespace/synthesized_instruments/instrument/proc/create_full_sample_deviation_map()
	if (!src.samples.len)
		CRASH("No samples were defined in [src.type]")

	var/storage[128]
	for (var/key in samples)
		storage[text2num(key) + 1] = text2num(key) + 1

	while (null in storage) // Not the most efficient at all (O(n^2) at worst), but fuck it
		var/static/temp_storage[128]
		for (var/i = 1 to 128)
			if (storage[i])
				temp_storage[i] = storage[i]
				if (i > 1)
					temp_storage[i-1] = storage[i-1] ? storage[i-1] : storage[i]
				if (i < 128)
					temp_storage[i+1] = storage[i+1] ? storage[i+1] : storage[i]
		storage = temp_storage.Copy()

	for (var/i = 1 to 128)
		var/num_index = i - 1
		var/num_id = storage[i] - 1
		var/text_id = num2text(num_id)
		src.sample_map[text_id] = new (src.samples[text_id], num_index - num_id)
