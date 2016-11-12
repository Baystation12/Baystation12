/mob/living/carbon/alien/larva/confirm_evolution()

	to_chat(src, "<span class='notice'><b>You are growing into a beautiful alien! It is time to choose a caste.</b></span>")
	to_chat(src, "<span class='notice'>There are three to choose from:</span>")
	to_chat(src, "<B>Hunters</B> <span class='notice'>are strong and agile, able to hunt away from the hive and rapidly move through ventilation shafts. Hunters generate plasma slowly and have low reserves.</span>")
	to_chat(src, "<B>Sentinels</B> <span class='notice'>are tasked with protecting the hive and are deadly up close and at a range. They are not as physically imposing nor fast as the hunters.</span>")
	to_chat(src, "<B>Drones</B> <span class='notice'>are the working class, offering the largest plasma storage and generation. They are the only caste which may evolve again, turning into the dreaded alien queen.</span>")
	var/alien_caste = alert(src, "Please choose which alien caste you shall belong to.",,"Hunter","Sentinel","Drone")
	return alien_caste ? "Xenomorph [alien_caste]" : null

/mob/living/carbon/alien/larva/show_evolution_blurb()
	return