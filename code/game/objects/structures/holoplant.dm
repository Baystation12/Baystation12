/obj/structure/holoplant
	name = "holo-plant"
	desc = "One of those famous Aster's holoplants! Add to your space a bit of the comfort from old Earth, by buying this blue buddy. A nuclear battery and a rugged case guarantee that your flower will survive journey to another galaxy, and variety of plant types won't let you to get bored along the way!"
	icon = 'icons/obj/holoplants.dmi'
	icon_state = "holopot"
	var/brightness_on = 0.5
	var/emaged = FALSE
	var/interference = FALSE
	var/icon/plant = null
	var/plant_color
	var/glow_color
	var/hologram_opacity = 0.85
	var/set_plant
	var/global/list/possible_plants = list(
		"plant-1",
		"plant-02",
		"plant-04",
		"plant-06",
		"plant-09",
		"plant-10",
		"plant-14",
		"plant-13",
		"plant-15",
	)
	var/global/list/possible_colors = list(
		rgb(60, 148, 197),
		COLOR_NAVY_BLUE,
		COLOR_GREEN,
		COLOR_MAROON,
		COLOR_PURPLE,
		COLOR_VIOLET,
		COLOR_OLIVE,
		COLOR_BROWN_ORANGE,
		COLOR_DARK_ORANGE,
		COLOR_SEDONA,
		COLOR_DARK_BROWN,
		COLOR_BLUE,
		COLOR_DEEP_SKY_BLUE,
		COLOR_LIME,
		COLOR_CYAN,
		COLOR_TEAL,
		COLOR_RED,
		COLOR_PINK,
		COLOR_ORANGE,
		COLOR_YELLOW,
		COLOR_SUN,
		COLOR_BLUE_LIGHT,
		COLOR_RED_LIGHT,
		COLOR_BEIGE,
		COLOR_LUMINOL,
		COLOR_SILVER,
		COLOR_WHITE,
		COLOR_NT_RED,
		COLOR_BOTTLE_GREEN,
		COLOR_CHESTNUT,
		COLOR_BEASTY_BROWN,
		COLOR_WHEAT,
		COLOR_CYAN_BLUE,
		COLOR_LIGHT_CYAN,
		COLOR_PAKISTAN_GREEN,
		COLOR_HULL,
		COLOR_AMBER,
		COLOR_SKY_BLUE,
		COLOR_CIVIE_GREEN,
		COLOR_DARK_GUNMETAL,
	)

/obj/structure/holoplant/Initialize()
	..()
	if(set_plant)
		change_plant(set_plant)
	else
		change_plant(plant)
	change_color(plant_color)

	update_icon()

	set_light(brightness_on, brightness_on/2)

/obj/structure/holoplant/on_update_icon()
	overlays.Cut()
	if (!plant)
		return

	plant.ChangeOpacity(hologram_opacity)
	overlays += plant

/obj/structure/holoplant/proc/change_plant(var/state)
	plant = prepare_icon(state)

/obj/structure/holoplant/proc/change_color(var/color)
	if (!plant)
		return

	if(!color)
		color = pick(possible_colors)

	glow_color = color
	plant_color = color
	plant.ColorTone(color)

	set_light(l_color=color)

/obj/structure/holoplant/attack_hand(var/mob/user)
	if(!interference)
		if (prob(1))
			change_plant("emaged")
		else if (set_plant)
			change_plant(set_plant)
		else
			change_plant()
		update_icon()

/obj/structure/holoplant/proc/prepare_icon(var/state)
	if(!state)
		state = pick(possible_plants)

	var/plant_icon = icon(icon, state)
	return getHologramIcon(plant_icon, 0, hologram_opacity)

/obj/structure/holoplant/emag_act()
	if(emaged)
		return

	emaged = TRUE
	plant = change_plant("emaged")

	update_icon()

/obj/structure/holoplant/proc/doInterference()
	if(!interference)
		interference = TRUE
		spawn(0)
			if (QDELETED(src))
				return

			overlays.Cut()
			set_light(0, 0)
			sleep(3)
			if (QDELETED(src))
				return

			overlays += plant
			set_light(brightness_on, brightness_on/2)
			sleep(3)
			if (QDELETED(src))
				return

			overlays -= plant
			set_light(0, 0)
			sleep(3)
			if (QDELETED(src))
				return

			change_color()
			set_light(brightness_on, brightness_on/2)
			update_icon()

			interference = FALSE

/obj/structure/holoplant/Crossed(var/mob/living/L)
	if (istype(L))
		doInterference()

/obj/structure/holoplant/steve
	name = "holo-steve"
	desc = "A holographic plant resembling what was once a very, very smelly plant"
	set_plant = "plant-14"