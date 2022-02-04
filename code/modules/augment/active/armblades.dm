/obj/item/material/armblade
	icon_state = "armblade"
	item_state = null
	name = "armblade"
	icon = 'icons/obj/augment.dmi'
	applies_material_colour = FALSE
	desc = "A handy utility blade for the discerning augmentee. Warranty void if used for cutting."
	base_parry_chance = 30
	unbreakable = TRUE
	unacidable = TRUE
	force_multiplier = 0.2
	sharp = TRUE
	edge = TRUE
	attack_verb = list("stabbed", "sliced", "cut")


/obj/item/organ/internal/augment/active/item/armblade
	name = "embedded blade"
	desc = "A sturdy housing for a steel utility blade."
	action_button_name = "Deploy blade"
	icon_state = "armblade"
	augment_slots = AUGMENT_ARM
	item = /obj/item/material/armblade
	augment_flags = AUGMENT_MECHANICAL | AUGMENT_SCANNABLE


/obj/item/material/armblade/claws
	icon_state = "wolverine"
	name = "combat claws"
	desc = "These do not grow back."
	base_parry_chance = 40
	force_multiplier = 0.3


/obj/item/organ/internal/augment/active/item/wolverine
	name = "cyberclaws"
	desc = "An unusual type of cybernetic weaponry, these sharp blades are bound to turn heads."
	action_button_name = "Deploy claws"
	icon_state = "wolverine"
	augment_slots = AUGMENT_HAND
	item = /obj/item/material/armblade/claws
	augment_flags = AUGMENT_MECHANICAL | AUGMENT_SCANNABLE


/// Traitor version - no parry chance but good damage, and compatible with organic limbs
/obj/item/organ/internal/augment/active/item/wrist_blade
	name = "concealed wrist blade"
	desc = "A concealed sheath made from bio-compatible cloth, shaped for a thin blade."
	action_button_name = "Deploy blade"
	icon_state = "armblade"
	augment_slots = AUGMENT_ARM
	item = /obj/item/material/armblade/wrist
	origin_tech = list(TECH_COMBAT = 3, TECH_ESOTERIC = 4)
	deploy_sound = 'sound/effects/holster/sheathout.ogg'
	retract_sound = 'sound/effects/holster/sheathin.ogg'
	augment_flags = AUGMENT_MECHANICAL | AUGMENT_BIOLOGICAL


/obj/item/material/armblade/wrist
	name = "wrist blade"
	desc = "A thin and very sharp folding blade specially made for combat, made from a specialized alloy that prevents all that nasty blood and viscera from sticking to it. Its light weight allows for rapid slashing attacks."
	icon_state = "wristblade"
	item_state = "wristblade"
	base_parry_chance = 0
	force_multiplier = 0.2
	attack_cooldown_modifier = -1
	default_material = MATERIAL_PLASTEEL

	/// SMALL prevents dismembering limbs - only hands & feet
	w_class = ITEM_SIZE_SMALL


/obj/item/material/armblade/wrist/add_blood(mob/living/carbon/human/M)
	return FALSE
