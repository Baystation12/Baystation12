/spell/targeted/analyze
	name = "Analyze"
	desc = "Using your wizardly powers, you can detect the inner destructions of a persons body."

	feedback = "AZ"
	school = "illusion"
	charge_max = 100
	spell_flags = INCLUDEUSER|SELECTABLE
	range = 2
	invocation_type = SpI_WHISPER
	invocation = "Fu Yi Fim"
	compatible_mobs = list(/mob/living/carbon/human)
	hud_state = "analyze"

/spell/targeted/analyze/cast(var/list/targets, var/mob/user)
	for(var/a in targets)
		var/mob/living/carbon/human/H = a
		new /obj/effect/temporary(get_turf(a),5, 'icons/effects/effects.dmi', "repel_missiles")
		to_chat(user,medical_scan_results(H,1))