
/datum/vote/proc/calculate_result()
	//get the highest number of votes
	var/greatest_votes = 0
	var/second_greatest_votes = 0
	var/third_greatest_votes = 0

	for(var/option in choices)
		var/votes = choices[option]
		total_votes += votes
		if(votes > greatest_votes)
			third_greatest_votes = second_greatest_votes
			second_greatest_votes = greatest_votes
			greatest_votes = votes
		else if(votes > second_greatest_votes)
			third_greatest_votes = second_greatest_votes
			second_greatest_votes = votes
		else if(votes > third_greatest_votes)
			third_greatest_votes = votes

	//get all options with that many votes and return them in a list
	var/first = list()
	var/second = list()
	var/third = list()
	for(var/option in choices)
		if(choices[option] == greatest_votes && greatest_votes)
			first += option
		else if(choices[option] == second_greatest_votes && second_greatest_votes)
			second += option
		else if(choices[option] == third_greatest_votes && third_greatest_votes)
			third += option
	return list(first, second, third)
