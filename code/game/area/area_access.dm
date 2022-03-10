
/**
 * List of strings (`access_*`). Required access flags to access the area. Used for autosetting access
 *   on doors. Nested lists indicate an 'OR' structure.
 *
 * Examples:
 * ```
 * list(ACCESS_ONE, ACCESS_TWO) // This requires both ACCESS_ONE and ACCESS_TWO
 * list(list(ACCESS_ONE, ACCESS_TWO)) // This requires either ACCESS_ONE or ACCESS_TWO
 * list(ACCESS_THREE, list(ACCESS_ONE, ACCESS_TWO)) // This requires ACCCESS_THREE and either ACCESS_ONE or ACCESS_TWO
 * ```
 */
/area/var/list/req_access = list()


/**
 * Boolean. Unsecure areas will have doors between them use `req_access_diff()` (Only access flags not shared by both
 *   areas). Secure areas use `req_access_union()` (All access flags between both areas).
 *
 * Examples, where area one has `req_access = list(ACCESS_ONE, ACCESS_TWO)` and area two has
 *   `req_access = list(ACCESS_TWO, ACCESS_THREE)`:
 * ```
 * // Doors where `secure = FALSE` for both areas:
 * req_access = list(ACCESS_ONE, ACCESS_THREE)
 * // Doors where `secure = TRUE` for either area:
 * req_access = list(ACCESS_ONE, ACCESS_TWO, ACCESS_THREE)
 * ```
 */
/area/var/secure = TRUE


/**
 * Given two areas, finds the minimal `req_access` needed to access either area, with the assumption that shared
 *   access flags are not needed. Used when both areas are unsecure.
 *
 * Returns a new list of strings (`access_*`).
 *
 * Example:
 * ```
 * req_access_union(list(ACCESS_ONE, ACCESS_TWO), list(ACCESS_TWO, ACCESS_THREE))
 * // Output:
 * list(ACCESS_ONE, ACCESS_THREE)
 * ```
 */
/proc/req_access_diff(area/first, area/second)
	if(!length(first.req_access))
		return second.req_access.Copy()
	if(!length(second.req_access))
		return first.req_access.Copy()
	. = list()
	for(var/requirement in first.req_access)
		add_access_requirement(., get_minimal_requirement(second.req_access, requirement))
	for(var/requirement in second.req_access)
		add_access_requirement(., get_minimal_requirement(first.req_access, requirement))


/**
 * Given two areas, finds the maximal `req_access` needed to access either area, including shared access flags. Used
 *   when either area is secure.
 *
 * Returns a new list of strings (`access_*`).
 *
 * Example:
 * ```
 * req_access_union(list(ACCESS_ONE, ACCESS_TWO), list(ACCESS_TWO, ACCESS_THREE))
 * // Output:
 * list(ACCESS_ONE, ACCESS_TWO, ACCESS_THREE)
 * ```
 */
/proc/req_access_union(area/first, area/second)
	if(!length(first.req_access))
		return second.req_access.Copy()
	if(!length(second.req_access))
		return first.req_access.Copy()
	. = first.req_access.Copy()
	for(var/requirement in second.req_access)
		add_access_requirement(., requirement)


/**
 * Determines if required access `requirement` is already accounted for in `req_access`. If so, returns `null`. If not,
 *   returns a copy of `requirement`. If `requirement` is a list, individually checks each entry and only returns
 *   `requirement` if there's no duplicate entries.
 *
 * Parameters:
 * - `req_access`: List of strings (`access_*`). The access list to compare against.
 * - `requirement`: Single string (`access_*`) or list of strings (`access_*`). The access flag(s) to check and return.
 *
 * Returns `null` or a copy of `requirement`.
 *
 * Examples:
 * ```
 * get_minimal_requirement(list(ACCESS_ONE, ACCESS_TWO), ACCESS_ONE)
 * // Output
 * null
 *
 * get_minimal_requirement(list(ACCESS_ONE, ACCESS_TWO), ACCESS_THREE)
 * // Output
 * ACCESS_THREE
 *
 * get_minimal_requirement(list(ACCESS_ONE, ACCESS_TWO), list(ACCESS_TWO, ACCESS_THREE))
 * // Output
 * null
 *
 * get_minimal_requirement(list(ACCESS_ONE, ACCESS_TWO), list(ACCESS_THREE, ACCESS_FOUR))
 * // Output
 * list(ACCESS_THREE, ACCESS_FOUR)
 * ```
 */
/proc/get_minimal_requirement(list/req_access, list/requirement)
	if(!requirement)
		return
	if(!islist(requirement))
		return (requirement in req_access) ? null : requirement
	for(var/req in req_access)
		if(req in requirement)
			return // have one of the requirements, and these use AND, so we're good
		if(islist(req))
			var/fully_contained = TRUE // In this case we check if we are already requiring something more stringent than the new thing.
			for(var/one_req in req)
				if(!(one_req in requirement))
					fully_contained = FALSE
					break
			if(fully_contained)
				return
	return requirement.Copy()


/**
 * Adds a new requirement to `req_access`, avoiding duplicates using `get_minimal_requirement()`.
 *
 * Directly modifies `req_access`.
 */
/proc/add_access_requirement(list/req_access, requirement)
	var/minimal = get_minimal_requirement(req_access, requirement)
	if(minimal)
		req_access[++req_access.len] = minimal
