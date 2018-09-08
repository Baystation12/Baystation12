/obj/item/weapon/material/hatchet/tacknife/armblade
	icon_state = "armblade"
	item_state = null
	name = "armblade"
	icon = 'icons/obj/augment.dmi'
	icon_state = "armblade"
	applies_material_colour = 0
	desc = "A handy utility blade for the discerning augmentee. Warranty void if used for cutting"
	base_parry_chance = 30

/obj/item/organ/internal/augment/active/simple/armblade
	name = "embedded blade"
	desc = "A sturdy housing for a steel utility blade."
	action_button_name = "Deploy blade"
	icon_state = "armblade"
	allowed_organs = list(BP_AUGMENT_R_ARM, BP_AUGMENT_L_ARM)
	holding_type = /obj/item/weapon/material/hatchet/tacknife/armblade
	//Limited to robolimbs
	augment_flags = AUGMENTATION_MECHANIC



/obj/item/weapon/material/hatchet/tacknife/armblade/claws
	icon_state = "wolverine"
	name = "Combat claws"
	desc = "These do not grow back"
	base_parry_chance = 40
	force_divisor = 0.3

//Alternate look
/obj/item/organ/internal/augment/active/simple/wolverine
	name = "Cyberclaws"
	desc = "An unusual type of cybernetic weaponry, these sharp blades are bound to turn heads"
	action_button_name = "Deploy claws"
	icon_state = "wolverine"
	allowed_organs = list(BP_AUGMENT_R_HAND, BP_AUGMENT_L_HAND)
	holding_type = /obj/item/weapon/material/hatchet/tacknife/armblade/claws