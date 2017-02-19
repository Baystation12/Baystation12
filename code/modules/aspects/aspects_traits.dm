/decl/aspect/leadpoisoning
	name = ASPECT_RADHARDENED
	desc = "Those ancient water pipes have left you resistant to radiation."

/decl/aspect/hardy
	name = ASPECT_HARDY
	desc = "You were born with thick skin."
	use_icon_state = "kitchen_3"
	apply_post_species_change = 1

/decl/aspect/hardy/do_post_spawn(var/mob/living/carbon/human/holder)
	if(!istype(holder))
		return
	holder.maxHealth += (holder.species.total_health * 0.1)

/decl/aspect/thickbones
	name = ASPECT_THICKBONES
	desc = "You always were big-boned."
	parent_name = ASPECT_HARDY
	use_icon_state = "kitchen_3"
	apply_post_species_change = 1

/decl/aspect/thickbones/do_post_spawn(var/mob/living/carbon/human/holder)
	if(!istype(holder))
		return
	for(var/obj/item/organ/external/E in holder.organs)
		E.min_bruised_damage += initial(E.min_bruised_damage)*0.1
		E.min_broken_damage +=  initial(E.min_broken_damage)*0.1
		E.max_damage +=         initial(E.max_damage)*0.1

/decl/aspect/scarred
	name = ASPECT_SCARRED
	desc = "There are so many scars on your hide that weapons have a hard time getting through."
	use_icon_state = "kitchen_3"
	parent_name = ASPECT_HARDY
	apply_post_species_change = 1

/decl/aspect/scarred/do_post_spawn(var/mob/living/carbon/human/holder)
	if(!istype(holder))
		return
	for(var/obj/item/organ/external/E in holder.organs)
		E.brute_mod -= initial(E.brute_mod)*0.1

/decl/aspect/hotstuff
	name = ASPECT_HOTSTUFF
	desc = "You're pretty good at coping with burns."
	use_icon_state = "kitchen_3"
	parent_name = ASPECT_HARDY
	apply_post_species_change = 1

/decl/aspect/hotstuff/do_post_spawn(var/mob/living/carbon/human/holder)
	if(!istype(holder))
		return
	for(var/obj/item/organ/external/E in holder.organs)
		E.burn_mod -= initial(E.burn_mod)*0.1
/*
/decl/aspect/sharpeyed
	name = ASPECT_SHARPEYED
	desc = "You can see well in darkness."
	apply_post_species_change = 1

/decl/aspect/sharpeyed/do_post_spawn(var/mob/living/carbon/human/holder)
	if(!istype(holder))
		return
	holder.dark_plane.alpha = initial(holder.dark_plane.alpha) + 15

/decl/aspect/robuddy
	name = ASPECT_ROBUDDY
	desc = "You've spent a lot of time and money on customizing a small helper drone. Open source!"

/decl/aspect/robuddy/do_post_spawn(var/mob/living/carbon/human/holder)
	if(!istype(holder))
		return
	// Drone doesn't exist yet, rip.
*/

/decl/aspect/company_man
	name = ASPECT_COMPANYMAN
	desc = "The Company has your back, and ensures you have plenty of cash to throw around."
	aspect_cost = 3

/decl/aspect/company_man/do_post_spawn(var/mob/living/carbon/human/holder)
	if(!istype(holder))
		return
	holder.put_in_hands(new /obj/item/weapon/storage/secure/briefcase/money(get_turf(holder)))

/decl/aspect/junkie
	name = ASPECT_JUNKIE
	desc = "You've got the goods."
	aspect_cost = 2

/decl/aspect/junkie/do_post_spawn(var/mob/living/carbon/human/holder)
	if(!istype(holder))
		return
	var/pilltype = pick(list(
		/obj/item/weapon/storage/pill_bottle/happy,
		/obj/item/weapon/storage/pill_bottle/zoom,
		))
	holder.put_in_hands(new pilltype(get_turf(holder)))

/decl/aspect/green_thumb
	name = ASPECT_GREENTHUMB
	desc = "You love plants. Like, a lot. Someone needs to have an intervention."
	aspect_cost = 2

/decl/aspect/ninja
	name = ASPECT_NINJA
	desc = "You grew up as part of the Spider Clan, learning how to make good use of throwing weapons and stealth."
	aspect_cost = 2

/decl/aspect/ninja/do_post_spawn(var/mob/living/carbon/human/holder)
	if(!istype(holder))
		return
	holder.put_in_hands(new /obj/item/weapon/material/star(get_turf(holder)))
	holder.equip_to_slot_or_del(new /obj/item/weapon/material/star(get_turf(holder), slot_r_store))
	holder.equip_to_slot_or_del(new /obj/item/weapon/material/star(get_turf(holder), slot_l_store))

/decl/aspect/tribal
	name = ASPECT_TRIBAL
	desc = "You hail from a borderworld that hasn't really caught up to the rest of the pack just yet."
	aspect_cost = 2

/decl/aspect/tribal/do_post_spawn(var/mob/living/carbon/human/holder)
	if(!istype(holder))
		return
	holder.put_in_hands(new /obj/item/weapon/material/twohanded/spear(get_turf(holder)))
	var/obj/item/clothing/suit/unathi/mantle/mantle = new(get_turf(holder))
	holder.equip_to_slot_if_possible(mantle, slot_wear_suit)