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
	desc = "When desperation reaches a breaking point humans will create things which are far scarier then they are practical. The colossus armor is a perfect example of this, with multiple layers of heavy impact plating fitted all across the exterior of the body suit, inside this, the wearer becomes a walking tank provided they are wielding enough firepower to emulate such a vehicle. Even without a hand held rocket launcher any foe will be hard pressed to pierce through the robust alloys protecting its user. Though, don't expect to be able to get around the battle field with any kind of speed, the key word of being a walking tank is 'walking'."
	icon_state = "bombsuitsec"
	w_class = ITEM_SIZE_HUGE//bulky item
	item_flags = THICKMATERIAL
	allowed = list(/obj/item/weapon/gun/energy,/obj/item/device/radio,/obj/item/weapon/reagent_containers/spray/pepper,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/weapon/gun/magnetic)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	flags_inv = 29
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	siemens_coefficient = 0
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	armor = list(melee = 50, bullet = 50, laser = 50, energy = 50, bomb = 80, bio = 20, rad = 15)
	armor_thickness= 30
	slowdown_general = 2
	siemens_coefficient = 0.7

/obj/item/clothing/head/bomb_hood/security/colossus
	name = "Colossus Helm"
	desc = "It's all well and good to have your body protected by a few inches of pure metal, but the colossus set is not complete without making sure your brain stays in the same condition as your body. The Colossus helm is also heavy, unwieldly and covered in multiple layers of heavy impact plating. But you can't really be a walking tank without it."
	icon_state = "bombsuitsec"
	body_parts_covered = HEAD
	item_flags = THICKMATERIAL
	w_class = ITEM_SIZE_HUGE//bulky item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	slowdown_general = 1
	siemens_coefficient = 1.5
	armor_thickness = 60
	armor = list(melee = 50, bullet = 50, laser = 50, energy = 50, bomb = 80, bio = 20, rad = 15)
	gas_transfer_coefficient = 0.90
	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4
	on = 0

/obj/item/weapon/storage/briefcase/colossuscase
	name = "Thick Brief Case"
	desc = "This is a hardy metal bound briefcase which seems larger then your normal carry on. Inside of this enourmous case you can see there are two molded slots which seem perfectly fitted for both the Colossus Armor and Helmet in their entirety. You should silently thank whatever various diety you believe in that this case even exists in the first place."
	icon_state = "colossuscase"
	item_state = "colossuscase"
	flags = CONDUCT
	force = 10.0
	throw_speed = 1
	throw_range = 4
	w_class = ITEM_SIZE_HUGE
	max_w_class = ITEM_SIZE_HUGE
	max_storage_space = 32
	can_hold = list(/obj/item/clothing/head/bomb_hood/security/colossus, /obj/item/clothing/suit/bomb_suit/security/colossus)
	slowdown_general = 0

/obj/item/clothing/suit/justice/zeal
	name = "Zeal Scout Suit"
	desc = "The Zeal suit was initially designed by URF research efforts to create a scout suit which their forces could utilize on a large scale across multiple systems. Geminus Colony scientists were contracted for the project so that suspicion wouldn't be drawn to the scattered URF bases near Sol due to technological requirements of the initial design. When it was finished the URF had on their hands an advanced uniform which also provided moderate defense for the wearer. The armor is carefully constructed with nano-kinetic motors built into the joints between the small segments of armor provide enhanced speed by continuously storing and releasing kinetic energy from the users natural movements. Though it is a powerful addition to the URF's compliment of existing equipment the rare minerals required to power and store this kind of energy meant that the URF was only initially capable of small scale production. In the end only the largest URF bases ended up recieving any number of these suits to help in their efforts of liberation. Because of its light weight the suit has no storage capacity to speak of, only being capable of holding a single weapon on its magnetic harness. Due to the nature of the armor's abilities excess weight taken on by the user can lead to overtaxing the motors and a loss of speed very quickly."
	w_class = ITEM_SIZE_LARGE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|HANDS|LEGS|FEET
	flags_inv = 29|HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	allowed = list(/obj/item/weapon/gun)
	slowdown_general = 1
	armor_thickness = 10 //Should be able to take 5-6 bullets before shattering.
	siemens_coefficient = 1.5
	armor = list(melee = 25, bullet = 30, laser = 20, energy = 20, bomb = 20, bio = 10, rad = 15)

/obj/item/clothing/suit/justice/zeal/New()
	..()
	slowdown_per_slot[slot_wear_suit] = -2

#undef INNIE_OVERRIDE