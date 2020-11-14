//INTERNAL ORGANS
/obj/item/organ/internal/lungs/plasmasans
	name = "phoronized lungs"
	//icon_state = "lungs-plasma"
	desc = "A set of lungs seemingly made out of fleshy phoron."
	/*
	breath_type = GAS_PHORON
	poison_types = list(GAS_OXYGEN = TRUE) //It burns to breathe!
	exhale_type = GAS_HYDROGEN
	*/
	color = "#7e4ba0"

/obj/item/organ/internal/liver/plasmasans
	name = "phoron processor"
	desc = "A fleshy hunk of phoron that looks a little like a liver."
	parent_organ = BP_CHEST
	color = "#7e4ba0"

/obj/item/organ/internal/heart/plasmasans
	name = "phoron pump"
	parent_organ = BP_CHEST
	color = "#7e4ba0"

/obj/item/organ/internal/brain/plasmasans
	name = "crystallized brain"
	desc = "A brain seemingly made out of both crystallized phoron and brain matter."
	parent_organ = BP_HEAD
	color = "#7e4ba0"

/obj/item/organ/internal/eyes/plasmasans
	name = "crystallized eyeballs"
	desc = "A pair of crystal spheres in the shape of eyes. They give off a faint glow."
	phoron_guard = 1

/obj/item/organ/internal/eyes/plasmasans/New()
	..()
	update_colour()

//EXTERNAL ORGANS
//Phoron reinforced bones woo.
/obj/item/organ/external/head/plasmasans
	min_broken_damage = 50

/obj/item/organ/external/chest/plasmasans
	min_broken_damage = 50

/obj/item/organ/external/groin/plasmasans
	min_broken_damage = 50

/obj/item/organ/external/arm/plasmasans
	min_broken_damage = 45

/obj/item/organ/external/arm/right/plasmasans
	min_broken_damage = 45

/obj/item/organ/external/leg/plasmasans
	min_broken_damage = 45

/obj/item/organ/external/leg/right/plasmasans
	min_broken_damage = 45

/obj/item/organ/external/foot/plasmasans
	min_broken_damage = 30

/obj/item/organ/external/foot/right/plasmasans
	min_broken_damage = 30

/obj/item/organ/external/hand/plasmasans
	min_broken_damage = 30

/obj/item/organ/external/hand/right/plasmasans
	min_broken_damage = 30
