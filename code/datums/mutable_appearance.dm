// Mutable appearances are an inbuilt byond datastructure. Read the documentation on them by hitting F1 in DM.
// Basically use them instead of images for overlays/underlays and when changing an object's appearance if you're doing so with any regularity.
// Unless you need the overlay/underlay to have a different direction than the base object. Then you have to use an image due to a bug.

// Mutable appearances are children of images, just so you know.

// Helper similar to image()
/proc/mutable_appearance(icon, icon_state, color, flags = RESET_COLOR | RESET_ALPHA, plane = FLOAT_PLANE, layer = FLOAT_LAYER)
	var/mutable_appearance/MA = new()
	MA.icon = icon
	MA.icon_state = icon_state
	MA.color = color
	MA.appearance_flags = flags
	MA.plane = plane
	MA.layer = layer
	return MA
