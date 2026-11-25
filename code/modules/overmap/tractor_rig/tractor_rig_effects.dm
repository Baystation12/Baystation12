/*
 * Tractor rig minigame particles, filters and sounds. None of this
 * affects outcomes; it all runs on the operator's client.
 */

/// Slow motes drifting through the field. Coordinates are relative to the emitter, which sits at the field's centre.
/particles/tractor_dust
	name = "tractor dust"
	width = TRACTOR_FIELD_WIDTH
	height = TRACTOR_FIELD_HEIGHT
	count = 70
	spawning = 0.4
	lifespan = 80
	fade = 30
	fadein = 20
	position = generator("box", list(-TRACTOR_FIELD_WIDTH / 2, -TRACTOR_FIELD_HEIGHT / 2 + 48), list(TRACTOR_FIELD_WIDTH / 2, TRACTOR_FIELD_HEIGHT / 2 - 48))
	velocity = generator("box", list(-0.15, -0.04), list(0.15, 0.04))
	color = TRACTOR_COLOUR_DIM


/// A burst of sparks where the claw hits something. Made fresh for each burst and switched off after a tick.
/particles/tractor_sparks
	name = "tractor sparks"
	width = 160
	height = 160
	count = 28
	spawning = 28
	lifespan = 7
	fade = 5
	velocity = generator("circle", 2, 6)
	friction = 0.2
	color = TRACTOR_COLOUR_BRIGHT


/// Shimmer around the claw while the beam holds it.
/particles/tractor_claw
	name = "tractor claw shimmer"
	width = 64
	height = 96
	count = 24
	spawning = 1.5
	lifespan = 8
	fade = 6
	position = generator("box", list(-11, -6), list(11, 6))
	velocity = generator("box", list(-0.2, 0.5), list(0.2, 1.5))
	color = TRACTOR_COLOUR_HOT


/// The plane master/game screen for the playfield map. Its filters and transform apply to everything drawn on the playfield.
/obj/screen/tractor_rig/plane_master
	icon = null
	appearance_flags = PLANE_MASTER | NO_CLIENT_COLOR
	blend_mode = BLEND_OVERLAY


/**
 * Sets up whole-screen effects: the plane master's phosphor bloom, the CRT
 * scanlines and vignette, the flash overlay and the drifting dust.
 */
/datum/tractor_rig_session/proc/build_effects()
	plane_master = new
	plane_master.plane = TRACTOR_PLANE
	plane_master.screen_loc = "[TRACTOR_MAP]:CENTER"
	plane_master.filters += filter(type = "bloom", threshold = rgb(40, 140, 70), size = 2, offset = 1, alpha = 170)
	screen_objects += plane_master
	user.client?.screen += plane_master

	make_object("scanlines", 0, 0, 19, TRACTOR_FIELD_HEIGHT / world.icon_size)
	var/obj/screen/tractor_rig/vignette = make_object("vignette", 0, 0, 20)
	vignette.transform = field_cover_matrix()

	flash_overlay = make_object("flat", 0, 0, 18)
	flash_overlay.transform = field_cover_matrix()
	flash_overlay.blend_mode = BLEND_ADD
	flash_overlay.alpha = 0

	var/obj/screen/tractor_rig/dust = make_object(null, TRACTOR_FIELD_WIDTH / 2 - 16, TRACTOR_FIELD_HEIGHT / 2 - 16, 2.2)
	dust.particles = new /particles/tractor_dust


/**
 * The NO SIGNAL screen shown over the playfield while the console has no link to
 * its projector
 */
/datum/tractor_rig_session/proc/build_offline_screen()
	offline_wash = make_object("flat", 0, 0, 15)
	offline_wash.transform = field_cover_matrix()
	offline_wash.color = TRACTOR_COLOUR_GLASS
	offline_wash.alpha = 0

	offline_static = make_object(null, TRACTOR_FIELD_WIDTH / 2 - 16, TRACTOR_FIELD_HEIGHT / 2 - 16, 15.5)
	var/particles/tractor_static/snow = new
	snow.spawning = 0
	offline_static.particles = snow

	offline_message = make_object(null, TRACTOR_FIELD_WIDTH / 2 - 160, TRACTOR_FIELD_HEIGHT / 2 - 40, 16)
	offline_message.maptext_width = 320
	offline_message.maptext_height = 80
	offline_message.alpha = 0


/// Shows the NO SIGNAL screen with `problem` as the reason, or hides it if `problem` is null.
/datum/tractor_rig_session/proc/show_offline_screen(problem)
	if (!offline_wash)
		return
	var/particles/tractor_static/snow = offline_static.particles
	if (!problem)
		animate(offline_wash, alpha = 0, time = 4)
		animate(offline_message)
		offline_message.alpha = 0
		if (snow)
			snow.spawning = 0
		screen_flash(TRACTOR_COLOUR_BRIGHT, 60)
		return
	animate(offline_wash, alpha = 215, time = 2)
	if (snow)
		snow.spawning = 40
	var/style = "font-family: \"Small Fonts\"; text-align: center; -dm-text-outline: 1px [TRACTOR_COLOUR_GLASS]"
	var/text = "<div style='[style]'>"
	text += "<span style='font-size: 14px; color: [TRACTOR_COLOUR_THREAT]'>&#9888; NO SIGNAL</span><br>"
	text += "<span style='font-size: 7px; color: [TRACTOR_COLOUR_THREAT]'>[uppertext(problem)]</span><br><br>"
	text += "<span style='font-size: 6px; color: [TRACTOR_COLOUR_AMBER]'>RESTORE POWER TO THE PROJECTOR AND CONSOLE</span></div>"
	offline_message.maptext = text
	offline_message.alpha = 255
	animate(offline_message, alpha = 255, time = 6, loop = -1)
	animate(alpha = 110, time = 4)
	screen_shake(3)


/// Snow on a dead screen.
/particles/tractor_static
	icon = 'icons/effects/tractor_rig.dmi'
	icon_state = "flat"
	width = 700
	height = 600
	count = 600
	spawning = 40
	lifespan = 2
	fade = 1
	position = generator("box", list(-320, -272), list(320, 272))
	scale = generator("num", 0.04, 0.09)
	color = generator("color", "#1a6b36", "#c8ffdb")


/// Stretches a 32px sprite over the whole playfield.
/datum/tractor_rig_session/proc/field_cover_matrix()
	return matrix(TRACTOR_FIELD_WIDTH / 32, 0, TRACTOR_FIELD_WIDTH / 2 - 16, 0, TRACTOR_FIELD_HEIGHT / 32, TRACTOR_FIELD_HEIGHT / 2 - 16)


/// Pulses a coloured wash over the whole playfield.
/datum/tractor_rig_session/proc/screen_flash(colour, strength = 80)
	flash_overlay.color = colour
	animate(flash_overlay, alpha = strength, time = 1)
	animate(alpha = 0, time = 7)


/// Rattles the whole playfield.
/datum/tractor_rig_session/proc/screen_shake(strength = 4)
	animate(plane_master, transform = matrix(1, 0, strength, 0, 1, -strength), time = 1)
	animate(transform = matrix(1, 0, -strength, 0, 1, strength / 2), time = 1)
	animate(transform = matrix(1, 0, strength / 2, 0, 1, strength), time = 1)
	animate(transform = matrix(1, 0, -strength / 2, 0, 1, -strength / 2), time = 1)
	animate(transform = matrix(), time = 2)


/// Throws a burst of sparks at (x, depth) in `colour`.
/datum/tractor_rig_session/proc/spark_burst(x, depth, colour)
	var/obj/screen/tractor_rig/emitter = make_object(null, x - 16, TRACTOR_HULL_Y - depth - 16, 8.4)
	var/particles/tractor_sparks/sparks = new
	sparks.color = colour
	emitter.particles = sparks
	addtimer(new Callback(src, PROC_REF(stop_sparks), emitter), 1)
	addtimer(new Callback(src, PROC_REF(remove_effect), emitter), 9)


/datum/tractor_rig_session/proc/stop_sparks(obj/screen/tractor_rig/emitter)
	if (QDELETED(emitter) || !emitter.particles)
		return
	emitter.particles.spawning = 0


/// Turns the claw's shimmer on or off.
/datum/tractor_rig_session/proc/set_claw_shimmer(on)
	if (on && !claw_object.particles)
		claw_object.particles = new /particles/tractor_claw
	else if (!on && claw_object.particles)
		QDEL_NULL(claw_object.particles)


/**
 * Filters and flicker for a contact's screen object, by what it is.
 * Ship threats pulse with a red glow; unidentified contacts are blurred and flicker
 * like a weak sensor return. Run again after animate_drift(), which replaces the
 * object's animations.
 */
/datum/tractor_rig_session/proc/dress_contact(datum/tractor_field_contact/contact, obj/screen/tractor_rig/object)
	object.filters = null
	if (contact.info.kind == TRACTOR_CONTACT_THREAT)
		object.filters += filter(type = "drop_shadow", x = 0, y = 0, size = 2, color = "[TRACTOR_COLOUR_THREAT]90")
		animate(object.filters[1], size = 5, time = 8, loop = -1, easing = SINE_EASING, flags = ANIMATION_PARALLEL)
		animate(size = 2, time = 8, easing = SINE_EASING)
	else if (is_hidden(contact))
		object.filters += filter(type = "blur", size = 0.6)
		animate(object, alpha = 150, time = rand(3, 6), loop = -1, flags = ANIMATION_PARALLEL)
		animate(alpha = 255, time = rand(2, 5))


/// A sound only the operator hears, from the console's speakers.
/datum/tractor_rig_session/proc/beep(sound_file, volume = 30)
	if (user?.client)
		sound_to(user, sound(sound_file, volume = volume))


/// A sound everyone near the console hears, use for alarms / machinery etc
/datum/tractor_rig_session/proc/machine_sound(sound_file, volume = 40)
	if (!QDELETED(console))
		playsound(console, sound_file, volume, TRUE)
