
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

/datum/job/colonist
	title = "KS7 Colonist"
	total_positions = -1
	//spawnpoint_override = "Colony Arrival Shuttle"
	selection_color = "#000000"
	spawn_faction = "Human Colony"
	supervisors = " the Colony Mayor"
	account_allowed = 1
	generate_email = 1
	loadout_allowed = TRUE
	outfit_type = /decl/hierarchy/outfit/job/ks7_colonist
	whitelisted_species = list(/datum/species/human)
	latejoin_at_spawnpoints = FALSE

/datum/job/colonist/mayor
	title = "KS7 Mayor"
	total_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/ks7_colonist/mayor

/datum/job/colonist/aerodrome
	title = "KS7 Aerodrome Technician"
	total_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/ks7_colonist/aerodrome

/datum/job/colonist/biodome_worker
	title = "KS7 Biodome Worker"
	total_positions = 4
	outfit_type = /decl/hierarchy/outfit/job/ks7_colonist/biodome_worker

/datum/job/colonist/casino_owner
	title = "KS7 Casino Owner"
	total_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/ks7_colonist/casino_owner

/datum/job/colonist/hospital_worker
	title = "KS7 Hospital Worker"
	total_positions = 3
	outfit_type = /decl/hierarchy/outfit/job/ks7_colonist/hospital_worker

/datum/job/colonist/pharmacist
	title = "KS7 Pharmacist"
	total_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/ks7_colonist/pharmacist

/datum/job/colonist/colonist_marshall
	title = "KS7 Colonist Marshall"
	total_positions = 5
	outfit_type = /decl/hierarchy/outfit/job/ks7_colonist/colonist_marshall

/datum/job/colonist/bartender
	title = "KS7 Bartender"
	total_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/ks7_colonist/bartender

/datum/job/colonist/chef
	title = "KS7 Chef"
	total_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/ks7_colonist/chef

/datum/job/colonist/librarian_museum
	title = "KS7 Librarian / Museum Worker"
	total_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/ks7_colonist/librarian_museum

/datum/job/first_contact_kigyar
	title = "Kig-Yar"
	total_positions = 11
	outfit_type = /decl/hierarchy/outfit //nekked

/datum/job/first_contact_unggoy
	title = "Unggoy"
	total_positions = 7
	outfit_type = /decl/hierarchy/outfit/fc_unggoy

/datum/job/first_contact_innie
	title = "Insurrectionist"
	total_positions = 18
	outfit_type = /decl/hierarchy/outfit/job/ks7_colonist/innie

/datum/job/first_contact_unsc
	title = "UNSC Crewman"
	total_positions = 18
	outfit_type = /decl/hierarchy/outfit/job/ks7_unsc