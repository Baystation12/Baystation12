//----------------------------------------
//
//   Return a copy of the provided icon,
//  after calling MapColors on it. The
//  colour values are linearily interpolated
//  between the pairs provided, based on
//  the ratio argument.
//
//----------------------------------------

/proc/MapColors_interpolate(icon/input, ratio,
							rr1, rg1, rb1, ra1, rr2, rg2, rb2, ra2,
							gr1, gg1, gb1, ga1, gr2, gg2, gb2, ga2,
							br1, bg1, bb1, ba1, br2, bg2, bb2, ba2,
							ar1, ag1, ab1, aa1, ar2, ag2, ab2, aa2,
							zr1, zg1, zb1, za1, zr2, zg2, zb2, za2)
	var/r = ratio
	var/i = 1 - ratio
	var/icon/I = icon(input)

	I.MapColors(
		(rr1 * r + rr2 * i) / 255.0, (rg1 * r + rg2 * i) / 255.0, (rb1 * r + rb2 * i) / 255.0, (ra1 * r + ra2 * i) / 255.0,
		(gr1 * r + gr2 * i) / 255.0, (gg1 * r + gg2 * i) / 255.0, (gb1 * r + gb2 * i) / 255.0, (ga1 * r + ga2 * i) / 255.0,
		(br1 * r + br2 * i) / 255.0, (bg1 * r + bg2 * i) / 255.0, (bb1 * r + bb2 * i) / 255.0, (ba1 * r + ba2 * i) / 255.0,
		(ar1 * r + ar2 * i) / 255.0, (ag1 * r + ag2 * i) / 255.0, (ab1 * r + ab2 * i) / 255.0, (aa1 * r + aa2 * i) / 255.0,
		(zr1 * r + zr2 * i) / 255.0, (zg1 * r + zg2 * i) / 255.0, (zb1 * r + zb2 * i) / 255.0, (za1 * r + za2 * i) / 255.0)

	return I




//----------------------------------------
//
//   Extension of the above that takes a
//  list of lists of colour values, rather
//  than a large number of arguments.
//
//----------------------------------------

/proc/MapColors_interpolate_list(icon/I, ratio, list/colours)
	var/list/c[10]

	//Provide default values for any missing colours (without altering the original list
	for(var/i = 1, i <= 10, i++)
		c[i] = list(0, 0, 0, (i == 7 || i == 8)? 255 : 0)

		if(istype(colours[i], /list))
			for(var/j = 1, j <= 4, j++)
				if(j <= length(colours[i]) && isnum(colours[i][j]))
					c[i][j] = colours[i][j]

	return MapColors_interpolate(I, ratio,
		 colours[ 1][1], colours[ 1][2], colours[ 1][3], colours[ 1][4], // Red 1
		 colours[ 2][1], colours[ 2][2], colours[ 2][3], colours[ 2][4], // Red 2
		 colours[ 3][1], colours[ 3][2], colours[ 3][3], colours[ 3][4], // Green 1
		 colours[ 4][1], colours[ 4][2], colours[ 4][3], colours[ 4][4], // Green 2
		 colours[ 5][1], colours[ 5][2], colours[ 5][3], colours[ 5][4], // Blue 1
		 colours[ 6][1], colours[ 6][2], colours[ 6][3], colours[ 6][4], // Blue 2
		 colours[ 7][1], colours[ 7][2], colours[ 7][3], colours[ 7][4], // Alpha 1
		 colours[ 8][1], colours[ 8][2], colours[ 8][3], colours[ 8][4], // Alpha 2
		 colours[ 9][1], colours[ 9][2], colours[ 9][3], colours[ 9][4], // Added 1
		 colours[10][1], colours[10][2], colours[10][3], colours[10][4]) // Added 2





//----------------------------------------
//
//   Take the source image, and return an animated
//  version, that transitions between the provided
//  colour mappings, according to the provided
//  pattern.
//
//   Colors should be in a format suitable for
//  MapColors_interpolate_list, and frames should
//  be a list of 'frames', where each frame is itself
//  a list, element 1 being the ratio of the first
//  colour to the second, and element 2 being how
//  long the frame lasts, in tenths of a second.
//
//----------------------------------------

/proc/generate_colour_animation(icon/icon, list/colours, list/frames)
	var/icon/out = icon('icons/effects/uristrunes.dmi', "")
	var/frame_num = 1

	for(var/frame in frames)
		var/icon/I = MapColors_interpolate_list(icon, frame[1], colours)
		out.Insert(I, "", 2, frame_num++, 0, frame[2])

	return out



