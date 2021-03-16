// Attached to surrogate mobs that are being controlled by a living occupant in VR.
// Virtual mobs can return to their occupant at any time, and vanish on death.
// This file also includes VR-related verbs.
// This extension has a lot of custom logic. Gibbing and brainmobs are disabled on virtual mobs, for instance.
/datum/extension/virtual_surrogate
	base_type = /datum/extension/virtual_surrogate
	expected_type = /mob

	var/mob/living/virtual_mob
	var/mob/living/real_mob

/datum/extension/virtual_surrogate/Destroy()
	GLOB.death_event.unregister(virtual_mob, SSvirtual_reality, /datum/controller/subsystem/virtual_reality/proc/remove_virtual_mob)
	GLOB.death_event.unregister(real_mob, SSvirtual_reality, /datum/controller/subsystem/virtual_reality/proc/remove_virtual_mob)
	GLOB.destroyed_event.unregister(virtual_mob, SSvirtual_reality, /datum/controller/subsystem/virtual_reality/proc/remove_virtual_mob)
	GLOB.destroyed_event.unregister(real_mob, SSvirtual_reality, /datum/controller/subsystem/virtual_reality/proc/remove_virtual_mob)
	. = ..()

/datum/extension/virtual_surrogate/proc/set_mob(mob/living/new_mob)
	real_mob = new_mob
	virtual_mob = holder
	new_mob.verbs += /mob/living/proc/exit_vr_mob
	new_mob.verbs += /mob/living/proc/clear_reagents_vr
	new_mob.verbs += /mob/living/proc/rejuvenate_self_vr
	new_mob.verbs += /mob/living/proc/toggle_max_skills_vr
	GLOB.death_event.register(virtual_mob, SSvirtual_reality, /datum/controller/subsystem/virtual_reality/proc/remove_virtual_mob, virtual_mob)
	GLOB.death_event.register(real_mob, SSvirtual_reality, /datum/controller/subsystem/virtual_reality/proc/remove_virtual_mob, real_mob)
	GLOB.destroyed_event.register(virtual_mob, SSvirtual_reality, /datum/controller/subsystem/virtual_reality/proc/remove_virtual_mob, real_mob)
	GLOB.destroyed_event.register(real_mob, SSvirtual_reality, /datum/controller/subsystem/virtual_reality/proc/remove_virtual_mob, real_mob)

// VR verbs. Being completely virtual, people controlling VR mobs can do a bunch of stuff.
/mob/living/proc/exit_vr_mob()
	set name = "\[Exit VR\]"
	set desc = "Exits your virtual mob, and returns to your normal body."
	set category = "VR"
	set src = usr

	SSvirtual_reality.remove_virtual_mob(src)

/mob/living/proc/clear_reagents_vr()
	set name = "Clear Reagents"
	set desc = "Removes any reagents in your stomach and bloodstream."
	set category = "VR"
	set src = usr

	if (reagents)
		to_chat(usr, SPAN_NOTICE("You clear your virtual body of reagents."))
		reagents.clear_reagents()

/mob/living/proc/rejuvenate_self_vr()
	set name = "Rejuvenate"
	set desc = "Fully undoes any kind of damage on your body, as well as clearing reagents and stuns."
	set category = "VR"
	set src = usr

	rejuvenate()
	if (ishuman(src))
		var/mob/living/carbon/human/H = src
		usr.client.prefs.copy_to(H) // Redo hair, augments, and limbs after rejuvenating
		H.set_nutrition(400)
		H.set_hydration(400)
	to_chat(usr, SPAN_NOTICE("You fully rejuvenate your virtual body."))

/datum/skill_buff/virtual_reality
	limit = 1

/mob/living/proc/toggle_max_skills_vr()
	set name = "Toggle Max Skills"
	set desc = "Become a master in all skills. Useful for allowing you to compare your own skills to a fully-learned professional's."
	set category = "VR"
	set src = usr

	var/mob/living/user = usr
	var/list/vr_buffs = user.fetch_buffs_of_type(/datum/skill_buff/virtual_reality)
	if (vr_buffs.len)
		for (var/datum/skill_buff/virtual_reality/VRB in vr_buffs)
			VRB.remove()
		to_chat(user, SPAN_NOTICE("You fall back to your own skills, remembering your own knowledge and training."))
	else
		var/list/buffs = list()
		for (var/decl/hierarchy/skill/S in GLOB.skills)
			buffs[S.type] = SKILL_PROF
		user.buff_skill(buffs, buff_type = /datum/skill_buff/virtual_reality)
		to_chat(user, SPAN_NOTICE("You connect yourself to a database and augment your skills. Your virtual body is now a master in all skills."))
