//Report datums for use with the report editor and other programs.

/datum/computer_file/report/recipient/crew_transfer
	form_name = "CTA-SGF-01"
	title = "Crew Transfer Application"
	logo = "\[solcrest\]\[logo\]"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/crew_transfer/generate_fields()
	..()
	var/list/xo_fields = list()
	add_field(/datum/report_field/instruction, "SEV Torch - Office of the Executive Officer")
	add_field(/datum/report_field/people/from_manifest, "Name (XO)")
	add_field(/datum/report_field/people/from_manifest, "Name (applicant)", required = 1)
	add_field(/datum/report_field/date, "Date filed")
	add_field(/datum/report_field/time, "Time filed")
	add_field(/datum/report_field/simple_text, "Present position")
	add_field(/datum/report_field/simple_text, "Requested position")
	add_field(/datum/report_field/pencode_text, "Reason stated")
	add_field(/datum/report_field/instruction, "The following fields render the document invalid if not signed clearly.")
	add_field(/datum/report_field/signature, "Applicant signature")
	xo_fields += add_field(/datum/report_field/signature, "Executive Officer's signature")
	xo_fields += add_field(/datum/report_field/number, "Number of personnel in present/previous position")
	xo_fields += add_field(/datum/report_field/number, "Number of personnel in requested position")
	xo_fields += add_field(/datum/report_field/options/yes_no, "Approved")
	for(var/datum/report_field/field in xo_fields)
		field.set_access(access_edit = access_hop)

/datum/computer_file/report/recipient/access_modification
	form_name = "AMA-SGF-02"
	title = "Crew Access Modification Application"
	logo = "\[solcrest\]\[logo\]"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/access_modification/generate_fields()
	..()
	var/list/xo_fields = list()
	add_field(/datum/report_field/instruction, "SEV Torch - Office of the Executive Officer")
	add_field(/datum/report_field/people/from_manifest, "Name (XO)")
	add_field(/datum/report_field/people/from_manifest, "Name (applicant)", required = 1)
	add_field(/datum/report_field/date, "Date filed")
	add_field(/datum/report_field/time, "Time filed")
	add_field(/datum/report_field/simple_text, "Present position")
	add_field(/datum/report_field/simple_text, "Requested access")
	add_field(/datum/report_field/pencode_text, "Reason stated")
	add_field(/datum/report_field/simple_text, "Duration of expanded access")
	add_field(/datum/report_field/instruction, "The following fields render the document invalid if not signed clearly.")
	add_field(/datum/report_field/signature, "Applicant signature")
	xo_fields += add_field(/datum/report_field/signature, "Executive Officer's signature")
	xo_fields += add_field(/datum/report_field/number, "Number of personnel in relevant position")
	xo_fields += add_field(/datum/report_field/options/yes_no, "Approved")
	for(var/datum/report_field/field in xo_fields)
		field.set_access(access_edit = access_hop)

/datum/computer_file/report/recipient/borging
	form_name = "CC-SGF-09"
	title = "Cyborgification Contract"
	logo = "\[solcrest\]"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/borging/generate_fields()
	..()
	var/list/xo_fields = list()
	add_field(/datum/report_field/instruction, "SEV Torch - Office of the Executive Officer")
	add_field(/datum/report_field/people/from_manifest, "Name (XO)")
	add_field(/datum/report_field/people/from_manifest, "Name (subject)", required = 1)
	add_field(/datum/report_field/date, "Date filed")
	add_field(/datum/report_field/time, "Time filed")
	add_field(/datum/report_field/instruction, "I, undersigned, hereby agree to willingly undergo a Regulation Lobotimization with intention of cyborgification or AI assimilation, and I am aware of all the consequences of such act. I also understand that this operation may be irreversible, and that my employment contract will be terminated.")
	add_field(/datum/report_field/signature, "Subject's signature")
	xo_fields += add_field(/datum/report_field/signature, "Executive Officer's signature")
	xo_fields += add_field(/datum/report_field/options/yes_no, "Approved")
	for(var/datum/report_field/field in xo_fields)
		field.set_access(access_edit = access_hop)

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
	add_field(/datum/report_field/instruction, "SEV Torch Security Department")
	add_field(/datum/report_field/instruction, "For internal use only.")
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
	add_field(/datum/report_field/instruction, "SEV Torch Security Department")
	add_field(/datum/report_field/instruction, "To be filled out by Officer on duty responding to the Incident. Report must be signed and submitted before the end of the shift!")
	add_field(/datum/report_field/people/from_manifest, "Reporting Officer")
	add_field(/datum/report_field/simple_text, "Offense/Incident Type")
	add_field(/datum/report_field/date, "Date")
	add_field(/datum/report_field/time, "Time of incident")
	add_field(/datum/report_field/people/list_from_manifest, "Assisting Officer(s)")
	add_field(/datum/report_field/simple_text, "Location")
	add_field(/datum/report_field/pencode_text, "Personnel involved in Incident", "\[small\]\[i\](V-Victim, S-Suspect, W-Witness, M-Missing, A-Arrested, RP-Reporting Person, D-Deceased)\[/i\]\[/small\]")
	add_field(/datum/report_field/pencode_text, "Description of Items/Property", "\[small\]\[i\](D-Damaged, E-Evidence, L-Lost, R-Recovered, S-Stolen)\[/i\]\[/small\]")
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
	add_field(/datum/report_field/instruction, "SEV Torch Security Department")
	add_field(/datum/report_field/date, "Date")
	add_field(/datum/report_field/time, "Time")
	add_field(/datum/report_field/people/from_manifest, "Confiscated from")
	add_field(/datum/report_field/pencode_text, "List of items in custody/evidence lockup")
	set_access(access_edit = access_security)
	temp_field = add_field(/datum/report_field/signature, "Brig Officer's signature")
	temp_field.set_access(access_edit = list(access_security, access_armory))
	temp_field = add_field(/datum/report_field/signature, "Forensic Technician's signature")
	temp_field.set_access(access_edit = list(access_security, access_forensics_lockers))

//Supply and Exploration; these are not shown in deck manager.

/datum/computer_file/report/recipient/docked
	logo = "\[solcrest\]"
	form_name = "SCG-SUP-12"
	title = "Docked Vessel Report"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/docked/New()
	..()
	set_access(access_cargo, access_cargo)
	set_access(access_heads, override = 0)

/datum/computer_file/report/recipient/docked/generate_fields()
	..()
	add_field(/datum/report_field/instruction, "SEV Torch Supply and Hangar Management Department")
	add_field(/datum/report_field/instruction, "General Info")
	add_field(/datum/report_field/date, "Date")
	add_field(/datum/report_field/simple_text, "Vessel Name")
	add_field(/datum/report_field/simple_text, "Vessel Pilot/Owner")
	add_field(/datum/report_field/simple_text, "Vessel Intended Purpose")
	add_field(/datum/report_field/people/from_manifest, "Docking Authorized by")
	add_field(/datum/report_field/instruction, "General Cargo Info")
	add_field(/datum/report_field/pencode_text, "List the types of cargo onboard the vessel")
	add_field(/datum/report_field/instruction, "Hazardous Cargo Info")
	add_field(/datum/report_field/options/yes_no, "Weaponry")
	add_field(/datum/report_field/options/yes_no, "Live Cargo")
	add_field(/datum/report_field/options/yes_no, "Biohazardous material")
	add_field(/datum/report_field/options/yes_no, "Chemical or radiation hazard")
	add_field(/datum/report_field/signature, "To indicate authorization for vessel entry, sign here")
	add_field(/datum/report_field/instruction, "Undocking and Departure")
	add_field(/datum/report_field/time, "Undocking Time")
	add_field(/datum/report_field/pencode_text, "Additional Undocking Comments")

/datum/computer_file/report/recipient/fauna
	logo = "\[solcrest\]"
	form_name = "SCG-EXP-19f"
	title = "Alien Fauna Report"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/docked/New()
	..()
	set_access(access_edit = access_hangar)
	set_access(access_edit = access_research, override = 0)

/datum/computer_file/report/recipient/fauna/generate_fields()
	..()
	add_field(/datum/report_field/instruction, "SEV Torch Expeditions")
	add_field(/datum/report_field/instruction, "The following is to be filled out by members of a Expedition team after discovery and study of new alien life forms.")
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
	add_field(/datum/report_field/instruction, "On completion of this form and form approval, the Research Director should fax the form to both the Corporate Liaison and the Commanding Officer, as well as keep a copy on file in their Office alongside other mission reports.")

//NT reports, mostly for liason but can be used by any NT personnel.

/datum/computer_file/report/recipient/nt
	logo = "\[logo\]"

/datum/computer_file/report/recipient/nt/proc/add_header()
	add_field(/datum/report_field/simple_text, "Vessel", "SEV Torch")
	add_field(/datum/report_field/date, "Date")
	add_field(/datum/report_field/time, "Time")
	add_field(/datum/report_field/simple_text, "Index")

/datum/computer_file/report/recipient/nt/anomaly
	form_name = "C-1546"
	title = "Anomalistic Object Report"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/nt/anomaly/New()
	..()
	set_access(access_research, access_research)

/datum/computer_file/report/recipient/nt/anomaly/generate_fields()
	..()
	add_header()
	add_field(/datum/report_field/simple_text, "AO Codename")
	add_field(/datum/report_field/people/from_manifest, "Reporting Scientist")
	add_field(/datum/report_field/people/from_manifest, "Overviewing Research Director")
	add_field(/datum/report_field/pencode_text, "Containment Procedures")
	add_field(/datum/report_field/pencode_text, "Generalized Overview")
	add_field(/datum/report_field/simple_text, "Approximate Age of AO")
	add_field(/datum/report_field/simple_text, "Threat Level of AO")

/datum/computer_file/report/recipient/nt/fire
	form_name = "C-0102"
	title = "Corporate Employment Termination Form"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/nt/fire/New()
	..()
	set_access(access_heads, access_heads)
	set_access(access_nanotrasen, override = 0)

/datum/computer_file/report/recipient/nt/fire/generate_fields()
	..()
	add_header()
	add_field(/datum/report_field/instruction, "Notice of Termination of Employment")
	add_field(/datum/report_field/people/from_manifest, "Name")
	add_field(/datum/report_field/number, "Age")
	add_field(/datum/report_field/simple_text, "Position")
	add_field(/datum/report_field/pencode_text, "Reason for Termination")
	add_field(/datum/report_field/signature, "Authorized by")
	add_field(/datum/report_field/instruction, "Please attach employment records alongside notice of termination.")

/datum/computer_file/report/recipient/nt/incident/New()
	..()
	set_access(access_edit = access_nanotrasen)

/datum/computer_file/report/recipient/nt/incident/generate_fields()
	..()
	add_header()
	add_field(/datum/report_field/pencode_text, "Summary of Incident")
	add_field(/datum/report_field/pencode_text, "Details of Incident")

/datum/computer_file/report/recipient/nt/incident/proc/add_signatures()
	add_field(/datum/report_field/signature, "Signature")
	add_field(/datum/report_field/signature, "Witness Signature")
	add_field(/datum/report_field/options/yes_no, "Approved")

/datum/computer_file/report/recipient/nt/incident/ship
	form_name = "C-3203"
	title = "Corporate Ship Incident Report"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/nt/incident/ship/generate_fields()
	..()
	add_field(/datum/report_field/pencode_text, "Departments Involved")
	add_signatures()


/datum/computer_file/report/recipient/nt/incident/personnel
	form_name = "C-3205"
	title = "Corporate Personnel Incident Report"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/nt/incident/personnel/generate_fields()
	..()
	add_field(/datum/report_field/people/list_from_manifest, "Employee(s) Involved")
	add_signatures()

/datum/computer_file/report/recipient/nt/incident/asset
	form_name = "C-3201"
	title = "Corporate Asset Incident Report"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/nt/incident/asset/generate_fields()
	..()
	add_field(/datum/report_field/pencode_text, "Corporate Employee Injuries")
	add_field(/datum/report_field/pencode_text, "Corporate Assets Lost")
	add_signatures()

/datum/computer_file/report/recipient/nt/incident/xeno
	form_name = "C-3213"
	title = "Corporate Non-Human Employee Incident Report"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/nt/incident/xeno/generate_fields()
	add_field(/datum/report_field/instruction, "If non-human employee lacks a valid work visa, use form C-3213A instead.")
	..()
	add_field(/datum/report_field/people/list_from_manifest, "Non-Human Employee(s) Involved")
	add_signatures()

/datum/computer_file/report/recipient/nt/incident/xeno_no_visa/
	form_name = "C-3213A"
	title = "Corporate Non-Human Employee Incident Report: Without Visa"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/nt/incident/xeno_no_visa/generate_fields()
	add_field(/datum/report_field/instruction, "If non-human employee has a valid work visa, use form C-3213 instead.")
	..()
	add_field(/datum/report_field/people/list_from_manifest, "Non-Human Employee(s) Involved")
	add_signatures()

/datum/computer_file/report/recipient/nt/incident/synth
	form_name = "C-3213X"
	title = "Corporate Synthetic Employee Incident Report"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/nt/incident/synth/generate_fields()
	..()
	add_field(/datum/report_field/people/list_from_manifest, "Synthetic Employee(s) Involved")
	add_signatures()

/datum/computer_file/report/recipient/nt/incident/crew
	form_name = "C-3241"
	title = "Corporate Ship Crew/Employee Incident Report"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/nt/incident/crew/generate_fields()
	add_field(/datum/report_field/instruction, "For multi-party incidents involving both ship crew and company employees.")
	..()
	add_field(/datum/report_field/people/list_from_manifest, "Crew Member(s) Involved")
	add_field(/datum/report_field/people/list_from_manifest, "Employee(s) Involved")
	add_signatures()

/datum/computer_file/report/recipient/nt/volunteer
	form_name = "C-1443"
	title = "Corporate Test Subject Volunteer Form"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/nt/volunteer/generate_fields()
	..()
	var/list/temp_fields = list()
	add_header()
	add_field(/datum/report_field/people/from_manifest, "Name of Volunteer")
	add_field(/datum/report_field/simple_text, "Intended Procedure(s)")
	add_field(/datum/report_field/simple_text, "Compensation for Volunteer: (if any)")
	add_field(/datum/report_field/people/list_from_manifest, "Handling Researcher(s)")
	add_field(/datum/report_field/instruction, "By signing, the \"Volunteer\" agrees to absolve the Corporation, and its employees, of any liability or responsibility for injuries, damages, property loss or side-effects that may result from the intended procedure. If signed by an authorized representative of the Corporation, such as a Research Director or Executive - this form is deemed reviewed, but is only approved if so marked.")
	add_field(/datum/report_field/signature, "Volunteer's Signature:")
	temp_fields += add_field(/datum/report_field/signature, "Corporate Representative's Signature")
	temp_fields += add_field(/datum/report_field/options/yes_no, "Approved")
	for(var/datum/report_field/temp_field in temp_fields)
		temp_field.set_access(access_edit = access_nanotrasen)

/datum/computer_file/report/recipient/nt/deny
	form_name = "C-1443D"
	title = "Rejection of Test Subject Volunteer Notice"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/nt/deny/generate_fields()
	..()
	add_header()
	add_field(/datum/report_field/instruction, "Dear Sir/Madam, we regret to inform you that your volunteer application for service as a test subject with the Corporation has been rejected. We thank you for your interest in our company and the progression of research. Attached, you will find a copy of your original volunteer form for your records. Regards,")
	add_field(/datum/report_field/signature, "Corporate Representative's Signature")
	add_field(/datum/report_field/people/from_manifest, "Name of Volunteer")
	add_field(/datum/report_field/instruction, "Reason for Rejection")
	add_field(/datum/report_field/options/yes_no, "Physically Unfit")
	add_field(/datum/report_field/options/yes_no, "Mentally Unfit")
	add_field(/datum/report_field/options/yes_no, "Project Cancellation")
	add_field(/datum/report_field/simple_text, "Other")
	add_field(/datum/report_field/options/yes_no, "Report Approved")
	set_access(access_edit = access_nanotrasen)

/datum/computer_file/report/recipient/nt/memo/generate_fields()
	..()
	add_header()
	add_field(/datum/report_field/simple_text, "Subject")
	add_field(/datum/report_field/pencode_text, "Body")
	add_field(/datum/report_field/signature, "Authorizing Signature")
	add_field(/datum/report_field/options/yes_no, "Approved")

/datum/computer_file/report/recipient/nt/memo/internal
	form_name = "C-0003"
	title = "Internal Memorandum"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/nt/memo/internal/New()
	..()
	set_access(access_nanotrasen, access_nanotrasen)

/datum/computer_file/report/recipient/nt/memo/external
	form_name = "C-0005"
	title = "External Memorandum"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/nt/memo/external/New()
	..()
	set_access(access_edit = access_nanotrasen)

//No access restrictions for easier use.
/datum/computer_file/report/recipient/nt/sales
	form_name = "C-2192"
	title = "Corporate Sales Contract and Receipt"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/nt/sales/generate_fields()
	..()
	add_header()
	add_field(/datum/report_field/instruction, "Product Information")
	add_field(/datum/report_field/simple_text, "Product Name")
	add_field(/datum/report_field/simple_text, "Product Type")
	add_field(/datum/report_field/number, "Product Unit Cost (T)")
	add_field(/datum/report_field/number, "Product Units Requested")
	add_field(/datum/report_field/number, "Total Cost (T)")
	add_field(/datum/report_field/instruction, "Seller Information")
	add_field(/datum/report_field/instruction, "The 'Purchaser' may not return any sold product units for re-compensation in thalers, but may return the item for an identical item, or item of equal material (not thaler) value. The 'Seller' agrees to make their best effort to repair, or replace any items that fail to accomplish their designed purpose, due to malfunction or manufacturing error - but not user-caused damage.")
	add_field(/datum/report_field/people/from_manifest, "Name")
	add_field(/datum/report_field/signature, "Signature")
	add_field(/datum/report_field/options/yes_no, "Approved")

/datum/computer_file/report/recipient/nt/visa
	form_name = "C-0952"
	title = "Corporate Sol Central Government Work Visa Request Form"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/nt/visa/generate_fields()
	..()
	add_header()
	var/datum/report_field/temp_field
	add_field(/datum/report_field/people/from_manifest, "Intended Recipient of Visa")
	add_field(/datum/report_field/pencode_text, "Reason for Request")
	add_field(/datum/report_field/signature, "Applicant's Signature")
	temp_field = add_field(/datum/report_field/signature, "Request Issuer's Signature")
	temp_field.set_access(access_edit = access_nanotrasen)
	temp_field = add_field(/datum/report_field/options/yes_no, "Request Approved by Issuer")
	temp_field.set_access(access_edit = access_nanotrasen)
	temp_field = add_field(/datum/report_field/signature, "Issuing Authority's Signature (acknowledging reciept)")
	temp_field.set_access(access_edit = access_representative)

/datum/computer_file/report/recipient/nt/payout
	form_name = "C-3310"
	title = "Next of Kin Payout Authorization"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/nt/payout/generate_fields()
	..()
	add_header()
	add_field(/datum/report_field/people/from_manifest, "This document hereby authorizes the payout of the remaining salary of")
	add_field(/datum/report_field/pencode_text, "As well as the net-worth of any remaining personal assets: (Asset, Thaler Amount)")
	add_field(/datum/report_field/pencode_text, "Including personal effects")
	add_field(/datum/report_field/instruction, "To be shipped and delivered directly to the employee's next of kin without delay.")
	add_field(/datum/report_field/signature, "Signature")
	add_field(/datum/report_field/options/yes_no, "Approved")
	set_access(access_edit = access_nanotrasen)

//Solgov reports, mostly for the SGR
/datum/computer_file/report/recipient/sol
	logo = "\[solcrest\]"
	form_name = "SCG-REP-00"

/datum/computer_file/report/recipient/sol/audit
	form_name = "SCG-REP-12"
	title = "SEV Torch Department Audit"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/sol/audit/generate_fields()
	add_field(/datum/report_field/date, "Date")
	add_field(/datum/report_field/time, "Time")
	add_field(/datum/report_field/simple_text, "Name of Department")
	add_field(/datum/report_field/pencode_text, "Positive Observations")
	add_field(/datum/report_field/pencode_text, "Negative Observations")
	add_field(/datum/report_field/pencode_text, "Other Notes")
	add_field(/datum/report_field/signature, "Signature")
	add_field(/datum/report_field/options/yes_no, "Approved")
	set_access(access_edit = access_representative)

/datum/computer_file/report/recipient/sol/audit
	form_name = "SCG-REP-4"
	title = "Crewman Incident Report"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/sol/audit/generate_fields()
	add_field(/datum/report_field/date, "Date")
	add_field(/datum/report_field/time, "Time")
	add_field(/datum/report_field/people/from_manifest, "Crewman Involved in Incident")
	add_field(/datum/report_field/simple_text, "Nature of Incident")
	add_field(/datum/report_field/pencode_text, "Description of incident")
	add_field(/datum/report_field/signature, "Signature")
	add_field(/datum/report_field/options/yes_no, "Approved")
	set_access(access_edit = list(access_heads, access_solgov_crew))

/datum/computer_file/report/recipient/sol/audit
	form_name = "SCG-REP-03b"
	title = "Work Visa Issuing Form"
	available_on_ntnet = 1

/datum/computer_file/report/recipient/sol/audit/generate_fields()
	var/datum/report_field/temp_field
	add_field(/datum/report_field/date, "Date")
	add_field(/datum/report_field/time, "Time")
	add_field(/datum/report_field/people/from_manifest, "Recipient of Work Visa")
	add_field(/datum/report_field/simple_text, "Species of Recipient")
	temp_field = add_field(/datum/report_field/signature, "Issuer of Work Visa Signature")
	add_field(/datum/report_field/signature, "Recipient of Work Visa Signature")
	add_field(/datum/report_field/options/yes_no, "Approved")
	temp_field.set_access(access_edit = access_representative)
