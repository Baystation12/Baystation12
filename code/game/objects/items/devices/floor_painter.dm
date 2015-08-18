#define CELLS 4
#define CELLSIZE (32/CELLS)

/obj/item/device/floor_painter
	name = "floor painter"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "labeler1"
	item_state = "flight"

	var/decal =        "remove all decals"
	var/paint_dir =    "precise"
	var/paint_colour = "white"

	var/list/decals = list(
		"quarter-turf" =      list("path" = /obj/effect/floor_decal/corner, "precise" = 1, "coloured" = 1),
		"hazard stripes" =    list("path" = /obj/effect/floor_decal/industrial/warning),
		"corner, hazard" =    list("path" = /obj/effect/floor_decal/industrial/warning/corner),
		"hatched marking" =   list("path" = /obj/effect/floor_decal/industrial/hatch),
		"dotted outline" =    list("path" = /obj/effect/floor_decal/industrial/outline, "coloured" = 1),
		"loading sign" =      list("path" = /obj/effect/floor_decal/industrial/loading),
		"1" =                 list("path" = /obj/effect/floor_decal/sign),
		"2" =                 list("path" = /obj/effect/floor_decal/sign/two),
		"A" =                 list("path" = /obj/effect/floor_decal/sign/a),
		"B" =                 list("path" = /obj/effect/floor_decal/sign/b),
		"C" =                 list("path" = /obj/effect/floor_decal/sign/c),
		"D" =                 list("path" = /obj/effect/floor_decal/sign/d),
		"Ex" =                list("path" = /obj/effect/floor_decal/sign/ex),
		"M" =                 list("path" = /obj/effect/floor_decal/sign/m),
		"CMO" =               list("path" = /obj/effect/floor_decal/sign/cmo),
		"V" =                 list("path" = /obj/effect/floor_decal/sign/v),
		"Psy" =               list("path" = /obj/effect/floor_decal/sign/p),
		"remove all decals" = list("path" = /obj/effect/floor_decal/reset)
		)
	var/list/paint_dirs = list(
		"north" =       NORTH,
		"northwest" =   NORTHWEST,
		"west" =        WEST,
		"southwest" =   SOUTHWEST,
		"south" =       SOUTH,
		"southeast" =   SOUTHEAST,
		"east" =        EAST,
		"northeast" =   NORTHEAST,
		"precise" = 0
		)
	var/list/paint_colours = list(
		"white" =            COLOR_WHITE,
		"light gray" =       COLOR_SILVER,
		"dark gray" =        COLOR_GRAY,
		"blue-grey" =        "#6A97B0",
		"pale blue-grey" =   "#8BBBD5",
		"green-grey" =       "#8DAF6A",
		"pale green-gray" =  "#AED18B",
		"red-gray" =         "#AA5F61",
		"pale red-gray" =    "#CC9090",
		"purple-gray" =      "#A2819E",
		"pale purple-gray" = "#BDA2BA",
		"black" =             COLOR_BLACK,
		"red" =               COLOR_RED,
		"dark red" =          COLOR_MAROON,
		"yellow" =            COLOR_YELLOW,
		"dark yellow" =       COLOR_OLIVE,
		"green" =             COLOR_LIME,
		"dark green" =        COLOR_GREEN,
		"cyan" =              COLOR_CYAN,
		"teal" =              COLOR_TEAL,
		"blue" =              COLOR_BLUE,
		"dark blue" =         COLOR_NAVY,
		"magenta" =           COLOR_PINK,
		"purple" =            COLOR_PURPLE,
		"orange" =            COLOR_ORANGE,
		"dark orange" =       "#B95A00",
		"dark brown" =        "#917448",
		"brown" =             "#B19664",
		"pale brown" =        "#CEB689"
		)

/obj/item/device/floor_painter/afterattack(var/atom/A, var/mob/user, proximity, params)
	if(!proximity)
		return

	var/turf/simulated/floor/F = A
	if(!istype(F))
		user << "<span class='warning'>\The [src] can only be used on station flooring.</span>"
		return

	if(!F.flooring || !F.flooring.can_paint || F.broken || F.burnt)
		user << "<span class='warning'>\The [src] cannot paint broken or missing tiles.</span>"
		return

	var/list/decal_data = decals[decal]
	var/config_error
	if(!islist(decal_data))
		config_error = 1
	var/painting_decal
	if(!config_error)
		painting_decal = decal_data["path"]
		if(!ispath(painting_decal))
			config_error = 1

	if(config_error)
		user << "<span class='warning'>\The [src] flashes an error light. You might need to reconfigure it.</span>"
		return

	if(F.decals && F.decals.len > 5 && painting_decal != /obj/effect/floor_decal/reset)
		user << "<span class='warning'>\The [F] has been painted too much; you need to clear it off.</span>"
		return

	var/painting_dir = 0
	if(paint_dir == "precise")
		if(!decal_data["precise"])
			painting_dir = user.dir
		else
			var/list/mouse_control = params2list(params)
			var/mouse_x = text2num(mouse_control["icon-x"])
			var/mouse_y = text2num(mouse_control["icon-y"])
			if(isnum(mouse_x) && isnum(mouse_y))
				if(mouse_x <= 16)
					if(mouse_y <= 16)
						painting_dir = WEST
					else
						painting_dir = NORTH
				else
					if(mouse_y <= 16)
						painting_dir = SOUTH
					else
						painting_dir = EAST
			else
				painting_dir = user.dir
	else if(paint_dirs[paint_dir])
		painting_dir = paint_dirs[paint_dir]

	var/painting_colour
	if(paint_colour && !isnull(paint_colours[paint_colour]) && decal_data["coloured"])
		painting_colour = paint_colours[paint_colour]

	new painting_decal(F, painting_dir, painting_colour)

/obj/item/device/floor_painter/attack_self(mob/user as mob)

	var/choice = input("Do you wish to change the decal type, paint direction, or paint colour?") as null|anything in list("Decal","Direction", "Colour")

	if(choice == "Decal")
		var/new_decal = input("Select a decal.") as null|anything in decals
		if(new_decal && !isnull(decals[new_decal]))
			decal = new_decal
			user << "<span class='notice'>You set \the [src] decal to '[decal]'.</span>"
	else if(choice == "Direction")
		var/new_dir = input("Select a direction.") as null|anything in paint_dirs
		if(new_dir && !isnull(paint_dirs[new_dir]))
			paint_dir = new_dir
			user << "<span class='notice'>You set \the [src] direction to '[paint_dir]'.</span>"
	else if(choice == "Colour")
		var/new_colour = input("Select a colour.") as null|anything in paint_colours
		if(new_colour && !isnull(paint_colours[new_colour]))
			paint_colour = new_colour
			user << "<span class='notice'>You set \the [src] colour to '[paint_colour]'.</span>"

/obj/item/device/floor_painter/examine(mob/user)
	..(user)
	user << "It is configured to produce the '[decal]' decal with a direction of '[paint_dir]' using [paint_colour] paint."

/obj/item/device/floor_painter/verb/choose_colour(new_colour in paint_colours)
	set name = "Choose Colour"
	set desc = "Choose a floor painter colour."
	set category = "Object"
	set src in usr

	if(usr.incapacitated())
		return

	if(new_colour && !isnull(paint_colours[new_colour]))
		paint_colour = new_colour
		usr << "<span class='notice'>You set \the [src] colour to '[paint_colour]'.</span>"

/obj/item/device/floor_painter/verb/choose_decal(new_decal in decals)
	set name = "Choose Decal"
	set desc = "Choose a floor painter decal."
	set category = "Object"
	set src in usr

	if(usr.incapacitated())
		return

	if(new_decal && !isnull(decals[new_decal]))
		decal = new_decal
		usr << "<span class='notice'>You set \the [src] decal to '[decal]'.</span>"

/obj/item/device/floor_painter/verb/choose_direction(new_dir in paint_dirs)
	set name = "Choose Direction"
	set desc = "Choose a floor painter direction."
	set category = "Object"
	set src in usr

	if(usr.incapacitated())
		return

	if(new_dir && !isnull(paint_dirs[new_dir]))
		paint_dir = new_dir
		usr << "<span class='notice'>You set \the [src] direction to '[paint_dir]'.</span>"

#undef CELLS
#undef CELLSIZE
