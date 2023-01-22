/*
	"Brain expansion"
	Rare, short event that makes every item worth one more research point for a small while

	All relevant code is run in /datum/research/proc/UpdateTech
*/

/datum/event/brain_expansion
	startWhen	= 0
	endWhen		= 150

/datum/event/brain_expansion/announce()
	command_announcement.Announce("Аномальные показатели эффективности обнаружены в нейронных сетях деструктивного анализа. Это может повлиять на результаты анализа.", "[station_name()] Neural Network Monitor", zlevels = affecting_z)

/datum/event/brain_expansion/end()
	command_announcement.Announce("Нейронная сеть деструктивного анализа вернулась в нормальное состояние.", "[station_name()] Neural Network Monitor", zlevels = affecting_z)
