//spitters - fast, comparatively weak, very venomous; projectile attacks but will resort to melee once out of ammo
/mob/living/simple_animal/hostile/giant_spider/spitter
	desc = "A monstrously huge iridescent spider with shimmering eyes."
	icon_state = "spitter"
	icon_living = "spitter"
	icon_dead = "spitter_dead"
	maxHealth = 90
	health = 90
	poison_per_bite = 15
	ranged = TRUE
	move_to_delay = 2
	projectiletype = /obj/item/projectile/venom
	projectilesound = 'sound/effects/hypospray.ogg'
	fire_desc = "spits venom"
	ranged_range = 6
	pry_time = 7 SECONDS
	flash_vulnerability = 2
	base_attack_cooldown = 2 SECONDS

	var/venom_charge = 16

	ai_holder_type = /datum/ai_holder/simple_animal/spider/spitter

/datum/ai_holder/simple_animal/spider/spitter/post_ranged_attack(atom/A)
	. = ..()
	var/mob/living/simple_animal/hostile/giant_spider/spitter/S = holder
	S.venom_charge--

/mob/living/simple_animal/hostile/giant_spider/spitter/Life()
	. = ..()
	if(!.)
		return FALSE
	if(venom_charge <= 0)
		ranged = FALSE
		if(prob(25))
			venom_charge++
			if(venom_charge >= 8)
				ranged = TRUE
