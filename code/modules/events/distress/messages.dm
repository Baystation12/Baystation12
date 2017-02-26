/*********************
ENGINEERING MESSAGES
**********************/
/datum/event/distress/proc/generate_message()
	var/message = "[pick(start)]This is [pick(sender)]We are in a critical situation because [pick(reasons)]Our current situation is [pick(status)]Please send help!"
	return(message)

var/list/start = list(
	"Mayday, Mayday! ",
	"To whom it may concern. ",
	"Hello?! Can anyone hear me? ",
	"[station_name()], are you receiving? ",
	"By the ancients, please help! "
	)

var/list/sender = list(
	"a harmless Tajaran merchant ship. ",
	"the Glaxy Ranger patrol. ",
	"a consular ship on an unrecorded flight. ",
	"the independent freighter IK-[rand(1300, 6735)]. ",
	"an official representative of NanoTrasen. "
	)

var/list/reasons = list(
	"spacecarp broke through the hull and ate our captain! ",
	"a person in weird robes is terrorizing our crew and damaged the ship. ",
	"there has been an explosion in the engine room. We are drifting. ",
	"pirates stole all our supllies. ",
	"our incinerator unit overheated and melted half the ship. ",
	"we had an unfortunate run-in with an asteroid. ",
	"Members of the crew in strange robes are on the loose and causing absolute mayhem. "
	)

var/list/status = list(
	"completely untennable. ",
	"approaching critical. ",
	"not overly urgent. ",
	"absolutely hopeless without help. ",
	"not that bad, but could get worse any second. ",
	"the second worst mess I have ever found myself in. "
	)