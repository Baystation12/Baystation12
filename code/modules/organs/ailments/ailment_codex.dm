/datum/codex_entry/ailments
	display_name = "Medical Ailments"
	lore_text = "Day to day life can exert stress on the body, which can manifest in small, non-critical medical conditions like a sore back or a \
	headache. 9/10 doctors recommend a visit to your local physician for treatment before they compound into a chronic or acute condition."
	mechanics_text = "Ailments are minor medical conditions that can crop up during a round. They aren't life-threatening, and \
	frequently aren't anything more than slightly annoying, and treating them is generally straightforward."
	var/show_robotics_recipes = FALSE
	var/name_column = "Ailment"
	var/treatment_column = "Recommended treatment"

/datum/codex_entry/ailments/robotic
	display_name = "Prosthetic Faults"
	lore_text = "Prosthetic limbs can be prone to debilitating and often dangerous faults, especially if exposed to hostile conditions."
	mechanics_text = "EMP damage or improper installation can cause prosthetic limbs to develop problems, some of them more serious than others."
	show_robotics_recipes = TRUE
	name_column = "Fault"
	treatment_column = "Recommended repair"

/datum/codex_entry/ailments/New()
	var/list/ailment_table = list("<table border = 1px>")
	ailment_table += "<tr><td><b>[name_column]</b></td><td><b>[treatment_column]</b></td></tr>"
	for(var/atype in subtypesof(/datum/ailment))
		var/datum/ailment/ailment = get_ailment_reference(atype)
		if(!ailment.name || show_robotics_recipes != ailment.affects_robotics)
			continue
		ailment_table += "<tr><td>[ailment.name]</td><td>"
		var/list/ailment_cures = list()
		if(ailment.treated_by_item_type)
			var/obj/item/thing = ailment.treated_by_item_type
			ailment_cures += "[ailment.treated_by_item_cost] x [initial(thing.name)]"
		if(ailment.treated_by_reagent_type)
			var/datum/reagent/reagent = ailment.treated_by_reagent_type
			ailment_cures += "[ailment.treated_by_reagent_dosage]u [reagent.name]"
		if(!length(ailment_cures))
			ailment_cures += "Unknown."
		ailment_table += "[jointext(ailment_cures,"<br>")]</td></tr>"
	ailment_table += "</table>"
	mechanics_text = "[mechanics_text]<br><h2>Known [display_name]</h2>[jointext(ailment_table, "")]"
	..()