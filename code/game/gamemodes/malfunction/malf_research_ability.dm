/datum/malf_research_ability
	var/ability = null 									// Path to verb which will be given to the AI when researched.
	var/name = "Unknown Ability"						// Name of this ability
	var/price = 0										// Amount of CPU time needed to unlock this ability.
	var/invested = 0 									// Amount of CPU time already used to research this ability. When larger or equal to price unlocks the ability.
	var/unlocked = 0									// Changed to 1 when fully researched.
	var/datum/malf_research_ability/next = null			// Next research (if applicable).


/datum/malf_research_ability/proc/process(var/time = 0)
	invested += time
	if(invested >= price)
		unlocked = 1


// ABILITIES BEGIN HERE
// NETWORKING TREE
/datum/malf_research_ability/networking/basic_hack
	ability = new/datum/game_mode/malfunction/verb/basic_encryption_hack()
	price = 25
	next = new/datum/malf_research_ability/networking/advanced_hack()
	name = "Basic Encryption Hack"


/datum/malf_research_ability/networking/advanced_hack
	ability = new/datum/game_mode/malfunction/verb/advanced_encryption_hack()
	price = 400
	next = new/datum/malf_research_ability/networking/elite_hack()
	name = "Advanced Encryption Hack"


/datum/malf_research_ability/networking/elite_hack
	ability = new/datum/game_mode/malfunction/verb/elite_encryption_hack()
	price = 1000
	next = new/datum/malf_research_ability/networking/system_override()
	name = "Elite Encryption Hack"


/datum/malf_research_ability/networking/system_override
	ability = new/datum/game_mode/malfunction/verb/system_override()
	price = 2750
	name = "System Override"



// INTERDICTION TREE
/datum/malf_research_ability/interdiction/recall_shuttle
	ability = new/datum/game_mode/malfunction/verb/recall_shuttle()
	price = 75
	next = new/datum/malf_research_ability/interdiction/unlock_cyborg()
	name = "Recall Shuttle"


/datum/malf_research_ability/interdiction/unlock_cyborg
	ability = new/datum/game_mode/malfunction/verb/unlock_cyborg()
	price = 1200
	next = new/datum/malf_research_ability/interdiction/hack_cyborg()
	name = "Unlock Cyborg"


/datum/malf_research_ability/interdiction/hack_cyborg
	ability = new/datum/game_mode/malfunction/verb/hack_cyborg()
	price = 3000
	next = new/datum/malf_research_ability/interdiction/hack_ai()
	name = "Hack Cyborg"


/datum/malf_research_ability/interdiction/hack_ai
	ability = new/datum/game_mode/malfunction/verb/hack_ai()
	price = 7500
	name = "Hack AI"



// MANIPULATION TREE
/datum/malf_research_ability/manipulation/electrical_pulse
	ability = new/datum/game_mode/malfunction/verb/electrical_pulse()
	price = 50
	next = new/datum/malf_research_ability/manipulation/hack_camera()
	name = "Electrical Pulse"


/datum/malf_research_ability/manipulation/hack_camera
	ability = new/datum/game_mode/malfunction/verb/hack_camera()
	price = 1200
	next = new/datum/malf_research_ability/manipulation/emergency_forcefield()
	name = "Hack Camera"


/datum/malf_research_ability/manipulation/emergency_forcefield
	ability = new/datum/game_mode/malfunction/verb/emergency_forcefield()
	price = 3000
	next = new/datum/malf_research_ability/manipulation/machine_overload()
	name = "Emergency Forcefield"


/datum/malf_research_ability/manipulation/machine_overload
	ability = new/datum/game_mode/malfunction/verb/machine_overload()
	price = 7500
	name = "Machine Overload"