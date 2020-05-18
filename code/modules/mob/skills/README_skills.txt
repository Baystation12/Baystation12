User's Guide to Skills

1. How does the skill system work, and what are the relevant objects?
	Every skill is defined via a /decl/hierarchy/skill/skill_category/skill_name in skill.dm.
	These are initialized once and /decl/hierarchy/skill is stored in decls_repository. The actual skill instances are stored in GLOB.skills (this is a list).
	Every mob has a variable mob.skillset of type datum/skillset (or a subtype of that).
	The skillset contains all of the skill information for that mob, along with various procs for obtaining or manipulating it.
	Using those procs, you will be able to extract skill values from the mob. These should be positive integers between SKILL_MIN and SKILL_MAX.
	These values each have define corresponidng to them, starting with SKILL_. Use that define, not the number.

2. Where do skills come from?
	Most mobs (i.e. not player-controlled ones) will respond SKILL_DEFAULT when checked for skills.
	Players set up their skill preferences on a per-job basis in the player setup screen, under occupations. See below for more.
	At round start, these preferences are transferred over to the relevant mob. This is handled in the skillset.obtain_from_client proc.
	If a player is an antag, this is bypassed. Modify the skillset.set_antag_skills proc to change the antag behavior.
	When minds are transferred between mobs, the skillset is generally copied over to the new mob.
	Silicon mobs do not inherit skills in this way.

3. What do you do with skills?
	The correct way of obtaining the value of a mob's skill is to use the get_skill_value proc on the mob. It takes a skill path, which should be called via a corresponding SKILL_ define.
	Do not try to get the datum instance out of decls_repository; use the type path getter instead or else find it in GLOB.skills.
	The values can be used directly to make skill checks.
	Additional helper procs may be given to mobs to convert skill values into times, probabilities, or whatever in a reusable way.
	Currently implemented examples:
		skill_check(SKILL_PATH, SKILL_VALUE) returns 1 if the mob's skill is >= value.
		skill_delay_mult(SKILL_PATH, factor) gives a generic way to modify times via skills.
		do_skilled(base_delay, SKILL_PATH, atom/target, factor) is like do_after, but modifies the time by skill_delay_mult
		skill_fail_chance(SKILL_PATH, fail_chance, no_more_fail, factor) modifies fail probabilities according to skill.

4. What determines what skill options are available in player setup? How can you change them?
	Skill setup works largely on a per-job basis, with some per-species and branch modifiers.
	For each job, a minimum value can be assigned to any skill. To do this, add an entry of /decl/hierarchy/skill/skill_category/skill_name = min_value to that job datums's min_skill variable (this is a list).
	This minimum value is given for free to the player, and does not use up allocation points.
	For each job, a maximum value can also be assigned. Add a similar entry to the max_skills list.
	For each job, a base number of free points can be assigned. This is given in the job datum's skill_points variable (should be a number).
	Free point bonuses/penalties can be specified, for each species, as a function of a player's selected age. 
	This can be done by overwriting species datum's skills_from_age proc, which takes in the age and returns an integer (positive or negative) which will be added to all jobs' available skill points.
	Free point bonuses/penalties can be specified, for each species, as a function of the job.
	To do this, add the entry /datum/job/my_job = points_to_add to the species datum's job_skill_buffs variable (this is a list). Then points_to_add (positive or negative) will be added to that job's available skill points.
	Generally, if the free point allocations or min/max values turn out to be negative or otherwise contradictory, this will not result in runtime errors, so make sure to test whether your changes work as intended.

5. You want to make skill-related changes but are worried about whether they will break savefiles.
	Savefiles are on a per-job basis. Only affected jobs will have their savefiles reset.
	If a savefile represents a plausable skill point allocation, it will be imported; if not, a default skill allocation is used.
	In particular, changes which increase the number of free skill points, decrease minimum allocations, or increase maximum allocations, will not break savefiles.
	Changes which increase minimum allocations or decrease maximum allocations will not reset the entire allocation, but may leave extra unassigned points if the skill cap is reached.
	Changes which decrease the number of free points (including from species/age buffs) may reset the entire job's allocation.
	The size of the savefile roughly corresponds to the number of skills with nondefault allocations; this is only significant if many jobs have nondefault skill selections.

6. You are an admin and need to bus skill stuff.
	If you are antaging/unantaging someone via the traitor panel, this will usually change their skills.
	To make sure they have the correct skills (as in their prefs), you should check that the role (top item) is correct, in addition to their antag status.
	If you need to change their skill values directly, you can use VV on mob/skillset, in particular changing the values of the entries in skill_list.
	There is a show skills admin verb, that displays skill values of any human mob (pick from list) in a similar way to the player Show Own Skills verb.