//A sledgehammer
/obj/item/material/twohanded/sledgehammer
	name = "sledgehammer"
	desc = "A hefty hammer. You feel like smashing your superior's face in with this."

	icon = 'icons/obj/weapons/melee_physical.dmi'
	icon_state = "sledgehammer0"
	base_icon = "sledgehammer"

	slot_flags = SLOT_BELT //You can fit a sledgehammer on your belt
	w_class = ITEM_SIZE_HUGE

	attack_verb = list("bashed", "bludgeoned", "hammered", "conked", "slammed")
	hitsound = 'sound/weapons/heavysmash.ogg'

	default_material = MATERIAL_PLASTEEL
	applies_material_colour = FALSE

	max_force = 65
	force_multiplier = 0.6
	unwielded_force_divisor = 0.3
	attack_cooldown_modifier = 7