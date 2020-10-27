// Abstract type for preference record providers
// Implemented by ~things~ that can fill out preferences
/datum/pref_record_reader

/datum/pref_record_reader/New()
	CRASH("abstract - must be overridden")

/datum/pref_record_reader/proc/get_version()
	CRASH("abstract - must be overridden")

/datum/pref_record_reader/proc/read(key)
	CRASH("abstract - must be overridden")


// Abstract type for preference record writers
/datum/pref_record_writer

/datum/pref_record_writer/New()
	CRASH("abstract - must be overridden")

/datum/pref_record_writer/proc/write(key, val)
	CRASH("abstract - must be overridden")


// Preference reader for legacy savefiles
// Version must be manually passed, as it's only present at the root
/datum/pref_record_reader/savefile
	var/savefile
	var/version

/datum/pref_record_reader/savefile/New(savefile, version)
	src.savefile = savefile
	src.version = version

/datum/pref_record_reader/savefile/get_version()
	return version

/datum/pref_record_reader/savefile/read(key)
	return savefile[key]


// Preference reader for assoc lists
// Version should be in the "__VERSION" key
/datum/pref_record_reader/json_list
	var/list/data

/datum/pref_record_reader/json_list/New(list/data)
	src.data = data
	ASSERT(istype(data))
	ASSERT(isnum(get_version()))

/datum/pref_record_reader/json_list/get_version()
	return read("__VERSION")

/datum/pref_record_reader/json_list/read(key)
	return data[key]


// Null preference reader
// Returns null for all keys; used when initializing records
/datum/pref_record_reader/null
	var/version

/datum/pref_record_reader/null/New(version)
	src.version = version

/datum/pref_record_reader/null/get_version()
	return version

/datum/pref_record_reader/null/read(key)
	return null


// Preference writer for assoc lists
// Version should be passed in, will be placed in "__VERSION"
/datum/pref_record_writer/json_list
	var/list/data

/datum/pref_record_writer/json_list/New(version)
	ASSERT(isnum(version))
	data = list("__VERSION"=version)

/datum/pref_record_writer/json_list/write(key, val)
	data[key] = val
