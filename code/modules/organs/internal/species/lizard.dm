/obj/item/organ/internal/mogendrix
	name = "mogendrix"
	desc = "A sack of some kind, found in an Unathi. Purportedly aids in blood fabrication. You're not sure how."
	icon_state = "vox lung"
	color = "#ed81f1"
	organ_tag = BP_MOGENDRIX
	parent_organ = BP_CHEST
	var/mogine_level = 5
	var/raw_amount = 2

/obj/item/organ/internal/mogendrix/Process()
	if(owner)
		var/amount = raw_amount
		if(is_broken())
			return
		else if(is_bruised())
			amount *= 0.5

		var/mogine_volume_raw = owner.reagents.get_reagent_amount(/datum/reagent/mogine)

		if(mogine_volume_raw < mogine_level)
			owner.reagents.add_reagent(/datum/reagent/mogine, amount)
	..()


/obj/item/organ/internal/cardioasylant
	name = "cardioasylant"
	desc = "A strange piece of meat, once attached to the heart of an Unathi. Or maybe never, and about to be. Assists in cardiovascular function after trauma."
	icon_state = "hindtongue"
	max_damage = 100
	min_bruised_damage = 50
	min_broken_damage = 25
	color = "#92766c"
	organ_tag = BP_CARDIOASYLANT
	parent_organ = BP_CHEST

/obj/item/organ/internal/cardioasylant/Process()
	if(is_broken())
		return
		if(owner && (prob(5) && owner.is_asystole()))
			(owner.resuscitate())
				take_internal_damage(max_damage * 0.25)

/obj/item/organ/internal/brain/unathi
	name = "large brain"
	desc = "A rotund, thick and suprisingly heavy piece of meat, found inside someone else's head, probably. hopefully."
	attack_verb = list("thworped", "slapped", "splatted", "ancestrally insulted")
	relative_size = 70

/obj/item/organ/internal/brain/unathi/Initialize()
	. = ..()
	set_max_damage(300)

/obj/item/organ/internal/lungs/unathi
	name = "air sack"
	desc = "A thin, long, pair of fleshy bits found in an Unathi's chest cavity, or supposed to, anyways. Looks like a pair of meat shopping bags attatched to a tube."
	max_damage = 20
	min_broken_damage = 15
	min_bruised_damage = 10
	relative_size = 70
	max_pressure_diff = 40
	attack_verb = list("slapped", "flapped")


/obj/item/organ/internal/lungs/unathi/gills
	has_gills = TRUE