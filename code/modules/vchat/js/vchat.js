//The 'V' is for 'VORE' but you can pretend it's for Vue.js if you really want.

(function(){
    var oldLog = console.log;
    console.log = function (message) {
        send_debug(message);
        oldLog.apply(console, arguments);
    };
    var oldError = console.error;
    console.error = function (message) {
        send_debug(message);
        oldError.apply(console, arguments);
    }
    window.onerror = function (message, url, line, col, error) {
	var stacktrace = "";
	if(error && error.stack) {
		stacktrace = error.stack;
	}
        send_debug(message+" ("+url+"@"+line+":"+col+") "+error+"|UA: "+navigator.userAgent+"|Stack: "+stacktrace);
	return true;
    }
})();


//Options for vchat
var vchat_opts = {
	msBeforeDropped: 30000, //No ping for this long, and the server must be gone
	cookiePrefix: "vst-", //If you're another server, you can change this if you want.
	alwaysShow: ["vc_looc", "vc_system"], //Categories to always display on every tab
	vchatTabsVer: 1.0 //Version of vchat tabs save 'file'
};

var DARKMODE_COLORS = {
	buttonBgColor: "#40628a",
	buttonTextColor: "#FFFFFF",
	windowBgColor: "#272727",
	highlightColor: "#009900",
	tabTextColor: "#FFFFFF",
	tabBackgroundColor: "#272727"
};

var LIGHTMODE_COLORS = {
	buttonBgColor: "none",
	buttonTextColor: "#000000",
	windowBgColor: "none",
	highlightColor: "#007700",
	tabTextColor: "#000000",
	tabBackgroundColor: "none"
};


/***********
*
* Setup Methods
*
************/

var set_storage = set_cookie;
var get_storage = get_cookie;
var domparser = new DOMParser();

//Upgrade to LS
if (storageAvailable('localStorage')) {
	set_storage = set_localstorage;
	get_storage = get_localstorage;
}

//State-tracking variables
var vchat_state = {
	ready: false,

	//Userinfo as reported by byond
	byond_ip: null,
	byond_cid: null,
	byond_ckey: null,

	//Ping status
	lastPingReceived: 0,
	latency_sent: 0,

	//Last ID
	lastId: 0
}

function start_vchat() {
	//Instantiate Vue.js
	start_vue();

	//Inform byond we're done
	vchat_state.ready = true;
	push_Topic('done_loading');
	push_Topic_showingnum(this.showingnum);

	//I'll do my own winsets
	doWinset("htmloutput", {"is-visible": true});
	doWinset("oldoutput", {"is-visible": false});
	doWinset("chatloadlabel", {"is-visible": false});
	
	//Commence the pingening
	setInterval(check_ping, vchat_opts.msBeforeDropped);

	//For fun
	send_debug("VChat Loaded!");
	//throw new Error("VChat Loaded!");

}

//Loads vue for chat usage
var vueapp;
function start_vue() {
	vueapp = new Vue({
		el: '#app',
		data: {
			messages: [], //List o messages from byond
			shown_messages: [], //Used on filtered tabs, but not "Main" because it has 0len categories list, which bypasses filtering for speed
			unshown_messages: 0, //How many messages in archive would be shown but aren't
			archived_messages: [], //Too old to show
			tabs: [ //Our tabs
				{name: "Main", categories: [], immutable: true, active: true}
			],
			unread_messages: {}, //Message categories that haven't been looked at since we got one of them
			editing: false, //If we're in settings edit mode
			paused: false, //Autoscrolling
			latency: 0, //Not necessarily network latency, since the game server has to align the responses into ticks
			reconnecting: false, //If we've lost our connection
			ext_styles: "", //Styles for chat downloaded files
			is_admin: false,

			//Settings
			inverted: false, //Dark mode
			crushing: 3, //Combine similar messages
			animated: false, //Small CSS animations for new messages
			fontsize: 0.9, //Font size nudging
			lineheight: 130,
			showingnum: 200, //How many messages to show

			//The table to map game css classes to our vchat categories
			type_table: [
				{
					matches: ".filter_say, .say, .emote",
					becomes: "vc_localchat",
					pretty: "Local Chat",
					tooltip: "In-character local messages (say, emote, etc)",
					required: false,
					admin: false
				},
				{
					matches: ".filter_radio, .alert, .syndradio, .centradio, .airadio, .entradio, .comradio, .secradio, .engradio, .medradio, .sciradio, .supradio, .srvradio, .expradio, .radio, .deptradio, .newscaster",
					becomes: "vc_radio",
					pretty: "Radio Comms",
					tooltip: "All departments of radio messages",
					required: false,
					admin: false
				},
				{
					matches: ".filter_notice, .notice:not(.pm), .adminnotice, .info, .sinister, .cult",
					becomes: "vc_info",
					pretty: "Notices",
					tooltip: "Non-urgent messages from the game and items",
					required: false,
					admin: false
				},
				{
					matches: ".filter_warning, .warning:not(.pm), .critical, .userdanger, .italics",
					becomes: "vc_warnings",
					pretty: "Warnings",
					tooltip: "Urgent messages from the game and items",
					required: false,
					admin: false
				},
				{
					matches: ".filter_deadsay, .deadsay",
					becomes: "vc_deadchat",
					pretty: "Deadchat",
					tooltip: "All of deadchat",
					required: false,
					admin: false
				},
				{
					matches: ".filter_ooc, .ooc:not(.looc)",
					becomes: "vc_globalooc",
					pretty: "Global OOC",
					tooltip: "The bluewall of global OOC messages",
					required: false,
					admin: false
				},
				//VOREStation Add Start
				{
					matches: ".nif",
					becomes: "vc_nif",
					pretty: "NIF Messages",
					tooltip: "Messages from the NIF itself and people inside",
					required: false,
					admin: false
				},
				//VOREStation Add End
				{
					matches: ".filter_pm, .pm",
					becomes: "vc_adminpm",
					pretty: "Admin PMs",
					tooltip: "Messages to/from admins ('adminhelps')",
					required: false,
					admin: false
				},
				{
					matches: ".filter_ASAY, .admin_channel",
					becomes: "vc_adminchat",
					pretty: "Admin Chat",
					tooltip: "ASAY messages",
					required: false,
					admin: true
				},
				{
					matches: ".filter_MSAY, .mod_channel",
					becomes: "vc_modchat",
					pretty: "Mod Chat",
					tooltip: "MSAY messages",
					required: false,
					admin: true
				},
				{
					matches: ".filter_ESAY, .event_channel",
					becomes: "vc_eventchat",
					pretty: "Event Chat",
					tooltip: "ESAY messages",
					required: false,
					admin: true
				},
				{
					matches: ".filter_combat, .danger",
					becomes: "vc_combat",
					pretty: "Combat Logs",
					tooltip: "Urist McTraitor has stabbed you with a knife!",
					required: false,
					admin: false
				},
				{
					matches: ".filter_adminlogs, .log_message",
					becomes: "vc_adminlogs",
					pretty: "Admin Logs",
					tooltip: "ADMIN LOG: Urist McAdmin has jumped to coordinates X, Y, Z",
					required: false,
					admin: true
				},
				{
					matches: ".filter_attacklogs",
					becomes: "vc_attacklogs",
					pretty: "Attack Logs",
					tooltip: "Urist McTraitor has shot John Doe",
					required: false,
					admin: true
				},
				{
					matches: ".filter_debuglogs",
					becomes: "vc_debuglogs",
					pretty: "Debug Logs",
					tooltip: "DEBUG: SSPlanets subsystem Recover().",
					required: false,
					admin: true
				},
				{
					matches: ".ooc.looc, .ooc, .looc", //Dumb game
					becomes: "vc_looc",
					pretty: "Local OOC",
					tooltip: "Local OOC messages, always enabled",
					required: true
				},
				{
					matches: ".boldannounce, .filter_system",
					becomes: "vc_system",
					pretty: "System Messages",
					tooltip: "Messages from your client, always enabled",
					required: true
				}
			],
		},
		mounted: function() {
			//Load our settings
			this.load_settings();

			var xhr = new XMLHttpRequest();
			xhr.open('GET', 'ss13styles.css');
			xhr.onreadystatechange = (function() {
				this.ext_styles = xhr.responseText;
			}).bind(this);
			xhr.send();
		},
		updated: function() {
			if(!this.editing && !this.paused) {
				window.scrollTo(0,document.getElementById("messagebox").scrollHeight);
			}
		},
		watch: {
			reconnecting: function(newSetting, oldSetting) {
				if(newSetting == true && oldSetting == false) {
					this.internal_message("Your client has lost connection to the server, or there is severe lag. Your client will reconnect if possible.");
				} else if (newSetting == false && oldSetting == true) {
					this.internal_message("Your client has reconnected to the server.");
				}
			},
			//Save the inverted setting to LS
			inverted: function (newSetting) {
				set_storage("darkmode",newSetting);
				if(newSetting) { //Special treatment for <body> which is outside Vue's scope and has custom css
					document.body.classList.add("inverted");
					switch_ui_mode(DARKMODE_COLORS);
				} else {
					document.body.classList.remove("inverted");
					switch_ui_mode(LIGHTMODE_COLORS);
				}
			}, 
			crushing: function (newSetting) {
				set_storage("crushing",newSetting);
			},
			animated: function (newSetting) {
				set_storage("animated",newSetting);
			},
			fontsize: function (newSetting, oldSetting) {
				if(isNaN(newSetting)) { //Numbers only
					this.fontsize = oldSetting;
					return;
				}
				if(newSetting < 0.2) {
					this.fontsize = 0.2;
				} else if(newSetting > 5) {
					this.fontsize = 5;
				}
				set_storage("fontsize",newSetting);
			},
			lineheight: function (newSetting, oldSetting) {
				if(!isFinite(newSetting)) { //Integers only
					this.lineheight = oldSetting;
					return;
				}
				if(newSetting < 100) {
					this.lineheight = 100;
				} else if(newSetting > 200) {
					this.lineheight = 200;
				}
				set_storage("lineheight",newSetting);
			},
			showingnum: function (newSetting, oldSetting) {
				if(!isFinite(newSetting)) { //Integers only
					this.showingnum = oldSetting;
					return;
				}
				
				newSetting = Math.floor(newSetting);
				if(newSetting < 50) {
					this.showingnum = 50;
				} else if(newSetting > 2000) {
					this.showingnum = 2000;
				}

				set_storage("showingnum",this.showingnum);
				push_Topic_showingnum(this.showingnum); // Send the buffer length back to byond so we have it in case of reconnect
				this.attempt_archive();
			},
			current_categories: function(newSetting, oldSetting) {
				if(newSetting.length) {
					this.apply_filter(newSetting);
				}
			}
		},
		computed: {
			//Which tab is active?
			active_tab: function() {
				//Had to polyfill this stupid .find since IE doesn't have EC6
				let tab = this.tabs.find( function(tab) {
					return tab.active;
				});
				return tab;
			},
			//What color does the latency pip get?
			ping_classes: function() {
				if(!this.latency) {
					return this.reconnecting ? "red" : "green"; //Standard
				} 

				if (this.latency == "?") { return "grey"; } //Waiting for latency test reply
				else if(this.latency < 0 ) {return "red"; }
				else if(this.latency <= 200) { return "green"; }
				else if(this.latency <= 400) { return "yellow"; }
				else { return "grey"; }
			},
			current_categories: function() {
				if(this.active_tab == this.tabs[0]) {
					return []; //Everything, no filtering, special case for speed.
				} else {
					return this.active_tab.categories.concat(vchat_opts.alwaysShow);
				}
			}
		},
		methods: {
			//Load the chat settings
			load_settings: function() {
				this.inverted = get_storage("darkmode", false);
				this.crushing = get_storage("crushing", 3);
				this.animated = get_storage("animated", false);
				this.fontsize = get_storage("fontsize", 0.9);
				this.lineheight = get_storage("lineheight", 130);
				this.showingnum = get_storage("showingnum", 200);

				if(isNaN(this.crushing)){this.crushing = 3;} //This used to be a bool (03-02-2020)
				if(isNaN(this.fontsize)){this.fontsize = 0.9;} //This used to be a string (03-02-2020)

				this.load_tabs();
			},
			load_tabs: function() {
				var loadstring = get_storage("tabs")
				if(!loadstring)
					return;
				var loadfile = JSON.parse(loadstring);
				//Malformed somehow.
				if(!loadfile.version || !loadfile.tabs) {
					this.internal_message("There was a problem loading your tabs. Any new ones you make will be saved, however.");
					return;
				}
				//Version is old? Sorry.
				if(!loadfile.version == vchat_opts.vchatTabsVer) {
					this.internal_message("Your saved tabs are for an older version of VChat and must be recreated, sorry.");
					return;
				}

				this.tabs.push.apply(this.tabs, loadfile.tabs);
			},
			save_tabs: function() {
				var savefile = {
					version: vchat_opts.vchatTabsVer,
					tabs: []
				}

				//The tabs contain a bunch of vue stuff that gets funky when you try to serialize it with stringify, so we 'purify' it
				this.tabs.forEach(function(tab){
					if(tab.immutable)
						return;
					
					var name = tab.name;
					
					var categories = [];
					tab.categories.forEach(function(category){categories.push(category);});

					var cleantab = {name: name, categories: categories, immutable: false, active: false}

					savefile.tabs.push(cleantab);
				});

				var savestring = JSON.stringify(savefile);
				set_storage("tabs", savestring);
			},
			//Change to another tab
			switchtab: function(tab) {
				if(tab == this.active_tab) return;
				this.active_tab.active = false;
				tab.active = true;

				tab.categories.forEach( function(cls) {
					this.unread_messages[cls] = 0;
				}, this);

				this.apply_filter(this.current_categories);
			},
			//Toggle edit mode
			editmode: function() {
				this.editing = !this.editing;
				this.save_tabs();
			},
			//Toggle autoscroll
			pause: function() {
				this.paused = !this.paused;
			},
			//Create a new tab (stupid lack of classes in ES5...)
			newtab: function() {
				this.tabs.push({
					name: "New Tab",
					categories: [],
					immutable: false,
					active: false
				});
				this.switchtab(this.tabs[this.tabs.length - 1]);
			},
			//Rename an existing tab
			renametab: function() {
				if(this.active_tab.immutable) {
					return;
				}
				var tabtorename = this.active_tab;
				var newname = window.prompt("Type the desired tab name:", tabtorename.name);
				if(newname === null || newname === "" || tabtorename === null) {
					return;
				}
				tabtorename.name = newname;
			},
			//Delete the currently active tab
			deltab: function(tab) {
				if(!tab) {
					tab = this.active_tab;
				}
				if(tab.immutable) {
					return;
				}
				this.switchtab(this.tabs[0]);
				this.tabs.splice(this.tabs.indexOf(tab), 1);
			},
			movetab: function(tab, shift) {
				if(!tab || tab.immutable) {
					return;
				}
				var at = this.tabs.indexOf(tab);
				var to = at + shift;
				this.tabs.splice(to, 0, this.tabs.splice(at, 1)[0]);
			},
			tab_unread_count: function(tab) {
				var unreads = 0;
				var thisum = this.unread_messages;
				tab.categories.find( function(cls){
					if(thisum[cls]) {
						unreads += thisum[cls];
					}
				});
				return unreads;
			},
			tab_unread_categories: function(tab) {
				var unreads = false;
				var thisum = this.unread_messages;
				tab.categories.find( function(cls){
					if(thisum[cls]) {
						unreads = true;
						return true;
					}
				});

				return { red: unreads, grey: !unreads};
			},
			attempt_archive: function() {
				var wiggle = 20; //Wiggle room to prevent hysterisis effects. Slice off 20 at a time.
				//Pushing out old messages
				if(this.messages.length > this.showingnum) {//Time to slice off old messages
					var too_old = this.messages.splice(0,wiggle); //We do a few at a time to avoid doing it too often
					Array.prototype.push.apply(this.archived_messages, too_old); //ES6 adds spread operator. I'd use it if I could.
				}/*
				//Pulling back old messages
				} else if(this.messages.length < (this.showingnum - wiggle)) { //Sigh, repopulate old messages
					var too_new = this.archived_messages.splice(this.messages.length - (this.showingnum - wiggle));
					Array.prototype.shift.apply(this.messages, too_new);
				}
				*/
			},
			apply_filter: function(cat_array) {
				//Clean up the array
				this.shown_messages.splice(0);
				this.unshown_messages = 0;

				//For each message, try to find it's category in the categories we're showing
				this.messages.forEach( function(msg){
					if(cat_array.indexOf(msg.category) > -1) { //Returns the position in the array, and -1 for not found
						this.shown_messages.push(msg);
					}
				}, this);

				//For each message, try to find it's category in the categories we're showing
				this.archived_messages.forEach( function(msg){
					if(cat_array.indexOf(msg.category) > -1) { //Returns the position in the array, and -1 for not found
						this.unshown_messages++;
					}
				}, this);
			},
			//Push a new message into our array
			add_message: function(message) {
				//IE doesn't support the 'class' syntactic sugar so we're left making our own object.
				let newmessage = {
					time: message.time,
					category: "error",
					content: message.message,
					repeats: 1
				};

				//Get a category
				newmessage.category = this.get_category(newmessage.content);

				//Try to crush it with one of the last few
				if(this.crushing) {
					let crushwith = this.messages.slice(-(this.crushing));
					for (let i = crushwith.length - 1; i >= 0; i--) {
						let oldmessage = crushwith[i];
						if(oldmessage.content == newmessage.content) {
							newmessage.repeats += oldmessage.repeats;
							this.messages.splice(this.messages.indexOf(oldmessage), 1);
						}
					}
				}

				newmessage.content = newmessage.content.replace(
					/(\b(https?):\/\/[\-A-Z0-9+&@#\/%?=~_|!:,.;]*[\-A-Z0-9+&@#\/%=~_|])/img, //Honestly good luck with this regex ~Gear
					'<a href="$1">$1</a>');

				//Unread indicator and insertion into current tab shown messages if sensible
				if(this.current_categories.length && (this.current_categories.indexOf(newmessage.category) < 0)) { //Not in the current categories
					if (isNaN(this.unread_messages[newmessage.category])) {
						this.unread_messages[newmessage.category] = 0;
					}
					this.unread_messages[newmessage.category] += 1;
				} else if(this.current_categories.length) { //Is in the current categories
					this.shown_messages.push(newmessage);
				}

				//Append to vue's messages
				newmessage.id = ++vchat_state.lastId;
				this.attempt_archive();
				this.messages.push(newmessage);
			},
			//Push an internally generated message into our array
			internal_message: function(message) {
				let newmessage = {
					time: this.messages.length ? this.messages.slice(-1).time+1 : 0,
					category: "vc_system",
					content: "<span class='notice'>[VChat Internal] " + message + "</span>"
				};
				newmessage.id = ++vchat_state.lastId;
				this.messages.push(newmessage);
			},
			on_mouseup: function(event) {
				// Focus map window on mouseup so hotkeys work.  Exception for if they highlighted text or clicked an input.
				let ele = event.target;
				let textSelected = ('getSelection' in window) && window.getSelection().isCollapsed === false;
				if (!textSelected && !(ele && (ele.tagName === 'INPUT' || ele.tagName === 'TEXTAREA'))) {
					focusMapWindow();
					// Okay focusing map window appears to prevent click event from being fired.  So lets do it ourselves.
					event.preventDefault();
					event.target.click();
				}
			},
			click_message: function(event) {
				let ele = event.target;
				if(ele.tagName === "A") {
					event.stopPropagation();
					event.preventDefault ? event.preventDefault() : (event.returnValue = false); //The second one is the weird IE method.

					var href = ele.getAttribute('href'); // Gets actual href without transformation into fully qualified URL
					
					if (href[0] == '?' || (href.length >= 8 && href.substring(0,8) == "byond://")) {
						window.location = href; //Internal byond link
					} else { //It's an external link
						window.location = "byond://?action=openLink&link="+encodeURIComponent(href);
					}
				}
			},
			//Derive a vchat category based on css classes
			get_category: function(message) {
				if(!vchat_state.ready) {
					push_Topic('not_ready');
					return;
				}

				let doc = domparser.parseFromString(message, 'text/html');
				let evaluating = doc.querySelector('span');

				let category = "nomatch"; //What we use if the classes aren't anything we know.
				if(!evaluating) return category;
				this.type_table.find( function(type) {
					if(evaluating.msMatchesSelector(type.matches)) {
						category = type.becomes;
						return true;
					}
				});

				return category;
			},
			save_chatlog: function() {
				var textToSave = "<html><head><style>"+this.ext_styles+"</style></head><body>";
				
				var messagesToSave = this.archived_messages.concat(this.messages);

				messagesToSave.forEach( function(message) {
					textToSave += message.content;
					if(message.repeats > 1) {
						textToSave += "(x"+message.repeats+")";
					}
					textToSave += "<br>\n";
				});
				textToSave += "</body></html>";

				var fileprefix = "log";
				var extension =".html";

				var now = new Date();
				var hours = String(now.getHours());
				if(hours.length < 2) {
					hours = "0" + hours;
				}
				var minutes = String(now.getMinutes());
				if(minutes.length < 2) {
					minutes = "0" + minutes;
				}
				var dayofmonth = String(now.getDate());
				if(dayofmonth.length < 2) {
					dayofmonth = "0" + dayofmonth;
				}
				var month = String(now.getMonth()+1); //0-11
				if(month.length < 2) {
					month = "0" + month;
				}
				var year = String(now.getFullYear());
				var datesegment = " "+year+"-"+month+"-"+dayofmonth+" ("+hours+" "+minutes+")";

				var filename = fileprefix+datesegment+extension;

				//Unlikely to work unfortunately, not supported in any version of IE, only Edge
				var hiddenElement = document.createElement('a');
				if (hiddenElement.download !== undefined) {
					hiddenElement.href = 'data:attachment/text,' + encodeURI(textToSave); //Has a problem in byond 512 due to weird unicode handling
					hiddenElement.target = '_blank';
					hiddenElement.download = filename;
					hiddenElement.click();
				//Probably what will end up getting used
				} else {
					var blob = new Blob([textToSave], {type: 'text/html;charset=utf8;'});
					saved = window.navigator.msSaveOrOpenBlob(blob, filename);
				}
			},
			do_latency_test: function() {
				send_latency_check();
			},
			blur_this: function(event) {
				event.target.blur();
			}
		}
	});
}

/***********
*
* Actual Methods
*
************/
function check_ping() {
	var time_ago = Date.now() - vchat_state.lastPingReceived;
	if(time_ago > vchat_opts.msBeforeDropped)
		vueapp.reconnecting = true;
}

//Send a 'ping' to byond
function send_latency_check() {
	if(vchat_state.latency_sent)
			return;
	
	vchat_state.latency_sent = Date.now();
	vueapp.latency = "?";
	push_Topic("ping");
	setTimeout(function() {
		if(vchat_state.latency_ms == "?") {
			vchat_state.latency_ms = 999;
		}
	}, 1000); // 1 second to reply otherwise we mark it as bad
	setTimeout(function() {
		vchat_state.latency_sent = 0;
		vueapp.latency = 0;
	}, 5000); //5 seconds to display ping time overall
}

function get_latency_check() {
	if(!vchat_state.latency_sent) {
		return; //Too late
	}

	vueapp.latency = Date.now() - vchat_state.latency_sent;
}

//We accept double-url-encoded JSON strings because Byond is garbage and UTF-8 encoded url_encode() text has crazy garbage in it.
function byondDecode(message) {
	
	//Byond encodes spaces as pluses?! This is 1998 I guess.
	message = message.replace(/\+/g, "%20");
	try { 
		message = decodeURIComponent(message);
	} catch (err) {
		message = unescape(message);
	}
	return JSON.parse(message);
}

//This is the function byond actually communicates with using byond's client << output() method.
function putmessage(messages) {
	messages = byondDecode(messages);
	if (Array.isArray(messages)) {
		messages.forEach(function(message) {
			vueapp.add_message(message);
		});
	} else if (typeof messages === 'object') {
		vueapp.add_message(messages);
	}
}

//Send an internal message generated in the javascript
function system_message(message) {
	vueapp.internal_message(message);
}

//This is the other direction of communication, to push a Topic message back
function push_Topic(topic_uri) {
	window.location = '?_src_=chat&proc=' + topic_uri; //Yes that's really how it works.
}

// Send the showingnum back to byond
function push_Topic_showingnum(topic_num) {
	window.location = '?_src_=chat&showingnum=' + topic_num;
}

//Tells byond client to focus the main map window.
function focusMapWindow() {
	window.location = 'byond://winset?mapwindow.map.focus=true';
}

//Debug event
function send_debug(message) {
	push_Topic("debug&param[message]="+encodeURIComponent(message));
}

//A side-channel to send events over that aren't just chat messages, if necessary.
function get_event(event) {
	if(!vchat_state.ready) {
		push_Topic("not_ready");
		return;
	}

	var parsed_event = {evttype: 'internal_error', event: event};
	parsed_event = byondDecode(event);

	switch(parsed_event.evttype) {
		//We didn't parse it very well
		case 'internal_error':
			system_message("Event parse error: " + event);
			break;
		
		//They provided byond data.
		case 'byond_player':
			send_client_data();
			vueapp.is_admin = (parsed_event.admin === 'true');
			vchat_state.byond_ip = parsed_event.address;
			vchat_state.byond_cid = parsed_event.cid;
			vchat_state.byond_ckey = parsed_event.ckey;
			set_storage("ip",vchat_state.byond_ip);
			set_storage("cid",vchat_state.byond_cid);
			set_storage("ckey",vchat_state.byond_ckey);
			break;

		//Just a ping.
		case 'keepalive':
			vchat_state.lastPingReceived = Date.now();
			vueapp.reconnecting = false;
			break;

		//Response to a latency test.
		case 'pong':
			get_latency_check();
			break;

		//The server doesn't know if we're loaded or not (we bail above if we're not, so we must be).
		case 'availability':
			push_Topic("done_loading");
			break;
	
		default: 
			system_message("Didn't know what to do with event: " + event);
	}
}

//Send information retrieved from storage
function send_client_data() {
	let client_data = {
		ip: get_storage("ip"),
		cid: get_storage("cid"),
		ckey: get_storage("ckey")
	};
	push_Topic("ident&param[clientdata]="+JSON.stringify(client_data));
}

//Newer localstorage methods
function set_localstorage(key, value) {
	let localstorage = window.localStorage;
	localstorage.setItem(vchat_opts.cookiePrefix+key,value);
}

function get_localstorage(key, deffo) {
	let localstorage = window.localStorage;
	let value = localstorage.getItem(vchat_opts.cookiePrefix+key);
	
	//localstorage only stores strings.
	if(value === "null" || value === null) {
		value = deffo;
	//Coerce bools back into their native forms
	} else if(value === "true") {
		value = true;
	} else if(value === "false") {
		value = false;
	//Coerce numbers back into numerical form
	} else if(!isNaN(value)) {
		value = +value;
	}
	return value;
}

//Older cookie methods
function set_cookie(key, value) {
	let now = new Date();
	now.setFullYear(now.getFullYear() + 1);
	let then = now.toUTCString();
	document.cookie = vchat_opts.cookiePrefix+key+"="+value+";expires="+then+";path=/";
}

function get_cookie(key, deffo) {
	var candidates = {cookie: null, localstorage: null, indexeddb: null};
	let cookie_array = document.cookie.split(';');
	let cookie_object = {};
	cookie_array.forEach( function(element) {
		let clean = element.replace(vchat_opts.cookiePrefix,"").trim(); //Strip the prefix, trim whitespace
		let equals = clean.search("="); //Find the equals
		let left = decodeURIComponent(clean.substring(0,equals)); //From start to one char before equals
		let right = decodeURIComponent(clean.substring(equals+1)); //From one char after equals to end
		//cookies only stores strings.
		if(right == "null" || right === null) {
			right = deffo;
		} else if(right === "true") {
			right = true;
		} else if(right === "false") {
			right = false;
		} else if(!isNaN(right)) {
			right = +right;
		}
		cookie_object[left] = right; //Stick into object
	});
	candidates.cookie = cookie_object[key]; //Return value of that key in our object (or undefined)
}

// Button Controls that need background-color and text-color set.
var SKIN_BUTTONS = [
	/* Rpane */ "rpane.textb", "rpane.infob", "rpane.wikib", "rpane.forumb", "rpane.rulesb", "rpane.github", "rpane.mapb", "rpane.changelog",
	/* Mainwindow */ "mainwindow.saybutton", "mainwindow.mebutton", "mainwindow.hotkey_toggle"
	
];
// Windows or controls that need background-color set.
var SKIN_ELEMENTS = [
	/* Mainwindow */ "mainwindow", "mainwindow.mainvsplit", "mainwindow.tooltip",
	/* Rpane */ "rpane", "rpane.rpanewindow", "rpane.mediapanel",
];

function switch_ui_mode(options) {
	doWinset(SKIN_BUTTONS.reduce(function(params, ctl) {params[ctl + ".background-color"] = options.buttonBgColor; return params;}, {}));
	doWinset(SKIN_BUTTONS.reduce(function(params, ctl) {params[ctl + ".text-color"] = options.buttonTextColor; return params;}, {}));
	doWinset(SKIN_ELEMENTS.reduce(function(params, ctl) {params[ctl + ".background-color"] = options.windowBgColor; return params;}, {}));
	doWinset("infowindow", {
		"background-color": options.tabBackgroundColor,
		"text-color": options.tabTextColor
	});
	doWinset("infowindow.info", {
		"background-color": options.tabBackgroundColor,
		"text-color": options.tabTextColor,
		"highlight-color": options.highlightColor,
		"tab-text-color": options.tabTextColor,
		"tab-background-color": options.tabBackgroundColor
	});
}

function doWinset(control_id, params) {
	if (typeof params === 'undefined') {
		params = control_id;  // Handle single-argument use case.
		control_id = null;
	}
	var url = "byond://winset?";
	if (control_id) {
		url += ("id=" + control_id + "&");
	}
	url += Object.keys(params).map(function(ctl) {
		return ctl + "=" + encodeURIComponent(params[ctl]);
	}).join("&");
	window.location = url;
}
