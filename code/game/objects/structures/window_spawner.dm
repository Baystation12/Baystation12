// Ported from Haine and WrongEnd with much gratitude!
/* ._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._. */
/*-=-=-=-=-=-=-=-=-=-=-=-=-=WHAT-EVER=-=-=-=-=-=-=-=-=-=-=-=-=-*/
/* '~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~' */

/obj/wingrille_spawn
	name = "window grille spawner"
	icon = 'icons/obj/structures.dmi'
	icon_state = "wingrille"
	density = 1
	anchored = 1.0
	invisibility = 101
	pressure_resistance = 4*ONE_ATMOSPHERE
	var/win_path = /obj/structure/window/basic

/obj/wingrille_spawn/initialize()
	..()
	if(!win_path)
		return
	if (!locate(/obj/structure/grille) in get_turf(src))
		new /obj/structure/grille(src.loc)
	for (var/dir in cardinal)
		var/turf/T = get_step(src, dir)
		if (!locate(/obj/wingrille_spawn) in T)
			var/obj/structure/window/new_win = new win_path(src.loc)
			new_win.set_dir(dir)

/obj/wingrille_spawn/reinforced
	name = "reinforced window grille spawner"
	icon_state = "r-wingrille"
	win_path = /obj/structure/window/reinforced

/obj/wingrille_spawn/phoron
	name = "phoron window grille spawner"
	icon_state = "p-wingrille"
	win_path = /obj/structure/window/phoronbasic

/obj/wingrille_spawn/reinforced_phoron
	name = "reinforced phoron window grille spawner"
	icon_state = "pr-wingrille"
	win_path = /obj/structure/window/phoronreinforced
