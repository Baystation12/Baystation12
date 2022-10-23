/singleton/color_generator
	var/color = COLOR_WHITE
	var/min_random_span = -25
	var/max_random_span = 25

/singleton/color_generator/proc/GenerateHex()
	. = GenerateRGB()
	. = rgb(.[1], .[2], .[3])

/singleton/color_generator/proc/GenerateRGB()
	. = create_color()
	for(var/i in 1 to 3)
		.[i] += rand(min_random_span, max_random_span)
		.[i] = clamp(.[i], 0, 255)

/singleton/color_generator/proc/create_color()
	return GetHexColors(color)

/singleton/color_generator/albino_eye/create_color()
	return list(rand(200, 255), rand(0, 150), rand(0, 150))

/singleton/color_generator/black
	color = COLOR_BLACK

/singleton/color_generator/blue
	color = COLOR_CYAN_BLUE

/singleton/color_generator/blue_light
	color = COLOR_LIGHT_CYAN

/singleton/color_generator/blonde
	color = COLOR_YELLOW

/singleton/color_generator/brown
	color = COLOR_BEASTY_BROWN

/singleton/color_generator/chestnut
	color = COLOR_CHESTNUT

/singleton/color_generator/copper
	color = COLOR_ORANGE

/singleton/color_generator/green
	color = COLOR_PAKISTAN_GREEN

/singleton/color_generator/grey/create_color()
	. = rand(100, 200)
	return list(., ., .)

/singleton/color_generator/old/create_color()
	. = rand(100, 255)
	return list(., ., .)

/singleton/color_generator/punk/create_color()
	return list(rand(0, 255), rand(0, 255), rand(0, 255))

/singleton/color_generator/wheat
	color = COLOR_WHEAT

/singleton/color_generator/white
	color = COLOR_WHITE
