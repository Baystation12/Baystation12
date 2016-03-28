// /data/ files store data in string format.
// They don't contain other logic for now.
/datum/computer_file/data/news_article
	filetype = "XNML"
	filename = "Unknown News Entry"
	block_size = 1000 // Results in smaller files
	var/server_file_path 			// File path to HTML file that will be loaded on server start. Example: "space_magazine_1.html". Must be in /news_articles/ server folder.

/datum/computer_file/data/news_article/New(var/load_from_file = 0)
	..()
	if(server_file_path && load_from_file)
		stored_data = file2text("news_articles/[server_file_path]")
	calculate_size()


// NEWS DEFINITIONS BELOW THIS LINE

/datum/computer_file/data/news_article/space/vol_one
	filename = "SPACE Magazine vol. 1"
	server_file_path = "space_magazine_1.html"