#define EXTENSION_SCAN_TYPE_ALL				(~0)
#define EXTENSION_SCAN_TYPE_LIFE			1	// Generic lifeform scan
#define EXTENSION_SCAN_TYPE_HEALTH			2	// Detailed health scan
#define EXTENSION_SCAN_TYPE_GAS				4
#define EXTENSION_SCAN_TYPE_HEAT			8
#define EXTENSION_SCAN_TYPE_RADIO			16	// Radio signal scan
#define EXTENSION_SCAN_TYPE_ANOMALY			32	// Exotic science stuff

/datum/extension/scan
	expected_type = /atom
	var/atom/atom_holder
	var/allowed_scan_types = EXTENSION_SCAN_TYPE_ALL

/datum/extension/scan/New(var/datum/holder, var/disallowed_scan_types = 0)
	..()
	atom_holder = holder
	allowed_scan_types &= ~disallowed_scan_types

/datum/extension/scan/Destroy()
	atom_holder = null
	return ..()

/datum/extension/scan/proc/GetAllowedContent(var/scan_type, var/target_type)
	// Check if returns are allowed for this kind of scan
	if (allowed_scan_types & scan_type)
		return GetContent(target_type)
	return null

/datum/extension/scan/proc/GetDifficulty()
	//Can return a value between 0.0 and 1.0, representing the difficulty of scanning the content of this object.
	//How that affects the scan is up to the scanner to decide
	return 0

/datum/extension/scan/proc/GetContent(var/target_type)
	// Implementation logic for specific holder types should override this
	var/list/matches = list()
	for(var/O in atom_holder.contents)
		if (istype(O, target_type))
			matches.Add(O)
	return matches
