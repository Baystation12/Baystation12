//////////////////////////////////////////////////////////////////////////////////////////
//Dependencies located in robot.dm and robot_modules.dm, they are vital for this to work//
//////////////////////////////////////////////////////////////////////////////////////////
#define HURAGOK_REGEN 2	// 200 seconds to heal from full damage to full health

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
	pass_flags = PASSTABLE

	var/bruteloss = 0
	var/fireloss = 0

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
	if(stat == DEAD)
		return
	/*	What in the goddamn
	if(health < maxHealth)
		health = min(health + HURAGOK_REGEN,maxHealth)
	*/
	heal_overall_damage(HURAGOK_REGEN,HURAGOK_REGEN)

/mob/living/silicon/robot/huragok/New()
	. =.. ()
	remove_language("Robot Talk", 1)
	remove_language(LANGUAGE_ENGLISH, 1)
	add_language(LANGUAGE_SIGN, 1)
	add_language(LANGUAGE_SANGHEILI, 0)
	default_language = all_languages[LANGUAGE_SIGN]
	radio.create_channel_dongle(RADIO_COV)


/mob/living/silicon/robot/huragok/get_move_sound()
	. = null // Huragok hover, therefore make no sound when they move

/mob/living/silicon/robot/huragok/handle_regular_status_updates()	// Override the proc, so we kill huragok at 0 hp
	updatehealth()

	if (health <= 0)
		death()

	return 1

/mob/living/silicon/robot/huragok/CtrlShiftClickOn(var/atom/A)	// Special Bonk
	face_atom(A)
	if(Adjacent(A))
		if (prob(2))
			visible_message("<span class='notice'>\The [src] BONKS \the [A].</span>")
			playsound(get_turf(src),'code/modules/halo/sounds/bonk.ogg',100,0)
		else
			visible_message("<span class='notice'>\The [src] bonks \the [A] harmlessly.</span>")
			playsound(get_turf(src),'sound/effects/pop.ogg',25,1)
		do_attack_animation(A)
	return
  
/mob/living/silicon/robot/huragok/death()
	. = ..()
	gib()

#undef HURAGOK_REGEN
