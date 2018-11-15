
/datum/armourspecials/regeneration
	var/active = 1
	var/next_active_time = 0
	var/regen_rate = 2
	var/emp_disable_duration = 100
	var/damage_disable_duration = 70
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
		heal_tick()
	else if(world.time >= next_active_time)
		active = 1

/datum/armourspecials/regeneration/handle_shield(mob/m,damage,atom/damage_source)
	. = 0

	//taking damage disables regeneration
	if(damage > 0)
		active = 0
		next_active_time = world.time + damage_disable_duration

/datum/armourspecials/regeneration/proc/heal_tick()
	if(owner)
		//heal wounds
		for(var/obj/item/organ/external/e in owner.bad_external_organs)
			for(var/datum/wound/w in e.wounds)
				w.damage -= regen_rate

		// Heals normal damage.
		if(owner.getBruteLoss())
			owner.adjustBruteLoss(-4)
		if(owner.getFireLoss())
			owner.adjustFireLoss(-4)
		if(owner.getToxLoss())
			owner.adjustToxLoss(-8)
		if(owner.getOxyLoss())
			owner.adjustOxyLoss(-8)

		if (prob(10))
			var/obj/item/organ/external/head/D = owner.organs_by_name["head"]
			if (D.disfigured && !owner.getBruteLoss() && !owner.getFireLoss())
				D.disfigured = 0

		for(var/obj/item/organ/I in owner.internal_organs)
			if(I.damage > 0)
				I.damage = max(I.damage - 2, 0)
				if (prob(1))
					to_chat(src, "<span class='warning'>You sense your [I.name] regenerating...</span>")

		if (prob(10))
			for(var/limb_type in owner.species.has_limbs)
				var/obj/item/organ/external/E = owner.organs_by_name[limb_type]
				for(var/datum/wound/W in E.wounds)
					if (W.wound_damage() == 0 && prob(50))
						E.wounds -= W
