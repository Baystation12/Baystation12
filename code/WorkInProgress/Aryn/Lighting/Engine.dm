/*

Overview:
	Procs given to atom and turf by the lighting engine, as well as the lighting overlay object.

Atom Vars:
	light - Contains the light object this atom is currently shining with.

Turf Vars:
	light_overlay - Contains an object showing the lighting icon over this turf.

	lit_value - Stores how brightly lit the turf is.

	has_opaque - A cached value updated by CheckForOpaqueObjects()

	is_outside - Any turf with this set to true will be considered as bright as space.

	needs_light_update - Turf is marked for icon updates when true.

	lightNE, lightSE, lightNW, lightSW - Hold the lightpoints on the four corners of this turf. See Lightpoint.dm

	lit_by - A list of lights that are lighting this turf.

Atom Procs:
	SetLight(intensity, radius)
		A more versatile SetLuminosity() that allows independent control of intensity and radius.
		Called behind the scenes of SetLuminosity().

	SetOpacity(opacity)
		Does the same thing as DAL.

Turf Procs:
	UpdateLight()
		Called by the lighting controller. It is advisable not to call this manually due to the cost of lightpoint/max_value()

	AddLight(light/light)
		Called by light/Reset() to light this turf with a particular light.

	RemoveLight(light/light)
		Called by light/Off() to unlight turfs that were lit by it.

	ResetValue()
		Called when lights are reset or starlight is changed.

	ResetCachedValues()
		Resets cached values of all four light points. Called by ResetValue().

	CheckForOpaqueObjects()
		Called by lighting_controller.Initialize(), SetOpacity() or when a turf might change opacity.
		Resets the opacity cache and looks for opaque objects. Also responsible for adding and removing borders to space.
*/


#define LIGHTCLAMP(x) ( max(0,min(3,round(x,1))) )

atom/movable/lighting_overlay
	anchored = 1
	layer = 9
	mouse_opacity = 0
	icon = 'icons/effects/ArynLights.dmi'
	icon_state = "0000"
	invisibility = INVISIBILITY_LIGHTING

atom/var/light/light

turf/var/atom/movable/lighting_overlay/light_overlay

turf/var/lit_value = 0
turf/var/max_brightness = 0
turf/var/has_opaque = 0
turf/var/is_outside = 0
turf/var/is_border = 0
turf/var/needs_light_update = 0

turf/var/lightpoint/lightNE
turf/var/lightpoint/lightNW
turf/var/lightpoint/lightSE
turf/var/lightpoint/lightSW
turf/var/list/lit_by

atom/movable/New()
	. = ..()
	if(luminosity)
		if(!light)
			SetLight(luminosity,luminosity)
		else
			light.Reset()
	if(opacity)
		if(lighting_ready())
			opacity = 0
			SetOpacity(1)

atom/movable/Move()
	var/o = opacity
	if(o) SetOpacity(0)
	. = ..()
	if(.)
		if(o) SetOpacity(1)
		if(light)
			light.Reset()
			if(lighting_ready()) lighting_controller.FlushIconUpdates()

atom/proc/SetLight(intensity, radius)
	//if(lights_verbose) world << "SetLight([intensity],[radius])"
	if(!intensity)
		if(!light || !light.intensity)
			//if(lights_verbose) world << "Still off."
			return
		//if(lights_verbose) world << "Shut off light with [light.lit_turfs.len] turfs lit."
		light.Off()
		light.intensity = 0
		if(lighting_ready()) lighting_controller.FlushIconUpdates()
		return
	if(!light)
		//if(lights_verbose) world << "New light."
		light = new(src)
	if(light.intensity == intensity)
		//if(lights_verbose) world << "Same intensity."
		return
	light.radius = min(radius,15)
	light.intensity = intensity
	light.Reset()
	if(lighting_ready()) lighting_controller.FlushIconUpdates()

atom/proc/SetOpacity(o)
	if(o == opacity) return
	opacity = o
	var/turf/T = loc
	if(isturf(T))
		for(var/light/A in T.lit_by)
			A.Reset()
		lighting_controller.FlushIconUpdates()

turf/proc/UpdateLight()
	if(light_overlay)
		light_overlay.icon_state = "[lightSE.max_value()][lightSW.max_value()][lightNW.max_value()][lightNE.max_value()]"

turf/proc/AddLight(light/light)
	if(is_outside) return

	var/brightness = light.CalculateBrightness(src)
	if(brightness <= 0) return

	if(!lit_by) lit_by = list()
	lit_by.Add(light)


	lit_by[light] = brightness

	if(!has_opaque && lighting_ready())
		if(brightness > max_brightness)
			lit_value = LIGHTCLAMP(brightness)
			max_brightness = brightness
			ResetCachedValues()
			for(var/turf/T in range(1,src))
				lighting_controller.MarkIconUpdate(T)

turf/proc/RemoveLight(light/light)
	if(lit_by)
		var/brightness = lit_by[light]
		lit_by.Remove(light)
		if(brightness == max_brightness)
			ResetValue()
		if(!lit_by.len) lit_by = null

//Only called by ChangeTurf, because it really needs it.
turf/proc/ResetAllLights()
	for(var/light/light in lit_by)
		light.Reset()

/turf/space/ResetAllLights()
	var/atom/movable/lighting_overlay/overlay = locate() in src
	overlay.loc = null
	light_overlay = null
	is_outside = 1
	. = ..()

turf/proc/ResetValue()
	if(is_outside)
		max_brightness = lighting_controller.starlight
		lit_value = LIGHTCLAMP(lighting_controller.starlight)
		return

	CheckForOpaqueObjects()
	if(has_opaque)
		lit_value = 0
	else
		the_part_where_I_calculate_brightness()

	if(lighting_ready())
		the_part_where_I_use_range()

turf/proc
	the_part_where_I_calculate_brightness()
		max_brightness = 0
		for(var/light/light in lit_by)
			var/brightness = lit_by[light]//light.CalculateBrightness(src)
			if(brightness > max_brightness)
				max_brightness = brightness
		lit_value = LIGHTCLAMP(max_brightness)

	the_part_where_I_use_range()
		ResetCachedValues()
		for(var/turf/T in range(1,src))
			lighting_controller.MarkIconUpdate(T)

turf/proc/ResetCachedValues()
	if(lightNE)
		lightNE.cached_value = -1
	if(lightNW)
		lightNW.cached_value = -1
	if(lightSE)
		lightSE.cached_value = -1
	if(lightSW)
		lightSW.cached_value = -1

turf/proc/CheckForOpaqueObjects()
	has_opaque = opacity
	if(!opacity)
		for(var/atom/movable/M in contents)
			if(M.opacity)
				has_opaque = 1
				break

#undef LIGHTCLAMP