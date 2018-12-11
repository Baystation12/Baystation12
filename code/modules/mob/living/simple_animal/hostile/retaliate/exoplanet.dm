
/mob/living/simple_animal/hostile/retaliate/beast
	var/hunger = 0
	var/list/prey = list()

/mob/living/simple_animal/hostile/retaliate/beast/ListTargets(var/dist = 7)
	var/list/see = ..()
	if(see.len)
		return see
	if(prey.len)
		. = list()
		for(var/weakref/W in prey)
			var/mob/M = W.resolve()
			if(M)
				. += M
		return
	if(hunger > 500) //time to look for some food
		for(var/mob/living/L in view(src, dist))
			if(!attack_same && L.faction != faction)
				prey |= weakref(L)

/mob/living/simple_animal/hostile/retaliate/beast/Life()
	. = ..()
	if(!stat)
		hunger++
		if(hunger < 100) //stop hunting when satiated
			prey.Cut()
		else
			for(var/mob/living/simple_animal/S in range(src,1))
				if(S.stat == DEAD)
					visible_message("[src] consumes \the body of [S]!")
					var/turf/T = get_turf(S)
					var/obj/item/remains/xeno/X = new(T)
					X.desc += "These look like they belong to \a [S.name]."
					hunger = max(0, hunger - 5*S.maxHealth)
					if(prob(5))
						S.gib()
					else
						qdel(S)

/mob/living/simple_animal/proc/name_species()
	set name = "Name Alien Species"
	set category = "Exploration"
	set src in view()

	if(!GLOB.using_map.use_overmap)
		return
	if(!CanInteract(usr, GLOB.conscious_state))
		return

	for(var/obj/effect/overmap/sector/exoplanet/E)
		if(src in E.animals)
			var/newname = input("What do you want to name this species?", "Species naming", E.get_random_species_name()) as text|null
			newname = sanitizeName(newname, allow_numbers = TRUE, force_first_letter_uppercase = FALSE)
			if(newname && CanInteract(usr, GLOB.conscious_state))
				if(E.rename_species(type, newname))
					to_chat(usr,"<span class='notice'>This species will be known from now on as '[newname]'.</span>")
				else
					to_chat(usr,"<span class='warning'>This species has already been named!</span>")
			return

/mob/living/simple_animal/hostile/retaliate/beast/samak
	name = "samak"
	desc = "A fast, armoured predator accustomed to hiding and ambushing in cold terrain."
	faction = "samak"
	icon_state = "samak"
	icon_living = "samak"
	icon_dead = "samak_dead"
	move_to_delay = 2
	maxHealth = 125
	health = 125
	speed = 2
	melee_damage_lower = 5
	melee_damage_upper = 15
	attacktext = "mauled"
	cold_damage_per_tick = 0
	speak_chance = 5
	speak = list("Hruuugh!","Hrunnph")
	emote_see = list("paws the ground","shakes its mane","stomps")
	emote_hear = list("snuffles")

/mob/living/simple_animal/hostile/retaliate/beast/samak/alt
	desc = "A fast, armoured predator accustomed to hiding and ambushing."
	icon_state = "samak-alt"
	icon_living = "samak-alt"
	icon_dead = "samak-alt_dead"

/mob/living/simple_animal/hostile/retaliate/beast/diyaab
	name = "diyaab"
	desc = "A small pack animal. Although omnivorous, it will hunt meat on occasion."
	faction = "diyaab"
	icon_state = "diyaab"
	icon_living = "diyaab"
	icon_dead = "diyaab_dead"
	move_to_delay = 1
	maxHealth = 25
	health = 25
	speed = 1
	melee_damage_lower = 1
	melee_damage_upper = 8
	attacktext = "gouged"
	cold_damage_per_tick = 0
	speak_chance = 5
	speak = list("Awrr?","Aowrl!","Worrl")
	emote_see = list("sniffs the air cautiously","looks around")
	emote_hear = list("snuffles")
	mob_size = MOB_SMALL

/mob/living/simple_animal/hostile/retaliate/beast/shantak
	name = "shantak"
	desc = "A piglike creature with a bright iridiscent mane that sparkles as though lit by an inner light. Don't be fooled by its beauty though."
	faction = "shantak"
	icon_state = "shantak"
	icon_living = "shantak"
	icon_dead = "shantak_dead"
	move_to_delay = 1
	maxHealth = 75
	health = 75
	speed = 1
	melee_damage_lower = 3
	melee_damage_upper = 12
	attacktext = "gouged"
	cold_damage_per_tick = 0
	speak_chance = 2
	speak = list("Shuhn","Shrunnph?","Shunpf")
	emote_see = list("scratches the ground","shakes out its mane","tinkles gently")

/mob/living/simple_animal/hostile/retaliate/beast/shantak/alt
	desc = "A piglike creature with a long and graceful mane. Don't be fooled by its beauty."
	icon_state = "shantak-alt"
	icon_living = "shantak-alt"
	icon_dead = "shantak-alt_dead"
	emote_see = list("scratches the ground","shakes out it's mane","rustles softly")

/mob/living/simple_animal/yithian
	name = "yithian"
	desc = "A friendly creature vaguely resembling an oversized snail without a shell."
	icon_state = "yithian"
	icon_living = "yithian"
	icon_dead = "yithian_dead"
	mob_size = MOB_TINY

/mob/living/simple_animal/tindalos
	name = "tindalos"
	desc = "It looks like a large, flightless grasshopper."
	icon_state = "tindalos"
	icon_living = "tindalos"
	icon_dead = "tindalos_dead"
	mob_size = MOB_TINY

/mob/living/simple_animal/thinbug
	name = "taki"
	desc = "It looks like a bunch of legs."
	icon_state = "thinbug"
	icon_living = "thinbug"
	icon_dead = "thinbug_dead"
	speak_chance = 1
	emote_hear = list("scratches the ground","chitters")
	mob_size = MOB_MINISCULE

/mob/living/simple_animal/hostile/retaliate/jelly
	name = "zeq"
	desc = "It looks like a floating jellyfish. How does it do that?"
	faction = "zeq"
	icon_state = "jelly"
	icon_living = "jelly"
	icon_dead = "jelly_dead"
	move_to_delay = 1
	maxHealth = 75
	health = 75
	speed = 1
	melee_damage_lower = 3
	melee_damage_upper = 12
	attacktext = "stung"
	damtype = BURN
	speak_chance = 1
	emote_see = list("wobbles slightly","oozes something out of tentacles' ends")

/mob/living/simple_animal/hostile/retaliate/jelly/alt
	icon_state = "jelly-alt"
	icon_living = "jelly-alt"
	icon_dead = "jelly-alt_dead"

mob/living/simple_animal/hostile/retaliate/royalcrab
	name = "cragenoy"
	desc = "It looks like a crustacean with an exceedingly hard carapace. Watch the pinchers!"
	faction = "crab"
	icon_state = "royalcrab"
	icon_living = "royalcrab"
	icon_dead = "royalcrab_dead"
	move_to_delay = 3
	maxHealth = 150
	health = 150
	speed = 1
	melee_damage_lower = 2
	melee_damage_upper = 5
	attacktext = "pinched"
	speak_chance = 1
	emote_see = list("skitters","oozes liquid from its mouth", "scratches at the ground", "clicks its claws")

/mob/living/simple_animal/hostile/jelly/New()
	..()
	color = color_rotation(round(rand(0,360),20))
