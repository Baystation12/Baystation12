/obj/item/flame/lighter
	name = "lighter"
	desc = "A cheap-as-free lighter."
	icon = 'icons/obj/lighters.dmi'
	icon_state = "lighter"
	item_state = "lighter"
	w_class = ITEM_SIZE_TINY
	throwforce = 4
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	attack_verb = list("burnt", "singed")
	var/max_fuel = 5
	var/random_colour = FALSE
	var/available_colors = list(COLOR_WHITE, COLOR_BLUE_GRAY, COLOR_GREEN_GRAY, COLOR_BOTTLE_GREEN, COLOR_DARK_GRAY, COLOR_RED_GRAY, COLOR_GUNMETAL, COLOR_RED, COLOR_YELLOW, COLOR_CYAN, COLOR_GREEN, COLOR_VIOLET, COLOR_NAVY_BLUE, COLOR_PINK)

/obj/item/flame/lighter/Initialize()
	. = ..()
	create_reagents(max_fuel)
	reagents.add_reagent(/datum/reagent/fuel, max_fuel)
	set_extension(src, /datum/extension/base_icon_state, icon_state)
	if(random_colour)
		color = pick(available_colors)
	update_icon()

/obj/item/flame/lighter/proc/light(mob/user)
	if(submerged())
		to_chat(user, "<span class='warning'>You cannot light \the [src] underwater.</span>")
		return
	lit = 1
	update_icon()
	light_effects(user)
	set_light(0.6, 0.5, 2, l_color = COLOR_PALE_ORANGE)
	START_PROCESSING(SSobj, src)

/obj/item/flame/lighter/proc/light_effects(mob/living/carbon/user)
	if(prob(95))
		user.visible_message("<span class='notice'>After a few attempts, [user] manages to light \the [src].</span>")
	else
		to_chat(user, "<span class='warning'>You burn yourself while lighting the lighter.</span>")
		if (user.l_hand == src)
			user.apply_damage(2,BURN,BP_L_HAND)
		else
			user.apply_damage(2,BURN,BP_R_HAND)
		user.visible_message("<span class='notice'>After a few attempts, [user] manages to light \the [src], burning their finger in the process.</span>")
	playsound(src.loc, "light_bic", 100, 1, -4)

/obj/item/flame/lighter/extinguish(var/mob/user, var/no_message)
	..()
	update_icon()
	if(user)
		shutoff_effects(user)
	else if(!no_message)
		visible_message("<span class='notice'>[src] goes out.</span>")
	set_light(0)

/obj/item/flame/lighter/proc/shutoff_effects(mob/user)
	user.visible_message("<span class='notice'>[user] quietly shuts off the [src].</span>")

/obj/item/flame/lighter/attack_self(mob/living/user)
	if(!lit)
		if(reagents.has_reagent(/datum/reagent/fuel))
			light(user)
		else
			to_chat(user, "<span class='warning'>\The [src] won't ignite - it must be out of fuel.</span>")
	else
		extinguish(user)

/obj/item/flame/lighter/on_update_icon()
	var/datum/extension/base_icon_state/bis = get_extension(src, /datum/extension/base_icon_state)

	overlays.Cut()
	if(lit)
		overlays += overlay_image(icon, "[bis.base_icon_state]_flame", flags=RESET_COLOR)
	else
		overlays += overlay_image(icon, "[bis.base_icon_state]_striker", flags=RESET_COLOR)

/obj/item/flame/lighter/attack(var/mob/living/M, var/mob/living/carbon/user)
	if(!istype(M, /mob))
		return

	if(lit)
		M.IgniteMob()

		if(istype(M.wear_mask, /obj/item/clothing/mask/smokable/cigarette) && user.zone_sel.selecting == BP_MOUTH)
			var/obj/item/clothing/mask/smokable/cigarette/cig = M.wear_mask
			if(M == user)
				cig.attackby(src, user)
			else
				cig.light("<span class='notice'>[user] holds the [name] out for [M], and lights the [cig.name].</span>")
			return
	..()

/obj/item/flame/lighter/Process()
	if(!submerged() && reagents.has_reagent(/datum/reagent/fuel))
		if(ismob(loc) && prob(10) && reagents.get_reagent_amount(/datum/reagent/fuel) < 1)
			to_chat(loc, "<span class='warning'>\The [src]'s flame flickers.</span>")
			set_light(0)
			addtimer(CALLBACK(src, .atom/proc/set_light, 0.6, 0.5, 2), 4)
		reagents.remove_reagent(/datum/reagent/fuel, 0.05)
	else
		extinguish()
		return

	var/turf/location = get_turf(src)
	if(location)
		location.hotspot_expose(700, 5)

/obj/item/flame/lighter/red
	color = COLOR_RED
	name = "red lighter"

/obj/item/flame/lighter/yellow
	color = COLOR_YELLOW
	name = "yellow lighter"

/obj/item/flame/lighter/cyan
	color = COLOR_CYAN
	name = "cyan lighter"

/obj/item/flame/lighter/green
	color = COLOR_GREEN
	name = "green lighter"

/obj/item/flame/lighter/pink
	color = COLOR_PINK
	name = "pink lighter"

/obj/item/flame/lighter/random
	random_colour = TRUE

/******
 Zippo
******/
/obj/item/flame/lighter/zippo
	name = "zippo lighter"
	desc = "It's a zippo-styled lighter, using a replacable flint in a fetching steel case. It makes a clicking sound that everyone loves."
	icon_state = "zippo"
	item_state = "zippo"
	max_fuel = 10
	available_colors = list(COLOR_WHITE, COLOR_WHITE, COLOR_WHITE, COLOR_DARK_GRAY, COLOR_GUNMETAL, COLOR_BRONZE, COLOR_BRASS)

/obj/item/flame/lighter/zippo/on_update_icon()
	var/datum/extension/base_icon_state/bis = get_extension(src, /datum/extension/base_icon_state)

	overlays.Cut()
	if(lit)
		icon_state = "[bis.base_icon_state]_open"
		item_state = "[bis.base_icon_state]_open"
		overlays += overlay_image(icon, "[bis.base_icon_state]_flame", flags=RESET_COLOR)
	else
		icon_state = "[bis.base_icon_state]"
		item_state = "[bis.base_icon_state]"

/obj/item/flame/lighter/zippo/light_effects(mob/user)
	user.visible_message("<span class='rose'>Without even breaking stride, [user] flips open and lights [src] in one smooth movement.</span>")
	playsound(src.loc, 'sound/items/zippo_open.ogg', 100, 1, -4)

/obj/item/flame/lighter/zippo/shutoff_effects(mob/user)
	user.visible_message("<span class='rose'>You hear a quiet click, as [user] shuts off [src] without even looking at what they're doing.</span>")
	playsound(src.loc, 'sound/items/zippo_close.ogg', 100, 1, -4)

/obj/item/flame/lighter/zippo/afterattack(obj/O, mob/user, proximity)
	if(!proximity) return
	if (istype(O, /obj/structure/reagent_dispensers/fueltank) && !lit)
		O.reagents.trans_to_obj(src, max_fuel)
		to_chat(user, "<span class='notice'>You refuel [src] from \the [O]</span>")
		playsound(src.loc, 'sound/effects/refill.ogg', 50, 1, -6)

/obj/item/flame/lighter/zippo/black
	color = COLOR_DARK_GRAY
	name = "black zippo"

/obj/item/flame/lighter/zippo/gunmetal
	color = COLOR_GUNMETAL
	name = "gunmetal zippo"

/obj/item/flame/lighter/zippo/brass
	color = COLOR_BRASS
	name = "brass zippo"

/obj/item/flame/lighter/zippo/bronze
	color = COLOR_BRONZE
	name = "bronze zippo"

/obj/item/flame/lighter/zippo/pink
	color = COLOR_PINK
	name = "pink zippo"

//Spawn using the colour list in the master type
/obj/item/flame/lighter/zippo/random
	random_colour = TRUE

//Legacy icon states for custom items
/obj/item/flame/lighter/zippo/custom/Initialize()
	. = ..()
	color = null

/obj/item/flame/lighter/zippo/custom/on_update_icon()
	var/datum/extension/base_icon_state/bis = get_extension(src, /datum/extension/base_icon_state)

	if(lit)
		icon_state = "[bis.base_icon_state]_on"
		item_state = "[bis.base_icon_state]_on"
	else
		icon_state = "[bis.base_icon_state]"
		item_state = "[bis.base_icon_state]"