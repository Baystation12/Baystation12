/datum/species/human/cult
	name = "Cult"
	spawn_flags = IS_RESTRICTED

	brute_mod = 2
	burn_mod = 2

/datum/species/human/cult/get_random_name()
	return "[pick("Anguished", "Blasphemous", "Corrupt", "Cruel", "Depraved", "Despicable", "Disturbed", "Exacerbated", "Foul", "Hateful", "Inexorable", "Implacable", "Impure", "Malevolent", "Malignant", "Malicious", "Pained", "Profane", "Profligate", "Relentless", "Resentful", "Restless", "Spiteful", "Tormented", "Unclean", "Unforgiving", "Vengeful", "Vindictive", "Wicked", "Wronged")] [pick("Apparition", "Aptrgangr", "Dis", "Draugr", "Dybbuk", "Eidolon", "Fetch", "Fylgja", "Ghast", "Ghost", "Gjenganger", "Haint", "Phantom", "Phantasm", "Poltergeist", "Revenant", "Shade", "Shadow", "Soul", "Spectre", "Spirit", "Spook", "Visitant", "Wraith")]"

/datum/species/human/cult/handle_death(var/mob/living/carbon/human/H)
	spawn(1)
		if(H)
			H.dust()

/datum/species/human/cult/handle_post_spawn(var/mob/living/carbon/human/H)
	H.s_tone = 35
	H.b_eyes = 200
	H.r_eyes = 200
	H.g_eyes = 200
	H.update_eyes()
	H.underwear = 0