
/datum/computer_file/report/recipient/sec
	logo = "\[solcrest\]"

/datum/computer_file/report/recipient/sec/New()
	..()
	set_access(access_security)
	set_access(access_heads, override = 0)

/datum/computer_file/report/recipient/sec/investigation
	form_name = "SCG-SEC-43"
	title = "Investigation Report"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/sec/investigation/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "SEV Torch Security Department")
	add_field(/datum/report_field/text_label/instruction, "For internal use only.")
	add_field(/datum/report_field/people/from_manifest, "Name")
	add_field(/datum/report_field/date, "Date")
	add_field(/datum/report_field/time, "Time")
	add_field(/datum/report_field/simple_text, "Case name")
	add_field(/datum/report_field/pencode_text, "Summary")
	add_field(/datum/report_field/pencode_text, "Observations")
	add_field(/datum/report_field/signature, "Signature")
	set_access(access_edit = access_security)

/datum/computer_file/report/recipient/sec/incident
	form_name = "SCG-SEC-12"
	title = "Security Incident Report"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/sec/incident/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "SEV Torch Security Department")
	add_field(/datum/report_field/text_label/instruction, "To be filled out by Officer on duty responding to the Incident. Report must be signed and submitted before the end of the shift!")
	add_field(/datum/report_field/people/from_manifest, "Reporting Officer")
	add_field(/datum/report_field/simple_text, "Offense/Incident Type")
	add_field(/datum/report_field/date, "Date")
	add_field(/datum/report_field/time, "Time of incident")
	add_field(/datum/report_field/people/list_from_manifest, "Assisting Officer(s)")
	add_field(/datum/report_field/simple_text, "Location")
	add_field(/datum/report_field/text_label/instruction, "(V-Victim, S-Suspect, W-Witness, M-Missing, A-Arrested, RP-Reporting Person, D-Deceased)")
	add_field(/datum/report_field/pencode_text, "Personnel involved in Incident")
	add_field(/datum/report_field/text_label/instruction, "(D-Damaged, E-Evidence, L-Lost, R-Recovered, S-Stolen)")
	add_field(/datum/report_field/pencode_text, "Description of Items/Property")
	add_field(/datum/report_field/pencode_text, "Narrative")
	add_field(/datum/report_field/signature, "Reporting Officer's signature")
	set_access(access_edit = access_security)

/datum/computer_file/report/recipient/sec/evidence
	form_name = "SCG-SEC-02b"
	title = "Evidence and Property Form"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/sec/evidence/generate_fields()
	..()
	var/datum/report_field/temp_field
	add_field(/datum/report_field/text_label/header, "SEV Torch Security Department")
	add_field(/datum/report_field/date, "Date")
	add_field(/datum/report_field/time, "Time")
	add_field(/datum/report_field/people/from_manifest, "Confiscated from")
	add_field(/datum/report_field/pencode_text, "List of items in custody/evidence lockup")
	set_access(access_edit = access_security)
	temp_field = add_field(/datum/report_field/signature, "Brig Chief's signature")
	temp_field.set_access(access_edit = list(access_security, access_armory))
	temp_field = add_field(/datum/report_field/signature, "Forensic Technician's signature")
	temp_field.set_access(access_edit = list(access_security, access_forensics_lockers))
