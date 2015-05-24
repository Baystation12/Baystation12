/obj/item/weapon/storage/pill_bottle/dice
	name = "pack of dice"
	desc = "It's a small container with dice inside."

	New()
		..()
		new /obj/item/weapon/dice( src )
		new /obj/item/weapon/dice/d20( src )

/*
 * Donut Box
 */

/obj/item/weapon/storage/box/donut
	icon = 'icons/obj/food.dmi'
	icon_state = "donutbox"
	name = "donut box"
	storage_slots = 6
	var/startswith = 6
	can_hold = list(/obj/item/weapon/reagent_containers/food/snacks/donut)
	foldable = /obj/item/stack/material/cardboard

/obj/item/weapon/storage/box/donut/New()
	..()
	for(var/i=1; i <= startswith; i++)
		new /obj/item/weapon/reagent_containers/food/snacks/donut/normal(src)
	update_icon()
	return

/obj/item/weapon/storage/box/donut/update_icon()
	overlays.Cut()
	var/i = 0
	for(var/obj/item/weapon/reagent_containers/food/snacks/donut/D in contents)
		var/image/img = image('icons/obj/food.dmi', D.overlay_state)
		img.pixel_x = i * 3
		overlays += img
		i++

/obj/item/weapon/storage/box/donut/empty
	startswith = 0
