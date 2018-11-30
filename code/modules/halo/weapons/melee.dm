
/obj/item/weapon/material/knife/combat_knife
	name = "combat knife"
	desc = "Multipurpose knife for utility use and close quarters combat"
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "Knife"
	item_state = "butterflyknife_open"
	w_class = ITEM_SIZE_SMALL
	force = 30
	throwforce = 10
	sharp = 1
	edge = 1
	hitsound = 'sound/weapons/bladeslice.ogg'

/obj/item/weapon/material/machete
	name = "machete"
	desc = "A standard issue machete used for hacking things apart. It is very sharp "
	icon= 'code/modules/halo/weapons/icons/machete.dmi'
	icon_state = "machete_obj"
	item_state = "machete"
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)


	w_class = ITEM_SIZE_LARGE
	force_divisor = 0.6
	thrown_force_divisor = 0.6
	slot_flags = SLOT_BELT | SLOT_BACK
	sharp = 1
	edge = 1
	unbreakable = 1
	attack_verb = list("chopped", "torn", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'