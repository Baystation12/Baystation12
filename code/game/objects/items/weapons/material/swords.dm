/obj/item/material/sword
	name = "claymore"
	desc = "What are you standing around staring at this for? Get to killing!"
	icon = 'icons/obj/weapons/melee_physical.dmi'
	icon_state = "claymore"
	item_state = "claymore"
	slot_flags = SLOT_BELT
	w_class = ITEM_SIZE_LARGE
	force_multiplier = 0.5 // 30 when wielded with hardness 60 (steel)
	armor_penetration = 10
	thrown_force_multiplier = 0.5 // 10 when thrown with weight 20 (steel)
	sharp = TRUE
	edge = TRUE
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	base_parry_chance = 50
	melee_accuracy_bonus = 10
	worth_multiplier = 30

/obj/item/material/sword/replica
	max_force = 10
	edge = FALSE
	sharp = FALSE
	force_multiplier = 0.2
	thrown_force_multiplier = 0.2
	worth_multiplier = 15

/obj/item/material/sword/makeshift
	desc = "A large, unwieldy blade haphazardly tied together with rod and wire. The weapon of the modern caveman."
	icon_state = "makeshift_sword"
	force_multiplier = 0.5
	attack_cooldown = 30 // slow.
	thrown_force_multiplier = 0.2
	base_parry_chance = 25
	worth_multiplier = 5
	slot_flags = SLOT_BELT | SLOT_BACK

/obj/item/material/sword/katana
	name = "katana"
	desc = "Woefully underpowered in D20. This one looks pretty sharp."
	icon = 'icons/obj/weapons/melee_physical.dmi'
	icon_state = "katana"
	item_state = "katana"
	furniture_icon = "katana_handle"
	slot_flags = SLOT_BELT | SLOT_BACK

/obj/item/material/sword/katana/replica
	max_force = 10
	edge = FALSE
	sharp = FALSE
	force_multiplier = 0.2
	thrown_force_multiplier = 0.2

/obj/item/material/sword/katana/vibro
	name = "vibrokatana"
	desc = "A high-tech take on a woefully underpowered weapon. Can't mistake its sound for anything."
	default_material = MATERIAL_TITANIUM
	hitsound = 'sound/weapons/anime_sword.wav'

/obj/item/material/sword/katana/vibro/equipped(mob/user, slot)
	if(slot == slot_l_hand || slot == slot_r_hand)
		playsound(src, 'sound/weapons/katana_out.wav', 50, 1, -5)
