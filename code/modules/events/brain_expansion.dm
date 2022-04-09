/*
	"Brain expansion"
	Rare, short event that makes every item worth one more research point for a small while

	All relevant code is run in /datum/research/proc/UpdateTech
*/

/datum/event/brain_expansion
	startWhen	= 0
	endWhen		= 150

/datum/event/brain_expansion/announce()
	command_announcement.Announce("Abnormal efficiency rates detected in destructive analysis neural networks. Analysis results may be impacted.", "[location_name()] Neural Network Monitor", zlevels = affecting_z)

/datum/event/brain_expansion/end()
	command_announcement.Announce("The destructive analysis neural network has returned to a normal state.", "[location_name()] Neural Network Monitor", zlevels = affecting_z)