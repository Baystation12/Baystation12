#define PUKE_ACTION_NAME "Empty Stomach"

/obj/item/organ/internal/stomach
	name = "stomach"
	desc = "Gross. This is hard to stomach."
	icon_state = "stomach"
	dead_icon = "stomach"
	organ_tag = BP_STOMACH
	parent_organ = BP_GROIN
	var/stomach_capacity
	var/datum/reagents/metabolism/ingested
	var/next_cramp = 0

/obj/item/organ/internal/stomach/Destroy()
	QDEL_NULL(ingested)
	. = ..()

/obj/item/organ/internal/stomach/New()
	..()
	ingested = new/datum/reagents/metabolism(240, owner, CHEM_INGEST)
	if(!ingested.my_atom)
		ingested.my_atom = src
	if(species.gluttonous)
		action_button_name = PUKE_ACTION_NAME

/obj/item/organ/internal/stomach/removed()
	. = ..()
	ingested.my_atom = src
	ingested.parent = null

/obj/item/organ/internal/stomach/replaced()
	. = ..()
	ingested.my_atom = owner
	ingested.parent = owner

/obj/item/organ/internal/stomach/proc/can_eat_atom(var/atom/movable/food)
	return !isnull(get_devour_time(food))

/obj/item/organ/internal/stomach/proc/is_full(var/atom/movable/food)
	var/total = Floor(ingested.total_volume / 10)
	for(var/a in contents + food)
		if(ismob(a))
			var/mob/M = a
			total += M.mob_size
		else if(isobj(a))
			var/obj/item/I = a
			total += I.get_storage_cost()
		else
			continue
		if(total > species.stomach_capacity)
			return TRUE
	return FALSE

/obj/item/organ/internal/stomach/proc/get_devour_time(var/atom/movable/food)
	if(iscarbon(food) || isanimal(food))
		var/mob/living/L = food
		if((species.gluttonous & GLUT_TINY) && (L.mob_size <= MOB_TINY) && !ishuman(food)) // Anything MOB_TINY or smaller
			return DEVOUR_SLOW
		else if((species.gluttonous & GLUT_SMALLER) && owner.mob_size > L.mob_size) // Anything we're larger than
			return DEVOUR_SLOW
		else if(species.gluttonous & GLUT_ANYTHING) // Eat anything ever
			return DEVOUR_FAST
	else if(istype(food, /obj/item) && !istype(food, /obj/item/weapon/holder)) //Don't eat holders. They are special.
		var/obj/item/I = food
		var/cost = I.get_storage_cost()
		if(cost != ITEM_SIZE_NO_CONTAINER)
			if((species.gluttonous & GLUT_ITEM_TINY) && cost < 4)
				return DEVOUR_SLOW
			else if((species.gluttonous & GLUT_ITEM_NORMAL) && cost <= 4)
				return DEVOUR_SLOW
			else if(species.gluttonous & GLUT_ITEM_ANYTHING)
				return DEVOUR_FAST

/obj/item/organ/internal/stomach/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "puke"
		if(action.button) action.button.UpdateIcon()

/obj/item/organ/internal/stomach/attack_self(mob/user)
	. = ..()
	if(. && action_button_name == PUKE_ACTION_NAME && owner && !owner.incapacitated())
		owner.vomit(deliberate = TRUE)
		refresh_action_button()

/obj/item/organ/internal/stomach/return_air()
	return null

// This call needs to be split out to make sure that all the ingested things are metabolised
// before the process call is made on any of the other organs
/obj/item/organ/internal/stomach/proc/metabolize()
	if(is_usable())
		ingested.metabolize()
	
#define STOMACH_VOLUME 65
	
/obj/item/organ/internal/stomach/Process()
	..()

	if(owner)
		var/functioning = is_usable()
		if(damage >= min_bruised_damage && prob((damage / max_damage) * 100))
			functioning = FALSE

		if(functioning)
			for(var/mob/living/M in contents)
				if(M.stat == DEAD)
					qdel(M)
					continue

				M.adjustBruteLoss(3)
				M.adjustFireLoss(3)
				M.adjustToxLoss(3)

				var/digestion_product = M.get_digestion_product()
				if(digestion_product)
					ingested.add_reagent(digestion_product, rand(1,3))

		else if(world.time >= next_cramp)
			next_cramp = world.time + rand(200,800)
			owner.custom_pain("Your stomach cramps agonizingly!",1)

		var/alcohol_volume = ingested.get_reagent_amount(/datum/reagent/ethanol)
		
		var/alcohol_threshold_met = alcohol_volume > STOMACH_VOLUME / 2
		if(alcohol_threshold_met && (owner.disabilities & EPILEPSY) && prob(20))
			owner.seizure()
		
		// Alcohol counts as double volume for the purposes of vomit probability
		var/effective_volume = ingested.total_volume + alcohol_volume
		
		// Just over the limit, the probability will be low. It rises a lot such that at double ingested it's 64% chance.
		var/vomit_probability = (effective_volume / STOMACH_VOLUME) ** 6
		if(prob(vomit_probability))
			owner.vomit()

#undef STOMACH_VOLUME
#undef PUKE_ACTION_NAME