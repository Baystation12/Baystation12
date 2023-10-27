//Sierra ID Cards (they have to be here to make the outfits work, no way around it)

/obj/item/card/id/sierra
	name = "identification card"
	desc = "An identification card issued to personnel aboard the NSV Sierra."
	job_access_type = /datum/job/assistant

/obj/item/card/id/sierra/silver
	desc = "A silver identification card belonging to heads of staff."
	item_state = "silver_id"
	job_access_type = /datum/job/hop
	extra_details = list("goldstripe")
	color = "#ccecff"

/obj/item/card/id/sierra/gold
	desc = "A golden identification card belonging to the Captain."
	item_state = "gold_id"
	job_access_type = /datum/job/captain
	color = "#d4c780"
	extra_details = list("goldstripe")

// NanoTrasen Personnel and Passengers
/obj/item/card/id/sierra/passenger
	desc = "An identification card issued to passengers aboard the NSV Sierra."
	job_access_type = /datum/job/assistant
	color = "#ccecff"

/obj/item/card/id/sierra/crew
	desc = "An identification card issued to NanoTrasen crewmembers aboard the NSV Sierra."
	job_access_type = /datum/job/assistant
	color = "#ccecff"

/obj/item/card/id/sierra/crew/medical
	desc = "An identification card issued to medical crewmembers aboard the NSV Sierra."
	job_access_type = /datum/job/doctor
	detail_color = COLOR_PALE_BLUE_GRAY

/obj/item/card/id/sierra/silver/medical
	job_access_type = /datum/job/cmo
	detail_color = COLOR_PALE_BLUE_GRAY

/obj/item/card/id/sierra/crew/medical/senior
	job_access_type = /datum/job/senior_doctor

/obj/item/card/id/sierra/crew/medical/trainee
	job_access_type = /datum/job/doctor_trainee

/obj/item/card/id/sierra/crew/medical/chemist
	job_access_type = /datum/job/chemist

/obj/item/card/id/sierra/crew/medical/counselor
	job_access_type = /datum/job/psychiatrist

//Security

/obj/item/card/id/sierra/silver/security
	job_access_type = /datum/job/hos
	detail_color = "#e00000"
	extra_details = list("onegoldstripe")

/obj/item/card/id/sierra/crew/security
	desc = "An identification card issued to asset protection depatment's personnel aboard the NSV Sierra."
	job_access_type = /datum/job/officer
	detail_color = "#e00000"

/obj/item/card/id/sierra/crew/security/cadet
	job_access_type = /datum/job/security_assistant

/obj/item/card/id/sierra/crew/security/warden
	job_access_type = /datum/job/warden
	extra_details = list("onegoldstripe")

/obj/item/card/id/sierra/crew/security/detective
	job_access_type = /datum/job/detective

//Engineering

/obj/item/card/id/sierra/silver/engineering
	job_access_type = /datum/job/chief_engineer
	detail_color = COLOR_SUN
	extra_details = list("onegoldstripe")

/obj/item/card/id/sierra/crew/engineering
	desc = "An identification card issued to engineering personnel aboard the NSV Sierra."
	job_access_type = /datum/job/engineer
	detail_color = COLOR_SUN

/obj/item/card/id/sierra/crew/engineering/senior
	job_access_type = /datum/job/senior_engineer
	extra_details = list("onegoldstripe")

/obj/item/card/id/sierra/crew/engineering/trainee
	job_access_type = /datum/job/engineer_trainee

/obj/item/card/id/sierra/crew/engineering/comms
	job_access_type = /datum/job/infsys



/obj/item/card/id/sierra/crew/supply/quartermaster
	job_access_type = /datum/job/qm
	detail_color = COLOR_BROWN
	extra_details = list("onegoldstripe")

/obj/item/card/id/sierra/crew/supply
	job_access_type = /datum/job/cargo_tech
	detail_color = COLOR_BROWN

/obj/item/card/id/sierra/crew/supply/mining
	job_access_type = /datum/job/mining

/obj/item/card/id/sierra/crew/supply/assistant
	job_access_type = /datum/job/cargo_assistant



/obj/item/card/id/sierra/crew/service //unused
	desc = "An identification card issued to service personnel aboard the NSV Sierra."
	detail_color = COLOR_CIVIE_GREEN

/obj/item/card/id/sierra/crew/service/chief_steward
	job_access_type = /datum/job/chief_steward
	extra_details = list("onegoldstripe")

/obj/item/card/id/sierra/crew/service/janitor
	job_access_type = /datum/job/janitor

/obj/item/card/id/sierra/crew/service/cook
	job_access_type = /datum/job/cook

/obj/item/card/id/sierra/crew/service/steward
	job_access_type = /datum/job/steward

/obj/item/card/id/sierra/crew/service/bartender
	job_access_type = /datum/job/bartender

/obj/item/card/id/sierra/crew/service/chaplain
	job_access_type = /datum/job/chaplain

/obj/item/card/id/sierra/crew/service/actor
	job_access_type = /datum/job/actor

//Explorers

/obj/item/card/id/sierra/crew/exploration_leader
	job_access_type = /datum/job/exploration_leader
	detail_color = COLOR_PURPLE
	extra_details = list("onegoldstripe")

/obj/item/card/id/sierra/crew/explorer
	job_access_type = /datum/job/explorer
	detail_color = COLOR_PURPLE

/obj/item/card/id/sierra/crew/pilot
	job_access_type = /datum/job/explorer_pilot
	detail_color = COLOR_PURPLE

/obj/item/card/id/sierra/crew/field_medic
	job_access_type = /datum/job/explorer_medic
	detail_color = COLOR_PURPLE

/obj/item/card/id/sierra/crew/field_engineer
	job_access_type = /datum/job/explorer_engineer
	detail_color = COLOR_PURPLE

//Research

/obj/item/card/id/sierra/crew/research
	desc = "A card issued to research personnel aboard the NSV Sierra."
	job_access_type = /datum/job/scientist_assistant
	detail_color = COLOR_RESEARCH
	color = COLOR_WHITE

/obj/item/card/id/sierra/silver/research
	job_access_type = /datum/job/rd
	detail_color = COLOR_RESEARCH
	color = COLOR_WHITE
	extra_details = list("onegoldstripe")

/obj/item/card/id/sierra/crew/research/senior_scientist
	job_access_type = /datum/job/senior_scientist

/obj/item/card/id/sierra/crew/research/scientist
	job_access_type = /datum/job/scientist

/obj/item/card/id/sierra/crew/research/roboticist
	job_access_type = /datum/job/roboticist

/obj/item/card/id/sierra/crew/liaison
	desc = "A card issued to corporate represenatives aboard the NSV Sierra."
	job_access_type = /datum/job/iaa
	color = COLOR_GRAY40
	detail_color = COLOR_COMMAND_BLUE
	extra_details = list("onegoldstripe")

/obj/item/card/id/sierra/crew/adjutant
	desc = "A card issued to command's support personnel aboard the NSV Sierra."
	job_access_type = /datum/job/adjutant
	color = "#ccecff"
	detail_color = COLOR_COMMAND_BLUE

//Merchant
/obj/item/card/id/sierra/merchant
	desc = "An identification card issued to Merchants."
	color = COLOR_OFF_WHITE
	detail_color = COLOR_BEIGE

/obj/item/card/id/sierra/merchant/leader
	desc = "An identification card issued to Merchant Leaders, indicating their right to sell and buy goods."
