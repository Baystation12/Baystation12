// Targeted stun ability, moderate duration.
/spell/targeted/vampire/hypnotize

	name = "Hypnotise (10)"
	desc = "Through blood magic, you dominate the victim's mind and force them into a hypnotic trance."
	school = "vampirism"
	charge_max = 12 SECONDS
	invocation_type = SpI_NONE
	blood_cost = 10
	range = 3
	hud_state = "gen_rmind"


/spell/targeted/vampire/hypnotize/cast()

	if(user.stat == DEAD)
		return

	if (!user.has_eyes())
		to_chat(src, "<span class='warning'>You don't have eyes!</span>")
		return

	var/list/victims = list()
	for (var/mob/living/carbon/human/H in oview(range))
		victims += H

	if (!victims.len)
		to_chat(src, "<span class='warning'>No suitable targets.</span>")
		return

	var/mob/living/carbon/human/T = input(src, "Select Victim") as null|mob in victims

	if (!vampire_can_affect_target(T))
		return

	to_chat(src, "<span class='notice'>You begin peering into [T.name]'s mind, looking for a way to render them useless.</span>")

	if (do_mob(src, T, 50))
		to_chat(src, "<span class='danger'>You dominate [T.name]'s mind and render them temporarily powerless to resist.</span>")
		to_chat(T, "<span class='danger'>You are captivated by [src.name]'s gaze, and find yourself unable to move or even speak.</span>")
		T.Weaken(25)
		T.Stun(25)
		T.silent += 30

		admin_attack_log(src, T, "used hypnotise to stun [key_name(T)]", "was stunned by [key_name(src)] using hypnotise", "used hypnotise on")

	else
		to_chat(src, "<span class='warning'>You broke your gaze.</span>")
