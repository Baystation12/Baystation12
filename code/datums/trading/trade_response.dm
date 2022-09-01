/datum/trade_response
	var/text = "blah blah" //What the trader says
	var/money_delta = 0 //The amount of money to change in the bank
	var/success = TRUE //Whether the action was a failure

/datum/trade_response/New(t, m, s, i)
	text = t
	money_delta = m
	success = s
