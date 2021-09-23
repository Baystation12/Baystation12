/datum/psi_complexus

	var/announced = FALSE             // Whether or not we have been announced to our holder yet.
	var/suppressed = TRUE             // Whether or not we are suppressing our psi powers.
	var/use_psi_armour = TRUE         // Whether or not we should automatically deflect/block incoming damage.
	var/rebuild_power_cache = TRUE    // Whether or not we need to rebuild our cache of psi powers.

	var/rating = 0                    // Overall psi rating.
	var/cost_modifier = 1             // Multiplier for power use stamina costs.
	var/stun = 0                      // Number of process ticks we are stunned for.
	var/next_power_use = 0            // world.time minimum before next power use.
	var/stamina = 50                  // Current psi pool.
	var/max_stamina = 50              // Max psi pool.
	var/armor_cost = 0                // Amount of power to substract this tick from psi armor blocking damage

	var/list/latencies                // List of all currently latent faculties.
	var/list/ranks                    // Assoc list of psi faculties to current rank.
	var/list/base_ranks               // Assoc list of psi faculties to base rank, in case reset is needed
	var/list/manifested_items         // List of atoms manifested/maintained by psychic power.
	var/next_latency_trigger = 0      // world.time minimum before a trigger can be attempted again.
	var/last_aura_size
	var/last_aura_alpha
	var/last_aura_color
	var/aura_color = "#ff0022"

	// Cached powers.
	var/list/melee_powers             // Powers used in melee range.
	var/list/grab_powers              // Powers use by using a grab.
	var/list/ranged_powers            // Powers used at range.
	var/list/manifestation_powers     // Powers that create an item.
	var/list/powers_by_faculty        // All powers within a given faculty.

	var/obj/screen/psi/hub/ui	      // Reference to the master psi UI object.
	var/mob/living/owner              // Reference to our owner.
	var/image/_aura_image             // Client image

/datum/psi_complexus/proc/get_aura_image()
	if(_aura_image && !istype(_aura_image))
		var/atom/A = _aura_image
		log_debug("Non-image found in psi complexus: \ref[A] - \the [A] - [istype(A) ? A.type : "non-atom"]")
		destroy_aura_image(_aura_image)
		_aura_image = null
	if(!_aura_image)
		_aura_image = create_aura_image(owner)
	return _aura_image

/proc/create_aura_image(var/newloc)
	var/image/aura_image = image(loc = newloc, icon = 'icons/effects/psi_aura_small.dmi', icon_state = "aura")
	aura_image.blend_mode = BLEND_MULTIPLY
	aura_image.appearance_flags = DEFAULT_APPEARANCE_FLAGS | NO_CLIENT_COLOR | RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM
	aura_image.layer = TURF_LAYER + 0.5
	aura_image.alpha = 0
	aura_image.pixel_x = -64
	aura_image.pixel_y = -64
	aura_image.mouse_opacity = 0
	aura_image.appearance_flags = DEFAULT_APPEARANCE_FLAGS
	for(var/thing in SSpsi.processing)
		var/datum/psi_complexus/psychic = thing
		if(psychic.owner.client && !psychic.suppressed)
			psychic.owner.client.images += aura_image
	SSpsi.all_aura_images[aura_image] = TRUE
	return aura_image

/proc/destroy_aura_image(var/image/aura_image)
	for(var/thing in SSpsi.processing)
		var/datum/psi_complexus/psychic = thing
		if(psychic.owner.client)
			psychic.owner.client.images -= aura_image
	SSpsi.all_aura_images -= aura_image

/datum/psi_complexus/New(var/mob/_owner)
	owner = _owner
	START_PROCESSING(SSpsi, src)
	set_extension(src, /datum/extension/armor/psionic)

/datum/psi_complexus/Destroy()
	destroy_aura_image(_aura_image)
	STOP_PROCESSING(SSpsi, src)
	if(owner)
		cancel()
		if(owner.client)
			owner.client.screen -= list(ui, ui?.components)
			for(var/thing in SSpsi.all_aura_images)
				owner.client.images -= thing
		QDEL_NULL(ui)
		owner.psi = null
		owner = null

	if(manifested_items)
		for(var/thing in manifested_items)
			qdel(thing)
		manifested_items.Cut()
	. = ..()
