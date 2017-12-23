/datum/map_template/ruin/exoplanet/monolith
	name = "Monolith Ring"
	id = "planetsite_monoliths"
	description = "Bunch of monoliths surrounding an artifact."
	suffixes = list("monoliths/monoliths.dmm")
	cost = 1

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
					H.hallucination(20, 100)
				return
	to_chat(user, "<span class='notice'>\The [src] is still.</span>")
	return ..()

/turf/simulated/floor/fixed/alium/ruin
	name = "ancient alien plating"
	desc = "This obviously wasn't made for your feet. Looks pretty old."
	initial_gas = null

/turf/simulated/floor/fixed/alium/ruin/Initialize()
	. = ..()
	if(prob(10))
		ChangeTurf(get_base_turf_by_area(src))