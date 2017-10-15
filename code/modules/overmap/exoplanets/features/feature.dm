/datum/random_map/feature
	target_turf_type = /turf/simulated/floor/exoplanet
	var/unique = 0

/obj/structure/monolith
	name = "monolith"
	desc = "An obviously artifical structure of unknown origin."
	icon = 'icons/obj/monolith.dmi'
	icon_state = "jaggy1"
	plane = ABOVE_HUMAN_PLANE
	layer = ABOVE_HUMAN_LAYER
	density = 1
	anchored = 1
	var/active = 0

/obj/structure/monolith/Initialize()
	. = ..()
	icon_state = "jaggy[rand(1,4)]"
	var/material/A = get_material_by_name("alien alloy")
	if(A)
		color = A.icon_colour
	if(GLOB.using_map.use_overmap)
		var/obj/effect/overmap/sector/exoplanet/E = map_sectors["[z]"]
		if(istype(E))
			desc += "\nThere are images on it: [E.get_engravings()]"

/obj/structure/monolith/update_icon()
	overlays.Cut()
	if(active)
		var/image/I = image(icon,"[icon_state]decor")
		I.appearance_flags = RESET_COLOR
		I.color = get_random_colour(0, 150, 255)
		I.layer = ABOVE_LIGHTING_LAYER
		I.plane = EFFECTS_ABOVE_LIGHTING_PLANE
		overlays += I
		set_light(2, 1, I.color)

/obj/structure/monolith/attack_hand(mob/user)
	visible_message("[user] touches \the [src].")
	if(GLOB.using_map.use_overmap && istype(user,/mob/living/carbon/human))
		var/obj/effect/overmap/sector/exoplanet/E = map_sectors["[z]"]
		if(istype(E))
			var/mob/living/carbon/human/H = user
			if(!H.isSynthetic())
				active = 1
				update_icon()
				if(prob(99))
					to_chat(H, "<span class='notice'>As you touch \the [src], you suddenly get a vivid image - [E.get_engravings()]</span>")
				else
					to_chat(H, "<span class='warning'>An overwhelming stream of information invades your mind!</span>")
					var/vision = ""
					for(var/i = 1 to 10)
						vision += pick(E.actors) + " " + pick("killing","dying","gored","expiring","exploding","mauled","burning","flayed","in agony") + ". "
					to_chat(H, "<span class='danger'><font size=2>[uppertext(vision)]</font></span>")
					H.Paralyse(2)
					H.hallucinations += 10
				return
	to_chat(user, "<span class='notice'>\The [src] is still.</span>")
	return ..()

/datum/random_map/feature/monoliths
	descriptor = "Monoliths"
	limit_x = 15
	limit_y = 15
	initial_wall_cell = 0

/datum/random_map/feature/monoliths/generate_map()
	var/center_x = round(limit_x/2) + 1
	var/center_y = round(limit_y/2) + 1

	map[get_map_cell(center_x,center_y)] = 6

	var/list/monoliths
	switch(rand(1,3))
		if(1)
			monoliths = list(
				get_map_cell(center_x + 2,center_y + 2),
				get_map_cell(center_x + 2,center_y - 2),
				get_map_cell(center_x - 2,center_y + 2),
				get_map_cell(center_x - 2,center_y - 2),
				get_map_cell(center_x,center_y + 5),
				get_map_cell(center_x,center_y - 5),
				get_map_cell(center_x + 5,center_y),
				get_map_cell(center_x - 5,center_y)
				)
		if(2)
			monoliths = list(
				get_map_cell(center_x + 2,center_y + 3),
				get_map_cell(center_x + 2,center_y - 3),
				get_map_cell(center_x + 2,center_y),
				get_map_cell(center_x - 2,center_y + 3),
				get_map_cell(center_x - 2,center_y - 3),
				get_map_cell(center_x - 2,center_y)
				)
		if(3)
			monoliths = list(
				get_map_cell(center_x + 3,center_y + 3),
				get_map_cell(center_x + 3,center_y - 3),
				get_map_cell(center_x - 3,center_y + 3),
				get_map_cell(center_x - 3,center_y - 3),
				get_map_cell(center_x,center_y + 5),
				get_map_cell(center_x,center_y - 5),
				get_map_cell(center_x + 5,center_y),
				get_map_cell(center_x - 5,center_y)
				)

	for(var/coors in monoliths)
		map[coors] = 4


/datum/random_map/feature/monoliths/get_appropriate_path(var/value)
	return

/datum/random_map/feature/monoliths/get_additional_spawns(var/value, var/turf/T)
	switch(value)
		if(6)
			new /obj/machinery/artifact(T)
		if(4)
			new /obj/structure/monolith(T)