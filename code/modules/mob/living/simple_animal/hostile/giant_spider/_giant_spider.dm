/*
	Spiders come in various types, and are a fairly common enemy both inside and outside the station.
	Their attacks can inject reagents, which can cause harm long after the spider is killed.
	Thick material will prevent injections, similar to other means of injections.
*/


// The base spider, in the 'walking tank' family.
/mob/living/simple_animal/hostile/giant_spider
	name = "giant spider"
	desc = "Furry and brown, it makes you shudder to look at it. This has light grey eyes."

	icon = 'icons/mob/simple_animal/spider.dmi'
	icon_state = "generic"
	icon_living = "generic"
	icon_dead = "generic_dead"
	// has_eye_glow = TRUE

	faction = "spiders"
	maxHealth = 125
	health = 125
	natural_weapon = /obj/item/natural_weapon/bite/spider
	pass_flags = PASS_FLAG_TABLE
	movement_cooldown = 10
	poison_resist = 0.5

	see_in_dark = 10

	response_help  = "pets"
	response_disarm = "gently pushes aside"

	max_gas = list(GAS_PHORON = 1, GAS_CO2 = 5, GAS_METHYL_BROMIDE = 1)
	bleed_colour = "#0d5a71"

	response_harm   = "punches"

	pry_time = 8 SECONDS
	pry_desc = "clawing"


	heat_damage_per_tick = 20
	cold_damage_per_tick = 20
	minbodytemp = 175 // So they can all survive Sif without having to be classed under /sif subtype.

	speak_emote = list("chitters")

	say_list_type = /datum/say_list/spider
	ai_holder_type = /datum/ai_holder/simple_animal/melee

	var/poison_type = /datum/reagent/toxin/venom	// The reagent that gets injected when it attacks.
	var/poison_chance = 20			// Chance for injection to occur.
	var/poison_per_bite = 5			// Amount added per injection.

	var/image/eye_layer

	var/use_ladder_chance = 25
	var/climbing_ladder = FALSE

	meat_type = /obj/item/reagent_containers/food/snacks/spider
	meat_amount = 3
	bone_material = null
	bone_amount =   0
	skin_material = MATERIAL_SKIN_CHITIN
	skin_amount =   5

/datum/ai_holder/simple_animal/melee/spider
	// intelligence_level = AI_SMART
	// use_astar = FALSE

/obj/item/natural_weapon/bite/spider
	force = 20

/mob/living/simple_animal/hostile/giant_spider/Initialize(mapload, atom/parent)
	get_light_and_color(parent)
	spider_randomify()
	update_icon()
	. = ..()

/mob/living/simple_animal/hostile/giant_spider/death(gibbed, deathmessage, show_dead_message)
	. = ..()

	overlays -= eye_layer

/mob/living/simple_animal/hostile/giant_spider/proc/spider_randomify() //random math nonsense to get their damage, health and venomness values
	maxHealth = rand(initial(maxHealth), (1.4 * initial(maxHealth)))
	health = maxHealth
	var/image/I = image(icon = icon, icon_state = "[icon_state]-eyes", layer = EYE_GLOW_LAYER)
	I.plane = EFFECTS_ABOVE_LIGHTING_PLANE
	I.appearance_flags = DEFAULT_APPEARANCE_FLAGS | RESET_COLOR
	eye_layer = I
	overlays += I


/mob/living/simple_animal/hostile/giant_spider/apply_melee_effects(atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(L.reagents)
			var/target_zone = pick(BP_CHEST,BP_CHEST,BP_CHEST,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_HEAD)
			if(L.can_inject(src, null, target_zone))
				inject_poison(L, target_zone)

// Does actual poison injection, after all checks passed.
/mob/living/simple_animal/hostile/giant_spider/proc/inject_poison(mob/living/L, target_zone)
	if(prob(poison_chance))
		to_chat(L, SPAN_WARNING("You feel a tiny prick."))
		L.reagents.add_reagent(poison_type, poison_per_bite)

/// Scale the spiders icon up or down.
/mob/living/simple_animal/hostile/giant_spider/proc/scale(factor)
	if (factor)
		var/matrix/M = matrix()
		M.Scale(factor)
		src.transform = M
