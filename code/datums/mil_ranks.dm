/**
 *  Datums for military branches and ranks
 *
 *  Map datums can optionally specify a list of /datum/mil_branch paths. These paths
 *  are used to initialize the global branches list on server startup. Each branch 
 *  object has a list of /datum/mil_rank paths; these are instantiated when the branch
 *  object is created.
 *
 *  To retrieve a rank object, retrieve the branch from the global branches list by
 *  name, then retrieve from it the rank object by name. 
 */
 

var/list/mil_branches        // All branches that exist
var/list/spawn_mil_branches  // Branches that a player can choose for spawning.
 
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
		mil_branches = null
		spawn_mil_branches = null
		return 1
		
	mil_branches = list()
	spawn_mil_branches = list()
	for(var/branch_path in using_map.branch_types)
		if(!ispath(branch_path, /datum/mil_branch))
			crash_with("populate_branches() attempted to instantiate object with path [branch_path], which is not a subtype of /datum/mil_branch.")
			continue
	
		var/datum/mil_branch/branch = new branch_path ()
		mil_branches[branch.name] = branch
		
		if(branch_path in using_map.spawn_branch_types)
			spawn_mil_branches[branch.name] = branch
		
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
	