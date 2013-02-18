SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

INSERT INTO `campus` (`c_id`, `c_name`, `c_lat`, `c_lng`) VALUES
(1, 'St. James Campus', 43.6512279, -79.3693856),
(2, 'Casa Loma Campus', 43.6757552, -79.410208),
(3, 'Waterfront Campus', 43.643929, -79.367659);


INSERT INTO `permissions` (`p_id`, `p_desc`) VALUES
(0, "Regular user, can play game"),
(1, "Master Admin, has all the power ower game and players."),
(2, "Editor, can change add new tasks and teams"),
(3, "Admin, has ability that editor can do plus able to ban users"),
(4, "Banned User");


INSERT INTO `users` (`u_id`, `u_nickname`, `u_fname`, `u_lastname`, `u_email`, `u_phone`, `s_num`) VALUES
(0, 'byuntaeng', 'Taeyeon', 'Kim', 'tkim@example.com', '6470010101', '100123456'),
(1, 'fany', 'Tiffany', 'Hwang', 'fany@example.com', '6470020202', '100987654'),
(2, 'sunny', 'Soonkyu', 'Lee', 'soonkyu@example.com', '4160030303', '100159753'),
(3, 'sica', 'Sooyeon', 'Jung', 'lazysica@example.com', '6470040404', '100456852'),
(4, 'seororo', 'Joohyun', 'Seo', 'seohyun@example.com', '6470050505', '100147896'),
(5, 'syoung', 'Sooyoung', 'Choi', 'dj.syoung@example.com', '6470060606', '100456963'),
(6, 'kwonyul', 'Yuri', 'Kwon', 'kyuri@example.com', '4160070707', '100987123'),
(7, 'hyoraengi', 'Hyoyeon', 'Kim', 'hyo@example.com', '6470080808', '100741963'),
(8, 'yoong', 'Yoona', 'Im', 'imyoona@example.com', '4160090909', '101793158'),
(9, 'user1', 'user1', 'user1', 'user1@example.com', '6471020202', '102987654'),
(10, 'user2', 'user2', 'user2', 'user2@example.com', '4162030303', '103159753'),
(11, 'user3', 'user3', 'user3', 'user3@example.com', '6473040404', '104456852'),
(12, 'user4', 'user4', 'user4', 'user4@example.com', '6474050505', '105147896'),
(13, 'user5', 'user5', 'user5', 'user5@example.com', '6475060606', '106456963'),
(14, 'user6', 'user6', 'user6', 'user6@example.com', '4166070707', '107987123'),
(15, 'user7', 'user7', 'user7', 'user7@example.com', '6477080808', '108741963'),
(16, 'user8', 'user8', 'user8', 'user8@example.com', '4168090909', '109793158'),
(17, 'user9', 'user9', 'user9', 'user9@example.com', '4169090909', '110793158');

INSERT INTO `login` (`login_name`, `login_pass`, `u_id`, `p_id`) VALUES
('hkim', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 7, NULL),
('jseo', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 4, NULL),
('schoi', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 5, NULL),
('sjung', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 3, NULL),
('slee', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 2, NULL),
('thwang', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 1, NULL),
('tkim', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 0, NULL),
('yim', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 8, NULL),
('ykwon', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 6, NULL),
('user1', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 9, NULL),
('user2', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 10, NULL),
('user3', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 11, NULL),
('user4', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 12, NULL),
('user5', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 13, NULL),
('user6', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 14, NULL),
('user7', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 15, NULL),
('user8', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 16, NULL),
('user9', '8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92', 17, NULL);

INSERT INTO `teams` (`t_id`, `t_name`, `t_chat_id`) VALUES
(0, 'TTS', 'TTS'),
(1, 'SJS', 'SJS'),
(2, 'YHY', 'YHY'),
(3, 'Team 1', 'Team 1'),
(4, 'Team 2', 'Team 2'),
(5, 'Team 3', 'Team 3');

INSERT INTO `team_user` (`t_id`, `u_id`) VALUES
(0, 0),(0, 1),(1, 2),(1, 3),(0, 4),(1, 5),(2, 6),(2, 7),(2, 8),
(3, 9),(3, 10),(3, 11),(4, 12),(4, 13),(4, 14),(5, 15),(5, 16),(5, 17);

Insert Into user_options(`u_id`,`p_vsbl_tm`,`e_vsbl_tm`) values(0,1,1),(1,0,1),(2,1,0),(3,1,1),(4,1,1),(5,1,0),(6,0,1),(7,0,1),(8,1,1),
(9,1,1),(10,0,1),(11,1,0),(12,1,1),(13,1,1),(14,1,0),(15,0,1),(16,0,1),(17,1,1);


INSERT INTO dic(`direction`,`audio`,`image`,`td_lat`,`td_lng`) values("The first place you will want to visit on this scavenger hunt is the International Centre. Go through the first door on west (left) side of the lobby. Walk down the hall and there you will see a desk on the left hand side.  Find and scan the MOSHapp QR-code displayed there or if you have any problems finding the QR code ask the person at the desk for directions.  Follow the instructions displayed on the phone; then send your answers using the application.","Checkpt1.1.mp3","check.1.1.png",43.657965,-79.5647896)
,("Once you have all this information you are ready to move to the next stop.  You can choose whichever order you wish to visit all the stops; it doesn''t make a difference because they will all be directed from the center elevators on the first floor of the building.  To get there from the International Centre, walk directly across the lobby, up 5 steps past the Information Desk and the Security office into the mezzanine.  Go up another set of 8 steps, past the first Aid Centre and Tim Horton''s on the left, through the double doors to find yourself in front of the center elevators.","Checkpt1.2.mp3","check.1.2.png",43.658965,-79.5647896)
,("Another service for the students but run by the students is the Student Association office.  To get there, walk towards the variety store at the end of the hallway.  Don''t go in but turn right.  At the end of that hallway, you will see the Student Association office -Room 147. Go in through the glass doors. Scan the MOSHapp QR-code displayed on the door. Follow the instruction and send your answers using the MOSH application.","Checkpt2.1.mp3","check.1.1.png",43.658965,-79.5947896)
,("Another place you will be spending a lot of time during your studies at George Brown is the Library Learning Commons.  To get there from the center elevators, walk through the double doors right by the elevators.  Immediately on your left is the entrance to the library.  Go inside to the front desk.  You will need your student ID card for this exercise.  Scan the QR-code displayed there or ask for assistance with finding the MOSHapp QR code. Follow the instruction and send your answers using the application.","Checkpt3.1.mp3","check.1.2.png",43.658965,-79.5947896)
,("When you begin your studies at George Brown you will need to buy your textbooks and other materials at the Bookstore.  Getting there from the center elevators is quite easy.  Go through the double doors, past the library on your left and Tim Horton''s on the right.  Just past Tim Horton''s you will go down 4 steps; then immediately on your left you will see the bookstore.  Scan the MOSHapp QR-code and follow the instruction provided in the recording.","Checkpt4.1.mp3","check.1.1.png",43.658965,-79.5947896)
,("Go inside and find a hoodie in the colour you like.  Try it on and have your partner snap a picture of you in it; then send it using the application.  If you don''t want to have your picture posted on the website, just have your partner take your picture without your face showing.","Checkpt4.2.mp3","check.1.2.png",43.658965,-79.5947896)
,("The School of Business has two main offices:  one in SJA and one in SJC (The Centre for Financial Services Education).  To get to the SJA office, take the elevator to the third floor.  When you get out of the elevator, turn left and walk to the end of the hallway; then turn right. This is the A hallway. Take this hallway to the very end and walk through the double doors at 313A.  You are now in the Business office.  Scan the MOSHapp QR-code displayed in the Business office and follow the instructions that appear on your phone; then send your answers using the application.","Checkpt5.1.mp3","check.1.1.png",43.658965,-79.5947896)
,("Now turn around and walk completely to the other end of hallway A.  Go through the doors, down the stairs to the first floor, and then outside.  Being very careful, cross the street.  It is safest to cross Adelaide Street at the lights you see on your left.  Once you are on the other side of the street you will see a walkway directly west of the Hospitality building.  Take that walkway to the CFSE, Building C, go through the glass doors and turn left into the other Business office.  Once again go to the front desk, scan the MOSHapp QR code and use the MOSH app to submit the answers you received from the people at the front desk.","Checkpt5.2.mp3","check.1.2.png",43.658965,-79.5947896)
,("One of the services you will definitely want to use on a regular basis is the Tutoring and Learning Centre, TLC (430A).  Take the center elevators to the 4th floor. As you get out of the elevators, turn left and walk to the end of the hallway; then turn left again.  Before you go through the doors at the end of the hallway, you will see the Tutoring and Learning Centre on the right.  Go inside and scan the MOSHapp QR-code displayed at the front desk of the Tutoring and Learning Centre. Follow the instruction and send your answers using the application. To get your answers, speak to the person who is at the front desk. Ask this person about the services being offered.","Checkpt6.1.mp3","check.1.1.png",43.658965,-79.5947896)
,("One of the great services George Brown provides for its students is the Student Affairs on the 5th floor, 582C.  This is different from the Student Association, so don''t get them confused. This office provides support for students in job searching, housing, counseling, and studying techniques.  To get to the Student Affairs office, take the center elevators to the 5th floor.  When the elevator doors open, walk straight ahead, past the lounge/study area to the hallway at the end.  Turn left.  Halfway down that hallway you will see the Student Affairs on the right.  Go in and walk to the front desk.  Scan the QR-code and follow the instructions in the recording","Checkpt7.1.mp3","check.1.2.png",43.658965,-79.5947896)
,("In front of the desk you will see a stand that is holding a number of information sheets.  Look for the sheet titled “Welcome to Student Affairs.”  Take a copy of that sheet and bring it with you. Answer the question shown in the application.","Checkpt7.2.mp3","check.1.1.png",43.658965,-79.5947896)
,("A great way to meet people and keep in shape while at George Brown is to go to the gym.  Even getting there is part of the warm-up.  You have two different ways to do this.  The easy way is to take the center elevators to the fifth floor.  That is the highest it will go.  Then directly in front of the elevator is a set of stairs that will take you to the 6th floor.  Climb the stairs, go through the door to the front desk, which is directly on your left. That''s the easy way. The harder way is to take the stairs from the first floor all the way to the 6th floor, but you''ve also had a good cardio workout at the same time. Once you are at the gym scan the QR-code and follow the instructions. You might want to ask the person at the desk for help","Checkpt8.1.mp3","check.1.2.png",43.658965,-79.5947896)
,("There are many other services available at George Brown, but now you need to go outside the college to discover some of the services that George Brown students use.  To get a quick fix of mojo, go outside through the main doors on King Street. Walk west to the stoplight at King and George Streets.  Cross the street twice to get to Starbucks on the south-west corner of the street.  Enter the store and scan the MOSHapp QR-code displayed there. Follow the instructions. One of the servers will be able to provide you the necessary information.","Checkpt9.1.mp3","check.1.1.png",43.658965,-79.5947896)
,("Another very important service you will need to use is the bank.  George Brown works closely with Scotia Bank.  To get to this bank from George Brown, walk east on King Street (away from the CN Tower).  Cross over Sherbourne Street and cross again to the south side of King Street. Continue walking east till you see the Scotia Bank sign.  Go inside and scan the QR-code at the Customer Service desk. Follow the instructions on your phone. Ask the person at the Customer Service desk for the necessary information.","Checkpt10.1.mp3","check.1.2.png",43.658965,-79.5947896);

INSERT INTO tasks(`tsk_name`,`secret_id`,`c_id`) values('International Centre','ABC123',3),('Student Association','CBA123',3),('Library Learning Commons','BCA123',3),('Bookstore','BAC123',3),
('School of Business','ACB123',3),('Tutoring and Learning Centre','CAB123',3),('Student Affairs','ABC213',3),('Gym','ACB231',3),('Starbucks','CAB132',3),('Scotia Bank','ABC321',3);

INSERT INTO task_dic values(1,1),(1,2),(2,3),(3,4),(4,5),(4,6),(5,7),(5,8),(6,9),(7,10),(7,11),(8,12),(9,13),(10,14);

INSERT INTO question_type(`typ_desc`) values("Regular question answer type"),("Multichoice question type");

INSERT INTO questions(`q_typ_id`,`q_text`) values(1,"Where can I find out more about scholarships for International students?")
,(1,"Can I work in Canada while I am going to school? "),(1,"Are International students eligible to work on campus at the beginning of the school year? ")
,(1,"When can I apply for my off-campus work permit?"),(2,'When can I buy my metro pass for the month?~&~Whenever I feel like it~Last week of month~First week of month~The 15th of each month'),(1,'When will I be able to pick up my health benefits card?')
,(1,'I am interested in accessing the library from home so I need to make sure that my student card works.  Could you please check to make sure my card is working and active?<br/>What is the name of the person who helped you?')
,(1,'What is your name?<br/>What is the last date I can drop a course without penalty?'),(1,'What is your name?<br/>What is the website that gives information about bursaries available for students?'),
(2,'What do I need to do to use these services?~&~Nothing, just walk in and work with a tutor~Do an on-line orientation that explains how the centre works~Pay the registration fee before beginning~Agree to buy the tutor a coffee each time you use the centre')
,(2,'What are the special sessions that are offered?~&~Writing Skills for Business Concepts~Accounting Conversation~Grammar and Conversation~Personal Finance for International Students'),
(1,'What does PAL stand for?'),(1,'What facilities can I use for free with my student card?'),(1,'What are the special fitness classes that are given?<br/>Name one that you would be interested in.')
,(1,'How much does it cost to join these special classes?'),(1,'What is the season special?'),(1,'How much does it cost?'),(1,'What is your name so I can tell my partner whom I spoke with?')
,(1,'What do I need to do to open an account with Scotia Bank?'),(1,'Can I use this bank even if I don''t have an account with them?');

INSERT INTO answers(`q_id`,`answer`) values(1,"Our website"),(2,"Yes"),(3,"Yes"),(4,"6 months after starting school as a full-time student"),
(5,'Last week of month'),(6,'Pick up a copy of the health benefit program'),(7,'John'),(8,'12th week of every semester'),(9,'stars.georgebrown.ca')
,(10,'Do an on-line orientation that explains how the centre works'),(11,'Grammar and Conversation'),(12,'Peer Assisted Learning'),(13,'gym');

INSERT INTO dic_question values(1,1),(1,2),(1,3),(1,4),(3,5),(3,6),(4,7),(7,8),(8,9),(9,10),(9,11),(11,12),(12,13),(12,14),(12,15),(13,16),(13,17),(13,18),(14,19),(14,20);

INSERT INTO game(`start_time`,`finis_time`) values('2013-1-28 13:15:23','2013-2-18 13:15:23');

INSERT INTO team_game values(1,1),(2,1),(3,1),(4,1),(5,1);

INSERT INTO game_task(`tsk_id`,`g_id`) values(1,1);

INSERT INTO game_task(`tsk_id`,`g_id`,`prv_tsk_id`) values(2,1,1),(3,1,2),(4,1,3),(5,1,4),(6,1,5),(7,1,6),(8,1,7),(9,1,8),(10,1,9);



