/spell/targeted/shatter
	name = "Shatter Mind"
	desc = "this spell allows the caster to literally break an enemy's mind. Permanently."
	feedback = "SM"
	school = "evocation"
	charge_max = 300
	spell_flags = 0
	invocation_type = SpI_NONE
	range = 5
	max_targets = 1
	compatible_mobs = list(/mob/living/carbon/human)

	time_between_channels = 150
	number_of_channels = 0

	hud_state = "gen_dissolve"

/spell/targeted/shatter/cast(var/list/targets, var/mob/user)
	var/mob/living/carbon/human/H = targets[1]
	if(prob(50))
		sound_to(user, get_sfx("swing_hit"))
	if(prob(5))
		to_chat(H, "<span class='warning'>You feel unhinged.</span>")
	H.hallucination += 5
	H.confused += 2
	H.dizziness += 2
	if(H.hallucination > 50)
		H.adjustBrainLoss(5)
		to_chat(H, "<span class='danger'>You feel your mind tearing apart!</span>")

/spell/targeted/shatter/cast_check(skipcharge = 0,mob/user = usr, var/list/targets)
	if(!..())
		return 0

	return !(targets[1] in view_or_range(range, holder, selection_type))