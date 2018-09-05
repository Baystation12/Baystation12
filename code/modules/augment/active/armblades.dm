/obj/item/weapon/material/hatchet/tacknife/armblade
	icon_state = "armblade"
	item_state = null
	name = "armblade"
	icon = 'icons/obj/augment.dmi'
	icon_state = "armblade"
	applies_material_colour = 0

/obj/item/organ/internal/augment/active/simple/armblade
	name = "embedded blade"
	action_button_name = "Deploy blade"
	icon_state = "armblade"
	allowed_organs = list(BP_R_HAND, BP_L_HAND)
	holding_type = /obj/item/weapon/material/hatchet/tacknife/armblade
	//Limited to robolimbs
	augment_flags = AUGMENTATION_MECHANIC



/obj/item/weapon/material/hatchet/tacknife/armblade/claws
	icon_state = "wolverine"
	name = "claws"

//Alternate look
/obj/item/organ/internal/augment/active/simple/wolverine
	name = "embedded claws"
	action_button_name = "Deploy embed claws"
	icon_state = "wolverine"
	allowed_organs = list(BP_R_HAND, BP_L_HAND)
	holding_type = /obj/item/weapon/material/hatchet/tacknife/armblade/claws