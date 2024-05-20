GLOBAL_LIST_INIT(recomended_holoplants_colors, list(COLOR_PALE_RED_GRAY,COLOR_BLUE_GRAY,COLOR_PALE_GREEN_GRAY,COLOR_PALE_YELLOW,COLOR_PALE_PINK,COLOR_BABY_BLUE))
/obj/structure/holoplant
	name = "holograph"
	desc = "An strange flower pot. It have something like holograph projector."
	icon = 'packs/infinity/icons/obj/structures/holoplants.dmi'
	icon_state = "holopot"
	w_class = ITEM_SIZE_TINY

	var/emagged = FALSE
	var/interference = FALSE

	var/brightness_on = 1
	var/enabled = TRUE

	var/icon/plant = null
	var/plant_color
	var/list/colors_clamp = 60
	var/hologram_opacity = 0.85

	var/list/possible_states
	var/list/emagged_states

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
	ClearOverlays()
	hologram_opacity = (emagged ? 0.95 : initial(hologram_opacity))
	if(!isicon(plant))
		change_plant(plant)
	change_color(plant_color)

	if(enabled)
		AddOverlays(plant)
	set_light(3, brightness_on, plant_color)

/obj/structure/holoplant/proc/change_plant(state)
	plant = prepare_icon(state)

/obj/structure/holoplant/proc/prepare_icon(state)
	if(!istext(state))
		state = pick((emagged ? emagged_states : possible_states))

	var/plant_icon = icon(icon, state)
	return getHologramIcon(plant_icon, TRUE, null)

/obj/structure/holoplant/proc/change_color(ncolor)
	if (!plant)
		return
	if(!ncolor)
		ncolor = pick(GLOB.recomended_holoplants_colors)
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

/obj/structure/holoplant/use_tool(obj/item/tool, mob/user, list/click_params)
	if(istype(tool, /obj/item/card/id))
		if(!emagged)
			emag_act()
		else
			rollback()
		return TRUE
	if(isScrewdriver(tool))
		enabled = !enabled
		brightness_on = brightness_on ? 0 : initial(brightness_on)
		to_chat(usr, SPAN_NOTICE("You switch [enabled ? "on" : "off"] the [src]"))
		update_icon()
		return TRUE
	return ..()

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
	ClearOverlays()
	set_light(0, 0, l_color = plant_color)
	sleep(3)
	if(QDELETED(src))
		return

	AddOverlays(plant)
	set_light(2, 0.5, brightness_on, l_color = plant_color)
	sleep(3)
	if(QDELETED(src))
		return

	CutOverlays(plant)
	set_light(0, 0, l_color = plant_color)
	sleep(3)
	if(QDELETED(src))
		return

	update_icon()

	interference = FALSE

/obj/structure/holoplant/proc/doInterference()
	if(!interference && enabled)
		addtimer(new Callback(src, PROC_REF(Interference)), 0, TIMER_UNIQUE)

/obj/structure/holoplant/Crossed(mob/living/L)
	if(istype(L))
		doInterference()
