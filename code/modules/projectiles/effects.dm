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
	light_max_bright = 3

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
	light_max_bright = 2
	light_color = COLOR_DEEP_SKY_BLUE

/obj/effect/projectile/laser/pulse/tracer
	icon_state = "u_laser"


/obj/effect/projectile/laser/pulse/muzzle
	icon_state = "muzzle_u_laser"

/obj/effect/projectile/laser/pulse/impact
	icon_state = "impact_u_laser"

//----------------------------
// Pulse muzzle effect only
//----------------------------
/obj/effect/projectile/pulse/muzzle
	icon_state = "muzzle_pulse"
	light_max_bright = 2
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
// Emitter beam
//----------------------------
/obj/effect/projectile/laser/emitter/
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
	light_outer_range = 5
	light_max_bright = 1
	light_color = COLOR_MUZZLE_FLASH


//----------------------------
// Sustained tracer beams
//----------------------------
//There is some special code here
/obj/effect/projectile/sustained
	light_outer_range = 5
	light_max_bright = 1
	light_color = COLOR_DEEP_SKY_BLUE
	icon_state = "gravity_tether"

	//Start and endpoints are in world pixel coordinates
	var/vector2/start
	var/vector2/end
	var/vector2/offset = new /vector2(16,16)
	animate_movement = 0

//Takes start and endpoint as vector2s of global pixel coords
/obj/effect/projectile/sustained/proc/set_ends(var/vector2/_start = null, var/vector2/_end = null)
	if (_start != start)
		start = _start// + offset

	if (_end != end)
		end = _end// + offset



	var/matrix/M = matrix()

	//Get the vector between them first
	var/vector2/delta = end - start

	//Figuring out scale
	var/length = delta.Magnitude()
	var/scale = length / world.icon_size //The length of the beam
	M.Scale(scale, 1)

	//Now rotation
	var/rot = Atan2(delta.y, delta.x)
	M.Turn(rot-90)

	//Apply the transform to ourselves
	transform = M

	//And finally, place our location halfway along the delta line
	set_global_pixel_loc(start + (delta*0.5))
