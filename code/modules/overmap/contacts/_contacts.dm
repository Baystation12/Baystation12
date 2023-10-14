#define SENSOR_TIME_DELAY 0.2 SECONDS
/datum/overmap_contact

	/// Contact name
	var/name  = "Unknown"
	/// Used to animate overmap effects
	var/pinged = FALSE

	/// Our list of images to cast to users
	var/list/images = list()

	/// Image overlay attached to the contact
	var/image/marker
	/// Radar image for sonar esque effect
	var/image/radar

	/// The sensor console holding this data
	var/obj/machinery/shipsensors/owner

	/// The actual overmap effect associated with this
	var/obj/overmap/effect

/datum/overmap_contact/New(obj/machinery/computer/ship/sensors/creator, obj/overmap/source)
	// Update local tracking information
	owner =  creator
	effect = source
	name =   effect.name
	owner.contact_datums[effect] = src

	marker = new(loc = effect)
	marker.appearance = effect
	marker.alpha = 0 // Marker fades in on detection

	// Needs to be reset to be accurate in position and directions
	marker.pixel_x = 0
	marker.pixel_y = 0
	marker.transform = null

	images += marker

	radar = image(loc = effect.loc, icon = 'icons/obj/overmap.dmi', icon_state = "sensor_range", pixel_x = effect.pixel_x, pixel_y = effect.pixel_y)
	radar.tag = "radar"
	radar.filters = filter(type="blur", size = 1)
	radar.mouse_opacity = MOUSE_OPACITY_UNCLICKABLE


/datum/overmap_contact/proc/update_marker_icon(range = 0)
	marker.icon_state = effect.icon_state

	marker.ClearOverlays()

	if (check_effect_shield())
		var/image/shield_image = image(icon = 'icons/obj/overmap.dmi', icon_state = "shield")
		shield_image.pixel_x = 8
		marker.AddOverlays(shield_image)

	if (range > 0)
		radar.transform = null
		radar.alpha = 255
		radar.loc = effect.loc
		radar.pixel_x = effect.pixel_x
		radar.pixel_y = effect.pixel_y

		images |= radar

		var/matrix/M = matrix()
		M.Scale(range*2.6)
		animate(radar, transform = M, alpha = 0, time = (SENSOR_TIME_DELAY*range), 1, SINE_EASING)
		addtimer(new Callback(src, .proc/reset_radar, radar), (0.25 SECONDS *range+0.1))

/datum/overmap_contact/proc/reset_radar(image/radar)
	images -= radar

/datum/overmap_contact/proc/show()
	if (!owner)
		return
	var/list/showing = owner.linked?.navigation_viewers
	if (length(showing))
		for(var/weakref/W in showing)
			var/mob/M = W.resolve()
			if (istype(M) && M.client)
				M.client.images |= images

/datum/overmap_contact/proc/check_effect_shield()
	var/obj/overmap/visitable/visitable_effect = effect
	if (!visitable_effect || !istype(visitable_effect))
		return FALSE
	for (var/obj/machinery/power/shield_generator/S in SSmachines.machinery)
		if (S.z in visitable_effect.map_z)
			if (S.running == SHIELD_RUNNING)
				return TRUE
	return FALSE

/datum/overmap_contact/proc/ping()
	if (pinged)
		return
	pinged = TRUE
	show()
	animate(marker, alpha=255, 0.5 SECOND, 1, LINEAR_EASING)
	addtimer(new Callback(src, .proc/unping), 1 SECOND)

/datum/overmap_contact/proc/unping()
	animate(marker, alpha=75, 2 SECOND, 1, LINEAR_EASING)
	pinged = FALSE

/datum/overmap_contact/Destroy()
	if (owner)
		var/list/showing = owner.linked?.navigation_viewers
		if (length(showing))
			for (var/weakref/W in showing)
				var/mob/M = W.resolve()
				if (istype(M) && M.client)
					M.client.images -= images
		if (effect)
			owner.contact_datums -= effect
		owner = null
	effect = null
	QDEL_NULL_LIST(images)
	. = ..()
