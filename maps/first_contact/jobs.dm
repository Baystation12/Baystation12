
/datum/map/first_contact
	allowed_jobs = list(\
	/datum/job/colonist,
	/datum/job/colonist/mayor,
	/datum/job/colonist/aerodrome,
	/datum/job/colonist/biodome_worker,
	/datum/job/colonist/casino_owner,
	/datum/job/colonist/hospital_worker,
	/datum/job/colonist/pharmacist,
	/datum/job/colonist/colonist_marshall,
	/datum/job/colonist/bartender,
	/datum/job/colonist/chef,
	/datum/job/colonist/librarian_museum,
	/datum/job/first_contact_kigyar,
	/datum/job/first_contact_unggoy,
	/datum/job/first_contact_innie,
	/datum/job/first_contact_unsc)

	allowed_spawns = list(\
		DEFAULT_SPAWNPOINT_ID)

	default_spawn = DEFAULT_SPAWNPOINT_ID

/datum/job/first_contact_kigyar
	title = "Kig-Yar"
	total_positions = 11
	outfit_type = /decl/hierarchy/outfit //nekked
	whitelisted_species = list(/datum/species/kig_yar)
	intro_blurb = "You have arrived in a system which, through a variety of sources, you believe contains great treasure and even an undiscovered sapient species. Preparing them for integration with the empire would surely gain the favour of the Heirarchs.."

/datum/job/first_contact_unggoy
	title = "Unggoy"
	total_positions = 7
	outfit_type = /decl/hierarchy/outfit/fc_unggoy
	whitelisted_species = list(/datum/species/unggoy)
	intro_blurb = "You have resided on this vessel for a long time, at the beck-and-call of your Kig-Yar shipowners. Assisting them in their tasks may give the Heirarchs a reason to reassign you to a different duty."

/datum/job/first_contact_innie
	title = "Insurrectionist"
	total_positions = 18
	outfit_type = /decl/hierarchy/outfit/job/ks7_colonist/innie
	whitelisted_species = list(/datum/species/human)
	intro_blurb = "You have taken over a crashed supply vessel as your base of operations for your newly formed insurrectionist cell. The docking apparatus is concealed and you cannot re-enter if you leave."

/datum/job/first_contact_unsc
	title = "UNSC Crewman"
	total_positions = 18
	outfit_type = /decl/hierarchy/outfit/job/ks7_unsc
	whitelisted_species = list(/datum/species/human)
	intro_blurb = "You have been tasked to act as diplomatic personnel with the goal of establishing and maintaining a line of contact to the independent colony on KS7, New Pompeii."
	access = list(access_unsc_crew)