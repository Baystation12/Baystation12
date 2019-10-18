//////////////////////////////////////////////////////////////////////////////////////////
//Dependencies located in robot.dm and robot_modules.dm, they are vital for this to work//
//////////////////////////////////////////////////////////////////////////////////////////

/mob/living/silicon/robot/huragok
	name = "Huragok"
	real_name = "Huragok"
	icon = 'code/modules/halo/covenant/engineer.dmi'
	icon_state = "engineer"
	maxHealth = 75
	health = 75
	faction = "Covenant"
	spawn_sound = null
	speak_statement = "chirps"
	speak_exclamation = "chirps"
	speak_query = "chirps"
	laws = /datum/ai_laws/huragok
	default_language = /datum/language/sign

	modules_available = list("Huragok Engineer", "Huragok Lifeworker")

	universal_understand = 1
	scrambledcodes = 1
	req_access = list(-1)
//	intenselight = 1
	light_color = " 1fe5ef"	//Yeah for some reason, the space at the beginning is vital. Go figure.
	light_power = 3

	cell = /obj/item/weapon/cell/infinite
	radio = /obj/item/device/radio/headset/covenant
	common_radio = /obj/item/device/radio/headset/covenant

/mob/living/silicon/robot/huragok/Login()
	. =.. ()
	to_chat(src,"<span class='notice'>You can set a custom name by using the <b>Namepick</b> command in the <b>Silicon Commands</b> tab. Make sure to use a proper huragok name, the naming rule still apply!</span> <span class='warning'>This role and its mechanics are experimental! It is nowhere near a finished stated as it lacks proper balance and unique features. Expect to need a lot of admin assistance!</span>")

/mob/living/silicon/robot/huragok/Initialize()
	. =.. ()
	remove_language("Robot Talk", 1)
	remove_language(LANGUAGE_EAL, 1)
	remove_language(LANGUAGE_GALCOM, 1)
	remove_language(LANGUAGE_SOL_COMMON, 1)
	add_language(LANGUAGE_SIGN, 1)
