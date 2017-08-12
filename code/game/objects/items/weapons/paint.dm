//NEVER USE THIS IT SUX	-PETETHEGOAT
//THE GOAT WAS RIGHT - RKF

var/global/list/cached_icons = list()

/obj/item/weapon/reagent_containers/glass/paint
	desc = "It's a paint bucket."
	name = "paint bucket"
	icon = 'icons/obj/items.dmi'
	icon_state = "paint_neutral"
	item_state = "paintcan"
	matter = list(DEFAULT_WALL_MATERIAL = 200)
	w_class = ITEM_SIZE_NORMAL
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = "10;20;30;60"
	volume = 60
	unacidable = 0
	flags = OPENCONTAINER
	var/paint_hex = "#FE191A"

/obj/item/weapon/reagent_containers/glass/paint/afterattack(turf/simulated/target, mob/user, proximity)
	if(!proximity) return
	if(istype(target) && reagents.total_volume > 5)
		user.visible_message("<span class='warning'>\The [target] has been splashed with something by [user]!</span>")
		reagents.trans_to_turf(target, 5)
	else
		return ..()

/obj/item/weapon/reagent_containers/glass/paint/New()
	..()
	if(paint_hex && lentext(paint_hex) > 0)
		reagents.add_reagent(/datum/reagent/paint, volume, paint_hex)

/obj/item/weapon/reagent_containers/glass/paint/red
	name = "red paint bucket"
	icon_state = "paint_red"
	paint_hex = "#FE191A"

/obj/item/weapon/reagent_containers/glass/paint/yellow
	name = "yellow paint bucket"
	icon_state = "paint_yellow"
	paint_hex = "#FDFE7D"

/obj/item/weapon/reagent_containers/glass/paint/green
	name = "green paint bucket"
	icon_state = "paint_green"
	paint_hex = "#18A31A"

/obj/item/weapon/reagent_containers/glass/paint/blue
	name = "blue paint bucket"
	icon_state = "paint_blue"
	paint_hex = "#247CFF"

/obj/item/weapon/reagent_containers/glass/paint/purple
	name = "purple paint bucket"
	icon_state = "paint_violet"
	paint_hex = "#CC0099"

/obj/item/weapon/reagent_containers/glass/paint/black
	name = "black paint bucket"
	icon_state = "paint_black"
	paint_hex = "#333333"

/obj/item/weapon/reagent_containers/glass/paint/white
	name = "white paint bucket"
	icon_state = "paint_white"
	paint_hex = "#F0F8FF"

/obj/item/weapon/reagent_containers/glass/paint/random
	name = "odd paint bucket"
	icon_state = "paint_neutral"

/obj/item/weapon/reagent_containers/glass/paint/random/New()
	paint_hex = rgb(rand(1,255),rand(1,255),rand(1,255))
	..()