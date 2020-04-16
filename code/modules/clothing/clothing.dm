/obj/item/clothing
	name = "clothing"
	siemens_coefficient = 0.9
	var/flash_protection = FLASH_PROTECTION_NONE	// Sets the item's level of flash protection.
	var/tint = TINT_NONE							// Sets the item's level of visual impairment tint.
	var/list/species_restricted = list(
		"exclude",
		SPECIES_NABBER,
		SPECIES_MANTID_ALATE,
		SPECIES_MANTID_GYNE,
		SPECIES_MONARCH_WORKER,
		SPECIES_MONARCH_QUEEN
	) //everyone except for these species can wear this kit.

	var/list/accessories = list()
	var/list/valid_accessory_slots
	var/list/restricted_accessory_slots
	var/list/starting_accessories
	var/blood_overlay_type = "uniformblood"
	var/visible_name = "Unknown"
	var/ironed_state = WRINKLES_DEFAULT
	var/smell_state = SMELL_DEFAULT

	var/move_trail = /obj/effect/decal/cleanable/blood/tracks/footprints // if this item covers the feet, the footprints it should leave

// Updates the icons of the mob wearing the clothing item, if any.
/obj/item/clothing/proc/update_clothing_icon()
	return

// Updates the vision of the mob wearing the clothing item, if any
/obj/item/clothing/proc/update_vision()
	if(isliving(src.loc))
		var/mob/living/L = src.loc
		L.handle_vision()

// Checked when equipped, returns true when the wearing mob's vision should be updated
/obj/item/clothing/proc/needs_vision_update()
	return flash_protection || tint

/obj/item/clothing/get_mob_overlay(mob/user_mob, slot)
	var/image/ret = ..()

	if(slot == slot_l_hand_str || slot == slot_r_hand_str)
		return ret

	if(ishuman(user_mob))
		var/mob/living/carbon/human/user_human = user_mob
		if(blood_DNA && user_human.species.blood_mask)
			var/image/bloodsies = overlay_image(user_human.species.blood_mask, blood_overlay_type, blood_color, RESET_COLOR)
			bloodsies.appearance_flags |= NO_CLIENT_COLOR
			ret.overlays	+= bloodsies

	if(accessories.len)
		for(var/obj/item/clothing/accessory/A in accessories)
			ret.overlays |= A.get_mob_overlay(user_mob, slot)
	return ret

/obj/item/clothing/proc/change_smell(smell = SMELL_DEFAULT)
	smell_state = smell

/obj/item/clothing/proc/get_fibers()
	. = "material from \a [name]"
	var/list/acc = list()
	for(var/obj/item/clothing/accessory/A in accessories)
		if(prob(40) && A.get_fibers())
			acc += A.get_fibers()
	if(acc.len)
		. += " with traces of [english_list(acc)]"

/obj/item/clothing/proc/leave_evidence(mob/source)
	add_fingerprint(source)
	if(prob(10))
		ironed_state = WRINKLES_WRINKLY

/obj/item/clothing/New()
	..()
	if(starting_accessories)
		for(var/T in starting_accessories)
			var/obj/item/clothing/accessory/tie = new T(src)
			src.attach_accessory(null, tie)

//BS12: Species-restricted clothing check.
/obj/item/clothing/mob_can_equip(M as mob, slot, disable_warning = 0)

	//if we can't equip the item anyway, don't bother with species_restricted (cuts down on spam)
	if (!..())
		return 0

	if(species_restricted && istype(M,/mob/living/carbon/human))
		var/exclusive = null
		var/wearable = null
		var/mob/living/carbon/human/H = M

		if("exclude" in species_restricted)
			exclusive = 1

		if(H.species)
			if(exclusive)
				if(!(H.species.get_bodytype(H) in species_restricted))
					wearable = 1
			else
				if(H.species.get_bodytype(H) in species_restricted)
					wearable = 1

			if(!wearable && !(slot in list(slot_l_store, slot_r_store, slot_s_store)))
				if(!disable_warning)
					to_chat(H, "<span class='danger'>Your species cannot wear [src].</span>")
				return 0
	return 1

/obj/item/clothing/equipped(var/mob/user)
	if(needs_vision_update())
		update_vision()
	return ..()

/obj/item/clothing/proc/refit_for_species(var/target_species)
	if(!species_restricted)
		return //this item doesn't use the species_restricted system

	//Set species_restricted list
	switch(target_species)
		if(SPECIES_HUMAN, SPECIES_SKRELL)	//humanoid bodytypes
			species_restricted = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_IPC) //skrell/humans/machines can wear each other's suits
		else
			species_restricted = list(target_species)

	if (sprite_sheets_obj && (target_species in sprite_sheets_obj))
		icon = sprite_sheets_obj[target_species]
	else
		icon = initial(icon)

/obj/item/clothing/head/helmet/refit_for_species(var/target_species)
	if(!species_restricted)
		return //this item doesn't use the species_restricted system

	//Set species_restricted list
	switch(target_species)
		if(SPECIES_SKRELL)
			species_restricted = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_IPC) //skrell helmets fit humans too
		if(SPECIES_HUMAN)
			species_restricted = list(SPECIES_HUMAN, SPECIES_IPC) //human helmets fit IPCs too
		else
			species_restricted = list(target_species)

	if (sprite_sheets_obj && (target_species in sprite_sheets_obj))
		icon = sprite_sheets_obj[target_species]
	else
		icon = initial(icon)

/obj/item/clothing/get_examine_line()
	. = ..()
	var/list/ties = list()
	for(var/obj/item/clothing/accessory/accessory in accessories)
		if(accessory.high_visibility)
			ties += "\a [accessory.get_examine_line()]"
	if(ties.len)
		.+= " with [english_list(ties)] attached"
	if(accessories.len > ties.len)
		.+= ". <a href='?src=\ref[src];list_ungabunga=1'>\[See accessories\]</a>"

/obj/item/clothing/examine(mob/user)
	. = ..()
	var/datum/extension/armor/ablative/armor_datum = get_extension(src, /datum/extension/armor/ablative)
	if(istype(armor_datum) && LAZYLEN(armor_datum.get_visible_damage()))
		to_chat(user, SPAN_WARNING("It has some <a href='?src=\ref[src];list_armor_damage=1'>damage</a>."))

/obj/item/clothing/CanUseTopic(var/user)
	if(user in view(get_turf(src)))
		return STATUS_INTERACTIVE

/obj/item/clothing/OnTopic(var/user, var/list/href_list, var/datum/topic_state/state)
	if(href_list["list_ungabunga"])
		if(accessories.len)
			var/list/ties = list()
			for(var/accessory in accessories)
				ties += "\icon[accessory] \a [accessory]"
			to_chat(user, "Attached to \the [src] are [english_list(ties)].")
		return TOPIC_HANDLED
	if(href_list["list_armor_damage"])
		var/datum/extension/armor/ablative/armor_datum = get_extension(src, /datum/extension/armor/ablative)
		var/list/damages = armor_datum.get_visible_damage()
		to_chat(user, "\The [src] \icon[src] has some damage:")
		for(var/key in damages)
			to_chat(user, "<li><b>[capitalize(damages[key])]</b> damage to the <b>[key]</b> armor.")
		return TOPIC_HANDLED

///////////////////////////////////////////////////////////////////////
// Ears: headsets, earmuffs and tiny objects
/obj/item/clothing/ears
	name = "ears"
	w_class = ITEM_SIZE_TINY
	throwforce = 2
	slot_flags = SLOT_EARS
	var/volume_multiplier = 1

/obj/item/clothing/ears/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_ears()

/obj/item/clothing/ears/earmuffs
	name = "earmuffs"
	desc = "Protects your hearing from loud noises, and quiet ones as well."
	icon_state = "earmuffs"
	item_state = "earmuffs"
	slot_flags = SLOT_EARS | SLOT_TWOEARS
	volume_multiplier = 0.1


///////////////////////////////////////////////////////////////////////
//Glasses
/*
SEE_SELF  // can see self, no matter what
SEE_MOBS  // can see all mobs, no matter what
SEE_OBJS  // can see all objs, no matter what
SEE_TURFS // can see all turfs (and areas), no matter what
SEE_PIXELS// if an object is located on an unlit area, but some of its pixels are
	      // in a lit area (via pixel_x, y or smooth movement), can see those pixels
BLIND     // can't see anything
*/
/obj/item/clothing/glasses
	name = "glasses"
	icon = 'icons/obj/clothing/obj_eyes.dmi'
	w_class = ITEM_SIZE_SMALL
	body_parts_covered = EYES
	slot_flags = SLOT_EYES
	var/vision_flags = 0
	var/darkness_view = 0//Base human is 2
	var/see_invisible = -1
	var/light_protection = 0
	sprite_sheets = list(
		SPECIES_VOX = 'icons/mob/species/vox/onmob_eyes_vox.dmi',
		SPECIES_VOX_ARMALIS = 'icons/mob/species/vox/onmob_eyes_vox_armalis.dmi',
		SPECIES_UNATHI = 'icons/mob/species/unathi/generated/onmob_eyes_unathi.dmi',
	)

/obj/item/clothing/glasses/get_icon_state(mob/user_mob, slot)
	if(item_state_slots && item_state_slots[slot])
		return item_state_slots[slot]
	else
		return icon_state

/obj/item/clothing/glasses/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_glasses()

///////////////////////////////////////////////////////////////////////
//Gloves
/obj/item/clothing/gloves
	name = "gloves"
	gender = PLURAL //Carn: for grammarically correct text-parsing
	w_class = ITEM_SIZE_SMALL
	icon = 'icons/obj/clothing/obj_hands.dmi'
	siemens_coefficient = 0.75
	var/wired = 0
	var/obj/item/weapon/cell/cell = 0
	var/clipped = 0
	var/obj/item/clothing/ring/ring = null		//Covered ring
	var/mob/living/carbon/human/wearer = null	//Used for covered rings when dropping
	body_parts_covered = HANDS
	slot_flags = SLOT_GLOVES
	attack_verb = list("challenged")
	species_restricted = list("exclude",SPECIES_NABBER, SPECIES_UNATHI,SPECIES_VOX, SPECIES_VOX_ARMALIS)
	sprite_sheets = list(
		SPECIES_VOX = 'icons/mob/species/vox/onmob_hands_vox.dmi',
		SPECIES_VOX_ARMALIS = 'icons/mob/species/vox/onmob_hands_vox_armalis.dmi',
		SPECIES_NABBER = 'icons/mob/species/nabber/onmob_hands_gas.dmi',
		SPECIES_UNATHI = 'icons/mob/species/unathi/generated/onmob_hands_unathi.dmi',
		)
	blood_overlay_type = "bloodyhands"

/obj/item/clothing/gloves/Initialize()
	if(item_flags & ITEM_FLAG_PREMODIFIED)
		cut_fingertops()

	. = ..()

/obj/item/clothing/gloves/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_gloves()

/obj/item/clothing/gloves/emp_act(severity)
	if(cell)
		//why is this not part of the powercell code?
		cell.charge -= 1000 / severity
		if (cell.charge < 0)
			cell.charge = 0
	..()

/obj/item/clothing/gloves/get_fibers()
	return "material from a pair of [name]."

// Called just before an attack_hand(), in mob/UnarmedAttack()
/obj/item/clothing/gloves/proc/Touch(var/atom/A, var/proximity)
	return 0 // return 1 to cancel attack_hand()

/obj/item/clothing/gloves/attackby(obj/item/weapon/W, mob/user)
	if(istype(W, /obj/item/weapon/wirecutters) || istype(W, /obj/item/weapon/scalpel))
		if (clipped)
			to_chat(user, "<span class='notice'>\The [src] have already been modified!</span>")
			update_icon()
			return

		playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
		user.visible_message("<span class='warning'>\The [user] modifies \the [src] with \the [W].</span>","<span class='warning'>You modify \the [src] with \the [W].</span>")

		cut_fingertops() // apply change, so relevant xenos can wear these
		return

// Applies "clipped" and removes relevant restricted species from the list,
// making them wearable by the specified species, does nothing if already cut
/obj/item/clothing/gloves/proc/cut_fingertops()
	if (clipped)
		return

	clipped = 1
	name = "modified [name]"
	desc = "[desc]<br>They have been modified to accommodate a different shape."
	if("exclude" in species_restricted)
		species_restricted -= SPECIES_UNATHI
	return

/obj/item/clothing/gloves/mob_can_equip(mob/user)
	var/mob/living/carbon/human/H = user

	if(istype(H.gloves, /obj/item/clothing/ring))
		ring = H.gloves
		if(!ring.undergloves)
			to_chat(user, "You are unable to wear \the [src] as \the [H.gloves] are in the way.")
			ring = null
			return 0
		if(!H.unEquip(ring, src))//Remove the ring (or other under-glove item in the hand slot?) so you can put on the gloves.
			ring = null
			return 0

	if(!..())
		if(ring) //Put the ring back on if the check fails.
			if(H.equip_to_slot_if_possible(ring, slot_gloves))
				src.ring = null
		return 0

	if (ring)
		to_chat(user, "You slip \the [src] on over \the [ring].")
	wearer = H //TODO clean this when magboots are cleaned
	return 1

/obj/item/clothing/gloves/dropped()
	..()
	if(!wearer)
		return

	var/mob/living/carbon/human/H = wearer
	if(ring && istype(H))
		if(!H.equip_to_slot_if_possible(ring, slot_gloves))
			ring.dropInto(loc)
		src.ring = null
	wearer = null

///////////////////////////////////////////////////////////////////////
//Head
/obj/item/clothing/head
	name = "head"
	icon = 'icons/obj/clothing/obj_head.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/onmob/items/lefthand_hats.dmi',
		slot_r_hand_str = 'icons/mob/onmob/items/righthand_hats.dmi',
		)
	body_parts_covered = HEAD
	slot_flags = SLOT_HEAD
	w_class = ITEM_SIZE_SMALL

	var/image/light_overlay_image
	var/light_overlay = "helmet_light"
	var/light_applied
	var/brightness_on
	var/on = 0

	sprite_sheets = list(
		SPECIES_VOX = 'icons/mob/species/vox/onmob_head_vox.dmi',
		SPECIES_VOX_ARMALIS = 'icons/mob/species/vox/onmob_head_vox_armalis.dmi',
		SPECIES_UNATHI = 'icons/mob/species/unathi/generated/onmob_head_unathi.dmi',
		)
	blood_overlay_type = "helmetblood"

/obj/item/clothing/head/equipped(var/mob/user, var/slot)
	light_overlay_image = null
	..(user, slot)

/obj/item/clothing/head/get_mob_overlay(mob/user_mob, slot)
	var/image/ret = ..()
	if(light_overlay_image)
		ret.overlays -= light_overlay_image
	if(on && slot == slot_head_str)
		if(!light_overlay_image)
			if(ishuman(user_mob))
				var/mob/living/carbon/human/user_human = user_mob
				var/use_icon
				if(sprite_sheets)
					use_icon = sprite_sheets[user_human.species.get_bodytype(user_human)]
				if(use_icon)
					light_overlay_image = user_human.species.get_offset_overlay_image(TRUE, use_icon, "[light_overlay]", color, slot)
				else
					light_overlay_image = user_human.species.get_offset_overlay_image(FALSE, 'icons/mob/light_overlays.dmi', "[light_overlay]", color, slot)
			else
				light_overlay_image = overlay_image('icons/mob/light_overlays.dmi', "[light_overlay]", null, RESET_COLOR)
		ret.overlays |= light_overlay_image
	return ret

/obj/item/clothing/head/attack_self(mob/user)
	if(brightness_on)
		if(!isturf(user.loc))
			to_chat(user, "You cannot turn the light on while in this [user.loc]")
			return
		on = !on
		to_chat(user, "You [on ? "enable" : "disable"] the helmet light.")
		update_flashlight(user)
	else
		return ..(user)

/obj/item/clothing/head/proc/update_flashlight(var/mob/user = null)
	if(on && !light_applied)
		set_light(brightness_on, 1, 3)
		light_applied = 1
	else if(!on && light_applied)
		set_light(0)
		light_applied = 0
	update_icon(user)
	user.update_action_buttons()

/obj/item/clothing/head/attack_ai(var/mob/user)
	if(!mob_wear_hat(user))
		return ..()

/obj/item/clothing/head/attack_generic(var/mob/user)
	if(!istype(user) || !mob_wear_hat(user))
		return ..()

/obj/item/clothing/head/proc/mob_wear_hat(var/mob/user)
	if(!Adjacent(user))
		return 0
	var/success
	if(is_drone(user))
		var/mob/living/silicon/robot/drone/D = user
		if(D.hat)
			success = 2
		else
			D.wear_hat(src)
			success = 1
	else if(istype(user, /mob/living/carbon/alien/diona))
		var/mob/living/carbon/alien/diona/D = user
		if(D.hat)
			success = 2
		else
			D.wear_hat(src)
			success = 1

	if(!success)
		return 0
	else if(success == 2)
		to_chat(user, "<span class='warning'>You are already wearing a hat.</span>")
	else if(success == 1)
		to_chat(user, "<span class='notice'>You crawl under \the [src].</span>")
	return 1

/obj/item/clothing/head/on_update_icon(var/mob/user)

	overlays.Cut()
	if(on)
		// Generate object icon.
		if(!light_overlay_cache["[light_overlay]_icon"])
			light_overlay_cache["[light_overlay]_icon"] = image("icon" = 'icons/obj/light_overlays.dmi', "icon_state" = "[light_overlay]")
		overlays |= light_overlay_cache["[light_overlay]_icon"]

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_head()

/obj/item/clothing/head/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_head()

///////////////////////////////////////////////////////////////////////
//Mask
/obj/item/clothing/mask
	name = "mask"
	icon = 'icons/obj/clothing/obj_mask.dmi'
	slot_flags = SLOT_MASK
	body_parts_covered = FACE|EYES
	sprite_sheets = list(
		SPECIES_VOX = 'icons/mob/species/vox/onmob_mask_vox.dmi',
		SPECIES_VOX_ARMALIS = 'icons/mob/species/vox/onmob_mask_vox_armalis.dmi',
		SPECIES_UNATHI = 'icons/mob/species/unathi/generated/onmob_mask_unathi.dmi',
		)

	var/voicechange = 0
	var/list/say_messages
	var/list/say_verbs
	var/down_gas_transfer_coefficient = 0
	var/down_body_parts_covered = 0
	var/down_icon_state = 0
	var/down_item_flags = 0
	var/down_flags_inv = 0
	var/pull_mask = 0
	var/hanging = 0
	var/list/filtered_gases
	blood_overlay_type = "maskblood"

/obj/item/clothing/mask/proc/filters_water()
	return FALSE

/obj/item/clothing/mask/New()
	if(pull_mask)
		action_button_name = "Adjust Mask"
		verbs += /obj/item/clothing/mask/proc/adjust_mask
	..()

/obj/item/clothing/mask/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_wear_mask()

/obj/item/clothing/mask/proc/filter_air(datum/gas_mixture/air)
	return

/obj/item/clothing/mask/proc/adjust_mask(var/mob/user)
	set category = "Object"
	set name = "Adjust mask"
	set src in usr

	if(!user.incapacitated())
		if(!pull_mask)
			to_chat(usr, "<span class ='notice'>You cannot pull down your [src.name].</span>")
			return
		else
			src.hanging = !src.hanging
			if (src.hanging)
				gas_transfer_coefficient = down_gas_transfer_coefficient
				body_parts_covered = down_body_parts_covered
				icon_state = down_icon_state
				item_state = down_icon_state
				item_flags = down_item_flags
				flags_inv = down_flags_inv
				to_chat(usr, "You pull [src] below your chin.")
			else
				gas_transfer_coefficient = initial(gas_transfer_coefficient)
				body_parts_covered = initial(body_parts_covered)
				icon_state = initial(icon_state)
				item_state = initial(icon_state)
				item_flags = initial(item_flags)
				flags_inv = initial(flags_inv)
				to_chat(usr, "You pull [src] up to cover your face.")
			update_clothing_icon()
			user.update_action_buttons()

/obj/item/clothing/mask/attack_self(mob/user)
	if(pull_mask)
		adjust_mask(user)

///////////////////////////////////////////////////////////////////////
//Shoes
/obj/item/clothing/shoes
	name = "shoes"
	icon = 'icons/obj/clothing/obj_feet.dmi'
	desc = "Comfortable-looking shoes."
	gender = PLURAL
	siemens_coefficient = 0.9
	body_parts_covered = FEET
	slot_flags = SLOT_FEET
	permeability_coefficient = 0.50
	force = 2
	species_restricted = list("exclude", SPECIES_NABBER, SPECIES_UNATHI, SPECIES_VOX, SPECIES_VOX_ARMALIS)
	sprite_sheets = list(
		SPECIES_VOX = 'icons/mob/species/vox/onmob_feet_vox.dmi',
		SPECIES_VOX_ARMALIS = 'icons/mob/species/vox/onmob_feet_vox_armalis.dmi',
		SPECIES_UNATHI = 'icons/mob/species/unathi/generated/onmob_feet_unathi.dmi',
		)
	blood_overlay_type = "shoeblood"
	var/overshoes = 0
	var/can_add_cuffs = TRUE
	var/obj/item/weapon/handcuffs/attached_cuffs = null
	var/can_add_hidden_item = TRUE
	var/hidden_item_max_w_class = ITEM_SIZE_SMALL
	var/obj/item/hidden_item = null

/obj/item/clothing/shoes/Destroy()
	. = ..()
	if (hidden_item)
		QDEL_NULL(hidden_item)
	if (attached_cuffs)
		QDEL_NULL(attached_cuffs)

/obj/item/clothing/shoes/examine(mob/user)
	. = ..()
	if (attached_cuffs)
		to_chat(user, SPAN_WARNING("They are connected by \the [attached_cuffs]."))
	if (hidden_item)
		if (loc == user)
			to_chat(user, SPAN_ITALIC("\An [hidden_item] is inside."))
		else if (get_dist(src, user) == 1)
			to_chat(user, SPAN_ITALIC("Something is hidden inside."))

/obj/item/clothing/shoes/attack_hand(var/mob/living/user)
	if (remove_hidden(user))
		return
	..()

/obj/item/clothing/shoes/attack_self(var/mob/user)
	remove_cuffs(user)
	..()

/obj/item/clothing/shoes/attackby(var/obj/item/I, var/mob/user)
	if (istype(I, /obj/item/weapon/handcuffs))
		add_cuffs(I, user)
		return
	else
		add_hidden(I, user)
		return

/obj/item/clothing/shoes/proc/add_cuffs(var/obj/item/weapon/handcuffs/cuffs, var/mob/user)
	if (!can_add_cuffs)
		to_chat(user, SPAN_WARNING("\The [cuffs] can't be attached to \the [src]."))
		return
	if (attached_cuffs)
		to_chat(user, SPAN_WARNING("\The [src] already has [attached_cuffs] attached."))
		return
	if (do_after(user, 5 SECONDS))
		if(!user.unEquip(cuffs, src))
			return
		user.visible_message(SPAN_ITALIC("\The [user] attaches \the [cuffs] to \the [src]."), range = 2)
		verbs |= /obj/item/clothing/shoes/proc/remove_cuffs
		slowdown_per_slot[slot_shoes] += cuffs.elastic ? 10 : 15
		attached_cuffs = cuffs

/obj/item/clothing/shoes/proc/remove_cuffs(var/mob/user)
	set name = "Remove Shoe Cuffs"
	set desc = "Get rid of those limiters and lengthen your stride."
	set category = "Object"
	set src in usr

	user = user || usr
	if (!user)
		return
	if (!attached_cuffs)
		return
	if (user.incapacitated())
		return
	if (do_after(user, 5 SECONDS))
		if (!user.put_in_hands(attached_cuffs))
			to_chat(usr, SPAN_WARNING("You need an empty, unbroken hand to remove the [attached_cuffs] from the [src]."))
			return
		user.visible_message(SPAN_ITALIC("\The [user] removes \the [attached_cuffs] from \the [src]."), range = 2)
		attached_cuffs.add_fingerprint(user)
		slowdown_per_slot[slot_shoes] -= attached_cuffs.elastic ? 10 : 15
		verbs -= /obj/item/clothing/shoes/proc/remove_cuffs
		attached_cuffs = null

/obj/item/clothing/shoes/proc/add_hidden(var/obj/item/I, var/mob/user)
	if (!can_add_hidden_item)
		to_chat(user, SPAN_WARNING("\The [src] can't hold anything."))
		return
	if (hidden_item)
		to_chat(user, SPAN_WARNING("\The [src] already holds \an [hidden_item]."))
		return
	if (!(I.item_flags & ITEM_FLAG_CAN_HIDE_IN_SHOES) || (I.slot_flags & SLOT_DENYPOCKET))
		to_chat(user, SPAN_WARNING("\The [src] can't hold the [I]."))
		return
	if (I.w_class > hidden_item_max_w_class)
		to_chat(user, SPAN_WARNING("\The [I] is too large to fit in the [src]."))
		return
	if (do_after(user, 1 SECONDS))
		if(!user.unEquip(I, src))
			return
		user.visible_message(SPAN_ITALIC("\The [user] shoves \the [I] into \the [src]."), range = 1)
		verbs |= /obj/item/clothing/shoes/proc/remove_hidden
		hidden_item = I

/obj/item/clothing/shoes/proc/remove_hidden(var/mob/user)
	set name = "Remove Shoe Item"
	set desc = "Pull out whatever's hidden in your foot gloves."
	set category = "Object"
	set src in usr

	user = user || usr
	if (!user)
		return
	if (!hidden_item)
		return FALSE
	if (user.incapacitated())
		return FALSE
	if (loc != user)
		return FALSE
	if (do_after(user, 2 SECONDS))
		if (!user.put_in_hands(hidden_item))
			to_chat(usr, SPAN_WARNING("You need an empty, unbroken hand to pull the [hidden_item] from the [src]."))
			return TRUE
		user.visible_message(SPAN_ITALIC("\The [user] pulls \the [hidden_item] from \the [src]."), range = 1)
		playsound(get_turf(src), 'sound/effects/holster/tactiholsterout.ogg', 25)
		verbs -= /obj/item/clothing/shoes/proc/remove_hidden
		hidden_item = null
	return TRUE

/obj/item/clothing/shoes/proc/handle_movement(var/turf/walking, var/running)
	if (attached_cuffs && running)
		if (attached_cuffs.health)
			attached_cuffs.health -= 1
			if (attached_cuffs.health < 1)
				visible_message(SPAN_WARNING("\The [attached_cuffs] attached to \the [src] snap and fall away!"), range = 1)
				verbs -= /obj/item/clothing/shoes/proc/remove_cuffs
				slowdown_per_slot[slot_shoes] -= attached_cuffs.elastic ? 10 : 15
				QDEL_NULL(attached_cuffs)
	return

/obj/item/clothing/shoes/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_shoes()

///////////////////////////////////////////////////////////////////////
//Suit
/obj/item/clothing/suit
	icon = 'icons/obj/clothing/obj_suit.dmi'
	name = "suit"
	var/fire_resist = T0C+100
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	allowed = list(/obj/item/weapon/tank/emergency)
	slot_flags = SLOT_OCLOTHING
	blood_overlay_type = "suit"
	siemens_coefficient = 0.9
	w_class = ITEM_SIZE_NORMAL

	sprite_sheets = list(
		SPECIES_VOX = 'icons/mob/species/vox/onmob_suit_vox.dmi',
		SPECIES_VOX_ARMALIS = 'icons/mob/species/vox/onmob_suit_vox_armalis.dmi',
		SPECIES_UNATHI = 'icons/mob/species/unathi/generated/onmob_suit_unathi.dmi',
		SPECIES_NABBER = 'icons/mob/species/nabber/onmob_suit_gas.dmi',
		SPECIES_MANTID_ALATE = 'icons/mob/species/mantid/onmob_suit_alate.dmi',
		SPECIES_MANTID_GYNE = 'icons/mob/species/mantid/onmob_suit_gyne.dmi'
		)

/obj/item/clothing/suit/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_wear_suit()

/obj/item/clothing/suit/get_mob_overlay(mob/user_mob, slot)
	var/image/ret = ..()
	if(item_state_slots && item_state_slots[slot])
		ret.icon_state = item_state_slots[slot]
	else
		ret.icon_state = item_state
	if(!ret.icon_state)
		ret.icon_state = icon_state
	return ret

/obj/item/clothing/suit/handle_shield()
	return FALSE

/obj/item/clothing/suit/proc/get_collar()
	var/icon/C = new('icons/mob/collar.dmi')
	if(icon_state in C.IconStates())
		var/image/I = image(C, icon_state)
		I.color = color
		return I
///////////////////////////////////////////////////////////////////////
//Under clothing
/obj/item/clothing/under
	icon = 'icons/obj/clothing/obj_under.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/onmob/items/lefthand_uniforms.dmi',
		slot_r_hand_str = 'icons/mob/onmob/items/righthand_uniforms.dmi',
		)
	name = "under"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	permeability_coefficient = 0.90
	slot_flags = SLOT_ICLOTHING
	w_class = ITEM_SIZE_NORMAL
	force = 0
	var/has_sensor = SUIT_HAS_SENSORS //For the crew computer 2 = unable to change mode
	var/sensor_mode = SUIT_SENSOR_OFF
		/*
		1 = Report living/dead
		2 = Report detailed damages
		3 = Report location
		*/
	var/displays_id = 1
	var/rolled_down = -1 //0 = unrolled, 1 = rolled, -1 = cannot be toggled
	var/rolled_sleeves = -1 //0 = unrolled, 1 = rolled, -1 = cannot be toggled
	sprite_sheets = list(
		SPECIES_VOX = 'icons/mob/species/vox/onmob_under_vox.dmi',
		SPECIES_VOX_ARMALIS = 'icons/mob/species/vox/onmob_under_vox_armalis.dmi',
		SPECIES_NABBER = 'icons/mob/species/nabber/onmob_under_gas.dmi',
		SPECIES_UNATHI = 'icons/mob/species/unathi/generated/onmob_under_unathi.dmi',
		SPECIES_MANTID_ALATE = 'icons/mob/species/mantid/onmob_under_alate.dmi',
		SPECIES_MANTID_GYNE = 'icons/mob/species/mantid/onmob_under_gyne.dmi'
	)

	//convenience var for defining the icon state for the overlay used when the clothing is worn.
	//Also used by rolling/unrolling.
	var/worn_state = null
	//Whether the clothing item has gender-specific states when worn.
	var/gender_icons = 0
	valid_accessory_slots = list(ACCESSORY_SLOT_UTILITY,ACCESSORY_SLOT_HOLSTER,ACCESSORY_SLOT_ARMBAND,ACCESSORY_SLOT_RANK,ACCESSORY_SLOT_DEPT,ACCESSORY_SLOT_DECOR,ACCESSORY_SLOT_MEDAL,ACCESSORY_SLOT_INSIGNIA)
	restricted_accessory_slots = list(ACCESSORY_SLOT_UTILITY,ACCESSORY_SLOT_HOLSTER,ACCESSORY_SLOT_ARMBAND,ACCESSORY_SLOT_RANK,ACCESSORY_SLOT_DEPT)

/obj/item/clothing/under/New()
	..()
	update_rolldown_status()
	update_rollsleeves_status()
	if(rolled_down == -1)
		verbs -= /obj/item/clothing/under/verb/rollsuit
	if(rolled_sleeves == -1)
		verbs -= /obj/item/clothing/under/verb/rollsleeves

/obj/item/clothing/under/inherit_custom_item_data(var/datum/custom_item/citem)
	. = ..()
	worn_state = icon_state
	update_rolldown_status()

/obj/item/clothing/under/proc/get_gender_suffix(var/suffix = "_s")
	. = suffix
	var/mob/living/carbon/human/H
	if(istype(src.loc, /mob/living/carbon/human))
		H = src.loc
		var/bodytype
		if(ishuman(H))
			bodytype = H.species.get_bodytype(H)

		if(gender_icons && bodytype == SPECIES_HUMAN && H.gender == FEMALE)
			. = "_f" + suffix

/obj/item/clothing/under/get_icon_state(mob/user_mob, slot)
	if(item_state_slots && item_state_slots[slot])
		. = item_state_slots[slot]
	else
		. = icon_state
	if(!findtext(.,"_s", -2)) // If we don't already have our suffix
		if((icon_state + "_f_s") in icon_states(default_onmob_icons[slot_w_uniform_str]))
			. +=  get_gender_suffix()
		else
			. += "_s"

/obj/item/clothing/under/attack_hand(var/mob/user)
	if(accessories && accessories.len)
		..()
	if ((ishuman(usr) || issmall(usr)) && src.loc == user)
		return
	..()

/obj/item/clothing/under/New()
	..()
	if(worn_state)
		if(!item_state_slots)
			item_state_slots = list()
		item_state_slots[slot_w_uniform_str] = worn_state
	else
		worn_state = icon_state
	//autodetect rollability
	if(rolled_down < 0)
		if(("[worn_state]_d_s") in icon_states(default_onmob_icons[slot_w_uniform_str]))
			rolled_down = 0

/obj/item/clothing/under/proc/update_rolldown_status()
	var/mob/living/carbon/human/H
	if(istype(src.loc, /mob/living/carbon/human))
		H = src.loc

	var/icon/under_icon
	if(icon_override)
		under_icon = icon_override
	else if(H && sprite_sheets && sprite_sheets[H.species.get_bodytype(H)])
		under_icon = sprite_sheets[H.species.get_bodytype(H)]
	else if(item_icons && item_icons[slot_w_uniform_str])
		under_icon = item_icons[slot_w_uniform_str]
	else
		under_icon = default_onmob_icons[slot_w_uniform_str]

	// The _s is because the icon update procs append it.
	if(("[worn_state]_d_s") in icon_states(under_icon))
		if(rolled_down != 1)
			rolled_down = 0
	else
		rolled_down = -1
	if(H) update_clothing_icon()

/obj/item/clothing/under/proc/update_rollsleeves_status()
	var/mob/living/carbon/human/H
	if(istype(src.loc, /mob/living/carbon/human))
		H = src.loc

	var/icon/under_icon
	if(icon_override)
		under_icon = icon_override
	else if(H && sprite_sheets && sprite_sheets[H.species.get_bodytype(H)])
		under_icon = sprite_sheets[H.species.get_bodytype(H)]
	else if(item_icons && item_icons[slot_w_uniform_str])
		under_icon = item_icons[slot_w_uniform_str]
	else
		under_icon = default_onmob_icons[slot_w_uniform_str]

	// The _s is because the icon update procs append it.
	if(("[worn_state]_r_s") in icon_states(under_icon))
		if(rolled_sleeves != 1)
			rolled_sleeves = 0
	else
		rolled_sleeves = -1
	if(H) update_clothing_icon()

/obj/item/clothing/under/update_clothing_icon()
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_w_uniform(0)
		M.update_inv_wear_id()


/obj/item/clothing/under/examine(mob/user)
	. = ..()
	switch(src.sensor_mode)
		if(SUIT_SENSOR_OFF)
			to_chat(user, "Its sensors appear to be disabled.")
		if(SUIT_SENSOR_BINARY)
			to_chat(user, "Its binary life sensors appear to be enabled.")
		if(SUIT_SENSOR_VITAL)
			to_chat(user, "Its vital tracker appears to be enabled.")
		if(SUIT_SENSOR_TRACKING)
			to_chat(user, "Its vital tracker and tracking beacon appear to be enabled.")

/obj/item/clothing/under/proc/set_sensors(mob/user as mob)
	var/mob/M = user
	if (isobserver(M)) return
	if (user.incapacitated()) return
	if(has_sensor >= SUIT_LOCKED_SENSORS)
		to_chat(user, "The controls are locked.")
		return 0
	if(has_sensor <= SUIT_NO_SENSORS)
		to_chat(user, "This suit does not have any sensors.")
		return 0

	var/switchMode = input("Select a sensor mode:", "Suit Sensor Mode", get_key_by_index(SUIT_SENSOR_MODES, sensor_mode + 1)) as null | anything in SUIT_SENSOR_MODES
	if(!switchMode)
		return
	if(get_dist(user, src) > 1)
		to_chat(user, "You have moved too far away.")
		return
	sensor_mode = SUIT_SENSOR_MODES[switchMode]

	if (src.loc == user)
		switch(sensor_mode)
			if(SUIT_SENSOR_OFF)
				user.visible_message("[user] adjusts the tracking sensor on \his [src.name].", "You disable your suit's remote sensing equipment.")
			if(SUIT_SENSOR_BINARY)
				user.visible_message("[user] adjusts the tracking sensor on \his [src.name].", "Your suit will now report whether you are live or dead.")
			if(SUIT_SENSOR_VITAL)
				user.visible_message("[user] adjusts the tracking sensor on \his [src.name].", "Your suit will now report your vital lifesigns.")
			if(SUIT_SENSOR_TRACKING)
				user.visible_message("[user] adjusts the tracking sensor on \his [src.name].", "Your suit will now report your vital lifesigns as well as your coordinate position.")

	else if (ismob(src.loc))
		if(sensor_mode == SUIT_SENSOR_OFF)
			user.visible_message("<span class='warning'>[user] disables [src.loc]'s remote sensing equipment.</span>", "You disable [src.loc]'s remote sensing equipment.")
		else
			user.visible_message("[user] adjusts the tracking sensor on [src.loc]'s [src.name].", "You adjust [src.loc]'s sensors.")
	else
		user.visible_message("[user] adjusts the tracking sensor on [src]", "You adjust the sensor on [src].")

/obj/item/clothing/under/emp_act(var/severity)
	..()
	var/new_mode
	switch(severity)
		if(1)
			new_mode = pick(75;SUIT_SENSOR_OFF, 15;SUIT_SENSOR_BINARY, 10;SUIT_SENSOR_VITAL)
		if(2)
			new_mode = pick(50;SUIT_SENSOR_OFF, 25;SUIT_SENSOR_BINARY, 20;SUIT_SENSOR_VITAL, 5;SUIT_SENSOR_TRACKING)
		else
			new_mode = pick(25;SUIT_SENSOR_OFF, 35;SUIT_SENSOR_BINARY, 30;SUIT_SENSOR_VITAL, 10;SUIT_SENSOR_TRACKING)

	sensor_mode = new_mode

/obj/item/clothing/under/verb/toggle()
	set name = "Toggle Suit Sensors"
	set category = "Object"
	set src in usr
	set_sensors(usr)

/obj/item/clothing/under/verb/rollsuit()
	set name = "Roll Down Jumpsuit"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return

	update_rolldown_status()
	if(rolled_down == -1)
		to_chat(usr, "<span class='notice'>You cannot roll down [src]!</span>")
	if((rolled_sleeves == 1) && !(rolled_down))
		rolled_sleeves = 0
		return

	rolled_down = !rolled_down
	if(rolled_down)
		body_parts_covered &= LOWER_TORSO|LEGS|FEET
		item_state_slots[slot_w_uniform_str] = worn_state + get_gender_suffix("_d_s")
	else
		body_parts_covered = initial(body_parts_covered)
		item_state_slots[slot_w_uniform_str] = worn_state + get_gender_suffix()
	update_clothing_icon()

/obj/item/clothing/under/verb/rollsleeves()
	set name = "Roll Up Sleeves"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return

	update_rollsleeves_status()
	if(rolled_sleeves == -1)
		to_chat(usr, "<span class='notice'>You cannot roll up your [src]'s sleeves!</span>")
		return
	if(rolled_down == 1)
		to_chat(usr, "<span class='notice'>You must roll up your [src] first!</span>")
		return

	rolled_sleeves = !rolled_sleeves
	if(rolled_sleeves)
		body_parts_covered &= ~(ARMS|HANDS)
		item_state_slots[slot_w_uniform_str] = worn_state + get_gender_suffix("_r_s")
		to_chat(usr, "<span class='notice'>You roll up your [src]'s sleeves.</span>")
	else
		body_parts_covered = initial(body_parts_covered)
		item_state_slots[slot_w_uniform_str] = worn_state + get_gender_suffix()
		to_chat(usr, "<span class='notice'>You roll down your [src]'s sleeves.</span>")
	update_clothing_icon()

/obj/item/clothing/under/rank/New()
	sensor_mode = pick(list_values(SUIT_SENSOR_MODES))
	..()

/obj/item/clothing/under/AltClick(var/mob/user)
	if(CanPhysicallyInteract(user))
		set_sensors(user)

///////////////////////////////////////////////////////////////////////
//Rings

/obj/item/clothing/ring
	name = "ring"
	w_class = ITEM_SIZE_TINY
	icon = 'icons/obj/clothing/obj_hands_ring.dmi'
	slot_flags = SLOT_GLOVES
	gender = NEUTER
	species_restricted = list("exclude", SPECIES_NABBER, SPECIES_DIONA)
	var/undergloves = 1
