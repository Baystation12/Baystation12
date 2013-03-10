/*
	Modified DynamicAreaLighting for TGstation - Coded by Carnwennan

	This is TG's 'new' lighting system. It's basically a heavily modified combination of Forum_Account's and
	ShadowDarke's respective lighting libraries. Credits, where due, to them.

	Like sd_DAL (what we used to use), it changes the shading overlays of areas by splitting each type of area into sub-areas
	by using the var/tag variable and moving turfs into the contents list of the correct sub-area. This method is
	much less costly than using overlays or objects.

	Unlike sd_DAL however it uses a queueing system. Everytime we call a change to opacity or luminosity
	(through SetOpacity() or SetLuminosity()) we are  simply updating variables and scheduling certain lights/turfs for an
	update. Actual updates are handled periodically by the lighting_controller. This carries additional overheads, however it
	means that each thing is changed only once per lighting_controller.processing_interval ticks. Allowing for greater control
	over how much priority we'd like lighting updates to have. It also makes it possible for us to simply delay updates by
	setting lighting_controller.processing = 0 at say, the start of a large explosion, waiting for it to finish, and then
	turning it back on with lighting_controller.processing = 1.

	Unlike our old system there are hardcoded maximum luminositys (different for certain atoms).
	This is to cap the cost of creating lighting effects.
	(without this, an atom with luminosity of 20 would have to update 41^2 turfs!) :s

	Also, in order for the queueing system to work, each light remembers the effect it casts on each turf. This is going to
	have larger memory requirements than our previous system but it's easily worth the hassle for the greater control we
	gain. It also reduces cost of removing lighting effects by a lot!

	Known Issues/TODO:
		Shuttles still do not have support for dynamic lighting (I hope to fix this at some point)
		No directional lighting support. (prototype looked ugly)
*/

#define LIGHTING_CIRCULAR 1									//comment this out to use old square lighting effects.
#define LIGHTING_LAYER 10									//Drawing layer for lighting overlays
#define LIGHTING_ICON 'icons/effects/ss13_dark_alpha6.dmi'	//Icon used for lighting shading effects

datum/light_source
	var/atom/owner
	var/changed = 1
	var/list/effect = list()
	var/__x = 0		//x coordinate at last update
	var/__y = 0		//y coordinate at last update


	New(atom/A)
		if(!istype(A))
			CRASH("The first argument to the light object's constructor must be the atom that is the light source. Expected atom, received '[A]' instead.")
		..()
		owner = A
		__x = owner.x
		__y = owner.y
		// the lighting object maintains a list of all light sources
		lighting_controller.lights += src


	//Check a light to see if its effect needs reprocessing. If it does, remove any old effect and create a new one
	proc/check()
		if(!owner)
			remove_effect()
			return 1	//causes it to be removed from our list of lights. The garbage collector will then destroy it.

		// check to see if we've moved since last update
		if(owner.x != __x || owner.y != __y)
			__x = owner.x
			__y = owner.y
			changed = 1

		if(changed)
			changed = 0
			remove_effect()
			return add_effect()
		return 0


	proc/remove_effect()
		// before we apply the effect we remove the light's current effect.
		for(var/turf/T in effect)	// negate the effect of this light source
			T.update_lumcount(-effect[T])
		effect.Cut()					// clear the effect list

	proc/add_effect()
		// only do this if the light is turned on and is on the map
		if(owner.loc && owner.luminosity > 0)
			effect = new_effect()						// identify the effects of this light source
			for(var/turf/T in effect)
				T.update_lumcount(effect[T])			// apply the effect
			return 0
		else
			owner.light = null
			return 1	//cause the light to be removed from the lights list and garbage collected once it's no
						//longer referenced by the queue

	proc/new_effect()
		. = list()
		var/range = owner.get_light_range()
		for(var/turf/T in view(range, owner))
			var/change_in_lumcount = lum(T)
			if(change_in_lumcount > 0)
				.[T] = change_in_lumcount
		return .


	proc/lum(turf/A)
#ifdef LIGHTING_CIRCULAR
		return owner.luminosity - cheap_hypotenuse(A.x,A.y,__x,__y)
#else
		return owner.luminosity - max(abs(A.x-__x),abs(A.y-__y))
#endif

atom
	var/datum/light_source/light


//Turfs with opacity when they are constructed will trigger nearby lights to update
//Turfs and atoms with luminosity when they are constructed will create a light_source automatically
turf/New()
	..()
	if(luminosity)
		if(light)	warning("[type] - Don't set lights up manually during New(), We do it automatically.")
		light = new(src)

//Movable atoms with opacity when they are constructed will trigger nearby lights to update
//Movable atoms with luminosity when they are constructed will create a light_source automatically
atom/movable/New()
	..()
	if(opacity)
		if(isturf(loc))
			if(loc:lighting_lumcount > 1)
				UpdateAffectingLights()
	if(luminosity)
		if(light)	warning("[type] - Don't set lights up manually during New(), We do it automatically.")
		light = new(src)

//Objects with opacity will trigger nearby lights to update at next lighting process.
atom/movable/Del()
	if(opacity)
		if(isturf(loc))
			if(loc:lighting_lumcount > 1)
				UpdateAffectingLights()
	return ..()

//Sets our luminosity.
//If we have no light it will create one.
//If we are setting luminosity to 0 the light will be cleaned up by the controller and garbage collected once all its
//queues are complete.
//if we have a light already it is merely updated, rather than making a new one.
atom/proc/SetLuminosity(new_luminosity)
	if(new_luminosity < 0)
		new_luminosity = 0
	if(light)
		if(luminosity != new_luminosity)	//non-luminous lights are removed from the lights list in add_effect()
			light.changed = 1
	else
		if(new_luminosity)
			light = new(src)
	luminosity = new_luminosity

area/SetLuminosity(new_luminosity)			//we don't want dynamic lighting for areas
	luminosity = new_luminosity


//change our opacity (defaults to toggle), and then update all lights that affect us.
atom/proc/SetOpacity(new_opacity)
	if(new_opacity == null)
		new_opacity = !opacity			//default = toggle opacity
	else if(opacity == new_opacity)
		return 0						//opacity hasn't changed! don't bother doing anything
	opacity = new_opacity				//update opacity, the below procs now call light updates.
	return 1

turf/SetOpacity(new_opacity)
	if(..()==1)							//only bother if opacity changed
		if(lighting_lumcount)			//only bother with an update if our turf is currently affected by a light
			UpdateAffectingLights()

/atom/movable/SetOpacity(new_opacity)
	if(..()==1)							//only bother if opacity changed
		if(isturf(loc))					//only bother with an update if we're on a turf
			var/turf/T = loc
			if(T.lighting_lumcount)		//only bother with an update if our turf is currently affected by a light
				UpdateAffectingLights()


turf
	var/lighting_lumcount = 0
	var/lighting_changed = 0

turf/space
	lighting_lumcount = 4		//starlight

turf/proc/update_lumcount(amount)
	lighting_lumcount += amount
	if(!lighting_changed)
		lighting_controller.changed_turfs += src
		lighting_changed = 1

turf/proc/shift_to_subarea()
	lighting_changed = 0
	var/area/Area = loc

	if(!istype(Area) || !Area.lighting_use_dynamic) return

	// change the turf's area depending on its brightness
	// restrict light to valid levels
	var/light = min(max(round(lighting_lumcount,1),0),lighting_controller.lighting_states)

	var/find = findtextEx(Area.tag, "sd_L")
	var/new_tag = copytext(Area.tag, 1, find)
	new_tag += "sd_L[light]"

	if(Area.tag!=new_tag)	//skip if already in this area

		var/area/A = locate(new_tag)	// find an appropriate area

		if(!A)

			A = new Area.type()    // create area if it wasn't found
			// replicate vars
			for(var/V in Area.vars)
				switch(V)
					if("contents","lighting_overlay","overlays")	continue
					else
						if(issaved(Area.vars[V])) A.vars[V] = Area.vars[V]

			A.tag = new_tag
			A.lighting_subarea = 1
			A.SetLightLevel(light)

			Area.related += A

		A.contents += src	// move the turf into the area

area
	var/lighting_use_dynamic = 1	//Turn this flag off to prevent sd_DynamicAreaLighting from affecting this area
	var/image/lighting_overlay		//tracks the darkness image of the area for easy removal
	var/lighting_subarea = 0		//tracks whether we're a lighting sub-area

	proc/SetLightLevel(light)
		if(!src) return
		if(light <= 0)
			light = 0
			luminosity = 0
		else
			if(light > lighting_controller.lighting_states)
				light = lighting_controller.lighting_states
			luminosity = 1

		if(lighting_overlay)
			overlays -= lighting_overlay
			lighting_overlay.icon_state = "[light]"
		else
			lighting_overlay = image(LIGHTING_ICON,,num2text(light),LIGHTING_LAYER)

		overlays += lighting_overlay

	proc/InitializeLighting()	//TODO: could probably improve this bit ~Carn
		if(!tag) tag = "[type]"
		if(!lighting_use_dynamic)
			if(!lighting_subarea)	// see if this is a lighting subarea already
			//show the dark overlay so areas, not yet in a lighting subarea, won't be bright as day and look silly.
				SetLightLevel(4)

#undef LIGHTING_LAYER
#undef LIGHTING_CIRCULAR
//#undef LIGHTING_ICON
#define LIGHTING_MAX_LUMINOSITY_STATIC	8	//Maximum luminosity to reduce lag.
#define LIGHTING_MAX_LUMINOSITY_MOBILE	5	//Moving objects have a lower max luminosity since these update more often. (lag reduction)
#define LIGHTING_MAX_LUMINOSITY_TURF	1	//turfs have a severely shortened range to protect from inevitable floor-lighttile spam.

//set the changed status of all lights which could have possibly lit this atom.
//We don't need to worry about lights which lit us but moved away, since they will have change status set already
//This proc can cause lots of lights to be updated. :(
atom/proc/UpdateAffectingLights()
	for(var/atom/A in oview(LIGHTING_MAX_LUMINOSITY_STATIC-1,src))
		if(A.light)
			A.light.changed = 1			//force it to update at next process()

//caps luminosity effects max-range based on what type the light's owner is.
atom/proc/get_light_range()
	return min(luminosity, LIGHTING_MAX_LUMINOSITY_STATIC)

atom/movable/get_light_range()
	return min(luminosity, LIGHTING_MAX_LUMINOSITY_MOBILE)

obj/machinery/light/get_light_range()
	return min(luminosity, LIGHTING_MAX_LUMINOSITY_STATIC)

turf/get_light_range()
	return min(luminosity, LIGHTING_MAX_LUMINOSITY_TURF)

#undef LIGHTING_MAX_LUMINOSITY_STATIC
#undef LIGHTING_MAX_LUMINOSITY_MOBILE
#undef LIGHTING_MAX_LUMINOSITY_TURF