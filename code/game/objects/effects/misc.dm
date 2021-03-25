//The effect when you wrap a dead body in gift wrap
/obj/effect/spresent
	name = "strange present"
	desc = "It's a ... present?"
	icon = 'icons/obj/items.dmi'
	icon_state = "strangepresent"
	density = TRUE
	anchored = FALSE

/obj/effect/stop
	var/victim = null
	icon_state = "empty"
	name = "Geas"
	desc = "You can't resist."

//Paints the wall it spawns on, then dies
/obj/effect/paint
	name = "coat of paint"
	icon = 'icons/effects/effects.dmi'
	icon_state = "wall_paint_effect"
	layer = TURF_DETAIL_LAYER
	blend_mode = BLEND_MULTIPLY

/obj/effect/paint/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/paint/LateInitialize()
	var/turf/simulated/wall/W = get_turf(src)
	if(istype(W))
		W.paint_color = color
		W.update_icon()
	var/obj/structure/wall_frame/WF = locate() in loc
	if(WF)
		WF.paint_color = color
		WF.update_icon()
	qdel(src)

/obj/effect/paint/pink
	color = COLOR_PINK

/obj/effect/paint/sun
	color = COLOR_SUN

/obj/effect/paint/red
	color = COLOR_RED

/obj/effect/paint/silver
	color = COLOR_SILVER

/obj/effect/paint/black
	color = COLOR_DARK_GRAY

/obj/effect/paint/green
	color = COLOR_GREEN_GRAY

/obj/effect/paint/blue
	color = COLOR_NAVY_BLUE

obj/effect/paint/ocean
	color =	COLOR_OCEAN

obj/effect/paint/palegreengray
	color =	COLOR_PALE_GREEN_GRAY

/obj/effect/paint/brown
	color = COLOR_DARK_BROWN

//Stripes the wall it spawns on, then dies
/obj/effect/paint_stripe
	name = "stripe of paint"
	icon = 'icons/effects/effects.dmi'
	icon_state = "white"
	layer = TURF_DETAIL_LAYER
	blend_mode = BLEND_MULTIPLY

/obj/effect/paint_stripe/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/paint_stripe/LateInitialize()
	var/turf/simulated/wall/W = get_turf(src)
	if(istype(W))
		W.stripe_color = color
		W.update_icon()
	var/obj/structure/wall_frame/WF = locate() in loc
	if(WF)
		WF.stripe_color = color
		WF.update_icon()
	qdel(src)

/obj/effect/paint_stripe/green
	color = COLOR_GREEN_GRAY

/obj/effect/paint_stripe/red
	color = COLOR_RED_GRAY

/obj/effect/paint_stripe/paleblue
	color = COLOR_PALE_BLUE_GRAY

/obj/effect/paint_stripe/yellow
	color = COLOR_BROWN

/obj/effect/paint_stripe/blue
	color = COLOR_BLUE_GRAY

/obj/effect/paint_stripe/brown
	color = COLOR_DARK_BROWN

/obj/effect/paint_stripe/mauve
	color = COLOR_PALE_PURPLE_GRAY

/obj/effect/paint_stripe/white
	color = COLOR_SILVER

/obj/effect/paint_stripe/gunmetal
	color = COLOR_GUNMETAL

/obj/effect/gas_setup	//cryogenic
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x3"
	var/tempurature = 70
	var/pressure = 20* ONE_ATMOSPHERE

/obj/effect/gas_setup/Initialize()
	SHOULD_CALL_PARENT(FALSE)
	atom_flags |= ATOM_FLAG_INITIALIZED
	var/obj/machinery/atmospherics/pipe/P = locate() in loc
	if(P && !P.air_temporary)
		P.air_temporary = new(P.volume, tempurature)
		var/datum/gas_mixture/G = P.air_temporary
		G.adjust_gas(GAS_OXYGEN,((pressure*P.volume)/(R_IDEAL_GAS_EQUATION*temperature)))
	return INITIALIZE_HINT_QDEL