/obj/item/shellfish
	abstract_type = /obj/item/shellfish
	name = "shellfish"
	desc = "You shouldn't be seeing this."
	icon = 'icons/obj/food_shellfish.dmi'
	icon_state = "clam"
	w_class = ITEM_SIZE_SMALL
	throwforce = 0
	throw_speed = 4
	throw_range = 20

	var/snack_path = /obj/item/reagent_containers/food/snacks/shellfish


/obj/item/shellfish/attackby(obj/item/W, mob/living/user)
	if(W.sharp)
		to_chat(user, SPAN_NOTICE("You start to pry open \the [src]."))
		if(user.do_skilled(2 SECONDS, SKILL_COOKING, user))
			if (prob(user.skill_fail_chance(SKILL_COOKING, 80, SKILL_ADEPT)))
				user.visible_message(
					SPAN_WARNING("\The [user] slips, cutting their hand while trying to open \a [src]."),
					SPAN_WARNING("You slip, cutting your hand while trying to open \the [src].")
				)
				playsound(loc, 'sound/weapons/bladeslice.ogg', 50, 1)
				user.apply_damage(2, DAMAGE_BRUTE, pick(BP_R_HAND, BP_L_HAND), damage_flags=DAMAGE_FLAG_SHARP)
				return
			else
				to_chat(user, SPAN_NOTICE("You carefully clean and open \the [src]."))
				new snack_path (get_turf(src))
				qdel(src)
				return
	else
		return ..()


/obj/item/shellfish/clam
	name = "clam"
	desc = "A fresh clam. Needs to be cracked open before eating."
	icon_state = "clam"
	snack_path = /obj/item/reagent_containers/food/snacks/shellfish/clam

/obj/item/shellfish/mussel
	name = "mussel"
	desc = "A fresh mussel. Needs to be cracked open before eating."
	icon_state = "mussel"
	snack_path = /obj/item/reagent_containers/food/snacks/shellfish/mussel

/obj/item/shellfish/oyster
	name = "oyster"
	desc = "A fresh oyster. Needs to be cracked open before eating."
	icon_state = "oyster"
	snack_path = /obj/item/reagent_containers/food/snacks/shellfish/oyster

/obj/item/shellfish/shrimp
	name = "shrimp"
	desc = "A fresh shrimp. Needs to be cracked open before eating."
	icon_state = "shrimp"
	snack_path = /obj/item/reagent_containers/food/snacks/shellfish/shrimp

/obj/item/shellfish/crab
	name = "crab"
	desc = "A fresh crab. Mind the pincers."
	icon_state = "crab"
	snack_path = /obj/item/reagent_containers/food/snacks/shellfish/crab


//edible
/obj/item/reagent_containers/food/snacks/shellfish
	abstract_type = /obj/item/reagent_containers/food/snacks/shellfish
	name = "raw shellfish"
	desc = "You shouldn't be seeing this."
	icon = 'icons/obj/food_shellfish.dmi'
	icon_state = "clam_open"
	filling_color = "#f6db93"
	bitesize = 4
	center_of_mass = "x=16;y=16"
	trash = /obj/item/shell


/obj/item/reagent_containers/food/snacks/shellfish/clam
	name = "raw clam"
	desc = "A tasty clam, ready to use. Slightly calamitous."
	icon_state = "clam_open"
	filling_color = "#f6db93"
	trash = /obj/item/shell/clam
/obj/item/reagent_containers/food/snacks/shellfish/clam/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 5)


/obj/item/reagent_containers/food/snacks/shellfish/mussel
	name = "raw mussel"
	desc = "A tasty mussel, ready to use. Goes nicely with white wine."
	icon_state = "mussel_open"
	filling_color = "#eea82d"
	trash = /obj/item/shell/mussel
/obj/item/reagent_containers/food/snacks/shellfish/mussel/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 3)


/obj/item/reagent_containers/food/snacks/shellfish/oyster
	name = "raw oyster"
	desc = "A tasty oyster, ready to use. Its shell is pretty sharp."
	icon_state = "oyster_open"
	filling_color = "#ffdec0"
	trash = /obj/item/shell/oyster
/obj/item/reagent_containers/food/snacks/shellfish/oyster/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 4)


/obj/item/reagent_containers/food/snacks/shellfish/shrimp
	name = "raw shrimp"
	desc = "A tasty shrimp, ready to use. Eat too much and you'll get sick."
	icon_state = "shrimp_meat"
	filling_color = "#ffdfc5"
/obj/item/reagent_containers/food/snacks/shellfish/shrimp/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 3)


/obj/item/reagent_containers/food/snacks/shellfish/crab
	name = "raw crab legs"
	desc = "Meat from a crustacean. Don't get crabby."
	icon_state = "crab_meat"
	filling_color = "#e8d9c8"
	bitesize = 3
/obj/item/reagent_containers/food/snacks/shellfish/crab/Initialize()
	.=..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 6)


//shells
/obj/item/shell
	abstract_type = /obj/item/shell
	name = "shell"
	desc = "An empty shell."
	icon = 'icons/obj/food_shellfish.dmi'
	icon_state = "clam_empty"
	w_class = ITEM_SIZE_SMALL
	throwforce = 0
	throw_speed = 4
	throw_range = 20

/obj/item/shell/clam
	name = "clam shell"
	desc = "An empty clam shell."
	icon_state = "clam_empty"

/obj/item/shell/mussel
	name = "mussel shell"
	desc = "An empty mussel shell."
	icon_state = "mussel_empty"

/obj/item/shell/oyster
	name = "oyster shell"
	desc = "An empty oyster shell."
	icon_state = "oyster_empty"