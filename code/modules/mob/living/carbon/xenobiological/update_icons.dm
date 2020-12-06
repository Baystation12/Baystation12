/mob/living/carbon/slime/regenerate_icons()
	if (stat == DEAD)
		icon_state = "[colour] baby slime dead"
	else
		icon_state = "[colour] [is_adult ? "adult" : "baby"] slime[Victim ? "" : " eat"]"
	overlays.len = 0
	if (mood)
		overlays += image('icons/mob/slimes.dmi', icon_state = "aslime-[mood]")
	..()