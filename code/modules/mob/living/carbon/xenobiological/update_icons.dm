/mob/living/carbon/slime/regenerate_icons()
	if (stat == DEAD)
		icon_state = "[colour] baby slime dead"
	else
		icon_state = "[colour] [is_adult ? "adult" : "baby"] slime[Victim ? "" : " eat"]"
	ClearOverlays()
	if (mood)
		AddOverlays(image('icons/mob/simple_animal/slimes.dmi', icon_state = "aslime-[mood]"))
	..()
