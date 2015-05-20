// Glass shards

/obj/item/weapon/shard
	name = "shard"
	icon = 'icons/obj/shards.dmi'
	icon_state = "large"
	sharp = 1
	edge = 1
	desc = "Made of nothing. How does this even exist?" // set based on material, if this desc is visible it's a bug (shards default to being made of glass)
	w_class = 2.0
	force = 5.0
	throwforce = 8.0
	item_state = "shard-glass"
	//matter = list("glass" = 3750) // Weld it into sheets before you use it!
	attack_verb = list("stabbed", "slashed", "sliced", "cut")

	gender = "neuter"
	var/material/material = null

/obj/item/weapon/shard/suicide_act(mob/user)
		viewers(user) << pick("\red <b>[user] is slitting \his wrists with \the [src]! It looks like \he's trying to commit suicide.</b>", \
							"\red <b>[user] is slitting \his throat with \the [src]! It looks like \he's trying to commit suicide.</b>")
		return (BRUTELOSS)

/obj/item/weapon/shard/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	playsound(loc, 'sound/weapons/bladeslice.ogg', 50, 1, -1)
	return ..()

/obj/item/weapon/shard/Bump()

	spawn( 0 )
		if (prob(20))
			src.force = 15
		else
			src.force = 4
		..()
		return
	return

/obj/item/weapon/shard/New(loc, material/material)
	..(loc)

	if(!material || !istype(material)) // We either don't have a material or we've been passed an invalid material. Use glass instead.
		material = get_material_by_name("glass")

	set_material(material)

/obj/item/weapon/shard/proc/set_material(material/material)
	if(istype(material))
		src.material = material
		icon_state = "[material.shard_icon][pick("large", "medium", "small")]"
		pixel_x = rand(-8, 8)
		pixel_y = rand(-8, 8)
		update_material()
		update_icon()

/obj/item/weapon/shard/proc/update_material()
	if(material)
		if(material.shard_type)
			name = "[material.display_name] [material.shard_type]"
			desc = "A small piece of [material.display_name]. It looks sharp, you wouldn't want to step on it barefoot. Could probably be used as ... a throwing weapon?"
			switch(material.shard_type)
				if(SHARD_SPLINTER, SHARD_SHRAPNEL)
					gender = "plural"
				else
					gender = "neuter"
		else
			qdel(src)
			return
	else
		name = initial(name)
		desc = initial(desc)

/obj/item/weapon/shard/update_icon()
	if(material)
		color = material.icon_colour
		// 1-(1-x)^2, so that glass shards with 0.3 opacity end up somewhat visible at 0.51 opacity
		alpha = 255 * (1 - (1 - material.opacity)*(1 - material.opacity))
	else
		color = "#ffffff"
		alpha = 255

/obj/item/weapon/shard/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/weldingtool) && material.shard_can_repair)
		var/obj/item/weapon/weldingtool/WT = W
		if(WT.remove_fuel(0, user))
			material.place_sheet(loc)
			qdel(src)
			return
	return ..()

/obj/item/weapon/shard/Crossed(AM as mob|obj)
	if(ismob(AM))
		var/mob/M = AM
		M << "\red <B>You step on \the [src]!</B>"
		playsound(src.loc, 'sound/effects/glass_step.ogg', 50, 1) // not sure how to handle metal shards with sounds
		if(ishuman(M))
			var/mob/living/carbon/human/H = M

			if(H.species.flags & IS_SYNTHETIC || (H.species.siemens_coefficient<0.5)) //Thick skin.
				return

			if( !H.shoes && ( !H.wear_suit || !(H.wear_suit.body_parts_covered & FEET) ) )
				var/obj/item/organ/external/affecting = H.get_organ(pick("l_foot", "r_foot"))
				if(affecting.status & ORGAN_ROBOT)
					return
				if(affecting.take_damage(5, 0))
					H.UpdateDamageIcon()
				H.updatehealth()
				if(!(H.species && (H.species.flags & NO_PAIN)))
					H.Weaken(3)
	..()

// Preset types - left here for the code that uses them

/obj/item/weapon/shard/shrapnel/New(loc)
	..(loc, get_material_by_name("steel"))

/obj/item/weapon/shard/phoron/New(loc)
	..(loc, get_material_by_name("phoron glass"))
