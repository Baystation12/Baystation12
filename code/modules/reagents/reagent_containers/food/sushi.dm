/obj/item/reagent_containers/food/snacks/sushi
	name = "sushi"
	desc = "A small, neatly wrapped morsel. Itadakimasu!"
	icon = 'icons/obj/food/sushi.dmi'
	icon_state = "sushi_rice"
	bitesize = 1
	sushi_overlay = "fish"
	var/sushi_type

/obj/item/reagent_containers/food/snacks/sushi/New(newloc, obj/item/reagent_containers/food/snacks/rice, obj/item/reagent_containers/food/snacks/topping)

	..(newloc)

	if(istype(topping))
		for(var/taste_thing in topping.nutriment_desc)
			if(!nutriment_desc[taste_thing]) nutriment_desc[taste_thing] = 0
			nutriment_desc[taste_thing] += topping.nutriment_desc[taste_thing]

		sushi_overlay = topping.sushi_overlay
		var/image/I = image(icon, sushi_overlay)
		if(sushi_overlay == "fish" || sushi_overlay == "meat")
			I.color = topping.filling_color
		AddOverlays(I)

		if(istype(topping, /obj/item/reagent_containers/food/snacks/sashimi))
			var/obj/item/reagent_containers/food/snacks/sashimi/sashimi = topping
			sushi_type = sashimi.fish_type
		else
			sushi_type = topping.name
			if (text_starts_with(sushi_type, "raw"))
				sushi_type = trimtext(copytext(sushi_type, 4))
		if(topping.reagents)
			topping.reagents.trans_to(src, topping.reagents.total_volume)

		var/mob/M = topping.loc
		if(istype(M)) M.drop_from_inventory(topping)
		qdel(topping)

	else
		var/image/I = image(icon, sushi_overlay)
		I.color = "#ff4040"
		AddOverlays(I)

	if(istype(rice))
		if(rice.reagents)
			rice.reagents.trans_to(src, 1)
		if(!rice.reagents || !rice.reagents.total_volume)
			var/mob/M = rice.loc
			if(istype(M)) M.drop_from_inventory(rice)
			qdel(rice)
	update_icon()

/obj/item/reagent_containers/food/snacks/sushi/on_update_icon()
	name = "[sushi_type] sushi"
	AddOverlays("nori")

/////////////
// SASHIMI //
/////////////
/obj/item/reagent_containers/food/snacks/sashimi
	name = "sashimi"
	icon = 'icons/obj/food/sushi.dmi'
	desc = "Thinly sliced raw fish. Tasty."
	icon_state = "sashimi"
	color = "#ff4040"
	filling_color = "#ff4040"
	gender = PLURAL
	bitesize = 1
	sushi_overlay = "fish"
	var/fish_type = "fish"
	var/slices = 1


/obj/item/reagent_containers/food/snacks/sashimi/Initialize(mapload, _fish_type, _color)
	. = ..()
	if (_fish_type)
		fish_type = _fish_type
	if (_color)
		color = _color
		filling_color = _color
	name = "[fish_type] sashimi"
	update_icon()
