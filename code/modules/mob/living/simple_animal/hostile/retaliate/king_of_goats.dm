//Visager's tracks 'Battle!' and 'Miniboss Fight' from the album 'Songs from an Unmade World 2' are available here
//http://freemusicarchive.org/music/Visager/Songs_From_An_Unmade_World_2/ and are made available under the CC BY 4.0 Attribution license,
//which is available for viewing here: https://creativecommons.org/licenses/by/4.0/legalcode


//the king and his court
/mob/living/simple_animal/hostile/retaliate/goat/king
	name = "king of goats"
	desc = "The oldest and wisest of goats; king of his race, peerless in dignity and power. His golden fleece radiates nobility."
	icon = 'icons/mob/simple_animal/king_of_goats.dmi'
	icon_state = "king_goat"
	icon_living = "king_goat"
	icon_dead = "goat_dead"
	speak_emote = list("brays in a booming voice")
	meat_amount = 12
	response_help  = "placates"
	response_harm   = "assaults"
	health = 500
	maxHealth = 500
	mob_size = MOB_LARGE
	mob_bump_flag = HEAVY
	can_escape = TRUE
	move_to_delay = 3
	min_gas = null
	max_gas = null
	minbodytemp = 0
	break_stuff_probability = 35
	flash_vulnerability = 0
	natural_weapon = /obj/item/natural_weapon/goatking
	var/current_damtype = DAMAGE_BRUTE
	var/list/elemental_weapons = list(
		BURN = /obj/item/natural_weapon/goatking/fire,
		ELECTROCUTE = /obj/item/natural_weapon/goatking/lightning
	)
	var/stun_chance = 5 //chance per attack to Weaken target

	ai_holder = /datum/ai_holder/simple_animal/goat/king
	say_list = /datum/say_list/goat/king

/datum/ai_holder/simple_animal/goat/king

/datum/ai_holder/simple_animal/goat/king/engage_target()
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/goat/king/G = holder
	if(isliving(G.target_mob))
		var/mob/living/L = G.target_mob
		if(prob(G.stun_chance))
			L.Weaken(0.5)
			L.confused += 1
			G.visible_message(SPAN_WARNING("\The [L] is bowled over by the impact of [G]'s attack!"))

/datum/ai_holder/simple_animal/goat/king/react_to_attack(atom/movable/attacker)
	. = ..()

	if(holder.stat == CONSCIOUS && prob(5))
		holder.visible_message(SPAN_WARNING("The [holder] bellows indignantly, with a judgemental gleam in his eye."))

/datum/ai_holder/simple_animal/goat/king/phase2/engage_target()
	. = ..()

	var/mob/living/simple_animal/hostile/retaliate/goat/king/phase2/G = holder
	if (G.current_damtype != DAMAGE_BRUTE)
		G.special_attacks++

/datum/ai_holder/simple_animal/goat/king/phase2/react_to_attack(atom/movable/attacker)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/goat/king/phase2/G = holder
	if(G.spellscast < 5)
		if(prob(5) && G.move_to_delay != 1) //speed buff
			G.spellscast++
			G.visible_message(SPAN_MFAUNA("\The [G] shimmers and seems to phase in and out of reality itself!"))
			G.move_to_delay = 1

		else if(prob(5)) //stun move
			G.spellscast++
			G.visible_message(SPAN_MFAUNA("\The [G]' fleece flashes with blinding light!"))
			new /obj/item/grenade/flashbang/instant(G.loc)

		else if(prob(5)) //spawn adds
			G.spellscast++
			G.visible_message(SPAN_MFAUNA("\The [G] summons the imperial guard to his aid, and they appear in a flash!"))
			new /mob/living/simple_animal/hostile/retaliate/goat/guard/master(get_step(G,pick(GLOB.cardinal)))
			new /mob/living/simple_animal/hostile/retaliate/goat/guard(get_step(G,pick(GLOB.cardinal)))
			new /mob/living/simple_animal/hostile/retaliate/goat/guard(get_step(G,pick(GLOB.cardinal)))

		else if(prob(5)) //EMP blast
			G.spellscast++
			G.visible_message(SPAN_MFAUNA("\The [G] disrupts nearby electrical equipment!"))
			empulse(get_turf(G), 5, 2, 0)

		else if (prob(5) && G.current_damtype == DAMAGE_BRUTE && !G.special_attacks) //elemental attacks
			G.spellscast++
			if(prob(50))
				G.visible_message(SPAN_MFAUNA("\The [G]' horns flicker with holy white flame!"))
				G.current_damtype = DAMAGE_BURN
			else
				G.visible_message(SPAN_MFAUNA("\The [G]' horns glimmer, electricity arcing between them!"))
				G.current_damtype = DAMAGE_SHOCK

		else if(prob(5)) //earthquake spell
			G.visible_message("<span class='cultannounce'>\The [G]' eyes begin to glow ominously as dust and debris in the area is kicked up in a light breeze.</span>")
			set_busy(TRUE)
			if(do_after(G, 6 SECONDS, do_flags = DO_DEFAULT | DO_USER_UNIQUE_ACT))
				var/health_holder = G.health
				G.visible_message(SPAN_MFAUNA("\The [G] raises its fore-hooves and stomps them into the ground with incredible force!"))
				explosion(get_step(G,pick(GLOB.cardinal)), -1, 2, 2, 3, 6)
				explosion(get_step(G,pick(GLOB.cardinal)), -1, 1, 4, 4, 6)
				explosion(get_step(G,pick(GLOB.cardinal)), -1, 3, 4, 3, 6)
				set_busy(FALSE)
				G.spellscast += 2
				if(!G.health < health_holder)
					G.health = health_holder //our own magicks cannot harm us
			else
				G.visible_message(SPAN_NOTICE("The [G] loses concentration and huffs haughtily."))
				set_busy(FALSE)

		else return


/mob/living/simple_animal/hostile/retaliate/goat/king/get_natural_weapon()
	if(!(current_damtype in elemental_weapons))
		return ..()
	if(ispath(elemental_weapons[current_damtype]))
		var/T = elemental_weapons[current_damtype]
		elemental_weapons[current_damtype] = new T(src)
	return elemental_weapons[current_damtype]

/obj/item/natural_weapon/goatking
	name = "giant horns"
	attack_verb = list("brutalized")
	force = 40
	sharp = TRUE

/obj/item/natural_weapon/goatking/fire
	name = "burning horns"
	damtype = DAMAGE_BURN

/obj/item/natural_weapon/goatking/lightning
	name = "lightning horns"
	damtype = DAMAGE_SHOCK

/mob/living/simple_animal/hostile/retaliate/goat/king/phase2
	name = "emperor of goats"
	desc = "The King of Kings, God amongst men, and your superior in every way."
	icon_state = "king_goat2"
	icon_living = "king_goat2"
	meat_amount = 36
	health = 750
	maxHealth = 750
	natural_weapon = /obj/item/natural_weapon/goatking/unleashed
	elemental_weapons = list(
		BURN = /obj/item/natural_weapon/goatking/fire/unleashed,
		ELECTROCUTE = /obj/item/natural_weapon/goatking/lightning/unleashed
	)
	default_pixel_y = 5
	break_stuff_probability = 40
	stun_chance = 7

	ai_holder = /datum/ai_holder/simple_animal/goat/king/phase2

	var/spellscast = 0
	var/phase3 = FALSE
	var/datum/sound_token/boss_theme
	var/sound_id = "goat"
	var/special_attacks = 0

/obj/item/natural_weapon/goatking/unleashed
	force = 55

/obj/item/natural_weapon/goatking/lightning/unleashed
	force = 55

/obj/item/natural_weapon/goatking/fire/unleashed
	force = 55

/mob/living/simple_animal/hostile/retaliate/goat/king/phase2/Initialize()
	. = ..()
	boss_theme = GLOB.sound_player.PlayLoopingSound(src, sound_id, 'sound/music/Visager-Battle.ogg', volume = 10, range = 7, falloff = 4, prefer_mute = TRUE)
	update_icon()

/mob/living/simple_animal/hostile/retaliate/goat/guard
	name = "honour guard"
	desc = "A very handsome and noble beast."
	icon = 'icons/mob/simple_animal/king_of_goats.dmi'
	icon_state = "goat_guard"
	icon_living = "goat_guard"
	icon_dead = "goat_guard_dead"
	health = 125
	maxHealth = 125
	natural_weapon = /obj/item/natural_weapon/goathorns

/obj/item/natural_weapon/goathorns
	name = "horns"
	attack_verb = list("impaled", "stabbed")
	force = 15
	sharp = TRUE

/mob/living/simple_animal/hostile/retaliate/goat/guard/master
	name = "master of the guard"
	desc = "A very handsome and noble beast - the most trusted of all the king's men."
	icon_state = "goat_guard_m"
	icon_living = "goat_guard_m"
	icon_dead = "goat_guard_m_dead"
	health = 200
	maxHealth = 200
	natural_weapon = /obj/item/natural_weapon/goathorns
	move_to_delay = 3

/mob/living/simple_animal/hostile/retaliate/goat/king/phase2/proc/phase3_transition()
	phase3 = TRUE
	spellscast = 0
	health = 750
	new /obj/item/grenade/flashbang/instant(src.loc)
	QDEL_NULL(boss_theme)
	boss_theme = GLOB.sound_player.PlayLoopingSound(src, sound_id, 'sound/music/Visager-Miniboss_Fight.ogg', volume = 10, range = 8, falloff = 4, prefer_mute = TRUE)
	stun_chance = 10
	update_icon()
	visible_message("<span class='cultannounce'>\The [src]' wounds close with a flash, and when he emerges, he's even larger than before!</span>")

/mob/living/simple_animal/hostile/retaliate/goat/king/phase2/on_update_icon()
	SetTransform(scale = phase3 ? 1.5 : 1.25)
	if (phase3)
		icon_state = "king_goat3"
		icon_living = "king_goat3"
	default_pixel_y = 10

/mob/living/simple_animal/hostile/retaliate/goat/king/phase2/Life()
	. = ..()
	if(!.)
		return FALSE
	if(special_attacks >= 6 && current_damtype != DAMAGE_BRUTE)
		visible_message(SPAN_MFAUNA("The energy surrounding \the [src]'s horns dissipates."))
		current_damtype = DAMAGE_BRUTE

	if(health <= 150 && !phase3 && spellscast == 5) //begin phase 3, reset spell limit and heal
		phase3_transition()

/mob/living/simple_animal/hostile/retaliate/goat/king/proc/OnDeath()
	visible_message("<span class='cultannounce'>\The [src] lets loose a terrific wail as its wounds close shut with a flash of light, and its eyes glow even brighter than before!</span>")
	new /mob/living/simple_animal/hostile/retaliate/goat/king/phase2(src.loc)
	qdel(src)

/mob/living/simple_animal/hostile/retaliate/goat/king/phase2/OnDeath()
	QDEL_NULL(boss_theme)
	if(phase3)
		visible_message(SPAN_MFAUNA("\The [src] shrieks as the seal on his power breaks and his wool sheds off!"))
		new /obj/item/towel/fleece(src.loc)

/mob/living/simple_animal/hostile/retaliate/goat/king/death()
	..()
	OnDeath()

/mob/living/simple_animal/hostile/retaliate/goat/king/phase2/Destroy()
	QDEL_NULL(boss_theme)
	. = ..()

/mob/living/simple_animal/hostile/retaliate/goat/king/Allow_Spacemove(check_drift = 0)
	return 1

/datum/say_list/goat/king
	emote_hear = list("brays in a booming voice")
	emote_see = list("stamps a mighty foot, shaking the surroundings")
