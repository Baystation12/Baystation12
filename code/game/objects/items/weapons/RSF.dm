/obj/item/rsf
	name = "rapid service fabricator"
	desc = "A device used to rapidly deploy service items."
	icon = 'icons/obj/tools/rcd.dmi'
	icon_state = "rcd"

	var/const/MODE_CIGARETTE = "Cigarette"
	var/const/MODE_GLASS = "Drinking Glass"
	var/const/MODE_PAPER = "Paper"
	var/const/MODE_PEN = "Pen"
	var/const/MODE_DICE = "Dice Pack"

	/// The current mode of the RSF. One of the MODE_* constants.
	var/mode = MODE_CIGARETTE

	/// The maximum amount of matter the RSF can hold when not a robot RSF.
	var/max_stored_matter = 30

	/// The current amount of matter the RSF holds.
	var/stored_matter


/obj/item/rsf/Initialize()
	. = ..()
	stored_matter = max_stored_matter


/obj/item/rsf/examine(mob/user, distance)
	. = ..()
	if (distance <= 0)
		to_chat(user, "It currently holds [stored_matter]/[max_stored_matter] fabrication units.")


/obj/item/rsf/attackby(obj/item/item, mob/living/user)
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


/obj/item/rsf/attack_self(mob/living/user)
	var/list/options = list()
	options[MODE_CIGARETTE] = mutable_appearance('icons/screen/radial.dmi', "cigarette")
	options[MODE_GLASS] = mutable_appearance('icons/screen/radial.dmi', "glass")
	options[MODE_PAPER] = mutable_appearance('icons/screen/radial.dmi', "paper")
	options[MODE_PEN] = mutable_appearance('icons/screen/radial.dmi', "pen")
	options[MODE_DICE] = mutable_appearance('icons/screen/radial.dmi', "dicebag")
	var/choice = show_radial_menu(user, user, options, require_near = TRUE, radius = 42, tooltips = TRUE, check_locs = list(src))
	if (!choice || !user.use_sanity_check(src))
		return
	mode = choice
	to_chat(user, SPAN_NOTICE("Changed dispending mode to \the [choice]."))
	playsound(loc, 'sound/effects/pop.ogg', 50, FALSE)


/obj/item/rsf/use_before(atom/target, mob/living/user, list/click_parameters)
	if (!istype(target, /obj/structure/table) && !istype(target, /turf/simulated/floor))
		return FALSE
	var/turf/into = get_turf(target)
	if (!into)
		return FALSE
	var/required_energy
	var/obj/product
	switch (mode)
		if (MODE_CIGARETTE)
			product = new /obj/item/clothing/mask/smokable/cigarette
			required_energy = 10
		if (MODE_GLASS)
			product = new /obj/item/reagent_containers/food/drinks/glass2
			required_energy = 50
		if (MODE_PAPER)
			product = new /obj/item/paper
			required_energy = 10
		if (MODE_PEN)
			product = new /obj/item/pen
			required_energy = 50
		if (MODE_DICE)
			product = new /obj/item/storage/pill_bottle/dice
			required_energy = 200
	if (isrobot(user))
		var/mob/living/silicon/robot/robot = user
		if (robot.stat || !robot.cell)
			to_chat(user, SPAN_WARNING("You're in no condition to do that."))
			return TRUE
		if (!robot.cell.checked_use(required_energy))
			to_chat(user, SPAN_WARNING("You don't have enough energy to do that."))
			return TRUE
	else if (stored_matter < 1)
		to_chat(user, SPAN_WARNING("\The [src] is empty."))
		return TRUE
	else
		stored_matter--
	playsound(loc, 'sound/machines/click.ogg', 10, TRUE)
	to_chat(user, "Dispensing [product ? product : "product"]...")
	product.dropInto(into)
	return TRUE
