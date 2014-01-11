//NEVER USE THIS IT SUX	-PETETHEGOAT

var/global/list/cached_icons = list()

/obj/item/weapon/reagent_containers/glass/paint
	desc = "It's a paint bucket."
	name = "paint bucket"
	icon = 'icons/obj/items.dmi'
	icon_state = "paint_neutral"
	item_state = "paintcan"
	m_amt = 200
	g_amt = 0
	w_class = 3.0
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(10,20,30,50,70)
	volume = 70
	flags = FPRINT | OPENCONTAINER
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
		reagents.add_reagent("paint_[paint_type]", volume)

	on_reagent_change() //Until we have a generic "paint", this will give new colours to all paints in the can
		for(var/datum/reagent/paint/P in reagents.reagent_list)
			P.color = mix_color_from_reagents(reagent_list)

	red
		icon_state = "paint_red"
		paint_type = "red"

	green
		icon_state = "paint_green"
		paint_type = "green"

	blue
		icon_state = "paint_blue"
		paint_type = "blue"

	yellow
		icon_state = "paint_yellow"
		paint_type = "yellow"

	violet
		icon_state = "paint_violet"
		paint_type = "violet"

	black
		icon_state = "paint_black"
		paint_type = "black"

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

/obj/item/weapon/paint/red
	name = "red paint"
	color = "FF0000"
	icon_state = "paint_red"

/obj/item/weapon/paint/green
	name = "green paint"
	color = "00FF00"
	icon_state = "paint_green"

/obj/item/weapon/paint/blue
	name = "blue paint"
	color = "0000FF"
	icon_state = "paint_blue"

/obj/item/weapon/paint/yellow
	name = "yellow paint"
	color = "FFFF00"
	icon_state = "paint_yellow"

/obj/item/weapon/paint/violet
	name = "violet paint"
	color = "FF00FF"
	icon_state = "paint_violet"

/obj/item/weapon/paint/black
	name = "black paint"
	color = "333333"
	icon_state = "paint_black"

/obj/item/weapon/paint/white
	name = "white paint"
	color = "FFFFFF"
	icon_state = "paint_white"


/obj/item/weapon/paint/anycolor
	gender= PLURAL
	name = "any color"
	icon_state = "paint_neutral"

	attack_self(mob/user as mob)
		var/t1 = input(user, "Please select a color:", "Locking Computer", null) in list( "red", "blue", "green", "yellow", "black", "white")
		if ((user.get_active_hand() != src || user.stat || user.restrained()))
			return
		switch(t1)
			if("red")
				color = "FF0000"
			if("blue")
				color = "0000FF"
			if("green")
				color = "00FF00"
			if("yellow")
				color = "FFFF00"
			if("violet")
				color = "FF00FF"
			if("white")
				color = "FFFFFF"
			if("black")
				color = "333333"
		icon_state = "paint_[t1]"
		add_fingerprint(user)
		return


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

datum/reagent/paint
	name = "Paint"
	id = "paint_"
	description = name + " is used to color floor tiles."
	reagent_state = LIQUID
	color = "#808080"

	reaction_turf(var/turf/T, var/volume)
		if(!istype(T) || istype(T, /turf/space))
			return
		var/ind = "[initial(T.icon)][color]"
		if(!cached_icons[ind])
			var/icon/overlay = new/icon(initial(T.icon))
			overlay.Blend(color,ICON_MULTIPLY)
			overlay.SetIntensity(1.4)
			T.icon = overlay
			cached_icons[ind] = T.icon
		else
			T.icon = cached_icons[ind]
		return

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
