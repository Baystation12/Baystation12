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
	possible_transfer_amounts = list(10,20,30,50,70)
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

	remover
		paint_type = "remover"
/*
/obj/item/weapon/paint
	gender= PLURAL
	name = "paint"
	desc = "Used to recolor floors and walls. Can not be removed by the janitor."
	icon = 'icons/obj/items.dmi'
	icon_state = "paint_neutral"
	color = "FFFFFF"
	item_state = "paintcan"
	w_class = 3.0

/obj/item/weapon/paint/afterattack(turf/target, mob/user as mob, proximity)
	if(!proximity) return
	if(!istype(target) || istype(target, /turf/space))
		return
	var/ind = "[initial(target.icon)][color]"
	if(!cached_icons[ind])
		var/icon/overlay = new/icon(initial(target.icon))
		overlay.Blend("#[color]",ICON_MULTIPLY)
		overlay.SetIntensity(1.4)
		target.icon = overlay
		cached_icons[ind] = target.icon
	else
		target.icon = cached_icons[ind]
	return

/obj/item/weapon/paint/paint_remover
	gender =  PLURAL
	name = "paint remover"
	icon_state = "paint_neutral"

	afterattack(turf/target, mob/user as mob)
		if(istype(target) && target.icon != initial(target.icon))
			target.icon = initial(target.icon)
		return
*/
/*
datum/reagent/paint
	name = "Paint"
	id = "paint_"
	reagent_state = 2
	color = "#808080"
	description = "This paint will only adhere to floor tiles."



	red
		name = "Red Paint"
		id = "paint_red"
		color = "#FE191A"

	green
		name = "Green Paint"
		color = "#18A31A"
		id = "paint_green"

	blue
		name = "Blue Paint"
		color = "#247CFF"
		id = "paint_blue"

	yellow
		name = "Yellow Paint"
		color = "#FDFE7D"
		id = "paint_yellow"

	violet
		name = "Violet Paint"
		color = "#CC0099"
		id = "paint_violet"

	black
		name = "Black Paint"
		color = "#333333"
		id = "paint_black"

	white
		name = "White Paint"
		color = "#F0F8FF"
		id = "paint_white"

datum/reagent/paint_remover
	name = "Paint Remover"
	id = "paint_remover"
	description = "Paint remover is used to remove floor paint from floor tiles."
	reagent_state = 2
	color = "#808080"

	reaction_turf(var/turf/T, var/volume)
		if(istype(T) && T.icon != initial(T.icon))
			T.icon = initial(T.icon)
		return
*/
