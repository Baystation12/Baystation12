/obj/item/rsf
	name = "rapid service fabricator"
	desc = "A device used to rapidly deploy service items."
	icon = 'icons/obj/tools/rcd.dmi'
	icon_state = "rcd"

	/// The things an RSF can create as a map of {"name" = [radial icon, energy cost, path]}.
	var/static/list/modes = list(
		"Cigarette" = list("cigarette", 10, /obj/item/clothing/mask/smokable/cigarette),
		"Drinking Glass" = list("glass", 50, /obj/item/reagent_containers/food/drinks/glass2),
		"Paper" = list("paper", 10, /obj/item/paper),
		"Pen" = list("pen", 50, /obj/item/pen),
		"Dice Pack" = list("dicebag", 200, /obj/item/storage/pill_bottle/dice)
	)

	/// The current mode of the RSF. One of the keys in the modes list.
	var/mode

	/// The maximum amount of matter the RSF can hold when not a robot RSF.
	var/max_stored_matter = 30

	/// The current amount of matter the RSF holds.
	var/stored_matter


/obj/item/rsf/examine(mob/user, distance)
	. = ..()
	if (distance <= 0)
		to_chat(user, "It currently holds [stored_matter]/[max_stored_matter] fabrication units.")


/obj/item/rsf/attack_self(mob/living/user)
	var/radial = list()
	for (var/key in modes)
		radial[key] = mutable_appearance('icons/screen/radial.dmi', modes[key][1])
	var/choice = show_radial_menu(user, user, radial, require_near = TRUE, radius = 42, tooltips = TRUE, check_locs = list(src))
	if (!choice || !user.use_sanity_check(src))
		return
	mode = choice
	to_chat(user, SPAN_NOTICE("Changed dispensing mode to \"[choice]\"."))
	playsound(src, 'sound/effects/pop.ogg', 50, FALSE)


/obj/item/rsf/use_before(atom/target, mob/living/user, list/click_parameters)
	if (!istype(target, /obj/structure/table) && !istype(target, /turf/simulated/floor))
		return FALSE
	var/turf/into = get_turf(target)
	if (!into)
		return FALSE
	if (!(mode in modes))
		to_chat(user, SPAN_WARNING("\The [src] is not set to dispense anything."))
		return TRUE
	var/details = modes[mode]
	if (isrobot(user))
		var/mob/living/silicon/robot/robot = user
		if (robot.stat || !robot.cell)
			to_chat(user, SPAN_WARNING("You're in no condition to do that."))
			return TRUE
		var/cost = details[2]
		if (!robot.cell.checked_use(cost))
			to_chat(user, SPAN_WARNING("You don't have enough energy to do that."))
			return TRUE
	else if (stored_matter < 1)
		to_chat(user, SPAN_WARNING("\The [src] is empty."))
		return TRUE
	else
		stored_matter--
	playsound(loc, 'sound/machines/click.ogg', 10, TRUE)
	var/obj/product = details[3]
	product = new product
	to_chat(user, "Dispensing \a [product]...")
	product.dropInto(into)
	return TRUE


/obj/item/rsf/use_tool(obj/item/item, mob/living/user, list/click_params)
	if (istype(item, /obj/item/rcd_ammo))
		var/obj/item/rcd_ammo/ammo = item
		if (stored_matter >= max_stored_matter)
			to_chat(user, "The RSF can't hold any more matter.")
			return TRUE
		var/use_amount = min(ammo.remaining, max_stored_matter - stored_matter)
		stored_matter += use_amount
		ammo.remaining -= use_amount
		if (ammo.remaining <= 0)
			qdel(ammo)
		playsound(loc, 'sound/machines/click.ogg', 10, TRUE)
		to_chat(user, "The RSF now holds [stored_matter]/[max_stored_matter] fabrication units.")
		return TRUE
	return ..()


/obj/item/rsf/loaded/Initialize()
	. = ..()
	stored_matter = max_stored_matter
