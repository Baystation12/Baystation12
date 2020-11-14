/decl/hierarchy/outfit/job/infantry/
	name = "Infantry Outfit"

/decl/hierarchy/outfit/job/infantry/squadlead
	name = OUTFIT_JOB_NAME("Squad Lead")

/decl/hierarchy/outfit/job/infantry/tech
	name = OUTFIT_JOB_NAME("Combat Tech")

/decl/hierarchy/outfit/job/infantry/grunt
	name = OUTFIT_JOB_NAME("Rifleman")

/decl/hierarchy/outfit/job/infantry/New()
	..()
	BACKPACK_OVERRIDE_SECURITY

/decl/hierarchy/outfit/job/infantry/detective/New()
	..()
	backpack_overrides.Cut()