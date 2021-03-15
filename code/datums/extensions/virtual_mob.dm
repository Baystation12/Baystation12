// Attached to surrogate mobs that are being controlled by a living occupant in VR.
// Virtual mobs can return to their occupant at any time, and vanish on death.
/datum/extension/virtual_mob
	base_type = /datum/extension/virtual_mob
	expected_type = /mob

	var/mob/living/virtual_mob
	var/mob/living/real_mob

/datum/extension/virtual_mob/Destroy()
	GLOB.death_event.unregister(virtual_mob, SSvirtual_reality, /datum/controller/subsystem/virtual_reality/proc/remove_virtual_mob)
	GLOB.death_event.unregister(real_mob, SSvirtual_reality, /datum/controller/subsystem/virtual_reality/proc/remove_virtual_mob)
	GLOB.destroyed_event.unregister(virtual_mob, SSvirtual_reality, /datum/controller/subsystem/virtual_reality/proc/remove_virtual_mob)
	GLOB.destroyed_event.unregister(real_mob, SSvirtual_reality, /datum/controller/subsystem/virtual_reality/proc/remove_virtual_mob)
	. = ..()

/datum/extension/virtual_mob/proc/set_mob(mob/living/new_mob)
	real_mob = new_mob
	virtual_mob = holder
	new_mob.verbs += /mob/living/proc/exit_vr_mob
	new_mob.verbs += /mob/living/proc/clear_reagents_vr
	new_mob.verbs += /mob/living/proc/rejuvenate_self_vr
	GLOB.death_event.register(virtual_mob, SSvirtual_reality, /datum/controller/subsystem/virtual_reality/proc/remove_virtual_mob, virtual_mob)
	GLOB.death_event.register(real_mob, SSvirtual_reality, /datum/controller/subsystem/virtual_reality/proc/remove_virtual_mob, real_mob)
	GLOB.destroyed_event.register(virtual_mob, SSvirtual_reality, /datum/controller/subsystem/virtual_reality/proc/remove_virtual_mob, real_mob)
	GLOB.destroyed_event.register(real_mob, SSvirtual_reality, /datum/controller/subsystem/virtual_reality/proc/remove_virtual_mob, real_mob)
