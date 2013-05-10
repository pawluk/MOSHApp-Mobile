/* Audio player */
var audio = null;
var audioTimer = null;
var timerDur = null;
var pausePos = 0;
var playing=false;

/* play audio file */
 function loadAudio(file){
	 var loctofl= host+'pages/mp3s/'+file+'.mp3';
	 audio = new Media(loctofl, function(){ // success callback
    	 console.log("playAudio():Audio Success");
     }, function(error){ // error callback
    	 alert('code: '    + error.code    + '\n' + 
          	   'message: ' + error.message + '\n');
     },function(status){
    	 if(status==2){
    		 hideloading();
    		 playing=true;
    	 }else if(status==1){
    		 showloading();
    	 	 playing=false;
    	 }else{
    		 hideloading();
    		 playing=false;
    	 }
    	 if(status==4){
    		 clearInterval(timerDur);clearInterval(audioTimer);
    		$('#play .ui-btn-text').html('Play');
 			$('#play .ui-icon').addClass('ui-icon-audio-play').removeClass('ui-icon-audio-pause');
    	 }
     });
}
 
/* play audio */
 function playAudio(){
	 if(!audio) return false;
	 playing=true;
	 var counter = 0;
	 timerDur = setInterval(function() {
         counter = counter + 100;
         if (counter > 2000) {
             clearInterval(timerDur);
         }
         var dur = audio.getDuration();
         if (dur > 0) {
             clearInterval(timerDur);
    	     $('#slider').attr( 'max', Math.round(dur));
    	     $('#slider').slider('refresh');
         }
    }, 100);

    
     audio.play();

     if (audioTimer == null) {
         audioTimer = setInterval(function() {
             audio.getCurrentPosition(
                 function(position) { // get position success
                     if (position > -1) {
                         setAudioPosition(position);
                     }
                 }, function(e) { // get position error
                     console.log("Error getting pos=" + e);
                 }
             );
         }, 1000);
     }
 }


/* pause audio */
 function pauseAudio() {
	if(playing){
		 playing=false;
	     if (audio) {
	    	 audio.pause();
	     }
	}
 }

 

/* stop audio */
 function stopAudio() {
	 if(!playing) return false;
	 playing=false;
    if (audio) {
         audio.stop();
         //audio.release();
     }
     clearInterval(audioTimer);
     audioTimer = null;
     pausePos = 0;
     $('#slider').val(position);
     $('#slider').slider('refresh');
}

 /* set audio position */
 function setAudioPosition(position) {
	 pausePos = position;
	 position = Math.round(position);
     $('#slider').val(position);
     $('#slider').slider('refresh');
}