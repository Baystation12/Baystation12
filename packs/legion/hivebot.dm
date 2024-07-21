// Hivebots renamed as legion scouts.

/// Boolean. Whether or not this hivebot has been integrated by the legion.
/mob/living/simple_animal/hostile/hivebot/var/is_legion = FALSE

/// The legion beacon this mob is linked to and spawned from.
/mob/living/simple_animal/hostile/hivebot/var/obj/structure/legion/beacon/linked_beacon = null

/// Upgrades the hivebot into a legion scout.
/mob/living/simple_animal/hostile/hivebot/proc/legionify(obj/structure/legion/beacon/beacon)
	if (is_legion)
		return
	SetName("legion scout")
	is_legion = TRUE
	desc += " <span class='warning'>This one seems smarter and faster than usual...</span>"
	faction = "legion"
	speed = max(speed - 1, 1)
	base_attack_cooldown = max(base_attack_cooldown - 1 SECOND, 1 SECOND)
	can_escape = TRUE
	melee_attack_delay = max(melee_attack_delay - 2, 0)
	if (beacon)
		linked_beacon = beacon


/mob/living/simple_animal/hostile/hivebot/Destroy()
	if (linked_beacon)
		linked_beacon.linked_mobs -= src
		linked_beacon = null

	. = ..()


/mob/living/simple_animal/hostile/hivebot/death()
	if (!is_legion || !rand(0, 1))
		..()
		return

	switch(rand(1, 2))
		if (1) // Normal brain
			var/obj/item/organ/internal/brain/brain = new(loc)
			brain.SetName("[name]'s [initial(brain.name)]")
			brain.die()

		if (2) // Positronic
			var/obj/item/organ/internal/posibrain/posibrain = new(loc)
			posibrain.SetName("[name]'s [initial(posibrain.name)]")
			posibrain.die()

	..()


// Legion hivebot spawners
/obj/spawner/legion/hivebot
	abstract_type = /obj/spawner/legion/hivebot
	/// Type path. Base hivebot to spawn and upgrade.
	var/mob/living/simple_animal/hostile/hivebot/base_hivebot


/obj/spawner/legion/hivebot/Initialize(mapload, ...)
	. = ..()
	base_hivebot = new base_hivebot(loc)
	base_hivebot.legionify()
	return INITIALIZE_HINT_QDEL


/obj/spawner/legion/hivebot/melee
	base_hivebot = /mob/living/simple_animal/hostile/hivebot

/obj/spawner/legion/hivebot/melee_fast
	base_hivebot = /mob/living/simple_animal/hostile/hivebot/rapid

/obj/spawner/legion/hivebot/melee_strong
	base_hivebot = /mob/living/simple_animal/hostile/hivebot/strong

/obj/spawner/legion/hivebot/ranged_pistol
	base_hivebot = /mob/living/simple_animal/hostile/hivebot/ranged_damage/basic

/obj/spawner/legion/hivebot/ranged_rifle
	base_hivebot = /mob/living/simple_animal/hostile/hivebot/ranged_damage/rapid

/obj/spawner/legion/hivebot/ranged_laser
	base_hivebot = /mob/living/simple_animal/hostile/hivebot/ranged_damage/laser

/obj/spawner/legion/hivebot/ranged_strong
	base_hivebot = /mob/living/simple_animal/hostile/hivebot/ranged_damage/strong

/obj/spawner/legion/hivebot/ranged_fire
	base_hivebot = /mob/living/simple_animal/hostile/hivebot/ranged_damage/dot


// Random legion hivebot spawner
/obj/random/legion/hivebot
	abstract_type = /obj/random/legion/hivebot
	icon = 'packs/legion/hivebot.dmi'
	icon_state = "spawner"


/obj/random/legion/hivebot/any/spawn_choices()
	return subtypesof(/obj/spawner/legion/hivebot)


/obj/random/legion/hivebot/melee/spawn_choices()
	return list(
		/obj/spawner/legion/hivebot/melee,
		/obj/spawner/legion/hivebot/melee_fast,
		/obj/spawner/legion/hivebot/melee_strong,
	)


/obj/random/legion/hivebot/ranged/spawn_choices()
	return list(
		/obj/spawner/legion/hivebot/ranged_pistol,
		/obj/spawner/legion/hivebot/ranged_rifle,
		/obj/spawner/legion/hivebot/ranged_laser,
		/obj/spawner/legion/hivebot/ranged_strong,
		/obj/spawner/legion/hivebot/ranged_fire,
	)
