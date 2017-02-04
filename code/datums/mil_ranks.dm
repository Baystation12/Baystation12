/**
 *  Datums for military branches and ranks
 *
 *  Map datums can optionally specify a list of /datum/mil_branch paths. These paths
 *  are used to initialize the global mil_branches object, which contains a list of
 *  branch objects the map uses. Each branch definition specifies a list of
 *  /datum/mil_rank paths, which are ranks available to that branch.
 *
 *  Which branches and ranks can be selected for spawning is specifed in using_map
 *  and each branch datum definition, respectively.
 */

var/datum/mil_branches/mil_branches = new()

/**
 *  Global object for handling branches
 */
/datum/mil_branches
	var/list/branches            // All branches that exist
	var/list/spawn_branches  // Branches that a player can choose for spawning.

/**
 *  Retrieve branch object by branch name
 */
/datum/mil_branches/proc/get_branch(var/branch_name)
	if(branch_name == "None" || !(branch_name in branches))
		return null
	else
		return branches[branch_name]

/**
 *  Retrieve branch object by branch type
 */
/datum/mil_branches/proc/get_branch_by_type(var/branch_type)
	for(var/name in branches)
		if (istype(branches[name], branch_type))
			return branches[name]

/**
 *  Retrieve a rank object from given branch by name
 */
/datum/mil_branches/proc/get_rank(var/branch_name, var/rank_name)
	if(rank_name == "None")
		return null

	var/datum/mil_branch/branch = get_branch(branch_name)

	if(!branch || !(rank_name in branch.ranks))
		return null

	var/datum/mil_rank/rank = branch.ranks[rank_name]
	return rank

/**
 *  Return a true value if branch_name is a valid spawn branch key
 */
/datum/mil_branches/proc/is_spawn_branch(var/branch_name)
	return branch_name in spawn_branches


/**
 *  Return a true value if rank_name is a valid spawn rank in branch under branch_name
 */
/datum/mil_branches/proc/is_spawn_rank(var/branch_name, var/rank_name)
	var/datum/mil_branch/branch = get_branch(branch_name)

	if(branch && (rank_name in branch.spawn_ranks))
		return 1
	else
		return 0

/**
 *  A single military branch, such as Fleet or Marines
 */
/datum/mil_branch
	var/name = "Unknown"         // Longer name for branch, eg "Sol Central Marine Corps"
	var/name_short = "N/A"       // Abbreviation of the name, eg "SCMC"



	var/list/ranks // Associative list of full rank names to the corresponding
	               // /datum/mil_rank objects. These are all ranks available to the branch.

	var/list/spawn_ranks // Ranks which the player can choose for spawning

	var/list/rank_types       // list of paths used to init the ranks list
	var/list/spawn_rank_types // list of paths used to init the spawn_ranks list. Subset of rank_types

	var/assistant_job //what people who have the BE_ASSISTANT pref set will attempt to join as

/datum/mil_branch/New()
	ranks = list()
	spawn_ranks = list()

	for(var/rank_path in rank_types)
		if(!ispath(rank_path, /datum/mil_rank))
			crash_with("[name]'s rank_types includes [rank_path], which is not a subtype of /datum/mil_rank.")
			continue
		var/datum/mil_rank/rank = new rank_path ()
		ranks[rank.name] = rank

		if(rank_path in spawn_rank_types)
			spawn_ranks[rank.name] = rank

/**
 *  Populate the global branches list from using_map
 */
/hook/startup/proc/populate_branches()
	if(!(using_map.flags & MAP_HAS_BRANCH) && !(using_map.flags & MAP_HAS_RANK))
		mil_branches.branches  = null
		mil_branches.spawn_branches = null
		return 1

	mil_branches.branches  = list()
	mil_branches.spawn_branches = list()
	for(var/branch_path in using_map.branch_types)
		if(!ispath(branch_path, /datum/mil_branch))
			crash_with("populate_branches() attempted to instantiate object with path [branch_path], which is not a subtype of /datum/mil_branch.")
			continue

		var/datum/mil_branch/branch = new branch_path ()
		mil_branches.branches[branch.name] = branch

		if(branch_path in using_map.spawn_branch_types)
			mil_branches.spawn_branches[branch.name] = branch

	return 1

/**
 *  A military rank
 *
 *  Note that in various places "rank" is used to refer to a character's job, and
 *  so this is  "mil_rank" to distinguish it.
 */
/datum/mil_rank
	var/name = "Unknown"
	var/name_short = "N/A" // Abbreviation of the name. Should be null if the
	                       // rank doesn't usually serve as a prefix to the individual's name.
	var/list/accessory		//type of accesory that will be equipped by job code with this rank
