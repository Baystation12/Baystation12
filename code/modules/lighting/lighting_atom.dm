/// Float. Intensity of the light within the full brightness range. Value between 0 and 1. Do not modify directly. See `set_light()`.
/atom/var/light_max_bright = 1.0
/// Integer. Range, in tiles, the light is at full brightness. Do not modify directly. See `set_light()`.
/atom/var/light_inner_range = 1
/// Integer. Range, in tiles, where the light becomes darkness. Do not modify directly. See `set_light()`.
/atom/var/light_outer_range = 0
/// Integer. Adjusts curve for falloff gradient. Must be greater than 0. Do not modify directly. See `set_light()`.
/atom/var/light_falloff_curve = 2
/// String (Hexadecimal color code). The color of the light. Do not modify directly. See `set_light()`.
/atom/var/light_color

/// The light source datum handling rendering of the light defined in the `light_*` vars on this atom. See `set_light()` and `update_light()`.
/atom/var/datum/light_source/light
/// LAZYLIST of all light sources contained within the atom and its contents. Used to propagate updates whenever somehting, i.e. position, changes.
/atom/var/list/light_sources

// Nonsensical value for l_color default, so we can detect if it gets set to null.
#define NONSENSICAL_VALUE -99999
#define DEFAULT_FALLOFF_CURVE (2)

/**
 * Sets the atom's light values and color. Calls `update_light()`.
 *
 * **Parameters**:
 * - `l_max_bright` float (0 to 1) - Intensity of the light within the full brightness range. Value between 0 and 1. Applied to `light_max_bright`.
 * - `l_inner_range` integer - Range, in tiles, the light is at full brightness. Applied to `light_inner_range`.
 * - `l_outer_range` integer - Range, in tiles, where the light becomes darkness. Do not modify directly. Applied to `light_outer_range`.
 * - `l_falloff_curbe` integer (Default `NONSENSICAL_VALUE`) - Adjusts curve for falloff gradient. Must be greater than 0. Do not modify directly. Applied to `light_falloff_curve`.
 * - `l_color` color (Default `NONSENSICAL_VALUE`) - The color of the light. Applied to `light_color`.
 *
 * Returns boolean. Whether or not the light was actually changed.
 */
/atom/proc/set_light(l_max_bright, l_inner_range, l_outer_range, l_falloff_curve = NONSENSICAL_VALUE, l_color = NONSENSICAL_VALUE)
	. = 0 //make it less costly if nothing's changed

	if(l_max_bright != null && l_max_bright != light_max_bright)
		light_max_bright = l_max_bright
		. = 1
	if(l_outer_range != null && l_outer_range != light_outer_range)
		light_outer_range = l_outer_range
		. = 1
	if(l_inner_range != null && l_inner_range != light_inner_range)
		if(light_inner_range >= light_outer_range)
			light_inner_range = light_outer_range / 4
		else
			light_inner_range = l_inner_range
		. = 1
	if(l_falloff_curve != NONSENSICAL_VALUE)
		if(!l_falloff_curve || l_falloff_curve <= 0)
			light_falloff_curve = DEFAULT_FALLOFF_CURVE
		if(l_falloff_curve != light_falloff_curve)
			light_falloff_curve = l_falloff_curve
			. = 1
	if(l_color != NONSENSICAL_VALUE && l_color != light_color)
		light_color = l_color
		. = 1

	if(.) update_light()

#undef NONSENSICAL_VALUE
#undef DEFAULT_FALLOFF_CURVE

/**
 * Updates the atom's light source datum. This is automatically called by `set_light()`.
 */
/atom/proc/update_light()
	set waitfor = FALSE

	if(!light_max_bright || !light_outer_range || light_max_bright > 1)
		if(light)
			light.destroy()
			light = null
		if(light_max_bright > 1)
			light_max_bright = 1
			CRASH("Attempted to call update_light() on atom [src] \ref[src] with a light_max_bright value greater than one")
	else
		if(!istype(loc, /atom/movable))
			. = src
		else
			. = loc

		if(light)
			light.update(.)
		else
			light = new /datum/light_source(src, .)

/atom/Destroy()
	if(light)
		light.destroy()
		light = null
	return ..()

/atom/set_opacity()
	. = ..()
	if(.)
		var/turf/T = loc
		if(istype(T))
			T.RecalculateOpacity()
