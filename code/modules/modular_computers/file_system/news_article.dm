// /data/ files store data in string format.
// They don't contain other logic for now.
/datum/computer_file/data/news_article
	filetype = "XNML"
	filename = "Unknown News Entry"
	block_size = 5000 		// Results in smaller files
	do_not_edit = 1			// Editing the file breaks most formatting due to some HTML tags not being accepted as input from average user.
	var/server_file_path 	// File path to HTML file that will be loaded on server start. Example: '/news_articles/space_magazine_1.html'. Use the /news_articles/ folder!
	var/archived			// Set to 1 for older stuff
	var/cover				//filename of cover.

/datum/computer_file/data/news_article/New(var/load_from_file = 0)
	..()
	if(server_file_path && load_from_file)
		stored_data = file2text(server_file_path)
	calculate_size()


// NEWS DEFINITIONS BELOW THIS LINE

/datum/computer_file/data/news_article/space/vol_one
	filename = "SPACE Magazine vol. 1"
	server_file_path = 'news_articles/space_magazine_1.html'
	cover = "issue1.png"
	archived = 1

/datum/computer_file/data/news_article/space/vol_two
	filename = "SPACE Magazine vol. 2"
	server_file_path = 'news_articles/space_magazine_2.html'
	cover = "issue2.png"
	archived = 1

/datum/computer_file/data/news_article/space/vol_three
	filename = "SPACE Magazine vol. 3"
	server_file_path = 'news_articles/space_magazine_3.html'
	cover = "issue3.png"
	archived = 1

/datum/computer_file/data/news_article/space/vol_four
	filename = "SPACE Magazine vol. 4"
	server_file_path = 'news_articles/space_magazine_4.html'
	cover = "issue4.png"
	archived = 1

/datum/computer_file/data/news_article/space/vol_five
	filename = "SPACE Magazine vol. 5"
	server_file_path = 'news_articles/space_magazine_5.html'
	cover = "issue5.png"
	archived = 0

/datum/computer_file/data/news_article/space/vol_six
	filename = "SPACE Magazine vol. 6"
	server_file_path = 'news_articles/space_magazine_6.html'
	cover = "issue6.png"
	archived = 0