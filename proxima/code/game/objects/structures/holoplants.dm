GLOBAL_LIST_INIT(recomended_holoplants_colors, list(COLOR_LIGHTING_RED_BRIGHT,COLOR_LIGHTING_BLUE_BRIGHT,COLOR_LIGHTING_GREEN_BRIGHT,COLOR_LIGHTING_ORANGE_BRIGHT,COLOR_LIGHTING_PURPLE_BRIGHT,COLOR_LIGHTING_CYAN_BRIGHT))
/obj/structure/holoplant
	name = "holograph"
	desc = "An strange flower pot. It have something like holograph projector."
	icon = 'proxima/icons/obj/structures/holoplants.dmi'
	icon_state = "holopot"
	w_class = ITEM_SIZE_TINY

	var/emagged = FALSE
	var/interference = FALSE

	var/brightness_on = 2
	var/enabled = TRUE

	var/icon/plant = null
	var/plant_color
	var/list/colors_clamp = 60
	var/hologram_opacity = 0.85

	var/tmp/list/possible_states
	var/tmp/list/emagged_states


/obj/structure/holoplant/Initialize()
	. = ..()
	update_icon()

/obj/structure/holoplant/proc/parse_icon()
	possible_states = list()
	emagged_states = list()
	var/list/states = icon_states(icon)
	for(var/i in states)
		var/list/state_splittext = splittext(i, "-")
		if(length(state_splittext) > 1)
			if(istext(state_splittext[1]))
				var/t = state_splittext[1]
				var/list/add2
				if(t == "P")
					add2 = possible_states
				else if(t == "E")
					add2 = emagged_states
				add2 += i

/obj/structure/holoplant/on_update_icon()
	. = ..()
	if(!islist(possible_states))
		parse_icon()
	overlays.Cut()
	hologram_opacity = (emagged ? 0.95 : initial(hologram_opacity))
	if(!isicon(plant))
		change_plant(plant)
	change_color(plant_color)

	if(enabled)
		overlays += plant
	SET_L_RPC(brightness_on, 1, plant_color)

/obj/structure/holoplant/proc/change_plant(var/state)
	plant = prepare_icon(state)

/obj/structure/holoplant/proc/prepare_icon(var/state)
	if(!istext(state))
		state = pick((emagged ? emagged_states : possible_states))

	var/plant_icon = icon(icon, state)
	return getHologramIcon(plant_icon, TRUE, null, nopacity = hologram_opacity)

/obj/structure/holoplant/proc/change_color(var/ncolor)
	if (!plant)
		return
	if(!ncolor)
		ncolor = pick(GLOB.recomended_holoplants_colors)
//	ncolor = clamphex(ncolor, (islist(colors_clamp) && length(colors_clamp)) ? (colors_clamp[1], colors_clamp[2]) : (colors_clamp, 255))
	if(islist(colors_clamp) && length(colors_clamp))
		ncolor = clamphex(ncolor, colors_clamp[1], colors_clamp[2])
	else
		ncolor = clamphex(ncolor, colors_clamp)
	plant_color = ncolor
	plant.ColorTone(ncolor)

	set_light(l_color=ncolor)

/obj/structure/holoplant/attack_hand(mob/user)
	if(!interference)
		switch(alert("What do you want?",,"Color", "Cancel", "Hologram"))
			if("Color")
				change_color(input("Select New color", "Color", plant_color) as color)
			if("Hologram")
				change_plant(input("Select Hologram", "Hologram") in (emagged ? emagged_states : possible_states))
		update_icon()

/obj/structure/holoplant/attackby(obj/item/I, mob/user, click_params)
	if(istype(I, /obj/item/card/id))
		if(!emagged)
			emag_act()
		else
			rollback()
		. = TRUE
	if(isScrewdriver(I))
		enabled = !enabled
		brightness_on = brightness_on ? 0 : initial(brightness_on)
		to_chat(usr, SPAN_NOTICE("You switch [enabled ? "on" : "off"] the [src]"))
		update_icon()
		. = TRUE
	if(!.)
		. = ..()

/obj/structure/holoplant/proc/rollback()
	emagged = FALSE
	update_icon()

/obj/structure/holoplant/emag_act()
	emagged = TRUE
	update_icon()

/obj/structure/holoplant/proc/Interference() //should not have any returns, cuz of waitfor = 0
	set waitfor = 0
	if (QDELETED(src))
		return
	interference = TRUE
	overlays.Cut()
	SET_L_RPC(0, 0, plant_color)
	sleep(3)
	if(QDELETED(src))
		return

	overlays += plant
	SET_L_RPC(brightness_on, 1, plant_color)
	sleep(3)
	if(QDELETED(src))
		return

	overlays -= plant
	SET_L_RPC(0, 0, plant_color)
	sleep(3)
	if(QDELETED(src))
		return

	update_icon()

	interference = FALSE

/obj/structure/holoplant/proc/doInterference()
	if(!interference && enabled)
		addtimer(CALLBACK(src, .proc/Interference), 0, TIMER_STOPPABLE)

/obj/structure/holoplant/Crossed(var/mob/living/L)
	if(istype(L))
		doInterference()
