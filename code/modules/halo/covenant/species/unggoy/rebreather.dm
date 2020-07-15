
/obj/item/clothing/mask/rebreather
	name = "Unggoy Rebreather Mask"
	desc = "A breathing device fitted for Unggoy, who breathe a methane atmospheric mix. This one has some protective armour for the head."
	icon_state = "mask"
	item_state = "rebreather"
	icon = GRUNT_GEAR_ICON
	icon_override = GRUNT_GEAR_ICON

	species_restricted = list("Unggoy")
	item_state_slots = list(slot_l_hand_str = "armor", slot_r_hand_str = "armor")

	body_parts_covered = HEAD|FACE
	item_flags = BLOCK_GAS_SMOKE_EFFECT | AIRTIGHT | FLEXIBLEMATERIAL
	armor = list(melee = 40, bullet = 20, laser = 35,energy = 35, bomb = 20, bio = 0, rad = 0)
	armor_thickness = 10
	unacidable = 1

	var/rebreath_efficiency = 50 //Rebreather efficiency: Percentile
	matter = list("nanolaminate" = 1)

/obj/item/clothing/mask/rebreather/small
	name = "Small Unggoy Rebreather Mask"
	desc = "A breathing device fitted for Unggoy, who breathe a methane atmospheric mix."
	item_state = "rebreather_small"
	body_parts_covered = FACE
	item_flags = AIRTIGHT|FLEXIBLEMATERIAL
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	armor_thickness = 0

/obj/item/clothing/mask/rebreather/post_internals_breathe(var/datum/gas_mixture/removed_gas,var/obj/item/weapon/tank/tank_removed_from)
	var/datum/gas_mixture/gas_rebreathed = new
	gas_rebreathed.copy_from(removed_gas)
	gas_rebreathed.multiply(rebreath_efficiency/100)//A rebreather: Recycle some of the gas used up due to breathing.
	tank_removed_from.air_contents.merge(gas_rebreathed)
	qdel(gas_rebreathed)

/obj/item/clothing/mask/rebreather/equipped(var/mob/user, var/slot)
	. = ..()
	if(slot == slot_wear_mask)
		var/obj/item/weapon/tank/internal = locate() in user
		if(internal)
			internal.toggle_valve(user)

/obj/item/clothing/mask/rebreather/unggoy_spec_ops
	name = "Unggoy Rebreather Mask (Spec-Ops)"
	icon_state = "mask_white"
	item_state = "rebreather_specops"
	rebreath_efficiency = 75

/obj/item/clothing/mask/rebreather/unggoy_deacon
	name = "Unggoy Rebreather Mask (Deacon)"
	icon_state = "mask_white"
	item_state = "rebreather_deacon"
	rebreath_efficiency = 75

/obj/item/clothing/mask/rebreather/unggoy_ultra
	name = "Unggoy Rebreather Mask (Ultra)"
	rebreath_efficiency = 75

/obj/item/clothing/mask/rebreather/unggoy_heavy
	name = "Unggoy Rebreather Mask (Heavy)"
	icon_state = "mask_green"
	item_state = "rebreather_heavy"
	rebreath_efficiency = 75

/obj/item/clothing/mask/rebreather/unggoy_honour_guard
	name = "Unggoy Rebreather Mask (Honour Guard)"
	icon_state = "mask_red"
	item_state = "rebreather_honour"
	rebreath_efficiency = 75
