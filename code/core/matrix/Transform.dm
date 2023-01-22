/// Clears the matrix's a-f variables to identity.
/matrix/proc/Clear()
	a = 1
	b = 0
	c = 0
	d = 0
	e = 1
	f = 0
	return src


/// Runs Scale, Turn, and Translate if supplied parameters, then multiplies by others if set.
/matrix/proc/Update(scale_x, scale_y, rotation, offset_x, offset_y, list/others)
	var/x_null = isnull(scale_x)
	var/y_null = isnull(scale_y)
	if (!x_null || !y_null)
		Scale(x_null ? 1 : scale_x, y_null ? 1 : scale_y)
	if (!isnull(rotation))
		Turn(rotation)
	if (offset_x || offset_y)
		Translate(offset_x || 0, offset_y || 0)
	if (islist(others))
		for (var/other in others)
			Multiply(other)
	else if (others)
		Multiply(others)
	return src
