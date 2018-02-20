/obj/effect/projectile
	icon = 'icons/effects/projectiles.dmi'
	icon_state = "bolt"
	plane = EFFECTS_ABOVE_LIGHTING_PLANE
	layer = BEAM_PROJECTILE_LAYER //Muzzle flashes would be above the lighting plane anyways.
	//Standard compiletime light vars aren't working here, so we've made some of our own.
	light_range = 2
	light_power = 1
	light_color = "#FF00DC"

/obj/effect/projectile/proc/set_transform(var/matrix/M)
	if(istype(M))
		transform = M

//----------------------------
// Laser beam
//----------------------------
/obj/effect/projectile/laser/
	light_color = COLOR_RED_LIGHT

/obj/effect/projectile/laser/tracer
	icon_state = "beam"

/obj/effect/projectile/laser/muzzle
	icon_state = "muzzle_laser"

/obj/effect/projectile/laser/impact
	icon_state = "impact_laser"

//----------------------------
// Blue laser beam
//----------------------------
/obj/effect/projectile/laser/blue
	light_color = COLOR_BLUE_LIGHT

/obj/effect/projectile/laser/blue/tracer
	icon_state = "beam_blue"

/obj/effect/projectile/laser/blue/muzzle
	icon_state = "muzzle_blue"

/obj/effect/projectile/laser/blue/impact
	icon_state = "impact_blue"

//----------------------------
// Omni laser beam
//----------------------------
/obj/effect/projectile/laser/omni
	light_color = COLOR_LUMINOL

/obj/effect/projectile/laser/omni/tracer//tracer
	icon_state = "beam_omni"

/obj/effect/projectile/laser/omni/muzzle//muzzle
	icon_state = "muzzle_omni"

/obj/effect/projectile/laser/omni/impact//impact
	icon_state = "impact_omni"

//----------------------------
// Xray laser beam
//----------------------------
/obj/effect/projectile/laser/xray
	light_color = "#00cc00"

/obj/effect/projectile/laser/xray/tracer
	icon_state = "xray"

/obj/effect/projectile/laser/xray/muzzle
	icon_state = "muzzle_xray"

/obj/effect/projectile/laser/xray/impact
	icon_state = "impact_xray"

//----------------------------
// Heavy laser beam
//----------------------------
/obj/effect/projectile/laser/heavy
	light_power = 3

/obj/effect/projectile/laser/heavy/tracer
	icon_state = "beam_heavy"

/obj/effect/projectile/laser/heavy/muzzle
	icon_state = "muzzle_beam_heavy"

/obj/effect/projectile/laser/heavy/impact
	icon_state = "impact_beam_heavy"

//----------------------------
// Pulse laser beam
//----------------------------
/obj/effect/projectile/laser/pulse
	light_power = 2
	light_color = COLOR_DEEP_SKY_BLUE

/obj/effect/projectile/laser/pulse/tracer
	icon_state = "u_laser"


/obj/effect/projectile/laser/pulse/muzzle
	icon_state = "muzzle_u_laser"

/obj/effect/projectile/laser/pulse/impact
	icon_state = "impact_u_laser"

//----------------------------
// Bogani Pulsar beam
//----------------------------
/obj/effect/projectile/laser/bogani/
	light_power = 2
	light_color = COLOR_VIOLET

/obj/effect/projectile/laser/bogani/tracer
	icon_state = "bogb"

/obj/effect/projectile/laser/bogani/muzzle
	icon_state = "muzzle_bogb"

/obj/effect/projectile/laser/bogani/impact
	icon_state = "impact_bogb"

//----------------------------
// Pulse muzzle effect only
//----------------------------
/obj/effect/projectile/pulse/muzzle
	icon_state = "muzzle_pulse"
	light_power = 2
	light_color = COLOR_DEEP_SKY_BLUE

//----------------------------
// Treye beam
//----------------------------
/obj/effect/projectile/trilaser/
	light_color = COLOR_LUMINOL

/obj/effect/projectile/trilaser/tracer
	icon_state = "plasmacutter"

/obj/effect/projectile/trilaser/muzzle
	icon_state = "muzzle_plasmacutter"

/obj/effect/projectile/trilaser/impact
	icon_state = "impact_plasmacutter"

//----------------------------
// laser/emitter beam
//----------------------------
/obj/effect/projectile/laser/emitter/
	light_power = 3
	light_color = "#00cc00"

/obj/effect/projectile/laser/emitter/tracer
	icon_state = "laser/emitter"

/obj/effect/projectile/laser/emitter/muzzle
	icon_state = "muzzle_laser/emitter"

/obj/effect/projectile/laser/emitter/impact
	icon_state = "impact_laser/emitter"

//----------------------------
// Stun beam
//----------------------------
/obj/effect/projectile/stun/
	light_color = COLOR_YELLOW

/obj/effect/projectile/stun/tracer
	icon_state = "stun"

/obj/effect/projectile/stun/muzzle
	icon_state = "muzzle_stun"

/obj/effect/projectile/stun/impact
	icon_state = "impact_stun"

//----------------------------
// Bullet
//----------------------------
/obj/effect/projectile/bullet/muzzle
	icon_state = "muzzle_bullet"
	light_range = 5
	light_power = 1
	light_color = COLOR_MUZZLE_FLASH