////---- Config variables ----////

// The Web Service URL
var servicelink = "service/dbservice.php",
	// For now, until the C# web service is 100% done, we will be using both the PHP service and the C#-based one
	servicelink2 = "http://localhost:9000"; // Change this to the URL of the web service

////-- End config variables --////

var isconnected = false;

//online offline listener works for any connection required for a page or function to work
document.addEventListener("offline", function() {
	isconnected = false;
}, false);
document.addEventListener("online", function() {
	isconnected = true;
}, false);
document.addEventListener("deviceready", DeviceReady, false);
window.addEventListener("load", function() {
	//get device
	var ua = navigator.userAgent;
	var checker = {
		iphone: ua.match(/(iPhone|iPod|iPad)/),
		blackberry: ua.match(/BlackBerry/),
		android: ua.match(/Android/)
	};
	//if device iphone scroll just down to status bar
	if (checker.iphone) {
		window.top.scrollTo(0, 1);
	}
});

//dont needed for mobile
$(document).ready(function() {
	DeviceReady();
});

function DeviceReady() {
	//this function under db.js checks localstorage and if user logged in sends him to main page instead of login page
	isloggedin();
}

//if a user who hasn't logged in tries to go another page don't let him see that page.
function isCheater() {
	if (!window.localStorage.getItem("sid")) $.mobile.changePage("#page-main");
}

//if user didn't select task but tries to change address and want to go question page directly don't allow him.
function isTaskSelected() {
	if (!window.localStorage.getItem("taskid")) $.mobile.changePage("#page-main");
}

var refreshIntervalId = "";
$('#page-chat').live('pageinit', function() {
	//instancitae chat class
	var chat = new Chat();
	chat.getState();
	$('#sendmsg').click(function() {
		if ($('#txtmsg').val() !== "") {
			chat.send($('#txtmsg').val(), window.localStorage.getItem("nickname"));
			$('#txtmsg').val('');
		}
	});
}).live('pageshow', function() {
	//when user opens this page, set interval and update chat every 2.5 sec.
	refreshIntervalId = setInterval(updateChat, 2500);
}).live('pagehide', function() {
	//when user changes page clear interval and chat screen. like users logout from chat.
	clearInterval(refreshIntervalId);
	$('#chatscreen').empty();
});

$('#page-main').live('pageinit', function() {
	//this two button hides and show second menu on navbar
	$('#smallmenuhide').click(function() {
		$('#choisetohide').slideUp('fast');
		$(this).hide('fast');
		$('#smallmenushow').show('fast');
	});

	$('#smallmenushow').click(function() {
		$('#choisetohide').slideDown('fast');
		$(this).hide('fast');
		$('#smallmenuhide').show('fast');
	});

	$('#chtbtn').click(function() {
		$.mobile.changePage("#page-chat", {
			transition: "slideup"
		});
	});

	$('#taskspage').click(function() {
		//checks if user has assigned any game
		if (window.localStorage.getItem("gameid") != "undefined") {
			//checks if user has task accepted and based on send either task selection page or shows task information page
			if (window.localStorage.getItem("taskid")) $.mobile.changePage("#dialog-task", {
				transition: "pop"
			});
			else $.mobile.changePage("#page-tasklist", {
				transition: "slide",
				reverse: false,
				changeHash: false
			});
		} else fadingMsg("You are not registered in any game, please contact your administrator.");
	});

	$('#scananswer').click(function() {
		//checks if user has assigned any game
		if (window.localStorage.getItem("gameid") != "undefined") {
			//checks if user has task accepted and based on send either task selection page or shows task information page
			if (window.localStorage.getItem("taskid")) {
				//if secret id for a task found change view
				if (window.localStorage.getItem('secretidfound')) {
					$.mobile.changePage("#page-questionanswer", {
						transition: "slide"
					});
				} else {
					$.mobile.changePage("#page-scananswer", {
						transition: "slide",
						reverse: false,
						changeHash: false
					});
				}
			} else {
				fadingMsg("You have not chosen any task yet, please choose one first.");
				$.mobile.changePage("#page-tasklist", {
					transition: "slide",
					reverse: false,
					changeHash: false
				});
			}
		} else fadingMsg("You are not registered in any game, please contact your administrator.");
	});
}).live('pageshow', function(event) {
	if (window.localStorage.getItem("reload")) {
		if (window.localStorage.getItem("sid")) {
			//after accepting task and finisihing task, this call is made for refreshing info on main page
			if (window.localStorage.getItem("taskid")) {
				window.localStorage.removeItem("reload");
				window.location.reload(true);
			} else {
				$('#mainnavbar').hide();
				confirmDialog("Congrats", "You have solved all questions on this task, now you can go and select another task.", "#page-main");
			}
		} else {
			window.localStorage.removeItem("reload");
			window.location.reload(true);
		}
	} else if (window.localStorage.getItem("gamfinished")) {
		window.localStorage.removeItem("gamfinished");
		$('#mainnavbar').hide();
		confirmDialog("Congrats", "You have finished all tasks that are assigned! Now you know some useful services.", "#page-main");
	}
	//adds main page user info like team name and if they have task
	ShowUserInfo();
	//isloggedin();
});

$('#dialog-devmenu').live('pageinit', function(event) {
	//user option setting switches styling handled by this two change listener
	$("#flip-phone").change(function() {
		var phonesw = $(this);
		var show = phonesw[0].selectedIndex == 1 ? true : false;
		if (show) {
			$(this).slider({
				trackTheme: "b"
			});
			window.localStorage.setItem("tempphoneoption", 1);
		} else {
			$(this).slider({
				trackTheme: "c"
			});
			window.localStorage.setItem("tempphoneoption", 0);
		}
		$(this).slider('refresh');
	});

	$("#flip-email").change(function() {
		var emailsw = $(this);
		var show = emailsw[0].selectedIndex == 1 ? true : false;
		if (show) {
			$(this).slider({
				trackTheme: "b"
			});
			window.localStorage.setItem("tempemailoption", 1);
		} else {
			$(this).slider({
				trackTheme: "c"
			});
			window.localStorage.setItem("tempemailoption", 0);
		}
		$(this).slider('refresh');
	});
}).live('pageshow', function(evenet) {
	if (window.localStorage.getItem('nickname')) $('.username').html(window.localStorage.getItem('nickname'));
	else $('.username').html('Not Logged In');

	var phonesw = $("#flip-phone");
	var emailsw = $("#flip-email");
	$('#logout').click(function() {
		if (window.localStorage.getItem('sid') === null) {
			fadingMsg("You didnot log in yet.");
		} else {
			window.localStorage.clear();
			$('div[id="page-main"] > div[data-role="footer"]').addClass('hidden');
			$('#mainmenu').addClass('hidden');
			$('#login').removeClass('hidden');
			window.localStorage.setItem("reload", "true");
			$.mobile.changePage("#page-main");
		}
	});
	if (window.localStorage.getItem('sid') === null) {
		phonesw.slider('disable');
		emailsw.slider('disable');
	} else {
		phonesw.slider('enable');
		emailsw.slider('enable');
		//position user option
		phonesw[0].selectedIndex = window.localStorage.getItem("phoneoption");
		$(phonesw).trigger('change');
		emailsw[0].selectedIndex = window.localStorage.getItem("emailoption");
		$(emailsw).trigger('change');
	}
}).live('pagehide', function() {
	//on closing page if there is any difference update
	if (window.localStorage.getItem("tempemailoption") != window.localStorage.getItem("emailoption") || window.localStorage.getItem("tempphoneoption") != window.localStorage.getItem("phoneoption")) {
		window.localStorage.setItem("phoneoption", window.localStorage.getItem("tempphoneoption"));
		window.localStorage.setItem("emailoption", window.localStorage.getItem("tempemailoption"));
		$.ajax({
			url: servicelink2 + "/users/" + window.localStorage.getItem("sid") + "/options",
			type: "post",
			data: JSON.stringify({
				userId: window.localStorage.getItem("sid"),
				phoneVisible: window.localStorage.getItem("phoneoption"),
				emailVisible: window.localStorage.getItem("emailoption")
			}),
			success: function (data) {
				data = $.parseJSON(data);
				if(data.status == 1) {}
			}
		});
	}
	//remove temporarly keeped user option data
	window.localStorage.removeItem("tempemailoption");
	window.localStorage.removeItem("tempphoneoption");
});

function go() {
	//if user is not logged in before or logout this function will be run to show them login page
	$('#login').removeClass('hidden');

	//on user login page, when user enters their user name and presses enter it blocks default action and put focus on password field.
	$('#login_username').keypress(function(e) {
		if (e.which == 13) {
			$('#login_password').focus().select();
		}
	});

	$('#login_password').keypress(function(e) {
		if (e.which == 13) {
			$("#login_submit").trigger('click');
		}
	});

	$("#login_submit").click(function(event) {
		event.preventDefault();
		//retrieve information from the form
		var credentials = {
			userName: $('#login_username').val(),
			password: $('#login_password').val()
		};

		//check if they are null
		if (credentials.userName === "" || credentials.password === "") {
			fadingMsg("Please fill in the username and password fields.");
		} else {
			//ask server if user exist
			$.ajax({
				async: false,
				type: 'POST',
				url: servicelink2 + '/authenticate',
				data: {
					userName: credentials.userName,
					password: credentials.password
				},
				success: function(data) {
					if(data.sessionId !== undefined) {
						saveSession(data.sessionId);
						$.ajax({
							url: servicelink2 + '/info?' + sessionQueryParams(),
							async: false,
							success: function(data) {
								// If newly logged in user has a nickname, then save their info
								if(data.user.nickname !== null && data.user.nickname !== "") {
									saveuser(data.user.id, credentials.userName);
								} else {
									// username will be asked here
								}
							}
						});
					} else {
						fadingMsg("Incorrect username or password. Please try again.");
					}
				},
				complete: function(data) {
					// on completion of login, ask for all user info, such as team name, game id, and if they have tasks accepted already
					if(window.localStorage.getItem("sid")) {
						$.ajax({
							async: false,
							type: 'GET',
							url: servicelink2 + '/init?' + sessionQueryParams(),
							success: function(data) {
								saveuserInfo(data.userinfo);
								if(data.hasOwnProperty('scripts')) {
									saveuserScript(data.scripts);
									saveuserQuestions(data.questions);
								}
							},
							complete: function(data) {
								// after completion of the two database calls, check again if the user info is saved, and let them go to the main page.
								isloggedin();
							},
							error: function(data) {}
						});
					}
				},
				error: function(data) {}
			});
		}
	});
}

//this function is called by isloggedin() function under db.js
function gomain() {
	//removed login page
	$('#login').addClass('hidden');
	$('#login_username').val('');
	$('#login_password').val('');
	//starts timer for game
	startTimer();
	$('div[id="page-main"] > div[data-role="footer"]').removeClass('hidden');
	ShowUserInfo();
	$('#mainmenu').removeClass('hidden');
}

//finds the time dif between now and game finish data and starts timer on main screen
function startTimer() {
	if (window.localStorage.getItem("gamefinish")) {
		var timedif = (new Date()).getTime() + 1000;
		var gmfinish = window.localStorage.getItem("gamefinish");
		if (gmfinish != "undefined") {
			timedif = (new Date()).getTime() + ((new Date(gmfinish.replace(" ", "T") + "+00:00")).getTime() - (new Date()).getTime());
		}
		$('#counter').empty();
		$('#counter').countdown({
			timestamp: timedif
		});
	} else {
		fadingMsg('Game has not started yet.');
	}
}

//show some info about current user info on main page
function ShowUserInfo() {
	if (window.localStorage.getItem("teamname")) $('#teamname').html(window.localStorage.getItem("teamname"));
	if (window.localStorage.getItem("taskname")) $('#currenttask').html(window.localStorage.getItem("taskname"));
}

$('#page-scananswer').live('pageshow', function(event) {
	//checksome information before letting user see page
	isCheater();
	isTaskSelected();
	//show some info about task on scan answer page
	$('#questions').html(window.localStorage.getItem("numberofquestion"));
	//solved task are checked with solvedtask function in this script, which checks status of task that is saved in login and shows user
	$('#solveds').html(solvedtasks());

	//binds enter button with get_question buttons click event
	$('#questionid').keypress(function(e) {
		if (e.which == 13) {
			$('#get_question').trigger('click');
		}
	});

	$('#get_question').click(function() {
		if (window.localStorage.getItem("tasksecret").toLowerCase() == $('#questionid').val().toLowerCase()) {
			//saves secret on localstorage for further use.
			window.localStorage.setItem('secretidfound', 1);
			$.mobile.changePage("#page-questionanswer", {
				transition: "slide"
			});
		} else {
			$('#errormsg').html("Incorrect key, Please try again!").css('color', 'red');
		}
	});
});

//this page show user all questions in slide view and let's users to answer
$('#page-questionanswer').live('pageshow', function() {
	isCheater();
	isTaskSelected();
	if (!window.localStorage.getItem("secretidfound")) confirmDialog("Task", "Please enter Key or scan QR Code", "#page-scananswer");

	//binds enter button with answer_btn buttons click event
	$('#singleanswer').keypress(function(e) {
		if (e.which == 13) {
			$('#answer_btn').trigger('click');
		}
	});

	//this two button hides and show second menu on navbar
	$('#menuhide').click(function() {
		$('#choisehide').slideUp('fast');
		$(this).hide('fast');
		$('#menushow').show('fast');
	});

	$('#menushow').click(function() {
		$('#choisehide').slideDown('fast');
		$(this).hide('fast');
		$('#menuhide').show('fast');
	});
	//with the rest of the code below  we are retrieving all question saved in localstorage and styling view with those questions based on their question type
	for (var i = 0; i < window.localStorage.getItem("numberofquestion"); i++) {
		var question = window.localStorage.getItem(("question" + i));
		if (window.localStorage.getItem(("questiontype" + i)) == 2) {
			var aa = question.split("~&~");
			question = aa[0];
		}
		if (i === 0) $('#taskquestions').append('<li style="display:block"><div class="questiondiv"><span>Question : ' + (i + 1) + '</span><br/><br/>' + question + '</div></li>');
		else $('#taskquestions').append('<li style="display:none"><div class="questiondiv"><span>Question : ' + (i + 1) + '</span><br/><br/>' + question + '</div></li>');

	}
	changeContent(0);
	var questiontype = window.localStorage.getItem(("questiontype0"));
	var questionid = window.localStorage.getItem(("questionid0"));
	var locationofquestion = 0;
	var slider1 = new Swipe(document.getElementById('imgslider1'), {
		callback: function(e, pos) {
			var i = bullets.length;
			while (i--) {
				bullets[i].className = ' ';
			}
			bullets[pos].className = 'on';
			//hide options and empty multichoice
			$('#multichoice').addClass('hidden');
			$('#singleanswer').addClass('hidden');
			$('#singleans').val("");
			$('#multichoiceq').empty();
			changeContent(pos);
			questiontype = window.localStorage.getItem(("questiontype" + pos));
			questionid = window.localStorage.getItem(("questionid" + pos));
			locationofquestion = pos;
		}
	}),
		bullets = document.getElementById('qposition').getElementsByTagName('em');

	$('#qprev').click(function() {
		slider1.prev();
		return false;
	});

	$('#qnext').click(function() {
		slider1.next();
		return false;
	});

	for (i = 0; i < numberofimages; i++) {
		if (i === 0) $('#qposition').append('<em class="on">&bull;</em>');
		else $('#qposition').append('<em>&bull;</em>');
	}

	$('#answer_btn').click(function() {
		var choice = $("#multichoiceq input[type='radio']:checked").val();
		var ans = $('#singleans').val();
		if (questiontype == 2) {
			if (choice) answerQuestion(choice, questionid, locationofquestion);
			else fadingMsg("Please select an answer");
		} else {
			if (ans) answerQuestion(ans, questionid, locationofquestion);
			else fadingMsg("Please enter answer");
		}
	});

}).live('pagehide', function() {
	slider1 = "";
	$('#taskquestions').empty();
	$('#qposition').empty();
});

//each time slide position changed we are re arranging view based on question type and if question solved before
function changeContent(pos) {
	result = window.localStorage.getItem(("question" + pos));
	var solved = "notsolved";
	if (window.localStorage.getItem(("questionstatus" + pos)) == 1) solved = "solved";
	if (window.localStorage.getItem(("questiontype" + pos)) == 2) {
		var aa = result.split("~&~");
		var question = aa[0];
		var options = aa[1].split("~");
		result = question;
		for (var i = 0; i < options.length; i++) {
			if (solved == "solved" && window.localStorage.getItem(("questionanswer" + pos)) == options[i]) $('<input data-theme="c" type="radio" name="radio-choice-1" id="radio-choice-' + i + '" value="' + options[i] + '" checked/>	<label for="radio-choice-' + i + '">' + options[i] + '</label>').appendTo('#multichoiceq');
			else $('<input data-theme="c" type="radio" name="radio-choice-1" id="radio-choice-' + i + '" value="' + options[i] + '" />	<label for="radio-choice-' + i + '">' + options[i] + '</label>').appendTo('#multichoiceq');
			$("#radio-choice-" + i).checkboxradio().checkboxradio("refresh");
		}
		$("fieldset#multichoiceq").controlgroup("refresh");
		$('#questiontype').html('Multichoice').css('color', 'blue');
		$('#multichoice').removeClass('hidden');

		if (solved == "solved") {
			$("fieldset#multichoiceq input[type='radio']").checkboxradio('disable');
		} else {
			$("fieldset#multichoiceq input[type='radio']").checkboxradio('enable');
		}
	} else {
		$('#questiontype').html('Answer').css('color', 'blue');
		$('#singleanswer').removeClass('hidden');
		if (solved == "solved") {
			$('#singleans').val(window.localStorage.getItem(("questionanswer" + pos)));
			$('#singleans').textinput('disable');
		} else $('#singleans').textinput('enable');
	}
}

//amswer question by sending required information to service.
function answerQuestion(answer, questionid, locationofquestion) {
	$.post(servicelink, "tag=adresponse&u_id=" + window.localStorage.getItem("sid") + "&t_id=" + window.localStorage.getItem("teamid") + "&tsk_id=" + window.localStorage.getItem("taskid") + "&q_id=" + questionid + "&response=" + answer + "&location=").done(function(data, textStatus, jqXHR) {
		data = $.parseJSON(data);
		if (data.success == 1) {
			//if all question are solved this call return new userinfo based of that user info we are sending user to main page and refresing all information, so they will be able to choose new task available
			if (data.hasOwnProperty('userinfo')) {
				//fadingMsg('<div align=center><strong>Congratz!</strong><br/>You have solved all question on this task, Now you can go and select another task.</div>','#EB88A9','#88EBE4',5000);
				// var userid=window.localStorage.getItem("sid"),nickname=window.localStorage.getItem("nickname");
				// window.localStorage.clear();
				// saveuser(userid,nickname);
				// saveuserInfo(data.userinfo);
				removeTaskData();
				window.localStorage.setItem("reload", "true"); //,reloadPage:true
				$.mobile.changePage("#page-main");
			} else if (data.hasOwnProperty('gamecomplete')) {
				removeTaskData();
				window.localStorage.setItem("gamfinished", "true"); //,reloadPage:true
				$.mobile.changePage("#page-main");
			} else {
				//if question is answered and answer were correct change status of question in localstorage and save answer for it to use it later
				$('#multichoiceq').empty();
				window.localStorage.setItem("questionstatus" + locationofquestion, data.success);
				window.localStorage.setItem("questionanswer" + locationofquestion, answer);
				changeContent(locationofquestion);
				if (locationofquestion != numberofimages) $('#qnext').trigger('click');
				fadingMsg('<div align=center><strong>Congratz!</strong><br/>Correct answer.</div>', '#EB88A9', '#88EBE4');
			}
		} else {
			//if somehow there were mistake and they passed same value for same question database restriction will not accept it and will return 'answered' so we can wanr user with this info
			if (data.hasOwnProperty('answered')) fadingMsg(data.error_msg);
			else fadingMsg("Wrong Answer!");
		}
	});
}

//when they have task accepted this page will be showed to user
$('#dialog-task').live('pageinit', function() {
	isCheater();
	isTaskSelected();
	//if they want to listen and read task dictionary this button wil direct them to that page
	$('#taskdictionary').click(function() {
		$.mobile.changePage("#page-download", {
			transition: "slide"
		});
	});
}).live('pageshow', function(event) {
	$('#taskname').html(window.localStorage.getItem("taskname"));
	$('#campusname').html(window.localStorage.getItem("campusname"));
	$('#direction').html(window.localStorage.getItem("numberofscript") + " available");
	$('#question').html(window.localStorage.getItem("numberofquestion"));
	$('#solved').html(solvedtasks());
});

function solvedtasks() {
	var result = 0;
	for (var i = 0; i < window.localStorage.getItem("numberofquestion"); i++) {
		if (window.localStorage.getItem(("questionstatus" + i)) == 1) result++;
	}
	return result;
}

$('#page-contact').live('pageshow', function(event) {
	isCheater();
	getMemberList();

	//normally all contacts is loaded when page loaded, refresh button located incase they searched one contact and didnt want to delete all those letters they can refresh contact info and load all
	$('#memberfsh').click(function() {
		getMemberList();
	});
});

function getMemberList() {
	//retrieves teammates contact information with sending user id to service
	$.post(servicelink, "tag=contact&u_id=" + window.localStorage.getItem("sid")).done(function(data, textStatus, jqXHR) {
		data = $.parseJSON(data);
		$('#memberList').empty();
		$.each(data['contacts'], function(entryIndex, entry) {
			var list = '<li id="list-' + entryIndex + '" data-icon="arrow-r" data-iconpos="right"></li>';
			$('#memberList').append(list);
			var imgs = "";
			//if user allowed teammates can see his phone number it shows on page
			if (entry['phone'] !== 0) {
				imgs += '<img src="css/img/ic_action_phone_outgoing.png"><img src="css/img/ic_action_dialog.png">';
			}
			//if user allowed teammates can see his email it shows on page
			if (entry['email'] !== 0) {
				imgs += ' <img src="css/img/ic_action_mail.png">';
			}
			var memberbtn = $('<a href="#page-memberdetail"><img src="img/pw_call.png"/><h4>' + entry['nickname'] + '</h4><span class="ui-li-aside">' + imgs + '</span></a>');
			memberbtn.bind('click', function() {
				window.localStorage.setItem('cntactprm', entry['id']);
			});
			$('#list-' + entryIndex).append(memberbtn);
			//refresh unordered list to get jquery theme for dynamically added elements
			$('#memberList').listview('refresh');
		});
	});
}

$('#page-memberdetail').live('pageshow', function(event) {
	isCheater();
	//retrieves same information as teammates list but shows single member information
	$.post(servicelink, "tag=contact&u_id=" + window.localStorage.getItem("sid")).done(function(data, textStatus, jqXHR) {
		data = $.parseJSON(data);
		$('#memberDetails').empty();
		$.map(data['contacts'], function(obj) {
			var html = "";
			if (obj['id'] === window.localStorage.getItem('cntactprm')) {
				$('#memberDetails').append('<h1 align="center">' + obj['firstname'] + ' ' + obj['lastname'] + '</h1>').listview('refresh');
				if (obj['phone'] !== 0) {
					html += '<li><a href="tel:' + obj['phone'] + '"><img src=""/><h4>Cell</h4><p>' + obj['phone'] + '</p><span class="ui-li-aside"><img src="css/img/ic_action_phone_outgoing.png"></span></a></li>';
					html += '<li><a href="sms:' + obj['phone'] + '"><img src=""/><h4>SMS</h4><p>' + obj['phone'] + '</p><span class="ui-li-aside"><img src="css/img/ic_action_dialog.png"></span></a></li>';
				}
				if (obj['email'] !== 0) {
					html += '<li><a href="mailto:' + obj['email'] + '"><img src=""/><h4>E-mail</h4><p>' + obj['email'] + '</p><span class="ui-li-aside"><img src="css/img/ic_action_mail.png"></span></a></li>';
				}
			}
			$('#memberDetails').append(html).listview('refresh');
		});
	});
});

//used for retrieving paramater from url
$.urlParam = function(name) {
	var results = new RegExp('[\\?&]' + name + '=([^&#]*)').exec(window.location.href);
	if (!results) {
		return 0;
	}
	return results[1] || 0;
};

$('#page-tasklist').live('pageshow', function(event) {
	isCheater();
	//all available tasks loaded for a user
	getTaskList();
	$('#tskrfsh').click(function() {
		getTaskList();
	});
});

function getTaskList() {
	//ask service to return all task for a user in a game, by providing game id and user id
	$.post(servicelink, "tag=gettasklist&g_id=" + window.localStorage.getItem("gameid") + "&u_id=" + window.localStorage.getItem("sid")).done(function(data, textStatus, jqXHR) {
		$('#taskList').empty();
		data = $.parseJSON(data);
		var loc = "";
		$.each(data['tasks'], function(entryIndex, entry) {
			if (entry['status'] == 2) loc = "#";
			else loc = "#";
			var html = '<li id="tsk' + entryIndex + '"></li>';
			$('#taskList').append(html);
			var btn = $('<a href="' + loc + '"><img src="css/img/ic_action_' + entry['status'] + '.png"><h4>' + entry['taskname'] + '</h4><p>Required Task: ' + entry['requiredtsk'] + '</p></a>');
			btn.bind('click', function() {
				var found = false;
				$.map(data['tasks'], function(obj) {
					if (obj['taskid'] == entry['requiredtsk'] && obj['status'] != 2) {
						fadingMsg('You haven\'t done "' + obj['taskname'] + '" task yet.');
						found = true;
					}
				});
				if (!found && entry['status'] != 2) {
					window.localStorage.setItem("temptaskid", entry['taskid']);
					$.mobile.changePage("#page-taskaccept", {
						transition: "slide",
						reverse: false,
						changeHash: false
					});
				}
			});
			$('#tsk' + entryIndex).append(btn);
			$('#taskList').listview('refresh');
		});
	});
}

//after selecting task from task list they are redirected to this page and this page shows basic information of the task that they are about to accept
$('#page-taskaccept').live('pageshow', function(event) {
	isCheater();
	$('#tskacceptnav').show();
	var tskid = window.localStorage.getItem("temptaskid");
	window.localStorage.removeItem("temptaskid");

	//ask task information and load
	$.post(servicelink, "tag=taskdetail&t_id=" + tskid).done(function(data, textStatus, jqXHR) {
		data = $.parseJSON(data);
		$('#txttaskname').html(data['taskname']);
		$('#txtcampusname').html(data['campus']);
		$('#txtquestions').html(data['questions']);
		$('#txtscript').html(data['numberofdic']);
		$('#txtaudio').html(data['numberofdic']);
		$('#txtimages').html(data['numberofdic']);
		tskloc = new google.maps.LatLng(data['campuslat'], data['campuslng']);
		$('#task_map_canvas').gmap({
			'center': data['campuslat'] + "," + data['campuslng']
		});
		$('#task_map_canvas').gmap('addMarker', {
			'position': tskloc,
			animation: google.maps.Animation.DROP,
			'bounds': true
		});
		$('#task_map_canvas').gmap('option', 'zoom', 13);
	});

	//accept button will insert all information to progress table and on successfull insertion will return all information are returned and saved to localstorage
	$('#accept_task').click(function() {
		$.post(servicelink, "tag=accepttask&t_id=" + window.localStorage.getItem("teamid") + "&tsk_id=" + tskid + "&u_id=" + window.localStorage.getItem("sid") + "&status=1").done(function(data, textStatus, jqXHR) {
			var x = $.parseJSON(data);
			saveuserInfo(x.userinfo);
			if (x.hasOwnProperty('scripts')) {
				saveuserScript(x.scripts);
				saveuserQuestions(x.questions);
			}
			//fadingMsg("You have accepted the task. Good luck!");
			//window.localStorage.setItem("reload","true");reloadPage:true
			//$.mobile.changePage( "#page-main", { transition: "slide"} );
			$('#tskacceptnav').hide();
			window.localStorage.setItem("reload", "true");
			confirmDialog("info", "Now, you will be redirected to the page where you can listen and read task directions.<br/><div align='center'><b>Good Luck!</b></div>", "#page-download");
		});
	});

}).live('pagehide', function() {
	$('#task_map_canvas').gmap('clear', 'markers');
});

//this page is actually called taskdictionary where we are showing all audio picture and description of a task  and scripts for this page is inside audioplay.js
$('#page-download').live('pageinit', function() {
	$('#goquestions').click(function() {
		if (window.localStorage.getItem('secretidfound')) {
			$.mobile.changePage("#page-questionanswer", {
				transition: "slide"
			});
		} else {
			confirmDialog("Task Key", "You will be redirected to the page where you can either enter the <b>Secret Key</b> or scan the <b>QR Code</b>", "#page-scananswer", true);
		}
	});
}).live('pageshow', function(event) {
	isCheater();
	isTaskSelected();
	//initilizepage();
	for (var i = 0; i < window.localStorage.getItem("numberofscript"); i++) {
		if (i === 0) $('#imgul').append('<li style="display:block"><div><img src="img/' + window.localStorage.getItem(("image" + i)) + '" width="320px" height="180px"/></div></li>');
		else $('#imgul').append('<li style="display:none"><div><img src="img/' + window.localStorage.getItem(("image" + i)) + '" width="320px" height="180px"/></div></li>');
	}
	$('#audioinfo').html(window.localStorage.getItem("audio0"));
	$('#desc').html(window.localStorage.getItem("scripttext0"));
	var audname = window.localStorage.getItem("audio0");
	audname = audname.substring(0, audname.length - 4);
	$('<source id="typeacc" src="http://moshapp.kaldim.com/pages/accs/' + audname + '.m4a"><source id="typeogg" src="http://moshapp.kaldim.com/pages/ogg/' + audname + '.ogg"><source id="typemp3" src="http://moshapp.kaldim.com/pages/mp3s/' + audname + '.mp3"><source id="typewav" src="http://moshapp.kaldim.com/pages/wavs/' + audname + '.wav">').appendTo('#moshplayer');
	var slider = new Swipe(document.getElementById('imgslider'), {
		callback: function(e, pos) {
			var i = bullets.length;
			while (i--) {
				bullets[i].className = ' ';
			}
			bullets[pos].className = 'on';
			$('#audioinfo').html(window.localStorage.getItem(("audio" + pos)));
			$('#desc').html(window.localStorage.getItem(("scripttext") + pos));
			audname = window.localStorage.getItem(("audio" + pos));
			audname = audname.substring(0, audname.length - 4);
			$('#moshplayer')[0].pause();
			$('#typeacc').attr('src', 'http://moshapp.kaldim.com/pages/accs/' + audname + '.m4a');
			$('#typemp3').attr('src', 'http://moshapp.kaldim.com/pages/mp3s/' + audname + '.mp3');
			$('#typeogg').attr('src', 'http://moshapp.kaldim.com/pages/ogg/' + audname + '.ogg');
			$('#typewav').attr('src', 'http://moshapp.kaldim.com/pages/ogg/' + audname + '.wav');
			$('#stop').trigger('click');
		}
	}),
		bullets = document.getElementById('position').getElementsByTagName('em');

	$('#prev').click(function() {
		slider.prev();
		return false;
	});

	$('#next').click(function() {
		slider.next();
		return false;
	});

	for (i = 0; i < numberofimages; i++) {
		if (i === 0) $('#position').append('<em class="on">&bull;</em>');
		else $('#position').append('<em>&bull;</em>');
	}

	var play_btn = $('#play');
	var stop_btn = $('#stop');

	play_btn.click(function() {
		if ($('#play .ui-btn-text').html() == 'Play') {
			$('#moshplayer')[0].play();
			$('#slider').attr('max', Math.round($('#moshplayer')[0].duration));
			$('#slider').slider('refresh');
			$('#play .ui-btn-text').html('Pause');
			$('#play .ui-icon').addClass('ui-icon-audio-pause').removeClass('ui-icon-audio-play');
		} else {
			$('#moshplayer')[0].pause();
			$('#play .ui-btn-text').html('Play');
			$('#play .ui-icon').addClass('ui-icon-audio-play').removeClass('ui-icon-audio-pause');
		}
	});

	stop_btn.click(function() {
		$('#moshplayer')[0].load();
		$('#play .ui-btn-text').html('Play');
		$('#play .ui-icon').addClass('ui-icon-audio-play').removeClass('ui-icon-audio-pause');
		$('#slider').val(0);
		$('#slider').slider('refresh');
	});
}).live('pagehide', function(e) {
	slider = "";
	$('#imgul').empty();
	$('#position').empty();
});

function updateslider() {
	$('#slider').val(Math.round($('#moshplayer')[0].currentTime));
	$('#slider').slider('refresh');
}

//leader board team list will return all teams that are in game will be loaded
$('#page-teamsList').live('pageshow', function(event) {
	getTeamsList();

	$('#tskrfsh').click(function() {
		getTeamsList();
	});
});

function getTeamsList() {
	$.post(servicelink, "tag=teams").done(function(data, textStatus, jqXHR) {
		data = $.parseJSON(data);
		$('#teamsList').empty();
		$.each(data['teams'], function(entryIndex, entry) {
			var html = '<li id="tms' + entryIndex + '" data-icon="arrow-r" data-iconpos="right"></li>';
			$('#teamsList').append(html);
			var tmbtn = $('<a href="#page-teammemberdetail"><img src="img/teams.png"><h4>' + entry['tname'] + '</h4><p>Time spent ' + toHHMMSS(entry['time_spent']) + ' sec</p><span class="ui-li-count">Rank ' + (entryIndex + 1) + '</span></a>');
			tmbtn.bind('click', function() {
				window.localStorage.setItem('tmsprm', entry['id']);
			});
			$('#tms' + entryIndex).append(tmbtn);
			$('#teamsList').listview('refresh');
		});
	});
}

//on leaderboard when they select team they will redirected to this page where they will see all members of that team information
$('#page-teammemberdetail').live('pageshow', function(event) {
	$.post(servicelink, "tag=teammembers&t_id=" + window.localStorage.getItem('tmsprm')).done(function(data, textStatus, jqXHR) {
		data = $.parseJSON(data);
		$('#teamMembers').empty();
		$('#teamMembers').append('<h1  align="center">' + data['tname'] + '</h1>');
		$.each(data['teammembers'], function(entryIndex, entry) {
			var html = '<li id="mmbs' + entryIndex + '" data-icon="arrow-r" data-iconpos="right"></li>';
			$('#teamMembers').append(html);
			var mmberbtn = $('<a href="#page-usertaskdetail?id=' + entry['id'] + '"><img src="css/img/ic_action_user.png"><h4>' + entry['nickname'] + '</h4><p>Time spent ' + toHHMMSS(entry['time_spent']) + ' sec</p></a>');
			mmberbtn.bind('click', function() {
				window.localStorage.setItem('tmsmmbrprm', entry['id']);
			});
			$('#mmbs' + entryIndex).append(mmberbtn);
			$('#teamMembers').listview('refresh');
		});
	});
});

//leaderboard on selection of team member this page is loaded and shows selected users progress, task list and if they have done any task
$('#page-usertaskdetail').live('pageshow', function(event) {
	$.post(servicelink, "tag=teammemberdetails&u_id=" + window.localStorage.getItem('tmsmmbrprm')).done(function(data, textStatus, jqXHR) {
		data = $.parseJSON(data);
		$('#userDetails').empty();
		$('.member-summary h1').html(data['nickname']);
		$('#secondinfo').html(data['tname'] + ' Team Member');
		$.each(data['tasks'], function(entryIndex, entry) {
			var html = '<li><a href="#"><img src="css/img/ic_action_' + entry['taskstatus'] + '.png"><h4>' + entry['taskname'] + '</h4><p>Time spent ' + toHHMMSS(entry['time_spent']) + ' sec</p></a></li>';
			$('#userDetails').append(html).listview('refresh');
		});
	});
});

function toHHMMSS(sec) {
	var sec_numb = parseInt(sec, 10);
	var hours = Math.floor(sec_numb / 3600);
	var minutes = Math.floor((sec_numb - (hours * 3600)) / 60);
	var seconds = sec_numb - (hours * 3600) - (minutes * 60);

	if (hours < 10) {
		hours = "0" + hours;
	}
	if (minutes < 10) {
		minutes = "0" + minutes;
	}
	if (seconds < 10) {
		seconds = "0" + seconds;
	}
	var time = hours + ':' + minutes + ':' + seconds;
	return time;
}

//any error or notification are sent to this function which will be overlay to screen and shows message
function fadingMsg(locMsg, bgcolor, textcolor, delayTime) {
	var dtime = delayTime ? delayTime : 2800;
	var bgcl = bgcolor ? bgcolor : '#bbf3db';
	var txtcl = textcolor ? textcolor : '#FAFAFA';
	$("<div class='ui-overlay-shadow ui-body-a ui-corner-all dkgreen' id='fading_msg'>" + locMsg + "</div>").css({
		"position": "absolute",
		"display": "block",
		"z-index": 99999999,
		"opacity": 0.99,
		"color": txtcl,
		"background-color": bgcl
	}).appendTo($.mobile.pageContainer).delay(dtime).fadeOut(1400);
}

//currently this function is only map page when they click show my location this overlay goes over screen and shows loading screen
function showloading() {
	$("<div class='ui-overlay-shadow ui-body-a ui-corner-all dkgreen' id='loading' align='center'>" + "<img src='img/ajax-loader.gif' width='100px' height='100px' title='loading' alt='loading...'/><br/>loading.." + "</div>").css({
		"position": "absolute",
		"top": "60%",
		"width": "100%",
		"display": "block",
		"z-index": 99999999,
		"opacity": 0.99,
		"background-color": "#bbf3db"
	}).appendTo($.mobile.pageContainer);
}

function hideloading() {
	$("#loading").remove();
}

function confirmDialog(header, message, redirectpage, headerclose) {
	header = header ? header : 'Error';
	message = message ? message : 'Please contact the facilitator.';
	redirectpage = redirectpage ? redirectpage : '#page-main';
	headerclose = headerclose ? headerclose : false;
	$('<div>').simpledialog2({
		mode: 'button',
		headerText: header,
		headerClose: headerclose,
		buttonPrompt: message,
		buttons: {
			'OK': {
				click: function() {
					if (redirectpage == "#page-main") {
						window.localStorage.removeItem("reload");
						window.location.reload(true);
					} else {
						$.mobile.changePage(redirectpage, {
							transition: "slide"
						});
					}
				}
			}
		}
	});
}
