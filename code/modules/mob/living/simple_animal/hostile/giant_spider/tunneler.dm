// Tunnelers have a special ability that allows them to charge at an enemy by tunneling towards them.
// Any mobs inbetween the tunneler's path and the target will be stunned if the tunneler hits them.
// The target will suffer a stun as well, if the tunneler hits them at the end. A successful hit will stop the tunneler.
// If the target moves fast enough, the tunneler can miss, causing it to overshoot.
// If the tunneler hits a solid wall, the tunneler will suffer a stun.

/mob/living/simple_animal/hostile/giant_spider/tunneler
	desc = "Sandy and brown, it makes you shudder to look at it. This one has glittering yellow eyes."

	icon_state = "tunneler"
	icon_living = "tunneler"
	icon_dead = "tunneler_dead"

	maxHealth = 120
	health = 120

	poison_chance = 15
	poison_per_bite = 3
	poison_type = /datum/reagent/toxin/serotrotium

	// Tunneling is a special attack, similar to the hunter's Leap.
	special_attack_min_range = 2
	special_attack_max_range = 6
	special_attack_cooldown = 10 SECONDS

	/// How long the dig telegraphing is.
	var/tunnel_warning = 0.5 SECONDS
	/// How long to wait between each tile. Higher numbers result in an easier to dodge tunnel attack.
	var/tunnel_tile_speed = 2

/mob/living/simple_animal/hostile/giant_spider/tunneler/frequent
	special_attack_cooldown = 5 SECONDS

/mob/living/simple_animal/hostile/giant_spider/tunneler/fast
	tunnel_tile_speed = 1

/mob/living/simple_animal/hostile/giant_spider/tunneler/should_special_attack(atom/A)
	// Make sure its possible for the spider to reach the target so it doesn't try to go through a window.
	var/turf/destination = get_turf(A)
	var/turf/starting_turf = get_turf(src)
	var/turf/T = starting_turf
	for (var/i = 1 to get_dist(starting_turf, destination))
		if (T == destination)
			break

		T = get_step(T, get_dir(T, destination))
		if (T.density)
			return FALSE
	return T == destination


/mob/living/simple_animal/hostile/giant_spider/tunneler/do_special_attack(atom/A)
	set waitfor = FALSE
	set_AI_busy(TRUE)

	// Save where we're gonna go soon.
	var/turf/destination = get_turf(A)
	var/turf/starting_turf = get_turf(src)

	// Telegraph to give a small window to dodge if really close.
	do_windup_animation(A, tunnel_warning)
	sleep(tunnel_warning) // For the telegraphing.

	// Do the dig!
	visible_message(SPAN_DANGER("\The [src] tunnels towards \the [A]!"))
	submerge()

	if (handle_tunnel(destination) == FALSE)
		set_AI_busy(FALSE)
		emerge()
		return FALSE

	// Did we make it?
	if (!(src in destination))
		set_AI_busy(FALSE)
		emerge()
		return FALSE

	var/overshoot = TRUE

	// Test if something is at destination.
	for (var/mob/living/L in destination)
		if (L == src)
			continue

		visible_message(SPAN_DANGER("\The [src] erupts from underneath, and hits \the [L]!"))
		playsound(src, 'sound/weapons/heavysmash.ogg', 75, 1)
		L.Weaken(3)
		overshoot = FALSE

	if (!overshoot) // We hit the target, or something, at destination, so we're done.
		set_AI_busy(FALSE)
		emerge()
		return TRUE

	// Otherwise we need to keep going.
	to_chat(src, SPAN_WARNING("You overshoot your target!"))
	playsound(src, 'sound/weapons/punchmiss.ogg', 75, 1)
	var/dir_to_go = get_dir(starting_turf, destination)
	for (var/i = 1 to rand(2, 4))
		destination = get_step(destination, dir_to_go)

	handle_tunnel(destination)
	set_AI_busy(FALSE)
	emerge()
	return FALSE



/// Does the tunnel movement, stuns enemies, etc.
/mob/living/simple_animal/hostile/giant_spider/tunneler/proc/handle_tunnel(turf/destination)
	var/turf/T = get_turf(src) // Hold our current tile.

	// Regular tunnel loop.
	for (var/i = 1 to get_dist(src, destination))
		if (stat)
			return FALSE // We died or got knocked out on the way.
		if (loc == destination)
			break // We somehow got there early.

		// Update T.
		T = get_step(src, get_dir(src, destination))
		if (T.density)
			to_chat(src, "<span class='critical'>You hit something really solid!</span>")
			playsound(src, "punch", 75, 1)
			Weaken(5)
			return FALSE // Hit a wall.

		// Stun anyone in our way.
		for (var/mob/living/L in T)
			playsound(src, 'sound/weapons/heavysmash.ogg', 75, 1)
			L.Weaken(2)

		// Get into the tile.
		forceMove(T)

		// Visuals and sound.
		dig_under_floor(get_turf(src))
		playsound(src, 'sound/effects/break_stone.ogg', 75, 1)
		sleep(tunnel_tile_speed)

// For visuals.
/mob/living/simple_animal/hostile/giant_spider/tunneler/proc/submerge()
	alpha = 0
	dig_under_floor(get_turf(src))
	new /obj/effect/temporary/tunneler_hole(get_turf(src), 1 MINUTE)

// Ditto.
/mob/living/simple_animal/hostile/giant_spider/tunneler/proc/emerge()
	alpha = 255
	dig_under_floor(get_turf(src))
	new /obj/effect/temporary/tunneler_hole(get_turf(src), 1 MINUTE)

/mob/living/simple_animal/hostile/giant_spider/tunneler/proc/dig_under_floor(turf/T)
	new /obj/item/ore/glass(T) // This will be rather weird when on station but the alternative is too much work.

/obj/effect/temporary/tunneler_hole
	name = "hole"
	desc = "A collapsing tunnel hole."
	icon_state = "tunnel_hole"
