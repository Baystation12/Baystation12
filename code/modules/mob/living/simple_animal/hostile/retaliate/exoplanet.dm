
/mob/living/simple_animal/hostile/retaliate/beast
	var/hunger = 0
	var/list/prey = list()
	ai_holder_type = /datum/ai_holder/simple_animal/beast

/mob/living/simple_animal/hostile/retaliate/beast/Life()
	. = ..()
	if(!.)
		return FALSE
	hunger++
	if(hunger < 100) //stop hunting when satiated
		ai_holder.hostile = FALSE
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

	if (hunger > 500)
		ai_holder.hostile = TRUE

/mob/living/simple_animal/proc/name_species(newname as text)
	set name = "Name Alien Species"
	set category = "IC"
	set src in view()

	if(!GLOB.using_map.use_overmap)
		return
	if(!CanInteract(usr, GLOB.conscious_state))
		return

	for(var/obj/effect/overmap/visitable/sector/exoplanet/E)
		if(src in E.animals)
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
	natural_weapon = /obj/item/natural_weapon/claws
	cold_damage_per_tick = 0
	natural_armor = list(
		melee = ARMOR_MELEE_KNIVES
		)

	ai_holder_type = /datum/ai_holder/simple_animal/samak
	say_list_type = /datum/say_list/samak

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
	natural_weapon = /obj/item/natural_weapon/claws/weak
	cold_damage_per_tick = 0
	mob_size = MOB_SMALL

	ai_holder_type = /datum/ai_holder/simple_animal/diyaab
	say_list_type = /datum/say_list/diyaab

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
	natural_weapon = /obj/item/natural_weapon/claws
	cold_damage_per_tick = 0

	ai_holder_type = /datum/ai_holder/simple_animal/shantak
	say_list_type = /datum/say_list/shantak

/mob/living/simple_animal/hostile/retaliate/beast/shantak/alt
	desc = "A piglike creature with a long and graceful mane. Don't be fooled by its beauty."
	icon_state = "shantak-alt"
	icon_living = "shantak-alt"
	icon_dead = "shantak-alt_dead"

/mob/living/simple_animal/yithian
	name = "yithian"
	desc = "A friendly creature vaguely resembling an oversized snail without a shell."
	icon_state = "yithian"
	icon_living = "yithian"
	icon_dead = "yithian_dead"
	mob_size = MOB_TINY
	density = FALSE

	ai_holder_type = /datum/ai_holder/simple_animal/passive

/mob/living/simple_animal/tindalos
	name = "tindalos"
	desc = "It looks like a large, flightless grasshopper."
	icon_state = "tindalos"
	icon_living = "tindalos"
	icon_dead = "tindalos_dead"
	mob_size = MOB_TINY
	density = FALSE

	ai_holder_type = /datum/ai_holder/simple_animal/passive

/mob/living/simple_animal/thinbug
	name = "taki"
	desc = "It looks like a bunch of legs."
	icon_state = "thinbug"
	icon_living = "thinbug"
	icon_dead = "thinbug_dead"
	mob_size = MOB_MINISCULE
	density = FALSE

	ai_holder_type = /datum/ai_holder/simple_animal/passive/thinbug
	say_list_type = /datum/say_list/thinbug

/mob/living/simple_animal/hostile/retaliate/royalcrab
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
	natural_weapon = /obj/item/natural_weapon/pincers
	natural_armor = list(
		melee = ARMOR_MELEE_RESISTANT
		)

	ai_holder_type = /datum/ai_holder/simple_animal/retaliate/royalcrab
	say_list = /datum/say_list/royalcrab

/mob/living/simple_animal/hostile/retaliate/beast/charbaby
	name = "charbaby"
	desc = "A huge grubby creature."
	icon_state = "char"
	icon_living = "char"
	icon_dead = "char_dead"
	mob_size = MOB_LARGE
	health = 45
	maxHealth = 45
	natural_weapon = /obj/item/natural_weapon/charbaby
	speed = 2
	response_help =  "pats briefly"
	response_disarm = "gently pushes"
	response_harm = "strikes"
	return_damage_min = 2
	return_damage_max = 3
	harm_intent_damage = 1
	blood_color = COLOR_NT_RED
	natural_armor = list(
		laser = ARMOR_LASER_HANDGUNS
		)
	ai_holder_type = /datum/ai_holder/simple_animal/melee/charbaby

/datum/ai_holder/simple_animal/melee/charbaby

/datum/ai_holder/simple_animal/melee/charbaby/engage_target()
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/beast/charbaby/C = holder
	if(isliving(C.target_mob) && prob(25))
		var/mob/living/L = C.target_mob
		if(prob(10))
			L.adjust_fire_stacks(1)
			L.IgniteMob()
/obj/item/natural_weapon/charbaby
	name = "scalding hide"
	damtype = BURN
	force = 5
	attack_verb = list("singed")

/mob/living/simple_animal/hostile/retaliate/beast/charbaby/attack_hand(mob/living/carbon/human/H)
	. = ..()
	reflect_unarmed_damage(H, BURN, "amorphous mass")

/mob/living/simple_animal/hostile/retaliate/beast/shantak/lava
	desc = "A vaguely canine looking beast. It looks as though its fur is made of stone wool."
	icon_state = "lavadog"
	icon_living = "lavadog"
	icon_dead = "lavadog_dead"

	say_list_type = /datum/say_list/shantak/lava


/* AI */

/datum/ai_holder/simple_animal/beast
	speak_chance = 5

/datum/ai_holder/simple_animal/diyaab/post_melee_attack(atom/A)
	. = ..()
	if(holder.Adjacent(A))
		holder.IMove(get_step(holder, pick(GLOB.alldirs)))
		holder.face_atom(A)

/datum/ai_holder/simple_animal/samak
	speak_chance = 5

/datum/ai_holder/simple_animal/diyaab
	speak_chance = 5

/datum/ai_holder/simple_animal/shantak
	speak_chance = 2

/datum/ai_holder/simple_animal/passive/thinbug
	speak_chance = 1

/datum/ai_holder/simple_animal/retaliate/royalcrab
	speak_chance = 1

/* Say Lists */

/datum/say_list/samak
	speak = list("Hruuugh!","Hrunnph")
	emote_see = list("paws the ground","shakes its mane","stomps")
	emote_hear = list("snuffles")

/datum/say_list/diyaab
	speak = list("Awrr?","Aowrl!","Worrl")
	emote_see = list("sniffs the air cautiously","looks around")
	emote_hear = list("snuffles")

/datum/say_list/shantak
	speak = list("Shuhn","Shrunnph?","Shunpf")
	emote_see = list("scratches the ground","shakes out its mane","tinkles gently")

/datum/say_list/thinbug
	emote_hear = list("scratches the ground","chitters")

/datum/say_list/royalcrab
	emote_see = list("skitters","oozes liquid from its mouth", "scratches at the ground", "clicks its claws")

/datum/say_list/shantak/lava
	speak = list("Karuph","Karump")
