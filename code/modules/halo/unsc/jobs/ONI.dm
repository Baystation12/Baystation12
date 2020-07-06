
/datum/job/unsc/oni
	access = list(access_unsc,access_unsc_oni)
	spawnpoint_override = null
	fallback_spawnpoint = null

/datum/job/unsc/oni/research
	title = "ONI Researcher"
	supervisors = "the ONI Research Director"
	total_positions = 2
	spawn_positions = 2
	outfit_type = /decl/hierarchy/outfit/job/unsc/oni/research
	alt_titles = list("ONI Doctor","ONI Physicist","ONI Botanist","ONI Chemist","ONI Weapons Researcher","ONI Surgeon","ONI Geneticist")

/datum/job/unsc/oni/research/director
	title = "ONI Research Director"
	supervisors = "the directors of ONI Section III"
	total_positions = 1
	spawn_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/unsc/oni/research/director

/datum/job/unsc/oni/guard
	title = "ONI Security Guard"
	supervisors = "the ONI Security Commander"
	outfit_type = /decl/hierarchy/outfit/job/unsc/oni/guard

/datum/job/unsc/oni/guard/commander
	title = "ONI Security Commander"
	supervisors = "the ONI Research Director"
	total_positions = 1
	spawn_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/unsc/oni/guard/commander
