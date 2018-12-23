/*
Other mutation or disability spells can be found in
code\game\dna\genes\vg_powers.dm //hulk is in this file
code\game\dna\genes\goon_disabilities.dm
code\game\dna\genes\goon_powers.dm
*/
/spell/targeted/genetic
	name = "Genetic modifier"
	desc = "This spell inflicts a set of mutations and disabilities upon the target."

	var/disabilities = 0 //bits
	var/list/mutations = list() //mutation strings
	duration = 100 //deciseconds


/spell/targeted/genetic/cast(list/targets)
	..()
	for(var/mob/living/target in targets)
		for(var/x in mutations)
			target.mutations.Add(x)
		target.disabilities |= disabilities
		target.update_mutations()	//update target's mutation overlays
		spawn(duration)
			for(var/x in mutations)
				target.mutations.Remove(x)
			target.disabilities &= ~disabilities
			target.update_mutations()
	return

/spell/targeted/genetic/blind
	name = "Blind"
	desc = "This spell inflicts a target with temporary blindness. Does not require wizard garb."
	feedback = "BD"
	disabilities = 1
	school = "illusion"
	duration = 300

	charge_max = 300

	spell_flags = 0
	invocation = "Sty Kaly."
	invocation_type = SpI_WHISPER
	message = "<span class='danger'>Your eyes cry out in pain!</span>"
	level_max = list(Sp_TOTAL = 3, Sp_SPEED = 1, Sp_POWER = 3)
	cooldown_min = 50

	range = 7
	max_targets = 0

	amt_eye_blind = 10
	amt_eye_blurry = 20

	hud_state = "wiz_blind"
	cast_sound = 'sound/magic/blind.ogg'

/spell/targeted/genetic/blind/empower_spell()
	if(!..())
		return 0
	duration += 100

	return "[src] will now blind for a longer period of time."

/spell/targeted/genetic/mutate
	name = "Mutate"
	desc = "This spell causes you to turn into a hulk and gain laser vision for a short while."
	feedback = "MU"
	school = "transmutation"
	charge_max = 400
	spell_flags = Z2NOCAST | NEEDSCLOTHES | INCLUDEUSER
	invocation = "BIRUZ BENNAR"
	invocation_type = SpI_SHOUT
	message = "<span class='notice'>You feel strong! You feel a pressure building behind your eyes!</span>"
	range = 0
	max_targets = 1

	mutations = list(MUTATION_LASER, MUTATION_HULK)
	duration = 300

	level_max = list(Sp_TOTAL = 1, Sp_SPEED = 1, Sp_POWER = 0)
	cooldown_min = 300

	hud_state = "wiz_hulk"
	cast_sound = 'sound/magic/mutate.ogg'
	effect_state = "electricity_constant"
	effect_duration = 5
	effect_color = "#ff0000"

/spell/targeted/genetic/blind/hysteria
	name = "Hysteria"
	desc = "A spell used to make someone look like a blind fool, and also makes them a blind fool."
	feedback = "HY"
	school = "illusion"
	spell_flags = SELECTABLE
	charge_max = 600
	invocation_type = SpI_SHOUT
	invocation = "Sty Di Kaly!"
	amt_dizziness = 10
	hud_state = "hysteria"

/spell/targeted/genetic/blind/starburst
	name = "Starburst"
	desc = "Send a jolt of electricity through everyone's nerve center, blinding and stunning them."
	feedback = "SB"
	school = "transmutation"
	invocation = "Tid Caeh Yor!"
	spell_flags = NOFACTION
	invocation_type = SpI_SHOUT
	charge_max = 60 SECONDS
	spell_flags = 0

	amt_dizziness = 0
	amt_eye_blurry = 5
	amt_stunned = 1

	effect_state = "electricity_constant"
	effect_duration = 5

	hud_state = "wiz_starburst"