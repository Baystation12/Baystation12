/obj/item/material/armblade
	icon_state = "armblade"
	item_state = null
	name = "armblade"
	icon = 'icons/obj/augment.dmi'
	applies_material_colour = 0
	desc = "A handy utility blade for the discerning augmentee. Warranty void if used for cutting."
	base_parry_chance = 30
	unbreakable = TRUE
	unacidable = TRUE
	force_multiplier = 0.2
	sharp = TRUE
	edge = TRUE
	attack_verb = list("stabbed", "sliced", "cut")
	applies_material_colour = 0

/obj/item/organ/internal/augment/active/simple/armblade
	name = "embedded blade"
	desc = "A sturdy housing for a steel utility blade."
	action_button_name = "Deploy blade"
	icon_state = "armblade"
	allowed_organs = list(BP_AUGMENT_R_ARM, BP_AUGMENT_L_ARM)
	holding_type = /obj/item/material/armblade
	//Limited to robolimbs
	augment_flags = AUGMENTATION_MECHANIC

/obj/item/material/armblade/claws
	icon_state = "wolverine"
	name = "combat claws"
	desc = "These do not grow back."
	base_parry_chance = 40
	force_multiplier = 0.3

//Alternate look
/obj/item/organ/internal/augment/active/simple/wolverine
	name = "cyberclaws"
	desc = "An unusual type of cybernetic weaponry, these sharp blades are bound to turn heads."
	action_button_name = "Deploy claws"
	icon_state = "wolverine"
	allowed_organs = list(BP_AUGMENT_R_HAND, BP_AUGMENT_L_HAND)
	holding_type = /obj/item/material/armblade/claws
	//Limited to robolimbs
	augment_flags = AUGMENTATION_MECHANIC

/// Traitor version - no parry chance but good damage, and compatible with organic limbs
/obj/item/organ/internal/augment/active/simple/wrist_blade
	name = "concealed wrist blade"
	desc = "A concealed sheath made from bio-compatible cloth, shaped for a thin blade."
	action_button_name = "Deploy blade"
	icon_state = "armblade"
	allowed_organs = list(BP_AUGMENT_R_ARM, BP_AUGMENT_L_ARM)
	holding_type = /obj/item/material/armblade/wrist
	known = FALSE // Specially designed for concealment
	origin_tech = list(TECH_COMBAT = 3, TECH_ESOTERIC = 4)
	deploy_sound = 'sound/effects/holster/sheathout.ogg'
	retract_sound = 'sound/effects/holster/sheathin.ogg'

/obj/item/material/armblade/wrist
	name = "wrist blade"
	desc = "A thin and very sharp folding blade specially made for combat, made from a specialized alloy that prevents all that nasty blood and viscera from sticking to it. Its light weight allows for rapid slashing attacks."
	icon_state = "armblade"
	item_state = "wolverine"
	base_parry_chance = 0
	force_multiplier = 0.2
	attack_cooldown_modifier = -1
	default_material = MATERIAL_PLASTEEL // Steel is so unsophisticated
	w_class = ITEM_SIZE_SMALL // Can't dismember limbs - only hands/feet

/obj/item/material/armblade/wrist/add_blood(mob/living/carbon/human/M)
	return FALSE
