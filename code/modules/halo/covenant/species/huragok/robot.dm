//////////////////////////////////////////////////////////////////////////////////////////
//Dependencies located in robot.dm and robot_modules.dm, they are vital for this to work//
//////////////////////////////////////////////////////////////////////////////////////////

#define HURAGOK_REGEN 0.5

/mob/living/silicon/robot/huragok
	name = "Huragok"
	real_name = "Huragok"
	icon = 'code/modules/halo/covenant/species/huragok/huragok.dmi'
	icon_state = "engineer"
	maxHealth = 400
	health = 400
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

/mob/living/silicon/robot/huragok/emp_act()
	return

/mob/living/silicon/robot/huragok/Login()
	. =.. ()
	to_chat(src,"<span class='notice'>You can set a custom name by using the <b>Namepick</b> command in the <b>Silicon Commands</b> tab. Make sure to use a proper huragok name, the naming rule still apply!</span> <span class='warning'>This role and its mechanics are experimental! It is nowhere near a finished stated as it lacks proper balance and unique features. Expect to need a lot of admin assistance!</span>")

/mob/living/silicon/robot/huragok/Life()
	. = ..()
	if(stat)
		return
	if(health < maxHealth)
		health = min(health + HURAGOK_REGEN,maxHealth)
	for(var/V in components)
		var/datum/robot_component/C = components[V]
		if(C.installed != 1)
			var/init_ex_type = initial(C.external_type)
			if(isnull(init_ex_type) || !C.wrapped)
				C.repair()
		var/heal_brute = 0
		var/heal_burn = 0
		if(C.brute_damage > 0)
			heal_brute = HURAGOK_REGEN
		if(C.electronics_damage > 0)
			heal_burn = HURAGOK_REGEN
		if(heal_brute || heal_burn)
			C.heal_damage(heal_brute,heal_burn)

/mob/living/silicon/robot/huragok/New()
	. =.. ()
	remove_language("Robot Talk", 1)
	remove_language(LANGUAGE_ENGLISH, 1)
	add_language(LANGUAGE_SIGN, 1)
	add_language(LANGUAGE_SANGHEILI, 0)
	default_language = all_languages[LANGUAGE_SIGN]
	radio.create_channel_dongle(RADIO_COV)

/mob/living/silicon/robot/huragok/death()
	. = ..()
	gib()

#undef HURAGOK_REGEN