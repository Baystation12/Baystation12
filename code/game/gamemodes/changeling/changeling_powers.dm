#define CHANGELING_STASIS_NONE 0
#define CHANGELING_STASIS_WAITING 1
#define CHANGELING_STASIS_READY 2

// READ: Don't use the apostrophe in name or desc. Causes script errors.

/// A list of all changeling power types, minus the base type.
GLOBAL_LIST_INIT(changeling_powers, subtypesof(/datum/power/changeling))
/// A pool of instantiated changeling powers that are added and removed from the changeling datum.
GLOBAL_LIST_EMPTY(changeling_power_instances)
/// A list of absorbed_dna datums present in the "hivemind" for all changelings to access.
GLOBAL_LIST_EMPTY(hivemind_bank)

/// The changeling subtype of /datum/power. Contains a lot of custom logic for chemicals, activation checks, and so on.
/datum/power/changeling
	/// The cost required for the changeling to unlock this power.
	var/genome_cost = 500000
	/// If TRUE, this power will not automatically purchase if it costs zero genomes.
	var/no_autobuy = FALSE

	/// The amount of chem_charges we need to activate this power
	var/required_chems = 0
	/// If we haven't absorbed this many genomes, this power will be unusable
	var/required_dna = 0
	/// If the the genetic_damage of the owner changeling is higher than this amount, we are unable to use the power
	var/max_genetic_damage = 100

	/// If our current mob's STAT is above this, then we cannot use it
	var/max_stat = 0
	/// If TRUE, we can use this ability while incapacitated. FALSE by default
	var/allow_incapacitated = FALSE
	/// Whether or not we can use this ability while in lesser form. FALSE by default
	var/allow_during_lesser_form = FALSE

/// Changeling powers require a carbon user, and check for several specific things such as chemical charges. See the full proc for more details.
/datum/power/changeling/can_activate(mob/living/user)
	if (!mind?.changeling || !iscarbon(mind.current))
		return

	var/mob/living/carbon/current = user
	var/datum/changeling/changeling = mind.changeling

	if (current.isMonkey() && !allow_during_lesser_form)
		to_chat(user, SPAN_WARNING("Our current form is too primitive to do this."))
		return
	if (current.stat > max_stat)
		to_chat(user, SPAN_WARNING("We are incapacitated."))
		return
	if (changeling.absorbed_dna.len < required_dna)
		to_chat(user, SPAN_WARNING("We require at least [required_dna] sample\s of compatible DNA."))
		return
	if (changeling.chem_charges < required_chems)
		to_chat(user, SPAN_WARNING("We require at least [required_chems] unit\s of chemicals to do that!"))
		return
	if (changeling.genetic_damage > max_genetic_damage)
		to_chat(user, SPAN_WARNING("Our genomes are still reassembling. We need time to recover first."))
		return
	if (current.incapacitated() && !allow_incapacitated)
		to_chat(user, SPAN_WARNING("We cannot use this ability in our current state."))
		return

	return TRUE

/datum/power/changeling/pre_activate(mob/living/user)
	mind.changeling.chem_charges = max(0, mind.changeling.chem_charges - required_chems)
	activate(user)


/// The power that changelings use to unlock new abilities. Has no effects on its own.
/datum/power/changeling/evolution_menu
	name = "Evolution Menu"
	desc = "Accesses this menu to spend genome points and grow stronger."
	button_icon_state = "evolution_menu"
	genome_cost = 0
	has_button = TRUE
	max_stat = UNCONSCIOUS
	allow_incapacitated = TRUE
	allow_during_lesser_form = TRUE

/datum/power/changeling/evolution_menu/activate(mob/living/user)
	mind.changeling.EvolutionMenu()

/// One of the three core changeling powers. After holding someone in a kill grab and channeling for long enough, kills them and absorbs their DNA.
/datum/power/changeling/absorb_dna
	name = "Absorb DNA"
	desc = "Permits us to syphon the DNA from a human. They become one with us, and we become stronger."
	button_icon_state = "absorb_dna"
	genome_cost = 0
	has_button = TRUE
	var/stage_time = 15 SECONDS

/datum/power/changeling/absorb_dna/can_activate(mob/living/carbon/human/user)
	. = ..(user)
	if (!istype(user))
		return FALSE
	var/obj/item/grab/G = user.get_active_hand()
	if(!istype(G))
		to_chat(user, SPAN_WARNING("We must be grabbing a creature in our active hand to absorb them."))
		return FALSE

	var/mob/living/carbon/human/T = G.affecting
	if(!istype(T))
		to_chat(user, SPAN_WARNING("\The [T] is not compatible with our biology."))
		return FALSE

	if((T.species.species_flags & SPECIES_FLAG_NO_SCAN) || T.isSynthetic())
		to_chat(user, SPAN_WARNING("We cannot extract DNA from this creature."))
		return FALSE

	if(MUTATION_HUSK in T.mutations)
		to_chat(user, SPAN_WARNING("This creature's DNA is ruined beyond useability!"))
		return FALSE

	if(!G.can_absorb())
		to_chat(user, SPAN_WARNING("We must have a tighter grip to absorb this creature."))
		return FALSE

	if(mind.changeling.is_absorbing)
		to_chat(user, SPAN_WARNING("We are already absorbing \the [T]."))
		return FALSE

	var/obj/item/organ/external/affecting = T.get_organ(user.zone_sel.selecting)
	if(!affecting)
		to_chat(user, SPAN_WARNING("They are missing that body part!"))
		return FALSE

/datum/power/changeling/absorb_dna/activate()
	var/obj/item/grab/G = mind.current.get_active_hand()
	do_absorb(1, G.affecting, G.affecting.get_organ(mind.current.zone_sel.selecting))

/datum/power/changeling/absorb_dna/proc/do_absorb(stage, mob/living/target, obj/item/organ/external/affecting)
	switch (stage)
		if (1)
			to_chat(mind.current, SPAN_NOTICE("This creature is compatible. We must hold still..."))
			to_chat(target, SPAN_WARNING("\The [mind.current] tightens their grip."))
		if (2)
			mind.current.visible_message(
				SPAN_WARNING(SPAN_BOLD("\The [mind.current] extends a proboscis!")),
				SPAN_NOTICE("We extend a proboscis.")
			)
		if (3)
			mind.current.visible_message(
				SPAN_WARNING(SPAN_BOLD("\The [mind.current] stabs \the [target] with the proboscis and begins sucking out their fluids!")),
				SPAN_NOTICE("We stab \the [target] with the proboscis, and begin draining their fluids.")
			)
			if (!target.mind?.changeling)
				to_chat(target, SPAN_DANGER(FONT_LARGE("You feel a sharp, stabbing pain in your \the [affecting.name]. Your mind is exposed to a hundred voices. They want you to join them. Your memories are slowly stripped away like an old bandage as you fight to resist.")))
			else
				to_chat(target, SPAN_DANGER(FONT_LARGE("Abruptly, we are in the presence of another collective. We recoil away as they press their will onto ours. Gradually, our voices begin to go silent as we are drawn away from ourselves.")))
			affecting.take_external_damage(39, 0, DAM_SHARP, "large organic needle")
		if (4)
			chomp(target)
			return
	SSstatistics.add_field_details("changeling_powers", "A[stage]")
	if (!do_after(mind.current, stage_time, target) || !can_activate(mind.current))
		to_chat(mind.current, SPAN_WARNING("Our absorption of \the [target] has been interrupted!"))
		mind.changeling.is_absorbing = FALSE
		return FALSE
	else
		do_absorb(stage + 1, target, affecting)

/datum/power/changeling/absorb_dna/proc/chomp(mob/living/carbon/human/target)
	mind.current.visible_message(
		SPAN_WARNING(SPAN_BOLD("\The [mind.current] sucks the fluids from \the [target]!")),
		SPAN_NOTICE("We have absorbed \the [target]!")
	)
	if (!target.mind?.changeling)
		to_chat(target, SPAN_DANGER(FONT_LARGE("You no longer have the strength to think. Your thoughts meld with the collective as they are consumed in an instant, subsumed into something that has outgrown individuality.")))
	else
		to_chat(target, SPAN_DANGER(FONT_LARGE("We join with another like us. We circle one another in the dark void of a shared mind, and are slowly drawn together, inexorably, until they fall upon us. They descend on us like an insect in a spider's web.")))

	mind.changeling.chem_charges = min(mind.changeling.chem_storage, mind.changeling.chem_charges + 10)
	mind.changeling.genetic_points += 2

	//Steal all of their languages!
	for(var/language in target.languages)
		if(!(language in mind.changeling.absorbed_languages))
			mind.changeling.absorbed_languages += language

	mind.changeling.update_languages(mind.changeling.absorbed_languages)

	var/datum/absorbed_dna/newDNA = new(target.real_name, target.dna, target.species.name, target.languages)
	mind.changeling.absorb_DNA(newDNA)

	if(target.mind)
		var/datum/mind/M = target.mind
		M.CopyMemories(mind)
		if(M.changeling)
			to_chat(mind.current, SPAN_NOTICE(SPAN_ITALIC("We draw the other collective into our mind. We circle one another in the dark of ourselves, until we are drawn together, and we feast. Afterwards, we emerge, fat with new memories.")))
			if(M.changeling.absorbed_dna)
				for(var/datum/absorbed_dna/dna_data in M.changeling.absorbed_dna) //steal all their loot
					if (mind.changeling.get_DNA(dna_data.name))
						continue
					mind.changeling.absorb_DNA(dna_data)
					mind.changeling.absorbed_count++
				M.changeling.absorbed_dna.len = 1

			if(M.changeling.purchased_powers)
				for(var/datum/power/changeling/C in M.changeling.purchased_powers)
					if(C in mind.changeling.purchased_powers)
						continue
					else
						mind.changeling.add_power(C, mind, TRUE)

			mind.changeling.chem_charges += M.changeling.chem_charges
			mind.changeling.genetic_points += M.changeling.genetic_points
			M.changeling.chem_charges = 0
			M.changeling.genetic_points = 0
			M.changeling.absorbed_count = 0
		else
			to_chat(mind.current, SPAN_NOTICE(SPAN_ITALIC("We draw \the [target]'s personality into ourselves. They are confused, and frightened. When we call out, they come to us. We assimilate them into our collective, and become one.")))
	else
		to_chat(mind.current, SPAN_NOTICE(SPAN_ITALIC("There is little sapience in the mind of \the [target]. We draw them into our collective with little resistance.")))

	mind.changeling.absorbed_count++
	mind.changeling.is_absorbing = FALSE

	target.death(0)
	target.Drain()


/// One of the three core changeling abilities. Transforms the changeling into a simulacrum of a genome they've absorbed.
/datum/power/changeling/transform
	name = "Transform"
	desc = "We take on the apperance and voice of one we have absorbed."
	helptext = "We will become indistinguishable from the absorbed individual, down to their very genetics. We must wait for some time between transformations."
	button_icon_state = "wiz_hulk"
	genome_cost = 0
	required_chems = 5
	required_dna = 1
	max_genetic_damage = 0
	allow_during_lesser_form = TRUE
	has_button = TRUE
	/// The genome we want to transform into. We cache this because it's selected in can_activate(), but used in activate() to avoid deducting chems on cancelling
	var/datum/absorbed_dna/chosen_dna

/datum/power/changeling/transform/can_activate(mob/living/user)
	. = ..()
	if (.)
		var/list/names = list()
		for(var/datum/absorbed_dna/DNA in mind.changeling.absorbed_dna)
			names += "[DNA.name]"

		var/S = input(user, "Select the target DNA.", "Target DNA", null) as null|anything in names
		if(!S)
			return FALSE

		chosen_dna = mind.changeling.get_DNA(S)
		if(!chosen_dna)
			return FALSE

/datum/power/changeling/transform/activate(mob/living/user)
	if(!chosen_dna)
		return

	mind.changeling.genetic_damage = 30

	var/S_name = chosen_dna.speciesName
	var/datum/species/S_dat = all_species[S_name]
	var/changeTime = 2 SECONDS

	if(user.mob_size != S_dat.mob_size)
		user.visible_message(
			SPAN_WARNING("\The [user]'s body begins to twist, their mass changing rapidly!"),
			SPAN_WARNING("We begin to transform, changing our body's size to accommodate our new form.")
		)
		changeTime = 8 SECONDS
	else
		user.visible_message(
			SPAN_WARNING("\The [user]'s body begins to twist, changing rapidly!"),
			SPAN_WARNING("We begin to transform.")
		)

	if(!do_after(user, changeTime) || !chosen_dna)
		to_chat(user, SPAN_WARNING("We fail to change shape."))
		return

	mind.changeling.do_transform(mind, chosen_dna)
	mind.changeling.update_languages(mind.changeling.absorbed_languages)
	chosen_dna = null

	SSstatistics.add_field_details("changeling_powers", "TR")


/// One of the three core changeling abilities. Enters a fake death state that can end with a full regeneration, up to and including actual death.
/datum/power/changeling/regenerative_stasis
	name = "Regenerative Stasis"
	desc = "We become weakened to a death-like state, where we will rise again from death."
	helptext = "Can be used before or after death. Duration varies greatly."
	button_icon_state = "heal_revoke"
	genome_cost = 0
	required_chems = 20
	required_dna = 1
	allow_during_lesser_form = TRUE
	allow_incapacitated = TRUE
	has_button = TRUE
	max_stat = DEAD
	var/state = 0 // 0 = not used; 1 = regenerating; 2 = ready to activate
	var/stasis_timer_id

/datum/power/changeling/regenerative_stasis/can_activate(mob/living/user)
	. = ..(user)
	if (.)
		if (state == CHANGELING_STASIS_WAITING)
			to_chat(user, SPAN_WARNING("We are still gathering our strength."))
			return FALSE
		else if (user.stat != DEAD && !state)
			if (alert(user, "Are we sure we wish to fake our own death?", name, "Yes", "No") == "No")
				return FALSE

/datum/power/changeling/regenerative_stasis/activate(mob/living/user)
	if (!state)
		to_chat(user, SPAN_NOTICE("We enter stasis, and begin to gather our energy. We will attempt to regenerate our form..."))
		user.status_flags |= FAKEDEATH
		user.UpdateLyingBuckledAndVerbStatus()
		state = CHANGELING_STASIS_WAITING
		addtimer(CALLBACK(src, .proc/make_ready, user), rand(800, 2000))
	else // No need to check for (state == 2) here due to logic in can_activate()
		var/mob/living/carbon/C = user
		if (C.stat == DEAD)
			to_chat(C, SPAN_NOTICE("We rise from death."))
		else
			to_chat(C, SPAN_NOTICE("We regenerate our wounds, and rise from our stasis."))
		// restore us to health
		C.revive()
		// remove our fake death flag
		C.status_flags &= ~(FAKEDEATH)
		// let us move again
		C.UpdateLyingBuckledAndVerbStatus()
		// re-add out changeling powers
		C.make_changeling()
		state = CHANGELING_STASIS_NONE
		// refresh ability master icons
		C.ability_master?.update_spells(0)
	SSstatistics.add_field_details("changeling_powers", "FD")

/datum/power/changeling/regenerative_stasis/is_active()
	return state

/datum/power/changeling/regenerative_stasis/proc/make_ready(mob/living/user)
	if (user && state != 2)
		var/mob/the_collective = find_dead_player(LAST_CKEY(user), TRUE) // Try and catch a ghost if we can
		if (!the_collective)
			the_collective = user // Backup for if we're still alive
		to_chat(the_collective, SPAN_NOTICE(FONT_LARGE("We are ready to rise! Re-use Regenerative Stasis when you are ready to return to life.")))
		sound_to(the_collective, sound('sound/effects/wind/spooky1.ogg'))
		state = CHANGELING_STASIS_READY


/// Allows the changeling to share an absorbed_dna datum with other changelings by putting it into a shared list.
/datum/power/changeling/hive_upload
	name = "Hive Channel"
	desc = "We can channel a DNA into our shared link, allowing our fellow changelings to absorb it and transform into it as if they acquired the DNA themselves."
	helptext = "Allows other changelings to absorb the DNA you channel from the airwaves. Will not help them towards their absorb objectives."
	button_icon_state = "gen_project" // {PH}
	required_chems = 10
	required_dna = 1
	genome_cost = 0
	has_button = TRUE
	var/datum/absorbed_dna/chosen_dna

/datum/power/changeling/hive_upload/can_activate(mob/living/user)
	. = ..(user)
	if (.)
		var/list/names = list()
		for(var/datum/absorbed_dna/DNA in mind.changeling.absorbed_dna)
			var/valid = TRUE
			for(var/datum/absorbed_dna/DNB in GLOB.hivemind_bank)
				if(DNA.name == DNB.name)
					valid = FALSE
					break
			if(valid)
				names += DNA.name
		if(!names.len)
			to_chat(user, SPAN_NOTICE("Our shared link already have all of our DNA."))
			return FALSE

		var/S = input(user, "Select a DNA to channel.", "Channel DNA", null) as null|anything in names
		if(!S)
			return FALSE

		chosen_dna = mind.changeling.get_DNA(S)
		if(!chosen_dna)
			return FALSE

		var/datum/species/spec = all_species[chosen_dna.speciesName]
		if(spec && spec.species_flags & SPECIES_FLAG_NEED_DIRECT_ABSORB)
			to_chat(user, SPAN_NOTICE("That species must be absorbed directly."))
			return FALSE

/datum/power/changeling/hive_upload/activate(mob/living/user)
	GLOB.hivemind_bank += chosen_dna
	to_chat(user, SPAN_NOTICE("We channel the genetic sequence of \the [chosen_dna.name] into the hive."))
	SSstatistics.add_field_details("changeling_powers", "HU")


/// Used to "download" DNA from the shared bank that Hive Channel adds to.
/datum/power/changeling/hive_download
	name = "Hive Absorb"
	desc = "We can absorb a single DNA from the hive, allowing us to use more disguises with help from our fellow changelings."
	helptext = "Allows you to absorb a single DNA and use it. Does not count towards your absorb objective."
	button_icon_state = "gen_rmind" // {PH}
	required_chems = 20
	required_dna = 1
	genome_cost = 0
	has_button = TRUE
	var/datum/absorbed_dna/chosen_dna

/datum/power/changeling/hive_download/can_activate(mob/living/user)
	. = ..(user)
	if (.)
		var/list/names = list()
		for(var/datum/absorbed_dna/DNA in GLOB.hivemind_bank)
			if(!(mind.changeling.get_DNA(DNA.name)))
				names[DNA.name] = DNA

		if(!names.len)
			to_chat(user, SPAN_NOTICE("There's no new DNA to absorb from the hive."))
			return FALSE

		var/S = input(user, "Select a DNA absorb from the air.", "Absorb DNA", null) as null|anything in names
		if(!S)
			return FALSE
		chosen_dna = names[S]
		if(!chosen_dna)
			return FALSE

/datum/power/changeling/hive_download/activate(mob/living/user)
	mind.changeling.absorb_DNA(chosen_dna)
	to_chat(user, SPAN_NOTICE("We absorb the genetic sequence of \the [chosen_dna.name] from the hive."))
	SSstatistics.add_field_details("changeling_powers", "HD")


/// Dummy changeling sting type. Has no effects on its own, but contains all the logic required for a sting.
/datum/power/changeling/sting
	name = "Dummy Sting"
	desc = "If you see this, you're a dummy! No, just kidding. It's a bug, so report this if this is visible to you."
	has_button = TRUE
	button_icon_state = "sting_base"
	var/stealthy = TRUE // If TRUE, the target will receive no indication that they've been stung
	var/mob/living/carbon/human/target
	var/obj/item/organ/external/target_limb

/datum/power/changeling/sting/can_activate(mob/living/user)
	. = ..(user)
	if (.)
		var/list/victims = list()
		for	(var/mob/living/carbon/human/C in oview(mind.changeling.sting_range))
			victims += C
		if (!victims.len)
			to_chat(user, SPAN_WARNING("There are no valid targets in range."))
			return FALSE

		var/mob/living/carbon/human/T = input(user, "Who will we sting?") as null|anything in victims

		if (!T)
			return FALSE
		var/obj/item/organ/external/affecting = T.get_organ(user.zone_sel.selecting)
		if (!affecting)
			to_chat(user, SPAN_WARNING("\The [T] is missing that limb."))
			return FALSE
		if (T.isSynthetic())
			to_chat(user, SPAN_WARNING("\The [T] is synthetic."))
			return FALSE
		if (BP_IS_ROBOTIC(affecting))
			to_chat(user, SPAN_WARNING("\The [T]'s [affecting.name] appears to be robotic. We must target a different limb."))
			return FALSE
		if (!(T in view(mind.changeling.sting_range)))
			return FALSE
		if (!user.sting_can_reach(T, mind.changeling.sting_range))
			return FALSE

		target = T
		target_limb = affecting

/datum/power/changeling/sting/activate(mob/living/user)
	if (!target)
		return
	mind.changeling.sting_range = 1
	if(stealthy)
		to_chat(user, SPAN_NOTICE("We stealthily sting \the [target]."))
	else
		user.visible_message(
			SPAN_WARNING("[user] fires an organic shard at \the [target]!"),
			SPAN_WARNING("We fire an organic shard at \the [target]!")
		)

	admin_attack_log(user, target, "Stung their victim using [name]", "Was stung using [name]", "stung using [name]")

	for(var/obj/item/clothing/clothes in list(target.head, target.wear_mask, target.wear_suit, target.w_uniform, target.gloves, target.shoes))
		if(istype(clothes) && (clothes.body_parts_covered & target_limb.body_part) && (clothes.item_flags & ITEM_FLAG_THICKMATERIAL))
			to_chat(src, SPAN_WARNING("Our sting deflects off of \the [target]'s armor."))
			if (!stealthy)
				target.visible_message(
					SPAN_DANGER("The organic shard deflects off of \the [target]'s armor!"),
					SPAN_DANGER("Your armor deflects the organic shard!")
				)
			return //thick clothes will protect from the sting

	if (!stealthy)
		target.visible_message(
			SPAN_DANGER("The organic shard embeds itself into \the [target]!"),
			SPAN_DANGER("The organic shard embeds itself into your [target_limb.name]!")
		)
	sting_effects()
	user.ability_master?.update_spells(0) // To clear the "active" icon from Boost Range if we have it
	target = null
	target_limb = null

/datum/power/changeling/sting/proc/sting_effects()
	return


/// Causes deafness in a target for 15 ticks.
/datum/power/changeling/sting/deaf_sting
	name = "Deaf Sting"
	desc = "We silently sting a human, completely deafening them for a short time."
	helptext = "They will not know it was us, but they will be immediately aware that they have been stung."
	button_icon_state = "deaf_sting"
	required_chems = 5
	genome_cost = 1
	allow_during_lesser_form = TRUE

/datum/power/changeling/sting/deaf_sting/sting_effects()
	to_chat(target, SPAN_WARNING("Your ears pop and begin ringing loudly!"))
	target.ear_deaf += 15
	SSstatistics.add_field_details("changeling_powers", "DS")


/// Causes blindness in a target for 10 ticks, blurriness for 20 ticks, and nearsightedness for 30 ticks.
/datum/power/changeling/sting/blind_sting
	name = "Blind Sting"
	desc = "We silently sting a human, completely blinding them for a short time."
	helptext = "They will not know it was us, but their immediate blindness will likely be cause for alarm."
	button_icon_state = "blind_sting"
	required_chems = 20
	genome_cost = 2
	allow_during_lesser_form = TRUE

/datum/power/changeling/sting/blind_sting/sting_effects()
	to_chat(target, SPAN_WARNING("Your eyes burn horrifically!"))
	target.eye_blind += 10
	target.eye_blurry += 20
	target.disabilities |= NEARSIGHTED
	addtimer(CALLBACK(src, .proc/unblind, target), 30 SECONDS)
	SSstatistics.add_field_details("changeling_powers", "BS")

/datum/power/changeling/sting/blind_sting/proc/unblind(mob/living/carbon/human/target)
	if (target)
		target.disabilities &= ~NEARSIGHTED


/// Silences a target for 30 seconds.
/datum/power/changeling/sting/silence_sting
	name = "Silence Sting"
	desc = "We silently sting a human, completely silencing them for a short time."
	helptext = "Does not provide a warning to a victim that they have been stung, until they try to speak and cannot."
	button_icon_state = "silence_sting"
	required_chems = 10
	genome_cost = 3
	allow_during_lesser_form = TRUE

/datum/power/changeling/sting/silence_sting/sting_effects()
	target.silent += 30
	SSstatistics.add_field_details("changeling_powers", "SS")


/// Extracts the DNA from a target, giving the changeling their DNA as a disguise without gaining any genome points.
/datum/power/changeling/sting/extract_dna
	name = "Extract DNA"
	desc = "We stealthily sting a target and extract the DNA from them."
	helptext = "Will give you the DNA of your target, allowing you to transform into them. Does not count towards absorb objectives, and grants no genome points."
	button_icon_state = "dna_sting"
	required_chems = 40
	genome_cost = 2
	allow_during_lesser_form = TRUE

/datum/power/changeling/sting/extract_dna/sting_effects()
	if ((MUTATION_HUSK in target.mutations) || (target.species.species_flags & SPECIES_FLAG_NO_SCAN))
		to_chat(mind.current, SPAN_WARNING("We cannot extract DNA from this creature!"))
		return 0

	if (target.species.species_flags & SPECIES_FLAG_NEED_DIRECT_ABSORB)
		to_chat(mind.current, SPAN_WARNING("This species must be absorbed directly."))
		return

	var/datum/absorbed_dna/newDNA = new(target.real_name, target.dna, target.species.name, target.languages)
	mind.changeling.absorb_DNA(newDNA)
	to_chat(mind.current, SPAN_NOTICE("We obtain a sample of \the [target.real_name]'s genetic sequence."))

	SSstatistics.add_field_details("changeling_powers", "ED")


/// Causes heavy hallucinations after a short delay.
/datum/power/changeling/sting/hallucination_sting
	name = "Hallucination Sting"
	desc = "We evolve the ability to sting a target with a powerful hallucinatory chemicals."
	helptext = "The target does not notice they have been stung. The effect occurs after 30 to 60 seconds."
	button_icon_state = "hallucination_sting"
	required_chems = 15
	genome_cost = 3

/datum/power/changeling/sting/hallucination_sting/sting_effects()
	addtimer(CALLBACK(src, .proc/good_stuff, target), rand(30 SECONDS, 60 SECONDS))
	SSstatistics.add_field_details("changeling_powers", "HS")

/datum/power/changeling/sting/hallucination_sting/proc/good_stuff(mob/living/carbon/human/victim)
	if (victim)
		victim.hallucination(400, 80)


/// Injects someone with a massive dose of lexorin.
/datum/power/changeling/sting/death_sting
	name = "Death Sting"
	desc = "We sting a human, filling them with a potent nerve agent. While it may cause maiming or even rapid death, our crime will be obvious."
	helptext = "It will be clear to any surrounding witnesses if you use this power."
	button_icon_state = "death_sting"
	required_chems = 40
	genome_cost = 10
	stealthy = FALSE

/datum/power/changeling/sting/death_sting/sting_effects()
	to_chat(target, SPAN_DANGER("You feel a lance of pain and your chest becomes tight."))
	target.make_jittery(400)
	if(target.reagents)
		target.reagents.add_reagent(/datum/reagent/lexorin, 40)
	SSstatistics.add_field_details("changeling_powers", "DS")


/// Allows the changeling to mimic any voice they choose. Very fun!
/datum/power/changeling/mimic_voice
	name = "Mimic Voice"
	desc = "We shape our vocal glands to sound like a desired voice."
	helptext = "Will turn your voice into the name that you enter. We must constantly expend chemicals to maintain our form like this."
	button_icon_state = "forgery" // {PH}?
	genome_cost = 1
	allow_incapacitated = TRUE
	has_button = TRUE

	/// The current amount of process ticks we've had. At 4, we consume a chem charge.
	var/consumption_tick = 0

/datum/power/changeling/mimic_voice/activate(mob/living/user)
	if (mind.changeling.mimicing)
		to_chat(user, SPAN_NOTICE("We return our voice to normal."))
		mind.changeling.mimicing = null
		STOP_PROCESSING(SSobj, src)
		return
	var/mimic_voice = sanitize(input(usr, "Enter a name to mimic.", "Mimic Voice", null) as null|text, MAX_NAME_LEN)
	if(!mimic_voice)
		return
	mind.changeling.mimicing = mimic_voice
	to_chat(user, SPAN_NOTICE("We shape our throat and vocal cords to mimic the voice of <b>[mimic_voice]</b>."))
	to_chat(user, SPAN_NOTICE("We will slowly lose chemicals while doing this. Activate the ability again to return to normal."))
	START_PROCESSING(SSobj, src)

/datum/power/changeling/mimic_voice/is_active()
	return mind.changeling?.mimicing

/datum/power/changeling/mimic_voice/Process()
	consumption_tick++
	if (consumption_tick >= 4) // Subtract a chem charge every 4 ticks. If upgraded regen has been taken, they will slowly outpace it, but not by much!
		mind.changeling.chem_charges--
		consumption_tick = 0


/// Turns the changeling into a monkey. They're able to revert back after a short period.
/datum/power/changeling/lesser_form
	name = "Lesser Form"
	desc = "We debase ourselves and become lesser.  We become a monkey."
	helptext = "We will be able to crawl through vents and other pipes while wearing nothing in this form. We will need to Transform to turn back."
	button_icon_state = "lesser_form"
	required_chems = 1
	genome_cost = 4
	allow_incapacitated = TRUE
	has_button = TRUE

/datum/power/changeling/lesser_form/can_activate(mob/living/user)
	var/mob/living/carbon/human/H = user
	if (!istype(H))
		return FALSE
	if (H.isMonkey()) // Give a warning if they try to use it while existing as a monkey, just so they know
		to_chat(user, SPAN_WARNING("Use your Transform ability to exit this form."))
		return FALSE
	. = ..(user)
	if (.)
		if (H.has_brain_worms())
			to_chat(user, SPAN_WARNING("We cannot use this ability at the present time!"))
			return FALSE
		else if (!H.species.primitive_form)
			to_chat(user, SPAN_WARNING("We cannot revert to a lesser body in this form!"))
			return FALSE
		else if (alert(H, "Are you sure you want to enter a Lesser Form?", name, "Yes", "No") != "Yes") // And finally a confirmation prompt
			return FALSE

/datum/power/changeling/lesser_form/activate(mob/living/user)
	var/mob/living/carbon/human/H = user
	H.visible_message(
		SPAN_WARNING(SPAN_BOLD("\The [H] suddenly shrinks, shedding their belongings as they transform!")),
		SPAN_WARNING("Our genes cry out as we adopt a primitive form!")
	)
	mind.changeling.genetic_damage = 30
	H = H.monkeyize()
	SSstatistics.add_field_details("changeling_powers", "LF")


/// Boosts the range of the next sting by one tile.
/datum/power/changeling/boost_range
	name = "Boost Range"
	desc = "We evolve the ability to shoot our stingers at humans, with some preperation."
	button_icon_state = "boost_sting"
	required_chems = 10
	genome_cost = 2
	allow_during_lesser_form = TRUE
	allow_incapacitated = TRUE
	has_button = TRUE

/datum/power/changeling/boost_range/can_activate(mob/living/user)
	. = ..(user)
	if (. && mind.changeling.sting_range > 1)
		to_chat(user, SPAN_WARNING("We are already prepared to launch our next sting."))
		return FALSE

/datum/power/changeling/boost_range/activate(mob/living/user)
	to_chat(user, SPAN_NOTICE("Our throat adjusts itself to launch our next stinger."))
	mind.changeling.sting_range = 2
	SSstatistics.add_field_details("changeling_powers", "RS")

/datum/power/changeling/boost_range/is_active()
	return mind.changeling?.sting_range > 1


/// Immediately removes all stuns and wakes us up if we're unconscious.
/datum/power/changeling/epinephrine_sacs
	name = "Epinephrine Sacs"
	desc = "We evolve additional sacs of adrenaline throughout our body."
	helptext = "Gives the ability to instantly recover from stuns.  High chemical cost."
	button_icon_state = "epinephrine_sacs"
	required_chems = 45
	genome_cost = 3
	allow_incapacitated = TRUE
	max_stat = UNCONSCIOUS
	has_button = TRUE

/datum/power/changeling/epinephrine_sacs/activate(mob/living/user)
	var/mob/living/carbon/human/C = user
	C.set_stat(CONSCIOUS)
	C.SetParalysis(0)
	C.SetStunned(0)
	C.SetWeakened(0)
	C.sleeping = 0
	C.lying = FALSE
	C.UpdateLyingBuckledAndVerbStatus()
	to_chat(C, SPAN_NOTICE("Stimulants pour into our blood. Energy pumps through us, and we rise."))
	SSstatistics.add_field_details("changeling_powers", "UNS")


/// Passive, doubles natural chem regen. At time of writing, this means it goes from 0.5 to 1.
/datum/power/changeling/rapid_chemical_synthesis
	name = "Rapid Chemical-Synthesis"
	desc = "We evolve new pathways for producing our necessary chemicals, permitting us to naturally create them faster."
	helptext = "Doubles the rate at which we naturally recharge chemicals."
	genome_cost = 4

/datum/power/changeling/rapid_chemical_synthesis/on_add()
	to_chat(mind.current, SPAN_NOTICE("New chemical vessels carve themselves into our flesh."))
	mind.changeling.chem_recharge_rate *= 2

/datum/power/changeling/rapid_chemical_synthesis/on_remove()
	to_chat(mind.current, SPAN_WARNING("Some of our chemical vessels shrink tightly, then close."))
	mind.changeling.chem_recharge_rate *= 0.5


/// Passive, boosts chem storage by 25 points.
/datum/power/changeling/engorged_chemical_glands
	name = "Engorged Chemical Glands"
	desc = "Our chemical glands swell, permitting us to store more chemicals inside of them."
	helptext = "Allows us to store an extra 25 units of chemicals."
	genome_cost = 4

/datum/power/changeling/engorged_chemical_glands/on_add()
	to_chat(mind.current, SPAN_NOTICE("Our chemical glands bloat with new mass."))
	mind.changeling.chem_storage += 25

/datum/power/changeling/engorged_chemical_glands/on_remove()
	to_chat(mind.current, SPAN_WARNING("Our chemical glands shrink."))
	mind.changeling.chem_storage -= 25


/// Makes you untrackable by AI, but gives you unique examine text. Free because the AI currently doesn't exist, making this primarily for RPing.
/datum/power/changeling/digital_camouflage
	name = "Digital Camouflage"
	desc = "We evolve the ability to distort our form and proprtions, defeating common algorithms used by AI to track lifeforms on cameras."
	helptext = "We cannot be tracked by any AIs while using this skill.  However, humans looking at us will find us... uncanny."
	button_icon_state = "digital_camouflage"
	has_button = TRUE
	genome_cost = 0
	no_autobuy = TRUE
	allow_during_lesser_form = TRUE

/datum/power/changeling/digital_camouflage/activate(mob/living/user)
	user.digitalcamo = !user.digitalcamo
	if (user.digitalcamo)
		to_chat(user, SPAN_NOTICE("We distort our form to prevent AI tracking."))
	else
		to_chat(user, SPAN_NOTICE("We return our form to normal."))

/datum/power/changeling/digital_camouflage/is_active()
	return mind.current.digitalcamo


/// Heals 10 of brute/fire/tox/oxy damage per second for 10 seconds. Can't be "restarted" while it's already active. (unintentional?)
/datum/power/changeling/rapid_regeneration
	name = "Rapid Regeneration"
	desc = "We evolve the ability to rapidly regenerate, negating the need for stasis."
	helptext = "Heals a moderate amount of damage every tick."
	button_icon_state = "rapid_regeneration"
	genome_cost = 7
	required_chems = 30
	max_stat = UNCONSCIOUS
	allow_incapacitated = TRUE
	has_button = TRUE
	var/active_ticks = 0

/datum/power/changeling/rapid_regeneration/can_activate(mob/living/user)
	. = ..(user)
	if (. && active_ticks)
		to_chat(user, SPAN_WARNING("We are already regenerating."))
		return FALSE

/datum/power/changeling/rapid_regeneration/activate(mob/living/user)
	to_chat(user, SPAN_NOTICE("We feel our flesh churn beneath our skin as we begin to regenerate our injuries."))
	active_ticks = 10
	do_regen(user)
	SSstatistics.add_field_details("changeling_powers", "RR")
	return TRUE

/datum/power/changeling/rapid_regeneration/is_active()
	return active_ticks

/datum/power/changeling/rapid_regeneration/proc/do_regen(mob/living/carbon/human/H)
	if (!istype(H))
		active_ticks = 0
		return
	active_ticks--
	H.adjustBruteLoss(-10)
	H.adjustToxLoss(-10)
	H.adjustOxyLoss(-10)
	H.adjustFireLoss(-10)
	H.playsound_local(H, 'sound/effects/singlebeat.ogg', 50, FALSE, is_global = TRUE) // Audio feedback to highlight each regen tick
	if (active_ticks)
		addtimer(CALLBACK(src, .proc/do_regen, H), 1 SECONDS) // Repeat every second until we're fully regenerated
	else
		to_chat(H, SPAN_NOTICE("We have finished regenerating."))
		H.ability_master?.update_spells(0) // Immediately refresh icons to turn off the "active" overlay



/// The code for the menu that the changeling uses to unlock new abilities. Totally stolen from the player panel.
/datum/changeling/proc/EvolutionMenu()//The new one
	set name = "Evolution Menu"
	set category = "Changeling"
	set desc = "Level up!"

	if(!usr || !usr.mind || !usr.mind.changeling)	return
	src = usr.mind.changeling

	if(!LAZYLEN(GLOB.changeling_power_instances))
		for(var/P in GLOB.changeling_powers)
			GLOB.changeling_power_instances += new P()

	var/dat = "<html><head><title>Changeling Evolution Menu</title></head>"

	//javascript, the part that does most of the work~
	dat += {"

		<head>
			<script type='text/javascript'>

				var locked_tabs = new Array();

				function updateSearch(){


					var filter_text = document.getElementById('filter');
					var filter = filter_text.value.toLowerCase();

					if(complete_list != null && complete_list != ""){
						var mtbl = document.getElementById("maintable_data_archive");
						mtbl.innerHTML = complete_list;
					}

					if(filter.value == ""){
						return;
					}else{

						var maintable_data = document.getElementById('maintable_data');
						var ltr = maintable_data.getElementsByTagName("tr");
						for ( var i = 0; i < ltr.length; ++i )
						{
							try{
								var tr = ltr\[i\];
								if(tr.getAttribute("id").indexOf("data") != 0){
									continue;
								}
								var ltd = tr.getElementsByTagName("td");
								var td = ltd\[0\];
								var lsearch = td.getElementsByTagName("b");
								var search = lsearch\[0\];
								//var inner_span = li.getElementsByTagName("span")\[1\] //Should only ever contain one element.
								//document.write("<p>"+search.innerText+"<br>"+filter+"<br>"+search.innerText.indexOf(filter))
								if ( search.innerText.toLowerCase().indexOf(filter) == -1 )
								{
									//document.write("a");
									//ltr.removeChild(tr);
									td.innerHTML = "";
									i--;
								}
							}catch(err) {   }
						}
					}

					var count = 0;
					var index = -1;
					var debug = document.getElementById("debug");

					locked_tabs = new Array();

				}

				function expand(id,name,desc,helptext,power,ownsthis){

					clearAll();

					var span = document.getElementById(id);

					body = "<table><tr><td>";

					body += "</td><td align='center'>";

					body += "<font size='2'><b>"+desc+"</b></font> <BR>"

					body += "<font size='2'><font color = 'red'><b>"+helptext+"</b></font></font><BR>"

					if(!ownsthis)
					{
						body += "<a href='?src=\ref[src];P="+power+"'>Evolve</a>"
					}

					body += "</td><td align='center'>";

					body += "</td></tr></table>";


					span.innerHTML = body
				}

				function clearAll(){
					var spans = document.getElementsByTagName('span');
					for(var i = 0; i < spans.length; i++){
						var span = spans\[i\];

						var id = span.getAttribute("id");

						if(!(id.indexOf("item")==0))
							continue;

						var pass = 1;

						for(var j = 0; j < locked_tabs.length; j++){
							if(locked_tabs\[j\]==id){
								pass = 0;
								break;
							}
						}

						if(pass != 1)
							continue;




						span.innerHTML = "";
					}
				}

				function addToLocked(id,link_id,notice_span_id){
					var link = document.getElementById(link_id);
					var decision = link.getAttribute("name");
					if(decision == "1"){
						link.setAttribute("name","2");
					}else{
						link.setAttribute("name","1");
						removeFromLocked(id,link_id,notice_span_id);
						return;
					}

					var pass = 1;
					for(var j = 0; j < locked_tabs.length; j++){
						if(locked_tabs\[j\]==id){
							pass = 0;
							break;
						}
					}
					if(!pass)
						return;
					locked_tabs.push(id);
					var notice_span = document.getElementById(notice_span_id);
					notice_span.innerHTML = "<font color='red'>Locked</font> ";
					//link.setAttribute("onClick","attempt('"+id+"','"+link_id+"','"+notice_span_id+"');");
					//document.write("removeFromLocked('"+id+"','"+link_id+"','"+notice_span_id+"')");
					//document.write("aa - "+link.getAttribute("onClick"));
				}

				function attempt(ab){
					return ab;
				}

				function removeFromLocked(id,link_id,notice_span_id){
					//document.write("a");
					var index = 0;
					var pass = 0;
					for(var j = 0; j < locked_tabs.length; j++){
						if(locked_tabs\[j\]==id){
							pass = 1;
							index = j;
							break;
						}
					}
					if(!pass)
						return;
					locked_tabs\[index\] = "";
					var notice_span = document.getElementById(notice_span_id);
					notice_span.innerHTML = "";
					//var link = document.getElementById(link_id);
					//link.setAttribute("onClick","addToLocked('"+id+"','"+link_id+"','"+notice_span_id+"')");
				}

				function selectTextField(){
					var filter_text = document.getElementById('filter');
					filter_text.focus();
					filter_text.select();
				}

			</script>
		</head>


	"}

	//body tag start + onload and onkeypress (onkeyup) javascript event calls
	dat += "<body onload='selectTextField(); updateSearch();' onkeyup='updateSearch();'>"

	//title + search bar
	dat += {"

		<table width='560' align='center' cellspacing='0' cellpadding='5' id='maintable'>
			<tr id='title_tr'>
				<td align='center'>
					<font size='5'><b>Changeling Evolution Menu</b></font><br>
					Hover over a power to see more information<br>
					Current evolution points left to evolve with: [genetic_points]<br>
					Absorb genomes to acquire more evolution points
					<p>
				</td>
			</tr>
			<tr id='search_tr'>
				<td align='center'>
					<b>Search:</b> <input type='text' id='filter' value='' style='width:300px;'>
				</td>
			</tr>
	</table>

	"}

	//player table header
	dat += {"
		<span id='maintable_data_archive'>
		<table width='560' align='center' cellspacing='0' cellpadding='5' id='maintable_data'>"}

	var/i = 1
	for(var/datum/power/changeling/P in GLOB.changeling_power_instances)
		if (P.type == /datum/power/changeling/sting) // This is disgusting.
			continue
		var/ownsthis = 0

		if(P in purchased_powers)
			ownsthis = 1


		var/color = "#e6e6e6"
		if(i%2 == 0)
			color = "#f2f2f2"


		dat += {"

			<tr id='data[i]' name='[i]' onClick="addToLocked('item[i]','data[i]','notice_span[i]')">
				<td align='center' bgcolor='[color]'>
					<span id='notice_span[i]'></span>
					<a id='link[i]'
					onmouseover='expand("item[i]","[P.name]","[P.desc]","[P.helptext]","[P]",[ownsthis])'
					>
					<span id='search[i]'><b>Evolve [P] - Cost: [ownsthis ? "Purchased" : P.genome_cost]</b></span>
					</a>
					<br><span id='item[i]'></span>
				</td>
			</tr>

		"}

		i++


	//player table ending
	dat += {"
		</table>
		</span>

		<script type='text/javascript'>
			var maintable = document.getElementById("maintable_data_archive");
			var complete_list = maintable.innerHTML;
		</script>
	</body></html>
	"}

	show_browser(usr, dat, "window=powers;size=900x480")


/datum/changeling/Topic(href, href_list)
	..()
	if(!ismob(usr))
		return

	if(href_list["P"])
		var/datum/mind/M = usr.mind
		if(!istype(M))
			return
		purchasePower(M, href_list["P"])
		call(/datum/changeling/proc/EvolutionMenu)()



/datum/changeling/proc/purchasePower(var/datum/mind/M, var/Pname, var/remake_verbs = 1, silent = FALSE)
	if(!M || !M.changeling)
		return

	var/datum/power/changeling/Thepower = Pname


	for (var/datum/power/changeling/P in GLOB.changeling_power_instances)
		if(P.name == Pname)
			Thepower = P
			break


	if(Thepower == null)
		to_chat(M.current, SPAN_DEBUG("This is awkward.  Changeling power purchase failed, please report this bug to a coder!"))
		return

	if(Thepower in purchased_powers)
		to_chat(M.current, SPAN_WARNING("We have already evolved this ability!"))
		return


	if(genetic_points < Thepower.genome_cost)
		to_chat(M.current, SPAN_WARNING("We cannot evolve this... yet.  We must acquire more DNA."))
		return

	genetic_points -= Thepower.genome_cost

	add_power(Thepower, M, silent, remake_verbs)

/// Adds the provided power to this changeling datum's purchased powers.
/datum/changeling/proc/add_power(datum/power/changeling/C, datum/mind/M, silent, remake_verbs = FALSE)
	purchased_powers += C
	C.mind = M
	if (C.has_button)
		//var/datum/action/changeling_power/A = new C.action_type
		if (!M.current.ability_master)
			M.current.ability_master = new(null, M.current)
		M.current.ability_master.name = "Powers"
		M.current.ability_master.icon_state = "grey_spell_base"
		M.current.ability_master.open_state = "changeling_open"
		M.current.ability_master.closed_state = "genetics_closed"
		M.current.ability_master.add_changeling_power(C)
		/*A.Grant(M.current)
		A.power = C
		C.action = A*/

	if (!silent)
		to_chat(M.current, SPAN_NOTICE("We have evolved the [C.name] ability."))

	if(remake_verbs)
		M.current.make_changeling()
	C.on_add()

#undef CHANGELING_STASIS_NONE
#undef CHANGELING_STASIS_WAITING
#undef CHANGELING_STASIS_READY
