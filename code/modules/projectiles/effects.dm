/obj/projectile
	icon = 'icons/effects/projectiles.dmi'
	icon_state = "bolt"
	plane = EFFECTS_ABOVE_LIGHTING_PLANE
	layer = BEAM_PROJECTILE_LAYER //Muzzle flashes would be above the lighting plane anyways.
	//Standard compiletime light vars aren't working here, so we've made some of our own.
	light_range = 2
	light_power = 1
	light_color = "#ff00dc"

	mouse_opacity = 0


//----------------------------
// Laser beam
//----------------------------
/obj/projectile/laser
	light_color = COLOR_RED_LIGHT

/obj/projectile/laser/tracer
	icon_state = "beam"

/obj/projectile/laser/muzzle
	icon_state = "muzzle_laser"

/obj/projectile/laser/impact
	icon_state = "impact_laser"

//----------------------------
// Blue laser beam
//----------------------------
/obj/projectile/laser/blue
	light_color = COLOR_BLUE_LIGHT

/obj/projectile/laser/blue/tracer
	icon_state = "beam_blue"

/obj/projectile/laser/blue/muzzle
	icon_state = "muzzle_blue"

/obj/projectile/laser/blue/impact
	icon_state = "impact_blue"

//----------------------------
// Omni laser beam
//----------------------------
/obj/projectile/laser/omni
	light_color = COLOR_LUMINOL

/obj/projectile/laser/omni/tracer
	icon_state = "beam_omni"

/obj/projectile/laser/omni/muzzle
	icon_state = "muzzle_omni"

/obj/projectile/laser/omni/impact
	icon_state = "impact_omni"

//----------------------------
// Xray laser beam
//----------------------------
/obj/projectile/laser/xray
	light_color = "#00cc00"

/obj/projectile/laser/xray/tracer
	icon_state = "xray"

/obj/projectile/laser/xray/muzzle
	icon_state = "muzzle_xray"

/obj/projectile/laser/xray/impact
	icon_state = "impact_xray"

//----------------------------
// Heavy laser beam
//----------------------------
/obj/projectile/laser/heavy
	light_power = 1

/obj/projectile/laser/heavy/tracer
	icon_state = "beam_heavy"

/obj/projectile/laser/heavy/muzzle
	icon_state = "muzzle_beam_heavy"

/obj/projectile/laser/heavy/impact
	icon_state = "impact_beam_heavy"

//----------------------------
// Pulse laser beam
//----------------------------
/obj/projectile/laser/pulse
	light_power = 1
	light_color = COLOR_DEEP_SKY_BLUE

/obj/projectile/laser/pulse/tracer
	icon_state = "u_laser"


/obj/projectile/laser/pulse/muzzle
	icon_state = "muzzle_u_laser"

/obj/projectile/laser/pulse/impact
	icon_state = "impact_u_laser"

//----------------------------
// Skrell laser beam
//----------------------------
/obj/projectile/laser/pulse/skrell
	light_power = 1
	light_color = "#4c00ff"

/obj/projectile/laser/pulse/skrell/tracer
	icon_state = "pu_laser"

/obj/projectile/laser/pulse/skrell/muzzle
	icon_state = "muzzle_pu_laser"

/obj/projectile/laser/pulse/skrell/impact
	icon_state = "impact_pu_laser"

//----------------------------
// Pulse muzzle effect only
//----------------------------
/obj/projectile/pulse/muzzle
	icon_state = "muzzle_pulse"
	light_power = 1
	light_color = COLOR_DEEP_SKY_BLUE

//----------------------------
// Treye beam
//----------------------------
/obj/projectile/trilaser
	light_color = COLOR_LUMINOL

/obj/projectile/trilaser/tracer
	icon_state = "plasmacutter"

/obj/projectile/trilaser/muzzle
	icon_state = "muzzle_plasmacutter"

/obj/projectile/trilaser/impact
	icon_state = "impact_plasmacutter"

//----------------------------
// Emitter beam
//----------------------------
/obj/projectile/laser/emitter
	light_power = 1
	light_color = "#00cc00"

/obj/projectile/laser/emitter/tracer
	icon_state = "emitter"

/obj/projectile/laser/emitter/muzzle
	icon_state = "muzzle_emitter"

/obj/projectile/laser/emitter/impact
	icon_state = "impact_emitter"

//----------------------------
// Stun beam
//----------------------------
/obj/projectile/stun
	light_color = COLOR_YELLOW

/obj/projectile/stun/tracer
	icon_state = "stun"

/obj/projectile/stun/muzzle
	icon_state = "muzzle_stun"

/obj/projectile/stun/impact
	icon_state = "impact_stun"

//----------------------------
// Bullet
//----------------------------
/obj/projectile/bullet/muzzle
	icon_state = "muzzle_bullet"
	light_range = 5
	light_power = 1
	light_color = COLOR_MUZZLE_FLASH

//----------------------------
// confuse ray
//----------------------------
/obj/projectile/confuseray
	light_color = COLOR_GREEN_GRAY

/obj/projectile/confuseray/tracer
	icon_state = "beam_grass"

/obj/projectile/confuseray/muzzle
	icon_state = "muzzle_grass"

/obj/projectile/confuseray/impact
	icon_state = "impact_grass"

//----------------------------
// Particle beam
//----------------------------
/obj/projectile/laser_particle
	light_color = COLOR_CYAN

/obj/projectile/laser_particle/tracer
	icon_state = "beam_particle"

/obj/projectile/laser_particle/muzzle
	icon_state = "muzzle_particle"

/obj/projectile/laser_particle/impact
	icon_state = "impact_particle"

//----------------------------
// Dark matter
//----------------------------
/obj/projectile/darkmatter
	light_color = COLOR_PURPLE

/obj/projectile/darkmatter/tracer
	icon_state = "beam_darkb"

/obj/projectile/darkmatter/muzzle
	icon_state = "muzzle_darkb"

/obj/projectile/darkmatter/impact
	icon_state = "impact_darkb"

	//----------------------------
// Dark matter stun
//----------------------------
/obj/projectile/stun/darkmatter
	light_color = COLOR_PURPLE

/obj/projectile/stun/darkmatter/tracer
	icon_state = "beam_darkt"

/obj/projectile/stun/darkmatter/muzzle
	icon_state = "muzzle_darkt"

/obj/projectile/stun/darkmatter/impact
	icon_state = "impact_darkt"

//----------------------------
// Point defense
//----------------------------
/obj/projectile/pointdefense
	light_color = COLOR_GOLD
	light_power = 1

/obj/projectile/pointdefense/tracer
	icon_state = "beam_pointdef_d"

/obj/projectile/pointdefense/muzzle
	icon_state = "muzzle_pointdef_d"

/obj/projectile/pointdefense/impact
	icon_state = "impact_pointdef_d"

//----------------------------
// incendiary laser
//----------------------------
/obj/projectile/incen
	light_color = COLOR_PALE_ORANGE

/obj/projectile/incen/tracer
	icon_state = "beam_incen"

/obj/projectile/incen/muzzle
	icon_state = "muzzle_incen"

/obj/projectile/incen/impact
	icon_state = "impact_incen"
