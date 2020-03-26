/datum/map/persistence
	allowed_jobs = list(/datum/job/assistant)

/datum/job/assistant
	title = "Deck Hand"
	supervisors = "literally everyone, you bottom feeder"
	outfit_type = /decl/hierarchy/outfit/job/outreach/hand
	alt_titles = list("Passenger")
	hud_icon = "hudcargotechnician"

/decl/hierarchy/outfit/job/outreach/
	hierarchy_type = /decl/hierarchy/outfit/job/outreach
	pda_type = /obj/item/modular_computer/pda
	pda_slot = slot_l_store
	l_ear = null
	r_ear = null

/decl/hierarchy/outfit/job/outreach/hand
	name = "Deck Hand"