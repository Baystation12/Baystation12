#define INNIE_OVERRIDE 'code/modules/halo/clothing/inniearmor.dmi'

/obj/item/clothing/under/innie/jumpsuit
	name = "Insurrectionist-modified Jumpsuit"
	desc = "A grey jumpsuit, modified with extra padding."
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "jumpsuit1_s"
	icon_state = "jumpsuit1_s"
	worn_state = "jumpsuit1"
	armor = list(melee = 10, bullet = 10, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

/obj/item/clothing/head/helmet/innie
	name = "Armored Helmet"
	desc = "An armored helmet composed of materials salvaged from a wide array of UNSC equipment"
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "helmet"
	icon_state = "helmet"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	armor = list(melee = 40, bullet = 30, laser = 40,energy = 5, bomb = 15, bio = 0, rad = 0)
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

/obj/item/clothing/suit/armor/innie
	name = "Salvaged Armor"
	desc = "A worn set of armor composed of materials usually found in UNSC equipment, modified for superior bullet resistance."
	icon = INNIE_OVERRIDE
	icon_state = "armor1"
	icon_override = INNIE_OVERRIDE
	blood_overlay_type = "armor1"
	armor = list(melee = 45, bullet = 40, laser = 40, energy = 40, bomb = 40, bio = 20, rad = 15)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	item_flags = THICKMATERIAL
	flags_inv = HIDETAIL
	cold_protection = UPPER_TORSO | LOWER_TORSO | ARMS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE

/obj/item/clothing/mask/innie/shemagh
	name = "Shemagh"
	desc = "A headdress designed to keep out dust and protect agains the sun."
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	icon_state = "shemagh"
	item_state = "shemagh"
	body_parts_covered = FACE
	item_flags = FLEXIBLEMATERIAL
	w_class = ITEM_SIZE_SMALL
	gas_transfer_coefficient = 0.90
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

/obj/item/clothing/suit/bomb_suit/security/colossus
	name = "Colossus Armor"
	desc = "When desperation reaches a breaking point humans will create things which are far scarier then they are practical. The collossus armor is a perfect example of this, with thick heavy layers of armor fitted all across the exterior of the body suit.Inside this armored suit the wearer becomes a walking tank provided they are wielding enough firepower to emulate such a vehicle. Even without a hand held rocket launcher any foe will be hard pressed to pierce through the robust alloys protecting its user. Though, don't expect to be able to get around the battle field with any kind of speed, the key word of being a walking tank is 'walking'."
	icon_state = "bombsuitsec"
	w_class = ITEM_SIZE_HUGE//bulky item
	item_flags = THICKMATERIAL
	flags_inv = 29
	allowed = list(/obj/item/weapon/gun/energy,/obj/item/device/radio,/obj/item/weapon/reagent_containers/spray/pepper,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/weapon/gun/magnetic)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	siemens_coefficient = 0
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	armor = list(melee = 80, bullet = 75, laser = 65, energy = 65, bomb = 80, bio = 20, rad = 15)
	armor_thickness= 120
	slowdown_general = 2
	siemens_coefficient = 0.7

/obj/item/clothing/head/bomb_hood/security/colossus
	name = "Colossus Helm"
	desc = "It's all well and good to have your body protected by a few inches of pure metal, but the colossus set is not complete without making sure your brain stays in the same condition as your body. The Colossus helm is also heavy, unwieldly and overly protective. But you can't really be a walking tank without it."
	icon_state = "bombsuitsec"
	body_parts_covered = HEAD
	item_flags = THICKMATERIAL
	w_class = ITEM_SIZE_HUGE//bulky item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	slowdown_general = 1
	siemens_coefficient = 0.7
	armor_thickness = 85
	armor = list(melee = 80, bullet = 75, laser = 70, energy = 70, bomb = 80, bio = 20, rad = 15)
	gas_transfer_coefficient = 0.90



#undef INNIE_OVERRIDE