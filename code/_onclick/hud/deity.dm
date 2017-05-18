/mob/living/deity/instantiate_hud(var/datum/hud/HUD)
	HUD.deity_hud()

/datum/hud/proc/deity_hud(ui_style = 'icons/mob/screen1_Midnight.dmi')
	src.adding = list()
	src.other = list()

	var/obj/screen/using

	using = new /obj/screen()
	using.name = "act_intent"
	using.set_dir(SOUTHWEST)
	using.icon = ui_style
	using.icon_state = "intent_"+mymob.a_intent
	using.screen_loc = ui_zonesel
	src.adding += using
	action_intent = using

	//intent small hud objects
	var/icon/ico

	ico = new(ui_style, "black")
	ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
	ico.DrawBox(rgb(255,255,255,1),1,ico.Height()/2,ico.Width()/2,ico.Height())
	using = new /obj/screen( src )
	using.name = I_HELP
	using.icon = ico
	using.screen_loc = ui_zonesel
	using.hud_layerise()
	src.adding += using
	help_intent = using

	ico = new(ui_style, "black")
	ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
	ico.DrawBox(rgb(255,255,255,1),ico.Width()/2,ico.Height()/2,ico.Width(),ico.Height())
	using = new /obj/screen( src )
	using.name = I_DISARM
	using.icon = ico
	using.screen_loc = ui_zonesel
	using.hud_layerise()
	src.adding += using
	disarm_intent = using

	ico = new(ui_style, "black")
	ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
	ico.DrawBox(rgb(255,255,255,1),ico.Width()/2,1,ico.Width(),ico.Height()/2)
	using = new /obj/screen( src )
	using.name = I_GRAB
	using.icon = ico
	using.screen_loc = ui_zonesel
	using.hud_layerise()
	src.adding += using
	grab_intent = using

	ico = new(ui_style, "black")
	ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
	ico.DrawBox(rgb(255,255,255,1),1,1,ico.Width()/2,ico.Height()/2)
	using = new /obj/screen( src )
	using.name = I_HURT
	using.icon = ico
	using.screen_loc = ui_zonesel
	using.hud_layerise()
	src.adding += using
	hurt_intent = using

	mymob.client.screen = list()
	mymob.client.screen += src.adding