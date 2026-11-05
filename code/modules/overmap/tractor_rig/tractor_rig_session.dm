/// Operator sessions by ckey, so the window's close command can find them. It should be just one but I just dont trust our playerbase
var/global/list/tractor_rig_sessions = list()


/obj/screen/tractor_rig
	name = ""
	icon = 'icons/effects/tractor_rig.dmi'
	plane = TRACTOR_PLANE
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE


/**
 * One operator playing the tractor rig minigame.
 *
 * Map control showing the playfield as screen objects,
 * and a browser control with the side panel. All outcomes are decided here on
 * the server. The client only animates motion the server has already worked out.
 */
/datum/tractor_rig_session
	/// The console being operated.
	var/obj/machinery/computer/ship/tractor_rig/console
	/// The operator.
	var/mob/user
	/// The current playfield.
	var/datum/tractor_field/field
	/// One of TRACTOR_STATE_*.
	var/state = TRACTOR_STATE_IDLE
	/// Gantry position: the claw's centre x in pixels.
	var/claw_x = TRACTOR_FIELD_WIDTH / 2
	/// Bumped every cast and on close, so timers from an old cast do nothing.
	var/cast_id = 0
	/// world.time the current drop started.
	var/drop_start = 0
	/// Depth in pixels where the current drop stops on its own.
	var/stop_depth = 0
	/// Reel timing, for working out the claw's depth mid-reel.
	var/reel_start = 0
	var/reel_time = 0
	var/reel_depth = 0
	/// An ion knot drained the capacitors this cast.
	var/drained = FALSE
	/// Total mass on the claw.
	var/load = 0
	/// world.time the next cast is allowed.
	var/cooldown_until = 0
	/// Contacts on the claw.
	var/list/datum/tractor_field_contact/latched = list()
	/// A ship threat touched this cast, if any.
	var/datum/tractor_field_contact/threat_struck
	/// Newest first.
	var/list/log_lines = list()
	/// The last haul report, one line per item.
	var/list/last_haul = list()

	/// Every screen object this session made, for cleanup.
	var/list/obj/screen/tractor_rig/screen_objects = list()
	/// Field contact = its screen object.
	var/list/contact_objects = list()
	var/obj/screen/tractor_rig/emitter_object
	var/obj/screen/tractor_rig/beam_object
	var/obj/screen/tractor_rig/claw_object
	var/obj/screen/tractor_rig/limit_object
	var/obj/screen/tractor_rig/limit_label
	/// Dotted line showing where the claw will fall. Hidden while the claw is out.
	var/obj/screen/tractor_rig/aim_object
	/// The playfield's plane master: bloom, and the screen shake.
	var/obj/screen/tractor_rig/plane_master/plane_master
	/// Full-screen wash for flashes.
	var/obj/screen/tractor_rig/flash_overlay
	/// Why the console has no link to the projector, or null while it's up. Checked every second.
	var/link_problem
	/// The NO SIGNAL screen over the playfield while the link is down: a dark wash, static and a message.
	var/obj/screen/tractor_rig/offline_wash
	var/obj/screen/tractor_rig/offline_static
	var/obj/screen/tractor_rig/offline_message


/datum/tractor_rig_session/New(obj/machinery/computer/ship/tractor_rig/console, mob/user)
	..()
	src.console = console
	src.user = user
	tractor_rig_sessions[user.ckey] = src
	GLOB.moved_event.register(user, src, PROC_REF(check_user_in_range))
	GLOB.destroyed_event.register(user, src, PROC_REF(close))
	open_window()
	build_playfield()
	build_effects()
	build_offline_screen()
	new_field()
	beep('sound/machines/twobeep.ogg', 25)
	add_log("Rig online. Aim with the gantry, then drop the claw.")
	if (!console.linked)
		add_log("No ship link: only open space is in range.")
	watch_link()
	refresh_panel()


/datum/tractor_rig_session/Destroy()
	cast_id++
	console?.emitter?.set_casting(FALSE)
	if (console && !console.arrival_due)
		console.set_alarms(TRACTOR_ALARM_OFF)
	GLOB.moved_event.unregister(user, src, PROC_REF(check_user_in_range))
	GLOB.destroyed_event.unregister(user, src, PROC_REF(close))
	if (user?.client)
		user.client.screen -= screen_objects
		for (var/contact in contact_objects)
			user.client.screen -= contact_objects[contact]
		winshow(user.client, TRACTOR_WINDOW, FALSE)
	if (user && tractor_rig_sessions[user.ckey] == src)
		tractor_rig_sessions -= user.ckey
	for (var/contact in contact_objects)
		qdel(contact_objects[contact])
	contact_objects.Cut()
	QDEL_NULL_LIST(screen_objects)
	emitter_object = null
	beam_object = null
	claw_object = null
	limit_object = null
	limit_label = null
	aim_object = null
	plane_master = null
	flash_overlay = null
	offline_wash = null
	offline_static = null
	offline_message = null
	latched.Cut()
	threat_struck = null
	QDEL_NULL(field)
	if (console?.session == src)
		console.session = null
	console = null
	user = null
	return ..()


/datum/tractor_rig_session/proc/close()
	qdel(src)


/**
 * Checks the console's link to the projector, and again every second while the
 * session is open. Todo, callbacks or subsystem.
 */
/datum/tractor_rig_session/proc/watch_link()
	if (QDELETED(src) || QDELETED(console))
		return
	check_link()
	addtimer(new Callback(src, PROC_REF(watch_link)), 1 SECOND)


/datum/tractor_rig_session/proc/check_link()
	var/problem = console.link_problem()
	if (problem == link_problem)
		return
	var/was_down = !isnull(link_problem)
	link_problem = problem
	show_offline_screen(problem)
	if (problem)
		add_log("<span class='threat'>LINK LOST: [problem].</span>")
		beep('sound/machines/buzz-two.ogg', 30)
		if (state == TRACTOR_STATE_DROPPING || state == TRACTOR_STATE_REELING)
			// No power to hold the beam: it collapses and the claw springs back empty.
			cast_id++
			add_log("<span class='bad'>The beam collapsed. Everything on the claw is lost.</span>")
			lose_everything()
	else if (was_down)
		add_log("Link restored.")
		beep('sound/machines/twobeep.ogg', 25)
	refresh_panel()


/// Closes the session when the operator walks away from the console.
/datum/tractor_rig_session/proc/check_user_in_range()
	if (QDELETED(console) || !user || get_dist(user, console) > 1)
		close()


// Window and playfield setup.

/datum/tractor_rig_session/proc/open_window()
	var/client/C = user.client
	if (!winexists(C, TRACTOR_WINDOW))
		winclone(C, "window", TRACTOR_WINDOW)
	winset(C, TRACTOR_WINDOW, list2params(list(
		"title" = "[console.name]",
		"size" = "[TRACTOR_FIELD_WIDTH + 320]x[TRACTOR_FIELD_HEIGHT]",
		"can-resize" = "false",
		"statusbar" = "false",
		"on-close" = "tractor-rig-close"
	)))
	if (!winexists(C, TRACTOR_MAP))
		winset(C, TRACTOR_MAP, list2params(list(
			"parent" = TRACTOR_WINDOW,
			"type" = "map",
			"pos" = "0,0",
			"size" = "[TRACTOR_FIELD_WIDTH]x[TRACTOR_FIELD_HEIGHT]",
			"anchor1" = "0,0",
			"zoom" = "1",
			"background-color" = "#05080b"
		)))
	if (!winexists(C, TRACTOR_PANEL))
		winset(C, TRACTOR_PANEL, list2params(list(
			"parent" = TRACTOR_WINDOW,
			"type" = "browser",
			"pos" = "[TRACTOR_FIELD_WIDTH],0",
			"size" = "320x[TRACTOR_FIELD_HEIGHT]",
			"anchor1" = "0,0",
			"anchor2" = "100,100"
		)))
	winshow(C, TRACTOR_WINDOW, TRUE)
	winset(C, TRACTOR_PANEL, "focus=true")


/**
 * Makes a screen object on the playfield map. `x` and `y` place its sprite's
 * bottom-left corner, in pixels from the playfield's bottom-left.
 *
 * Screen objects ignore pixel_x and pixel_y, so single objects are placed with a
 * transform translation (which animate() can move), and full-width strips of
 * `rows` tiles are placed with pixel offsets in their screen_loc.
 */
/datum/tractor_rig_session/proc/make_object(icon_state, x, y, layer, rows = 0)
	var/obj/screen/tractor_rig/object = new
	object.icon_state = icon_state
	object.layer = layer
	if (rows)
		object.screen_loc = strip_loc(y, rows)
	else
		object.screen_loc = "[TRACTOR_MAP]:1,1"
		object.transform = tractor_rig_at(x, y)
	screen_objects += object
	user.client?.screen += object
	return object


/// screen_loc for a full-width strip `rows` tiles tall whose bottom edge is `y` pixels up the playfield.
/datum/tractor_rig_session/proc/strip_loc(y, rows)
	var/tile = floor(y / world.icon_size)
	var/offset = y - tile * world.icon_size
	var/width = TRACTOR_FIELD_WIDTH / world.icon_size
	return "[TRACTOR_MAP]:1,[tile + 1]:[offset] to [width],[tile + rows]:[offset]"


/// A translation matrix: what moves a screen object's sprite to (x, y) on the playfield.
/proc/tractor_rig_at(x, y)
	return matrix(1, 0, x, 0, 1, y)


/datum/tractor_rig_session/proc/make_label(text, x, y, colour = TRACTOR_COLOUR_MID, layer = 9)
	var/obj/screen/tractor_rig/label = make_object(null, x, y, layer)
	label.maptext = tractor_rig_maptext(text, colour)
	label.maptext_width = 300
	label.maptext_height = 12
	return label


/**
 * Phosphor-style maptext: small, upper case, with a dark outline so it reads over anything.
 * Pass `upper = FALSE` for text that's already upper case or holds HTML entities.
 */
/proc/tractor_rig_maptext(text, colour, upper = TRUE)
	return "<span style='font-family: \"Small Fonts\"; font-size: 6px; color: [colour]; -dm-text-outline: 1px [TRACTOR_COLOUR_GLASS]'>[upper ? uppertext(text) : text]</span>"


/datum/tractor_rig_session/proc/build_playfield()
	make_object("bg", 0, 0, 1, TRACTOR_FIELD_HEIGHT / world.icon_size)
	for (var/i = 1 to 16)
		make_object("star", rand(0, TRACTOR_FIELD_WIDTH - 32), rand(0, TRACTOR_HULL_Y - 48), 1.1)
	for (var/metres in list(8, 16, 24))
		var/y = TRACTOR_HULL_Y - metres * TRACTOR_PX_PER_M
		make_object("depthline", 0, y, 2, 1)
		make_label("[metres] m", 4, y - 11, TRACTOR_COLOUR_DIM)
	limit_object = make_object("limit", 0, 0, 2.1, 1)
	limit_label = make_label("", 4, 0, TRACTOR_COLOUR_AMBER)
	update_reach_line()

	// Two overlapping one-row strips cover the hull without poking out of the top of the playfield.
	make_object("hull", 0, TRACTOR_HULL_Y, 7, 1)
	make_object("hull", 0, TRACTOR_FIELD_HEIGHT - world.icon_size, 7, 1)
	make_object("rail", 0, TRACTOR_HULL_Y + 2, 7.1, 1)
	make_label("Hull · gantry rail", 6, TRACTOR_HULL_Y + 32, TRACTOR_COLOUR_MID, 9)

	// The radar sweep: a stretched sprite that loops down the field on the client.
	var/obj/screen/tractor_rig/sweep = make_object("sweep", 0, 0, 2.5)
	sweep.transform = sweep_matrix(TRACTOR_HULL_Y - 32)
	animate(sweep, transform = sweep_matrix(TRACTOR_HULL_Y - 32), time = 0, loop = -1)
	animate(transform = sweep_matrix(-32), time = TRACTOR_SWEEP_TIME)

	aim_object = make_object("aimline", claw_x - 16, TRACTOR_HULL_Y - 32, 4)
	update_aim()

	beam_object = make_object("beam", claw_x - 16, TRACTOR_HULL_Y - 32, 5)
	beam_object.transform = beam_matrix(0)
	claw_object = make_object("claw", claw_x - 16, claw_y(0), 6)
	claw_object.transform = claw_matrix(0)
	emitter_object = make_object("emitter", claw_x - 16, TRACTOR_HULL_Y - 6, 8)


/// Moves the red reach line to the emitter's current reach.
/datum/tractor_rig_session/proc/update_reach_line()
	var/reach = console?.emitter?.reach_px || 0
	var/y = TRACTOR_HULL_Y - reach
	limit_object.screen_loc = strip_loc(y, 1)
	limit_label.transform = tractor_rig_at(4, y - 11)
	limit_label.maptext = tractor_rig_maptext("Reach limit [round(reach / TRACTOR_PX_PER_M)] m", TRACTOR_COLOUR_AMBER)
	update_aim()


/// Bottom-left y of the claw sprite when the claw's centre is `depth` pixels below the hull.
/datum/tractor_rig_session/proc/claw_y(depth)
	return TRACTOR_HULL_Y - depth - 16


/// Stretches the 32px sweep sprite across the whole field, its bottom edge at `y`.
/datum/tractor_rig_session/proc/sweep_matrix(y)
	return matrix(TRACTOR_FIELD_WIDTH / 32, 0, TRACTOR_FIELD_WIDTH / 2 - 16, 0, 1, y)


/// Shows the dotted drop path from the claw to the reach limit while the claw is home.
/datum/tractor_rig_session/proc/update_aim()
	if (!aim_object)
		return
	var/reach = console?.emitter?.reach_px || 0
	aim_object.transform = beam_matrix(reach)
	aim_object.alpha = (state == TRACTOR_STATE_IDLE || state == TRACTOR_STATE_COOLDOWN) && reach ? 255 : 0


/// Places the claw at the gantry's x with its centre `depth` pixels below the hull.
/datum/tractor_rig_session/proc/claw_matrix(depth)
	return tractor_rig_at(claw_x - 16, claw_y(depth))


/**
 * Stretches the 32px beam sprite to `depth` pixels, hanging from the hull at the gantry's x.
 * Transforms scale about the sprite's centre, so it's shifted to keep its top at the hull.
 */
/datum/tractor_rig_session/proc/beam_matrix(depth)
	var/matrix/M = matrix()
	M.Scale(1, max(depth, 0.5) / 32)
	M.Translate(claw_x - 16, TRACTOR_HULL_Y - 32 + 16 - depth / 2)
	return M


// The field.

/// Replaces the playfield's contacts with a fresh scan of the area.
/datum/tractor_rig_session/proc/new_field()
	for (var/contact in contact_objects)
		discard_object(contact_objects[contact])
	contact_objects.Cut()
	QDEL_NULL(field)
	var/scan_range = clamp(console.emitter?.scan_tier || 1, 1, 3)
	field = new(console.linked, scan_range)
	for (var/datum/tractor_field_contact/contact as anything in field.contacts)
		add_contact_object(contact)


/datum/tractor_rig_session/proc/scan_tier()
	return console?.emitter?.scan_tier || 1


/// Whether the operator's scanner is too weak to identify a contact.
/datum/tractor_rig_session/proc/is_hidden(datum/tractor_field_contact/contact)
	return scan_tier() < 2 && contact.info.kind == TRACTOR_CONTACT_HAZARD


/// Whether the scanner can tell what kind of thing a contact is, but not exactly what: a rock, but not its mineral.
/datum/tractor_rig_session/proc/is_vague(datum/tractor_field_contact/contact)
	return contact.info.vague_name && scan_tier() < contact.info.identify_tier


/datum/tractor_rig_session/proc/contact_name(datum/tractor_field_contact/contact)
	if (is_hidden(contact))
		return "unknown contact"
	return is_vague(contact) ? contact.info.vague_name : contact.info.name


/datum/tractor_rig_session/proc/contact_label(datum/tractor_field_contact/contact)
	var/text = is_hidden(contact) ? "?" : contact_name(contact)
	if (contact.info.kind == TRACTOR_CONTACT_THREAT)
		text = "SHIP THREAT: [text]"
	else if (scan_tier() >= 3)
		text = "[text] · [contact.source.name]"
	var/colour = TRACTOR_COLOUR_BRIGHT
	if (is_hidden(contact))
		colour = TRACTOR_COLOUR_MID
	else if (contact.info.kind == TRACTOR_CONTACT_HAZARD)
		colour = TRACTOR_COLOUR_AMBER
	else if (contact.info.kind == TRACTOR_CONTACT_THREAT)
		colour = TRACTOR_COLOUR_THREAT
	text = uppertext(text)
	return tractor_rig_maptext(contact.speed > 0 ? "[text] &gt;" : "&lt; [text]", colour, FALSE)


/// Makes a contact's screen object and starts it drifting.
/datum/tractor_rig_session/proc/add_contact_object(datum/tractor_field_contact/contact)
	var/obj/screen/tractor_rig/object = new
	object.layer = 3
	object.screen_loc = "[TRACTOR_MAP]:1,1"
	var/image/sprite = image('icons/effects/tractor_rig.dmi', is_hidden(contact) ? "unknown" : contact.info.icon_state)
	var/flip = contact.info.faces_left && contact.speed > 0
	var/matrix/M = matrix()
	M.Scale(contact.info.scale * (flip ? -1 : 1), contact.info.scale)
	sprite.transform = M
	// Identified veins show their mineral's colour; unidentified rock all looks the same.
	if (contact.info.tint && !is_hidden(contact) && !is_vague(contact))
		sprite.color = contact.info.tint
	object.AddOverlays(sprite)
	object.maptext = contact_label(contact)
	object.maptext_width = 220
	object.maptext_height = 12
	object.maptext_x = 16 + contact.info.hit_width() / 2 + 3
	object.maptext_y = 10
	contact_objects[contact] = object
	user.client?.screen += object
	animate_drift(contact, object)


/**
 * Loops a contact's drift on the client. One loop goes from where it is now to
 * the far edge, jumps to the near edge, and comes back to where it started, so it
 * matches `x_at()` with no server ticks.
 */
/datum/tractor_rig_session/proc/animate_drift(datum/tractor_field_contact/contact, obj/screen/tractor_rig/object)
	var/half = contact.info.hit_width() / 2
	var/speed = abs(contact.speed)
	var/x_now = contact.x_at(world.time)
	var/left_edge = -half
	var/right_edge = TRACTOR_FIELD_WIDTH + half
	var/y = TRACTOR_HULL_Y - contact.depth_px - 16
	object.transform = tractor_rig_at(x_now - 16, y)
	if (contact.speed >= 0)
		animate(object, transform = tractor_rig_at(right_edge - 16, y), time = (right_edge - x_now) / speed, loop = -1)
		animate(transform = tractor_rig_at(left_edge - 16, y), time = 0)
		animate(transform = tractor_rig_at(x_now - 16, y), time = (x_now - left_edge) / speed)
	else
		animate(object, transform = tractor_rig_at(left_edge - 16, y), time = (x_now - left_edge) / speed, loop = -1)
		animate(transform = tractor_rig_at(right_edge - 16, y), time = 0)
		animate(transform = tractor_rig_at(x_now - 16, y), time = (right_edge - x_now) / speed)
	dress_contact(contact, object)


/// Takes a screen object off the operator's screen and deletes it.
/datum/tractor_rig_session/proc/discard_object(obj/screen/tractor_rig/object)
	if (QDELETED(object))
		return
	user?.client?.screen -= object
	claw_object?.vis_contents -= object
	qdel(object)


// Controls.

/datum/tractor_rig_session/proc/handle_action(action)
	switch (action)
		if ("left")
			move_gantry(-1)
			return
		if ("right")
			move_gantry(1)
			return
		if ("fire")
			if (state == TRACTOR_STATE_DROPPING)
				release()
			else
				try_drop()
		if ("drop")
			try_drop()
		if ("release")
			release()
		if ("rescan")
			if (state == TRACTOR_STATE_IDLE && !link_problem)
				beep('sound/effects/scanbeep.ogg', 30)
				new_field()
				update_reach_line()
				add_log("Rescanned the area.")
		if ("close")
			close()
			return
	refresh_panel()


/datum/tractor_rig_session/proc/move_gantry(direction)
	if (state != TRACTOR_STATE_IDLE && state != TRACTOR_STATE_COOLDOWN)
		return
	if (link_problem)
		return
	var/step = console.emitter?.gantry_step || 8
	var/old_x = claw_x
	claw_x = clamp(claw_x + direction * step, 16, TRACTOR_FIELD_WIDTH - 16)
	if (claw_x == old_x)
		return
	beep(pick(GLOB.keyboard_sound), 12)
	animate(emitter_object, transform = tractor_rig_at(claw_x - 16, TRACTOR_HULL_Y - 6), time = 2)
	animate(beam_object, transform = beam_matrix(0), time = 2)
	animate(claw_object, transform = claw_matrix(0), time = 2)
	if (aim_object.alpha)
		var/reach = console.emitter?.reach_px || 0
		animate(aim_object, transform = beam_matrix(reach), time = 2)


/// The claw's current depth below the hull, in pixels.
/datum/tractor_rig_session/proc/current_depth()
	switch (state)
		if (TRACTOR_STATE_DROPPING)
			return min((world.time - drop_start) * TRACTOR_DROP_SPEED, stop_depth)
		if (TRACTOR_STATE_REELING)
			var/progress = reel_time ? clamp((world.time - reel_start) / reel_time, 0, 1) : 1
			return reel_depth * (1 - progress)
	return 0


/**
 * Drops the claw. Works out every contact it will cross on the way down, and
 * when, then schedules each hit and animates the claw to where it will stop.
 */
/datum/tractor_rig_session/proc/try_drop()
	if (state == TRACTOR_STATE_COOLDOWN)
		add_log("Capacitors recharging: [round((cooldown_until - world.time) / 10, 0.1)] s.")
		beep('sound/machines/buzz-sigh.ogg', 20)
		return
	if (state != TRACTOR_STATE_IDLE)
		return
	var/problem = console.cast_problem()
	if (problem)
		add_log("Can't cast: [problem].")
		beep('sound/machines/buzz-sigh.ogg', 25)
		return
	var/obj/machinery/tractor_emitter/emitter = console.emitter
	update_reach_line()

	state = TRACTOR_STATE_DROPPING
	cast_id++
	drop_start = world.time
	stop_depth = emitter.reach_px
	drained = FALSE
	threat_struck = null
	emitter.use_power_oneoff(emitter.active_power_usage)
	emitter.set_casting(TRUE)
	console.set_alarms(TRACTOR_ALARM_WORKING)
	aim_object.alpha = 0
	claw_object.icon_state = "claw"
	set_claw_shimmer(TRUE)
	machine_sound('sound/mecha/hydraulic.ogg', 35)

	// The client's drift animations run on its own clock, which drifts from world.time when the
	// server lags. Restart them from the server's positions so what the operator sees matches.
	for (var/datum/tractor_field_contact/contact as anything in field.contacts)
		var/obj/screen/tractor_rig/object = contact_objects[contact]
		if (object)
			animate_drift(contact, object)

	// Find when the claw first touches each contact: the claw's box sweeps down at a fixed
	// speed, so check every moment the two boxes overlap vertically for horizontal overlap too.
	var/list/hits = list()
	for (var/datum/tractor_field_contact/contact as anything in field.contacts)
		var/reach_x = contact.info.hit_width() / 2 + TRACTOR_CLAW_HALF_WIDTH
		var/reach_y = contact.info.hit_height() / 2 + TRACTOR_CLAW_HALF_HEIGHT
		var/top = max(0, contact.depth_px - reach_y)
		var/bottom = min(stop_depth, contact.depth_px + reach_y)
		if (top > bottom)
			continue
		var/hit_time
		for (var/time = drop_start + top / TRACTOR_DROP_SPEED; time <= drop_start + bottom / TRACTOR_DROP_SPEED; time += TRACTOR_HIT_STEP)
			if (abs(contact.x_at(time) - claw_x) <= reach_x)
				hit_time = time
				break
		if (isnull(hit_time))
			continue
		// Keep hits in the order they happen.
		var/position = length(hits) + 1
		for (var/i = 1 to length(hits))
			var/list/other = hits[i]
			if (hit_time < other[1])
				position = i
				break
		hits.Insert(position, list(list(hit_time, contact)))

	// Play the hits in order. Each event is list(time, contact, action, victim).
	var/list/events = list()
	var/list/will_latch = list()
	var/planned_load = 0
	for (var/list/hit as anything in hits)
		var/hit_time = hit[1]
		var/datum/tractor_field_contact/contact = hit[2]
		var/hit_depth = (hit_time - drop_start) * TRACTOR_DROP_SPEED
		switch (contact.info.effect)
			if (TRACTOR_EFFECT_THREAT)
				events += list(list(hit_time, contact, "threat", null))
				stop_depth = hit_depth
				break
			if (TRACTOR_EFFECT_SNAP)
				events += list(list(hit_time, contact, "snap", null))
				stop_depth = hit_depth
				break
			if (TRACTOR_EFFECT_SHAKE)
				var/datum/tractor_field_contact/victim = length(will_latch) ? pick(will_latch) : null
				if (victim)
					will_latch -= victim
					planned_load -= victim.info.mass
				events += list(list(hit_time, contact, "shake", victim))
				continue
			if (TRACTOR_EFFECT_DRAIN)
				events += list(list(hit_time, contact, "drain", null))
				continue
		// Too big to haul: the claw anchors on it, and the drop stops there.
		if (contact.info.anchors)
			events += list(list(hit_time, contact, "fix", null))
			stop_depth = hit_depth
			break
		if (!contact.info.latches)
			continue
		if (planned_load + contact.info.mass > emitter.capacity)
			events += list(list(hit_time, contact, "full", null))
			stop_depth = hit_depth
			break
		will_latch += contact
		planned_load += contact.info.mass
		events += list(list(hit_time, contact, "latch", null))
		if (planned_load >= emitter.capacity)
			stop_depth = hit_depth
			break

	var/drop_time = stop_depth / TRACTOR_DROP_SPEED
	animate(claw_object, transform = claw_matrix(stop_depth), time = drop_time)
	animate(beam_object, transform = beam_matrix(stop_depth), time = drop_time)
	for (var/list/event as anything in events)
		addtimer(new Callback(src, PROC_REF(resolve_event), cast_id, event), max(0, event[1] - world.time))
	addtimer(new Callback(src, PROC_REF(claw_stopped), cast_id), drop_time + 1)
	add_log("Claw away at [round(claw_x / TRACTOR_PX_PER_M, 0.1)] m along the rail.")


/datum/tractor_rig_session/proc/resolve_event(id, list/event)
	if (id != cast_id || state != TRACTOR_STATE_DROPPING)
		return
	var/datum/tractor_field_contact/contact = event[2]
	var/bad = event[3] != "latch" && event[3] != "fix"
	var/hit_x = contact.x_at(world.time)
	var/hit_depth = current_depth()
	flash(hit_x, hit_depth, bad)
	var/spark_colour = TRACTOR_COLOUR_AMBER
	if (!bad)
		spark_colour = TRACTOR_COLOUR_BRIGHT
	else if (event[3] == "threat")
		spark_colour = TRACTOR_COLOUR_THREAT
	spark_burst(hit_x, hit_depth, spark_colour)
	switch (event[3])
		if ("latch")
			latch(contact)
			beep('sound/machines/sensors/contactgeneric.ogg', 35)
			console.flash_alarms(TRACTOR_ALARM_GOOD, 1.5 SECONDS)
		if ("fix")
			anchor_on(contact)
		if ("full")
			console.flash_alarms(TRACTOR_ALARM_DANGER, 1.5 SECONDS)
			add_log("Claw full: bumped off \a [contact_name(contact)].")
			beep('sound/machines/buzz-two.ogg', 25)
		if ("shake")
			console.flash_alarms(TRACTOR_ALARM_DANGER, 2 SECONDS)
			var/datum/tractor_field_contact/victim = event[4]
			machine_sound('sound/effects/clang.ogg', 30)
			screen_shake(2)
			if (victim && (victim in latched))
				add_log("<span class='bad'>\A [contact_name(contact)] knocked \the [victim.info.name] loose!</span>")
				drop_latched(victim, current_depth())
			else
				add_log("\A [contact_name(contact)] glanced off the claw.")
		if ("drain")
			console.flash_alarms(TRACTOR_ALARM_DANGER, 2 SECONDS)
			drained = TRUE
			beep('sound/effects/sparks4.ogg', 35)
			add_log("<span class='bad'>\An [contact_name(contact)] drained the capacitors: the reel will be slow.</span>")
		if ("snap")
			console.flash_alarms(TRACTOR_ALARM_DANGER, 4 SECONDS)
			machine_sound('sound/effects/snap.ogg', 45)
			screen_shake(3)
			add_log("<span class='bad'>\A [contact_name(contact)] snapped the beam! Everything on the claw is lost.</span>")
			lose_everything()
		if ("threat")
			threat_struck = contact
			console.flash_alarms(TRACTOR_ALARM_THREAT, 10 SECONDS)
			console.strike_ship(contact.info, user)
			beep('sound/machines/warning-buzzer.ogg', 40)
			machine_sound('sound/effects/meteorimpact.ogg', 50)
			screen_shake(6)
			screen_flash(TRACTOR_COLOUR_THREAT, 110)
			add_log("<span class='threat'>SHIP THREAT STRUCK: \the [contact.info.name]! Expect [contact.info.payload]. Beam snapped.</span>")
			if (console.ship_threats)
				add_log("<span class='bad'>Emergency blast shutters down. Reopen them with the button once it's clear.</span>")
			lose_everything()
	refresh_panel()


/**
 * The claw's anchored on something too big to haul. It leaves the field, and the contact
 * decides what happens (see /singleton/tractor_contact/proc/on_anchor).
 */
/datum/tractor_rig_session/proc/anchor_on(datum/tractor_field_contact/contact)
	field.contacts -= contact
	discard_object(contact_objects[contact])
	contact_objects -= contact
	var/datum/tractor_field_contact/replacement = field.add_random_contact()
	if (replacement)
		add_contact_object(replacement)
	machine_sound('sound/effects/clang.ogg', 40)
	screen_shake(2)
	contact.info.on_anchor(src, contact)


/// A bracket burst that grows and fades at (x, depth): the operator's cue that something was hit.
/datum/tractor_rig_session/proc/flash(x, depth, bad = FALSE)
	var/obj/screen/tractor_rig/burst = make_object(bad ? "hitflash_bad" : "hitflash", x - 16, TRACTOR_HULL_Y - depth - 16, 8.5)
	var/matrix/big = matrix(2, 0, x - 16, 0, 2, TRACTOR_HULL_Y - depth - 16)
	animate(burst, transform = big, alpha = 0, time = 6)
	addtimer(new Callback(src, PROC_REF(remove_effect), burst), 7)


/// Removes a short-lived effect object made with make_object().
/datum/tractor_rig_session/proc/remove_effect(obj/screen/tractor_rig/effect)
	screen_objects -= effect
	discard_object(effect)


/// Pins a contact to the claw: it stops drifting and rides with the claw from now on.
/datum/tractor_rig_session/proc/latch(datum/tractor_field_contact/contact)
	var/obj/screen/tractor_rig/object = contact_objects[contact]
	latched += contact
	load += contact.info.mass
	add_log("Hit: [contact_name(contact)] (+[contact.info.mass] mass).")
	if (!object)
		return
	animate(object)
	object.filters = null
	object.alpha = 255
	user.client?.screen -= object
	object.transform = tractor_rig_at(0, -6 - 6 * (length(latched) - 1))
	object.maptext = tractor_rig_maptext("Latched: [contact_name(contact)]", TRACTOR_COLOUR_HOT)
	object.maptext_x = 16 + contact.info.hit_width() / 2 + 3
	claw_object.vis_contents += object


/// Knocks a latched contact off the claw at `depth`: it falls away and is gone.
/datum/tractor_rig_session/proc/drop_latched(datum/tractor_field_contact/contact, depth)
	latched -= contact
	load -= contact.info.mass
	field.contacts -= contact
	var/obj/screen/tractor_rig/object = contact_objects[contact]
	contact_objects -= contact
	if (!object)
		return
	claw_object.vis_contents -= object
	object.maptext = null
	object.transform = tractor_rig_at(claw_x - 16, claw_y(depth))
	user.client?.screen += object
	animate(object, transform = tractor_rig_at(claw_x - 16, claw_y(depth) - 96), alpha = 0, time = 12)
	addtimer(new Callback(src, PROC_REF(discard_object), object), 13)


/datum/tractor_rig_session/proc/lose_everything()
	var/depth = current_depth()
	for (var/datum/tractor_field_contact/contact as anything in latched.Copy())
		drop_latched(contact, depth)
	begin_reel(depth, TRUE)


/datum/tractor_rig_session/proc/claw_stopped(id)
	if (id != cast_id || state != TRACTOR_STATE_DROPPING)
		return
	begin_reel(stop_depth)


/// Stops the claw where it is and reels in early.
/datum/tractor_rig_session/proc/release()
	if (state != TRACTOR_STATE_DROPPING)
		return
	var/depth = current_depth()
	add_log("Released at [round(depth / TRACTOR_PX_PER_M, 0.1)] m.")
	animate(claw_object, transform = claw_matrix(depth), time = 0)
	animate(beam_object, transform = beam_matrix(depth), time = 0)
	begin_reel(depth)


/// Reels the claw in from `depth`. Heavier loads reel slower.
/datum/tractor_rig_session/proc/begin_reel(depth, empty = FALSE)
	state = TRACTOR_STATE_REELING
	if (length(latched))
		claw_object.icon_state = "claw_shut"
		machine_sound('sound/mecha/mechmove03.ogg', 30)
	reel_depth = depth
	reel_start = world.time
	if (empty)
		reel_time = max(3, depth / (TRACTOR_REEL_SPEED * 3))
	else
		reel_time = max(5, depth / TRACTOR_REEL_SPEED + load * 4)
		if (drained)
			reel_time *= 1.5
	animate(claw_object, transform = claw_matrix(0), time = reel_time)
	animate(beam_object, transform = beam_matrix(0), time = reel_time)
	addtimer(new Callback(src, PROC_REF(finish_reel), cast_id), reel_time + 1)
	// Something's coming aboard: the projector locks onto the intake for the whole reel and the trip in.
	if (length(latched) && !empty)
		console.start_haul_beam(reel_time)
		show_overmap_haul(reel_time)
	else
		console.stop_haul_beam()
	refresh_panel()


/// Shows the haul on the overmap: a tractor line out to each source it's coming from.
/datum/tractor_rig_session/proc/show_overmap_haul(time)
	var/obj/overmap/ship = console.linked
	if (!ship)
		return
	var/list/done = list()
	for (var/datum/tractor_field_contact/contact as anything in latched)
		var/obj/overmap/source = contact.source_object
		if (!source || done[source] || QDELETED(source))
			continue
		done[source] = TRUE
		tractor_overmap_beam(ship, source, contact.via_probe, time + TRACTOR_ARRIVAL_TIME)


/// Takes what the claw just brought in out of the sources it came from, and tells the operator about any that ran dry.
/datum/tractor_rig_session/proc/drain_sources()
	var/list/mass_by_source = list()
	var/list/theme_by_source = list()
	for (var/datum/tractor_field_contact/contact as anything in latched)
		if (!contact.source_object)
			continue
		mass_by_source[contact.source_object] = (mass_by_source[contact.source_object] || 0) + contact.info.mass
		theme_by_source[contact.source_object] = contact.source
	var/ran_dry = FALSE
	for (var/obj/overmap/source as anything in mass_by_source)
		var/message = tractor_drain_source(source, theme_by_source[source], mass_by_source[source])
		if (message)
			add_log("<span class='amber'>[message]</span>")
			ran_dry = TRUE
	// The field changed under the claw: rescan once it's home.
	if (ran_dry)
		addtimer(new Callback(src, PROC_REF(new_field)), 1)


/**
 * The claw is home. Sends the haul to the landing bay, takes the caught contacts
 * out of the field (topping it back up with new ones), and starts the cooldown.
 */
/datum/tractor_rig_session/proc/finish_reel(id)
	if (id != cast_id || state != TRACTOR_STATE_REELING)
		return
	last_haul = list()
	var/list/names = list()
	var/list/singleton/tractor_contact/haul = list()
	for (var/datum/tractor_field_contact/contact as anything in latched)
		last_haul += "[contact.info.name]: [contact.info.payload]"
		names += contact.info.name
		haul += contact.info
		field.contacts -= contact
		discard_object(contact_objects[contact])
		contact_objects -= contact
		var/datum/tractor_field_contact/replacement = field.add_random_contact()
		if (replacement)
			add_contact_object(replacement)
	drain_sources()
	if (threat_struck)
		last_haul += "<span class='threat'>SHIP THREAT: [threat_struck.info.name], [threat_struck.info.payload]</span>"
	if (length(haul))
		console.send_haul(haul, user)
	else
		console.stop_haul_beam()
	if (!length(last_haul))
		last_haul += "Nothing came back."

	set_claw_shimmer(FALSE)
	console.emitter?.set_casting(FALSE)
	// Blue from here while the haul is on its way (send_haul set arrival_due), otherwise off.
	console.set_alarms(console.arrival_due ? TRACTOR_ALARM_INBOUND : TRACTOR_ALARM_OFF)
	if (length(names))
		add_log("Haul aboard: [english_list(names)]. Materialising in the bay in [TRACTOR_ARRIVAL_TIME / 10] s.")
		beep('sound/machines/ping.ogg', 35)
		screen_flash(TRACTOR_COLOUR_BRIGHT, 50)
		to_chat(user, SPAN_NOTICE("\The [console] reports a haul: [english_list(names)]. It lands in the bay in [TRACTOR_ARRIVAL_TIME / 10] seconds."))
	else
		add_log("The claw came back empty.")
	log_game("[key_name(user)] reeled in a tractor rig haul at [get_area(console)]: [length(names) ? english_list(names) : "nothing"][threat_struck ? ", struck [threat_struck.info.name]" : ""].")

	latched.Cut()
	load = 0
	drained = FALSE
	threat_struck = null
	state = TRACTOR_STATE_COOLDOWN
	claw_object.icon_state = "claw"
	update_aim()
	var/cooldown = max(console.emitter?.cooldown_time || 12 SECONDS, length(haul) ? TRACTOR_ARRIVAL_TIME + 1 : 0)
	cooldown_until = world.time + cooldown
	addtimer(new Callback(src, PROC_REF(end_cooldown), cast_id), cooldown)
	refresh_panel()


/// Called by the console when a haul has landed (or failed to fit).
/datum/tractor_rig_session/proc/haul_landed(list/landed, list/lost)
	if (length(landed))
		add_log("Landed in the bay: [english_list(landed)].")
		beep('sound/machines/chime.ogg', 30)
	if (length(lost))
		add_log("<span class='bad'>No room in the bay for [english_list(lost)]: lost.</span>")
		beep('sound/machines/buzz-two.ogg', 25)
	refresh_panel()


/datum/tractor_rig_session/proc/end_cooldown(id)
	if (id != cast_id || state != TRACTOR_STATE_COOLDOWN)
		return
	state = TRACTOR_STATE_IDLE
	add_log("Capacitors charged. Ready.")
	beep('sound/machines/quiet_beep.ogg', 20)
	refresh_panel()


// The side panel.

/datum/tractor_rig_session/proc/add_log(text)
	log_lines.Insert(1, text)
	if (length(log_lines) > 12)
		log_lines.Cut(13)


/datum/tractor_rig_session/proc/panel_button(action, text, enabled = TRUE, extra_class = "")
	if (!enabled)
		return "<span class='key off [extra_class]'>\[ [text] \]</span>"
	return "<a class='key [extra_class]' href='byond://?src=\ref[console];tractor_rig=[action]'>\[ [text] \]</a>"


/**
 * Redraws the side panel
 */
/datum/tractor_rig_session/proc/refresh_panel()
	if (!user?.client || QDELETED(console))
		return
	var/obj/machinery/tractor_emitter/emitter = console.emitter
	var/list/html = list()
	html += {"<style>
		html, body {margin: 0; height: 100%; overflow: hidden;}
		body {box-sizing: border-box; display: flex; flex-direction: column; padding: 8px 10px; background: [TRACTOR_COLOUR_GLASS]; color: [TRACTOR_COLOUR_BRIGHT];
			font: 10px 'Lucida Console', Consolas, monospace; text-transform: uppercase; letter-spacing: 1px;
			text-shadow: 0 0 3px rgba(93, 255, 146, 0.55);}
		body:before {content: ''; position: fixed; left: 0; top: 0; right: 0; bottom: 0; pointer-events: none;
			box-shadow: inset 0 0 40px rgba(0, 0, 0, 0.7);}
		body:after {content: ''; position: fixed; left: 0; top: 0; right: 0; bottom: 0; pointer-events: none;
			background: repeating-linear-gradient(to bottom, rgba(0, 0, 0, 0.3) 0, rgba(0, 0, 0, 0.3) 1px, transparent 1px, transparent 3px);
			animation: flicker 6s infinite;}
		@keyframes flicker {0%, 96%, 100% {opacity: 1;} 97% {opacity: 0.7;} 98% {opacity: 1;} 99% {opacity: 0.85;}}
		@keyframes blink {50% {opacity: 0;}}
		.head {display: flex; justify-content: space-between; align-items: baseline; padding-bottom: 4px; margin-bottom: 9px; border-bottom: 1px solid [TRACTOR_COLOUR_DIM];}
		.title {color: [TRACTOR_COLOUR_HOT]; font-weight: bold; letter-spacing: 2px;}
		.dim {color: [TRACTOR_COLOUR_MID];}
		.blink {animation: blink 1s steps(1) infinite;}
		.blink.fast {animation-duration: 0.5s;}
		@keyframes pulse {0%, 100% {opacity: 1;} 50% {opacity: 0.35;}}
		.pulse {color: [TRACTOR_COLOUR_BRIGHT]; animation: pulse 2s ease-in-out infinite;}
		@keyframes alarm {0%, 100% {background: rgba(255, 90, 54, 0.18);} 50% {background: rgba(255, 90, 54, 0.04);}}
		.alert {flex: none; margin-bottom: 10px; padding: 6px; border: 1px solid [TRACTOR_COLOUR_THREAT]; color: [TRACTOR_COLOUR_THREAT];
			text-shadow: 0 0 3px rgba(255, 90, 54, 0.6); line-height: 1.5; animation: alarm 1.2s ease-in-out infinite;}
		.alert .dim {color: [TRACTOR_COLOUR_AMBER]; text-shadow: none;}
		.box {position: relative; flex: none; border: 1px solid [TRACTOR_COLOUR_DIM]; padding: 8px 6px 4px; margin-bottom: 10px;}
		.box.fill {flex: 1; min-height: 0; margin-bottom: 0; display: flex; flex-direction: column;}
		.clip {flex: 1; min-height: 0; overflow: hidden;}
		.tag {position: absolute; top: -6px; left: 6px; padding: 0 4px; background: [TRACTOR_COLOUR_GLASS]; color: [TRACTOR_COLOUR_MID]; font-size: 9px;}
		.row {display: flex; justify-content: space-between; margin: 1px 0;}
		.seg {height: 4px; margin: 1px 0 3px; background: repeating-linear-gradient(to right, #0c2a17 0, #0c2a17 5px, transparent 5px, transparent 7px);}
		.seg div {height: 4px; background: repeating-linear-gradient(to right, [TRACTOR_COLOUR_BRIGHT] 0, [TRACTOR_COLOUR_BRIGHT] 5px, transparent 5px, transparent 7px);}
		.amber, .bad {color: [TRACTOR_COLOUR_AMBER]; text-shadow: 0 0 3px rgba(255, 176, 0, 0.6);}
		.threat {color: [TRACTOR_COLOUR_THREAT]; text-shadow: 0 0 3px rgba(255, 90, 54, 0.6);}
		.keys {display: flex; flex-wrap: wrap; justify-content: space-between;}
		.key {display: block; box-sizing: border-box; width: 49%; margin: 2px 0; padding: 5px 0; text-align: center;
			border: 1px solid [TRACTOR_COLOUR_MID]; color: [TRACTOR_COLOUR_BRIGHT]; text-decoration: none;}
		.key:hover {background: #0c2a17;}
		.key.wide {width: 100%;}
		.key.go {background: [TRACTOR_COLOUR_BRIGHT]; color: [TRACTOR_COLOUR_GLASS]; text-shadow: none; font-weight: bold;}
		.key.stop {background: [TRACTOR_COLOUR_AMBER]; border-color: [TRACTOR_COLOUR_AMBER]; color: [TRACTOR_COLOUR_GLASS]; text-shadow: none; font-weight: bold;}
		.key.off {border-color: #0c2a17; color: [TRACTOR_COLOUR_DIM]; text-shadow: none; background: none;}
		.hint {margin-top: 4px; font-size: 9px; color: [TRACTOR_COLOUR_DIM]; text-align: center;}
		.lines div {margin: 1px 0;}
		.cursor:after {content: '_'; animation: blink 1s steps(1) infinite;}
	</style>"}

	if (link_problem)
		html += "<div class='head'><span class='title'>SALVAGE TRACTOR</span><span class='threat'>NO LINK <span class='blink fast'>&#9632;</span></span></div>"
		html += "<div class='alert'><b>&#9888; RIG OFFLINE</b><br>[uppertext(link_problem)].<br><span class='dim'>Restore power to the projector and console.</span></div>"
	else
		html += "<div class='head'><span class='title'>SALVAGE TRACTOR</span><span class='dim'>RIG LINK <span class='pulse'>&#9632;</span></span></div>"

	html += "<div class='box'><span class='tag'>FIELD COMPOSITION</span>"
	for (var/list/row as anything in field.mix_summary())
		html += "<div class='row'><span>[row[1]]</span><span>[row[2]]%</span></div><div class='seg'><div style='width: [row[2]]%'></div></div>"
	html += "</div>"

	html += "<div class='box'><span class='tag'>CLAW TELEMETRY</span>"
	var/status
	switch (state)
		if (TRACTOR_STATE_IDLE)
			status = "READY"
		if (TRACTOR_STATE_DROPPING)
			status = "<span class='amber blink'>DESCENDING</span>"
		if (TRACTOR_STATE_REELING)
			status = "<span class='amber'>REELING IN</span>"
		if (TRACTOR_STATE_COOLDOWN)
			status = "<span class='dim'>RECHARGING [max(0, round((cooldown_until - world.time) / 10))]S</span>"
	if (link_problem)
		status = "<span class='threat blink'>OFFLINE</span>"
	html += "<div class='row'><span>Status</span><span>[status]</span></div>"
	if (emitter)
		var/load_percent = emitter.capacity ? round(100 * load / emitter.capacity) : 0
		html += "<div class='row'><span>Reach</span><span>[round(emitter.reach_px / TRACTOR_PX_PER_M)] M</span></div>"
		html += "<div class='row'><span>Gantry</span><span>[emitter.gantry_step] PX/STEP</span></div>"
		html += "<div class='row'><span>Scanner</span><span>TIER [emitter.scan_tier]</span></div>"
		var/scanner_note = emitter.scan_tier >= 3 ? "MINERALS · HAZARDS · SOURCES" : emitter.scan_tier >= 2 ? "MINERALS · HAZARDS" : "UPGRADE TO IDENTIFY"
		html += "<div class='row'><span></span><span>[scanner_note]</span></div>"
		html += "<div class='row'><span>Load</span><span>[load] / [emitter.capacity]</span></div><div class='seg'><div style='width: [load_percent]%'></div></div>"
	else
		html += "<div class='threat'>NO EMITTER LINKED</div>"
	if (console.get_bay_area())
		var/clear = console.count_clear_bay_turfs()
		html += "<div class='row'><span>Bay</span><span[clear < TRACTOR_BAY_MIN_CLEAR ? " class='amber'" : ""]>[clear] TILES CLEAR</span></div>"
	else
		html += "<div class='row'><span>Bay</span><span class='threat'>NOT MAPPED</span></div>"
	if (console.arrival_due > world.time)
		html += "<div class='row'><span>Arrival</span><span class='amber blink'>[round((console.arrival_due - world.time) / 10)] S</span></div>"
	html += "</div>"

	html += "<div class='box'><span class='tag'>CONTROL</span><div class='keys'>"
	var/online = !link_problem
	var/can_aim = online && (state == TRACTOR_STATE_IDLE || state == TRACTOR_STATE_COOLDOWN)
	html += panel_button("left", "&lt; LEFT", can_aim)
	html += panel_button("right", "RIGHT &gt;", can_aim)
	if (state == TRACTOR_STATE_DROPPING)
		html += panel_button("release", "RELEASE + REEL IN", TRUE, "wide stop")
	else
		html += panel_button("drop", online ? "DROP CLAW" : "NO LINK", online && state == TRACTOR_STATE_IDLE, "wide go")
	html += panel_button("rescan", "RESCAN", online && state == TRACTOR_STATE_IDLE)
	html += panel_button("close", "CLOSE")
	html += "</div><div class='hint'>&larr; &rarr; AIM &middot; SPACE DROP/RELEASE &middot; R RESCAN</div></div>"

	html += "<div class='box lines'><span class='tag'>LAST HAUL</span>"
	if (length(last_haul))
		for (var/line in last_haul)
			html += "<div>[line]</div>"
	else
		html += "<div class='dim'>No haul yet.</div>"
	html += "</div>"

	html += "<div class='box lines fill'><span class='tag'>LOG</span><div class='clip'>"
	var/shown = 0
	for (var/line in log_lines)
		html += "<div>&gt; [line]</div>"
		if (++shown >= 6)
			break
	html += "<div class='cursor'>&gt; </div></div></div>"

	// Keyboard: forward keys to the same links the buttons use, throttled so a held key doesn't flood the server.
	html += {"<script>
		var lastSent = 0;
		function send(action) {
			var now = new Date().getTime();
			if (now - lastSent < 90) return;
			lastSent = now;
			window.location = 'byond://?src=\ref[console];tractor_rig=' + action;
		}
		document.onkeydown = function (e) {
			e = e || window.event;
			var action = null;
			switch (e.keyCode) {
				case 37: case 65: action = 'left'; break;
				case 39: case 68: action = 'right'; break;
				case 32: action = 'fire'; break;
				case 40: case 83: action = 'drop'; break;
				case 38: case 87: action = 'release'; break;
				case 82: action = 'rescan'; break;
			}
			if (!action) return true;
			if (e.preventDefault) e.preventDefault();
			send(action);
			return false;
		};
		window.focus();
	</script>"}

	show_browser(user, jointext(html, ""), "window=[TRACTOR_PANEL]")


/// Run by the popup window's close button.
/client/verb/tractor_rig_close()
	set name = "tractor-rig-close"
	set hidden = TRUE
	var/datum/tractor_rig_session/session = tractor_rig_sessions[ckey]
	if (session)
		qdel(session)
