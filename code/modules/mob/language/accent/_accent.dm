/**
 * Accents
 * Selectable tags that show up in chat before a spoken line.
 * Accents are mostly associated with a place or culture.
 * Some languages use their own accent rather than the one set by the user.
 */

/decl/accent
	abstract_type = /decl/accent
	var/name
	var/state
	var/code
	var/desc
	var/icon/icon


/decl/accent/New()
	if (state)
		icon = icon('icons/accents.dmi', state)


/decl/accent/proc/GetTag(client/recipient)
	if (!icon)
		return ""
	var/pref = recipient?.get_preference_value(/datum/client_preference/accent_tags)
	if (!pref || pref == GLOB.PREF_HIDE)
		return ""
	if (pref == GLOB.PREF_PLAIN)
		return code
	return icon2html(icon, recipient, realsize = TRUE, class = "text_tag")


/decl/accent/none
	name = "None"
	desc = "System accent for preventing an accent from showing."


/decl/accent/unknown
	name = "Unknown"
	state = "unknown"
	code = "???"
	desc = "An unrecognizable accent."


GLOBAL_LIST_EMPTY(accent_name_to_path)
GLOBAL_LIST_EMPTY(accent_path_to_name)

/hook/startup/proc/populate_glob_accents()
	for (var/decl/accent/path as anything in subtypesof(/decl/accent))
		var/name = initial(path.name)
		GLOB.accent_name_to_path[name] = path
		GLOB.accent_path_to_name[path] = name
	return TRUE


/datum/client_preference/accent_tags
	description = "Show Accent Tags"
	key = "accent_tags"
	options = list(
		GLOB.PREF_FANCY,
		GLOB.PREF_PLAIN,
		GLOB.PREF_HIDE
	)


//TODO: put this in the proper place and build all the allowed_accents sets
/// The accents this background permits, if any.
