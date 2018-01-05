// Dominate a victim, imbed a thought into their mind.
/spell/targeted/vampire/dominate
	name = "Dominate (25)"
	desc = "Dominate the mind of a victim, make them obey your will."
	blood_cost = 25
	charge_max = 180 SECONDS

/spell/targeted/vampire/dominate/cast()
	var/datum/vampire/vampire = vampire_power(25, 0)
	if (!vampire)
		return

	var/list/victims = list()
	for (var/mob/living/carbon/human/H in view(7))
		if (H == src)
			continue
		victims += H

	if (!victims.len)
		to_chat(src, "<span class='warning'>No suitable targets.</span>")
		return

	var/mob/living/carbon/human/T = input(src, "Select Victim") as null|mob in victims

	if (!vampire_can_affect_target(T, 1, 1))
		return

	if (!(vampire.status & VAMP_FULLPOWER))
		to_chat(src, "<span class='notice'>You begin peering into [T]'s mind, looking for a way to gain control.</span>")

		if (!do_mob(src, T, 50))
			to_chat(src, "<span class='warning'>Your concentration is broken!</span>")
			return

		to_chat(src, "<span class='notice'>You succeed in dominating [T]'s mind. They are yours to command.</span>")
	else
		to_chat(src, "<span class='notice'>You instantly dominate [T]'s mind, forcing them to obey your command.</span>")

	var/command = input(src, "Command your victim.", "Your command.") as text|null

	if (!command)
		to_chat(src, "<span class='alert'>Cancelled.</span>")
		return

	command = sanitizeSafe(command, extra = 0)

	admin_attack_log(src, T, "used dominate on [key_name(T)]", "was dominated by [key_name(src)]", "used dominate and issued the command of '[command]' to")

	show_browser(T, "<center>You feel a strong presence enter your mind. For a moment, you hear nothing but what it says, <b>and are compelled to follow its direction without question or hesitation:</b><br>[command]</center>", "window=vampiredominate")
	to_chat(src, "<span class='notice'>You command [T], and they will obey.</span>")
	emote("me", 1, "whispers.")
