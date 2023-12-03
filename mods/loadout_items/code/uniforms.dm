/obj/item/clothing/under/scp_uniform
	name = "SCP guard uniform"
	desc = "It's dark grey uniform made of a slightly sturdier material than standard jumpsuits, to allow for good protection.\nThis uniform has SCP tags on shoulders, terran organization of NT asset protection."
	icon = 'mods/loadout_items/icons/obj_under.dmi'
	item_icons = list(slot_w_uniform_str = 'mods/loadout_items/icons/onmob_under.dmi')
	icon_state = "scp_uniform"
	item_state = "scp_uniform"
	worn_state = "scp_uniform"
	armor = list(melee = 10, bullet = 5, laser = 5,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9

/obj/item/clothing/under/zpci_uniform
	name = "ZPCI uniform"
	desc = "This is a standard model of the ZPCI uniform."
	icon = 'mods/loadout_items/icons/obj_under.dmi'
	item_icons = list(slot_w_uniform_str = 'mods/loadout_items/icons/onmob_under.dmi')
	icon_state = "zpci_uniform"
	item_state = "zpci_uniform"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0) //it's security uniform's stats
	siemens_coefficient = 0.9

/obj/item/clothing/under/rank/security/saarecombat
	name = "\improper SAARE combat uniform"
	desc = "Tight-fitting dark uniform with a bright-green SAARE patch on the shoulder. The perfect outfit in which to kick doors out and teeth in."
	icon = 'mods/loadout_items/icons/obj_under.dmi'
	item_icons = list(slot_w_uniform_str = 'mods/loadout_items/icons/onmob_under.dmi')
	icon_state = "saarecombat"
	item_state = "saarecombat"
	worn_state = "saarecombat"
	gender_icons = 1

// SIERRA TO DO: Cleanup icons from unused loadout
