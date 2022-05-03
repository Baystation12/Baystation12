/obj/item/clothing/head/champhelm
	name = "champion's crown"
	desc = "A spiky, golden crown. It's probably worth more than your bank account."
	icon_state = "champhelm"
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH, 
		bullet = ARMOR_BALLISTIC_AP, 
		laser = ARMOR_LASER_HANDGUNS, 
		energy = ARMOR_ENERGY_SMALL, 
		bomb = ARMOR_BOMB_RESISTANT, 
		bio = ARMOR_BIO_MINOR
		)
	species_restricted = list(SPECIES_HUMAN)

/obj/item/clothing/suit/champarmor
	name = "champion's armor"
	desc = "A mighty suit of silver and gold armor, with a gleaming blue crystal inlaid into its left gaunlet."
	icon_state = "champarmor"
	siemens_coefficient = 0.5
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH, 
		bullet = ARMOR_BALLISTIC_AP, 
		laser = ARMOR_LASER_HANDGUNS, 
		energy = ARMOR_ENERGY_SMALL, 
		bomb = ARMOR_BOMB_RESISTANT, 
		bio = ARMOR_BIO_MINOR
		)

/obj/item/clothing/under/bluetunic
	name = "blue tunic"
	desc = "A royal blue tunic. Beautifully archaic."
	icon_state = "bluetunic"
	siemens_coefficient = 0.8
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	armor = list(
		melee = ARMOR_MELEE_MINOR
	)
	species_restricted = list(SPECIES_HUMAN)

/obj/item/clothing/shoes/jackboots/medievalboots
	name = "leather boots"
	desc = "Old-fashioned leather boots. Probably not something you want to get kicked with."
	icon_state = "medievalboots"
	force = 5
	armor = list(
		melee = ARMOR_MELEE_RESISTANT, 
		bullet = ARMOR_BALLISTIC_MINOR, 
		laser = ARMOR_LASER_MINOR, 
		energy = ARMOR_ENERGY_MINOR, 
		bomb = ARMOR_BOMB_PADDED
	)

/obj/item/excalibur
	name = "champion's blade"
	desc = "<i>For at his belt hung Excalibur, the finest sword that there was, which sliced through iron as through wood.</i>"
	icon = 'icons/obj/weapons/melee_physical.dmi'
	icon_state = "excalibur"
	item_icons = list(
					slot_l_hand_str = 'icons/mob/onmob/items/lefthand.dmi',
					slot_r_hand_str = 'icons/mob/onmob/items/righthand.dmi',
					slot_belt_str = 'icons/mob/onmob/onmob_belt.dmi'
					)
	item_state = "excalibur"
	edge = TRUE
	sharp = TRUE
	w_class = ITEM_SIZE_HUGE
	force = 35
	throw_range = 2
	throwforce = 10
	slot_flags = SLOT_BELT
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "cleaved", "sundered")

/obj/item/excalibur/pickup(var/mob/living/user as mob)
	if(user.mind)
		if(!GLOB.wizards.is_antagonist(user.mind) || user.mind.special_role != ANTAG_SERVANT)
			START_PROCESSING(SSobj, src)
			to_chat(user,"<span class='danger'>\The [src] heats up in your hands, burning you!</span>")

/obj/item/excalibur/Process()
	if(istype(loc, /mob/living))
		if(istype(loc, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = loc
			var/hand = BP_R_HAND
			if(H.l_hand == src)
				hand = BP_L_HAND
			var/obj/item/organ/external/E = H.get_organ(hand)
			E.take_external_damage(burn=2,used_weapon="stovetop")
		else
			var/mob/living/M = loc
			M.adjustFireLoss(2)
		if(prob(2))
			to_chat(loc,"<span class='danger'>\The [src] is burning you!</span>")
	return 1

/obj/item/excalibur/dropped()
	STOP_PROCESSING(SSobj, src)