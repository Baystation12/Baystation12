/obj/item/organ/internal/augment/active/internal_air_system
	name = "internal air system"
	augment_slots = AUGMENT_CHEST
	icon_state = "internal_air_system"
	desc = "A flexible air sac, made from a complex, bio-compatible polymer, is installed into the respiratory system. It gradually replenishes itself with breathable gas from the surrounding environment as you breathe, and you can later use it as a source of internals."
	augment_flags = AUGMENT_BIOLOGICAL | AUGMENT_SCANNABLE
	origin_tech = list(TECH_MATERIAL = 3, TECH_BIO = 4)
	var/obj/item/tank/emergency/air_sac/sac


/obj/item/organ/internal/augment/active/internal_air_system/hidden
	augment_flags = AUGMENT_BIOLOGICAL


/obj/item/organ/internal/augment/active/internal_air_system/onInstall()
	sac = new (owner)
	sac.air_contents.adjust_gas(owner.species.breath_type, (STD_BREATH_VOLUME * 3) * sac.air_contents.volume / (R_IDEAL_GAS_EQUATION * T20C), 0) // Give us a few free breaths
	to_chat(owner, SPAN_NOTICE("You feel a curious sensation as your [sac.name] starts puffing up inside your body.\n\
	Remember that you'll still need an airtight mask or helmet to use it!"))


/obj/item/organ/internal/augment/active/internal_air_system/onRemove()
	QDEL_NULL(sac)


/obj/item/organ/internal/augment/active/internal_air_system/Process()
	if (!owner || !owner.species || !sac)
		return
	var/safe_gas = owner.species.breath_type
	if (!sac.air_contents.gas[safe_gas] && sac.air_contents.return_pressure()) // Fallback in case of species switch or etc - purge all air if the gas type is no longer safe
		sac.air_contents.remove_volume(sac.air_contents.volume)
		to_chat(owner, SPAN_WARNING("You feel your [sac.name] rapidly deflate as it purges unsafe air."))
		return
	sac.distribute_pressure = owner.species.breath_pressure ? owner.species.breath_pressure : ONE_ATMOSPHERE
	if (owner.internal || sac.air_contents.return_pressure() >= 1013) // Don't refill unless we're breathing normally
		return
	var/turf/T = get_turf(owner)
	var/datum/gas_mixture/E = T.return_air_for_internal_lifeform()
	if (E.get_gas(safe_gas))
		var/datum/gas_mixture/breath = E.remove_volume(owner.species.breath_pressure * 0.25)
		sac.air_contents.adjust_gas(safe_gas, breath.get_gas(safe_gas)) // "Inhale" a breath of gas for the sac
		if (sac.air_contents.return_pressure() >= 1013)
			to_chat(owner, SPAN_NOTICE("Your [sac.name] stops filling as it reaches maximum pressure."))


/obj/item/organ/internal/augment/active/internal_air_system/activate()
	if (!owner || !owner.species || (owner.internal && owner.internal != sac))
		return
	if (!sac)
		to_chat(owner, SPAN_WARNING("Your [name]'s sac is missing or punctured!"))
		return
	if (sac.air_contents.return_pressure() < owner.species.breath_pressure)
		to_chat(owner, SPAN_WARNING("Your [name]'s [sac.name] is empty!"))
		return
	if (!(owner.wear_mask && owner.wear_mask.item_flags & ITEM_FLAG_AIRTIGHT))
		if (!(owner.head && owner.head.item_flags & ITEM_FLAG_AIRTIGHT))
			to_chat(owner, SPAN_WARNING("You need a valid mask or helmet equipped. You still need to exhale!"))
			return
	if (!owner.internal)
		owner.set_internals(sac, "\the [sac] in your [name]")
	else
		owner.set_internals(null)
	return TRUE
