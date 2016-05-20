
/obj/item/weapon/reagent_containers/food/drinks/glass2/fitnessflask
	name = "fitness shaker"
	base_name = "shaker"
	desc = "Big enough to contain enough protein to get perfectly swole. Don't mind the bits."
	icon_state = "fitness-cup_black"
	base_icon = "fitness-cup"
	volume = 100
	matter = list("plastic" = 2000)
	filling_states = list(10,20,30,40,50,60,70,80,90,100)
	possible_transfer_amounts = list(5, 10, 15, 25)
	rim_pos = null // no fruit slices
	var/lid_color = "black"

/obj/item/weapon/reagent_containers/food/drinks/glass2/fitnessflask/New()
	..()
	lid_color = pick("black", "red", "blue")
	update_icon()

/obj/item/weapon/reagent_containers/food/drinks/glass2/fitnessflask/update_icon()
	..()
	icon_state = "[base_icon]_[lid_color]"
/*
/obj/item/weapon/reagent_containers/food/drinks/glass2/fitnessflask/on_reagent_change()
	overlays.Cut()

	if(reagents.total_volume)
		var/image/filling = image('icons/obj/reagentfillings.dmi', src, "fitness-cup10")

		switch(reagents.total_volume)
			if(0 to 10)			filling.icon_state = "fitness-cup10"
			if(11 to 20)		filling.icon_state = "fitness-cup20"
			if(21 to 29)		filling.icon_state = "fitness-cup30"
			if(30 to 39)		filling.icon_state = "fitness-cup40"
			if(40 to 49)		filling.icon_state = "fitness-cup50"
			if(50 to 59)		filling.icon_state = "fitness-cup60"
			if(60 to 69)		filling.icon_state = "fitness-cup70"
			if(70 to 79)		filling.icon_state = "fitness-cup80"
			if(80 to 89)		filling.icon_state = "fitness-cup90"
			if(90 to INFINITY)	filling.icon_state = "fitness-cup100"

		filling.color += reagents.get_color()
		overlays += filling
*/
/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/fitnessflask/proteinshake
	name = "protein shake"

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/fitnessflask/proteinshake/New()
	..()
	reagents.add_reagent("nutriment", 30)
	reagents.add_reagent("iron", 10)
	reagents.add_reagent("protein", 15)
	reagents.add_reagent("water", 45)
//	on_reagent_change()
