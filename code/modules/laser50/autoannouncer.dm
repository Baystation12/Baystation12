var/list/announcemessages = list(
	"Our forums are located at: http://www.apollo-gaming.net , feel free to register!",
	"Please follow our rules, you can get to them by pressing the 'rules' button on the upper right!",
	"Please follow our rules, Link; http://www.apollo-gaming.net/index.php?topic=1137.0",
	"Have fun, and enjoy your stay!",
	"Have any game-related questions? Feel free to use adminhelp!",
	"End-Round Griefing is disallowed on this server, please remember this!",
	"We'd like to thank all of our Donators for keeping the server and its community alive!",
//	"We are holding a poll for server expansion, want to vote? Go here: http://www.apollo-gaming.org/index.php?topic=238.0",
	"Feel free to join our steam group: http://steamcommunity.com/groups/ApolloGamingSS13",
	"We're still looking for donators to help us on our quest for expansion and server improvements.<br> Interested? Check out our donator system here: http://www.apollo-gaming.net/index.php?action=treasury",
	"Need help or wish to report a player? Please use adminhelp (Or hit F1)",
	"Remember that this is a Med-Heavy Role-Play Server, act accordingly!",
	"",
	"",
	""
	)

/world/proc/Announce()
	while(1)
		var/message = pick(announcemessages)
		if(!message)
			continue //The empty messages are there to keep time time inbetween larger.
//		world << "<font size='2'><b>Auto-Announcer: </h3></font><i><font color='green'>[message]</font></i></b>"
		for(var/client/C in clients)
			C << "<font color='green'><font size='2'><b>" + create_text_tag("news", "NEWS:", C) + " Auto-Announcer: </b><span class='message'>[message]</span></font>"
		sleep(1800+rand(600, 1800))