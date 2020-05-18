/datum/computer_file/report/recipient/exp
	logo = "\[eclogo\]"

/datum/computer_file/report/recipient/exp/fauna
	form_name = "SCG-EXP-19f"
	title = "Alien Fauna Report"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/exp/fauna/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "SEV Torch Expeditions")
	add_field(/datum/report_field/text_label/instruction, "The following is to be filled out by members of a Expedition team after discovery and study of new alien life forms.")

	add_field(/datum/report_field/date, "Date")
	add_field(/datum/report_field/people/list_from_manifest, "Personnel Involved")
	add_field(/datum/report_field/pencode_text, "Anatomy/Appearance")
	add_field(/datum/report_field/pencode_text, "Locomotion")
	add_field(/datum/report_field/pencode_text, "Diet")
	add_field(/datum/report_field/pencode_text, "Habitat")
	add_field(/datum/report_field/simple_text, "Homeworld")
	add_field(/datum/report_field/pencode_text, "Behavior")
	add_field(/datum/report_field/pencode_text, "Defense/Offense")
	add_field(/datum/report_field/pencode_text, "Special Characteristic(s)")
	add_field(/datum/report_field/pencode_text, "Classification")

	add_field(/datum/report_field/text_label/instruction, "On completion of this form and form approval, the Chief Science Officer should fax the form to both the Corporate Liaison and the Commanding Officer, as well as keep a copy on file in their Office alongside other mission reports.")

/datum/computer_file/report/recipient/exp/planet
	form_name = "SCG-EXP-17"
	title = "Exoplanet Report"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/exp/planet/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "SEV Torch Expeditions")
	add_field(/datum/report_field/text_label/instruction, "The following is to be filled out by members of a Expedition team after an Expedition to an uncharted Exoplanet.")

	add_field(/datum/report_field/date, "Date")
	add_field(/datum/report_field/simple_text, "Planet Name")
	add_field(/datum/report_field/people/list_from_manifest, "Personnel Involved")
	add_field(/datum/report_field/pencode_text, "Terrain Information")
	add_field(/datum/report_field/simple_text, "Habitability")
	add_field(/datum/report_field/pencode_text, "Summary on Fauna")
	add_field(/datum/report_field/pencode_text, "Summary on Flora")
	add_field(/datum/report_field/pencode_text, "Points of Interest")
	add_field(/datum/report_field/pencode_text, "Observations")

	add_field(/datum/report_field/text_label/instruction, "On completion of this form and form approval, the Chief Science Officer should fax the form to both the Corporate Liaison and the Commanding Officer, as well as keep a copy on file in their Office alongside other mission reports.")

/datum/computer_file/report/recipient/shuttle/post_flight
	logo = "\[eclogo\]"
	form_name = "SCG-EXP-3"