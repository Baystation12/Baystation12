/proc/generate_tracer_between_points(var/obj/item/projectile/source, datum/point/starting, datum/point/ending, beam_type, color, qdel_in = 5)		//Do not pass z-crossing points as that will not be properly (and likely will never be properly until it's absolutely needed) supported!
	if(!istype(starting) || !istype(ending) || !ispath(beam_type))
		return
	if(starting.z != ending.z)
		crash_with("Projectile tracer generation of cross-Z beam detected. This feature is not supported!")			//Do it anyways though.
	var/datum/point/midpoint = point_midpoint_points(starting, ending)
	var/obj/effect/projectile/tracer/PB = new beam_type
	source.update_effect(PB)
	PB.apply_vars(angle_between_points(starting, ending), midpoint.return_px(), midpoint.return_py(), color, pixel_length_between_points(starting, ending) / world.icon_size, midpoint.return_turf(), 0)
	. = PB
	if(qdel_in)
		QDEL_IN(PB, qdel_in)

/obj/effect/projectile/tracer
	name = "beam"
	icon = 'icons/effects/projectiles/tracer.dmi'

/obj/effect/projectile/tracer/laser
	name = "laser"
	icon_state = "beam"
	light_color = COLOR_RED

/obj/effect/projectile/tracer/laser/blue
	icon_state = "beam_blue"
	light_color = COLOR_SKY_BLUE

/obj/effect/projectile/tracer/confuseray
	name = "confuseray"
	icon_state = "grass"
	light_color = COLOR_LIGHT_CYAN

/obj/effect/projectile/tracer/laser/omni
	name = "omni"
	icon_state = "omni"
	light_color = COLOR_LIGHT_CYAN

/obj/effect/projectile/tracer/xray
	name = "xray laser"
	icon_state = "xray"
	light_color = COLOR_LIME

/obj/effect/projectile/tracer/pulse
	name = "pulse laser"
	icon_state = "u_laser"
	light_color = COLOR_SKY_BLUE

/obj/effect/projectile/tracer/plasma_cutter
	name = "plasma blast"
	icon_state = "plasmacutter"
	light_color = COLOR_LIGHT_CYAN

/obj/effect/projectile/tracer/stun
	name = "stun beam"
	icon_state = "stun"
	light_color = COLOR_YELLOW

/obj/effect/projectile/tracer/heavy_laser
	name = "heavy laser"
	icon_state = "heavy"
	light_color = COLOR_RED

/obj/effect/projectile/tracer/eyelaser
	icon_state = "eye"
	light_color = COLOR_RED

/obj/effect/projectile/tracer/pulse/skrell
	icon_state = "pu_laser"
	light_color = COLOR_VIOLET

/obj/effect/projectile/tracer/emitter
	icon_state = "emitter"
	light_color = COLOR_LIME

/obj/effect/projectile/tracer/tachyon
	name = "particle beam"
	icon_state = "invisible"
	light_color = COLOR_PINK

/obj/effect/projectile/tracer/particle
	name = "particle beam"
	icon_state = "particle"
	light_color = COLOR_PINK

/obj/effect/projectile/tracer/darkmatter
	name = "darkmatter beam"
	icon_state = "darkb"
	light_color = COLOR_PINK

/obj/effect/projectile/tracer/darkmattertaser
	name = "darktaser beam"
	icon_state = "darkt"
	light_color = COLOR_PINK

/obj/effect/projectile/tracer/incen
	icon_state = "incen"
	light_color = COLOR_RED

/obj/effect/projectile/tracer/pd
	icon_state = "pd"
	light_color = COLOR_YELLOW

/obj/effect/projectile/tracer/blood
	icon_state = "blood"
	light_color = COLOR_RED
