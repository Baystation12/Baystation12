/obj/item/weapon/storage/box/bloodpacks
	name = "blood packs box"
	desc = "This box contains blood packs."
	icon_state = "sterile"
	New()
		..()
		new /obj/item/weapon/reagent_containers/blood/empty(src)
		new /obj/item/weapon/reagent_containers/blood/empty(src)
		new /obj/item/weapon/reagent_containers/blood/empty(src)
		new /obj/item/weapon/reagent_containers/blood/empty(src)
		new /obj/item/weapon/reagent_containers/blood/empty(src)
		new /obj/item/weapon/reagent_containers/blood/empty(src)
		new /obj/item/weapon/reagent_containers/blood/empty(src)

/obj/item/weapon/reagent_containers/blood
	name = "blood pack"
	desc = "Flexible bag for IV injectors."
	icon = 'icons/obj/bloodpack.dmi'
	icon_state = "empty"
	volume = 200

	var/blood_type = null
	var/vampire_marks = null

/obj/item/weapon/reagent_containers/blood/New()
	..()
	if(blood_type)
		name = "blood pack [blood_type]"
		reagents.add_reagent(/datum/reagent/blood, 200, list("donor" = null, "blood_DNA" = null, "blood_type" = blood_type, "trace_chem" = null, "virus2" = list(), "antibodies" = list()))

/obj/item/weapon/reagent_containers/blood/on_reagent_change()
	update_icon()

/obj/item/weapon/reagent_containers/blood/update_icon()
	overlays.Cut()
	var/percent = round(reagents.total_volume / volume * 100)
	if(reagents.total_volume)
		var/image/filling = image('icons/obj/bloodpack.dmi', "[round(percent,25)]")
		filling.color = reagents.get_color()
		overlays += filling
	overlays += image('icons/obj/bloodpack.dmi', "top")


/obj/item/weapon/reagent_containers/blood/attack(mob/living/carbon/human/M as mob, mob/living/carbon/human/user as mob, var/target_zone)
	if (user == M && (user.mind.vampire))
		if (being_feed)
			user << "<span class='notice'>You are already feeding on \the [src].</span>"
			return
		if (reagents.get_reagent_amount("blood"))
			user.visible_message("<span class='warning'>[user] raises \the [src] up to their mouth and bites into it.</span>", "<span class='notice'>You raise \the [src] up to your mouth and bite into it, starting to drain its contents.<br>You need to stand still.</span>")
			being_feed = TRUE
			vampire_marks = TRUE
			if (!LAZYLEN(src.other_dna))
				LAZYADD(src.other_dna, M.dna.unique_enzymes)

			while (do_after(user, 25, 5, 1))
				var/blood_taken = 0
				blood_taken = min(5, reagents.get_reagent_amount("blood")/4)

				reagents.remove_reagent("blood", blood_taken*4)
				user.mind.vampire.blood_usable += blood_taken

				if (blood_taken)
					user << "<span class='notice'>You have accumulated [user.mind.vampire.blood_usable] [user.mind.vampire.blood_usable > 1 ? "units" : "unit"] of usable blood. It tastes quite stale.</span>"

				if (reagents.get_reagent_amount("blood") < 1)
					break
			user.visible_message("<span class='warning'>[user] licks \his fangs dry, lowering \the [src].</span>", "<span class='notice'>You lick your fangs clean of the tasteless blood.</span>")
			being_feed = FALSE
	else
		..()

/obj/item/weapon/reagent_containers/blood/APlus
	blood_type = "A+"

/obj/item/weapon/reagent_containers/blood/AMinus
	blood_type = "A-"

/obj/item/weapon/reagent_containers/blood/BPlus
	blood_type = "B+"

/obj/item/weapon/reagent_containers/blood/BMinus
	blood_type = "B-"

/obj/item/weapon/reagent_containers/blood/OPlus
	blood_type = "O+"

/obj/item/weapon/reagent_containers/blood/OMinus
	blood_type = "O-"

/obj/item/weapon/reagent_containers/blood/empty
