/*
/datum/effect_system
	var/atom/movable/holder	
		- The atom that this effect_system is attached to.
	var/no_del
		- If this effect_system should be deleted at end of processing.

/datum/effect_system/New(var/queue = TRUE, var/persistant = FALSE)
- queue: 		if the effect should be queued for processing after creation
- persistent: 	if the effect should not be destroyed at the end of processing.


/datum/effect_system/proc/queue()
- Called when the object is queued for update. Overriding procs should call ..()

/datum/effect_system/process()
- Called when the processor processes this effect. 
	Return ..() to allow default behavior of self-destroying after one tick.
	Alternately; EFFECT_HALT, EFFECT_CONTINUE, and EFFECT_DESTROY can be used to tell the processor what to do with the object.

/datum/effect_system/proc/bind(var/target)
- Binds this effect_system to an object and prevents it from being destroyed by the collector, assuming the derived class returns ..() on process().


*/
