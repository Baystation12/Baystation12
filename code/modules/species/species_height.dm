/// Integer. The minimum height for the species in centimeters.
/datum/species/var/min_height = 145 // ~4'9"

/// Integer. The maximum height for the species in centimeters.
/datum/species/var/max_height = 203 // ~6'8"


/**
 * Whether or not the given height value falls within the species' minimum and maximum height values.
 *
 * **Parameters**:
 * - `height` (integer) - The height value to check in centimeters.
 *
 * Returns boolean.
 */
/datum/species/proc/height_is_valid(height)
	return height >= min_height && height <= max_height


/**
 * Retrieves the average height for the species, as the number immediately between min and max.
 *
 * Returns integer.
 */
/datum/species/proc/get_average_height()
	return round((max_height - min_height + 1) / 2)


/**
 * Returns a height descriptor for the given height, relative to the species min and max heights.
 *
 * **Parameters**:
 * - `height` - The height value to check in centimeters.
 *
 * Returns string. A height descriptor as defined in `/datum/mob_descriptor/height`.
 */
/datum/species/proc/get_height_descriptor(height)
	var/datum/mob_descriptor/height/descriptor = new()
	var/descriptor_count = descriptor.standalone_value_descriptors.len

	// Math magic to determine what heights apply to what descriptor based on min and max height
	var/height_block = (max_height - min_height + 1) / descriptor_count
	for (var/count = 1 to descriptor_count)
		var/height_threshhold = round(height_block * count)
		if (height <= height_threshhold)
			return descriptor.standalone_value_descriptors[count]
