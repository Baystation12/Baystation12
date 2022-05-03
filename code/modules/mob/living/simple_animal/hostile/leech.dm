/*MEGALEECH
Tiny, weak, and mostly harmless alone. dangerous in groups.
*/

/mob/living/simple_animal/hostile/leech
	name = "megaleech"
	desc = "A giant leech the size of a common snake."
	icon = 'icons/mob/simple_animal/megaleech.dmi'
	icon_state = "leech"
	icon_living = "leech"
	icon_dead = "leech_dead"
	health = 15
	maxHealth = 15
	harm_intent_damage = 8
	natural_weapon = /obj/item/natural_weapon/bite/weak
	pass_flags = PASS_FLAG_TABLE
	faction = "leeches"
	can_pry = FALSE
	break_stuff_probability = 5
	flash_vulnerability = 0 // We dont have eyes, why should we care about light?
	bleed_colour = COLOR_VIOLET
	color = COLOR_GRAY

	ai_holder = /datum/ai_holder/simple_animal/melee/leech

	var/suck_potency = 8
	var/belly = 100

/mob/living/simple_animal/hostile/leech/Initialize()
	color = get_random_colour(0,75,190) // Our icon is greyscale, and can be painted just fine.  Uses same coloring range as flora.
	. = ..()

/datum/ai_holder/simple_animal/melee/leech/engage_target()
	. = ..()

	var/mob/living/simple_animal/hostile/leech/L = holder
	if(ishuman(.) && L.belly <= 75)
		var/mob/living/carbon/human/H = .
		var/obj/item/clothing/suit/space/S = H.get_covering_equipped_item_by_zone(BP_CHEST)
		if(istype(S) && !length(S.breaches))
			return
		H.remove_blood_simple(L.suck_potency)
		if(L.health < L.maxHealth)
			L.health += L.suck_potency / 1.5
		L.belly += clamp(L.suck_potency, 0, 100)


/mob/living/simple_animal/hostile/leech/Life()
	. = ..()
	if(!.)
		return FALSE

	if(target_mob)
		belly -= 3
	else
		belly -= 1

/obj/structure/leech_spawner
	name = "rigus regzorfra" // Similar naming to exoplanet flora, but not quite.
	desc = "Wait... Something is wrong about this one." // Someone is actually checking for pests, let's reward them.
	icon = 'icons/obj/hydroponics_growing.dmi'
	icon_state = "alien1-1" // Placeholder until initalize. If seen like this, something went wrong.
	color = COLOR_GRAY
	anchored = TRUE
	var/number_to_spawn = 12
	var/spent = FALSE

/obj/structure/leech_spawner/Initialize()
	icon_state = pick("alien[rand(1,4)]-dead") // Picks from the same pool of icons as xenoflora, but dead already.
	color = get_random_colour(0,75,190) // Colors them as such, too.
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/structure/leech_spawner/Process()
	if(!spent && (locate(/mob/living/carbon/human) in orange(5, src)))
		burst()

/obj/structure/leech_spawner/proc/burst()
	for(var/i in 1 to number_to_spawn)
		new /mob/living/simple_animal/hostile/leech(get_turf(src))
	visible_message(SPAN_MFAUNA("A swarm of leeches burst out from \the [src]!"))
	playsound(src, 'sound/voice/BugHiss.ogg', 50, 5)
	icon_state = "alien4-1" // looks close enough to an exploded plant.
	desc = "A pile of strewn together, half-dissolved plant matter pieces, covered in a thin, transparent liquid."
	spent = TRUE
	STOP_PROCESSING(SSobj, src)
