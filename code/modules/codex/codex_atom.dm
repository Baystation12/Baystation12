/**
 * The codex entry name to use for this atom. By default, itself. Used for items that should direct to a codex entry
 * other than itself, such as Fleet lore.
 *
 * Returns instance of `/atom` or string.
 */
/atom/proc/get_codex_value()
	return src

/**
 * Retrieves the atom's codex entry, generating a new one if not already cached.
 *
 * Returns instance of `/datum/codex_entry` or `FALSE` if there's no codex data to generate.
 */
/atom/proc/get_specific_codex_entry()
	if(SScodex.entries_by_path[type])
		return SScodex.entries_by_path[type]

	var/lore = get_lore_info()
	var/mechanics = get_mechanics_info()
	var/interactions = html_list_dl(get_interactions_info())
	if (interactions)
		mechanics += "<h4>Interactions</h4>[interactions]"
	var/antag = get_antag_info()
	interactions = html_list_dl(get_antag_interactions_info())
	if (interactions)
		antag += "<h4>Interactions</h4>[interactions]"
	if(!lore && !mechanics && !antag)
		return FALSE

	var/datum/codex_entry/entry = new(name, list(type), _lore_text = lore, _mechanics_text = mechanics, _antag_text = antag)
	return entry

/**
 * Handler for displaying information in the Mechanics section of the atom's codex entry.
 *
 * Returns string.
 */
/atom/proc/get_mechanics_info()
	return

// Constants for use to describe special handlers in `get_interactions_info()`. These allow for consistant key names for overriding and stacking purposes.
// Click handlers
/atom/var/const/CODEX_INTERACTION_ALT_CLICK = "ALT+CLICK"
/atom/var/const/CODEX_INTERACTION_ALT_SHIFT_CLICK = "ALT+SHIFT+CLICK"
/atom/var/const/CODEX_INTERACTION_CTRL_CLICK = "CTRL+CLICK"
/atom/var/const/CODEX_INTERACTION_CTRL_ALT_CLICK = "CTRL+ALT+CLICK"
/atom/var/const/CODEX_INTERACTION_CTRL_ALT_SHIFT_CLICK = "CTRL+ALT+SHIFT+CLICK"
/atom/var/const/CODEX_INTERACTION_CTRL_SHIFT_CLICK = "CTRL+SHIFT+CLICK"
/atom/var/const/CODEX_INTERACTION_SHIFT_CLICK = "SHIFT+CLICK"

// Use handlers
/atom/var/const/CODEX_INTERACTION_USE_SELF = "Use On Self"
/atom/var/const/CODEX_INTERACTION_HAND = "Empty Hand"

// Other cases
/atom/var/const/CODEX_INTERACTION_EMAG = "Cryptographic Sequencer (EMAG)"
/atom/var/const/CODEX_INTERACTION_EMP = "EMP"

/**
 * Handler for displaying information on tool interations in the Mechanics section of the atom's codex entry.
 *
 * Returns associative list of strings. Best practice is to append information to existing entries with `+=`, if present (This is null safe), i.e.:
 * ```dm
 * . = ..()
 * .["Screwdriver"] += "<p>Toggles the maintenance panel open and closed.</p>"
 * ```
 */
/atom/proc/get_interactions_info()
	RETURN_TYPE(/list)
	return list()

/**
 * Handler for displaying information in the Antagonist section of the atom's codex entry.
 *
 * Returns string.
 */
/atom/proc/get_antag_info()
	return


/**
 * Handler for displaying information on tool interations in the Antagonist section of the atom's codex entry.
 *
 * Returns associative list of strings. Best practice is to append information to existing entries with `+=`, if present (This is null safe), i.e.:
 * ```dm
 * . = ..()
 * .["Screwdriver"] += "<p>Toggles the maintenance panel open and closed.</p>"
 * ```
 */
/atom/proc/get_antag_interactions_info()
	RETURN_TYPE(/list)
	return list()

/**
 * Handler for displaying information in the Lore section of the atom's codex entry.
 *
 * Returns string.
 */
/atom/proc/get_lore_info()
	return

/atom/examine(mob/user, distance, infix = "", suffix = "")
	. = ..()
	var/datum/codex_entry/entry = SScodex.get_codex_entry(get_codex_value())
	//This odd check v is done in case an item only has antag text but someone isn't an antag, in which case they shouldn't get the notice
	if(entry && (entry.lore_text || entry.mechanics_text || (entry.antag_text && player_is_antag(user.mind))) && user.can_use_codex())
		to_chat(user, "<span class='notice'>The codex has <b><a href='?src=\ref[SScodex];show_examined_info=\ref[src];show_to=\ref[user]'>relevant information</a></b> available.</span>")
