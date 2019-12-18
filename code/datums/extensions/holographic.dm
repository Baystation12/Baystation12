/datum/extension/holographic
	base_type = /datum/extension/holographic
	expected_type = /atom
	var/holographic = TRUE
	flags = EXTENSION_FLAG_IMMEDIATE
	var/holo_alpha = 0.8

/datum/extension/holographic/New(var/atom/holder)
	..()

	if(!istype(holder, /turf)) // Don't want the floors to be see-through
		holder.alpha *= holo_alpha

	if(ismovable(holder))
		GLOB.moved_event.register(holder, src, .proc/OnMovement)

	if(istype(src,/obj/structure))
		var/obj/structure/O = src
		O.breakable = FALSE
		O.parts = null

	MakeContentsHolographic(holder)

/datum/extension/holographic/proc/MakeContentsHolographic(var/atom/item)
	for(var/object in item)
		var/atom/A = object
		if(!A.simulated)
			continue
		set_extension(A, /datum/extension/holographic)

/datum/extension/holographic/Destroy(var/atom/holder)
	if(holder)
		holder.alpha /= holo_alpha
		if(ismob(holder))
			var/mob/M = holder
			M.death(null, "fades away!", "You have been destroyed.")
		if(ismovable(holder))
			GLOB.moved_event.unregister(holder, src, .proc/OnMovement)
	. = ..()

/datum/extension/holographic/proc/DestroyHolographicContents(var/atom/item) //recursively check for holographic items within containers and delete them, or non-holographic items within holographic containers and drop them.
	for(var/hi in item)
		var/atom/movable/held_item = hi
		if(has_extension(held_item,/datum/extension/holographic))
			if(held_item.contents)
				DestroyHolographicContents(held_item)
			qdel(held_item)
		else
			held_item.dropInto(item.loc)

/datum/extension/holographic/proc/ValidTarget(var/atom/A)
	. = ..()
	var/turf/T = get_turf(A)
	if(!has_extension(T,/datum/extension/holographic))
		. = FALSE

/datum/extension/holographic/proc/OnMovement(var/atom/mover, var/old_location, var/new_location)
	if(get_area(old_location) != get_area(new_location))
		DestroyHolographicContents(mover)
		qdel(mover)

/datum/extension/holographic/proc/attackby(obj/item/W as obj, mob/user as mob)
	if(is_type_in_list(src,list(/obj/structure,/obj/machinery)))
		if(W.iswrench() || W.isscrewdriver() || W.iscrowbar() || W.iswirecutter()) // don't want tools interacting with holographic machinery/structures, this should cover deconstruction actions
			return
	..()

/datum/extension/holographic/proc/dismantle() // disable dismantling holographic objects
	return TRUE
