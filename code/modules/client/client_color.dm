/datum/client_color
	/// Any value valid for client.color
	var/client_color

	/// The order in which client colors are applied. Higher numbers are applied later.
	var/order

	/// If set, stops applying client colors once this one is reached. Order still applies.
	var/override

	/// Whether this client color should affect the color of blood.
	var/ignore_blood


/// The set of /datum/client_color currently applied to the mob, if any.
/mob/var/list/client_colors


/// Checks whether the mob has an instance of color_type in its client_colors list.
/mob/proc/has_client_color(datum/client_color/color_type)
	if (!length(client_colors))
		return FALSE
	if (!ispath(color_type, /datum/client_color))
		return FALSE
	for (var/datum/client_color/entry as anything in client_colors)
		if (entry.type == color_type)
			return TRUE
	return FALSE


/// Adds an instance of color_type to the mob's client_colors list if one doesn't already exist.
/mob/proc/add_client_color(datum/client_color/color_type)
	if (has_client_color(color_type))
		return
	if (!length(client_colors))
		client_colors = list()
	client_colors |= new color_type
	sortTim(client_colors, /proc/cmp_clientcolor_order)
	update_client_color()


/// The comparison function for sorting client_colors by order.
/proc/cmp_clientcolor_order(datum/client_color/a, datum/client_color/b)
	return a.order - b.order


/// Removes an instance of color_type from the mob's client_colors list, returning TRUE if one existed.
/mob/proc/remove_client_color(datum/client_color/color_type)
	if (!length(client_colors))
		return
	for (var/datum/client_color/entry as anything in client_colors)
		if (entry.type == color_type)
			client_colors -= entry
			qdel(entry)
			update_client_color()
			if (!length(client_colors))
				client_colors = null
			break


/// Clears the mobs client_colors list.
/mob/proc/clear_client_colors()
	if (!length(client_colors))
		return
	client_colors = null
	update_client_color()


/// Resets the mob's client.color to null and then applies the client_colors list.
/mob/proc/update_client_color()
	if (!client)
		return
	client.color = null
	var/list/color = list(
		1, 0, 0,
		0, 1, 0,
		0, 0, 1
	)
	var/scene_group = GetRenderer(/atom/movable/renderer/scene_group)
	if (!length(client_colors))
		animate(scene_group, color = initial(color))
		animate(client, color = initial(color))
		return
	var/datum/client_color/top_color
	for (var/datum/client_color/entry as anything in client_colors)
		top_color = entry
		var/list/copy = color.Copy()
		for (var/m = 1 to 3)
			for (var/i = 1 to 3)
				var/value = 0
				for (var/j = 1 to 3)
					value += copy[(j - 1) * 3 + i] * entry.client_color[(m - 1) * 3 + j]
				color[(m - 1) * 3 + i] = value
		if (entry.override)
			break
	if (!top_color.ignore_blood)
		animate(scene_group, color = color)
		animate(client, color = list(
			1, 0, 0,
			0, 1, 0,
			0, 0, 1
		))
	else
		animate(client, color = color)
		animate(scene_group, color = list(
			1, 0, 0,
			0, 1, 0,
			0, 0, 1
		))


/datum/client_color/deuteranopia
	client_color = list(
		0.47, 0.38, 0.15,
		0.54, 0.31, 0.15,
		0, 0.3, 0.7
	)
	order = 100


/datum/client_color/protanopia
	client_color = list(
		0.51, 0.4, 0.12,
		0.49, 0.41, 0.12,
		0, 0.2, 0.76
	)
	order = 100


/datum/client_color/tritanopia
	client_color = list(
		0.95, 0.07, 0,
		0, 0.44, 0.52,
		0.05, 0.49, 0.48
	)
	order = 100


/datum/client_color/monochrome
	client_color = list(
		0.33, 0.33, 0.33,
		0.33, 0.33, 0.33,
		0.33, 0.33, 0.33
	)
	order = 199


/datum/client_color/nvg
	client_color = list(
		0.2, 0.2, 0.2,
		0.2, 0.5, 0.5,
		0.2, 0.3, 0.5
	)
	order = 199


/datum/client_color/noir
	client_color = list(
		0.299, 0.299, 0.299,
		0.587, 0.587, 0.587,
		0.114, 0.114, 0.114
	)
	order = 200
	ignore_blood = TRUE


/datum/client_color/thirdeye
	client_color = list(
		0.1, 0.1, 0.1,
		0.3, 0.3, 0.3,
		0.3, 0.3, 0.7
	)
	order = 300
	ignore_blood = TRUE


/datum/client_color/berserk
	client_color = "#af111c"
	order = INFINITY
	override = TRUE
	ignore_blood = TRUE
