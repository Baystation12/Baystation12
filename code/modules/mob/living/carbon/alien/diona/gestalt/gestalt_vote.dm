/obj/structure/diona_gestalt/proc/start_vote(var/mob/voter, var/vote_type)

	if(current_vote)
		to_chat(voter, "<span class='warning'>There is already a vote in progress.</span>")
		return

	current_vote = new vote_type(src, voter)

	if(!nymphs || nymphs.len < current_vote.minimum_nymphs)
		to_chat(voter, "<span class='warning'>There are not enough nymphs in the gestalt for this form to be viable.</span>")
		QDEL_NULL(current_vote)
		return

	for(var/thing in nymphs)
		to_chat(thing, "<span class='notice'><b>\The [voter]</b> has called a vote to <i>[current_vote.descriptor]</i>. Click <a href='?src=\ref[current_vote];voter=\ref[thing]'>here</a> to vote yes. \
		The vote will conclude in [current_vote.vote_time / 600] minute\s.</span>")

