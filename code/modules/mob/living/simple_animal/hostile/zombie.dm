//Locking movement speed //This doesn't do anything.
var/const/move_speed = 1
var/const/m_intent = "walk"
var/const/speed = -1


/mob/living/simple_animal/hostile/zombie
	name = "zombie"
	desc = "Cannablism at its best."
	icon = 'icons/mob/otherHuman/human.dmi'
	icon_state = "zombie_s"
	icon_living = "zombie_s"
	icon_dead = "zombie_l"
	speak = list("...", "f...a.", "rrrhhn", "..zzzooo..", "..phleahsh..")
	emote_see = list("starts moving towards flesh", "turns")
	speak_chance = 1
	turns_per_move = 3
	response_help = "unphazed"
	response_disarm = "shoves"
	response_harm = "hits"
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat/undead
	meat_amount = 1
	stop_automated_movement_when_pulled = 0
	maxHealth = 250
	health = 250
	move_to_delay = 6 //This is what slows down movement, change it if humans can outwalk a zombie

	harm_intent_damage = 2
	melee_damage_lower = 7
	melee_damage_upper = 19
	attacktext = "bites"
	attack_sound = "sound/effects/bite.ogg"

	minbodytemp = 200
	maxbodytemp = 340
	cold_damage_per_tick = 4	//Zombies are almost immune to the cold
	heat_damage_per_tick = 50	//Zombies are extremely weak to fire

	min_oxy = 0			//These zombies don't need to breath
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	unsuitable_atoms_damage = 0

	wall_smash = 1			//Add push as well?
	a_intent = "harm"
	faction = "undead"

	New()			//Any zombie created will have the virus
		..()
		var/datum/disease/D  = new /datum/disease/zombie_transformation
		D.holder = src
		D.affected_mob = src
		src.viruses += D

	SA_attackable(target_mob)
		if (isliving(target_mob))
			var/mob/living/L = target_mob
			if(L.stat != DEAD) //Make sure the target is completely dead
				return (0)
		if (istype(target_mob,/obj/mecha))
			var/obj/mecha/M = target_mob
			if (M.occupant)
				return (0)
		if (istype(target_mob,/obj/machinery/bot))
			var/obj/machinery/bot/B = target_mob
			if(B.health > 0)
				return (0)
		return (1)