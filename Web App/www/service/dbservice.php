<?php

if (isset($_POST['tag']) && $_POST['tag'] != '') {
    $tag = $_POST['tag'];
	
	require_once 'include/dbfunctions.php';
    $db = new DB_Functions();
	    // response Array
    $response = array("tag" => $tag, "success" => 0, "error" => 0);
	    if ($tag == 'login' && (isset($_POST['userName']) && $_POST['userName'] != '') && (isset($_POST['password']) && $_POST['password'] != '')) {
			// Request type is check Login
			$username = $_POST['userName'];
			$password = $_POST['password'];
			login($username, $password);
        }else if($tag=='contact' && (isset($_POST['u_id']) && $_POST['u_id'] != '') ){
			$u_id=$_POST['u_id'];
			getContact($u_id);
		
		}else if($tag=='teams'){
			getTeams();		
		}else if($tag=='teammembers' && (isset($_POST['t_id']) && $_POST['t_id'] != '')){
			$t_id=$_POST['t_id'];
			getTeammember($t_id);		
		}else if($tag=='teammemberdetails' && (isset($_POST['u_id']) && $_POST['u_id'] != '')){
			$u_id=$_POST['u_id'];
			getTeammemberdetail($u_id);
		}else if($tag=='userinfo' && (isset($_POST['u_id']) && $_POST['u_id'] != '')){
			$u_id=$_POST['u_id'];
			getUserTaskInfo($u_id);
		}else if($tag=='gettasklist' && (isset($_POST['g_id']) && $_POST['g_id'] != '')&& (isset($_POST['u_id']) && $_POST['u_id'] != '')){
			$g_id=$_POST['g_id'];
			$u_id=$_POST['u_id'];
			getTasklist($g_id,$u_id);
		}else if($tag=='taskdetail' && (isset($_POST['t_id']) && $_POST['t_id'] != '')){
			$t_id=$_POST['t_id'];
			getTaskDetail($t_id);
		}else if($tag=='accepttask' && (isset($_POST['t_id']) && $_POST['t_id'] != '') && (isset($_POST['tsk_id']) && $_POST['tsk_id'] != '') && (isset($_POST['u_id']) && $_POST['u_id'] != '')){
			$t_id=$_POST['t_id'];
			$tsk_id=$_POST['tsk_id'];
			$u_id=$_POST['u_id'];
			$status=$_POST['status'];
			$result = acceptTask($t_id,$tsk_id,$u_id,$status);
			if($result)
			getUserTaskInfo($u_id);
		}else if($tag=='updateuseroption' && (isset($_POST['u_id']) && $_POST['u_id'] != '') && (isset($_POST['pstatus']) && $_POST['pstatus'] != '') && (isset($_POST['estatus']) && $_POST['estatus'] != '')){
			$u_id=$_POST['u_id'];
			$pstatus=$_POST['pstatus'];
			$estatus=$_POST['estatus'];
			updateUseroption($u_id,$pstatus,$estatus);
		}else if($tag=='adresponse' && (isset($_POST['u_id']) && $_POST['u_id'] != '') && isset($_POST['t_id']) && isset($_POST['tsk_id']) && isset($_POST['q_id']) && isset($_POST['response']) && isset($_POST['location'])){
			$t_id=$_POST['t_id'];
			$tsk_id=$_POST['tsk_id'];
			$u_id=$_POST['u_id'];
			$q_id=$_POST['q_id'];
			$respons=$_POST['response'];
			$location=$_POST['location'];
			$result = addResponse($t_id,$u_id,$tsk_id,$q_id,$respons,$location);
			if($result)
			getUserTaskInfo($u_id);			
		}	


} else {
				$response["error"] = 1;
				$response["error_msg"] = "Access Denied!";
				echo json_encode($response);
}

function login($username, $password){
			global $db;
			global $response;
			$user = $db->login($username, $password);
			if ($user != false) {
				$response["success"] = 1;
				$response["u_id"] = $user["u_id"];
				$response["u_nickname"]=$user["nickname"];
				echo json_encode($response);
			} else {
				$response["error"] = 1;
				$response["error_msg"] = "Username or Password does not match!";
				echo json_encode($response);
			}
}

function getContact($u_id){
			global $db;
			global $response;
			$contacts = $db->getContact($u_id);
			if ($contacts != false) {
				$response["success"] = 1;
				while($row = mysql_fetch_array($contacts))
					{
						$response['contacts'][]=array("id"=>$row["u_id"],"nickname"=>$row["u_nickname"],"firstname"=>$row["u_fname"],"lastname"=>$row["u_lastname"],"email"=>$row['e_vsbl_tm']==1?$row["u_email"]:$row['e_vsbl_tm'],"phone"=>$row['p_vsbl_tm']==1?$row["u_phone"]:$row['p_vsbl_tm']);
						//$response['users']=$contactresponse;
				}
				echo json_encode($response);
				
			}else{
				$response["error"] = 1;
				$response["error_msg"] = "No Teams or teammates found";
				echo json_encode($response);
			}
}

function getTeams(){
			global $db;
			$teams = $db->getTeams();
			if($teams !=false){
				$response["success"]=1;
				$i=0;
				$team=array();
				while($row = mysql_fetch_array($teams)){
					if($i==0)
					$team = array("id"=>$row["t_id"],"tname"=>$row["t_name"],"time_spent"=>is_null($row["time_spent"])?0:$row["time_spent"]);
					else{
						if($team["id"]==$row["t_id"]){
						$team["time_spent"]=$team["time_spent"]+$row["time_spent"];
						}else{
						$response['teams'][]=$team;
						$team = array("id"=>$row["t_id"],"tname"=>$row["t_name"],"time_spent"=>is_null($row["time_spent"])?0:$row["time_spent"]);
						}
					}
					$i++;
				}
				$response['teams'][]=$team;
				for($tm=0;$tm<sizeof($response['teams']);$tm++)
				{
					for($tmy=0;$tmy<sizeof($response['teams']);$tmy++)
					{
					  if($response['teams'][$tm]['time_spent']>$response['teams'][$tmy]['time_spent']){
					  $team=$response['teams'][$tm];
					  $response['teams'][$tm]=$response['teams'][$tmy];
					  $response['teams'][$tmy]= $team;
					  }
					}
				
				}
				for($tm=0;$tm<sizeof($response['teams']);$tm++)
				{
					for($tmy=0;$tmy<sizeof($response['teams']);$tmy++)
					{
					 if($response['teams'][$tm]['time_spent']!=0){
					  if($response['teams'][$tm]['time_spent']<$response['teams'][$tmy]['time_spent']){
					  $team=$response['teams'][$tm];
					  $response['teams'][$tm]=$response['teams'][$tmy];
					  $response['teams'][$tmy]= $team;
					  }
					  }
					}
				
				}
				echo json_encode($response);
			}else{
				$response["error"] = 1;
				$response["error_msg"] = "No Teams found";
				echo json_encode($response);
			}
}

function getTeammember($t_id){
			global $db;
			global $response;
			$teammembers = $db->getTeamMembers($t_id);
			if($teammembers !=false){
				$response["success"]=1;
				$i=0;
				while($row = mysql_fetch_array($teammembers)){
					if($i==0)
						$response['tname']=$row["t_name"];
					$response['teammembers'][]=array("id"=>$row["u_id"],"nickname"=>$row["u_nickname"],"time_spent"=>is_null($row["time_spent"])?0:$row["time_spent"]);
					$i++;
				}
				echo json_encode($response);
			}else{
				$response["error"] = 1;
				$response["error_msg"] = "No Team Members found";
				echo json_encode($response);
			}
}


function getTeammemberdetail($u_id){
			global $db;
			global $response;
			$teammemberdetails = $db->getTeamMemberDetails($u_id);
			if($teammemberdetails !=false){
				$response["success"]=1;
				$i=0;
				while($row = mysql_fetch_array($teammemberdetails)){
					if($i==0){
						$response['nickname']=$row["u_nickname"];
						$response['tname']=$row["t_name"];
						}
					$response['tasks'][]=array("taskname"=>$row["tsk_name"],"taskstatus"=>is_null($row["status"])?0:$row["status"],"time_spent"=>is_null($row["time_spent"])?0:$row["time_spent"]);
					$i++;
				}
				echo json_encode($response);
			}else{
				$response["error"] = 1;
				$response["error_msg"] = "No Team Members found";
				echo json_encode($response);
			}
}

function getUserTaskInfo($u_id){
			global $db;
			global $response;
			$loggeduserinfo = $db->getLoggedinuserInfo($u_id);
			if($loggeduserinfo !=false){
			$number = mysql_num_rows($loggeduserinfo);
				$response["success"]=1;
				$count=1;
				$first=false;
				$i=0;
				$prvdid=0;
				$prvqid="";
				while($row = mysql_fetch_array($loggeduserinfo)){
				if($row['status']==1)
					$first=true;
				if($first){	
					if($i==0){
						if($row['status']!=null){
							$response['userinfo']=array("phoneoption"=>$row["p_vsbl_tm"],"emailoption"=>$row["e_vsbl_tm"],"teamid"=>$row["t_id"],"teamname"=>$row["t_name"],"gameid"=>$row["g_id"],"gamestart"=>$row['start_time'],"gamefinish"=>$row['finis_time'],"taskid"=>$row["tsk_id"],"tasksecret"=>$row["secret_id"],"taskname"=>$row["tsk_name"],"campusid"=>$row["c_id"],"campusname"=>$row["c_name"],"campuslat"=>$row["c_lat"],"campuslng"=>$row["c_lng"]);	
							$response['scripts'][]=array("dictionaryid"=>$row["td_id"],"text"=>$row["direction"],"audio"=>$row["audio"],"image"=>$row["image"],"lat"=>$row["td_lat"],"lng"=>$row["td_lng"]);
							$answer="";
							if($row["q_status"]==1){
								if($row['answer'])
								$answer=$row['answer'];
								else
								$answer="No answer assigned";
							}else
							$answer=0;
							$response['questions'][]=array("questionid"=>$row["q_id"],"questiontype"=>$row["q_typ_id"],"question"=>$row["q_text"],"questionstatus"=>$row["q_status"]?$row["q_status"]:0,"answer"=>$answer);
						}else{
							if($row['g_id']!=null)
								$response['userinfo']=array("phoneoption"=>$row["p_vsbl_tm"],"emailoption"=>$row["e_vsbl_tm"],"teamid"=>$row["t_id"],"teamname"=>$row["t_name"],"gameid"=>$row["g_id"],"gamestart"=>$row['start_time'],"gamefinish"=>$row['finis_time']);
							else
								$response['userinfo']=array("phoneoption"=>$row["p_vsbl_tm"],"emailoption"=>$row["e_vsbl_tm"]);
						}
					}else{
						if($row['status']!=null){
							if($prvdid != $row["td_id"])
							$response['scripts'][]=array("dictionaryid"=>$row["td_id"],"text"=>$row["direction"],"audio"=>$row["audio"],"image"=>$row["image"],"lat"=>$row["td_lat"],"lng"=>$row["td_lng"]);
							
							$qsts = explode('&',$prvqid);
							$found=false;
							for($q=0;$q<count($qsts);$q++){
								if($qsts[$q]==$row["q_id"]){
									$found=true;
									break;
									}
							}
							if(!$found){
							$answer="";
							if($row["q_status"]==1){
								if($row['answer'])
								$answer=$row['answer'];
								else
								$answer="No answer assigned";
							}else
							$answer=0;
							$response['questions'][]=array("questionid"=>$row["q_id"],"questiontype"=>$row["q_typ_id"],"question"=>$row["q_text"],"questionstatus"=>$row["q_status"]?$row["q_status"]:0,"answer"=>$answer);
							}
						}
					}
					if($row['status']!=null){
					$prvdid=$row["td_id"];
					$prvqid.=$row["q_id"].'&';
					}
					$i++;
					}
					$count++;
					if($number==$count && !$first){
							if($row['g_id']!=null)
								$response['userinfo']=array("phoneoption"=>$row["p_vsbl_tm"],"emailoption"=>$row["e_vsbl_tm"],"teamid"=>$row["t_id"],"teamname"=>$row["t_name"],"gameid"=>$row["g_id"],"gamestart"=>$row['start_time'],"gamefinish"=>$row['finis_time']);
							else
								$response['userinfo']=array("phoneoption"=>$row["p_vsbl_tm"],"emailoption"=>$row["e_vsbl_tm"]);
					}
				}
				echo json_encode($response);
			}else{
				$response["error"] = 1;
				$response["error_msg"] = "Error accoured on retrieving information";
				echo json_encode($response);
			}
}

function getTasklist($g_id,$u_id){
			global $db;
			global $response;
			$tasklist = $db->getAllavailabletasks($g_id,$u_id);
			if($tasklist !=false){
				$response["success"]=1;
				while($row = mysql_fetch_array($tasklist)){
					$response['tasks'][]=array("requiredtsk"=>$row['prv_tsk_id']?$row['prv_tsk_id']:'None',"taskid"=>$row["tsk_id"],"status"=>$row['status']?$row['status']:0,"taskname"=>$row["tsk_name"],"campusid"=>$row["c_id"],"campusname"=>$row["c_name"],"campuslat"=>$row["c_lat"],"campuslng"=>$row["c_lng"]);
				}
				echo json_encode($response);
			}else{
				$response["error"] = 1;
				$response["error_msg"] = "No tasks found";
				echo json_encode($response);
			}
}

function getTaskDetail($t_id){
			global $db;
			global $response;
			$taskdetail = $db->getTaskDetail($t_id);
			if($taskdetail !=false){
				$response["success"]=1;
				$number = mysql_num_rows($taskdetail);
				$count=1;
				$sumquest=0;
				while($row = mysql_fetch_array($taskdetail)){
				$sumquest+=$row["questions"];
				$count++;
				if($count==$number)
					$response['taskname']=$row['tsk_name'];$response['campus']=$row["c_name"];$response['campuslat']=$row['c_lat'];$response['campuslng']=$row["c_lng"];$response['numberofdic']=$number?$number:0;$response['questions']=$sumquest;
				}
				echo json_encode($response);
			}else{
				$response["error"] = 1;
				$response["error_msg"] = "Error accoured on retrieving task detail";
				echo json_encode($response);
			}
}

function acceptTask($t_id,$tsk_id,$u_id,$status){
			global $db;
			global $response;
			$accepttask = $db->acceptTask($t_id,$tsk_id,$u_id,$status);
			if($accepttask !=false){
				return true;
			}else{
				$response["error"] = 1;
				$response["error_msg"] = "Error accoured on while accepting task.";
				echo json_encode($response);
			}
}

function updateUseroption($u_id,$pstatus,$estatus){
			global $db;
			global $response;
			$accepttask = $db->updateUserOption($u_id,$pstatus,$estatus);
			if($accepttask !=false){
				$response["success"]=1;
				echo json_encode($response);
			}else{
				$response["error"] = 1;
				$response["error_msg"] = "Error accoured on while changing user options.";
				echo json_encode($response);
			}
}

function addResponse($t_id,$u_id,$tsk_id,$q_id,$respons,$location){
			global $db;
			global $response;
			if(!$respons && $location){
			$respons="My Picture";
			}
			$response['test']=$respons;
			$adresponse = $db->insertResponse($t_id?$t_id:0,$u_id?$u_id:0,$tsk_id?$tsk_id:0,$q_id?$q_id:null,$respons,$location?$location:null);
			if($adresponse==100){
					$response["error"] = 1;
					$response["answered"] = 1;
					$response["error_msg"] = "You have already answere this question";
					echo json_encode($response);
			}else{
				if($adresponse !=false){
					if($adresponse == "gamecomplete"){
						$response["success"]=1;
						$response['gamecomplete']=1;
						echo json_encode($response);
					}else if($adresponse == "taskcomplete"){
						return true;
					}else{
					$response["success"]=1;
					echo json_encode($response);
					}
				}else{
					$response["error"] = 1;
					$response["error_msg"] = "Error accoured on while inserting response.";
					echo json_encode($response);
				}
			}
}

?>