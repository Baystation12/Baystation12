//NEVER USE THIS IT SUX	-PETETHEGOAT

var/global/list/cached_icons = list()

/obj/item/weapon/reagent_containers/glass/paint
	desc = "It's a paint bucket."
	name = "paint bucket"
	icon = 'icons/obj/items.dmi'
	icon_state = "paint_neutral"
	item_state = "paintcan"
	matter = list("metal" = 200)
	w_class = 3.0
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(10,20,30,60)
	volume = 60
	flags = OPENCONTAINER
	var/paint_type = ""

	afterattack(turf/simulated/target, mob/user, proximity)
		if(!proximity) return
		if(istype(target) && reagents.total_volume > 5)
			for(var/mob/O in viewers(user))
				O.show_message("\red \The [target] has been splashed with something by [user]!", 1)
			spawn(5)
				reagents.reaction(target, TOUCH)
				reagents.remove_any(5)
		else
			return ..()

	New()
		if(paint_type == "remover")
			name = "paint remover bucket"
		else if(paint_type && lentext(paint_type) > 0)
			name = paint_type + " " + name
		..()
		reagents.add_reagent("water", volume*3/5)
		reagents.add_reagent("plasticide", volume/5)
		if(paint_type == "white") //why don't white crayons exist
			reagents.add_reagent("aluminum", volume/5)
		else
			reagents.add_reagent("crayon_dust_[paint_type]", volume/5)
		reagents.handle_reactions()

	on_reagent_change() //Until we have a generic "paint", this will give new colours to all paints in the can
		var/mixedcolor = mix_color_from_reagents(reagents.reagent_list)
		for(var/datum/reagent/paint/P in reagents.reagent_list)
			P.color = mixedcolor

	red
		icon_state = "paint_red"
		paint_type = "red"

	yellow
		icon_state = "paint_yellow"
		paint_type = "yellow"

	green
		icon_state = "paint_green"
		paint_type = "green"

	blue
		icon_state = "paint_blue"
		paint_type = "blue"

	violet
		icon_state = "paint_violet"
		paint_type = "purple"

	black
		icon_state = "paint_black"
		paint_type = "gray"

	white
		icon_state = "paint_white"
		paint_type = "white"

