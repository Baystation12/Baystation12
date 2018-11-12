
/datum/armourspecials/regeneration
	var/active = 1
	var/next_active_time = 0
	var/regen_rate = 2
	var/emp_disable_duration = 100
	var/obj/item/worn
	var/mob/living/carbon/human/owner

/datum/armourspecials/regeneration/tryemp(var/severity)
	if(owner)
		to_chat(owner, "<span class='danger'>The EMP temporarily disables your [worn] regeneration!</span>")
	active = 0
	next_active_time = world.time + max(emp_disable_duration * severity, emp_disable_duration / 2)

/datum/armourspecials/regeneration/on_equip(var/obj/source_armour)
	worn = source_armour
	owner = source_armour.loc
	GLOB.processing_objects += src

/datum/armourspecials/regeneration/on_drop(var/obj/source_armour)
	owner = null
	GLOB.processing_objects -= src

/datum/armourspecials/regeneration/process()
	if(active)
		if(owner)
			for(var/obj/item/organ/external/e in owner.bad_external_organs)
				for(var/datum/wound/w in e.wounds)
					w.damage -= regen_rate
		else
			GLOB.processing_objects -= src
	else if(world.time >= next_active_time)
		active = 1
