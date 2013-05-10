//    tx.executeSql('INSERT INTO user(id,fname,lname) VALUES (1, "Emrah","Ede")');
//    tx.executeSql('INSERT INTO teaminfo(tid,tname) VALUES (1, "Team 1")');
//    tx.executeSql('INSERT INTO memberinfo(mid,fname,lname,phone,email) VALUES (2, "Andrei", "Alfoso","6472933442","andreialfonso@gmail.com")');
//    tx.executeSql('INSERT INTO memberinfo(mid,fname,lname,phone,email) VALUES (3, "Jordan", "Carera","6472933442","j.carera@gmail.com")');
//    tx.executeSql('INSERT INTO memberinfo(mid,fname,lname,phone,email) VALUES (4, "Jayson", "jj","6472933442","jayson@gmail.com")');
//    tx.executeSql('INSERT INTO task(tskid,tsksecretid,tskquestion,tskdirectiontxt,tsklat,tsklon,cname,clat,clon,tskimg,tskaudio)' +
//        'VALUES (1, 459876, "Question Will be placed here!","Direction will be Placed here",43.675915,-79.410639,"Casa Loma",43.675915,-79.410639,"testimg.png","testaudio.mp3")');
//

function saveSession(sessionId) {
	window.localStorage.setItem("sessionid", sessionId);
}

function sessionId() {
	return window.localStorage.getItem("sessionid");
}

function sessionQueryParams() {
	return 'sessionId=' + encodeURIComponent(sessionId());
}

function isloggedin() {
	if (window.localStorage.getItem("sid") !== null) {
		gomain();
	} else {
		go();
	}
}

function saveuser(sid, name) {
	window.localStorage.setItem("sid", sid);
	window.localStorage.setItem("uname", name);
	window.localStorage.setItem("nickname", name);
}

function saveuserInfo(userinfo) {
	window.localStorage.setItem("phoneoption", userinfo.phoneoption);
	window.localStorage.setItem("emailoption", userinfo.emailoption);
	window.localStorage.setItem("teamid", userinfo.teamid);
	window.localStorage.setItem("teamname", userinfo.teamname);
	window.localStorage.setItem("gameid", userinfo.gameid);
	window.localStorage.setItem("gamestart", userinfo.gamestart);
	window.localStorage.setItem("gamefinish", userinfo.gamefinish);
	if (userinfo.hasOwnProperty('taskid')) {
		window.localStorage.setItem("taskid", userinfo.taskid);
		window.localStorage.setItem("tasksecret", userinfo.tasksecret);
		window.localStorage.setItem("taskname", userinfo.taskname);
		window.localStorage.setItem("campusid", userinfo.campusid);
		window.localStorage.setItem("campusname", userinfo.campusname);
		window.localStorage.setItem("campuslat", userinfo.campuslat);
		window.localStorage.setItem("campuslng", userinfo.campuslng);
	}

}

function saveuserScript(scripts) {
	window.localStorage.setItem("numberofscript", scripts.length);
	$.each(scripts, function(entryIndex, entry) {
		window.localStorage.setItem("dictionaryid" + entryIndex, entry.dictionaryid);
		window.localStorage.setItem("scripttext" + entryIndex, entry.text);
		window.localStorage.setItem("audio" + entryIndex, entry.audio);
		window.localStorage.setItem("image" + entryIndex, entry.image);
		window.localStorage.setItem("scriptlat" + entryIndex, entry.lat);
		window.localStorage.setItem("scriptlng" + entryIndex, entry.lng);
	});
}

function saveuserQuestions(questions) {
	window.localStorage.setItem("numberofquestion", questions.length);
	$.each(questions, function(entryIndex, entry) {
		window.localStorage.setItem("questionid" + entryIndex, entry.questionid);
		window.localStorage.setItem("questiontype" + entryIndex, entry.questiontype);
		window.localStorage.setItem("question" + entryIndex, entry.question);
		window.localStorage.setItem("questionstatus" + entryIndex, entry.questionstatus);
		window.localStorage.setItem("questionanswer" + entryIndex, entry.answer);
	});
}

function removeTaskData() {
	window.localStorage.removeItem('secretidfound');
	window.localStorage.removeItem("taskid");
	window.localStorage.removeItem("tasksecret");
	window.localStorage.removeItem("taskname");
	window.localStorage.removeItem("campusid");
	window.localStorage.removeItem("campusname");
	window.localStorage.removeItem("campuslat");
	window.localStorage.removeItem("campuslng");

	for (var i = 0; i < window.localStorage.removeItem("numberofscript"); i++) {
		window.localStorage.removeItem("dictionaryid" + i);
		window.localStorage.removeItem("scripttext" + i);
		window.localStorage.removeItem("audio" + i);
		window.localStorage.removeItem("image" + i);
		window.localStorage.removeItem("scriptlat" + i);
		window.localStorage.removeItem("scriptlng" + i);
	}
	window.localStorage.removeItem("numberofscript");

	for (i = 0; i < window.localStorage.removeItem("numberofquestion"); i++) {
		window.localStorage.removeItem("questionid" + i);
		window.localStorage.removeItem("questiontype" + i);
		window.localStorage.removeItem("question" + i);
		window.localStorage.removeItem("questionstatus" + i);
		window.localStorage.removeItem("questionanswer" + i);
	}
	window.localStorage.removeItem("numberofquestion");
}



//    window.localStorage.setItem("key", "value");
//    var keyname = window.localStorage.key(i);
//    // keyname is now equal to "key"
//    var value = window.localStorage.getItem("key");
//    // value is now equal to "value"
//    window.localStorage.removeItem("key");
//    window.localStorage.setItem("key2", "value2");
//    window.localStorage.clear();
