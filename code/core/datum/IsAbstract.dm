/**
* Abstract-ness is a meta-property of a class that is used to indicate
* that the class is intended to be used as a base class for others, and
* should not (or cannot) be instantiated.
* We have no such language concept in DM, and so we provide a datum member
* that can be used to hint at abstractness for circumstances where we would
* like that to be the case, such as base behavior providers.
*/

/// If set, a path at/above this one that expects not to be instantiated.
/datum/var/abstract_type

/// If true, this datum is an instance of an abstract type. Oops.
/datum/proc/IsAbstract()
	SHOULD_NOT_OVERRIDE(TRUE)
	return type == abstract_type

/// Passed a path or instance, returns whether it is abstract. Otherwise null.
/proc/is_abstract(datum/thing)
	if (ispath(thing))
		return thing == initial(thing.abstract_type)
	if (istype(thing))
		return thing.IsAbstract()
