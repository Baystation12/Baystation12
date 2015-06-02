/obj/item/weapon/reagent_containers/food/snacks/egg
	icon = 'icons/obj/kitchen/staples/eggs.dmi'
	filling_color = "#FFFFFF"

/obj/item/weapon/reagent_containers/food/snacks/egg/New()
	..()
	reagents.add_reagent("egg", 3)

/obj/item/weapon/reagent_containers/food/snacks/egg/rawegg
	name = "egg"
	desc = "An egg!"
	icon_state = "egg"
	filling_color = "#FDFFD1"

/obj/item/weapon/reagent_containers/food/snacks/egg/rawegg/throw_impact(atom/hit_atom)
	..()
	new/obj/effect/decal/cleanable/egg_smudge(get_turf(src))
	src.reagents.trans_to(hit_atom, reagents.total_volume)
	visible_message("<span class='danger'>\The [src.name] splatters over \the [hit_atom]!</span>","<span class='danger'>You hear a smack.</span>")
	qdel(src)

/obj/item/weapon/reagent_containers/food/snacks/egg/frying
	name = "raw egg"
	desc = "A half-cooked, gooey egg. Ew."
	icon_state = "friedegg"

/obj/item/weapon/reagent_containers/food/snacks/egg/fried
	name = "fried egg"
	desc = "A fried egg."
	icon_state = "friedegg"

/obj/item/weapon/reagent_containers/food/snacks/egg/boiled
	name = "boiled egg"
	desc = "A hard-boiled egg."
	icon_state = "egg"
