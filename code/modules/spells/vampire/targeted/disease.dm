// Gives a lethal disease to the target.
/spell/targeted/vampire/disease
	name = "Diseased Touch (100)"
	desc = "Infects the victim with corruption from the Veil, causing their organs to fail."
	school = "vampirism"
	blood_cost = 100
	charge_max = 3 MINUTES

/spell/targeted/vampire/jaunt/cast()
	var/datum/vampire/vampire = vampire_power(100, 0)
	if (!vampire)
		return

	var/list/victims = list()
	for (var/mob/living/carbon/human/H in view(1))
		if (H == src)
			continue
		victims += H

	if (!victims.len)
		to_chat(src, "<span class='warning'>No suitable targets.</span>")
		return

	var/mob/living/carbon/human/T = input(src, "Select Victim") as null|mob in victims

	if (!vampire_can_affect_target(T))
		return

	to_chat(src, "<span class='notice'>You infect [T] with a deadly disease. They will soon fade away.</span>")

	T.help_shake_act(src)

	var/datum/disease2/disease/lethal = new
	lethal.makerandom(3)
	lethal.infectionchance = 1
	lethal.stage = lethal.max_stage
	lethal.spreadtype = "None"

	infect_mob(T, lethal)

	admin_attack_log(src, T, "used diseased touch on [key_name(T)]", "was given a lethal disease by [key_name(src)]", "used diseased touch (<a href='?src=\ref[lethal];info=1'>virus info</a>) on")