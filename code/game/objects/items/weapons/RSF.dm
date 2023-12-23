/*
CONTAINS:
RSF
*/

/obj/item/rsf
	name = "rapid service fabricator"
	desc = "A device used to rapidly deploy service items."
	icon = 'icons/obj/tools/rcd.dmi'
	icon_state = "rcd"
	opacity = 0
	density = FALSE
	anchored = FALSE
	var/stored_matter = 30
	var/mode = MODE_CIGARETTE
	w_class = ITEM_SIZE_NORMAL
	var/const/MODE_CIGARETTE = "Cigarette"
	var/const/MODE_GLASS = "Drinking Glass"
	var/const/MODE_PAPER = "Paper"
	var/const/MODE_PEN = "Pen"
	var/const/MODE_DICE = "Dice Pack"

/obj/item/rsf/examine(mob/user, distance)
	. = ..()
	if(distance <= 0)
		to_chat(user, "It currently holds [stored_matter]/30 fabrication-units.")

/obj/item/rsf/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if (istype(W, /obj/item/rcd_ammo))

		if ((stored_matter + 10) > 30)
			to_chat(user, "The RSF can't hold any more matter.")
			return

		qdel(W)

		stored_matter += 10
		playsound(src.loc, 'sound/machines/click.ogg', 10, 1)
		to_chat(user, "The RSF now holds [stored_matter]/30 fabrication-units.")
		return

/obj/item/rsf/attack_self(mob/user as mob)
	var/list/options = list(
		"Cigarette" = mutable_appearance('icons/screen/radial.dmi', "cigarette"),
		"Drinking Glass" = mutable_appearance('icons/screen/radial.dmi', "glass"),
		"Paper" = mutable_appearance('icons/screen/radial.dmi', "paper"),
		"Pen" = mutable_appearance('icons/screen/radial.dmi', "pen"),
		"Dice Pack" = mutable_appearance('icons/screen/radial.dmi', "dicebag")
	)
	var/choice = show_radial_menu(user, user, options, require_near = TRUE, radius = 42, tooltips = TRUE, check_locs = list(src))
	if (!choice || !user.use_sanity_check(src))
		return

	mode = choice
	to_chat(user, SPAN_NOTICE("Changed dispending mode to \the [choice]."))
	playsound(src.loc, 'sound/effects/pop.ogg', 50, 0)

/obj/item/rsf/use_before(atom/A, mob/living/user, click_parameters)
	if(istype(user,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = user
		if(R.stat || !R.cell || R.cell.charge <= 0)
			to_chat(user, SPAN_WARNING("You are unable to use \the [src]."))
			return TRUE
	else
		if(stored_matter <= 0)
			to_chat(user, SPAN_WARNING("\The [src] is empty!"))
			return TRUE

	if(!istype(A, /obj/structure/table) && !istype(A, /turf/simulated/floor))
		return FALSE

	playsound(src.loc, 'sound/machines/click.ogg', 10, 1)
	var/used_energy = 0
	var/obj/product

	switch(mode)
		if(MODE_CIGARETTE)
			product = new /obj/item/clothing/mask/smokable/cigarette()
			used_energy = 10
		if(MODE_GLASS)
			product = new /obj/item/reagent_containers/food/drinks/glass2()
			used_energy = 50
		if(MODE_PAPER)
			product = new /obj/item/paper()
			used_energy = 10
		if(MODE_PEN)
			product = new /obj/item/pen()
			used_energy = 50
		if(MODE_DICE)
			product = new /obj/item/storage/pill_bottle/dice()
			used_energy = 200

	to_chat(user, "Dispensing [product ? product : "product"]...")
	if (isturf(A))
		product.dropInto(A)
	else
		product.dropInto(A.loc)

	if(isrobot(user))
		var/mob/living/silicon/robot/R = user
		if(R.cell)
			R.cell.use(used_energy)
	else
		stored_matter--
		to_chat(user, "The RSF now holds [stored_matter]/30 fabrication-units.")
	return TRUE
