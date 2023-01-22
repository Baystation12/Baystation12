/obj/structure/diona_gestalt/proc/start_vote(mob/voter, vote_type)

	if(current_vote)
		to_chat(voter, SPAN_WARNING("There is already a vote in progress."))
		return

	current_vote = new vote_type(src, voter)

	if(!nymphs || length(nymphs) < current_vote.minimum_nymphs)
		to_chat(voter, SPAN_WARNING("There are not enough nymphs in the gestalt for this form to be viable."))
		QDEL_NULL(current_vote)
		return

	for(var/thing in nymphs)
		to_chat(thing, SPAN_NOTICE("<b>\The [voter]</b> has called a vote to <i>[current_vote.descriptor]</i>. Click <a href='?src=\ref[current_vote];voter=\ref[thing]'>here</a> to vote yes. \
		The vote will conclude in [current_vote.vote_time / 600] minute\s."))
