
/datum/computer_file/report/recipient/sec
	logo = "\[solcrest\]"

/datum/computer_file/report/recipient/sec/New()
	..()
	set_access(access_security)
	set_access(access_heads, override = 0)

/datum/computer_file/report/recipient/sec/incident
	form_name = "SCG-SEC-01"
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

/datum/computer_file/report/recipient/sec/investigation
	form_name = "SCG-SEC-02"
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

/datum/computer_file/report/recipient/sec/statement
	form_name = "SCG-SEC-02c"
	title = "Written Statement"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/sec/statement/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "SEV Torch Security Department")
	add_field(/datum/report_field/text_label/instruction, "To be filled out by crewmember involved to document their side of an incident.")
	add_field(/datum/report_field/people/from_manifest, "Submitting Individual")
	add_field(/datum/report_field/simple_text, "Offense/Incident Type")
	add_field(/datum/report_field/date, "Date")
	add_field(/datum/report_field/time, "Time of incident")
	add_field(/datum/report_field/simple_text, "Location")
	add_field(/datum/report_field/text_label/instruction, "(V-Victim, S-Suspect, W-Witness, M-Missing, A-Arrested, RP-Reporting Person, D-Deceased)")
	add_field(/datum/report_field/pencode_text, "Personnel involved in Incident")
	add_field(/datum/report_field/text_label/instruction, "(D-Damaged, E-Evidence, L-Lost, R-Recovered, S-Stolen)")
	add_field(/datum/report_field/pencode_text, "Description of Items/Property")
	add_field(/datum/report_field/pencode_text, "Narrative")
	add_field(/datum/report_field/text_label/instruction, "By submitting this form, I understand this is considered a formal police report. I understand that all information written above is truthful and accurate. I understand that intentionally filing a fraudulent police report is a criminal offense that will be prosecuted to the fullest extent of the law.  As this is a binding legal document, I understand that by filing this form that any intentionally false information may warrant disciplinary action against myself. This statement was given on my own volition to assist with documenting the above summarized incident.")
	add_field(/datum/report_field/signature, "Signature")
	set_access(access_edit = access_security)

/datum/computer_file/report/recipient/sec/arrest
	form_name = "SCG-SEC-03"
	title = "Arrest Report"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/sec/arrest/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "SEV Torch Security Department")
	add_field(/datum/report_field/text_label/instruction, "To be filled out by Arresting Officer or Brig Chief. Report must be signed and submitted before the end of the shift!")
	add_field(/datum/report_field/people/from_manifest, "Booking Officer")
	add_field(/datum/report_field/people/list_from_manifest, "Arresting Officer(s)")
	add_field(/datum/report_field/date, "Date")
	add_field(/datum/report_field/time, "Time of incident")
	add_field(/datum/report_field/people/from_manifest, "Arrrested Individual")
	add_field(/datum/report_field/simple_text, "Charges")
	add_field(/datum/report_field/simple_text, "Sentence")
	add_field(/datum/report_field/simple_text, "Sentence")
	add_field(/datum/report_field/pencode_text, "Personal Property held for Safekeep")
	add_field(/datum/report_field/text_label/instruction, "The following eight questions are to be answered in YES/NO format")
	add_field(/datum/report_field/simple_text, "Escape Risk?")
	add_field(/datum/report_field/simple_text, "Suicide Risk?")
	add_field(/datum/report_field/simple_text, "Warrant Presented?")
	add_field(/datum/report_field/simple_text, "Advised of Rights?")
	add_field(/datum/report_field/simple_text, "Searched?")
	add_field(/datum/report_field/simple_text, "Provided an Opportunity for Statement?")
	add_field(/datum/report_field/simple_text, "Suit Sensors locked to MAX?")
	add_field(/datum/report_field/simple_text, "If needed, provided timely medical aid?")
	add_field(/datum/report_field/simple_text, "IF YES, what injuries are pre-existing?")
	add_field(/datum/report_field/text_label/instruction, "This document MUST be submitted to, and reviwed by, the Chief of Security or Brig Chief.")
	add_field(/datum/report_field/signature, "Reporting Officer's signature")
	set_access(access_edit = access_security)

/datum/computer_file/report/recipient/sec/restraining
	form_name = "SCG-SEC-04"
	title = "Restraining Order"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/sec/restraining/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "SEV Torch Security Department")
	add_field(/datum/report_field/text_label/instruction, "To be filled out by the Chief of Security, Executive Officer, or Commanding Officer. Report must be signed and submitted for the order to be considered valid. Any paper copies must be stamped.")
	add_field(/datum/report_field/people/from_manifest, "Plantiff")
	add_field(/datum/report_field/people/from_manifest, "Defendant(s)")
	add_field(/datum/report_field/date, "Date Effective")
	add_field(/datum/report_field/time, "Time Effective")
	add_field(/datum/report_field/text_label/instruction, "THE DEFENDANT IS ORDERED TO: 1) Not to abuse Plaintiff(s) by physically harming them, attempting to physically harm them, place them in fear of imminent physical harm; 2) Stop harassing them by any wilfull and malicious conduct aimed at them and intended to cause fear, intimidation, abuse, or damage to property; 3) Not to contact Plaintiff(s) unless authorized to do so by the CO, XO, COS or their appointee; 4) Remain out of the Plaintiff(s) workplace, 5) Remain no less than 20M away from Plaintiff. Violation of this legal order will result in arrest for Endangerment and any other applicable charges, including any applicable SCUJ violations.")
	add_field(/datum/report_field/signature, "Submitting Officer's signature")
	set_access(access_edit = access_hos)

/datum/computer_file/report/recipient/sec/ltc
	form_name = "SCG-SEC-05"
	title = "License to Carry"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/sec/ltc/generate_fields()
	..()
	add_field(/datum/report_field/text_label/header, "SEV Torch Security Department")
	add_field(/datum/report_field/text_label/instruction, "To be filled out by the Chief of Security, Executive Officer, or Commanding Officer. Report must be signed and submitted for the order to be considered valid. Any paper copies must be stamped.")
	add_field(/datum/report_field/people/from_manifest, "Licensee")
	add_field(/datum/report_field/date, "Date Effective")
	add_field(/datum/report_field/time, "Time Effective")
	add_field(/datum/report_field/simple_text, "Reason for License")
	add_field(/datum/report_field/simple_text, "Authorized for Possession Of")
	add_field(/datum/report_field/text_label/instruction, "THIS LICENSE IS ISSUED 'AT-WILL' AND MAY BE REVOKED AT ANY TIME FOR ANY REASON BY THE COMMANDING OFFICER, EXECUTIVE OFFICER, OR THE CHIEF OF SECURITY. IN THE EVENT OF ILLEGAL CONDUCT, THIS LICENSE MAY BE REVOKED BY ANY LAW ENFORCEMENT OFFICER ACTING IN THE COURSE OF THEIR NORMAL DUTIES. ALL LICENSEES ARE REQUIRED TO ABIDE BY LOCAL LAWS AND REGULATIONS AT ALL TIMES. OPEN CARRY OF LICENSED ITEMS IS GENERALLY NOT PERMITTED UNLESS EXPLICITLY DENOTED. THIS DOCUMENT MUST BE CARRIED BY THE LICENSED PARTY WHEN THEY ARE IN DIRECT OR CONSTRUCTIVE POSSESSION OF THE AFORMENTIONED ITEMS OR WEAPONS THAT THEY ARE AUTHORIZED FOR. COPIES OF THIS DOCUMENT WILL BE FORWARDED TO THE COMMANDING OFFICER, EXECUTIVE OFFICER, CHIEF OF SECURITY, AND BRIG OFFICER FOR REFERENCE.")
	add_field(/datum/report_field/signature, "Submitting Officer's signature")
	set_access(access_edit = access_hos)