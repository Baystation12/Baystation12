/obj/item/material/shard
	name = "shard"
	icon = 'icons/obj/materials/shards.dmi'
	icon_state = ""
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

	/// The sound to play when a valid mob enters the shard's turf
	var/step_sound = 'sound/effects/glass_step.ogg'

	/// Percent chance to embed in a wound if one was created
	var/embed_chance = 12

	/// If >0, the amount to weaken by when successfully hurting a mob
	var/weaken_amount = 3

	/// Whether the shard can hurt through footwear that has not set ITEM_FLAG_THICKMATERIAL
	var/pierce_thin_footwear = FALSE

	/// Whether to update the shard with the name and appearance of its material.
	var/applies_material_details = TRUE


/obj/item/material/shard/set_material(new_material)
	..(new_material)
	if (!istype(material))
		return
	if (!applies_material_details)
		return
	if (!material.shard_type)
		qdel(src)
		return
	SetName("[material.display_name] [material.shard_type]")
	desc = "A small piece of [material.display_name]. It looks sharp, you wouldn't want to step on it barefoot. Could probably be used as ... a throwing weapon?"
	switch (material.shard_type)
		if (SHARD_SPLINTER, SHARD_SHRAPNEL)
			gender = PLURAL
		else
			gender = NEUTER
	icon_state = "[material.shard_icon][pick("large", "medium", "small")]"
	update_icon()


/obj/item/material/shard/on_update_icon()
	if (material && applies_material_colour)
		color = material.icon_colour
		// 1-(1-x)^2, so that glass shards with 0.3 opacity end up somewhat visible at 0.51 opacity
		var/inverse_opacity = 1 - material.opacity
		alpha = 255 * (1 - inverse_opacity * inverse_opacity)
	else
		color = "#ffffff"
		alpha = 255

/obj/item/material/shard/use_tool(obj/item/W, mob/living/user, list/click_params)
	if(isWelder(W) && material.shard_can_repair)
		var/obj/item/weldingtool/WT = W
		if (!WT.can_use(1, user))
			return TRUE
		WT.remove_fuel(1, user)
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
	if (human.ignore_hazard_flags & HAZARD_FLAG_SHARD)
		return
	if (!istype(human))
		to_chat(human, SPAN_WARNING("\A [src] cuts you!"))
		human.take_overall_damage(force * 0.75, 0)
		return
	if (human.species.siemens_coefficient < 0.5)
		return
	if (human.species.species_flags & (SPECIES_FLAG_NO_EMBED|SPECIES_FLAG_NO_MINOR_CUT))
		return
	var/list/check
	if (!human.lying)
		if (human.shoes)
			if (human.shoes.item_flags & ITEM_FLAG_THICKMATERIAL)
				return
			if (!pierce_thin_footwear)
				return
		if (human.wear_suit?.body_parts_covered & FEET)
			if (human.wear_suit.item_flags & ITEM_FLAG_THICKMATERIAL)
				return
		check = list(BP_L_FOOT, BP_R_FOOT)
	else
		check = BP_ALL_LIMBS
	for (var/tag in shuffle(check, TRUE))
		var/obj/item/organ/external/external = human.get_organ(tag)
		if (!external)
			continue
		if (human.lying)
			var/obj/item/clothing/clothing = human.get_clothing_coverage(tag)
			if (clothing?.item_flags & ITEM_FLAG_THICKMATERIAL)
				return
		var/damage_text = "slices"
		if (BP_IS_ROBOTIC(external) || BP_IS_CRYSTAL(external))
			external.take_external_damage(force * 0.5, 0)
			damage_text = "gouges"
		else
			var/damage_flags = DAMAGE_FLAG_SHARP
			if (prob(embed_chance))
				damage_flags |= DAMAGE_FLAG_EDGE
				damage_text = "pierces into"
			var/wound = external.take_external_damage(force * 0.75, 0, damage_flags)
			if (damage_flags & DAMAGE_FLAG_EDGE)
				external.embed(src, TRUE, null, wound)
			if (weaken_amount && external.can_feel_pain())
				human.Weaken(weaken_amount)
		to_chat(human, SPAN_DANGER("\A [src] [damage_text] your [external.name]!"))
		human.updatehealth()
		return


/obj/item/material/shard/phoron
	default_material = MATERIAL_PHORON


/obj/item/material/shard/shrapnel
	name = "shrapnel"
	w_class = ITEM_SIZE_TINY
	item_flags = EMPTY_BITFIELD
	max_force = 4
	force_multiplier = 0.1
	thrown_force_multiplier = 0.25
	embed_chance = 20
	step_sound = 'sound/obj/item/material/shard/shrapnel.ogg'


/obj/item/material/shard/shrapnel/steel
	default_material = MATERIAL_STEEL


/obj/item/material/shard/shrapnel/titanium
	default_material = MATERIAL_TITANIUM


/obj/item/material/shard/shrapnel/aluminium
	default_material = MATERIAL_ALUMINIUM


/obj/item/material/shard/shrapnel/copper
	default_material = MATERIAL_COPPER

/obj/item/material/shard/caltrop
	name = "caltrop"
	desc = "A savage area denial weapon designed to puncture tire and boot alike."
	icon_state = "caltrop"
	default_material = MATERIAL_STEEL
	item_flags = EMPTY_BITFIELD
	max_force = 12
	thrown_force_multiplier = 0.3
	step_sound = 'sound/obj/item/material/shard/caltrop.ogg'
	embed_chance = 65
	pierce_thin_footwear = TRUE
	applies_material_details = FALSE


/obj/item/material/shard/caltrop/set_material(new_material)
	..(new_material)
	name = "[material.display_name] [initial(name)]"
	update_icon()


/obj/item/material/shard/caltrop/tack
	name = "thumbtack"
	desc = "A savage area denial weapon designed to puncture digit and heel alike."
	icon_state = "tack0"
	w_class = ITEM_SIZE_TINY
	default_material = MATERIAL_ALUMINIUM
	max_force = 3
	step_sound = 'sound/obj/item/material/shard/tack.ogg'
	embed_chance = 100
	pierce_thin_footwear = FALSE
	applies_material_colour = FALSE
	weaken_amount = FALSE


/obj/item/material/shard/caltrop/tack/set_material(new_material)
	..(new_material)
	icon_state = "tack[rand(0, 4)]"
