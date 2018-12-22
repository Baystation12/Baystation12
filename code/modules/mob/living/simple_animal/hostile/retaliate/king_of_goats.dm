//Visager's tracks 'Battle!' and 'Miniboss Fight' from the album 'Songs from an Unmade World 2' are available here
//http://freemusicarchive.org/music/Visager/Songs_From_An_Unmade_World_2/ and are made available under the CC BY 4.0 Attribution license,
//which is available for viewing here: https://creativecommons.org/licenses/by/4.0/legalcode


//the king and his court
/mob/living/simple_animal/hostile/retaliate/goat/king
	name = "king of goats"
	desc = "The oldest and wisest of goats; king of his race, peerless in dignity and power. His golden fleece radiates nobility."
	icon = 'icons/mob/king_of_goats.dmi'
	icon_state = "king_goat"
	icon_living = "king_goat"
	icon_dead = "goat_dead"
	speak_emote = list("brays in a booming voice")
	emote_hear = list("brays in a booming voice")
	emote_see = list("stamps a mighty foot, shaking the surroundings")
	meat_amount = 12
	response_help  = "placates"
	response_harm   = "assaults"
	attacktext = "brutalized"
	health = 500
	maxHealth = 500
	melee_damage_lower = 35
	melee_damage_upper = 55
	mob_size = MOB_LARGE
	can_escape = 1
	move_to_delay = 3
	min_gas = null
	max_gas = null
	minbodytemp = 0
	break_stuff_probability = 35

	var/stun_chance = 5 //chance per attack to Weaken target

/mob/living/simple_animal/hostile/retaliate/goat/king/phase2
	name = "emperor of goats"
	desc = "The King of Kings, God amongst men, and your superior in every way."
	icon_state = "king_goat2"
	icon_living = "king_goat2"
	meat_amount = 36
	health = 750
	maxHealth = 750
	melee_damage_lower = 40
	melee_damage_upper = 60
	default_pixel_y = 5
	break_stuff_probability = 40

	var/spellscast = 0
	var/phase3 = FALSE
	var/datum/sound_token/boss_theme
	var/sound_id = "goat"
	var/special_attacks = 0
	stun_chance = 7

/mob/living/simple_animal/hostile/retaliate/goat/king/phase2/Initialize()
	. = ..()
	boss_theme = GLOB.sound_player.PlayLoopingSound(src, sound_id, 'sound/music/Visager-Battle.ogg', volume = 10, range = 7, falloff = 4, prefer_mute = TRUE)
	update_icon()

/mob/living/simple_animal/hostile/retaliate/goat/guard
	name = "honour guard"
	desc = "A very handsome and noble beast."
	icon_state = "goat_guard"
	icon_living = "goat_guard"
	icon_dead = "goat_guard_dead"
	health = 125
	maxHealth = 125
	melee_damage_lower = 10
	melee_damage_upper = 15

/mob/living/simple_animal/hostile/retaliate/goat/guard/master
	name = "master of the guard"
	desc = "A very handsome and noble beast - the most trusted of all the king's men."
	icon_state = "goat_guard_m"
	icon_living = "goat_guard_m"
	icon_dead = "goat_guard_m_dead"
	health = 200
	maxHealth = 200
	melee_damage_lower = 15
	melee_damage_upper = 20
	move_to_delay = 3

/mob/living/simple_animal/hostile/retaliate/goat/king/Retaliate()
	..()
	if(stat == CONSCIOUS && prob(5))
		visible_message("<span class='warning'>\The [src] bellows indignantly, with a judgemental gleam in his eye.</span>")

/mob/living/simple_animal/hostile/retaliate/goat/king/phase2/Retaliate()
	set waitfor = FALSE
	..()
	if(spellscast < 5)
		if(prob(5) && move_to_delay != 1) //speed buff
			spellscast++
			visible_message("<span class='cult'>\The [src] shimmers and seems to phase in and out of reality itself!</span>")
			move_to_delay = 1

		else if(prob(5) && melee_damage_lower != 50) //damage buff
			spellscast++
			visible_message("<span class='cult'>\The [src]' horns grow larger and more menacing!</span>")
			melee_damage_lower = 50

		else if(prob(5)) //stun move
			spellscast++
			visible_message("<span class='cult'>\The [src]' fleece flashes with blinding light!</span>")
			new /obj/item/weapon/grenade/flashbang/instant(src.loc)

		else if(prob(5)) //spawn adds
			spellscast++
			visible_message("<span class='cult'>\The [src] summons the imperial guard to his aid, and they appear in a flash!</span>")
			new /mob/living/simple_animal/hostile/retaliate/goat/guard/master(get_step(src,pick(GLOB.cardinal)))
			new /mob/living/simple_animal/hostile/retaliate/goat/guard(get_step(src,pick(GLOB.cardinal)))
			new /mob/living/simple_animal/hostile/retaliate/goat/guard(get_step(src,pick(GLOB.cardinal)))

		else if(prob(5)) //EMP blast
			spellscast++
			visible_message("<span class='cult'>\The [src] disrupts nearby electrical equipment!</span>")
			empulse(get_turf(src), 5, 2, 0)

		else if(prob(5) && damtype == BRUTE && !special_attacks) //elemental attacks
			spellscast++
			if(prob(50))
				visible_message("<span class='cult'>\The [src]' horns flicker with holy white flame!</span>")
				damtype = BURN
			else
				visible_message("<span class='cult'>\The [src]' horns glimmer, electricity arcing between them!</span>")
				damtype = ELECTROCUTE

		else if(prob(5)) //earthquake spell
			visible_message("<span class='danger'>\The [src]' eyes begin to glow ominously as dust and debris in the area is kicked up in a light breeze.</span>")
			stop_automation = TRUE
			if(do_after(src, 6 SECONDS, src))
				var/health_holder = health
				visible_message("<span class='cult'>\The [src] raises its fore-hooves and stomps them into the ground with incredible force!</span>")
				explosion(get_step(src,pick(GLOB.cardinal)), -1, 2, 2, 3, 6)
				explosion(get_step(src,pick(GLOB.cardinal)), -1, 1, 4, 4, 6)
				explosion(get_step(src,pick(GLOB.cardinal)), -1, 3, 4, 3, 6)
				stop_automation = FALSE
				spellscast += 2
				if(!health < health_holder)
					health = health_holder //our own magicks cannot harm us
			else
				visible_message("<span class='notice'>\The [src] loses concentration and huffs haughtily.</span>")
				stop_automation = FALSE

		else return

/mob/living/simple_animal/hostile/retaliate/goat/king/phase2/proc/phase3_transition()
	phase3 = TRUE
	spellscast = 0
	health = 750
	new /obj/item/weapon/grenade/flashbang/instant(src.loc)
	QDEL_NULL(boss_theme)
	boss_theme = GLOB.sound_player.PlayLoopingSound(src, sound_id, 'sound/music/Visager-Miniboss_Fight.ogg', volume = 10, range = 8, falloff = 4, prefer_mute = TRUE)
	stun_chance = 10
	update_icon()
	visible_message("<span class='cult'>\The [src]' wounds close with a flash, and when he emerges, he's even larger than before!</span>")

/mob/living/simple_animal/hostile/retaliate/goat/king/phase2/on_update_icon()
	var/matrix/M = new
	if(phase3)
		icon_state = "king_goat3"
		icon_living = "king_goat3"
		M.Scale(1.5)
	else
		M.Scale(1.25)
	transform = M
	default_pixel_y = 10

/mob/living/simple_animal/hostile/retaliate/goat/king/phase2/Life()
	. = ..()
	if(!.)
		return FALSE
	if(special_attacks >= 6 && damtype != BRUTE)
		visible_message("<span class='cult'>The energy surrounding \the [src]'s horns dissipates.</span>")
		damtype = BRUTE

	if(health <= 150 && !phase3 && spellscast == 5) //begin phase 3, reset spell limit and heal
		phase3_transition()

/mob/living/simple_animal/hostile/retaliate/goat/king/proc/OnDeath()
	if(prob(85))
		visible_message("<span class='cult'>\The light radiating from \the [src]' fleece dims...</span>")
	else
		visible_message("<span class='cult'>\The [src] lets loose a terrific wail as its wounds close shut with a flash of light, and its eyes glow even brighter than before!</span>")
		new /mob/living/simple_animal/hostile/retaliate/goat/king/phase2(src.loc)
		Destroy()

/mob/living/simple_animal/hostile/retaliate/goat/king/phase2/OnDeath()
	QDEL_NULL(boss_theme)
	if(phase3)
		visible_message("<span class='cult'>\The [src] shrieks as the seal on his power breaks and his wool sheds off!</span>")
		new /obj/item/weapon/towel/fleece(src.loc)

/mob/living/simple_animal/hostile/retaliate/goat/king/death()
	..()
	OnDeath()

/mob/living/simple_animal/hostile/retaliate/goat/king/phase2/Destroy()
	QDEL_NULL(boss_theme)
	. = ..()

/mob/living/simple_animal/hostile/retaliate/goat/king/UnarmedAttack(atom/A)
	..()
	if(isliving(A))
		var/mob/living/L = A
		if(prob(stun_chance))
			L.Weaken(0.5)
			L.confused += 1
			visible_message("<span class='warning'>\The [L] is bowled over by the impact of [src]'s attack!</span>")

/mob/living/simple_animal/hostile/retaliate/goat/king/phase2/UnarmedAttack()
	..()
	if(damtype != BRUTE)
		special_attacks++