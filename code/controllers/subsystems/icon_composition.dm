/// Icon composition. Target the normal over/underlay cache.
var/global/const/ATOM_ICON_CACHE_NORMAL = FLAG(0)

/// Icon composition. Target the protected over/underlay cache.
var/global/const/ATOM_ICON_CACHE_PROTECTED = FLAG(1)

/// Icon composition. If relevant, target both normal and protected over/underlay caches.
var/global/const/ATOM_ICON_CACHE_ALL = (ATOM_ICON_CACHE_NORMAL | ATOM_ICON_CACHE_PROTECTED)


SUBSYSTEM_DEF(icon_composition)
	name = "Icon Composition"
	flags = SS_TICKER
	wait = 1 // ticks
	priority = SS_PRIORITY_ICON_COMPOSITION
	init_order = SS_INIT_ICON_COMPOSITION

	/// The queue of atoms that need under/overlay updates.
	var/static/list/atom/queue = list()

	/// A list([icon] = list([state] = [appearance], ...), ...) cache of appearances.
	var/static/list/state_cache = list()

	/// A list([icon] = [appearance], ...) cache of appearances.
	var/static/list/icon_cache = list()

	/// The number of appearances currently cached.
	var/static/cache_size = 0


/datum/controller/subsystem/icon_composition/Recover()
	queue.Cut()
	state_cache.Cut()
	icon_cache.Cut()
	cache_size = 0
	for (var/atom/atom)
		CLEAR_FLAGS(atom.atom_flags, ATOM_AWAITING_COMPOSITION_UPDATE)
		CHECK_TICK


/datum/controller/subsystem/icon_composition/Initialize(timeofday)
	fire(FALSE, TRUE)


/datum/controller/subsystem/icon_composition/UpdateStat(time)
	if (PreventUpdateStat(time))
		return ..()
	..({"Queued Atoms: [length(queue)], Cache Size: [cache_size]"})


/datum/controller/subsystem/icon_composition/fire(resumed, no_mc_tick)
	var/cut_until = 1
	for (var/atom/atom as anything in queue)
		++cut_until
		if (QDELETED(atom))
			continue
		if (atom.atom_flags & ATOM_AWAITING_UNDERLAY_UPDATE)
			atom.UpdateUnderlays()
		if (atom.atom_flags & ATOM_AWAITING_OVERLAY_UPDATE)
			atom.UpdateOverlays()
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			queue.Cut(1, cut_until)
			return
	queue.Cut()


/datum/controller/subsystem/icon_composition/proc/GetStateAppearance(icon, state)
	var/list/subcache = state_cache[icon]
	if (!subcache)
		subcache = list()
		state_cache[icon] = subcache
	if (!subcache[state])
		var/image/image = image(icon, null, state)
		subcache[state] = image.appearance
		++cache_size
	return subcache[state]


/datum/controller/subsystem/icon_composition/proc/GetIconAppearance(icon)
	if (!icon_cache[icon])
		var/image/image = image(icon)
		icon_cache[icon] = image.appearance
		++cache_size
	return icon_cache[icon]


/datum/controller/subsystem/icon_composition/proc/GetAppearanceList(atom/subject, list/sources)
	if (!sources)
		return list()
	if (!islist(sources))
		sources = list(sources)
	var/list/result = list()
	var/icon/icon = subject.icon
	for (var/atom/entry as anything in sources)
		if (!entry)
			continue
		else if (istext(entry))
			result += GetStateAppearance(icon, entry)
		else if (isicon(entry))
			result += GetIconAppearance(entry)
		else
			if (isloc(entry))
				if (GET_FLAGS(entry.atom_flags, ATOM_AWAITING_COMPOSITION_UPDATE))
					entry.ImmediateCompositionUpdate()
			if (!ispath(entry))
				result += entry.appearance
			else
				var/image/image = entry
				result += image.appearance
	return result


/// Immediately runs an underlay and overlay update, and dequeues the atom
/atom/proc/ImmediateCompositionUpdate()
	SHOULD_NOT_OVERRIDE(TRUE)
	SSicon_composition.queue -= src
	UpdateUnderlays()
	UpdateOverlays()


/**
* Shared behavior for CutOverlays & CutUnderlays. Do not use directly.
* null: nothing changed, do nothing
* FALSE: update should be queued
* TRUE: update should be queued, cache should be nulled
*/
/atom/proc/CutCacheBehavior(sources, cache)
	SHOULD_NOT_OVERRIDE(TRUE)
	var/initial_length = length(cache)
	if (!initial_length)
		return
	cache -= sources
	var/after_length = length(cache)
	if (!after_length)
		return TRUE
	if (initial_length > after_length)
		return FALSE


/// Enqueues the atom for an overlay update if not already queued
/atom/proc/QueueOverlayUpdate()
	SHOULD_NOT_OVERRIDE(TRUE)
	if (GET_FLAGS(atom_flags, ATOM_AWAITING_OVERLAY_UPDATE))
		return
	SET_FLAGS(atom_flags, ATOM_AWAITING_OVERLAY_UPDATE)
	SSicon_composition.queue += src


/// Builds the atom's overlay state from caches
/atom/proc/UpdateOverlays()
	SHOULD_NOT_OVERRIDE(TRUE)
	if (gc_destroyed)
		if (length(overlays))
			overlays.Cut()
		return
	CLEAR_FLAGS(atom_flags, ATOM_AWAITING_OVERLAY_UPDATE)
	if (length(atom_protected_overlay_cache))
		if (length(atom_overlay_cache))
			overlays = atom_protected_overlay_cache + atom_overlay_cache
		else
			overlays = atom_protected_overlay_cache
	else if (length(atom_overlay_cache))
		overlays = atom_overlay_cache
	else
		overlays.Cut()


/// Clears the atom's overlay cache(s) and queues an update if needed. Use CLEAR_TARGET_* flags.
/atom/proc/ClearOverlays(cache_target = ATOM_ICON_CACHE_NORMAL)
	SHOULD_NOT_OVERRIDE(TRUE)
	if (cache_target & ATOM_ICON_CACHE_PROTECTED)
		if (!atom_protected_overlay_cache)
			return
		atom_protected_overlay_cache.Cut()
		atom_protected_overlay_cache = null
		QueueOverlayUpdate()
	if (cache_target & ATOM_ICON_CACHE_NORMAL)
		if (!atom_overlay_cache)
			return
		atom_overlay_cache.Cut()
		atom_overlay_cache = null
		QueueOverlayUpdate()


/**
 * Adds specific overlay(s) to the atom.
 * It is designed so any of the types allowed to be added to /atom/overlays can be added here too. More details below.
 *
 * @param sources The overlay(s) to add. These may be
 *	- A string: In which case it is treated as an icon_state of the atom's icon.
 *	- An icon: It is treated as an icon.
 *	- An atom: Its own overlays are compiled and then it's appearance is added. (Meaning its current apperance is frozen).
 *	- An image: Image's apperance is added (i.e. subsequently editing the image will not edit the overlay)
 *	- A type path: Added to overlays as is.  Does whatever it is BYOND does when you add paths to overlays.
 *	- Or a list containing any of the above.
 * @param cache_target If ATOM_ICON_CACHE_PROTECTED, add to the protected cache instead of normal.
 */
/atom/proc/AddOverlays(sources, cache_target = ATOM_ICON_CACHE_NORMAL)
	SHOULD_NOT_OVERRIDE(TRUE)
	if (!sources)
		return
	sources = SSicon_composition.GetAppearanceList(src, sources)
	if (!length(sources))
		return
	if (cache_target & ATOM_ICON_CACHE_PROTECTED)
		if (atom_protected_overlay_cache)
			atom_protected_overlay_cache += sources
		else
			atom_protected_overlay_cache = sources
	else if (atom_overlay_cache)
		atom_overlay_cache += sources
	else
		atom_overlay_cache = sources
	QueueOverlayUpdate()


/**
 * Removes specific overlay(s) from the atom's normal or protected overlay cache and queue an update.
 *
 * @param overlays The overlays to removed. See AddOverlays for legal source types.
 * @param cache_target A mask of ICON_CACHE_TARGET_*.
 */
/atom/proc/CutOverlays(sources, cache_target = ATOM_ICON_CACHE_NORMAL)
	SHOULD_NOT_OVERRIDE(TRUE)
	if (!sources)
		return
	sources = SSicon_composition.GetAppearanceList(src, sources)
	if (!length(sources))
		return
	var/update
	if (cache_target & ATOM_ICON_CACHE_PROTECTED)
		var/outcome = CutCacheBehavior(sources, atom_protected_overlay_cache)
		if (!isnull(outcome))
			update = TRUE
			if (outcome == TRUE)
				atom_protected_overlay_cache = null
	if (cache_target & ATOM_ICON_CACHE_NORMAL)
		var/outcome = CutCacheBehavior(sources, atom_overlay_cache)
		if (!isnull(outcome))
			update = TRUE
			if (outcome == TRUE)
				atom_overlay_cache = null
	if (update)
		QueueOverlayUpdate()


/// AddOverlays with ClearOverlays first. See AddOverlays for behavior.
/atom/proc/SetOverlays(sources, cache_target = ATOM_ICON_CACHE_NORMAL)
	SHOULD_NOT_OVERRIDE(TRUE)
	ClearOverlays(cache_target)
	AddOverlays(sources, cache_target)


/**
 * Copy the overlays from another atom.
 *
 * @param other The atom to copy overlays from.
 * @param clear If TRUE, clear before adding other's overlays.
 * @param cache_target A mask of ICON_CACHE_TARGET_* indicating what to copy.
 */
/atom/proc/CopyOverlays(atom/other, clear, cache_target = ATOM_ICON_CACHE_NORMAL)
	SHOULD_NOT_OVERRIDE(TRUE)
	if (clear)
		ClearOverlays(cache_target)
	if (!istype(other))
		return
	if (cache_target & ATOM_ICON_CACHE_PROTECTED)
		AddOverlays(other.atom_protected_overlay_cache, ATOM_ICON_CACHE_PROTECTED)
	if (cache_target & ATOM_ICON_CACHE_NORMAL)
		AddOverlays(other.atom_overlay_cache, ATOM_ICON_CACHE_NORMAL)


/// Enqueues the atom for an underlay update if not already queued
/atom/proc/QueueUnderlayUpdate()
	SHOULD_NOT_OVERRIDE(TRUE)
	if (GET_FLAGS(atom_flags, ATOM_AWAITING_OVERLAY_UPDATE))
		return
	SET_FLAGS(atom_flags, ATOM_AWAITING_OVERLAY_UPDATE)
	SSicon_composition.queue += src


/// Builds the atom's underlay state from caches
/atom/proc/UpdateUnderlays()
	SHOULD_NOT_OVERRIDE(TRUE)
	if (gc_destroyed)
		if (length(underlays))
			underlays.Cut()
		return
	CLEAR_FLAGS(atom_flags, ATOM_AWAITING_OVERLAY_UPDATE)
	if (length(atom_protected_underlay_cache))
		if (length(atom_underlay_cache))
			underlays = atom_protected_underlay_cache + atom_underlay_cache
		else
			underlays = atom_protected_underlay_cache
	else if (length(atom_underlay_cache))
		underlays = atom_underlay_cache
	else
		underlays.Cut()


/// Clears the atom's underlay cache(s) and queues an update if needed. Use CLEAR_TARGET_* flags.
/atom/proc/ClearUnderlays(cache_target = ATOM_ICON_CACHE_NORMAL)
	SHOULD_NOT_OVERRIDE(TRUE)
	if (cache_target & ATOM_ICON_CACHE_PROTECTED)
		if (!atom_protected_underlay_cache)
			return
		atom_protected_underlay_cache.Cut()
		atom_protected_underlay_cache = null
		QueueUnderlayUpdate()
	if (cache_target & ATOM_ICON_CACHE_NORMAL)
		if (!atom_underlay_cache)
			return
		atom_underlay_cache.Cut()
		atom_underlay_cache = null
		QueueUnderlayUpdate()


/**
 * Adds specific underlay(s) to the atom.
 * It is designed so any of the types allowed to be added to /atom/underlays can be added here too. More details below.
 *
 * @param sources The underlay(s) to add. These may be
 *	- A string: In which case it is treated as an icon_state of the atom's icon.
 *	- An icon: It is treated as an icon.
 *	- An atom: Its own underlays are compiled and then it's appearance is added. (Meaning its current apperance is frozen).
 *	- An image: Image's apperance is added (i.e. subsequently editing the image will not edit the underlay)
 *	- A type path: Added to underlays as is.  Does whatever it is BYOND does when you add paths to underlays.
 *	- Or a list containing any of the above.
 * @param cache_target If ATOM_ICON_CACHE_PROTECTED, add to the protected cache instead of normal.
 */
/atom/proc/AddUnderlays(sources, cache_target = ATOM_ICON_CACHE_NORMAL)
	SHOULD_NOT_OVERRIDE(TRUE)
	if (!sources)
		return
	sources = SSicon_composition.GetAppearanceList(src, sources)
	if (!length(sources))
		return
	if (cache_target & ATOM_ICON_CACHE_PROTECTED)
		if (atom_protected_underlay_cache)
			atom_protected_underlay_cache += sources
		else
			atom_protected_underlay_cache = sources
	else if (atom_underlay_cache)
		atom_underlay_cache += sources
	else
		atom_underlay_cache = sources
	QueueUnderlayUpdate()


/**
 * Removes specific underlay(s) from the atom's normal or protected underlay cache and queue an update.
 *
 * @param underlays The underlays to removed. See AddUnderlays for legal source types.
 * @param cache_target A mask of ICON_CACHE_TARGET_*.
 */
/atom/proc/CutUnderlays(sources, cache_target = ATOM_ICON_CACHE_NORMAL)
	SHOULD_NOT_OVERRIDE(TRUE)
	if (!sources)
		return
	sources = SSicon_composition.GetAppearanceList(src, sources)
	if (!length(sources))
		return
	var/update
	if (cache_target & ATOM_ICON_CACHE_PROTECTED)
		var/outcome = CutCacheBehavior(sources, atom_protected_underlay_cache)
		if (!isnull(outcome))
			update = TRUE
			if (outcome == TRUE)
				atom_protected_underlay_cache = null
	if (cache_target & ATOM_ICON_CACHE_NORMAL)
		var/outcome = CutCacheBehavior(sources, atom_underlay_cache)
		if (!isnull(outcome))
			update = TRUE
			if (outcome == TRUE)
				atom_underlay_cache = null
	if (update)
		QueueUnderlayUpdate()


/// AddUnderlays with ClearUnderlays first. See AddUnderlays for behavior.
/atom/proc/SetUnderlays(sources, cache_target = ATOM_ICON_CACHE_NORMAL)
	SHOULD_NOT_OVERRIDE(TRUE)
	ClearUnderlays(cache_target)
	AddUnderlays(sources, cache_target)


/**
 * Copy the underlays from another atom.
 *
 * @param other The atom to copy underlays from.
 * @param clear If TRUE, clear before adding other's underlays.
 * @param cache_target A mask of ICON_CACHE_TARGET_* indicating what to copy.
 */
/atom/proc/CopyUnderlays(atom/other, clear, cache_target = ATOM_ICON_CACHE_NORMAL)
	SHOULD_NOT_OVERRIDE(TRUE)
	if (clear)
		ClearUnderlays(cache_target)
	if (!istype(other))
		return
	if (cache_target & ATOM_ICON_CACHE_PROTECTED)
		AddUnderlays(other.atom_protected_underlay_cache, ATOM_ICON_CACHE_PROTECTED)
	if (cache_target & ATOM_ICON_CACHE_NORMAL)
		AddUnderlays(other.atom_underlay_cache, ATOM_ICON_CACHE_NORMAL)


// Skin-deep API parity for images.
// Reference <https://www.byond.com/docs/ref/#/atom/var/overlays> for permitted types.

/// Adds sources to the image's overlays.
/image/proc/AddOverlays(sources)
	SHOULD_NOT_OVERRIDE(TRUE)
	overlays += sources


/// Removes sources from the image's overlays.
/image/proc/CutOverlays(sources)
	SHOULD_NOT_OVERRIDE(TRUE)
	overlays -= sources


/// Removes all of the image's overlays.
/image/proc/ClearOverlays()
	SHOULD_NOT_OVERRIDE(TRUE)
	overlays.Cut()


/// Copies the overlays from the atom other, clearing first if set, and using the caches indicated.
/image/proc/CopyOverlays(atom/other, clear, cache_target = ATOM_ICON_CACHE_ALL)
	SHOULD_NOT_OVERRIDE(TRUE)
	if (clear)
		overlays.Cut()
	if (!istype(other))
		return
	if (cache_target & ATOM_ICON_CACHE_PROTECTED)
		overlays |= other.atom_protected_overlay_cache
	if (cache_target & ATOM_ICON_CACHE_NORMAL)
		overlays |= other.atom_overlay_cache


/// Adds sources to the image's underlays.
/image/proc/AddUnderlays(sources)
	SHOULD_NOT_OVERRIDE(TRUE)
	underlays += sources


/// Removes sources from the image's underlays.
/image/proc/CutUnderlays(sources)
	SHOULD_NOT_OVERRIDE(TRUE)
	underlays -= sources


/// Removes all of the image's underlays.
/image/proc/ClearUnderlays()
	SHOULD_NOT_OVERRIDE(TRUE)
	underlays.Cut()


/// Copies the underlays from the atom other, clearing first if set, and using the caches indicated.
/image/proc/CopyUnderlays(atom/other, clear, cache_target = ATOM_ICON_CACHE_ALL)
	SHOULD_NOT_OVERRIDE(TRUE)
	if (clear)
		underlays.Cut()
	if (!istype(other))
		return
	if (cache_target & ATOM_ICON_CACHE_PROTECTED)
		underlays |= other.atom_protected_underlay_cache
	if (cache_target & ATOM_ICON_CACHE_NORMAL)
		underlays |= other.atom_underlay_cache
