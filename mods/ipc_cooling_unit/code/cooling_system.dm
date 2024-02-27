/obj/item/organ/internal/cooling_system
	name = "cooling system"
	icon = 'mods/ipc_cooling_unit/icons/ipc_icons.dmi'
	icon_state = "cooling0"
	organ_tag = BP_COOLING
	parent_organ = BP_GROIN
	status = ORGAN_ROBOTIC
	desc = "The internal liquid cooling system consists of a weighty humming cylinder and a small ribbed block connected by flexible tubes through which clear liquid flows."
	var/refrigerant_max = 90	// Максимальное количество охладителя
	var/refrigerant_rate = 5	// Чем больше это значение, тем сильнее будет идти нагрев владельца.
	var/durability_factor = 30	// Чем больше это значение, тем сильнее будет идти нагрев владельца при повреждениях
	var/safety = 1
	damage_reduction = 0.8
	max_damage = 50
	var/sprite_name = "cooling"
	var/fresh_coolant = 0
	var/coolant_purity = 0
	var/datum/reagents/coolant_reagents
	var/used_coolant = 0
	var/heating_modificator
	var/list/coolant_reagents_efficiency = list()
	var/coolant_reagent_water

/obj/item/organ/internal/cooling_system/New()
	robotize()
	create_reagents(refrigerant_max)
	coolant_reagents_efficiency[/datum/reagent/water] = 17
	coolant_reagents_efficiency[/datum/reagent/ethanol] = 10
	coolant_reagents_efficiency[/datum/reagent/space_cleaner] = 5
	coolant_reagents_efficiency[/datum/reagent/sterilizine] = 3
	coolant_reagents_efficiency[/datum/reagent/coolant] = 0.1
	reagents.add_reagent(/datum/reagent/coolant, 60)
	reagents.add_reagent(/datum/reagent/water, 30)
	..()

/obj/item/organ/internal/cooling_system/emp_act(severity)
	damage += rand(15 - severity * 5, 20 - severity * 5)
	..()
// Коэффицент эффективности работы смеси
/obj/item/organ/internal/cooling_system/proc/coolant_purity()
	var/total_purity = 0
	fresh_coolant = 0
	coolant_purity = 0
	for (var/datum/reagent/current_reagent in src.reagents.reagent_list)
		if (!current_reagent)
			continue
		var/cur_purity = coolant_reagents_efficiency[current_reagent.type]
		if(!cur_purity)
			cur_purity = 25
		else if(cur_purity < 0.1)
			cur_purity = 0.1
		total_purity += cur_purity * current_reagent.volume
		fresh_coolant += current_reagent.volume
	if(total_purity && fresh_coolant)
		coolant_purity = total_purity / fresh_coolant
		heating_modificator = coolant_purity




/obj/item/organ/internal/cooling_system/proc/get_coolant_drain()
	var/damage_factor = (damage*durability_factor)/max_damage
	return damage_factor

/obj/item/organ/internal/cooling_system/Process()

	if(!owner || owner.stat == DEAD || owner.bodytemperature < 32)
		return
	coolant_purity()
	handle_cooling()
	..()

/obj/item/organ/internal/cooling_system/proc/handle_cooling()

	var/obj/item/organ/internal/cell/C = owner.internal_organs_by_name[BP_CELL]
	refrigerant_rate = heating_modificator
	if (C && C.get_charge() < 25)
		return
	if(reagents.total_volume >= 0)
		var/bruised_cost = get_coolant_drain()

		if(is_bruised())
			var/reagents_remove = bruised_cost/durability_factor
			reagents.remove_any(reagents_remove)

		if(is_damaged())
			get_coolant_drain()
			refrigerant_rate += bruised_cost     // Нагрев владельца при повреждениях высчитывается тут.

		if(reagents.get_reagent_amount(/datum/reagent/water) <= (0.3 * reagents.total_volume))
			var/need_more_water = ((refrigerant_max - reagents.get_reagent_amount(/datum/reagent/water))/100)
			take_internal_damage(need_more_water)

	if(reagents.total_volume <= 0)
		refrigerant_rate += 40

/obj/item/organ/internal/cooling_system/proc/get_tempgain()
	if(owner.bodytemperature > 950 CELSIUS)
		return 0
	if(refrigerant_rate > 0)
		return refrigerant_rate

/obj/item/organ/internal/cooling_system/proc/get_coolant_remaining()
	if(status & ORGAN_DEAD)
		return 0
	return round(reagents.total_volume)

/obj/item/organ/internal/cooling_system/examine(mob/user, distance)
	. = ..()
	if(distance <= 0)
		to_chat(user, text("[icon2html(src, viewers(get_turf(src)))] [] contains [] units of liquid left!", src, src.reagents.total_volume))

/obj/item/organ/internal/cooling_system/attack_self(mob/user as mob)
	safety = !safety
	src.icon_state = "[sprite_name][!safety]"
	src.desc = "The injection is [safety ? "on" : "off"]."
	to_chat(user, "The injection is [safety ? "on" : "off"].")


/obj/item/organ/internal/cooling_system/afterattack(atom/target, mob/user, flag)
	var/obj/item/reagent_containers/glass/beaker = target
	if (!flag || !istype(beaker))
		return ..()

	var/amount = reagents.get_free_space()
	if (safety)
		if (amount <= 0)
			to_chat(user, SPAN_NOTICE("\The [src] is full."))
			return
		if (beaker.reagents.total_volume <= 0)
			to_chat(user, SPAN_NOTICE("\The [beaker] is empty."))
			return
		amount = beaker.reagents.trans_to_obj(src, refrigerant_max)
		to_chat(user, SPAN_NOTICE("You fill \the [src] with [amount] units from \the [beaker]."))
		playsound(src.loc, 'sound/effects/pour.ogg', 25, 1)
	else
		amount = src.reagents.trans_to_obj(beaker, refrigerant_max)
		to_chat(user, SPAN_NOTICE("You fill \the [beaker] with [amount] units from \the [src]."))
		playsound(src.loc, 'sound/effects/pour.ogg', 25, 1)
