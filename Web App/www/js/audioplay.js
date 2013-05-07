function initilizepage() {
	var taskdic = [{
		image: "noimage.png",
		audio: "sample.mp3",
		desc: "First, Will be the text version of audio"
	}, {
		image: "noimage.png",
		audio: "sample1.mp3",
		desc: "Second, Will be the text version of audio"
	}, {
		image: "noimage.png",
		audio: "sample2.mp3",
		desc: "Third, Will be the text version of audio"
	}];
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
			//will added for native version
			//stopAudio();
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
			$('#moshplayer')[0].load();
			$('#play .ui-btn-text').html('Play');
			$('#play .ui-icon').addClass('ui-icon-audio-play').removeClass('ui-icon-audio-pause');
		}
	}),
		bullets = document.getElementById('position').getElementsByTagName('em');

	$('#prev').click(function() {
		//will added for native version
		//stopAudio();
		slider.prev();
		return false;
	});

	$('#next').click(function() {
		//will added for native version
		//stopAudio();
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
		//will added for native version
		//playAudio(audname);
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
		// $(this).button('disable');
	});

	stop_btn.click(function() {
		//if(playing){
		//will added for native version
		//stopAudio();
		// reset slider
		$('#moshplayer')[0].load();
		$('#play .ui-btn-text').html('Play');
		$('#play .ui-icon').addClass('ui-icon-audio-play').removeClass('ui-icon-audio-pause');
		//$('#slider').val(0);
		//$('#slider').slider('refresh');
		//}
	});

}

function updateslider() {
	$('#slider').val(Math.round($('#moshplayer')[0].currentTime));
	$('#slider').slider('refresh');
}

//will added for native version
// function getPhoneGapPath() {

// var path = window.location.pathname;
// path = path.substr( path, path.length - 11 );
// return 'file://' + path;

// };



// /* Audio player */
// var audio = null;
// var audioTimer = null;
// var pausePos = 0;
//var playing=false;

// /* play audio file */
// function playAudio(file){
// var loctofl=getPhoneGapPath() + file;
// audio = new Media(loctofl, function(){ // success callback
// $('#play').button('enable');
// console.log("playAudio():Audio Success");
// }, function(error){ // error callback
// alert('code: '    + error.code    + '\n' +
// 'message: ' + error.message + '\n');
// },function(status){
// if(status==2)
// playing=true;
// else
// playing=false;
// });


// var counter = 0;
// var timerDur = setInterval(function() {
// counter = counter + 100;
// if (counter > 2000) {
// clearInterval(timerDur);
// }
// var dur = audio.getDuration();
// if (dur > 0) {
// clearInterval(timerDur);
// $('#slider').attr( 'max', Math.round(dur));
// $('#slider').slider('refresh');
// }
// }, 100);


// audio.play();

// audio.seekTo(pausePos*1000);

// if (audioTimer == null) {
// audioTimer = setInterval(function() {
// audio.getCurrentPosition(
// function(position) { // get position success
// if (position > -1) {
// setAudioPosition(position);
// }
// }, function(e) { // get position error
// console.log("Error getting pos=" + e);
// }
// );
// }, 1000);
// }
// }

// /* stop audio */
// function stopAudio() {
// if (audio) {
// audio.stop();
// audio.release();
// }
// clearInterval(audioTimer);
// audioTimer = null;
// pausePos = 0;
// $('#slider').val(position);
// $('#slider').slider('refresh');
// }

// /* set audio position */
// function setAudioPosition(position) {
// pausePos = position;
// position = Math.round(position);
// $('#slider').val(position);
// $('#slider').slider('refresh');
// }
