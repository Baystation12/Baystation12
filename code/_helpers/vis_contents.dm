// Making these procs systematic in view of a future where we have a
// proper system for queuing/caching/updating vis contents cleanly.
#define add_vis_contents(A, B)    A.vis_contents |= (B)
#define remove_vis_contents(A, B) A.vis_contents -= (B)
#define clear_vis_contents(A)     A.vis_contents.Cut()
#define set_vis_contents(A, B)    A.vis_contents = (B)

/turf/proc/refresh_vis_contents()
	var/new_vis_contents = get_vis_contents_to_add()
	if(length(new_vis_contents))
		set_vis_contents(src, new_vis_contents)
	else if(length(vis_contents))
		clear_vis_contents(src)

/turf/proc/get_vis_contents_to_add()
	return
