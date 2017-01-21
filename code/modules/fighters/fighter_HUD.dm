var/obj/screen/fighter_hud
var/f_hud = list()

/mob/proc/show_fighter_hud(var/mob/M)
	if(!client)
		return
	var/obj/screen/using

	using = new /obj/screen()
	using.name = "shields"
	using.set_dir(SOUTHWEST)
	using.icon = 'icons/obj/fighter.dmi'
	using.icon_state = "shieldicon"
	using.screen_loc = "Center-1, Center-5"
	f_hud += using

	using = new /obj/screen()
	using.name = "weapon"
	using.set_dir(SOUTHWEST)
	using.icon = 'icons/obj/fighter.dmi'
	using.icon_state = "weaponicon"
	using.screen_loc = "Center, Center-5"
	f_hud += using

	using = new /obj/screen()
	using.name = "engine"
	using.set_dir(SOUTHWEST)
	using.icon = 'icons/obj/fighter.dmi'
	using.icon_state = "engineicon"
	using.screen_loc = "Center+1, Center-5"
	f_hud += using

	using = new /obj/screen()
	using.name = "computer"
	using.set_dir(SOUTHWEST)
	using.icon = 'icons/obj/fighter.dmi'
	using.icon_state = "computericon"
	using.screen_loc = "Center, Center-4"
	f_hud += using

	M.client.screen += f_hud