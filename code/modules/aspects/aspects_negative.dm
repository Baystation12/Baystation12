/decl/aspect/negative
	name = ASPECT_HAEMOPHILE
	desc = "You're a bleeder."
	use_icon_state = "melee_2"
	aspect_cost = -1
	category = "Maluses"

/decl/aspect/negative/fragile
	name = ASPECT_FRAGILE
	desc = "You are a delicate flower."
	apply_post_species_change = 1

/decl/aspect/negative/fragile/do_post_spawn(var/mob/living/carbon/human/holder)
	if(!istype(holder))
		return
	holder.maxHealth -= (holder.species.total_health * 0.2)

/* Uncomment this when there's actually a negative aspect to it.
/decl/aspect/negative/uncanny
	name = ASPECT_UNCANNY
	desc = "There's something about you that makes people uneasy."
*/

/decl/aspect/negative/paper_skin
	name = ASPECT_PAPER_SKIN
	desc = "You could cut yourself on a plastic spork."
	parent_name = ASPECT_FRAGILE
	apply_post_species_change = 1

/decl/aspect/negative/paper_skin/do_post_spawn(var/mob/living/carbon/human/holder)
	if(!istype(holder))
		return
	for(var/obj/item/organ/external/E in holder.organs)
		E.brute_mod += initial(E.brute_mod)*0.2
		E.burn_mod  += initial(E.burn_mod)*0.2

/decl/aspect/negative/glassbones
	name = ASPECT_GLASS_BONES
	desc = "You break your bones easily."
	apply_post_species_change = 1
	parent_name = ASPECT_FRAGILE

/decl/aspect/negative/glassbones/do_post_spawn(var/mob/living/carbon/human/holder)
	if(!istype(holder))
		return
	for(var/obj/item/organ/external/E in holder.organs)
		E.min_bruised_damage -= initial(E.min_bruised_damage)*0.2
		E.min_broken_damage -=  initial(E.min_broken_damage)*0.2
		E.max_damage -=         initial(E.max_damage)*0.2
