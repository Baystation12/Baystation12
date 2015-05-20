/mob/living/carbon/alien/larva/confirm_evolution()

	src << "<span class='alium'><b>You begin to shed your skin, moulting into a more complex form. It is time to choose a caste.</b></span>"
	src << "<span class='notice'>There are three to choose from:</span>"
	src << "<span class='notice'><B>Hunters</B> are strong and agile, able to hunt away from the hive and rapidly move through ventilation shafts. Hunters generate plasma slowly and have low reserves.</span>"
	src << "<span class='notice'><B>Sentinels</B> are tasked with protecting the hive and are deadly up close and at a range. They are not as physically imposing nor fast as the hunters.</span>"
	src << "<span class='notice'><B>Drones</B> are the working class, offering the largest plasma storage and generation. They are the only caste which may evolve again, turning into the dreaded xenophage queen.</span>"
	var/alien_caste = alert(src, "Please choose which alien caste you shall belong to.",,"Hunter","Sentinel","Drone")
	return alien_caste ? "Xenophage [alien_caste]" : null

/mob/living/carbon/alien/larva/show_evolution_blurb()
	return