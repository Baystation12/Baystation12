//The following is a list of defs to be used for the Torch loadout.

//For all SolGov personnel, representative included
#define SOLGOV_ROLES list("Commanding Officer", "Executive Officer", "Chief Medical Officer", "Chief Engineer", "Chief of Security", "Bridge Officer", "Senior Enlisted Advisor", "Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Master at Arms", "Physician", "Corpsman", "Deck Officer", "Deck Technician", "Sanitation Technician", "Cook", "Crewman", "SolGov Representative", "SolGov Pilot")

//For EC/Fleet/Marines
#define MILITARY_ROLES list("Commanding Officer", "Executive Officer", "Chief Medical Officer", "Chief Engineer", "Chief of Security", "Bridge Officer", "Senior Enlisted Advisor", "Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Master at Arms", "Physician", "Corpsman", "Deck Officer", "Deck Technician", "Sanitation Technician", "Cook", "Crewman", "SolGov Pilot")

//For EC/Fleet/Marine Officers
#define MILITARY_OFFICER_ROLES list("Commanding Officer", "Executive Officer", "Chief Medical Officer", "Chief Engineer", "Chief of Security", "Bridge Officer", "Physician", "Deck Officer", "SolGov Pilot")

//For EC/Fleet/Marine Enlisted
#define MILITARY_ENLISTED_ROLES list("Senior Enlisted Advisor", "Senior Engineer", "Engineer", "Brig Officer", "Forensic Technician", "Master at Arms", "Physician", "Corpsman", "Deck Officer", "Deck Technician", "Sanitation Technician", "Cook", "Crewman")

//For all civilians or off-duty personnel, regardless of formality of dress or job.
#define NON_MILITARY_ROLES list("Research Director", "NanoTrasen Liaison", "Senior Researcher", "NanoTrasen Pilot", "Scientist", "Prospector", "Security Guard", "Research Assistant", "SolGov Representative", "Passenger", "Maintenance Assistant", "Roboticist", "Medical Contractor", "Chemist", "Counselor", "Supply Assistant", "Bartender", "Merchant", "Off-Duty","Stowaway")

//For jobs that allow for decorative or ceremonial clothing
#define FORMAL_ROLES list("NanoTrasen Liaison", "Research Director", "Senior Researcher", "Scientist", "Research Assistant", "SolGov Representative", "Passenger", "Bartender", "Merchant", "Off-Duty","Stowaway")

//For civilian jobs that may have a uniform, but not a strict one
#define SEMIFORMAL_ROLES list("Passenger", "Prospector", "Research Assistant", "Counselor", "Bartender", "Merchant", "NanoTrasen Pilot", "Off-Duty","Stowaway")

//For civilian jobs that may have a strict uniform.
#define SEMIANDFORMAL_ROLES list("Passenger", "Prospector", "Research Assistant", "Counselor", "Bartender", "Merchant", "NanoTrasen Pilot", "Off-Duty", "NanoTrasen Liaison", "Research Director", "Senior Researcher", "Scientist", "SolGov Representative","Stowaway")

//For NanoTrasen employees
#define NANOTRASEN_ROLES list("Research Director", "NanoTrasen Liaison", "Senior Researcher", "NanoTrasen Pilot", "Scientist", "Prospector", "Security Guard", "Research Assistant")

//For contractors
#define CONTRACTOR_ROLES list("Maintenance Assistant", "Roboticist", "Medical Contractor", "Chemist", "Counselor", "Supply Assistant", "Bartender", "Cook", "Sanitation Technician")

//For corporate or government representatives
#define REPRESENTATIVE_ROLES list("SolGov Representative", "NanoTrasen Liaison")

//For roles with no uniform or formal clothing requirements
#define RESTRICTED_ROLES list("Passenger", "Bartender", "Merchant", "Off-Duty","Stowaway")

//For members of the command department
#define COMMAND_ROLES list("Commanding Officer", "Executive Officer", "Research Director", "Chief Medical Officer", "Chief Engineer", "Chief of Security", "Bridge Officer", "Senior Enlisted Advisor")

//For members of the medical department
#define MEDICAL_ROLES list("Chief Medical Officer", "Physician", "Corpsman", "Medical Contractor", "Chemist", "Counselor")

//For members of the medical department, roboticists, and some Research
#define STERILE_ROLES list("Chief Medical Officer", "Physician", "Corpsman", "Medical Contractor", "Chemist", "Counselor", "Roboticist", "Research Director", "Senior Researcher", "Scientist", "Research Assistant")

//For members of the engineering department
#define ENGINEERING_ROLES list("Chief Engineer", "Senior Engineer", "Engineer", "Maintenance Assistant", "Roboticist")

//For members of Engineering, Cargo, and Research
#define TECHNICAL_ROLES list("Senior Engineer", "Engineer", "Maintenance Assistant", "Roboticist", "Deck Officer", "Deck Technician", "Supply Assistant", "Prospector", "Research Assistant", "Merchant", "Research Director", "Senior Researcher", "Scientist", "Chief Engineer", "Sanitation Technician")

//For members of the security department
#define SECURITY_ROLES list("Chief of Security", "Brig Officer", "Forensic Technician", "Master at Arms")

//For members of the supply department
#define SUPPLY_ROLES list("Deck Officer", "Deck Technician", "Supply Assistant")

//For members of the service department
#define SERVICE_ROLES list("Sanitation Technician", "Cook", "Crewman", "Bartender")

//For members of the research department and jobs that are scientific
#define RESEARCH_ROLES list("Research Director", "NanoTrasen Liaison", "Scientist", "Prospector", "Security Guard", "Research Assistant", "Passenger", "NanoTrasen Pilot", "Senior Researcher", "Chemist", "Roboticist", "Virologist")


/* BRANCH RESTRICTIONS */
// All ranks in the civilian branch
#define CIVILIAN_BRANCH list("branches" = list("Civilian"), "ranks" = list("ALL"))

// Nanotrasen rank only in the civilian branch
#define NANOTRASEN_BRANCH list("branches" = list("Civilian"), "ranks" = list("NanoTrasen"))

// All military branches
#define MILITARY_BRANCH list("branches" = list("Expeditionary Corps", "Fleet", "Marine Corps"), "ranks" = list("ALL"))