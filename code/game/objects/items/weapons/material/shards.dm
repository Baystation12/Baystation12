// Glass shards

/obj/item/material/shard
	name = "shard"
	icon = 'icons/obj/materials/shards.dmi'
	desc = "Made of nothing. How does this even exist?" // set based on material, if this desc is visible it's a bug (shards default to being made of glass)
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
	unbreakable = 1 //It's already broken.
	drops_debris = 0
	item_flags = ITEM_FLAG_CAN_HIDE_IN_SHOES

/obj/item/material/shard/set_material(new_material)
	..(new_material)
	if(!istype(material))
		return

	icon_state = "[material.shard_icon][pick("large", "medium", "small")]"
	update_icon()

	if(material.shard_type)
		SetName("[material.display_name] [material.shard_type]")
		desc = "A small piece of [material.display_name]. It looks sharp, you wouldn't want to step on it barefoot. Could probably be used as ... a throwing weapon?"
		switch(material.shard_type)
			if(SHARD_SPLINTER, SHARD_SHRAPNEL)
				gender = PLURAL
			else
				gender = NEUTER
	else
		qdel(src)

/obj/item/material/shard/on_update_icon()
	if(material)
		color = material.icon_colour
		// 1-(1-x)^2, so that glass shards with 0.3 opacity end up somewhat visible at 0.51 opacity
		alpha = 255 * (1 - (1 - material.opacity)*(1 - material.opacity))
	else
		color = "#ffffff"
		alpha = 255

/obj/item/material/shard/attackby(obj/item/W as obj, mob/user as mob)
	if(isWelder(W) && material.shard_can_repair)
		var/obj/item/weldingtool/WT = W
		if(WT.remove_fuel(1, user))
			material.place_sheet(get_turf(src))
			qdel(src)
			return
	return ..()

/obj/item/material/shard/Crossed(AM as mob|obj)
	..()
	if(isliving(AM))
		var/mob/M = AM

<<<<<<< ours
		if(M.buckled) //wheelchairs, office chairs, rollerbeds
			return
=======
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
>>>>>>> theirs

		playsound(src.loc, 'sound/effects/glass_step.ogg', 50, 1) // not sure how to handle metal shards with sounds
		if(ishuman(M))
			var/mob/living/carbon/human/H = M

			if(H.species.siemens_coefficient<0.5 || (H.species.species_flags & (SPECIES_FLAG_NO_EMBED|SPECIES_FLAG_NO_MINOR_CUT))) //Thick skin.
				return

			if( H.shoes || ( H.wear_suit && (H.wear_suit.body_parts_covered & FEET) ) )
				return

			to_chat(M, SPAN_DANGER("You step on \the [src]!"))

			var/list/check = list(BP_L_FOOT, BP_R_FOOT)
			while(length(check))
				var/picked = pick(check)
				var/obj/item/organ/external/affecting = H.get_organ(picked)
				if(affecting)
					if(BP_IS_ROBOTIC(affecting))
						return
					affecting.take_external_damage(5, 0)
					H.updatehealth()
					if(affecting.can_feel_pain())
						H.Weaken(3)
					return
				check -= picked
			return


/obj/item/material/shard/phoron/default_material = MATERIAL_PHORON


/obj/item/material/shard/shrapnel/name = "shrapnel"
/obj/item/material/shard/shrapnel/w_class = ITEM_SIZE_TINY
/obj/item/material/shard/shrapnel/item_flags = EMPTY_BITFIELD


<<<<<<< ours
/obj/item/material/shard/shrapnel/steel/default_material = MATERIAL_STEEL
=======
/obj/item/material/shard/caltrop
	name = "caltrop"
	desc = "A savage area denial weapon designed to puncture tire and boot alike."
	icon_state = "caltrop"
	default_material = MATERIAL_STEEL
	item_flags = EMPTY_BITFIELD
	max_force = 12
	thrown_force_multiplier = 0.3
	step_sound = 'sound/obj/item/material/shard/caltrop.ogg'
	embed_chance = 50
	pierce_thin_footwear = TRUE
	applies_material_details = FALSE
>>>>>>> theirs


/obj/item/material/shard/shrapnel/titanium/default_material = MATERIAL_TITANIUM


/obj/item/material/shard/shrapnel/aluminium/default_material = MATERIAL_ALUMINIUM


/obj/item/material/shard/shrapnel/copper/default_material = MATERIAL_COPPER
