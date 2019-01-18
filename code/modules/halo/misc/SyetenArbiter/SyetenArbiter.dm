/obj/item/clothing/suit/armor/special/combatharness/arbiter
    name = "Arbiter Combat Harness"
    desc = "A protective harness for use during combat by the arbiter."
    icon_state = "dogler-arbiter-suit_obj"
    item_state = "dogler-arbiter-suit_worn"
    totalshields = 150

/obj/item/clothing/head/helmet/sangheili/arbiter
	name = "Arbiter Helmet"
	desc = "A protective helmet for use during combat by an arbiter."
	icon_state = "dogler-arbiter-helm_obj"
	item_state = "dogler-arbiter-helm_worn"

/obj/item/clothing/shoes/sangheili/arbiter
	name = "Arbiter Leg Armour"
	desc = "Protective leg armour for use by an arbiter."
	icon_state = "dogler-arbiter-boots_obj"
	item_state = "dogler-arbiter-boots_worn"

/obj/item/clothing/gloves/thick/sangheili/arbiter
	name = "Arbiter Gauntlets"
	desc = "Protective gloves for use by an arbiter."
	icon_state = "dogler-arbiter-gloves_obj"
	item_state = "dogler-arbiter-gloves_worn"

/obj/item/clothing/mask/sangheili/arbiter
	name = "Arbiter Mask"
	desc = "A mask for covering your face."
	icon = 'icons/syetenarbiter.dmi'
	icon_state = "dogler-arbiter-mask_obj"
	item_state = "dogler-arbiter-mask_worn"

/obj/item/weapon/melee/energy/energystave
	name = "Energy Stave"
	desc = "An energy stave with a shimmering blade."
	icon = 'icons/syetenarbiter.dmi'
	icon_state = "dogler-staff_obj"
	item_state = "dogler-staff_obj"
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/misc/SyetenArbiter/inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/misc/SyetenArbiter/inhands_right.dmi'
		)
	force = 65
	throwforce = 12
	edge = 0
	sharp = 0
