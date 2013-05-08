var instanse = false;
var state;
var url= "http://mosh.kaldim.com/process.php";
function Chat () {
    this.update = updateChat;
    this.send = sendChat;
	this.getState = getStateOfChat;
}
function getStateOfChat(){
	if(!instanse){
		 instanse = true;
		 $.ajax({
			   type: "POST",
			   url: url,
			   data: { 'function': 'getState'},
			   dataType: "json",
			   success: function(data){
				   state = data.state;
				   instanse = false;
			   },
			});
	}	 
}
function updateChat(){
	 if(!instanse){
		 instanse = true;
	     $.ajax({
			   type: "POST",
			   url: url,
			   data: {  'function': 'update','state': state},
			   dataType: "json",
			   success: function(data){
				   if(data.text){
						for (var i = 0; i < data.text.length; i++) {
                            $('#chatscreen').append($("<p>"+ data.text[i] +"</p>"));
                        }								  
				   }
				   $('#chatscreen').animate({ scrollTop: $("#chatscreen")[0].scrollHeight });
				   instanse = false;
				   state = data.state;
			   },
			});
	 }
	 else {
		 setTimeout(updateChat, 1500);
	 }
}
function sendChat(message, nickname)
{       
    updateChat();
     $.ajax({
		   type: "POST",
		   url: url,
		   data: {  'function': 'send','message': message,'nickname': nickname},
		   dataType: "json",
		   success: function(data){
			   updateChat();
		   },
		});
}
