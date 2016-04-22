
/*
	Each ckey has three votes, one for high/medium/low.
	Each option can only have one vote from a given ckey, no matter if it's high/medium/low.
*/
/datum/vote/method/high_med_low
	vote_span = 3
	var/list/votes

/datum/vote/method/high_med_low/ui_data()

/datum/vote/method/high_med_low/Topic()
