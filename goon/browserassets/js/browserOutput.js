/*****************************************
*
* FUNCTION AND VAR DECLARATIONS
*
******************************************/

//DEBUG STUFF
var escaper = encodeURIComponent || escape;
var decoder = decodeURIComponent || unescape;
window.onerror = function(msg, url, line, col, error) {
	if (document.location.href.indexOf("proc=debug") <= 0) {
		var extra = !col ? '' : ' | column: ' + col;
		extra += !error ? '' : ' | error: ' + error;
		extra += !navigator.userAgent ? '' : ' | user agent: ' + navigator.userAgent;
		var debugLine = 'Error: ' + msg + ' | url: ' + url + ' | line: ' + line + extra;
		window.location = '?_src_=chat&proc=debug&param[error]='+escaper(debugLine);
	}
	return true;
};

//Globals
window.status = 'Output';
var $messages, $subOptions, $last_message;
var opts = {
	//General
	'messageCount': 0, //A count...of messages...
	'messageLimit': 2053, //A limit...for the messages...
	'scrollSnapTolerance': 5, //If within x pixels of bottom
	'clickTolerance': 10, //Keep focus if outside x pixels of mousedown position on mouseup
	'popups': 0, //Amount of popups opened ever
	'wasd': false, //Is the user in wasd mode?
	'chatMode': 'default', //The mode the chat is in
	'priorChatHeight': 0, //Thing for height-resizing detection
	'restarting': false, //Is the round restarting?

	//Options menu
	'subOptionsLoop': null, //Contains the interval loop for closing the options menu
	'suppressOptionsClose': false, //Whether or not we should be hiding the suboptions menu
	'highlightTerms': [],
	'highlightLimit': 5,
	'highlightColor': '#FFFF00', //The color of the highlighted message
	'pingDisabled': false, //Has the user disabled the ping counter

	//Ping display
	'lastPang': 0, //Timestamp of the last response from the server.
	'pangLimit': 35000,
	'pingTime': 0, //Timestamp of when ping sent
	'pongTime': 0, //Timestamp of when ping received
	'noResponse': false, //Tracks the state of the previous ping request
	'noResponseCount': 0, //How many failed pings?

	//Clicks
	'mouseDownX': null,
	'mouseDownY': null,
	'preventFocus': false, //Prevents switching focus to the game window

	//Client Connection Data
	'clientDataLimit': 5,
	'clientData': [],

	// List of macros in the 'hotkeymode' macro set.
	'macros': {},

	// index in the color presets list.
	'colorPreset': 0,

	// Whether to combine consecutive repeated messages into one, showing a counter
	'messageCombining': true
};

// Array of names for colorblind presets.
// If not set to normal, a CSS file `browserOutput_${name}.css` will be added to the head.
var colorPresets = [
	'normal',
	'dark',
	'colorblindv1'
]

function outerHTML(el) {
    var wrap = document.createElement('div');
    wrap.appendChild(el.cloneNode(true));
    return wrap.innerHTML;
}

//Polyfill for fucking date now because of course IE8 and below don't support it
if (!Date.now) {
	Date.now = function now() {
		return new Date().getTime();
	};
}
//Polyfill for trim() (IE8 and below)
if (typeof String.prototype.trim !== 'function') {
	String.prototype.trim = function () {
		return this.replace(/^\s+|\s+$/g, '');
	};
}

function updateColorPreset() {
	var el = $("#colorPresetLink")[0];
	el.href = "browserOutput_"+colorPresets[opts.colorPreset]+".css";
	runByond('?_src_=chat&proc=colorPresetPost&preset='+colorPresets[opts.colorPreset]);
}

//Shit fucking piece of crap that doesn't work god fuckin damn it
function linkify(text) {
	var rex = /((?:<a|<iframe|<img)(?:.*?(?:src="|href=").*?))?(?:(?:https?:\/\/)|(?:www\.))+(?:[^ ]*?\.[^ ]*?)+[-A-Za-z0-9+&@#\/%?=~_|$!:,.;]+/ig;
	return text.replace(rex, function ($0, $1) {
		if(/^https?:\/\/.+/i.test($0)) {
			return $1 ? $0: '<a href="'+$0+'">'+$0+'</a>';
		}
		else {
			return $1 ? $0: '<a href="http://'+$0+'">'+$0+'</a>';
		}
	});
}

//Actually turns the highlight term match into appropriate html
function addHighlightMarkup(match) {
	var extra = '';
	if (opts.highlightColor) {
		extra += ' style="background-color: '+opts.highlightColor+'"';
	}
	return '<span class="highlight"'+extra+'>'+match+'</span>';
}

//Highlights words based on user settings
function highlightTerms(el) {
	if (el.children.length > 0) {
		for(var h = 0; h < el.children.length; h++){
			highlightTerms(el.children[h]);
		}
	}

	var hasTextNode = false;
	for (var node = 0; node < el.childNodes.length; node++)
	{
		if (el.childNodes[node].nodeType === 3)
		{
			hasTextNode = true;
			break;
		}
	}

	if (hasTextNode) { //If element actually has text
		var newText = '';
		for (var c = 0; c < el.childNodes.length; c++) { //Each child element
			if (el.childNodes[c].nodeType === 3) { //Is it text only?
				var words = el.childNodes[c].data.split(' ');
				for (var w = 0; w < words.length; w++) { //Each word in the text
					var newWord = null;
					for (var i = 0; i < opts.highlightTerms.length; i++) { //Each highlight term
						if (opts.highlightTerms[i] && words[w].toLowerCase().indexOf(opts.highlightTerms[i].toLowerCase()) > -1) { //If a match is found
							newWord = words[w].replace("<", "&lt;").replace(new RegExp(opts.highlightTerms[i], 'gi'), addHighlightMarkup);
							break;
						}
						console.log(newWord)
					}
					newText += newWord || words[w].replace("<", "&lt;");
					newText += w >= words.length ? '' : ' ';
				}
			} else { //Every other type of element
				newText += outerHTML(el.childNodes[c]);
			}
		}
		el.innerHTML = newText;
	}
}
//Send a message to the client
function output(message, flag) {
	if (typeof message === 'undefined') {
		return;
	}
	if (typeof flag === 'undefined') {
		flag = '';
	}

	if (flag !== 'internal')
		opts.lastPang = Date.now();

	// Basically we url_encode twice server side so we can manually read the encoded version and actually do UTF-8.
	// The replace for + is because FOR SOME REASON, BYOND replaces spaces with a + instead of %20, and a plus with %2b.
	// Marvelous.
	message = message.replace(/\+/g, "%20")
	message = decoder(message)

	//Stuff we do along with appending a message
	var atBottom = false;
	var bodyHeight = $('body').height();
	var messagesHeight = $messages.outerHeight();
	var scrollPos = $('body,html').scrollTop();

	//Should we snap the output to the bottom?
	if (bodyHeight + scrollPos >= messagesHeight - opts.scrollSnapTolerance) {
		atBottom = true;
		if ($('#newMessages').length) {
			$('#newMessages').remove();
		}
	//If not, put the new messages box in
	} else {
		if ($('#newMessages').length) {
			var messages = $('#newMessages .number').text();
			messages = parseInt(messages);
			messages++;
			$('#newMessages .number').text(messages);
			if (messages == 2) {
				$('#newMessages .messageWord').append('s');
			}
		} else {
			$messages.after('<a href="#" id="newMessages"><span class="number">1</span> new <span class="messageWord">message</span> <i class="icon-double-angle-down"></i></a>');
		}
	}

	//Url stuff
	if (message.length && flag != 'preventLink') {
		message = linkify(message);
	}

	opts.messageCount++;

	//Pop the top message off if history limit reached
	if (opts.messageCount >= opts.messageLimit) {
		$messages.children('div.entry:first-child').remove();
		opts.messageCount--; //I guess the count should only ever equal the limit
	}

	var handled = false;
	var trimmed_message = message.trim();
	var lastmessages = $messages.children('div.entry:last-child');
	if(opts.messageCombining && lastmessages.length && $last_message)
	{
		if($last_message == trimmed_message)
		{
			if(lastmessages.children('span.repeat').length)
			{
				var current_value = parseInt(lastmessages.children('span.repeat').text());
				lastmessages.children('span.repeat').text(current_value + 1);
			}
			else
			{
				lastmessages.append($('<span/>', { 'class': 'repeat', 'text': 2}));
			}
			var insertedBadge = $(lastmessages).find('.repeat');
			insertedBadge.animate({
				"font-size": "0.9em"
			}, 100, function() {
				insertedBadge.animate({
					"font-size": "0.7em"
				}, 100);
			});
			opts.messageCount--;
			handled = true;
		}
	}

	if(!handled)
	{
		var entry = document.createElement('div');
		entry.className = 'entry';

		$last_message = trimmed_message;
		entry.innerHTML = trimmed_message;
		$messages[0].appendChild(entry);

		// Stuff we can do after the message shows can go here, in the interest of responsiveness
		if(opts.highlightTerms && opts.highlightTerms.length > 0) {
			highlightTerms(entry);
		}
	}

	//Actually do the snap
	if (atBottom) {
		$('body,html').scrollTop($messages.outerHeight());
	}
}

function internalOutput(message, flag)
{
	output(escaper(message), flag)
}

//Runs a route within byond, client or server side. Consider this "ehjax" for byond.
function runByond(uri) {
	window.location = uri;
}

function setCookie(cname, cvalue, exdays) {
	cvalue = escaper(cvalue);
	var d = new Date();
	d.setTime(d.getTime() + (exdays*24*60*60*1000));
	var expires = 'expires='+d.toUTCString();
	document.cookie = cname + '=' + cvalue + '; ' + expires + '; path=/';
}

function getCookie(cname) {
	var name = cname + '=';
	var ca = document.cookie.split(';');
	for(var i=0; i < ca.length; i++) {
	var c = ca[i];
	while (c.charAt(0)==' ') c = c.substring(1);
		if (c.indexOf(name) === 0) {
			return decoder(c.substring(name.length,c.length));
		}
	}
	return '';
}

function rgbToHex(R,G,B) {return toHex(R)+toHex(G)+toHex(B);}
function toHex(n) {
	n = parseInt(n,10);
	if (isNaN(n)) return "00";
	n = Math.max(0,Math.min(n,255));
	return "0123456789ABCDEF".charAt((n-n%16)/16) + "0123456789ABCDEF".charAt(n%16);
}

function changeMode(mode) {
	switch (mode) {
		case 'geocities':
			//switch in stylesheet
			opts.chatMode = mode;
			break;
		case 'console':

			opts.chatMode = mode;
			break;
		case 'default':
		default:
			//remove loaded stylesheet/s
			opts.chatMode = 'default';
	}
}

function handleClientData(ckey, ip, compid) {
	//byond sends player info to here
	var currentData = {'ckey': ckey, 'ip': ip, 'compid': compid};
	if (opts.clientData && !$.isEmptyObject(opts.clientData)) {
		runByond('?_src_=chat&proc=analyzeClientData&param[cookie]='+JSON.stringify({'connData': opts.clientData}));

		for (var i = 0; i < opts.clientData.length; i++) {
			var saved = opts.clientData[i];
			if (currentData.ckey == saved.ckey && currentData.ip == saved.ip && currentData.compid == saved.compid) {
				return; //Record already exists
			}
		}

		if (opts.clientData.length >= opts.clientDataLimit) {
			opts.clientData.shift();
		}
	} else {
		runByond('?_src_=chat&proc=analyzeClientData&param[cookie]=none');
	}

	//Update the cookie with current details
	opts.clientData.push(currentData);
	setCookie('connData', JSON.stringify(opts.clientData), 365);
}

//Server calls this on ehjax response
//Or, y'know, whenever really
function ehjaxCallback(data) {
	opts.lastPang = Date.now();
	if (data == 'softPang') {
		return;
	} else if (data == 'pang') {
		opts.pingCounter = 0; //reset
		opts.pingTime = Date.now();
		runByond('?_src_=chat&proc=ping');

	} else if (data == 'pong') {
		if (opts.pingDisabled) {return;}
		opts.pongTime = Date.now();
		var pingDuration = Math.ceil((opts.pongTime - opts.pingTime) / 2);
		$('#pingMs').text(pingDuration+'ms');
		pingDuration = Math.min(pingDuration, 255);
		var red = pingDuration;
		var green = 255 - pingDuration;
		var blue = 0;
		var hex = rgbToHex(red, green, blue);
		$('#pingDot').css('color', '#'+hex);

	} else if (data == 'roundrestart') {
		opts.restarting = true;
		internalOutput('<div class="connectionClosed internal restarting">The connection has been closed because the server is restarting. Please wait while you automatically reconnect.</div>', 'internal');
	} else if (data == 'stopaudio') {
		$('.dectalk').remove();
	} else {
		//Oh we're actually being sent data instead of an instruction
		var dataJ;
		try {
			dataJ = $.parseJSON(data);
		} catch (e) {
			//But...incorrect :sadtrombone:
			window.onerror('JSON: '+e+'. '+data, 'browserOutput.html', 327);
			return;
		}
		data = dataJ;

		if (data.clientData) {
			if (opts.restarting) {
				opts.restarting = false;
				$('.connectionClosed.restarting:not(.restored)').addClass('restored').text('The round restarted and you successfully reconnected!');
			}
			if (!data.clientData.ckey && !data.clientData.ip && !data.clientData.compid) {
				//TODO: Call shutdown perhaps
				return;
			} else {
				handleClientData(data.clientData.ckey, data.clientData.ip, data.clientData.compid);
			}
		} else if (data.modeChange) {
			changeMode(data.modeChange);
		} else if (data.firebug) {
			if (data.trigger) {
				internalOutput('<span class="internal boldnshit">Loading firebug console, triggered by '+data.trigger+'...</span>', 'internal');
			} else {
				internalOutput('<span class="internal boldnshit">Loading firebug console...</span>', 'internal');
			}
			var firebugEl = document.createElement('script');
			firebugEl.src = 'https://getfirebug.com/firebug-lite-debug.js';
			document.body.appendChild(firebugEl);
		} else if (data.dectalk) {
			var message = '<audio class="dectalk" src="'+data.dectalk+'" autoplay="autoplay"></audio>';
			if (data.decTalkTrigger) {
				message = '<a href="#" class="stopAudio icon-stack" title="Stop Audio" style="color: black;"><i class="icon-volume-off"></i><i class="icon-ban-circle" style="color: red;"></i></a> '+
				'<span class="italic">You hear a strange robotic voice...</span>' + message;
			}
			internalOutput(message, 'preventLink');
		}
	}
}

function createPopup(contents, width) {
	opts.popups++;
	$('body').append('<div class="popup" id="popup'+opts.popups+'" style="width: '+width+'px;">'+contents+' <a href="#" class="close"><i class="icon-remove"></i></a></div>');

	//Attach close popup event
	var $popup = $('#popup'+opts.popups);
	var height = $popup.outerHeight();
	$popup.css({'height': height+'px', 'margin': '-'+(height/2)+'px 0 0 -'+(width/2)+'px'});

	$popup.on('click', '.close', function(e) {
		e.preventDefault();
		$popup.remove();
	});
}

function toggleWasd(state) {
	opts.wasd = (state == 'on' ? true : false);
}

/*****************************************
*
* MAKE MACRO DICTIONARY
*
******************************************/

// Callback for winget.
function wingetMacros(macros) {
	var idRegex = /.*?\.(?!(?:CRTL|ALT|SHIFT)\+)(.*?)(?:\+REP)?\.command/; // Do NOT match macros which need crtl, alt or shift to be held down (saves a ton of headache because I don't give enough of a fuck).
	for (key in macros) {
		match   = idRegex.exec(key)
		if (match === null)
			continue
		macroID = match[1].toUpperCase();

		opts.macros[macroID] = macros[key];
	}
}

/*****************************************
*
* DOM READY
*
******************************************/

if (typeof $ === 'undefined') {
	var div = document.getElementById('loading').childNodes[1];
	div += '<br><br>ERROR: Jquery did not load.';
}

$(function() {
	// Detect encoding.
	if (document.defaultCharset)
	{
		runByond("?_src_=chat&proc=encoding&encoding=" + escaper(document.defaultCharset));
	}

	$messages = $('#messages');
	$subOptions = $('#subOptions');

	//Hey look it's a controller loop!
	setInterval(function() {
		if (opts.lastPang + opts.pangLimit < Date.now() && !opts.restarting) { //Every pingLimit
				if (!opts.noResponse) { //Only actually append a message if the previous ping didn't also fail (to prevent spam)
					opts.noResponse = true;
					opts.noResponseCount++;
					internalOutput('<div class="connectionClosed internal" data-count="'+opts.noResponseCount+'">You are either experiencing lag or the connection has closed.</div>', 'internal');
				}
		} else if (opts.noResponse) { //Previous ping attempt failed ohno
				$('.connectionClosed[data-count="'+opts.noResponseCount+'"]:not(.restored)').addClass('restored').text('Your connection has been restored (probably)!');
				opts.noResponse = false;
		}
	}, 2000); //2 seconds


	/*****************************************
	*
	* LOAD SAVED CONFIG
	*
	******************************************/
	var savedConfig = {
		'sfontSize': getCookie('fontsize'),
		'sfontType': getCookie('fonttype'),
		'spingDisabled': getCookie('pingdisabled'),
		'shighlightTerms': getCookie('highlightterms'),
		'shighlightColor': getCookie('highlightcolor'),
		'scolorPreset': getCookie('colorpreset'),
		'smessageCombining': getCookie('messagecombining')
	};

	if (savedConfig.sfontSize) {
		$messages.css('font-size', savedConfig.sfontSize);
		internalOutput('<span class="internal boldnshit">Loaded font size setting of: '+savedConfig.sfontSize+'</span>', 'internal');
	}
	if (savedConfig.sfontType) {
		$messages.css('font-family', savedConfig.sfontType);
		internalOutput('<span class="internal boldnshit">Loaded font type setting of: '+savedConfig.sfontType+'</span>', 'internal');
	}
	if (savedConfig.spingDisabled) {
		if (savedConfig.spingDisabled == 'true') {
			opts.pingDisabled = true;
			$('#ping').hide();
		}
		internalOutput('<span class="internal boldnshit">Loaded ping display of: '+(opts.pingDisabled ? 'hidden' : 'visible')+'</span>', 'internal');
	}
	if (savedConfig.shighlightTerms) {
		var savedTerms = $.parseJSON(savedConfig.shighlightTerms);
		var actualTerms = '';
		for (var i = 0; i < savedTerms.length; i++) {
			if (savedTerms[i]) {
				actualTerms += savedTerms[i] + ', ';
			}
		}
		if (actualTerms) {
			actualTerms = actualTerms.substring(0, actualTerms.length - 2);
			internalOutput('<span class="internal boldnshit">Loaded highlight strings of: ' + actualTerms+'</span>', 'internal');
			opts.highlightTerms = savedTerms;
		}
	}
	if (savedConfig.shighlightColor) {
		opts.highlightColor = savedConfig.shighlightColor;
		internalOutput('<span class="internal boldnshit">Loaded highlight color of: '+savedConfig.shighlightColor+'</span>', 'internal');
	}

	if (savedConfig.scolorPreset) {
		opts.colorPreset = Number(savedConfig.scolorPreset);
		updateColorPreset();
		internalOutput('<span class="internal boldnshit">Loaded color preset of: '+colorPresets[opts.colorPreset]+'</span>', 'internal');
	}

	if (savedConfig.smessageCombining) {
		if (savedConfig.smessageCombining == 'false') {
			opts.messageCombining = false;
		} else {
			opts.messageCombining = true;
		}
	}

	(function() {
		var dataCookie = getCookie('connData');
		if (dataCookie) {
			var dataJ;
			try {
				dataJ = $.parseJSON(dataCookie);
			} catch (e) {
				window.onerror('JSON '+e+'. '+dataCookie, 'browserOutput.html', 434);
				return;
			}
			opts.clientData = dataJ;
		}
	})();


	/*****************************************
	*
	* BASE CHAT OUTPUT EVENTS
	*
	******************************************/

	$('body').on('click', 'a', function(e) {
		e.preventDefault();
	});

	$('body').on('mousedown', function(e) {
		var $target = $(e.target);

		if ($target.is('a') || $target.parent('a').length || $target.is('input') || $target.is('textarea')) {
			opts.preventFocus = true;
		} else {
			opts.preventFocus = false;
			opts.mouseDownX = e.pageX;
			opts.mouseDownY = e.pageY;
		}
	});

	$messages.on('mousedown', function(e) {
		if ($subOptions && $subOptions.is(':visible')) {
			$subOptions.slideUp('fast', function() {
				$(this).removeClass('scroll');
				$(this).css('height', '');
			});
			clearInterval(opts.subOptionsLoop);
		}
	});

	$('body').on('mouseup', function(e) {
		if (!opts.preventFocus &&
			(e.pageX >= opts.mouseDownX - opts.clickTolerance && e.pageX <= opts.mouseDownX + opts.clickTolerance) &&
			(e.pageY >= opts.mouseDownY - opts.clickTolerance && e.pageY <= opts.mouseDownY + opts.clickTolerance)
		) {
			opts.mouseDownX = null;
			opts.mouseDownY = null;
			runByond('byond://winset?mapwindow.map.focus=true');
		}
	});

	$messages.on('click', 'a', function(e) {
		var href = $(this).attr('href');
		if (href[0] == '?' || (href.length >= 8 && href.substring(0,8) == 'byond://')) {
			runByond(href);
		} else {
			href = escaper(href);
			runByond('?action=openLink&link='+href);
		}
		runByond('byond://winset?mapwindow.map.focus=true');
	});

	//Fuck everything about this event. Will look into alternatives.
	$('body').on('keydown', function(e) {
		if (e.target.nodeName == 'INPUT' || e.target.nodeName == 'TEXTAREA') {
			return;
		}

		if (e.ctrlKey || e.altKey || e.shiftKey) { //Band-aid "fix" for allowing ctrl+c copy paste etc. Needs a proper fix.
			return;
		}

		e.preventDefault()

		var k = e.which;
		var command; // Command to execute through winset.

		// Hardcoded because else there would be no feedback message.
		if (k == 113) { // F2
			runByond('byond://winset?screenshot=auto');
			internalOutput('Screenshot taken', 'internal');
		}

		var c = "";
		switch (k) {
			case 8:
				c = 'BACK';
			case 9:
				c = 'TAB';
			case 13:
				c = 'ENTER';
			case 19:
				c = 'PAUSE';
			case 27:
				c = 'ESCAPE';
			case 33: // Page up
				c = 'NORTHEAST';
			case 34: // Page down
				c = 'SOUTHEAST';
			case 35: // End
				c = 'SOUTHWEST';
			case 36: // Home
				c = 'NORTHWEST';
			case 37:
				c = 'WEST';
			case 38:
				c = 'NORTH';
			case 39:
				c = 'EAST';
			case 40:
				c = 'SOUTH';
			case 45:
				c = 'INSERT';
			case 46:
				c = 'DELETE';
			case 93: // That weird thing to the right of alt gr.
				c = 'APPS';

			default:
				c = String.fromCharCode(k);
		}

		if(opts.macros.hasOwnProperty(c.toUpperCase()))
			command = opts.macros[c];

		if (command) {
			runByond('byond://winset?mapwindow.map.focus=true;command='+command);
			return false;
		}
		else if (c.length == 0) {
			if (!e.shiftKey) {
				c = c.toLowerCase();
			}
			runByond('byond://winset?mapwindow.map.focus=true;mainwindow.input.text='+c);
			return false;
		} else {
			runByond('byond://winset?mapwindow.map.focus=true');
			return false;
		}
	});

	//Mildly hacky fix for scroll issues on mob change (interface gets resized sometimes, messing up snap-scroll)
	$(window).on('resize', function(e) {
		if ($(this).height() !== opts.priorChatHeight) {
			$('body,html').scrollTop($messages.outerHeight());
			opts.priorChatHeight = $(this).height();
		}
	});

	//Audio sound prevention
	$messages.on('click', '.stopAudio', function() {
		var $audio = $(this).parent().children('audio');
		if ($audio) {
			$audio.remove();
		}
	});


	/*****************************************
	*
	* OPTIONS INTERFACE EVENTS
	*
	******************************************/

	$('body').on('click', '#newMessages', function(e) {
		var messagesHeight = $messages.outerHeight();
		$('body,html').scrollTop(messagesHeight);
		$('#newMessages').remove();
		runByond('byond://winset?mapwindow.map.focus=true');
	});

	$('#toggleOptions').click(function(e) {
		if ($subOptions.is(':visible')) {
			$subOptions.slideUp('fast', function() {
				$(this).removeClass('scroll');
				$(this).css('height', '');
			});
			clearInterval(opts.subOptionsLoop);
		} else {
			$subOptions.slideDown('fast', function() {
				var windowHeight = $(window).height();
				var toggleHeight = $('#toggleOptions').outerHeight();
				var priorSubHeight = $subOptions.outerHeight();
				var newSubHeight = windowHeight - toggleHeight;
				$(this).height(newSubHeight);
				if (priorSubHeight > (windowHeight - toggleHeight)) {
					$(this).addClass('scroll');
				}
			});
			opts.subOptionsLoop = setInterval(function() {
				if (!opts.suppressOptionsClose && $('#subOptions').is(':visible')) {
					$subOptions.slideUp('fast', function() {
						$(this).removeClass('scroll');
						$(this).css('height', '');
					});
					clearInterval(opts.subOptionsLoop);
				}
			}, 5000); //Every 5 seconds
		}
	});

	$('#subOptions, #toggleOptions').mouseenter(function() {
		opts.suppressOptionsClose = true;
	});

	$('#subOptions, #toggleOptions').mouseleave(function() {
		opts.suppressOptionsClose = false;
	});

	$('#decreaseFont').click(function(e) {
		var fontSize = parseInt($messages.css('font-size'));
		fontSize = fontSize - 1 + 'px';
		$messages.css({'font-size': fontSize});
		setCookie('fontsize', fontSize, 365);
		internalOutput('<span class="internal boldnshit">Font size set to '+fontSize+'</span>', 'internal');
	});

	$('#increaseFont').click(function(e) {
		var fontSize = parseInt($messages.css('font-size'));
		fontSize = fontSize + 1 + 'px';
		$messages.css({'font-size': fontSize});
		setCookie('fontsize', fontSize, 365);
		internalOutput('<span class="internal boldnshit">Font size set to '+fontSize+'</span>', 'internal');
	});

	$('#chooseFont').click(function(e) {
		if ($('.popup .changeFont').is(':visible')) {return;}
		var popupContent = '<div class="head">Change Font</div>' +
			'<div id="changeFont" class="changeFont">'+
				'<a href="#" data-font="Verdana" style="font-family: Verdana;">Verdana (Default)</a>'+
				'<a href="#" data-font="\'Helvetica Neue\', Helvetica, Arial" style="font-family: \'Helvetica Neue\', Helvetica, Arial;">Arial / Helvetica</a>'+
				'<a href="#" data-font="Times New Roman" style="font-family: Times New Roman;">Times New Roman</a>'+
				'<a href="#" data-font="Georgia" style="font-family: Georgia;">Georgia</a>'+
				'<a href="#" data-font="Courier New" style="font-family: Courier New;">Courier New</a>'+
				'<a href="#" data-font="Lucida Console" style="font-family: Lucida Console;">Lucida Console</a>'+
				'<a href="#" data-font="Wingdings" style="font-family: Wingdings;">Wingdings</a>'+
				'<a href="#" data-font="Comic Sans MS" style="font-family: Comic Sans MS;">Comic Sans MS</a>'+
			'</div>';
		createPopup(popupContent, 200);
	});

	$('body').on('click', '#changeFont a', function(e) {
		var font = $(this).attr('data-font');
		$messages.css('font-family', font);
		setCookie('fonttype', font, 365);
	});

	$('#togglePing').click(function(e) {
		if (opts.pingDisabled) {
			$('#ping').slideDown('fast');
			opts.pingDisabled = false;
		} else {
			$('#ping').slideUp('fast');
			opts.pingDisabled = true;
		}
		setCookie('pingdisabled', (opts.pingDisabled ? 'true' : 'false'), 365);
	});

	$('#saveLog').click(function(e) {
		$.ajax({
			type: 'GET',
			url: 'browserOutput.css',
			success: function(styleData) {
				var win;

				try {
					win = window.open('', 'Chat Log', 'toolbar=no, location=no, directories=no, status=no, menubar=yes, scrollbars=yes, resizable=yes, width=780, height=600, top=' + (screen.height/2 - 635/2) + ', left=' + (screen.width/2 - 780/2));
				} catch (e) {
					return;
				}

				if (win) {
					win.document.head.innerHTML = '<title>Chat Log</title>';
					win.document.head.innerHTML += '<style>' + styleData + '</style>';
					win.document.body.innerHTML = $messages.html();
				}
			}
		});
	});

	$('#highlightTerm').click(function(e) {
		if ($('.popup .highlightTerm').is(':visible')) {return;}
		var termInputs = '';
		for (var i = 0; i < opts.highlightLimit; i++) {
			termInputs += '<div><input type="text" name="highlightTermInput'+i+'" id="highlightTermInput'+i+'" class="highlightTermInput'+i+'" maxlength="255" value="'+(opts.highlightTerms[i] ? opts.highlightTerms[i] : '')+'" /></div>';
		}
		var popupContent = '<div class="head">String Highlighting</div>' +
			'<div class="highlightPopup" id="highlightPopup">' +
				'<div>Choose up to '+opts.highlightLimit+' strings that will highlight the line when they appear in chat.</div>' +
				'<form id="highlightTermForm">' +
					termInputs +
					'<div><input type="text" name="highlightColor" id="highlightColor" class="highlightColor" '+
						'style="background-color: '+(opts.highlightColor ? opts.highlightColor : '#FFFF00')+'" value="'+(opts.highlightColor ? opts.highlightColor : '#FFFF00')+'" maxlength="7" /></div>' +
					'<div><input type="submit" name="highlightTermSubmit" id="highlightTermSubmit" class="highlightTermSubmit" value="Save" /></div>' +
				'</form>' +
			'</div>';
		createPopup(popupContent, 250);
	});

	$('body').on('keyup', '#highlightColor', function() {
		var color = $('#highlightColor').val();
		color = color.trim();
		if (!color || color.charAt(0) != '#') return;
		$('#highlightColor').css('background-color', color);
	});

	$('body').on('submit', '#highlightTermForm', function(e) {
		e.preventDefault();

		var count = 0;
		while (count < opts.highlightLimit) {
			var term = $('#highlightTermInput'+count).val();
			if (term) {
				term = term.trim();
				if (term === '') {
					opts.highlightTerms[count] = null;
				} else {
					opts.highlightTerms[count] = term.toLowerCase();
				}
			} else {
				opts.highlightTerms[count] = null;
			}
			count++;
		}

		var color = $('#highlightColor').val();
		color = color.trim();
		if (color == '' || color.charAt(0) != '#') {
			opts.highlightColor = '#FFFF00';
		} else {
			opts.highlightColor = color;
		}
		var $popup = $('#highlightPopup').closest('.popup');
		$popup.remove();

		setCookie('highlightterms', JSON.stringify(opts.highlightTerms), 365);
		setCookie('highlightcolor', opts.highlightColor, 365);
	});

	$('#clearMessages').click(function() {
		$messages.empty();
		opts.messageCount = 0;
	});

	$('#changeColorPreset').click(function() {
		opts.colorPreset = (opts.colorPreset+1) % colorPresets.length;
		updateColorPreset();
		setCookie('colorpreset', opts.colorPreset, 365);
		internalOutput('<span class="internal boldnshit">Changed color preset to: '+colorPresets[opts.colorPreset]);
	});

	$('#toggleCombine').click(function(e) {
		opts.messageCombining = !opts.messageCombining;
		setCookie('messagecombining', opts.messageCombining, 365);
		internalOutput('<span class="internal boldnshit">Line combining '+(opts.messageCombining ? 'enabled' : 'disabled')+'</span>', 'internal');
	})

	// Tell BYOND to give us a macro list.
	// I don't know why but for some retarded reason,
	// You need to activate hotkeymode before you can winget the macros in it.
	runByond('byond://winset?id=mainwindow&macro=hotkeymode');
	runByond('byond://winset?id=mainwindow&macro=macro');

	runByond('byond://winget?callback=wingetMacros&id=hotkeymode.*&property=command');

	/*****************************************
	*
	* KICK EVERYTHING OFF
	*
	******************************************/

	runByond('?_src_=chat&proc=doneLoading');
	if ($('#loading').is(':visible')) {
		$('#loading').remove();
	}
	$('#userBar').show();
	opts.priorChatHeight = $(window).height();
});
