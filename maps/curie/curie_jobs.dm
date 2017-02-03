/datum/map/curie
	allowed_jobs = list(
	/datum/job/captain,
	/datum/job/hop,
	/datum/job/warden,
	/datum/job/officer,
	/datum/job/lawyer,
	/datum/job/cmo,
	/datum/job/doctor,
	/datum/job/rd,
	/datum/job/scientist,
	/datum/job/chief_engineer,
	/datum/job/engineer,
	/datum/job/mining,
	/datum/job/cargo_tech,
	/datum/job/janitor,
	/datum/job/bartender,
	/datum/job/chaplain,
	/datum/job/ai,
	/datum/job/cyborg,
	)

/datum/job/captain
	title = "Captain"
	alt_titles = list("Commander", "Major")

/datum/job/hop
	title = "Lieutenant"
	alt_titles = list("First Officer", "Head of Personnel")

/datum/job/warden
	title = "Sergeant"
	alt_titles = list("Squad Leader", "Security Manager")

/datum/job/officer
	total_positions = 2
	spawn_positions = 2

/datum/job/lawyer
	alt_titles = list("Lawyer", "Attorney")
	total_positions = 1
	spawn_positions = 1

/datum/job/scientist
	total_positions = 2
	spawn_positions = 2

/datum/job/engineer
	total_positions = 2
	spawn_positions = 2

/datum/job/cargo_tech
	total_positions = 2
	spawn_positions = 2

/datum/antagonist/ert
	hard_cap = 4 // Autotraitor var. Won't spawn more than this many antags.
	hard_cap_round = 8 // As above but 'core' round antags ie. roundstart.
	initial_spawn_req = 2 // Gamemode using this template won't start without this # candidates.
	initial_spawn_target = 4 // Gamemode will attempt to spawn this many antags.

/datum/antagonist/mercenary
	hard_cap = 4
	hard_cap_round = 8
	initial_spawn_req = 2
	initial_spawn_target = 4

/datum/job/mining
	total_positions = 1
	spawn_positions = 1

/datum/job/bartende
	access = list(access_hydroponics, access_bar, access_kitchen)
	minimal_access = list(access_kitchen, access_bar)