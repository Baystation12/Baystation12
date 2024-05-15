/obj/item/material/shard
	name = "shard"
	icon = 'icons/obj/materials/shards.dmi'
	icon_state = "large"
	randpixel = 8
	sharp = TRUE
	edge = TRUE
	w_class = ITEM_SIZE_SMALL
	max_force = 8
	force_multiplier = 0.12 // 6 with hardness 30 (glass)
	thrown_force_multiplier = 0.4 // 4 with weight 15 (glass)
	item_state = "shard-glass"
	attack_verb = list("stabbed", "slashed", "sliced", "cut")
	default_material = MATERIAL_GLASS
	unbreakable = TRUE
	drops_debris = FALSE
	item_flags = ITEM_FLAG_CAN_HIDE_IN_SHOES
	var/step_sound = 'sound/effects/glass_step.ogg'
	var/embed_prob = 12


/obj/item/material/shard/set_material(new_material)
	..(new_material)
	if (!istype(material))
		return
	icon_state = "[material.shard_icon][pick("large", "medium", "small")]"
	update_icon()
	if (material.shard_type)
		SetName("[material.display_name] [material.shard_type]")
		desc = "A small piece of [material.display_name]. It looks sharp, you wouldn't want to step on it barefoot. Could probably be used as ... a throwing weapon?"
		switch (material.shard_type)
			if (SHARD_SPLINTER, SHARD_SHRAPNEL)
				gender = PLURAL
			else
				gender = NEUTER
	else
		qdel(src)


/obj/item/material/shard/on_update_icon()
	if (material)
		color = material.icon_colour
		// 1-(1-x)^2, so that glass shards with 0.3 opacity end up somewhat visible at 0.51 opacity
		var/inverse_opacity = 1 - material.opacity
		alpha = 255 * (1 - inverse_opacity * inverse_opacity)
	else
		color = "#ffffff"
		alpha = 255


/obj/item/material/shard/use_tool(obj/item/item, mob/living/user, list/click_params)
	if(isWelder(item) && material.shard_can_repair)
		var/obj/item/weldingtool/welder = item
		if (!welder.can_use(1, user))
			return TRUE
		welder.remove_fuel(1, user)
		material.place_sheet(get_turf(src))
		qdel(src)
		return TRUE
	return ..()


/obj/item/material/shard/Crossed(atom/movable/movable)
	if (!isliving(movable))
		return
	var/mob/living/carbon/human/human = movable
	if (human.buckled)
		return
	playsound(src, step_sound, 50, TRUE)
	if (!istype(human))
		to_chat(human, SPAN_WARNING("\A [src] cuts you!"))
		human.take_overall_damage(force * 0.75, 0)
		return
	if (!human.lying)
		if (human.shoes)
			return
		if (human.wear_suit?.body_parts_covered & FEET)
			return
	if (human.species.siemens_coefficient < 0.5)
		return
	if (human.species.species_flags & (SPECIES_FLAG_NO_EMBED|SPECIES_FLAG_NO_MINOR_CUT))
		return
	var/list/check
	if (human.lying)
		check = BP_ALL_LIMBS
	else
		check = list(BP_L_FOOT, BP_R_FOOT)
	for (var/tag in shuffle(check, TRUE))
		var/obj/item/organ/external/external = human.get_organ(tag)
		if (!external)
			continue
		var/obj/item/clothing/clothing = get_clothing_coverage(tag)
		if (clothing?.item_flags & ITEM_FLAG_THICKMATERIAL)
			return
		var/damage_text = "slices"
		if (BP_IS_ROBOTIC(external) || BP_IS_CRYSTAL(external))
			external.take_external_damage(force * 0.5, 0)
			damage_text = "gouges"
		else
			var/damage_flags = DAMAGE_FLAG_SHARP
			if (prob(embed_prob))
				damage_flags |= DAMAGE_FLAG_EDGE
				damage_text = "pierces into"
			var/wound = external.take_external_damage(force * 0.75, 0, damage_flags)
			if (damage_flags & DAMAGE_FLAG_EDGE)
				external.embed(src, TRUE, null, wound)
			if (external.can_feel_pain())
				human.Weaken(3)
		to_chat(human, SPAN_DANGER("\A [src] [damage_text] your [external.name]!"))
		human.updatehealth()
		return


/obj/item/material/shard/phoron
	default_material = MATERIAL_PHORON


/obj/item/material/shard/shrapnel
	name = "shrapnel"
	w_class = ITEM_SIZE_TINY
	item_flags = EMPTY_BITFIELD
	embed_prob = 25
	step_sound = 'sound/obj/item/material/shard/shrapnel.ogg'


/obj/item/material/shard/shrapnel/steel
	default_material = MATERIAL_STEEL


/obj/item/material/shard/shrapnel/titanium
	default_material = MATERIAL_TITANIUM


/obj/item/material/shard/shrapnel/aluminium
	default_material = MATERIAL_ALUMINIUM


/obj/item/material/shard/shrapnel/copper
	default_material = MATERIAL_COPPER




