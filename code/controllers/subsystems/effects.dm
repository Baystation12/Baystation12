var/datum/controller/subsystem/effects/SSeffects

/datum/controller/subsystem/effects
	name = "Effects Master"
	wait = 1		// Deciseconds.
	flags = SS_NO_INIT
	priority = SS_PRIORITY_EFFECTS

	var/list/datum/effect_system/effect_systems = list()	// The effect-spawning objects. Shouldn't be many of these.
	var/list/obj/visual_effect/visuals	= list()	// The visible component of an effect. May be created without an effect object.

	var/tmp/list/processing_effects = list()
	var/tmp/list/processing_visuals = list()

/datum/controller/subsystem/effects/New()
	NEW_SS_GLOBAL(SSeffects)

/datum/controller/subsystem/effects/fire(resumed = FALSE)
	if (!resumed)
		processing_effects = effect_systems
		effect_systems = list()
		processing_visuals = visuals.Copy()

	var/list/current_effects = processing_effects
	var/list/current_visuals = processing_visuals

	// Most of the time these only exist for 1 cycle, so optimize for removal-on-first-fire.
	while (current_effects.len)
		var/datum/effect_system/E = current_effects[current_effects.len]
		current_effects.len--

		if (QDELETED(E) || !E.isprocessing)
			if (MC_TICK_CHECK)
				return
			continue

		STOP_EFFECT(E)
		var/last = E.last_fire
		E.last_fire = world.time
		switch (E.process(world.time - last))
			if (EFFECT_CONTINUE)
				QUEUE_EFFECT(E)

			if (EFFECT_DESTROY)
				qdel(E)

		if (MC_TICK_CHECK)
			return

	// Most often these will be continuing to tick, so assume that we're going to keep poking the effect.
	while (current_visuals.len)
		var/obj/visual_effect/V = current_visuals[current_visuals.len]
		current_visuals.len--

		if (QDELETED(V) || !V.isprocessing)
			visuals -= V
			if (MC_TICK_CHECK)
				return
			continue

		switch (V.tick())
			if (EFFECT_HALT)
				STOP_VISUAL(V)

			if (EFFECT_DESTROY)
				STOP_VISUAL(V)
				qdel(V)
		
		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/effects/stat_entry()
	..("E:[effect_systems.len] V:[visuals.len]")

/datum/controller/subsystem/effects/Recover()
	if (istype(SSeffects))
		src.effect_systems = SSeffects.effect_systems
		src.visuals = SSeffects.visuals

		src.effect_systems |= SSeffects.processing_effects
		src.visuals |= SSeffects.processing_visuals

/datum/effect_system
	var/last_fire
