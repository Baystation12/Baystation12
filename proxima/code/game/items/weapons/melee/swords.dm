//I'M FUCKING INVICIBLE!!!!!
/obj/item/material/sword/raiden
	name = "High frequency sword"
	desc = "a high-frequency sword, its blade is specially sharpened using a blue-space machine. The sword is barely felt in the hand, which means that it is incredibly light. and on the handle is written: 'an instrument of justice'"
	icon = 'terrania/icons/obj/weapons/melee.dmi'
	icon_state = "hfrequency0"
	item_icons = list(
		slot_l_hand_str = 'terrania/icons/mob/weapons/swords_lefthand.dmi',
		slot_r_hand_str = 'terrania/icons/mob/weapons/swords_righthand.dmi'
		)
	item_state_slots = list(
		slot_r_hand_str = "hfrequency0",
		slot_l_hand_str = "hfrequency0"
		)
	slot_flags = SLOT_BELT
	applies_material_colour = FALSE

/obj/item/melee/energy/machete/sundowner
	name = "high-frequency machete"
	desc = "a high-frequency machete, its blade is specially equipped to deliver fast and cutting blows. The sword is barely felt in the hand, which means that it is incredibly light. you feel like fucked up invulnerable"
	icon = 'terrania/icons/obj/weapons/melee.dmi'
	icon_state = "hfmachete0"
	active_icon = "hfmachete1"
	item_icons = list(
		slot_l_hand_str = 'terrania/icons/mob/weapons/swords_lefthand.dmi',
		slot_r_hand_str = 'terrania/icons/mob/weapons/swords_righthand.dmi'
		)
	item_state_slots = list(
		slot_r_hand_str = "cursed_katana",
		slot_l_hand_str = "cursed_katana"
		)
	active_force = 20
	active_throwforce = 15
	force = 5
	throwforce = 2
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_MAGNET = 3)
	active_attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	hitsound = 'sound/weapons/blade1.ogg'
