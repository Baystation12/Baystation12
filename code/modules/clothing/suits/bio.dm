//Biosuit complete with shoes (in the item sprite)
/obj/item/clothing/head/bio_hood
	name = "bio hood"
	icon_state = "bio"
	item_state_slots = list(
		slot_l_hand_str = "bio_hood",
		slot_r_hand_str = "bio_hood",
		)
	desc = "A hood that protects the head and face from biological comtaminants."
	permeability_coefficient = 0.01
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 20)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES
	siemens_coefficient = 0.9

/obj/item/clothing/suit/bio_suit
	name = "bio suit"
	desc = "A suit that protects against biological contamination."
	icon_state = "bio"
	item_state = "bio_suit"
	w_class = ITEM_SIZE_HUGE//bulky item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/weapon/tank/emergency,/obj/item/weapon/pen,/obj/item/device/flashlight/pen,/obj/item/device/healthanalyzer,/obj/item/device/ano_scanner,/obj/item/clothing/head/bio_hood,/obj/item/clothing/mask/gas)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 20)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL
	siemens_coefficient = 0.9

/obj/item/clothing/suit/bio_suit/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 1.0

//Standard biosuit, orange stripe
/obj/item/clothing/head/bio_hood/general
	icon_state = "bio_general"
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/suit/bio_suit/general
	icon_state = "bio_general"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|HANDS|FEET
	flags_inv = HIDEJUMPSUIT|HIDETAIL|HIDEGLOVES|HIDESHOES

//Virology biosuit, green stripe
/obj/item/clothing/head/bio_hood/virology
	icon_state = "bio_virology"

/obj/item/clothing/suit/bio_suit/virology
	icon_state = "bio_virology"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|HANDS|FEET
	flags_inv = HIDEJUMPSUIT|HIDETAIL|HIDEGLOVES|HIDESHOES

//Security biosuit, grey with red stripe across the chest
/obj/item/clothing/head/bio_hood/security
	icon_state = "bio_security"

/obj/item/clothing/suit/bio_suit/security
	icon_state = "bio_security"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|HANDS|FEET
	flags_inv = HIDEJUMPSUIT|HIDETAIL|HIDEGLOVES|HIDESHOES

//Janitor's biosuit, grey with purple arms
/obj/item/clothing/head/bio_hood/janitor
	icon_state = "bio_janitor"

/obj/item/clothing/suit/bio_suit/janitor
	icon_state = "bio_janitor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|HANDS|FEET
	flags_inv = HIDEJUMPSUIT|HIDETAIL|HIDEGLOVES|HIDESHOES


//Scientist's biosuit, white with a pink-ish hue
/obj/item/clothing/head/bio_hood/scientist
	icon_state = "bio_scientist"

/obj/item/clothing/suit/bio_suit/scientist
	icon_state = "bio_scientist"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|HANDS|FEET
	flags_inv = HIDEJUMPSUIT|HIDETAIL|HIDEGLOVES|HIDESHOES

//CMO's biosuit, blue stripe
/obj/item/clothing/suit/bio_suit/cmo
	icon_state = "bio_cmo"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|HANDS|FEET
	flags_inv = HIDEJUMPSUIT|HIDETAIL|HIDEGLOVES|HIDESHOES

/obj/item/clothing/head/bio_hood/cmo
	icon_state = "bio_cmo"


//Plague Dr mask can be found in clothing/masks/gasmask.dm
/obj/item/clothing/suit/bio_suit/plaguedoctorsuit
	name = "Plague doctor suit"
	desc = "It protected doctors from the Black Death, back then. You bet your arse it's gonna help you against viruses."
	icon_state = "plaguedoctor"
	item_state = "bio_suit"
	flags_inv = HIDEGLOVES|HIDEJUMPSUIT|HIDETAIL
