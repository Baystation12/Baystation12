
/datum/computer_file/report/recipient/medical
	logo = "\[solcrest\]"
	form_name = "SCG-MED-00"

/datum/computer_file/report/recipient/medical/checkup
	form_name = "SCG-MED-013b"
	title = "Regular Health Checkup Checklist"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/medical/checkup/generate_fields()
	add_field(/datum/report_field/text_label/instruction, "You would need following equipment for this: stethoscope, health analyzer, penlight.")
	add_field(/datum/report_field/people/from_manifest, "Patient")
	add_field(/datum/report_field/date, "Date")
	add_field(/datum/report_field/time, "Time")
	add_field(/datum/report_field/simple_text, "Take pulse", "NOT CHECKED")
	add_field(/datum/report_field/simple_text, "Check blood pressure", "NOT CHECKED")
	add_field(/datum/report_field/simple_text, "Listen for heart noises", "NOT CHECKED")
	add_field(/datum/report_field/simple_text, "Listen for lung noises", "NOT CHECKED")
	add_field(/datum/report_field/simple_text, "Ask if they exercise", "NOT CHECKED")
	add_field(/datum/report_field/simple_text, "Ask if they smoke, and how much per day", "NOT CHECKED")
	add_field(/datum/report_field/simple_text, "Check eye reaction to penlight", "NOT CHECKED")
	add_field(/datum/report_field/simple_text, "Ask about any recent radiation exposure", "NOT CHECKED")
	add_field(/datum/report_field/simple_text, "Ask about any recent sickness", "NOT CHECKED")
	add_field(/datum/report_field/pencode_text, "Other Notes")
	add_field(/datum/report_field/signature, "Doctor's Signature")
	set_access(access_edit = access_medical_equip)