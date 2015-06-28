/obj/item/device/floor_painter
	name = "floor painter"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "labeler1"
	item_state = "flight"

	var/mode_nice = "standard"
	var/mode = "floor"
	var/tile_dir_mode = 0

	// mode 0  ignore direction; sets dir=0
	// mode 1  all-direction
	// mode 2  corner selecting the side CW from the selected corner
	// mode 3  cardinal
	// mode 4  warningcorner and warnwhitecorner direction fix
	// mode 5  Opposite corner tiles where the second icon_state is "[mode]_inv"
/obj/item/device/floor_painter/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity)
		return

	if(istype(A, /turf/simulated/floor))
		var/turf/simulated/floor/F = A

		if(F.is_steel_floor()) // only tiled floors
			if(tile_dir_mode)
				var/D = get_dir(usr, F)
				if(usr.loc == F)
					D = usr.dir

				switch(tile_dir_mode)
					if(1) // All directions accepted
						F.set_dir(D)
						F.icon_state = mode
					if(2) // Corner mode - diagonal directions converted CW around.
						switch(D)
							if(NORTHEAST)
								D = EAST
							if(SOUTHEAST)
								D = SOUTH
							if(SOUTHWEST)
								D = WEST
							if(NORTHWEST)
								D = NORTH
						F.set_dir(D)
						F.icon_state = mode
					if(3) // cardinal directions only. I've adjusted diagonals the same way the facing code does.
						switch(D)
							if(NORTHEAST)
								D = EAST
							if(SOUTHEAST)
								D = EAST
							if(SOUTHWEST)
								D = WEST
							if(NORTHWEST)
								D = WEST
						F.set_dir(D)
						F.icon_state = mode
					if(4) // floors.dmi icon_states "warningcorner" and "warnwhitecorner" are incorrect, this fixes it
						var/D2
						switch(D)
							if(NORTHEAST)
								D2 = WEST
							if(SOUTHEAST)
								D2 = SOUTH
							if(SOUTHWEST)
								D2 = NORTH
							if(NORTHWEST)
								D2 = EAST
						F.set_dir(D2)
						F.icon_state = mode
					if(5)
						F.set_dir(0)
						if(D == NORTH || D == SOUTH || D == NORTHEAST || D == SOUTHWEST)
							F.icon_state = mode
						else
							F.icon_state = "[mode]_inv"
			else
				F.set_dir(0)
				F.icon_state = mode
		else
			usr << "You can't paint that!"

/obj/item/device/floor_painter/attack_self(mob/user as mob)
	var/type = input("What type of floor?", "Floor painter", "solid") in list("solid", "corner", "opposite corners", "side/three corners", "special", "letters")

	tile_dir_mode = 0

	switch(type)
		if("solid")
			tile_dir_mode = 0
			var/design = input("Which color?", "Floor painter") in list("standard", "dark", "red", "blue", "green", "yellow", "purple", "neutral", "white", "white-red", "white-blue", "white-green", "white-yellow", "white-purple", "freezer", "hydro", "showroom")
			if(design == "standard")
				mode = "floor"
				mode_nice = "standard"
				return
			if(design == "white")
				mode = "white"
				mode_nice = "white"
				return
			if(design == "dark")
				mode = "dark"
				mode_nice = "dark"
				return
			if(design == "showroom" || design == "hydro" || design == "freezer")
				mode = "[design]floor"
				mode_nice = design
				return
			mode_nice = design
			mode = "[replacetext(design, "-", "")]full"
		if("corner")
			var/design = input("Which design?", "Floor painter") in list("black", "red", "blue", "green", "yellow", "purple", "neutral", "white", "white-red", "white-blue", "white-green", "white-yellow", "white-purple")
			mode_nice = "[design] corner"
			mode = "[replacetext(design, "-", "")]corner"
			tile_dir_mode = 2
		if("opposite corners")
			var/design = input("Which design?", "Floor painter") in list("bar", "cmo", "yellowpatch", "cafeteria", "red-yellow", "red-blue", "red-green", "green-yellow", "green-blue", "blue-yellow")
			mode_nice = design
			if(design == "bar" || design == "cmo" || design == "yellowpatch" || design == "cafeteria")
				mode = design
			else
				mode = "[replacetext(design, "-", "")]full"
			if(design == "yellowpatch")
				tile_dir_mode = 5
			else
				tile_dir_mode = 0
		if("side/three corners")
			var/design = input("Which design?", "Floor painter") in list("black", "red", "blue", "green", "yellow", "purple", "neutral", "white", "white-red", "white-blue", "white-green", "white-yellow", "white-purple", "red-yellow", "red-blue", "blue-red", "red-green", "green-yellow", "green-blue", "blue-yellow")
			if(design == "white")
				mode = "whitehall"
				mode_nice = "white side"
			else if(design == "black") // because SOMEONE made the black/grey side/corner sprite have the same name as the 'empty space' sprite :(
				mode = "blackfloor"
				mode_nice = design
			else
				mode_nice = design
				mode = replacetext(design, "-", "")
			tile_dir_mode = 1
		if("special")
			var/design = input("Which design?", "Floor painter") in list("arrival", "escape", "caution", "warning", "white-warning", "white-blue-green", "loadingarea", "delivery", "bot", "white-delivery", "white-bot")
			if(design == "white-blue-green")
				mode_nice = design
				mode = "whitebluegreencorners"
				tile_dir_mode = 2
			else if(design == "delivery" || design == "bot" || design == "white-delivery" || design == "white-bot")
				mode_nice = design
				mode = replacetext(design, "-", "")
				tile_dir_mode = 0
			else if(design == "loadingarea")
				mode_nice = design
				mode = design
				tile_dir_mode = 3
			else
				if(design == "white-warning")
					mode_nice = design
					design = "warnwhite"
				var/s_corner = alert("Do you want to paint a single corner of the tile?", "Floor painter","Yes","No") == "Yes"
				if(s_corner)
					mode_nice = "[design] corner"
					mode = "[design]corner"
					if(design == "warning" || design == "white-warning") // sprites for these are weird, need to fix dirs (icons/turf/floors.dmi, "warningcorner" and "warnwhitecorner")
						tile_dir_mode = 4
					else
						tile_dir_mode = 2
				else
					mode_nice = design
					mode = design
					tile_dir_mode = 1
		if("letters")
			var/which = input("Which letters/design?", "Floor painter") in list("A1", "A2", "DI", "SA", "SA (red)", "SB", "SB (red)", "SC", "SC (red)", "W (red)", "V (green)", "Psy", "Ex", "Ex (blue)", "CMO", "O (OP)", "P (OP)")
			mode_nice = which
			switch(which)
				if("A1")
					mode = "white_1"
				if("A2")
					mode = "white_2"
				if("DI")
					mode = "white_d"
				if("SA")
					mode = "white_a"
				if("SA (red)")
					mode = "whitered_a"
					tile_dir_mode = 3
				if("SB")
					mode = "white_b"
				if("SB (red)")
					mode = "whitered_b"
					tile_dir_mode = 3
				if("SC")
					mode = "white_c"
				if("SC (red)")
					mode = "whitered_c"
					tile_dir_mode = 3
				if("W (red)")
					mode = "whitered_w"
					tile_dir_mode = 3
				if("V (green)")
					mode = "whitegreen_v"
					tile_dir_mode = 3
				if("Psy")
					mode = "white_p"
				if("Ex")
					mode = "white_ex"
				if("Ex (blue)")
					mode = "whiteblue_ex"
					tile_dir_mode = 3
				if("CMO") // yes this is also in "opposite corners" choices, but it's a different icon_state  (!!)
					mode = "white_cmo"
				if("O (OP)")
					mode = "white_halfo"
				if("P (OP)")
					mode = "white_halfp"

/obj/item/device/floor_painter/examine(mob/user)
	..(user)
	user << "It is in [mode_nice] mode."
