<?php
//base64_encode(sha1($pass))
class DB_Functions {

    private $db;
    function __construct() {
        require_once 'include/dbcon.php';
        // connecting to database
        $this->db = new DB_Connect();
        $this->db->connect();
    }
	
	public function login($username,$pass) {
	$query = sprintf('SELECT u_id,(Select u_nickname from users where users.u_id=login.u_id) as nickname from login WHERE login_name = "%s" and login_pass = "%s"',
            mysql_real_escape_string($username),
            mysql_real_escape_string(strtoupper(hash('sha256', $pass))));
        $result = mysql_query($query);
        $no_of_rows = mysql_num_rows($result);
        if ($no_of_rows > 0) {
		$result = mysql_fetch_array($result);
            return $result;
        } else
            return false;
        
    }
	
	public function getContact($u_id) {
	$query = sprintf('SELECT u.u_id,u.u_nickname,u.u_fname,u.u_lastname,u.u_email,u.u_phone,uo.p_vsbl_tm,uo.e_vsbl_tm FROM users u inner join team_user tu ON tu.u_id=u.u_id inner join user_options uo ON uo.u_id=u.u_id WHERE tu.t_id= (Select t_id From team_user where u_id=%s) AND tu.u_id <>%s',
			 mysql_real_escape_string($u_id),
			  mysql_real_escape_string($u_id));
        $result = mysql_query($query);
        $no_of_rows = mysql_num_rows($result);
        if ($no_of_rows > 0) 
            return $result;
        else 
            return false;
    }
	//old version Select t.t_id,t.t_name,(Select Sum(currenttime) From progress p where p.t_id=t.t_id) time_spent FROM teams t Order by time_spent
	public function getTeams(){
		$result = mysql_query('Select t.t_id,t.t_name,(Select count(pc.tsk_id) FROM progress pc WHERE pc.u_id=pf.u_id AND pc.t_id=pf.t_id AND pc.status=2) solved ,TIME_TO_SEC(TIMEDIFF(pf.currenttime,(Select ps.currenttime from progress ps Where ps.u_id= pf.u_id AND ps.tsk_id=pf.tsk_id AND ps.status=1))) time_spent FROM teams t LEFT OUTER JOIN progress pf ON pf.status=2 AND pf.t_id=t.t_id Order By solved,time_spent');
		$no_of_rows = mysql_num_rows($result);
		if($no_of_rows>0)
			return $result;
		else
			return false;
	}
	//old SELECT t.t_name,u.u_id,u.u_nickname,(Select sum(currenttime) from progress p where u.u_id=p.u_id) time_spent FROM team_user tu INNER JOIN users u ON u.u_id = tu.u_id INNER JOIN teams t on t.t_id=tu.t_id WHERE tu.t_id=%s Order by time_spent
	public function getTeamMembers($t_id){
		$query = sprintf('SELECT t.t_name,u.u_id,u.u_nickname,(Select SUM(TIME_TO_SEC(TIMEDIFF(pf.currenttime,(Select ps.currenttime from progress ps Where ps.u_id= pf.u_id AND ps.tsk_id=pf.tsk_id AND ps.status=1)))) time_spent FROM progress pf Where pf.status=2 AND pf.u_id=u.u_id) time_spent FROM team_user tu INNER JOIN users u ON u.u_id = tu.u_id INNER JOIN teams t on t.t_id=tu.t_id WHERE tu.t_id=%s Order by time_spent',
			 mysql_real_escape_string($t_id));
        $result = mysql_query($query);
		$no_of_rows = mysql_num_rows($result);
		if($no_of_rows>0)
			return $result;
		else
			return false;
	}
	//old Select u.u_nickname,t.t_name,tsk.tsk_name,(select max(p.status) from progress p where p.tsk_id=tsk.tsk_id AND p.u_id=%s) status,(select sum(p.currenttime) from progress p where p.tsk_id=tsk.tsk_id && p.u_id=%s) time_spent From users u inner join teams t ON t.t_id = (select t_id from team_user where u_id = %s) inner join game_task gt ON gt.g_id = (select g_id from team_game tg where tg.t_id = t.t_id) inner join tasks tsk ON tsk.tsk_id=gt.tsk_id where u.u_id =%s
	public function getTeamMemberDetails($u_id){
		$query = sprintf('Select u.u_nickname,t.t_name,tsk.tsk_name,(select max(p.status) from progress p where p.tsk_id=tsk.tsk_id AND p.u_id=%s) status,(Select TIME_TO_SEC(TIMEDIFF(pf.currenttime,(Select ps.currenttime from progress ps Where ps.u_id= pf.u_id AND ps.tsk_id=pf.tsk_id AND ps.status=1))) time_spent FROM progress pf Where pf.status=2 AND pf.tsk_id=tsk.tsk_id AND pf.u_id=%s ) time_spent From users u inner join teams t ON t.t_id = (select t_id from team_user where u_id = %s) inner join game_task gt ON gt.g_id = (select g_id from team_game tg where tg.t_id = t.t_id) inner join tasks tsk ON tsk.tsk_id=gt.tsk_id where u.u_id =%s',
			 mysql_real_escape_string($u_id),
			  mysql_real_escape_string($u_id),
			   mysql_real_escape_string($u_id),
			  mysql_real_escape_string($u_id));
        $result = mysql_query($query);
		$no_of_rows = mysql_num_rows($result);
		if($no_of_rows>0)
			return $result;
		else
			return false;
	}
	
// This part can be used to retrieve task from database directly	 currently not used
	public function getQuestion($qs_id){
			$query = sprintf('Select q_typ_id,q_text FROM questions where q_secret_id ="%s"',
			 mysql_real_escape_string($qs_id));
        $result = mysql_query($query);
		$no_of_rows = mysql_num_rows($result);
		if($no_of_rows>0)
			return $result;
		else
			return false;
	}
	public function getLoggedinuserInfo($u_id){
		$query = sprintf('SELECT uo.p_vsbl_tm,uo.e_vsbl_tm,t.t_id,t.t_name,gt.g_id,g.start_time, g.finis_time,tsk.tsk_id, tsk.tsk_name,tsk.secret_id, c.c_id, c.c_name, c.c_lat, c.c_lng, d.td_id, d.direction, d.audio, d.image, d.td_lat, d.td_lng, q.q_id, q.q_typ_id, q.q_text,(select max(p.status) from progress p where p.tsk_id=tsk.tsk_id AND p.u_id=%s) status,r.q_status,a.answer FROM tasks tsk LEFT OUTER JOIN campus c ON tsk.c_id = c.c_id LEFT OUTER JOIN task_dic td ON td.tsk_id = tsk.tsk_id LEFT OUTER JOIN dic d ON td.td_id = d.td_id LEFT OUTER JOIN dic_question dq ON dq.td_id =d.td_id LEFT OUTER JOIN questions q ON dq.q_id = q.q_id INNER JOIN user_options uo ON uo.u_id=%s LEFT OUTER JOIN team_user tu ON tu.u_id = uo.u_id LEFT OUTER JOIN teams t ON t.t_id = tu.t_id LEFT OUTER JOIN team_game gt ON gt.t_id = t.t_id LEFT OUTER JOIN game g ON g.g_id = gt.g_id LEFT OUTER JOIN progress p ON p.status=1 AND p.u_id = %s AND tsk.tsk_id = p.tsk_id LEFT OUTER JOIN responses r ON r.q_id =q.q_id AND r.q_status=1 AND r.u_id = %s LEFT OUTER JOIN answers a ON a.q_id=q.q_id ORDER BY p.status DESC',
			 mysql_real_escape_string($u_id),
			  mysql_real_escape_string($u_id),
			  mysql_real_escape_string($u_id),
			  mysql_real_escape_string($u_id));
        $result = mysql_query($query);
		$no_of_rows = mysql_num_rows($result);
		if($no_of_rows>0)
			return $result;
		else
			return false;
	}
	
	
	public function getAllavailabletasks($g_id,$u_id){
		$query = sprintf('SELECT gt.prv_tsk_id, tsk.tsk_id,(select max(p.status) from progress p where p.tsk_id=tsk.tsk_id AND p.u_id=%s) status , tsk.tsk_name, c.c_id, c.c_name, c.c_lat, c.c_lng FROM tasks tsk INNER JOIN game_task gt ON tsk.tsk_id = gt.tsk_id INNER JOIN campus c ON c.c_id = tsk.c_id Where gt.g_id=%s AND SYSDATE() < (Select finis_time from game where g_id = %s)',
			 mysql_real_escape_string($u_id),
			 mysql_real_escape_string($g_id),
			  mysql_real_escape_string($g_id));
        $result = mysql_query($query);
		$no_of_rows = mysql_num_rows($result);
		if($no_of_rows>0)
			return $result;
		else
			return false;
	}
	
	
	public function getTaskDetail($t_id){
		$query = sprintf('Select tsk.tsk_name,c.c_lat,c.c_lng,c.c_name, td.td_id dictionary,(Select count(dq.td_id) from dic_question dq where dq.td_id=td.td_id ) questions From task_dic td Inner join tasks tsk on td.tsk_id = tsk.tsk_id AND tsk.tsk_id =%s Inner join campus c on c.c_id = tsk.c_id',
			  mysql_real_escape_string($t_id));
        $result = mysql_query($query);
		$no_of_rows = mysql_num_rows($result);
		if($no_of_rows>0)
			return $result;
		else
			return false;
	}
	
	public function acceptTask($t_id,$tsk_id,$u_id,$status){
		$query = sprintf('INSERT INTO progress(`t_id`,`u_id`,`tsk_id`,`status`) values((Select t_id from team_user Where u_id = %s),%s,%s,%s)',
			 mysql_real_escape_string($u_id),
			  mysql_real_escape_string($u_id),
			 mysql_real_escape_string($tsk_id),
			  mysql_real_escape_string($status));
        $result = mysql_query($query);
		if ($result) {
			return $result;
		}else
			return false;
	}
	
	public function updateUserOption($u_id,$pstatus,$estatus){
		$query = sprintf('UPDATE user_options set p_vsbl_tm = %s,e_vsbl_tm=%s WHERE u_id = %s',
			 mysql_real_escape_string($pstatus),
			  mysql_real_escape_string($estatus),
			 mysql_real_escape_string($u_id));
        $result = mysql_query($query);
		if ($result) {
			return $result;
		}else
			return false;
	}
	
	public function insertResponse($t_id,$u_id,$tsk_id,$q_id,$response,$location){
		$query = sprintf('INSERT INTO responses(`t_id`,`u_id`,`tsk_id`,`q_id`,`response`,`location`) values((Select t_id from team_user Where u_id = %s),%s,(Select p.tsk_id from progress p Where p.u_id=%s AND p.currenttime=(Select MAX(pr.currenttime) from progress pr where pr.u_id=%s)),%s,"%s","%s")',
			 mysql_real_escape_string($u_id),
			  mysql_real_escape_string($u_id),
			   mysql_real_escape_string($u_id),
			  mysql_real_escape_string($u_id),
			 mysql_real_escape_string($q_id),
			 mysql_real_escape_string($response),
			 mysql_real_escape_string($location));
        $result = mysql_query($query);
		if ($result) {
			$rid = mysql_insert_id(); // last inserted id
            $result = mysql_query("SELECT * FROM answers WHERE q_id = ".$q_id." AND LOWER(answer) = (Select LOWER(response) from responses Where r_id = ".$rid.")");
			$no_of_rows = mysql_num_rows($result);
			if($no_of_rows>0){
				mysql_query("UPDATE responses set q_status = 1 WHERE r_id = ".$rid);
				$result = mysql_query("Select count(q_status) solvedquestion,(Select SUM(questions) FROM (Select (Select count(dq.td_id) from dic_question dq where dq.td_id=td.td_id)questions From task_dic td WHERE td.tsk_id =".$tsk_id.") as A) tskquestion FROM responses where q_status = 1 AND tsk_id = ".$tsk_id." AND u_id =".$u_id);
				if($result){
					$result = mysql_fetch_array($result);
					if($result['solvedquestion']==$result['tskquestion']){
					$result=mysql_query("INSERT INTO progress(`t_id`,`u_id`,`tsk_id`,`status`) values((Select t_id from team_user Where u_id = ".$u_id."),".$u_id.",(Select p.tsk_id from progress p Where p.u_id=".$u_id." AND p.currenttime=(Select MAX(pr.currenttime) from progress pr where pr.u_id=".$u_id.")),2)");
					if($result){
						$result = mysql_query("Select count(u_id) tasksdone,(select count(g_id) from game_task where g_id = (Select g_id from team_game where t_id=".$t_id.")) noftasks from progress where status=2 and u_id=".$u_id);
						$no_of_rows = mysql_num_rows($result);
						if($no_of_rows>0){
							$result = mysql_fetch_array($result);
							if($result['tasksdone']==$result['noftasks']){
								return "gamecomplete";
							}else{
							return "taskcomplete";
							}
						}else
						return "taskcomplete";
					}else
					return false;
					}
				}
			return $result;
			}else
			return false;
		}else
			return 100;
	}
	

}


?>