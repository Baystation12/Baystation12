// Glass shards

/obj/item/weapon/material/shard
	name = "shard"
	icon = 'icons/obj/shards.dmi'
	desc = "Made of nothing. How does this even exist?" // set based on material, if this desc is visible it's a bug (shards default to being made of glass)
	icon_state = "large"
	randpixel = 8
	sharp = 1
	edge = 1
	w_class = ITEM_SIZE_SMALL
	force_divisor = 0.12 // 6 with hardness 30 (glass)
	thrown_force_divisor = 0.4 // 4 with weight 15 (glass)
	item_state = "shard-glass"
	attack_verb = list("stabbed", "slashed", "sliced", "cut")
	default_material = MATERIAL_GLASS
	unbreakable = 1 //It's already broken.
	drops_debris = 0

/obj/item/weapon/material/shard/set_material(var/new_material)
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

/obj/item/weapon/material/shard/on_update_icon()
	if(material)
		color = material.icon_colour
		// 1-(1-x)^2, so that glass shards with 0.3 opacity end up somewhat visible at 0.51 opacity
		alpha = 255 * (1 - (1 - material.opacity)*(1 - material.opacity))
	else
		color = "#ffffff"
		alpha = 255

/obj/item/weapon/material/shard/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(isWelder(W) && material.shard_can_repair)
		var/obj/item/weapon/weldingtool/WT = W
		if(WT.remove_fuel(0, user))
			material.place_sheet(loc)
			qdel(src)
			return
	return ..()

/obj/item/weapon/material/shard/Crossed(AM as mob|obj)
	..()
	if(isliving(AM))
		var/mob/M = AM

		if(M.buckled) //wheelchairs, office chairs, rollerbeds
			return

		playsound(src.loc, 'sound/effects/glass_step.ogg', 50, 1) // not sure how to handle metal shards with sounds
		if(ishuman(M))
			var/mob/living/carbon/human/H = M

			if(H.species.siemens_coefficient<0.5 || (H.species.species_flags & (SPECIES_FLAG_NO_EMBED|SPECIES_FLAG_NO_MINOR_CUT))) //Thick skin.
				return

			if(H.shoes || (H.wear_suit && (H.wear_suit.body_parts_covered & FEET)))
				return

			to_chat(M, "<span class='danger'>You step on \the [src]!</span>")

			var/list/check = list(BP_L_FOOT, BP_R_FOOT)
			while(check.len)
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

// Preset types - left here for the code that uses them
/obj/item/weapon/material/shrapnel
	name = "shrapnel"
	default_material = MATERIAL_STEEL
	w_class = ITEM_SIZE_TINY	//it's real small

/obj/item/weapon/material/shard/shrapnel/New(loc)
	..(loc, MATERIAL_STEEL)

/obj/item/weapon/material/shard/phoron/New(loc)
	..(loc, MATERIAL_PHORON_GLASS)

/obj/item/weapon/material/shard/supermatter
	name = "supermatter shard"
	desc = "A shard of supermatter. Incredibly dangerous, though not large enough to go critical."
	force = 10.0
	throwforce = 20.0
	icon = 'icons/obj/supermatter.dmi'
	icon_state = "supermattersmall"
	item_state = "shard-sm"
	item_flags = OBJ_FLAG_CONDUCTIBLE

	var/smlevel = 1
	light_color = COLOR_SM_DEFAULT
	light_outer_range = 2

	var/size = 1
	var/max_size = 100
	var/next_event = 0

/obj/item/weapon/material/shard/supermatter/Initialize(var/maploading, var/level = 1, var/set_size = 0)
	level = Clamp(level, MIN_SUPERMATTER_LEVEL, MAX_SUPERMATTER_LEVEL)

	smlevel = level
	light_color = rgb(255, 0, (255-(255*(smlevel/MAX_SUPERMATTER_LEVEL))))
	color = light_color

	if(!set_size)
		size += rand(0, 9)
	else
		size = set_size

	START_PROCESSING(SSobj, src)
	update_icon()
	. = ..()

/obj/item/weapon/material/shard/supermatter/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/weapon/material/shard/supermatter/examine(mob/user)
	..()
	if(user.skill_check(SKILL_SCIENCE, SKILL_ADEPT))
		to_chat(user, "<span class='notice'>It looks like a level [smlevel] shard.</span>")


/obj/item/weapon/material/shard/supermatter/on_update_icon()
	var/datum/sm_control/sm_tier = GLOB.supermatter_tiers[smlevel]
	color = sm_tier.color
	light_color = color
	set_light(0.5, 0.1, light_outer_range, 2, light_color)

	if(size <= 34)
		icon_state = "supermattersmall"
		pixel_x = rand(-12, 12)
		pixel_y = rand(-12, 12)
	else if(src.size <= 67)
		icon_state = "supermattermedium"
		pixel_x = rand(-8, 8)
		pixel_y = rand(-8, 8)
	else
		icon_state = "supermatterlarge"
		pixel_x = rand(-5, 5)
		pixel_y = rand(-5, 5)

/obj/item/weapon/material/shard/supermatter/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon))
		if(W.force >= 5)
			shatter()
	else
		..()

/obj/item/weapon/material/shard/supermatter/attack_hand(var/mob/user)
	var/mob/living/carbon/human/H = user
	if(H.gloves && H.gloves.item_flags & ITEM_FLAG_SMPROOF)
		..()
		return
	else if (user.a_intent == I_HELP)
		var/message = pick(	"You think twice before touching that without protection.",
							"You don't want to touch that without some protection.",
							"You probably should get something else to pick that up.",
							"You aren't sure that's a good idea.",
							"You aren't in the mood to get vaporized today.",
							"You really don't feel like frying your hand off.",
							"You assume that's a bad idea.")
		to_chat(user, "<span class='danger'>[message]</span>")
		return
	..()

/obj/item/weapon/material/shard/supermatter/Process()
	if(world.time > next_event)
		if(prob(50))
			SSradiation.radiate(src, 4 * smlevel * (size / max_size))
		next_event = world.time + 20
	..()

/obj/item/weapon/material/shard/supermatter/proc/feed(var/datum/gas_mixture/gas)
	size += gas.gas["phoron"]

	if(size > max_size)
		shatter()

	qdel(gas)

	update_icon()

/obj/item/weapon/material/shard/supermatter/shatter()
	if(size > 100)
		src.visible_message("The supermatter shard grows into a full-sized supermatter crystal!")
		var/obj/machinery/power/supermatter/S = new /obj/machinery/power/supermatter(get_turf(src))
		S.smlevel = smlevel
		S.update_icon()
	else if(size > 10)
		src.visible_message("The supermatter shard shatters into smaller fragments!")
		for(size, size > 10, size -= 10)
			new /obj/item/weapon/material/shard/supermatter(src.loc, smlevel)
	else
		src.visible_message("The supermatter shard shatters into dust!")

	playsound(src, "shatter", 70, 1)
	playsound(src, "sound/effects/EMPulse.ogg", 70, 1)
	qdel(src)

/obj/item/weapon/material/shard/supermatter/proc/fuse_limb(var/mob/target, var/obj/item/organ/external/L)
	if(L)
		to_chat(target, "<span class='alert'>\The [src] begins to glow before bursting into a bright flash of color, fusing into your [L.name]!</span>")
		target.drop_from_inventory(src)
		L.droplimb(0, DROPLIMB_BURN)

/obj/item/weapon/material/shard/supermatter/equipped(var/mob/user)
	var/mob/living/carbon/human/H = user
	var/equipped_slot = user.get_inventory_slot(src)
	var/target_slot
	var/target_organ

	if(equipped_slot == slot_l_hand || equipped_slot == slot_r_hand)
		target_slot = slot_gloves
		target_organ = user.hand ? BP_L_HAND : BP_R_HAND
	else if(equipped_slot == slot_l_store)
		target_slot = slot_w_uniform
		target_organ = BP_L_LEG
	else if(equipped_slot == slot_r_store)
		target_slot = slot_w_uniform
		target_organ = BP_R_LEG

	var/obj/item/I = target_slot && user.get_equipped_item(target_slot)
	if(!(I && (I.item_flags & ITEM_FLAG_SMPROOF)))
		var/obj/item/organ/external/L = H.get_organ(target_organ)

		if(L)
			fuse_limb(user, L)
			shatter()
	else
		..()

/obj/item/weapon/material/shard/supermatter/throw_impact(atom/hit_atom, var/speed)
	shatter()
	if(isliving(hit_atom))
		var/mob/living/L = hit_atom
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			var/obj/item/organ/external/O = pick(H.organs)

			for(var/obj/item/clothing/C in list(H.head, H.wear_mask, H.wear_suit, H.w_uniform, H.gloves, H.shoes))
				if(C && (C.body_parts_covered & O.body_part) && (C.item_flags & ITEM_FLAG_SMPROOF))
					return
			fuse_limb(L, O)
		else
			L.dust()
