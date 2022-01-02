decl/color_generator
	var/color = COLOR_WHITE
	var/min_random_span = -25
	var/max_random_span = 25

/decl/color_generator/proc/GenerateHex()
	. = GenerateRGB()
	. = rgb(.[1], .[2], .[3])

/decl/color_generator/proc/GenerateRGB()
	. = create_color()
	for(var/i in 1 to 3)
		.[i] += rand(min_random_span, max_random_span)
		.[i] = clamp(.[i], 0, 255)

/decl/color_generator/proc/create_color()
	return GetHexColors(color)

/decl/color_generator/albino_eye/create_color()
	return list(rand(200, 255), rand(0, 150), rand(0, 150))

/decl/color_generator/black
	color = COLOR_BLACK

/decl/color_generator/blue
	color = COLOR_CYAN_BLUE

/decl/color_generator/blue_light
	color = COLOR_LIGHT_CYAN

/decl/color_generator/blonde
	color = COLOR_YELLOW

/decl/color_generator/brown
	color = COLOR_BEASTY_BROWN

/decl/color_generator/chestnut
	color = COLOR_CHESTNUT

/decl/color_generator/copper
	color = COLOR_ORANGE

/decl/color_generator/green
	color = COLOR_PAKISTAN_GREEN

/decl/color_generator/grey/create_color()
	. = rand(100, 200)
	return list(., ., .)

/decl/color_generator/old/create_color()
	. = rand(100, 255)
	return list(., ., .)

/decl/color_generator/punk/create_color()
	return list(rand(0, 255), rand(0, 255), rand(0, 255))

/decl/color_generator/wheat
	color = COLOR_WHEAT

/decl/color_generator/white
	color = COLOR_WHITE
