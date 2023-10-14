/obj/stop
	var/victim = null
	icon_state = "empty"
	name = "Geas"
	desc = "You can't resist."

//Paints the wall it spawns on, then dies
/obj/paint
	name = "coat of paint"
	icon = 'icons/effects/effects.dmi'
	icon_state = "wall_paint_effect"
	layer = TURF_DETAIL_LAYER
	blend_mode = BLEND_MULTIPLY

/obj/paint/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/paint/LateInitialize(mapload)
	var/turf/simulated/wall/W = get_turf(src)
	if(istype(W))
		W.paint_color = color
		W.update_icon()
	var/obj/structure/wall_frame/WF = locate() in loc
	if(WF)
		WF.paint_color = color
		WF.update_icon()
	qdel(src)

/obj/paint/pink
	color = COLOR_PINK

/obj/paint/sun
	color = COLOR_SUN

/obj/paint/red
	color = COLOR_RED

/obj/paint/silver
	color = COLOR_SILVER

/obj/paint/black
	color = COLOR_DARK_GRAY

/obj/paint/green
	color = COLOR_GREEN_GRAY

/obj/paint/blue
	color = COLOR_NAVY_BLUE

/obj/paint/ocean
	color =	COLOR_OCEAN

/obj/paint/palegreengray
	color =	COLOR_PALE_GREEN_GRAY

/obj/paint/brown
	color = COLOR_DARK_BROWN

//Stripes the wall it spawns on, then dies
/obj/paint_stripe
	name = "stripe of paint"
	icon = 'icons/effects/effects.dmi'
	icon_state = "white"
	layer = TURF_DETAIL_LAYER
	blend_mode = BLEND_MULTIPLY

/obj/paint_stripe/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/paint_stripe/LateInitialize(mapload)
	var/turf/simulated/wall/W = get_turf(src)
	if(istype(W))
		W.stripe_color = color
		W.update_icon()
	var/obj/structure/wall_frame/WF = locate() in loc
	if(WF)
		WF.stripe_color = color
		WF.update_icon()
	qdel(src)

/obj/paint_stripe/green
	color = COLOR_GREEN_GRAY

/obj/paint_stripe/red
	color = COLOR_RED_GRAY

/obj/paint_stripe/paleblue
	color = COLOR_PALE_BLUE_GRAY

/obj/paint_stripe/yellow
	color = COLOR_BROWN

/obj/paint_stripe/blue
	color = COLOR_BLUE_GRAY

/obj/paint_stripe/brown
	color = COLOR_DARK_BROWN

/obj/paint_stripe/mauve
	color = COLOR_PALE_PURPLE_GRAY

/obj/paint_stripe/white
	color = COLOR_SILVER

/obj/paint_stripe/gunmetal
	color = COLOR_GUNMETAL

/obj/gas_setup	//cryogenic
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x3"
	var/tempurature = 70
	var/pressure = 20* ONE_ATMOSPHERE

/obj/gas_setup/Initialize()
	SHOULD_CALL_PARENT(FALSE)
	atom_flags |= ATOM_FLAG_INITIALIZED
	var/obj/machinery/atmospherics/pipe/P = locate() in loc
	if(P && !P.air_temporary)
		P.air_temporary = new(P.volume, tempurature)
		var/datum/gas_mixture/G = P.air_temporary
		G.adjust_gas(GAS_OXYGEN,((pressure*P.volume)/(R_IDEAL_GAS_EQUATION*temperature)))
	return INITIALIZE_HINT_QDEL

/obj/heat
	icon = 'icons/effects/fire.dmi'
	icon_state = "3"
	render_target = HEAT_EFFECT_TARGET
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE

/// Example of a warp filter
/obj/effect/warp
	plane = WARP_EFFECT_PLANE
	appearance_flags = PIXEL_SCALE
	icon = 'icons/effects/352x352.dmi'
	icon_state = "singularity_s11"
	pixel_x = -176
	pixel_y = -176
	z_flags = ZMM_IGNORE
