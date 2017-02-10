//The following is a list of defs to be used for the Torch loadout.

//For all SolGov personnel, representative included
#define SOLGOV_ROLES list("Commanding Officer", "Executive Officer", "Chief Medical Officer", "Chief Engineer", "Chief of Security", "Bridge Officer", "Senior Enlisted Advisor", "Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Master at Arms", "Senior Physician", "Physician", "Deck Officer", "Deck Technician", "Sanitation Technician", "Cook", "Crewman", "SolGov Representative", "SolGov Pilot")

//For EC/Fleet/Marines
#define MILITARY_ROLES list("Commanding Officer", "Executive Officer", "Chief Medical Officer", "Chief Engineer", "Chief of Security", "Bridge Officer", "Senior Enlisted Advisor", "Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Master at Arms", "Senior Physician", "Physician", "Deck Officer", "Deck Technician", "Sanitation Technician", "Cook", "Crewman", "SolGov Pilot")

//For EC/Fleet/Marine Officers
#define MILITARY_OFFICER_ROLES list("Commanding Officer", "Executive Officer", "Chief Medical Officer", "Chief Engineer", "Chief of Security", "Bridge Officer", "Senior Physician", "Deck Officer", "SolGov Pilot")

//For EC/Fleet/Marine Enlisted
#define MILITARY_ENLISTED_ROLES list("Senior Enlisted Advisor", "Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Master at Arms", "Senior Physician", "Physician", "Deck Officer", "Deck Technician", "Sanitation Technician", "Cook", "Crewman")

//For all civilians or off-duty personnel, regardless of formality of dress or job.
#define NON_MILITARY_ROLES list("Research Director", "NanoTrasen Liaison", "Senior Researcher", "NanoTrasen Pilot", "Scientist", "Prospector", "Security Guard", "Research Assistant", "SolGov Representative", "Passenger", "Maintenance Assistant", "Roboticist", "Medical Assistant", "Virologist", "Chemist", "Counselor", "Supply Assistant", "Bartender", "Merchant", "Off-Duty")

//For jobs that allow for decorative or ceremonial clothing
#define FORMAL_ROLES list("NanoTrasen Liaison", "SolGov Representative", "Passenger", "Bartender", "Merchant", "Off-Duty")

//For civilian jobs that may have a uniform, but not a strict one
#define SEMIFORMAL_ROLES list("Passenger", "Prospector", "Research Assistant", "Counselor", "Bartender", "Merchant", "NanoTrasen Pilot", "Off-Duty")

//For NanoTrasen employees
#define NANOTRASEN_ROLES list("Research Director", "NanoTrasen Liaison", "Senior Researcher", "NanoTrasen Pilot", "Scientist", "Prospector", "Security Guard", "Research Assistant")

//For contractors
#define CONTRACTOR_ROLES list("Maintenance Assistant", "Roboticist", "Medical Assistant", "Virologist", "Chemist", "Counselor", "Supply Assistant", "Bartender", "Cook", "Sanitation Technician")

//For corporate or government representatives
#define REPRESENTATIVE_ROLES list("SolGov Representative", "NanoTrasen Liaison")

//For roles with no uniform or formal clothing requirements
#define RESTRICTED_ROLES list("Passenger", "Bartender", "Merchant", "Off-Duty")

//For members of the command department
#define COMMAND_ROLES list("Commanding Officer", "Executive Officer", "Research Director", "Chief Medical Officer", "Chief Engineer", "Chief of Security", "Bridge Officer", "Senior Enlisted Advisor")

//For members of the medical department
#define MEDICAL_ROLES list("Chief Medical Officer", "Senior Physician", "Physician", "Medical Assistant", "Virologist", "Chemist", "Counselor")

//For members of the medical department and roboticists
#define ALL_MEDICAL_ROLES list("Chief Medical Officer", "Senior Physician", "Physician", "Medical Assistant", "Virologist", "Chemist", "Counselor", "Roboticist")

//For members of the engineering department
#define ENGINEERING_ROLES list("Chief Engineer", "Senior Engineer", "Engineer", "Maintenance Assistant", "Roboticist")

//For members of the security department
#define SECURITY_ROLES list("Chief of Security", "Brig Officer", "Forensic Technician", "Master at Arms")

//For members of the supply department
#define SUPPLY_ROLES list("Deck Officer", "Deck Technician", "Supply Assistant")

//For members of the service department
#define SERVICE_ROLES list("Sanitation Technician", "Cook", "Crewman", "Bartender")

//For members of the research department and jobs that are scientific
#define RESEARCH_ROLES list("Research Director", "NanoTrasen Liaison", "Scientist", "Prospector", "Security Guard", "Research Assistant", "Passenger", "NanoTrasen Pilot", "Senior Researcher", "Chemist", "Roboticist", "Virologist")