#define PUKE_ACTION_NAME "Empty Stomach"

/obj/item/organ/internal/stomach
	name = "stomach"
	desc = "Gross. This is hard to stomach."
	icon_state = "stomach"
	dead_icon = "stomach"
	organ_tag = BP_STOMACH
	parent_organ = BP_GROIN
	///Defined at species level, this value is overriden at Initialize(). This is set here as a failsafe.
	var/stomach_max_volume = 75
	var/datum/reagents/metabolism/ingested
	var/next_cramp = 0

/obj/item/organ/internal/stomach/Destroy()
	QDEL_NULL(ingested)
	. = ..()

/obj/item/organ/internal/stomach/Initialize()
	. = ..()
	var/ingested_atom = owner ? owner : src
	ingested = new/datum/reagents/metabolism(240, ingested_atom, CHEM_INGEST)
	if (species.stomach_capacity)
		stomach_max_volume = species.stomach_capacity
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

/obj/item/organ/internal/stomach/robotize()
	. = ..()
	icon_state = "stomach-prosthetic"

/obj/item/organ/internal/stomach/proc/can_eat_atom(atom/movable/food)
	return !isnull(get_devour_time(food))

///Can return values greater than 100%; to increase penalties of overeating.
/obj/item/organ/internal/stomach/proc/stomach_fullness(atom/movable/food)
	var/total = ingested.total_volume
	for(var/a in contents + food)
		if(ismob(a))
			var/mob/M = a
			total += (M.mob_size * 8)
		else if(isobj(a))
			var/obj/item/I = a
			total += (I.get_storage_cost() * 25)
		else
			continue
	return ((total/stomach_max_volume) * 100)

/obj/item/organ/internal/stomach/proc/is_full(atom/movable/food)
	return (stomach_fullness(food) >= 100)

/obj/item/organ/internal/stomach/proc/get_devour_time(atom/movable/food)
	if(iscarbon(food) || isanimal(food))
		var/mob/living/L = food
		if((species.gluttonous & GLUT_TINY) && (L.mob_size <= MOB_TINY) && !ishuman(food)) // Anything MOB_TINY or smaller
			return DEVOUR_SLOW
		else if((species.gluttonous & GLUT_SMALLER) && owner.mob_size > L.mob_size) // Anything we're larger than
			return DEVOUR_SLOW
		else if(species.gluttonous & GLUT_ANYTHING) // Eat anything ever
			return DEVOUR_FAST
	else if(istype(food, /obj/item))
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
		owner.empty_stomach()
		refresh_action_button()

/obj/item/organ/internal/stomach/use_tool(obj/item/item, mob/living/user, list/click_params)
	if (!is_sharp(item))
		return ..()

	user.visible_message(
		SPAN_ITALIC("\The [user] begins cutting into \a [src] with \a [item]."),
		SPAN_ITALIC("You start to cut open \the [src] with \the [item]."),
		range = 5
	)
	take_internal_damage(5)
	if (!user.do_skilled(5 SECONDS, SKILL_ANATOMY, src) || QDELETED(src))
		return TRUE
	if (!Adjacent(user) || user.incapacitated())
		return TRUE
	var/removed_message
	var/length = length(contents)
	switch (length)
		if (0)
			removed_message = "There's nothing inside."
		if (1)
			removed_message = "Something falls out."
		else
			removed_message = "Several things fall out."
	user.visible_message(
		SPAN_ITALIC("\The [user] finishes cutting \a [src] open. [removed_message]"),
		SPAN_ITALIC("You finish cutting \the [src] open. [removed_message]"),
		range = 2
	)
	take_internal_damage(5)
	for (var/atom/movable/movable as anything in contents)
		movable.dropInto(loc)
	return TRUE

/obj/item/organ/internal/stomach/return_air()
	return null

// This call needs to be split out to make sure that all the ingested things are metabolised
// before the process call is made on any of the other organs
/obj/item/organ/internal/stomach/proc/metabolize()
	if(is_usable())
		ingested.metabolize()

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
			owner.add_chemical_effect(CE_NAUSEA, 3)
#undef PUKE_ACTION_NAME
