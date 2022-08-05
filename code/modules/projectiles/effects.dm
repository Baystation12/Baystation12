/obj/effect/projectile
	icon = 'icons/effects/projectiles.dmi'
	icon_state = "bolt"
	plane = EFFECTS_ABOVE_LIGHTING_PLANE
	layer = BEAM_PROJECTILE_LAYER //Muzzle flashes would be above the lighting plane anyways.
	//Standard compiletime light vars aren't working here, so we've made some of our own.
	light_outer_range = 2
	light_max_bright = 1
	light_color = "#ff00dc"

	mouse_opacity = 0


//----------------------------
// Laser beam
//----------------------------
/obj/effect/projectile/laser
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

/obj/effect/projectile/laser/omni/tracer
	icon_state = "beam_omni"

/obj/effect/projectile/laser/omni/muzzle
	icon_state = "muzzle_omni"

/obj/effect/projectile/laser/omni/impact
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
	light_max_bright = 1

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
	light_max_bright = 1
	light_color = COLOR_DEEP_SKY_BLUE

/obj/effect/projectile/laser/pulse/tracer
	icon_state = "u_laser"


/obj/effect/projectile/laser/pulse/muzzle
	icon_state = "muzzle_u_laser"

/obj/effect/projectile/laser/pulse/impact
	icon_state = "impact_u_laser"

//----------------------------
// Skrell laser beam
//----------------------------
/obj/effect/projectile/laser/pulse/skrell
	light_max_bright = 1
	light_color = "#4c00ff"

/obj/effect/projectile/laser/pulse/skrell/tracer
	icon_state = "pu_laser"

/obj/effect/projectile/laser/pulse/skrell/muzzle
	icon_state = "muzzle_pu_laser"

/obj/effect/projectile/laser/pulse/skrell/impact
	icon_state = "impact_pu_laser"

//----------------------------
// Pulse muzzle effect only
//----------------------------
/obj/effect/projectile/pulse/muzzle
	icon_state = "muzzle_pulse"
	light_max_bright = 1
	light_color = COLOR_DEEP_SKY_BLUE

//----------------------------
// Treye beam
//----------------------------
/obj/effect/projectile/trilaser
	light_color = COLOR_LUMINOL

/obj/effect/projectile/trilaser/tracer
	icon_state = "plasmacutter"

/obj/effect/projectile/trilaser/muzzle
	icon_state = "muzzle_plasmacutter"

/obj/effect/projectile/trilaser/impact
	icon_state = "impact_plasmacutter"

//----------------------------
// Emitter beam
//----------------------------
/obj/effect/projectile/laser/emitter
	light_max_bright = 1
	light_color = "#00cc00"

/obj/effect/projectile/laser/emitter/tracer
	icon_state = "emitter"

/obj/effect/projectile/laser/emitter/muzzle
	icon_state = "muzzle_emitter"

/obj/effect/projectile/laser/emitter/impact
	icon_state = "impact_emitter"

//----------------------------
// Stun beam
//----------------------------
/obj/effect/projectile/stun
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
	light_outer_range = 5
	light_max_bright = 1
	light_color = COLOR_MUZZLE_FLASH

//----------------------------
// confuse ray
//----------------------------
/obj/effect/projectile/confuseray
	light_color = COLOR_GREEN_GRAY

/obj/effect/projectile/confuseray/tracer
	icon_state = "beam_grass"

/obj/effect/projectile/confuseray/muzzle
	icon_state = "muzzle_grass"

/obj/effect/projectile/confuseray/impact
	icon_state = "impact_grass"

//----------------------------
// Particle beam
//----------------------------
/obj/effect/projectile/laser_particle
	light_color = COLOR_CYAN

/obj/effect/projectile/laser_particle/tracer
	icon_state = "beam_particle"

/obj/effect/projectile/laser_particle/muzzle
	icon_state = "muzzle_particle"

/obj/effect/projectile/laser_particle/impact
	icon_state = "impact_particle"

//----------------------------
// Dark matter
//----------------------------
/obj/effect/projectile/darkmatter
	light_color = COLOR_PURPLE

/obj/effect/projectile/darkmatter/tracer
	icon_state = "beam_darkb"

/obj/effect/projectile/darkmatter/muzzle
	icon_state = "muzzle_darkb"

/obj/effect/projectile/darkmatter/impact
	icon_state = "impact_darkb"

	//----------------------------
// Dark matter stun
//----------------------------
/obj/effect/projectile/stun/darkmatter
	light_color = COLOR_PURPLE

/obj/effect/projectile/stun/darkmatter/tracer
	icon_state = "beam_darkt"

/obj/effect/projectile/stun/darkmatter/muzzle
	icon_state = "muzzle_darkt"

/obj/effect/projectile/stun/darkmatter/impact
	icon_state = "impact_darkt"

//----------------------------
// Point defense
//----------------------------
/obj/effect/projectile/pointdefense
	light_color = COLOR_GOLD
	light_max_bright = 1

/obj/effect/projectile/pointdefense/tracer
	icon_state = "beam_pointdef_d"

/obj/effect/projectile/pointdefense/muzzle
	icon_state = "muzzle_pointdef_d"

/obj/effect/projectile/pointdefense/impact
	icon_state = "impact_pointdef_d"

//----------------------------
// incendiary laser
//----------------------------
/obj/effect/projectile/incen
	light_color = COLOR_PALE_ORANGE

/obj/effect/projectile/incen/tracer
	icon_state = "beam_incen"

/obj/effect/projectile/incen/muzzle
	icon_state = "muzzle_incen"

/obj/effect/projectile/incen/impact
	icon_state = "impact_incen"