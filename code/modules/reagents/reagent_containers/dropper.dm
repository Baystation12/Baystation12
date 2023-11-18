////////////////////////////////////////////////////////////////////////////////
/// Droppers.
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_containers/dropper
	name = "dropper"
	desc = "A dropper. Transfers 5 units."
	icon = 'icons/obj/tools/dropper.dmi'
	icon_state = "dropper0"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = "1;2;3;4;5"
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	volume = 5

/obj/item/reagent_containers/dropper/use_after(obj/target, mob/living/user, click_parameters)
	if(!target.reagents)
		return FALSE

	if(reagents.total_volume)
		if(!target.reagents.get_free_space())
			to_chat(user, SPAN_NOTICE("[target] is full."))
			return TRUE
		if(!target.is_open_container() && !ismob(target) && !istype(target, /obj/item/reagent_containers/food) && !istype(target, /obj/item/clothing/mask/smokable/cigarette)) //You can inject humans and food but you can't remove the shit.
			to_chat(user, SPAN_NOTICE("You cannot directly fill this object."))
			return TRUE

		var/trans = 0

		if(ismob(target))
			if(user.a_intent == I_HELP)
				return TRUE

			var/time = 20 //2/3rds the time of a syringe
			user.visible_message(SPAN_WARNING("[user] is trying to squirt something into [target]'s eyes!"))

			if(!do_after(user, time, target, DO_MEDICAL))
				return TRUE

			if(istype(target, /mob/living/carbon/human))
				var/mob/living/carbon/human/victim = target

				var/obj/item/safe_thing = null
				if(victim.wear_mask)
					if (victim.wear_mask.body_parts_covered & EYES)
						safe_thing = victim.wear_mask
				if(victim.head)
					if (victim.head.body_parts_covered & EYES)
						safe_thing = victim.head
				if(victim.glasses)
					if (victim.glasses.body_parts_covered & EYES)
						safe_thing = victim.glasses

				if(safe_thing)
					trans = reagents.splash(safe_thing, amount_per_transfer_from_this, max_spill=30)
					user.visible_message(SPAN_WARNING("[user] tries to squirt something into [target]'s eyes, but fails!"), SPAN_NOTICE("You transfer [trans] units of the solution."))
					return TRUE

			var/mob/living/M = target
			if (reagents.should_admin_log())
				var/contained = reagentlist()
				admin_attack_log(user, M, "Squirted their victim with \a [src] (Reagents: [contained])", "Were squirted with \a [src] (Reagents: [contained])", "used \a [src] (Reagents: [contained]) to squirt at")

			var/spill_amt = M.incapacitated()? 0 : 30
			trans += reagents.splash(target, reagents.total_volume/2, max_spill = spill_amt)
			trans += reagents.trans_to_mob(target, reagents.total_volume/2, CHEM_BLOOD) //I guess it gets into the bloodstream through the eyes or something
			user.visible_message(SPAN_WARNING("[user] squirts something into [target]'s eyes!"), SPAN_NOTICE("You transfer [trans] units of the solution."))
			return TRUE

		else
			trans = reagents.splash(target, amount_per_transfer_from_this, max_spill=0) //sprinkling reagents on generic non-mobs. Droppers are very precise
			to_chat(user, SPAN_NOTICE("You transfer [trans] units of the solution."))
			return TRUE

	else // Taking from something

		if(!target.is_open_container() && !istype(target,/obj/structure/reagent_dispensers))
			to_chat(user, SPAN_NOTICE("You cannot directly remove reagents from [target]."))
			return TRUE
		if(!target.reagents || !target.reagents.total_volume)
			to_chat(user, SPAN_NOTICE("[target] is empty."))
			return TRUE

		var/trans = target.reagents.trans_to_obj(src, amount_per_transfer_from_this)
		to_chat(user, SPAN_NOTICE("You fill the dropper with [trans] units of the solution."))
		return TRUE

/obj/item/reagent_containers/dropper/on_reagent_change()
	update_icon()

/obj/item/reagent_containers/dropper/on_update_icon()
	if(reagents.total_volume)
		icon_state = "dropper1"
	else
		icon_state = "dropper0"

/obj/item/reagent_containers/dropper/industrial
	name = "Industrial Dropper"
	desc = "A larger dropper. Transfers 10 units."
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = "1;2;3;4;5;6;7;8;9;10"
	volume = 10

////////////////////////////////////////////////////////////////////////////////
/// Droppers. END
////////////////////////////////////////////////////////////////////////////////

/obj/item/reagent_containers/dropper/peridaxon
	name = "Dropper (Peridaxon)"
	desc = "Contains peridaxon - used to rescue failing organs."
	amount_per_transfer_from_this = 1

/obj/item/reagent_containers/dropper/peridaxon/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/peridaxon, 5)
	update_icon()
