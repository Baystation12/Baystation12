/// The image's base transform scale for width.
/image/var/tf_scale_x

/// The image's base transform scale for height.
/image/var/tf_scale_y

/// The image's base transform scale for rotation.
/image/var/tf_rotation

/// The image's base transform scale for horizontal offset.
/image/var/tf_offset_x

/// The image's base transform scale for vertical offset.
/image/var/tf_offset_y


/// Clear the image's tf_* variables and the current transform state.
/image/proc/ClearTransform()
	tf_scale_x = null
	tf_scale_y = null
	tf_rotation = null
	tf_offset_x = null
	tf_offset_y = null
	transform = null


/// Sets the image's tf_* variables and the current transform state, also applying others if supplied.
/image/proc/SetTransform(
	scale,
	scale_x = tf_scale_x,
	scale_y = tf_scale_y,
	rotation = tf_rotation,
	offset_x = tf_offset_x,
	offset_y = tf_offset_y,
	list/others
)
	if (!isnull(scale))
		tf_scale_x = scale
		tf_scale_y = scale
	else
		tf_scale_x = scale_x
		tf_scale_y = scale_y
	tf_rotation = rotation
	tf_offset_x = offset_x
	tf_offset_y = offset_y
	transform = matrix().Update(
		scale_x = tf_scale_x,
		scale_y = tf_scale_y,
		rotation = tf_rotation,
		offset_x = tf_offset_x,
		offset_y = tf_offset_y,
		others = others
	)
