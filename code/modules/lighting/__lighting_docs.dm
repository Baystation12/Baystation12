/*
	-- Aurora directional lighting system, based off of /vg/lights. --

	Documentation is present in most of the code files.
		lighting_atom.dm -> procs/vars for tracking/managing lights attached to objects.
		lighting_turf.dm -> procs/vars for managing lighting overlays bound to turfs, tracking lights affecting said turf, and getting information about the turf's light level.
		lighting_corner.dm -> contains code for tracking per-corner lighting data.
		lighting_source.dm -> contains actual light emitter datum & core lighting calculations. Directional lights and Z-lights are implemented here.
		lighting_area.dm -> contains area vars/procs for managing an area's dynamic lighting state.

*/

/*
	Useful procs when using lights:

/atom/proc/set_light(range, power, color, angle, no_update)
	desc: Sets an atom's light emission. `set_light(FALSE)` will disable the light.
	args:
		range -> the range of the light. 1.4 is the lowest possible value here.
		power -> the power (intensity) of the light. Generally should be 1 or lower. Optional.
		color -> The hex string (#FFFFFF) color of the light. Optional.
		angle -> The angle of the cone that the light should shine at (directional lighting). Behavior of lights over 180 degrees is undefined. Best to stick to using the LIGHT_ defines for this. Optional.
		no_update -> if TRUE, the light will not be updated. Useful for when making several of these calls to the same object. Optional.

/atom/proc/set_opacity(new_opacity)
	desc: Sets an atom's opacity, updating affecting lights' visibility.
	args:
		new_opacity -> the new opacity value.

/turf/proc/reconsider_lights()
	desc: Cause all lights affecting this turf to recalculate visibility.
	args: none

/turf/proc/force_update_lights()
	desc: Force all lights affecting this turf to regenerate. Slow, use reconsider_lights instead when possible.
	args: none

/turf/proc/get_avg_color()
	desc: Gets the average color of this tile as a hexadecimal color string. Used by cameras.

/turf/proc/get_lumcount(minlum = 0, maxlum = 1)
	desc: Gets the brightness of this tile. If not dynamically lit, always returns 0.5, otherwise returns the average brightness of all 4 corners, scaled between minlum and maxlum.
	args:
		minlum -> the low-bound of the scalar.
		maxlum -> the high-bound of the scalar.
*/
