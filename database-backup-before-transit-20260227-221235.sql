PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE employees (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            employee_number TEXT UNIQUE,
            email TEXT UNIQUE,
            password_hash TEXT,
            position TEXT,
            department TEXT,
            supervisor_id INTEGER,
            is_active INTEGER DEFAULT 1,
            role TEXT DEFAULT 'employee',
            last_login DATETIME,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP, gl_account_id INTEGER REFERENCES gl_accounts(id), cost_center_id INTEGER,
            FOREIGN KEY (supervisor_id) REFERENCES employees (id)
        );
INSERT INTO employees VALUES(1,'John Smith','EMP001','john.smith@company.com','702a7c9ae91b4da10207d85b6e71dbbc1bebcdab23f98010e67073b642038111','Senior Manager','Finance',NULL,1,'admin','2026-02-19 05:18:08','2026-02-18 01:19:22',NULL,NULL);
INSERT INTO employees VALUES(2,'Sarah Johnson','EMP002','sarah.johnson@company.com','8b8091a1f93b0c9c785f52303032e22a1f6abea7d0873793497eedd65be01698','Financial Analyst','Finance',NULL,1,'supervisor','2026-02-19 05:16:48','2026-02-18 01:19:22',NULL,NULL);
INSERT INTO employees VALUES(3,'Mike Davis','EMP003','mike.davis@company.com','d23c5f79d47e0399ecbdc32037aa6e9fbb7de3c058fccdb23aefd5c6fa1dfbfa','Senior Developer','IT Updated',2,1,'employee','2026-02-19 04:13:47','2026-02-18 01:19:22',NULL,NULL);
INSERT INTO employees VALUES(4,'Lisa Brown','EMP004','lisa.brown@company.com','4f65a7c13b18d817fdaf6432605c4035fb9e316dc0284c39be8dcc61391079b1','Department Head','Operations',NULL,1,'supervisor','2026-02-25 02:51:32','2026-02-18 01:19:22',NULL,NULL);
INSERT INTO employees VALUES(5,'David Wilson','EMP005','david.wilson@company.com','83385739cb8e2ed830e3f2b5945982bc0a64f2537aabcec292781f81c7624504','Operations Specialist','Operations',4,1,'employee','2026-02-19 12:59:18','2026-02-18 01:19:22',NULL,NULL);
INSERT INTO employees VALUES(6,'Anna Lee','EMP006','anna.lee@company.com','6cfe34f40c8de5cafdc0a289198836ad5338a31550e0b1b8526b1a18fa04ef03','Project Coordinator','Operations',4,1,'employee','2026-02-25 02:51:32','2026-02-18 01:19:22',NULL,NULL);
INSERT INTO employees VALUES(186,'Rachel Chen','EMP007','rachel.chen@company.com','e9612d159c810d6dd8d1e355bc362bd4e1a292fae1549ad027c01ed6eda60970','Team Lead','Engineering',2,1,'supervisor','2026-02-18 11:20:22','2026-02-18 03:10:53',NULL,NULL);
INSERT INTO employees VALUES(187,'Marcus Thompson','EMP008','marcus.thompson@company.com','d2244584badbf6e057b2b5660d584c0b440a88b305f720008c113d291a556563','Team Lead','Marketing',2,1,'supervisor','2026-02-18 11:20:22','2026-02-18 03:10:53',NULL,NULL);
INSERT INTO employees VALUES(188,'Priya Patel','EMP009','priya.patel@company.com','27edf382ff03332fcfec4e103b5636db2fb273b668fc0246a562f27d538a1584','Team Lead','Finance',2,1,'supervisor','2026-02-18 11:20:23','2026-02-18 03:10:53',NULL,NULL);
INSERT INTO employees VALUES(189,'James Carter','EMP010','james.carter@company.com','117622028fc5677ae88d856c47367c0dbb63e49b155871dc07f3809e95f52ac4','Software Developer','Engineering',186,1,'employee','2026-02-18 11:20:14','2026-02-18 03:10:53',NULL,NULL);
INSERT INTO employees VALUES(190,'Emily Zhang','EMP011','emily.zhang@company.com','2dd0fcead05e03a3555497fcd91ce1e0e8675dcf99e821590778be1b4fa1b9a1','Data Analyst','Engineering',186,1,'employee','2026-02-18 11:20:15','2026-02-18 03:10:53',NULL,NULL);
INSERT INTO employees VALUES(191,'Omar Hassan','EMP012','omar.hassan@company.com','5868939742bddaf2136801cf66cc7157852fdffb1f0dc1958e10e46998df6d06','UX Designer','Engineering',186,1,'employee','2026-02-18 11:20:16','2026-02-18 03:10:53',NULL,NULL);
INSERT INTO employees VALUES(192,'Sophie Martin','EMP013','sophie.martin@company.com','eecdedc5584c4f2758a76bfcea2a383a73fe6f15a7c77e23b35a2ff0291cb38e','Marketing Specialist','Marketing',187,1,'employee','2026-02-18 11:20:16','2026-02-18 03:10:53',NULL,NULL);
INSERT INTO employees VALUES(193,'Tyler Brooks','EMP014','tyler.brooks@company.com','288cce99c819a2e939b27e77908b4de7087b9c5c82c567af11b56d25e06b5d3b','Content Manager','Marketing',187,1,'employee','2026-02-18 11:20:16','2026-02-18 03:10:53',NULL,NULL);
INSERT INTO employees VALUES(194,'Nina Kowalski','EMP015','nina.kowalski@company.com','d12670da937d82837819b664b590e57267c7ea8e4743209e1c760d74cdb328ea','Social Media Lead','Marketing',187,1,'employee','2026-02-18 11:20:17','2026-02-18 03:10:53',NULL,NULL);
INSERT INTO employees VALUES(195,'Alex Rivera','EMP016','alex.rivera@company.com','d65cf82e5724dc7234c2ed961cf6f4024b8ec23ac0fe9e741bda38d0018fd421','Financial Analyst','Finance',188,1,'employee','2026-02-18 11:20:18','2026-02-18 03:10:53',NULL,NULL);
INSERT INTO employees VALUES(196,'Fatima Al-Rashid','EMP017','fatima.alrashid@company.com','a205d97f0410c8b784990f3fe732a600a3def7618fc852c9cc5a3fbd57f7ccd5','Accountant','Finance',188,1,'employee','2026-02-18 11:20:18','2026-02-18 03:10:53',NULL,NULL);
INSERT INTO employees VALUES(197,'Ben O''Connor','EMP018','ben.oconnor@company.com','c383569b25832cbf7e0d2e94b9f055583b5cb5c612c33c5b7eebab0a806ca904','Budget Officer','Finance',188,1,'employee','2026-02-18 11:20:19','2026-02-18 03:10:53',NULL,NULL);
INSERT INTO employees VALUES(198,'Diana Reyes','EMP019','diana.reyes@company.com','0e164b2b89800ed6eb378be54e9575f56db12d64cc1dab95d36f38ba7ce94fd9','Policy Analyst','Operations',4,1,'employee','2026-02-18 11:20:19','2026-02-18 03:10:53',NULL,NULL);
INSERT INTO employees VALUES(338,'Test Employee','TEST001',NULL,NULL,'Analyst','Finance',NULL,1,'employee',NULL,'2026-02-18 17:44:32',1,NULL);
INSERT INTO employees VALUES(388,'Will can','007',NULL,NULL,'financial analyst','Finance',186,1,'employee',NULL,'2026-02-19 03:01:14',NULL,NULL);
INSERT INTO employees VALUES(395,'Jim Sam','223',NULL,NULL,'Financial Analyst','Finance',186,1,'employee',NULL,'2026-02-19 03:06:08',NULL,NULL);
INSERT INTO employees VALUES(402,'Test Fix','999','testfix@company.com','29de543db65d2ddeb60e3997814977521fdafecee9a42b44db33cfe789d45232','Tester','QA',NULL,1,'employee',NULL,'2026-02-19 03:08:53',NULL,NULL);
INSERT INTO employees VALUES(409,'Test Employee','TEST1771472280284','test1771472280284@company.com','3630bb663c8dc64b5bc1c3e7c1c1ac6f7cc08ebb33055fa19aea0df075dc8870','Test Position','Test Department',2,1,'employee','2026-02-19 03:38:00','2026-02-19 03:38:00',NULL,NULL);
INSERT INTO employees VALUES(410,'Test Employee 2','TEST21771472280284','test21771472280284@company.com',NULL,'Test Position 2','Test Department',2,0,'employee',NULL,'2026-02-19 03:38:00',NULL,NULL);
INSERT INTO employees VALUES(411,'Demo Employee','DEMO1771472305779','demo1771472305779@company.com',NULL,'Demo Position','Demo Department',2,0,'employee',NULL,'2026-02-19 03:38:25',NULL,NULL);
INSERT INTO employees VALUES(412,'Complete Test Employee','COMPLETE1771472363779','complete1771472363779@company.com','2216334ed70aec49290deb951ceb4c15bd8ea0454a033c2e2132cc21b493cf9c','Test Position','Test Department',2,1,'employee','2026-02-19 03:39:23','2026-02-19 03:39:23',NULL,NULL);
INSERT INTO employees VALUES(468,'Test Final User','FINAL001','final.test@company.com',NULL,'Final Tester','QA',2,0,'employee',NULL,'2026-02-19 05:17:49',NULL,NULL);
CREATE TABLE notifications (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    employee_id INTEGER NOT NULL,
    type TEXT NOT NULL,
    message TEXT NOT NULL,
    read INTEGER DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees (id)
);
INSERT INTO notifications VALUES(1,4,'trip_submitted','Trip "Ottawa Training Conference" has been submitted for your approval.',0,'2026-02-18 01:19:25');
INSERT INTO notifications VALUES(2,5,'expense_approved','Your expense #1 has been approved by Sarah Johnson.',0,'2026-02-18 01:19:25');
INSERT INTO notifications VALUES(3,5,'expense_approved','Your expense #2 has been approved by Sarah Johnson.',0,'2026-02-18 01:19:25');
INSERT INTO notifications VALUES(4,5,'expense_approved','Your expense #3 has been approved by Sarah Johnson.',0,'2026-02-18 01:19:25');
INSERT INTO notifications VALUES(5,5,'expense_approved','Your expense #4 has been approved by Sarah Johnson.',0,'2026-02-18 01:19:25');
INSERT INTO notifications VALUES(6,5,'expense_approved','Your expense #5 has been approved by Sarah Johnson.',0,'2026-02-18 01:19:25');
INSERT INTO notifications VALUES(7,4,'trip_submitted','Trip "Ottawa Training Conference" has been submitted for your approval.',0,'2026-02-18 01:28:13');
INSERT INTO notifications VALUES(8,5,'expense_approved','Your expense #6 has been approved by Sarah Johnson.',0,'2026-02-18 01:28:13');
INSERT INTO notifications VALUES(9,5,'expense_approved','Your expense #7 has been approved by Sarah Johnson.',0,'2026-02-18 01:28:13');
INSERT INTO notifications VALUES(10,5,'expense_approved','Your expense #8 has been approved by Sarah Johnson.',0,'2026-02-18 01:28:13');
INSERT INTO notifications VALUES(11,5,'expense_approved','Your expense #9 has been approved by Sarah Johnson.',0,'2026-02-18 01:28:13');
INSERT INTO notifications VALUES(12,5,'expense_approved','Your expense #10 has been approved by Sarah Johnson.',0,'2026-02-18 01:28:13');
INSERT INTO notifications VALUES(13,4,'trip_submitted','Trip "Browser Test Trip" has been submitted for your approval.',0,'2026-02-18 01:31:08');
INSERT INTO notifications VALUES(14,5,'expense_approved','Your expense #11 has been approved by Admin.',0,'2026-02-18 01:31:08');
INSERT INTO notifications VALUES(15,4,'trip_submitted','Trip "Ottawa Training Conference" has been submitted for your approval.',0,'2026-02-18 01:36:01');
INSERT INTO notifications VALUES(16,5,'expense_approved','Your expense #12 has been approved by Sarah Johnson.',0,'2026-02-18 01:36:01');
INSERT INTO notifications VALUES(17,5,'expense_approved','Your expense #13 has been approved by Sarah Johnson.',0,'2026-02-18 01:36:01');
INSERT INTO notifications VALUES(18,5,'expense_approved','Your expense #14 has been approved by Sarah Johnson.',0,'2026-02-18 01:36:01');
INSERT INTO notifications VALUES(19,5,'expense_approved','Your expense #15 has been approved by Sarah Johnson.',0,'2026-02-18 01:36:01');
INSERT INTO notifications VALUES(20,5,'expense_approved','Your expense #16 has been approved by Sarah Johnson.',0,'2026-02-18 01:36:01');
INSERT INTO notifications VALUES(21,4,'trip_submitted','Trip "Ottawa Training Conference" has been submitted for your approval.',0,'2026-02-18 02:23:01');
INSERT INTO notifications VALUES(22,5,'expense_approved','Your expense #17 has been approved by Sarah Johnson.',0,'2026-02-18 02:23:01');
INSERT INTO notifications VALUES(23,5,'expense_approved','Your expense #18 has been approved by Sarah Johnson.',0,'2026-02-18 02:23:01');
INSERT INTO notifications VALUES(24,5,'expense_approved','Your expense #19 has been approved by Sarah Johnson.',0,'2026-02-18 02:23:01');
INSERT INTO notifications VALUES(25,5,'expense_approved','Your expense #20 has been approved by Sarah Johnson.',0,'2026-02-18 02:23:01');
INSERT INTO notifications VALUES(26,5,'expense_approved','Your expense #21 has been approved by Sarah Johnson.',0,'2026-02-18 02:23:01');
INSERT INTO notifications VALUES(27,4,'trip_submitted','Trip "Ottawa Training Conference" has been submitted for your approval.',0,'2026-02-18 02:24:04');
INSERT INTO notifications VALUES(28,5,'expense_approved','Your expense #22 has been approved by Sarah Johnson.',0,'2026-02-18 02:24:05');
INSERT INTO notifications VALUES(29,5,'expense_approved','Your expense #23 has been approved by Sarah Johnson.',0,'2026-02-18 02:24:05');
INSERT INTO notifications VALUES(30,5,'expense_approved','Your expense #24 has been approved by Sarah Johnson.',0,'2026-02-18 02:24:05');
INSERT INTO notifications VALUES(31,5,'expense_approved','Your expense #25 has been approved by Sarah Johnson.',0,'2026-02-18 02:24:05');
INSERT INTO notifications VALUES(32,5,'expense_approved','Your expense #26 has been approved by Sarah Johnson.',0,'2026-02-18 02:24:05');
INSERT INTO notifications VALUES(33,4,'trip_submitted','Trip "Ottawa Training Conference" has been submitted for your approval.',0,'2026-02-18 02:40:00');
INSERT INTO notifications VALUES(34,5,'expense_approved','Your expense #27 has been approved by Sarah Johnson.',0,'2026-02-18 02:40:00');
INSERT INTO notifications VALUES(35,5,'expense_approved','Your expense #28 has been approved by Sarah Johnson.',0,'2026-02-18 02:40:00');
INSERT INTO notifications VALUES(36,5,'expense_approved','Your expense #29 has been approved by Sarah Johnson.',0,'2026-02-18 02:40:00');
INSERT INTO notifications VALUES(37,5,'expense_approved','Your expense #30 has been approved by Sarah Johnson.',0,'2026-02-18 02:40:00');
INSERT INTO notifications VALUES(38,5,'expense_approved','Your expense #31 has been approved by Sarah Johnson.',0,'2026-02-18 02:40:00');
INSERT INTO notifications VALUES(39,4,'trip_submitted','Trip "Ottawa Conference Trip" has been submitted for your approval.',0,'2026-02-18 02:46:05');
INSERT INTO notifications VALUES(40,4,'trip_submitted','Trip "Toronto Business Meeting" has been submitted for your approval.',0,'2026-02-18 02:51:35');
INSERT INTO notifications VALUES(41,4,'trip_submitted','Trip "colombo 123" has been submitted for your approval.',0,'2026-02-18 02:59:24');
INSERT INTO notifications VALUES(42,4,'trip_submitted','Trip "colombo 123" has been submitted for your approval.',0,'2026-02-18 02:59:24');
INSERT INTO notifications VALUES(43,4,'trip_submitted','Trip "trip test A" has been submitted for your approval.',0,'2026-02-18 03:07:19');
INSERT INTO notifications VALUES(44,4,'trip_submitted','Trip "trip test A" has been submitted for your approval.',0,'2026-02-18 03:07:19');
INSERT INTO notifications VALUES(45,6,'expense_approved','Your expense #36 has been approved by Sarah Johnson.',0,'2026-02-18 03:21:03');
INSERT INTO notifications VALUES(46,6,'expense_approved','Your expense #37 has been approved by Sarah Johnson.',0,'2026-02-18 03:21:04');
INSERT INTO notifications VALUES(47,6,'expense_approved','Your expense #38 has been approved by Sarah Johnson.',0,'2026-02-18 03:21:05');
INSERT INTO notifications VALUES(48,6,'expense_approved','Your expense #34 has been approved by Sarah Johnson.',0,'2026-02-18 03:21:06');
INSERT INTO notifications VALUES(49,6,'expense_approved','Your expense #35 has been approved by Sarah Johnson.',0,'2026-02-18 03:21:08');
INSERT INTO notifications VALUES(50,6,'expense_approved','Your expense #33 has been approved by Sarah Johnson.',0,'2026-02-18 03:21:08');
INSERT INTO notifications VALUES(51,6,'expense_approved','Your expense #32 has been approved by Sarah Johnson.',0,'2026-02-18 03:21:10');
INSERT INTO notifications VALUES(52,1,'trip_submitted','Trip "Calgary - Training conference" has been submitted for your approval.',0,'2026-02-18 11:20:10');
INSERT INTO notifications VALUES(53,1,'trip_submitted','Trip "Montreal - Project kickoff" has been submitted for your approval.',0,'2026-02-18 11:20:11');
INSERT INTO notifications VALUES(54,2,'trip_submitted','Trip "Montreal - Site inspection" has been submitted for your approval.',0,'2026-02-18 11:20:11');
INSERT INTO notifications VALUES(55,4,'trip_submitted','Trip "Toronto - Team building" has been submitted for your approval.',0,'2026-02-18 11:20:12');
INSERT INTO notifications VALUES(56,1,'trip_submitted','Trip "Winnipeg - Vendor meeting" has been submitted for your approval.',0,'2026-02-18 11:20:13');
INSERT INTO notifications VALUES(57,1,'trip_submitted','Trip "Halifax - Team building" has been submitted for your approval.',0,'2026-02-18 11:20:13');
INSERT INTO notifications VALUES(58,1,'trip_submitted','Trip "Montreal - Site inspection" has been submitted for your approval.',0,'2026-02-18 11:20:14');
INSERT INTO notifications VALUES(59,186,'trip_submitted','Trip "Ottawa - Team building" has been submitted for your approval.',0,'2026-02-18 11:20:15');
INSERT INTO notifications VALUES(60,186,'trip_submitted','Trip "Winnipeg - Audit review" has been submitted for your approval.',0,'2026-02-18 11:20:15');
INSERT INTO notifications VALUES(61,187,'trip_submitted','Trip "Halifax - Audit review" has been submitted for your approval.',0,'2026-02-18 11:20:17');
INSERT INTO notifications VALUES(62,188,'trip_submitted','Trip "Toronto - Audit review" has been submitted for your approval.',0,'2026-02-18 11:20:18');
INSERT INTO notifications VALUES(63,4,'trip_submitted','Trip "Toronto - Sales presentation" has been submitted for your approval.',0,'2026-02-18 11:20:20');
INSERT INTO notifications VALUES(64,1,'expense_approved','Your expense #39 has been approved by Admin.',0,'2026-02-18 11:20:20');
INSERT INTO notifications VALUES(65,3,'expense_rejected','Your expense #41 was rejected by Admin. Reason: Insufficient documentation provided',0,'2026-02-18 11:20:20');
INSERT INTO notifications VALUES(66,3,'expense_approved','Your expense #42 has been approved by Admin.',0,'2026-02-18 11:20:20');
INSERT INTO notifications VALUES(67,4,'expense_approved','Your expense #46 has been approved by Admin.',0,'2026-02-18 11:20:20');
INSERT INTO notifications VALUES(68,5,'expense_approved','Your expense #47 has been approved by Admin.',0,'2026-02-18 11:20:20');
INSERT INTO notifications VALUES(69,5,'expense_approved','Your expense #48 has been approved by Admin.',0,'2026-02-18 11:20:20');
INSERT INTO notifications VALUES(70,186,'expense_approved','Your expense #50 has been approved by Admin.',0,'2026-02-18 11:20:20');
INSERT INTO notifications VALUES(71,186,'expense_approved','Your expense #51 has been approved by Admin.',0,'2026-02-18 11:20:20');
INSERT INTO notifications VALUES(72,186,'expense_approved','Your expense #52 has been approved by Admin.',0,'2026-02-18 11:20:20');
INSERT INTO notifications VALUES(73,187,'expense_approved','Your expense #54 has been approved by Admin.',0,'2026-02-18 11:20:20');
INSERT INTO notifications VALUES(74,187,'expense_approved','Your expense #55 has been approved by Admin.',0,'2026-02-18 11:20:20');
INSERT INTO notifications VALUES(75,188,'expense_approved','Your expense #56 has been approved by Admin.',0,'2026-02-18 11:20:20');
INSERT INTO notifications VALUES(76,188,'expense_approved','Your expense #57 has been approved by Admin.',0,'2026-02-18 11:20:20');
INSERT INTO notifications VALUES(77,188,'expense_approved','Your expense #59 has been approved by Admin.',0,'2026-02-18 11:20:20');
INSERT INTO notifications VALUES(78,188,'expense_approved','Your expense #60 has been approved by Admin.',0,'2026-02-18 11:20:20');
INSERT INTO notifications VALUES(79,188,'expense_approved','Your expense #61 has been approved by Admin.',0,'2026-02-18 11:20:20');
INSERT INTO notifications VALUES(80,189,'expense_approved','Your expense #62 has been approved by Admin.',0,'2026-02-18 11:20:21');
INSERT INTO notifications VALUES(81,189,'expense_approved','Your expense #63 has been approved by Admin.',0,'2026-02-18 11:20:21');
INSERT INTO notifications VALUES(82,189,'expense_approved','Your expense #64 has been approved by Admin.',0,'2026-02-18 11:20:21');
INSERT INTO notifications VALUES(83,189,'expense_approved','Your expense #65 has been approved by Admin.',0,'2026-02-18 11:20:21');
INSERT INTO notifications VALUES(84,192,'expense_approved','Your expense #67 has been approved by Admin.',0,'2026-02-18 11:20:21');
INSERT INTO notifications VALUES(85,192,'expense_approved','Your expense #68 has been approved by Admin.',0,'2026-02-18 11:20:21');
INSERT INTO notifications VALUES(86,193,'expense_approved','Your expense #70 has been approved by Admin.',0,'2026-02-18 11:20:21');
INSERT INTO notifications VALUES(87,193,'expense_approved','Your expense #71 has been approved by Admin.',0,'2026-02-18 11:20:21');
INSERT INTO notifications VALUES(88,194,'expense_approved','Your expense #73 has been approved by Admin.',0,'2026-02-18 11:20:21');
INSERT INTO notifications VALUES(89,195,'expense_rejected','Your expense #74 was rejected by Admin. Reason: Receipt required for validation',0,'2026-02-18 11:20:21');
INSERT INTO notifications VALUES(90,195,'expense_approved','Your expense #75 has been approved by Admin.',0,'2026-02-18 11:20:21');
INSERT INTO notifications VALUES(91,195,'expense_approved','Your expense #76 has been approved by Admin.',0,'2026-02-18 11:20:21');
INSERT INTO notifications VALUES(92,195,'expense_approved','Your expense #77 has been approved by Admin.',0,'2026-02-18 11:20:21');
INSERT INTO notifications VALUES(93,196,'expense_approved','Your expense #78 has been approved by Admin.',0,'2026-02-18 11:20:21');
INSERT INTO notifications VALUES(94,196,'expense_approved','Your expense #79 has been approved by Admin.',0,'2026-02-18 11:20:21');
INSERT INTO notifications VALUES(95,196,'expense_approved','Your expense #80 has been approved by Admin.',0,'2026-02-18 11:20:21');
INSERT INTO notifications VALUES(96,196,'expense_approved','Your expense #81 has been approved by Admin.',0,'2026-02-18 11:20:21');
INSERT INTO notifications VALUES(97,196,'expense_approved','Your expense #82 has been approved by Admin.',0,'2026-02-18 11:20:21');
INSERT INTO notifications VALUES(98,196,'expense_approved','Your expense #83 has been approved by Admin.',0,'2026-02-18 11:20:21');
INSERT INTO notifications VALUES(99,198,'expense_approved','Your expense #84 has been approved by Admin.',0,'2026-02-18 11:20:21');
INSERT INTO notifications VALUES(100,198,'expense_approved','Your expense #86 has been approved by Admin.',0,'2026-02-18 11:20:21');
INSERT INTO notifications VALUES(101,1,'expense_approved','Your expense #39 has been approved by Admin.',0,'2026-02-18 11:20:21');
INSERT INTO notifications VALUES(102,2,'expense_approved','Your expense #40 has been approved by Admin.',0,'2026-02-18 11:20:21');
INSERT INTO notifications VALUES(103,3,'expense_approved','Your expense #41 has been approved by Admin.',0,'2026-02-18 11:20:21');
INSERT INTO notifications VALUES(104,3,'expense_approved','Your expense #42 has been approved by Admin.',0,'2026-02-18 11:20:21');
INSERT INTO notifications VALUES(105,188,'expense_approved','Your expense #56 has been approved by Admin.',0,'2026-02-18 11:20:21');
INSERT INTO notifications VALUES(106,188,'expense_approved','Your expense #58 has been approved by Admin.',0,'2026-02-18 11:20:21');
INSERT INTO notifications VALUES(107,188,'expense_approved','Your expense #60 has been approved by Admin.',0,'2026-02-18 11:20:22');
INSERT INTO notifications VALUES(108,188,'expense_rejected','Your expense #61 was rejected by Admin. Reason: Duplicate expense detected',0,'2026-02-18 11:20:22');
INSERT INTO notifications VALUES(109,195,'expense_approved','Your expense #74 has been approved by Admin.',0,'2026-02-18 11:20:22');
INSERT INTO notifications VALUES(110,195,'expense_approved','Your expense #75 has been approved by Admin.',0,'2026-02-18 11:20:22');
INSERT INTO notifications VALUES(111,195,'expense_approved','Your expense #76 has been approved by Admin.',0,'2026-02-18 11:20:22');
INSERT INTO notifications VALUES(112,195,'expense_approved','Your expense #77 has been approved by Admin.',0,'2026-02-18 11:20:22');
INSERT INTO notifications VALUES(113,196,'expense_approved','Your expense #79 has been approved by Admin.',0,'2026-02-18 11:20:22');
INSERT INTO notifications VALUES(114,196,'expense_approved','Your expense #81 has been approved by Admin.',0,'2026-02-18 11:20:22');
INSERT INTO notifications VALUES(115,196,'expense_approved','Your expense #82 has been approved by Admin.',0,'2026-02-18 11:20:22');
INSERT INTO notifications VALUES(116,196,'expense_approved','Your expense #83 has been approved by Admin.',0,'2026-02-18 11:20:22');
INSERT INTO notifications VALUES(117,4,'expense_approved','Your expense #44 has been approved by Admin.',0,'2026-02-18 11:20:22');
INSERT INTO notifications VALUES(118,4,'expense_approved','Your expense #45 has been approved by Admin.',0,'2026-02-18 11:20:22');
INSERT INTO notifications VALUES(119,4,'expense_approved','Your expense #46 has been approved by Admin.',0,'2026-02-18 11:20:22');
INSERT INTO notifications VALUES(120,5,'expense_approved','Your expense #47 has been approved by Admin.',0,'2026-02-18 11:20:22');
INSERT INTO notifications VALUES(121,5,'expense_approved','Your expense #48 has been approved by Admin.',0,'2026-02-18 11:20:22');
INSERT INTO notifications VALUES(122,5,'expense_rejected','Your expense #49 was rejected by Admin. Reason: Receipt required for validation',0,'2026-02-18 11:20:22');
INSERT INTO notifications VALUES(123,198,'expense_approved','Your expense #84 has been approved by Admin.',0,'2026-02-18 11:20:22');
INSERT INTO notifications VALUES(124,198,'expense_approved','Your expense #85 has been approved by Admin.',0,'2026-02-18 11:20:22');
INSERT INTO notifications VALUES(125,198,'expense_approved','Your expense #86 has been approved by Admin.',0,'2026-02-18 11:20:22');
INSERT INTO notifications VALUES(126,186,'expense_approved','Your expense #50 has been approved by Admin.',0,'2026-02-18 11:20:22');
INSERT INTO notifications VALUES(127,186,'expense_approved','Your expense #51 has been approved by Admin.',0,'2026-02-18 11:20:22');
INSERT INTO notifications VALUES(128,186,'expense_approved','Your expense #52 has been approved by Admin.',0,'2026-02-18 11:20:22');
INSERT INTO notifications VALUES(129,186,'expense_approved','Your expense #53 has been approved by Admin.',0,'2026-02-18 11:20:22');
INSERT INTO notifications VALUES(130,189,'expense_approved','Your expense #62 has been approved by Admin.',0,'2026-02-18 11:20:22');
INSERT INTO notifications VALUES(131,189,'expense_approved','Your expense #63 has been approved by Admin.',0,'2026-02-18 11:20:22');
INSERT INTO notifications VALUES(132,189,'expense_approved','Your expense #64 has been approved by Admin.',0,'2026-02-18 11:20:22');
INSERT INTO notifications VALUES(133,190,'expense_approved','Your expense #66 has been approved by Admin.',0,'2026-02-18 11:20:22');
INSERT INTO notifications VALUES(134,187,'expense_approved','Your expense #54 has been approved by Admin.',0,'2026-02-18 11:20:22');
INSERT INTO notifications VALUES(135,187,'expense_rejected','Your expense #55 was rejected by Admin. Reason: Amount exceeds policy limits',0,'2026-02-18 11:20:22');
INSERT INTO notifications VALUES(136,192,'expense_approved','Your expense #67 has been approved by Admin.',0,'2026-02-18 11:20:23');
INSERT INTO notifications VALUES(137,192,'expense_approved','Your expense #68 has been approved by Admin.',0,'2026-02-18 11:20:23');
INSERT INTO notifications VALUES(138,193,'expense_approved','Your expense #70 has been approved by Admin.',0,'2026-02-18 11:20:23');
INSERT INTO notifications VALUES(139,193,'expense_approved','Your expense #71 has been approved by Admin.',0,'2026-02-18 11:20:23');
INSERT INTO notifications VALUES(140,194,'expense_rejected','Your expense #72 was rejected by Admin. Reason: Missing business justification',0,'2026-02-18 11:20:23');
INSERT INTO notifications VALUES(141,194,'expense_approved','Your expense #73 has been approved by Admin.',0,'2026-02-18 11:20:23');
INSERT INTO notifications VALUES(142,1,'expense_approved','Your expense #39 has been approved by Admin.',0,'2026-02-18 11:20:23');
INSERT INTO notifications VALUES(143,2,'expense_approved','Your expense #40 has been approved by Admin.',0,'2026-02-18 11:20:23');
INSERT INTO notifications VALUES(144,3,'expense_approved','Your expense #41 has been approved by Admin.',0,'2026-02-18 11:20:23');
INSERT INTO notifications VALUES(145,3,'expense_approved','Your expense #42 has been approved by Admin.',0,'2026-02-18 11:20:23');
INSERT INTO notifications VALUES(146,188,'expense_approved','Your expense #56 has been approved by Admin.',0,'2026-02-18 11:20:23');
INSERT INTO notifications VALUES(147,188,'expense_approved','Your expense #57 has been approved by Admin.',0,'2026-02-18 11:20:23');
INSERT INTO notifications VALUES(148,188,'expense_approved','Your expense #58 has been approved by Admin.',0,'2026-02-18 11:20:23');
INSERT INTO notifications VALUES(149,188,'expense_approved','Your expense #60 has been approved by Admin.',0,'2026-02-18 11:20:23');
INSERT INTO notifications VALUES(150,188,'expense_approved','Your expense #61 has been approved by Admin.',0,'2026-02-18 11:20:23');
INSERT INTO notifications VALUES(151,195,'expense_approved','Your expense #74 has been approved by Admin.',0,'2026-02-18 11:20:23');
INSERT INTO notifications VALUES(152,195,'expense_approved','Your expense #75 has been approved by Admin.',0,'2026-02-18 11:20:23');
INSERT INTO notifications VALUES(153,195,'expense_approved','Your expense #76 has been approved by Admin.',0,'2026-02-18 11:20:23');
INSERT INTO notifications VALUES(154,195,'expense_approved','Your expense #77 has been approved by Admin.',0,'2026-02-18 11:20:23');
INSERT INTO notifications VALUES(155,196,'expense_approved','Your expense #80 has been approved by Admin.',0,'2026-02-18 11:20:23');
INSERT INTO notifications VALUES(156,196,'expense_approved','Your expense #81 has been approved by Admin.',0,'2026-02-18 11:20:23');
INSERT INTO notifications VALUES(157,196,'expense_approved','Your expense #82 has been approved by Admin.',0,'2026-02-18 11:20:23');
INSERT INTO notifications VALUES(158,196,'expense_rejected','Your expense #83 was rejected by Admin. Reason: Amount exceeds policy limits',0,'2026-02-18 11:20:23');
INSERT INTO notifications VALUES(159,2,'at_pending','New Authorization to Travel request for Toronto, ON awaits your approval.',0,'2026-02-19 04:12:29');
INSERT INTO notifications VALUES(160,3,'at_approved','Your Authorization to Travel for Toronto, ON has been approved.',0,'2026-02-19 04:13:42');
INSERT INTO notifications VALUES(161,2,'trip_submitted','Trip "Toronto Training Trip" has been submitted for your approval.',0,'2026-02-19 04:13:50');
INSERT INTO notifications VALUES(162,6,'expense_approved','Your expense #93 has been approved by Lisa Brown.',0,'2026-02-19 04:54:07');
INSERT INTO notifications VALUES(163,4,'at_pending','New Authorization to Travel request for Toronto, ON awaits your approval.',0,'2026-02-19 04:54:45');
INSERT INTO notifications VALUES(164,6,'at_approved','Your Authorization to Travel for Toronto, ON has been approved.',0,'2026-02-19 04:54:53');
INSERT INTO notifications VALUES(165,4,'trip_submitted','Trip "Phase 3 Test Trip - WITH AT" has been submitted for your approval.',0,'2026-02-19 04:55:18');
INSERT INTO notifications VALUES(166,4,'at_pending','New Authorization to Travel request for Vancouver, BC awaits your approval.',0,'2026-02-19 04:57:13');
INSERT INTO notifications VALUES(167,6,'at_rejected','Your Authorization to Travel for Vancouver, BC was rejected: Insufficient budget justification. Please provide detailed breakdown of transport costs and reduce lodging estimates.',0,'2026-02-19 04:57:21');
INSERT INTO notifications VALUES(168,4,'at_updated','Travel Authorization for Vancouver, BC has been revised and resubmitted.',0,'2026-02-19 04:57:33');
INSERT INTO notifications VALUES(169,4,'at_pending','New Authorization to Travel request for Montreal, QC awaits your approval.',0,'2026-02-19 05:16:12');
INSERT INTO notifications VALUES(170,6,'at_approved','Your Authorization to Travel for Montreal, QC has been approved.',0,'2026-02-19 05:17:00');
INSERT INTO notifications VALUES(171,4,'at_pending','New Authorization to Travel request "Ottawa Training" awaits your approval.',0,'2026-02-19 12:59:26');
INSERT INTO notifications VALUES(172,4,'at_pending','New Authorization to Travel request "Flight Test" awaits your approval.',0,'2026-02-25 02:51:00');
INSERT INTO notifications VALUES(173,6,'at_approved','Your Authorization to Travel for Flight Test has been approved. A trip has been created automatically.',0,'2026-02-25 02:51:00');
INSERT INTO notifications VALUES(174,4,'at_pending','New Authorization to Travel request "Variance Test 2" awaits your approval.',0,'2026-02-25 02:51:32');
INSERT INTO notifications VALUES(175,6,'at_approved','Your Authorization to Travel for Variance Test 2 has been approved. A trip has been created automatically.',0,'2026-02-25 02:51:32');
CREATE TABLE expenses (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            employee_name TEXT NOT NULL,
            employee_id INTEGER,
            trip_id INTEGER,
            expense_type TEXT NOT NULL,
            meal_name TEXT,
            date DATE NOT NULL,
            location TEXT,
            amount DECIMAL(10,2) NOT NULL,
            vendor TEXT,
            description TEXT,
            receipt_photo TEXT,
            status TEXT DEFAULT 'pending',
            approved_by TEXT,
            approved_at DATETIME,
            approval_comment TEXT,
            rejection_reason TEXT,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            updated_at DATETIME DEFAULT CURRENT_TIMESTAMP, category TEXT, travel_auth_id INTEGER REFERENCES travel_authorizations(id),
            FOREIGN KEY (employee_id) REFERENCES employees (id),
            FOREIGN KEY (trip_id) REFERENCES trips (id)
        );
INSERT INTO expenses VALUES(1,'David Wilson',5,1,'breakfast',NULL,'2026-08-10','Ottawa, ON',23.44999999999999929,NULL,'Breakfast per diem',NULL,'approved','Sarah Johnson','2026-02-18 01:19:25','Approved — within policy',NULL,'2026-02-18 01:19:25','2026-02-18 01:19:25',NULL,NULL);
INSERT INTO expenses VALUES(2,'David Wilson',5,1,'lunch',NULL,'2026-08-10','Ottawa, ON',29.75,NULL,'Lunch per diem',NULL,'approved','Sarah Johnson','2026-02-18 01:19:25','Approved — within policy',NULL,'2026-02-18 01:19:25','2026-02-18 01:19:25',NULL,NULL);
INSERT INTO expenses VALUES(3,'David Wilson',5,1,'dinner',NULL,'2026-08-10','Ottawa, ON',47.04999999999999716,NULL,'Dinner per diem',NULL,'approved','Sarah Johnson','2026-02-18 01:19:25','Approved — within policy',NULL,'2026-02-18 01:19:25','2026-02-18 01:19:25',NULL,NULL);
INSERT INTO expenses VALUES(4,'David Wilson',5,1,'incidentals',NULL,'2026-08-10','Ottawa, ON',32.0799999999999983,NULL,'Incidentals per diem',NULL,'approved','Sarah Johnson','2026-02-18 01:19:25','Approved — within policy',NULL,'2026-02-18 01:19:25','2026-02-18 01:19:25',NULL,NULL);
INSERT INTO expenses VALUES(5,'David Wilson',5,1,'vehicle_km',NULL,'2026-08-10','Ottawa, ON',68,NULL,'100 km driven',NULL,'approved','Sarah Johnson','2026-02-18 01:19:25','Approved — within policy',NULL,'2026-02-18 01:19:25','2026-02-18 01:19:25',NULL,NULL);
INSERT INTO expenses VALUES(6,'David Wilson',5,2,'breakfast',NULL,'2026-09-24','Ottawa, ON',23.44999999999999929,NULL,'Breakfast per diem',NULL,'approved','Sarah Johnson','2026-02-18 01:28:13','Approved — within policy',NULL,'2026-02-18 01:28:13','2026-02-18 01:28:13',NULL,NULL);
INSERT INTO expenses VALUES(7,'David Wilson',5,2,'lunch',NULL,'2026-09-24','Ottawa, ON',29.75,NULL,'Lunch per diem',NULL,'approved','Sarah Johnson','2026-02-18 01:28:13','Approved — within policy',NULL,'2026-02-18 01:28:13','2026-02-18 01:28:13',NULL,NULL);
INSERT INTO expenses VALUES(8,'David Wilson',5,2,'dinner',NULL,'2026-09-24','Ottawa, ON',47.04999999999999716,NULL,'Dinner per diem',NULL,'approved','Sarah Johnson','2026-02-18 01:28:13','Approved — within policy',NULL,'2026-02-18 01:28:13','2026-02-18 01:28:13',NULL,NULL);
INSERT INTO expenses VALUES(9,'David Wilson',5,2,'incidentals',NULL,'2026-09-24','Ottawa, ON',32.0799999999999983,NULL,'Incidentals per diem',NULL,'approved','Sarah Johnson','2026-02-18 01:28:13','Approved — within policy',NULL,'2026-02-18 01:28:13','2026-02-18 01:28:13',NULL,NULL);
INSERT INTO expenses VALUES(10,'David Wilson',5,2,'vehicle_km',NULL,'2026-09-24','Ottawa, ON',68,NULL,'100 km driven',NULL,'approved','Sarah Johnson','2026-02-18 01:28:13','Approved — within policy',NULL,'2026-02-18 01:28:13','2026-02-18 01:28:13',NULL,NULL);
INSERT INTO expenses VALUES(11,'David Wilson',5,3,'breakfast',NULL,'2026-12-01','Toronto',23.44999999999999929,'NJC Per Diem','Test breakfast',NULL,'approved','Admin','2026-02-18 01:31:08',NULL,NULL,'2026-02-18 01:31:08','2026-02-18 01:31:08',NULL,NULL);
INSERT INTO expenses VALUES(12,'David Wilson',5,4,'breakfast',NULL,'2026-08-04','Ottawa, ON',23.44999999999999929,NULL,'Breakfast per diem',NULL,'approved','Sarah Johnson','2026-02-18 01:36:01','Approved — within policy',NULL,'2026-02-18 01:36:01','2026-02-18 01:36:01',NULL,NULL);
INSERT INTO expenses VALUES(13,'David Wilson',5,4,'lunch',NULL,'2026-08-04','Ottawa, ON',29.75,NULL,'Lunch per diem',NULL,'approved','Sarah Johnson','2026-02-18 01:36:01','Approved — within policy',NULL,'2026-02-18 01:36:01','2026-02-18 01:36:01',NULL,NULL);
INSERT INTO expenses VALUES(14,'David Wilson',5,4,'dinner',NULL,'2026-08-04','Ottawa, ON',47.04999999999999716,NULL,'Dinner per diem',NULL,'approved','Sarah Johnson','2026-02-18 01:36:01','Approved — within policy',NULL,'2026-02-18 01:36:01','2026-02-18 01:36:01',NULL,NULL);
INSERT INTO expenses VALUES(15,'David Wilson',5,4,'incidentals',NULL,'2026-08-04','Ottawa, ON',32.0799999999999983,NULL,'Incidentals per diem',NULL,'approved','Sarah Johnson','2026-02-18 01:36:01','Approved — within policy',NULL,'2026-02-18 01:36:01','2026-02-18 01:36:01',NULL,NULL);
INSERT INTO expenses VALUES(16,'David Wilson',5,4,'vehicle_km',NULL,'2026-08-04','Ottawa, ON',68,NULL,'100 km driven',NULL,'approved','Sarah Johnson','2026-02-18 01:36:01','Approved — within policy',NULL,'2026-02-18 01:36:01','2026-02-18 01:36:01',NULL,NULL);
INSERT INTO expenses VALUES(17,'David Wilson',5,5,'breakfast',NULL,'2026-08-05','Ottawa, ON',23.44999999999999929,NULL,'Breakfast per diem',NULL,'approved','Sarah Johnson','2026-02-18 02:23:01','Approved — within policy',NULL,'2026-02-18 02:23:01','2026-02-18 02:23:01',NULL,NULL);
INSERT INTO expenses VALUES(18,'David Wilson',5,5,'lunch',NULL,'2026-08-05','Ottawa, ON',29.75,NULL,'Lunch per diem',NULL,'approved','Sarah Johnson','2026-02-18 02:23:01','Approved — within policy',NULL,'2026-02-18 02:23:01','2026-02-18 02:23:01',NULL,NULL);
INSERT INTO expenses VALUES(19,'David Wilson',5,5,'dinner',NULL,'2026-08-05','Ottawa, ON',47.04999999999999716,NULL,'Dinner per diem',NULL,'approved','Sarah Johnson','2026-02-18 02:23:01','Approved — within policy',NULL,'2026-02-18 02:23:01','2026-02-18 02:23:01',NULL,NULL);
INSERT INTO expenses VALUES(20,'David Wilson',5,5,'incidentals',NULL,'2026-08-05','Ottawa, ON',32.0799999999999983,NULL,'Incidentals per diem',NULL,'approved','Sarah Johnson','2026-02-18 02:23:01','Approved — within policy',NULL,'2026-02-18 02:23:01','2026-02-18 02:23:01',NULL,NULL);
INSERT INTO expenses VALUES(21,'David Wilson',5,5,'vehicle_km',NULL,'2026-08-05','Ottawa, ON',68,NULL,'100 km driven',NULL,'approved','Sarah Johnson','2026-02-18 02:23:01','Approved — within policy',NULL,'2026-02-18 02:23:01','2026-02-18 02:23:01',NULL,NULL);
INSERT INTO expenses VALUES(22,'David Wilson',5,6,'breakfast',NULL,'2026-10-02','Ottawa, ON',23.44999999999999929,NULL,'Breakfast per diem',NULL,'approved','Sarah Johnson','2026-02-18 02:24:05','Approved — within policy',NULL,'2026-02-18 02:24:04','2026-02-18 02:24:05',NULL,NULL);
INSERT INTO expenses VALUES(23,'David Wilson',5,6,'lunch',NULL,'2026-10-02','Ottawa, ON',29.75,NULL,'Lunch per diem',NULL,'approved','Sarah Johnson','2026-02-18 02:24:05','Approved — within policy',NULL,'2026-02-18 02:24:04','2026-02-18 02:24:05',NULL,NULL);
INSERT INTO expenses VALUES(24,'David Wilson',5,6,'dinner',NULL,'2026-10-02','Ottawa, ON',47.04999999999999716,NULL,'Dinner per diem',NULL,'approved','Sarah Johnson','2026-02-18 02:24:05','Approved — within policy',NULL,'2026-02-18 02:24:04','2026-02-18 02:24:05',NULL,NULL);
INSERT INTO expenses VALUES(25,'David Wilson',5,6,'incidentals',NULL,'2026-10-02','Ottawa, ON',32.0799999999999983,NULL,'Incidentals per diem',NULL,'approved','Sarah Johnson','2026-02-18 02:24:05','Approved — within policy',NULL,'2026-02-18 02:24:04','2026-02-18 02:24:05',NULL,NULL);
INSERT INTO expenses VALUES(26,'David Wilson',5,6,'vehicle_km',NULL,'2026-10-02','Ottawa, ON',68,NULL,'100 km driven',NULL,'approved','Sarah Johnson','2026-02-18 02:24:05','Approved — within policy',NULL,'2026-02-18 02:24:04','2026-02-18 02:24:05',NULL,NULL);
INSERT INTO expenses VALUES(27,'David Wilson',5,8,'breakfast',NULL,'2026-12-11','Ottawa, ON',23.44999999999999929,NULL,'Breakfast per diem',NULL,'approved','Sarah Johnson','2026-02-18 02:40:00','Approved — within policy',NULL,'2026-02-18 02:40:00','2026-02-18 02:40:00',NULL,NULL);
INSERT INTO expenses VALUES(28,'David Wilson',5,8,'lunch',NULL,'2026-12-11','Ottawa, ON',29.75,NULL,'Lunch per diem',NULL,'approved','Sarah Johnson','2026-02-18 02:40:00','Approved — within policy',NULL,'2026-02-18 02:40:00','2026-02-18 02:40:00',NULL,NULL);
INSERT INTO expenses VALUES(29,'David Wilson',5,8,'dinner',NULL,'2026-12-11','Ottawa, ON',47.04999999999999716,NULL,'Dinner per diem',NULL,'approved','Sarah Johnson','2026-02-18 02:40:00','Approved — within policy',NULL,'2026-02-18 02:40:00','2026-02-18 02:40:00',NULL,NULL);
INSERT INTO expenses VALUES(30,'David Wilson',5,8,'incidentals',NULL,'2026-12-11','Ottawa, ON',32.0799999999999983,NULL,'Incidentals per diem',NULL,'approved','Sarah Johnson','2026-02-18 02:40:00','Approved — within policy',NULL,'2026-02-18 02:40:00','2026-02-18 02:40:00',NULL,NULL);
INSERT INTO expenses VALUES(31,'David Wilson',5,8,'vehicle_km',NULL,'2026-12-11','Ottawa, ON',68,NULL,'100 km driven',NULL,'approved','Sarah Johnson','2026-02-18 02:40:00','Approved — within policy',NULL,'2026-02-18 02:40:00','2026-02-18 02:40:00',NULL,NULL);
INSERT INTO expenses VALUES(32,'Anna Lee',6,7,'breakfast',NULL,'2026-02-18','Ottawa, ON',23.44999999999999929,'NJC Per Diem Rate','Test breakfast',NULL,'approved','Sarah Johnson','2026-02-18 03:21:10','Approved',NULL,'2026-02-18 02:46:05','2026-02-18 03:21:10',NULL,NULL);
INSERT INTO expenses VALUES(33,'Anna Lee',6,9,'breakfast','Breakfast','2026-03-10','Toronto, ON',23.44999999999999929,'NJC Per Diem Rate','',NULL,'approved','Sarah Johnson','2026-02-18 03:21:08','Approved',NULL,'2026-02-18 02:51:35','2026-02-18 03:21:08',NULL,NULL);
INSERT INTO expenses VALUES(34,'Anna Lee',6,10,'breakfast','Breakfast','2026-02-19','montreal',23.44999999999999929,'NJC Per Diem Rate','',NULL,'approved','Sarah Johnson','2026-02-18 03:21:06','Approved',NULL,'2026-02-18 02:59:24','2026-02-18 03:21:06',NULL,NULL);
INSERT INTO expenses VALUES(35,'Anna Lee',6,10,'breakfast','Breakfast','2026-02-19','montreal',23.44999999999999929,'NJC Per Diem Rate','',NULL,'approved','Sarah Johnson','2026-02-18 03:21:08','Approved',NULL,'2026-02-18 02:59:24','2026-02-18 03:21:08',NULL,NULL);
INSERT INTO expenses VALUES(36,'Anna Lee',6,11,'breakfast','Breakfast','2026-02-20','montreal',23.44999999999999929,'NJC Per Diem Rate','',NULL,'approved','Sarah Johnson','2026-02-18 03:21:03','Approved',NULL,'2026-02-18 03:07:19','2026-02-18 03:21:03',NULL,NULL);
INSERT INTO expenses VALUES(37,'Anna Lee',6,11,'incidentals','Incidentals','2026-02-18','montreal',32.0799999999999983,'NJC Per Diem Rate','',NULL,'approved','Sarah Johnson','2026-02-18 03:21:04','Approved',NULL,'2026-02-18 03:07:19','2026-02-18 03:21:04',NULL,NULL);
INSERT INTO expenses VALUES(38,'Anna Lee',6,11,'incidentals','Incidentals','2026-02-18','montreal',32.0799999999999983,'NJC Per Diem Rate','',NULL,'approved','Sarah Johnson','2026-02-18 03:21:05','Approved',NULL,'2026-02-18 03:07:19','2026-02-18 03:21:05',NULL,NULL);
INSERT INTO expenses VALUES(39,'John Smith',1,37,'vehicle_km','','2026-02-18','To/from Ottawa',255,'Personal Vehicle','Vehicle travel - 375 km',NULL,'approved','Admin','2026-02-18 11:20:23',NULL,NULL,'2026-02-18 11:20:10','2026-02-18 11:20:23',NULL,NULL);
INSERT INTO expenses VALUES(40,'Sarah Johnson',2,38,'vehicle_km','','2026-02-18','To/from Calgary',106.0799999999999983,'Personal Vehicle','Vehicle travel - 156 km',NULL,'approved','Admin','2026-02-18 11:20:23',NULL,NULL,'2026-02-18 11:20:10','2026-02-18 11:20:23',NULL,NULL);
INSERT INTO expenses VALUES(41,'Mike Davis',3,39,'incidentals','','2026-02-13','Montreal',32.0799999999999983,'Local Transit','Incidental expenses in Montreal',NULL,'approved','Admin','2026-02-18 11:20:23',NULL,'Insufficient documentation provided','2026-02-18 11:20:11','2026-02-18 11:20:23',NULL,NULL);
INSERT INTO expenses VALUES(42,'Mike Davis',3,39,'lunch','','2026-02-13','Montreal',29.75,'Local Restaurant','Business lunch in Montreal',NULL,'approved','Admin','2026-02-18 11:20:23',NULL,NULL,'2026-02-18 11:20:11','2026-02-18 11:20:23',NULL,NULL);
INSERT INTO expenses VALUES(43,'Mike Davis',3,39,'breakfast','','2026-02-13','Montreal',23.44999999999999929,'Starbucks','Breakfast in Montreal',NULL,'pending',NULL,NULL,NULL,NULL,'2026-02-18 11:20:11','2026-02-18 11:20:11',NULL,NULL);
INSERT INTO expenses VALUES(44,'Lisa Brown',4,40,'breakfast','','2026-02-06','Montreal',23.44999999999999929,'Tim Hortons','Breakfast in Montreal',NULL,'approved','Admin','2026-02-18 11:20:22',NULL,NULL,'2026-02-18 11:20:11','2026-02-18 11:20:22',NULL,NULL);
INSERT INTO expenses VALUES(45,'Lisa Brown',4,40,'dinner','','2026-02-06','Montreal',47.04999999999999716,'Fine Dining','Business dinner in Montreal',NULL,'approved','Admin','2026-02-18 11:20:22',NULL,NULL,'2026-02-18 11:20:11','2026-02-18 11:20:22',NULL,NULL);
INSERT INTO expenses VALUES(46,'Lisa Brown',4,40,'dinner','','2026-02-07','Montreal',47.04999999999999716,'Conference Dinner','Business dinner in Montreal',NULL,'approved','Admin','2026-02-18 11:20:22',NULL,NULL,'2026-02-18 11:20:11','2026-02-18 11:20:22',NULL,NULL);
INSERT INTO expenses VALUES(47,'David Wilson',5,41,'breakfast','','2026-02-17','Toronto',23.44999999999999929,'Hotel Restaurant','Breakfast in Toronto',NULL,'approved','Admin','2026-02-18 11:20:22',NULL,NULL,'2026-02-18 11:20:12','2026-02-18 11:20:22',NULL,NULL);
INSERT INTO expenses VALUES(48,'David Wilson',5,41,'lunch','','2026-02-17','Toronto',29.75,'Restaurant','Business lunch in Toronto',NULL,'approved','Admin','2026-02-18 11:20:22',NULL,NULL,'2026-02-18 11:20:12','2026-02-18 11:20:22',NULL,NULL);
INSERT INTO expenses VALUES(49,'David Wilson',5,41,'other','','2026-02-17','Toronto',61,'Conference Supplier','Conference materials and supplies',NULL,'rejected','Admin','2026-02-18 11:20:22',NULL,'Receipt required for validation','2026-02-18 11:20:12','2026-02-18 11:20:22',NULL,NULL);
INSERT INTO expenses VALUES(50,'Rachel Chen',186,42,'lunch','','2026-02-10','Winnipeg',29.75,'Restaurant','Business lunch in Winnipeg',NULL,'approved','Admin','2026-02-18 11:20:22',NULL,NULL,'2026-02-18 11:20:12','2026-02-18 11:20:22',NULL,NULL);
INSERT INTO expenses VALUES(51,'Rachel Chen',186,42,'other','','2026-02-10','Winnipeg',113,'Conference Supplier','Conference materials and supplies',NULL,'approved','Admin','2026-02-18 11:20:22',NULL,NULL,'2026-02-18 11:20:13','2026-02-18 11:20:22',NULL,NULL);
INSERT INTO expenses VALUES(52,'Rachel Chen',186,42,'vehicle_km','','2026-02-10','To/from Winnipeg',226.4399999999999978,'Personal Vehicle','Vehicle travel - 333 km',NULL,'approved','Admin','2026-02-18 11:20:22',NULL,NULL,'2026-02-18 11:20:13','2026-02-18 11:20:22',NULL,NULL);
INSERT INTO expenses VALUES(53,'Rachel Chen',186,42,'breakfast','','2026-02-10','Winnipeg',23.44999999999999929,'Tim Hortons','Breakfast in Winnipeg',NULL,'approved','Admin','2026-02-18 11:20:22',NULL,NULL,'2026-02-18 11:20:13','2026-02-18 11:20:22',NULL,NULL);
INSERT INTO expenses VALUES(54,'Marcus Thompson',187,43,'lunch','','2026-02-08','Halifax',29.75,'Local Restaurant','Business lunch in Halifax',NULL,'approved','Admin','2026-02-18 11:20:22',NULL,NULL,'2026-02-18 11:20:13','2026-02-18 11:20:22',NULL,NULL);
INSERT INTO expenses VALUES(55,'Marcus Thompson',187,43,'other','','2026-02-08','Halifax',82,'Conference Supplier','Conference materials and supplies',NULL,'rejected','Admin','2026-02-18 11:20:22',NULL,'Amount exceeds policy limits','2026-02-18 11:20:13','2026-02-18 11:20:22',NULL,NULL);
INSERT INTO expenses VALUES(56,'Priya Patel',188,44,'other','','2026-02-05','Ottawa',47,'Conference Supplier','Conference materials and supplies',NULL,'approved','Admin','2026-02-18 11:20:23',NULL,NULL,'2026-02-18 11:20:14','2026-02-18 11:20:23',NULL,NULL);
INSERT INTO expenses VALUES(57,'Priya Patel',188,44,'other','','2026-02-07','Ottawa',60,'Conference Supplier','Conference materials and supplies',NULL,'approved','Admin','2026-02-18 11:20:23',NULL,NULL,'2026-02-18 11:20:14','2026-02-18 11:20:23',NULL,NULL);
INSERT INTO expenses VALUES(58,'Priya Patel',188,45,'dinner','','2026-02-12','Montreal',47.04999999999999716,'Client Dinner Venue','Business dinner in Montreal',NULL,'approved','Admin','2026-02-18 11:20:23',NULL,NULL,'2026-02-18 11:20:14','2026-02-18 11:20:23',NULL,NULL);
INSERT INTO expenses VALUES(59,'Priya Patel',188,45,'breakfast','','2026-02-14','Montreal',23.44999999999999929,'Hotel Restaurant','Breakfast in Montreal',NULL,'approved','Admin','2026-02-18 11:20:20',NULL,NULL,'2026-02-18 11:20:14','2026-02-18 11:20:20',NULL,NULL);
INSERT INTO expenses VALUES(60,'Priya Patel',188,45,'other','','2026-02-13','Montreal',60,'Conference Supplier','Conference materials and supplies',NULL,'approved','Admin','2026-02-18 11:20:23',NULL,NULL,'2026-02-18 11:20:14','2026-02-18 11:20:23',NULL,NULL);
INSERT INTO expenses VALUES(61,'Priya Patel',188,45,'lunch','','2026-02-13','Montreal',29.75,'Conference Catering','Business lunch in Montreal',NULL,'approved','Admin','2026-02-18 11:20:23',NULL,'Duplicate expense detected','2026-02-18 11:20:14','2026-02-18 11:20:23',NULL,NULL);
INSERT INTO expenses VALUES(62,'James Carter',189,46,'vehicle_km','','2026-02-14','To/from Ottawa',156.4000000000000056,'Personal Vehicle','Vehicle travel - 230 km',NULL,'approved','Admin','2026-02-18 11:20:22',NULL,NULL,'2026-02-18 11:20:14','2026-02-18 11:20:22',NULL,NULL);
INSERT INTO expenses VALUES(63,'James Carter',189,46,'incidentals','','2026-02-14','Ottawa',32.0799999999999983,'Airport','Incidental expenses in Ottawa',NULL,'approved','Admin','2026-02-18 11:20:22',NULL,NULL,'2026-02-18 11:20:14','2026-02-18 11:20:22',NULL,NULL);
INSERT INTO expenses VALUES(64,'James Carter',189,46,'breakfast','','2026-02-14','Ottawa',23.44999999999999929,'Hotel Restaurant','Breakfast in Ottawa',NULL,'approved','Admin','2026-02-18 11:20:22',NULL,NULL,'2026-02-18 11:20:15','2026-02-18 11:20:22',NULL,NULL);
INSERT INTO expenses VALUES(65,'James Carter',189,47,'incidentals','','2026-02-18','Toronto',32.0799999999999983,'Taxi','Incidental expenses in Toronto',NULL,'approved','Admin','2026-02-18 11:20:21',NULL,NULL,'2026-02-18 11:20:15','2026-02-18 11:20:21',NULL,NULL);
INSERT INTO expenses VALUES(66,'Emily Zhang',190,48,'lunch','','2026-02-10','Winnipeg',29.75,'Conference Catering','Business lunch in Winnipeg',NULL,'approved','Admin','2026-02-18 11:20:22',NULL,NULL,'2026-02-18 11:20:15','2026-02-18 11:20:22',NULL,NULL);
INSERT INTO expenses VALUES(67,'Sophie Martin',192,49,'other','','2026-02-16','Vancouver',24,'Conference Supplier','Conference materials and supplies',NULL,'approved','Admin','2026-02-18 11:20:22',NULL,NULL,'2026-02-18 11:20:16','2026-02-18 11:20:22',NULL,NULL);
INSERT INTO expenses VALUES(68,'Sophie Martin',192,49,'dinner','','2026-02-16','Vancouver',47.04999999999999716,'Client Dinner Venue','Business dinner in Vancouver',NULL,'approved','Admin','2026-02-18 11:20:23',NULL,NULL,'2026-02-18 11:20:16','2026-02-18 11:20:23',NULL,NULL);
INSERT INTO expenses VALUES(69,'Tyler Brooks',193,50,'dinner','','2026-02-09','Halifax',47.04999999999999716,'Fine Dining','Business dinner in Halifax',NULL,'pending',NULL,NULL,NULL,NULL,'2026-02-18 11:20:17','2026-02-18 11:20:17',NULL,NULL);
INSERT INTO expenses VALUES(70,'Tyler Brooks',193,50,'incidentals','','2026-02-09','Halifax',32.0799999999999983,'Various','Incidental expenses in Halifax',NULL,'approved','Admin','2026-02-18 11:20:23',NULL,NULL,'2026-02-18 11:20:17','2026-02-18 11:20:23',NULL,NULL);
INSERT INTO expenses VALUES(71,'Tyler Brooks',193,51,'vehicle_km','','2026-02-05','To/from Calgary',239.3600000000000136,'Personal Vehicle','Vehicle travel - 352 km',NULL,'approved','Admin','2026-02-18 11:20:23',NULL,NULL,'2026-02-18 11:20:17','2026-02-18 11:20:23',NULL,NULL);
INSERT INTO expenses VALUES(72,'Nina Kowalski',194,52,'breakfast','','2026-02-02','Vancouver',23.44999999999999929,'Hotel Restaurant','Breakfast in Vancouver',NULL,'rejected','Admin','2026-02-18 11:20:23',NULL,'Missing business justification','2026-02-18 11:20:17','2026-02-18 11:20:23',NULL,NULL);
INSERT INTO expenses VALUES(73,'Nina Kowalski',194,52,'dinner','','2026-02-02','Vancouver',47.04999999999999716,'Hotel Restaurant','Business dinner in Vancouver',NULL,'approved','Admin','2026-02-18 11:20:23',NULL,NULL,'2026-02-18 11:20:17','2026-02-18 11:20:23',NULL,NULL);
INSERT INTO expenses VALUES(74,'Alex Rivera',195,53,'incidentals','','2026-02-02','Halifax',32.0799999999999983,'Local Transit','Incidental expenses in Halifax',NULL,'approved','Admin','2026-02-18 11:20:23',NULL,'Receipt required for validation','2026-02-18 11:20:18','2026-02-18 11:20:23',NULL,NULL);
INSERT INTO expenses VALUES(75,'Alex Rivera',195,53,'breakfast','','2026-02-02','Halifax',23.44999999999999929,'Local Cafe','Breakfast in Halifax',NULL,'approved','Admin','2026-02-18 11:20:23',NULL,NULL,'2026-02-18 11:20:18','2026-02-18 11:20:23',NULL,NULL);
INSERT INTO expenses VALUES(76,'Alex Rivera',195,53,'breakfast','','2026-02-04','Halifax',23.44999999999999929,'Hotel Restaurant','Breakfast in Halifax',NULL,'approved','Admin','2026-02-18 11:20:23',NULL,NULL,'2026-02-18 11:20:18','2026-02-18 11:20:23',NULL,NULL);
INSERT INTO expenses VALUES(77,'Alex Rivera',195,53,'other','','2026-02-03','Halifax',55,'Conference Supplier','Conference materials and supplies',NULL,'approved','Admin','2026-02-18 11:20:23',NULL,NULL,'2026-02-18 11:20:18','2026-02-18 11:20:23',NULL,NULL);
INSERT INTO expenses VALUES(78,'Fatima Al-Rashid',196,54,'lunch','','2026-02-12','Toronto',29.75,'Local Restaurant','Business lunch in Toronto',NULL,'approved','Admin','2026-02-18 11:20:21',NULL,NULL,'2026-02-18 11:20:18','2026-02-18 11:20:21',NULL,NULL);
INSERT INTO expenses VALUES(79,'Fatima Al-Rashid',196,54,'other','','2026-02-15','Toronto',94,'Conference Supplier','Conference materials and supplies',NULL,'approved','Admin','2026-02-18 11:20:22',NULL,NULL,'2026-02-18 11:20:18','2026-02-18 11:20:22',NULL,NULL);
INSERT INTO expenses VALUES(80,'Fatima Al-Rashid',196,55,'vehicle_km','','2026-02-14','To/from Halifax',180.1999999999999887,'Personal Vehicle','Vehicle travel - 265 km',NULL,'approved','Admin','2026-02-18 11:20:23',NULL,NULL,'2026-02-18 11:20:19','2026-02-18 11:20:23',NULL,NULL);
INSERT INTO expenses VALUES(81,'Fatima Al-Rashid',196,55,'other','','2026-02-15','Halifax',91,'Conference Supplier','Conference materials and supplies',NULL,'approved','Admin','2026-02-18 11:20:23',NULL,NULL,'2026-02-18 11:20:19','2026-02-18 11:20:23',NULL,NULL);
INSERT INTO expenses VALUES(82,'Fatima Al-Rashid',196,55,'other','','2026-02-15','Halifax',42,'Conference Supplier','Conference materials and supplies',NULL,'approved','Admin','2026-02-18 11:20:23',NULL,NULL,'2026-02-18 11:20:19','2026-02-18 11:20:23',NULL,NULL);
INSERT INTO expenses VALUES(83,'Fatima Al-Rashid',196,55,'incidentals','','2026-02-15','Halifax',32.0799999999999983,'Airport','Incidental expenses in Halifax',NULL,'rejected','Admin','2026-02-18 11:20:23',NULL,'Amount exceeds policy limits','2026-02-18 11:20:19','2026-02-18 11:20:23',NULL,NULL);
INSERT INTO expenses VALUES(84,'Diana Reyes',198,56,'other','','2026-02-12','Toronto',54,'Conference Supplier','Conference materials and supplies',NULL,'approved','Admin','2026-02-18 11:20:22',NULL,NULL,'2026-02-18 11:20:19','2026-02-18 11:20:22',NULL,NULL);
INSERT INTO expenses VALUES(85,'Diana Reyes',198,56,'dinner','','2026-02-12','Toronto',47.04999999999999716,'Hotel Restaurant','Business dinner in Toronto',NULL,'approved','Admin','2026-02-18 11:20:22',NULL,NULL,'2026-02-18 11:20:19','2026-02-18 11:20:22',NULL,NULL);
INSERT INTO expenses VALUES(86,'Diana Reyes',198,56,'dinner','','2026-02-13','Toronto',47.04999999999999716,'Hotel Restaurant','Business dinner in Toronto',NULL,'approved','Admin','2026-02-18 11:20:22',NULL,NULL,'2026-02-18 11:20:20','2026-02-18 11:20:22',NULL,NULL);
INSERT INTO expenses VALUES(87,'Anna Lee',6,NULL,'other','','2026-02-15','N/A',25.5,'Staples','Printer paper for quarterly reports',NULL,'pending',NULL,NULL,NULL,NULL,'2026-02-19 00:34:39','2026-02-19 00:34:39','Office Supplies',NULL);
INSERT INTO expenses VALUES(88,'Anna Lee',6,NULL,'other','','2026-02-10','N/A',15.99000000000000021,'Microsoft','Monthly Office 365 subscription',NULL,'pending',NULL,NULL,NULL,NULL,'2026-02-19 00:34:57','2026-02-19 00:34:57','Software/Subscriptions',NULL);
INSERT INTO expenses VALUES(89,'Anna Lee',6,NULL,'breakfast','','2026-02-12','N/A',12.5,'Tim Hortons','Meeting with client over breakfast',NULL,'pending',NULL,NULL,NULL,NULL,'2026-02-19 00:35:37','2026-02-19 00:35:37','Other',NULL);
INSERT INTO expenses VALUES(90,'Anna Lee',6,NULL,'other','Office Supplies','2026-02-18','Office',45.99000000000000198,'Staples','Printer paper',NULL,'pending',NULL,NULL,NULL,NULL,'2026-02-19 00:57:09','2026-02-19 00:57:09','Office Supplies',NULL);
INSERT INTO expenses VALUES(91,'Anna Lee Updated',3,58,'lunch','','2026-03-15','Toronto, ON',29.75,'Restaurant ABC','Business lunch during training | ⚠️ FUTURE-DATED EXPENSE (submitted before expense date)',NULL,'pending',NULL,NULL,NULL,NULL,'2026-02-19 04:12:45','2026-02-19 04:12:45',NULL,NULL);
INSERT INTO expenses VALUES(92,'Anna Lee Updated',3,59,'lunch','','2026-04-01','Vancouver, BC',29.75,'Test Restaurant','Test lunch | ⚠️ FUTURE-DATED EXPENSE (submitted before expense date)',NULL,'pending',NULL,NULL,NULL,NULL,'2026-02-19 04:14:16','2026-02-19 04:14:16',NULL,NULL);
INSERT INTO expenses VALUES(93,'Anna Lee',6,NULL,'lunch','','2026-02-18','Ottawa, ON',15.5,'Restaurant ABC','Business lunch with client',NULL,'approved','Lisa Brown','2026-02-19 04:54:07','Approved for test workflow',NULL,'2026-02-19 04:53:08','2026-02-19 04:54:07',NULL,NULL);
INSERT INTO expenses VALUES(94,'Anna Lee',6,60,'breakfast','','2026-03-15','Toronto, ON',23.44999999999999929,'NJC Per Diem Rate','Day 1 breakfast | ⚠️ FUTURE-DATED EXPENSE (submitted before expense date)',NULL,'pending',NULL,NULL,NULL,NULL,'2026-02-19 04:55:06','2026-02-19 04:55:06',NULL,NULL);
INSERT INTO expenses VALUES(95,'Anna Lee',6,60,'other','','2026-03-15','Toronto, ON',85.5,'Airport Taxi','Taxi to airport | ⚠️ FUTURE-DATED EXPENSE (submitted before expense date)',NULL,'pending',NULL,NULL,NULL,NULL,'2026-02-19 04:55:10','2026-02-19 04:55:10',NULL,NULL);
INSERT INTO expenses VALUES(96,'Anna Lee',6,61,'lunch','','2026-04-10','Montreal, QC',29.75,'NJC Per Diem Rate','Day 1 lunch | ⚠️ FUTURE-DATED EXPENSE (submitted before expense date)',NULL,'pending',NULL,NULL,NULL,NULL,'2026-02-19 04:55:32','2026-02-19 04:55:32',NULL,NULL);
INSERT INTO expenses VALUES(97,'Anna Lee',6,NULL,'other','','2026-02-18','Ottawa, ON',25,'Test Vendor','This is a very long description that exceeds normal limits and should be tested to see how the system handles it. This description contains many words and should be truncated or handled gracefully by the input sanitization system. The description continues with more text to really test the boundaries and see what happens when someone tries to submit an extremely long description that might cause issues with the database or user interface display. We want to ensure that the system handles these edge cases gracefully and does not break when users input excessive amounts of text in form fields that should have reasonable limits imposed to maintain system stability and usability. This text continues even longer to test the 1000 character limit that should be in place according to the sanitization function.',NULL,'pending',NULL,NULL,NULL,NULL,'2026-02-19 04:58:17','2026-02-19 04:58:17',NULL,NULL);
INSERT INTO expenses VALUES(98,'Anna Lee',6,NULL,'other','','2026-02-19','Toronto, ON',25.5,'','Test taxi fare',NULL,'pending',NULL,NULL,NULL,NULL,'2026-02-19 05:15:34','2026-02-19 05:15:34','Transportation',NULL);
INSERT INTO expenses VALUES(99,'David Wilson',5,NULL,'breakfast','Breakfast','2026-03-01','Ottawa',23.44999999999999929,'Hotel','',NULL,'estimate',NULL,NULL,NULL,NULL,'2026-02-19 12:59:26','2026-02-19 12:59:26',NULL,5);
INSERT INTO expenses VALUES(100,'David Wilson',5,NULL,'dinner','Dinner','2026-03-01','Ottawa',47.04999999999999716,'Restaurant','',NULL,'estimate',NULL,NULL,NULL,NULL,'2026-02-19 12:59:26','2026-02-19 12:59:26',NULL,5);
INSERT INTO expenses VALUES(101,'Anna Lee',6,NULL,'breakfast','Breakfast','2026-04-01','',23.44999999999999929,'NJC','',NULL,'estimate',NULL,NULL,NULL,NULL,'2026-02-25 02:51:32','2026-02-25 02:51:32',NULL,8);
INSERT INTO expenses VALUES(102,'Anna Lee',6,NULL,'lunch','Lunch','2026-04-01','',29.75,'NJC','',NULL,'estimate',NULL,NULL,NULL,NULL,'2026-02-25 02:51:32','2026-02-25 02:51:32',NULL,8);
INSERT INTO expenses VALUES(103,'Anna Lee',6,NULL,'dinner','Dinner','2026-04-01','',47.04999999999999716,'NJC','',NULL,'estimate',NULL,NULL,NULL,NULL,'2026-02-25 02:51:32','2026-02-25 02:51:32',NULL,8);
INSERT INTO expenses VALUES(104,'Anna Lee',6,NULL,'incidentals','Incidentals','2026-04-01','',32.0799999999999983,'NJC','',NULL,'estimate',NULL,NULL,NULL,NULL,'2026-02-25 02:51:32','2026-02-25 02:51:32',NULL,8);
INSERT INTO expenses VALUES(105,'Anna Lee',6,NULL,'breakfast','Breakfast','2026-04-02','',23.44999999999999929,'NJC','',NULL,'estimate',NULL,NULL,NULL,NULL,'2026-02-25 02:51:32','2026-02-25 02:51:32',NULL,8);
INSERT INTO expenses VALUES(106,'Anna Lee',6,NULL,'lunch','Lunch','2026-04-02','',29.75,'NJC','',NULL,'estimate',NULL,NULL,NULL,NULL,'2026-02-25 02:51:32','2026-02-25 02:51:32',NULL,8);
INSERT INTO expenses VALUES(107,'Anna Lee',6,NULL,'dinner','Dinner','2026-04-02','',47.04999999999999716,'NJC','',NULL,'estimate',NULL,NULL,NULL,NULL,'2026-02-25 02:51:32','2026-02-25 02:51:32',NULL,8);
INSERT INTO expenses VALUES(108,'Anna Lee',6,NULL,'incidentals','Incidentals','2026-04-02','',32.0799999999999983,'NJC','',NULL,'estimate',NULL,NULL,NULL,NULL,'2026-02-25 02:51:32','2026-02-25 02:51:32',NULL,8);
INSERT INTO expenses VALUES(109,'Anna Lee',6,NULL,'breakfast','Breakfast','2026-04-03','',23.44999999999999929,'NJC','',NULL,'estimate',NULL,NULL,NULL,NULL,'2026-02-25 02:51:32','2026-02-25 02:51:32',NULL,8);
INSERT INTO expenses VALUES(110,'Anna Lee',6,NULL,'lunch','Lunch','2026-04-03','',29.75,'NJC','',NULL,'estimate',NULL,NULL,NULL,NULL,'2026-02-25 02:51:32','2026-02-25 02:51:32',NULL,8);
INSERT INTO expenses VALUES(111,'Anna Lee',6,NULL,'dinner','Dinner','2026-04-03','',47.04999999999999716,'NJC','',NULL,'estimate',NULL,NULL,NULL,NULL,'2026-02-25 02:51:32','2026-02-25 02:51:32',NULL,8);
INSERT INTO expenses VALUES(112,'Anna Lee',6,NULL,'incidentals','Incidentals','2026-04-03','',32.0799999999999983,'NJC','',NULL,'estimate',NULL,NULL,NULL,NULL,'2026-02-25 02:51:32','2026-02-25 02:51:32',NULL,8);
INSERT INTO expenses VALUES(113,'Anna Lee',6,NULL,'hotel',NULL,'2026-04-01','',150,'Hotel','',NULL,'estimate',NULL,NULL,NULL,NULL,'2026-02-25 02:51:32','2026-02-25 02:51:32',NULL,8);
INSERT INTO expenses VALUES(114,'Anna Lee',6,NULL,'hotel',NULL,'2026-04-02','',150,'Hotel','',NULL,'estimate',NULL,NULL,NULL,NULL,'2026-02-25 02:51:32','2026-02-25 02:51:32',NULL,8);
INSERT INTO expenses VALUES(115,'Anna Lee',6,NULL,'transport_flight',NULL,'2026-04-01','',1000,'Flight','',NULL,'estimate',NULL,NULL,NULL,NULL,'2026-02-25 02:51:32','2026-02-25 02:51:32',NULL,8);
CREATE TABLE trips (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            employee_id INTEGER NOT NULL,
            trip_name TEXT NOT NULL,
            destination TEXT,
            purpose TEXT,
            start_date DATE NOT NULL,
            end_date DATE NOT NULL,
            status TEXT DEFAULT 'draft',
            total_amount DECIMAL(10,2) DEFAULT 0.00,
            submitted_at DATETIME,
            approved_by TEXT,
            approved_at DATETIME,
            approval_comment TEXT,
            rejection_reason TEXT,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            updated_at DATETIME DEFAULT CURRENT_TIMESTAMP, justification TEXT DEFAULT NULL, report_ref TEXT DEFAULT NULL, pdf_report BLOB DEFAULT NULL, report_generated_at TEXT DEFAULT NULL,
            FOREIGN KEY (employee_id) REFERENCES employees (id)
        );
INSERT INTO trips VALUES(1,5,'Ottawa Training Conference','Ottawa, ON','Annual training conference','2026-08-10','2026-08-10','submitted',0,'2026-02-18 01:19:25',NULL,NULL,NULL,NULL,'2026-02-18 01:19:25','2026-02-18 01:19:25',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(2,5,'Ottawa Training Conference','Ottawa, ON','Annual training conference','2026-09-24','2026-09-24','submitted',0,'2026-02-18 01:28:13',NULL,NULL,NULL,NULL,'2026-02-18 01:28:13','2026-02-18 01:28:13',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(3,5,'Browser Test Trip','Toronto','Testing','2026-12-01','2026-12-03','submitted',0,'2026-02-18 01:31:08',NULL,NULL,NULL,NULL,'2026-02-18 01:31:08','2026-02-18 01:31:08',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(4,5,'Ottawa Training Conference','Ottawa, ON','Annual training conference','2026-08-04','2026-08-04','submitted',0,'2026-02-18 01:36:01',NULL,NULL,NULL,NULL,'2026-02-18 01:36:01','2026-02-18 01:36:01',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(5,5,'Ottawa Training Conference','Ottawa, ON','Annual training conference','2026-08-05','2026-08-05','submitted',0,'2026-02-18 02:23:01',NULL,NULL,NULL,NULL,'2026-02-18 02:23:01','2026-02-18 02:23:01',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(6,5,'Ottawa Training Conference','Ottawa, ON','Annual training conference','2026-10-02','2026-10-02','submitted',0,'2026-02-18 02:24:04',NULL,NULL,NULL,NULL,'2026-02-18 02:24:04','2026-02-18 02:24:04',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(7,6,'Ottawa Conference Trip','Ottawa, ON','Auto-recovered from draft','2026-02-18','2026-02-20','submitted',0,'2026-02-18 02:46:05',NULL,NULL,NULL,NULL,'2026-02-18 02:35:23','2026-02-18 02:35:23',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(8,5,'Ottawa Training Conference','Ottawa, ON','Annual training conference','2026-12-11','2026-12-11','submitted',0,'2026-02-18 02:40:00',NULL,NULL,NULL,NULL,'2026-02-18 02:40:00','2026-02-18 02:40:00',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(9,6,'Toronto Business Meeting','Toronto, ON','Client meetings','2026-03-10','2026-03-12','submitted',0,'2026-02-18 02:51:35',NULL,NULL,NULL,NULL,'2026-02-18 02:50:24','2026-02-18 02:50:24',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(10,6,'colombo 123','montreal','','2026-02-18','2026-02-20','submitted',0,'2026-02-18 02:59:24',NULL,NULL,NULL,NULL,'2026-02-18 02:55:48','2026-02-18 02:55:48',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(11,6,'trip test A','','','2026-02-18','2026-02-20','submitted',0,'2026-02-18 03:07:19',NULL,NULL,NULL,NULL,'2026-02-18 02:59:48','2026-02-18 02:59:48',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(12,3,'Test Trip','Toronto','Testing','2026-02-01','2026-02-03','draft',0,NULL,NULL,NULL,NULL,NULL,'2026-02-18 04:32:17','2026-02-18 04:32:17',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(13,2,'Halifax Audit review','Halifax','Audit review','2026-02-02','2026-02-06','draft',0,NULL,NULL,NULL,NULL,NULL,'2026-02-18 11:18:14','2026-02-18 11:18:14',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(14,3,'Toronto Team building','Toronto','Team building','2026-02-04','2026-02-09','draft',0,NULL,NULL,NULL,NULL,NULL,'2026-02-18 11:18:14','2026-02-18 11:18:14',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(15,4,'Montreal Client meeting','Montreal','Client meeting','2026-02-20','2026-02-22','draft',0,NULL,NULL,NULL,NULL,NULL,'2026-02-18 11:18:15','2026-02-18 11:18:15',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(16,5,'Winnipeg Site inspection','Winnipeg','Site inspection','2026-02-08','2026-02-09','draft',0,NULL,NULL,NULL,NULL,NULL,'2026-02-18 11:18:15','2026-02-18 11:18:15',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(17,5,'Calgary Vendor meeting','Calgary','Vendor meeting','2026-02-24','2026-02-26','draft',0,NULL,NULL,NULL,NULL,NULL,'2026-02-18 11:18:15','2026-02-18 11:18:15',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(18,6,'Vancouver Training conference','Vancouver','Training conference','2026-02-03','2026-02-04','draft',0,NULL,NULL,NULL,NULL,NULL,'2026-02-18 11:18:15','2026-02-18 11:18:15',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(19,6,'Halifax Sales presentation','Halifax','Sales presentation','2026-02-24','2026-02-27','draft',0,NULL,NULL,NULL,NULL,NULL,'2026-02-18 11:18:15','2026-02-18 11:18:15',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(20,186,'Ottawa Audit review','Ottawa','Audit review','2026-02-12','2026-02-13','draft',0,NULL,NULL,NULL,NULL,NULL,'2026-02-18 11:18:15','2026-02-18 11:18:15',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(21,187,'Winnipeg Project kickoff','Winnipeg','Project kickoff','2026-02-22','2026-02-24','draft',0,NULL,NULL,NULL,NULL,NULL,'2026-02-18 11:18:15','2026-02-18 11:18:15',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(22,187,'Ottawa Training conference','Ottawa','Training conference','2026-02-14','2026-02-16','draft',0,NULL,NULL,NULL,NULL,NULL,'2026-02-18 11:18:15','2026-02-18 11:18:15',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(23,188,'Calgary Client meeting','Calgary','Client meeting','2026-02-02','2026-02-03','draft',0,NULL,NULL,NULL,NULL,NULL,'2026-02-18 11:18:15','2026-02-18 11:18:15',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(24,189,'Montreal Training conference','Montreal','Training conference','2026-02-06','2026-02-09','draft',0,NULL,NULL,NULL,NULL,NULL,'2026-02-18 11:18:16','2026-02-18 11:18:16',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(25,190,'Toronto Industry conference','Toronto','Industry conference','2026-02-12','2026-02-14','draft',0,NULL,NULL,NULL,NULL,NULL,'2026-02-18 11:18:16','2026-02-18 11:18:16',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(26,190,'Montreal Industry conference','Montreal','Industry conference','2026-02-22','2026-02-23','draft',0,NULL,NULL,NULL,NULL,NULL,'2026-02-18 11:18:16','2026-02-18 11:18:16',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(27,191,'Winnipeg Audit review','Winnipeg','Audit review','2026-02-13','2026-02-16','draft',0,NULL,NULL,NULL,NULL,NULL,'2026-02-18 11:18:16','2026-02-18 11:18:16',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(28,191,'Winnipeg Team building','Winnipeg','Team building','2026-02-17','2026-02-22','draft',0,NULL,NULL,NULL,NULL,NULL,'2026-02-18 11:18:16','2026-02-18 11:18:16',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(29,192,'Vancouver Project kickoff','Vancouver','Project kickoff','2026-02-03','2026-02-07','draft',0,NULL,NULL,NULL,NULL,NULL,'2026-02-18 11:18:16','2026-02-18 11:18:16',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(30,193,'Halifax Client meeting','Halifax','Client meeting','2026-02-07','2026-02-08','draft',0,NULL,NULL,NULL,NULL,NULL,'2026-02-18 11:18:16','2026-02-18 11:18:16',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(31,193,'Toronto Training conference','Toronto','Training conference','2026-02-20','2026-02-23','draft',0,NULL,NULL,NULL,NULL,NULL,'2026-02-18 11:18:16','2026-02-18 11:18:16',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(32,194,'Ottawa Client meeting','Ottawa','Client meeting','2026-02-13','2026-02-15','draft',0,NULL,NULL,NULL,NULL,NULL,'2026-02-18 11:18:16','2026-02-18 11:18:16',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(33,195,'Vancouver Client meeting','Vancouver','Client meeting','2026-02-21','2026-02-23','draft',0,NULL,NULL,NULL,NULL,NULL,'2026-02-18 11:18:17','2026-02-18 11:18:17',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(34,197,'Winnipeg Industry conference','Winnipeg','Industry conference','2026-02-04','2026-02-05','draft',0,NULL,NULL,NULL,NULL,NULL,'2026-02-18 11:18:17','2026-02-18 11:18:17',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(35,197,'Ottawa Industry conference','Ottawa','Industry conference','2026-02-10','2026-02-12','draft',0,NULL,NULL,NULL,NULL,NULL,'2026-02-18 11:18:17','2026-02-18 11:18:17',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(36,198,'Toronto Site inspection','Toronto','Site inspection','2026-02-04','2026-02-06','draft',0,NULL,NULL,NULL,NULL,NULL,'2026-02-18 11:18:17','2026-02-18 11:18:17',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(37,1,'Ottawa - Project kickoff','Ottawa','Project kickoff','2026-02-18','2026-02-19','draft',0,NULL,NULL,NULL,NULL,NULL,'2026-02-18 11:20:09','2026-02-18 11:20:09',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(38,2,'Calgary - Training conference','Calgary','Training conference','2026-02-17','2026-02-21','submitted',0,'2026-02-18 11:20:10',NULL,NULL,NULL,NULL,'2026-02-18 11:20:10','2026-02-18 11:20:10',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(39,3,'Montreal - Project kickoff','Montreal','Project kickoff','2026-02-13','2026-02-14','submitted',0,'2026-02-18 11:20:11',NULL,NULL,NULL,NULL,'2026-02-18 11:20:10','2026-02-18 11:20:10',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(40,4,'Montreal - Site inspection','Montreal','Site inspection','2026-02-06','2026-02-08','submitted',0,'2026-02-18 11:20:11',NULL,NULL,NULL,NULL,'2026-02-18 11:20:11','2026-02-18 11:20:11',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(41,5,'Toronto - Team building','Toronto','Team building','2026-02-17','2026-02-18','submitted',0,'2026-02-18 11:20:12',NULL,NULL,NULL,NULL,'2026-02-18 11:20:12','2026-02-18 11:20:12',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(42,186,'Winnipeg - Vendor meeting','Winnipeg','Vendor meeting','2026-02-10','2026-02-11','submitted',0,'2026-02-18 11:20:13',NULL,NULL,NULL,NULL,'2026-02-18 11:20:12','2026-02-18 11:20:12',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(43,187,'Halifax - Team building','Halifax','Team building','2026-02-07','2026-02-10','submitted',0,'2026-02-18 11:20:13',NULL,NULL,NULL,NULL,'2026-02-18 11:20:13','2026-02-18 11:20:13',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(44,188,'Ottawa - Sales presentation','Ottawa','Sales presentation','2026-02-04','2026-02-08','draft',0,NULL,NULL,NULL,NULL,NULL,'2026-02-18 11:20:13','2026-02-18 11:20:13',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(45,188,'Montreal - Site inspection','Montreal','Site inspection','2026-02-12','2026-02-15','submitted',0,'2026-02-18 11:20:14',NULL,NULL,NULL,NULL,'2026-02-18 11:20:14','2026-02-18 11:20:14',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(46,189,'Ottawa - Team building','Ottawa','Team building','2026-02-14','2026-02-15','submitted',0,'2026-02-18 11:20:15',NULL,NULL,NULL,NULL,'2026-02-18 11:20:14','2026-02-18 11:20:14',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(47,189,'Toronto - Client meeting','Toronto','Client meeting','2026-02-15','2026-02-19','draft',0,NULL,NULL,NULL,NULL,NULL,'2026-02-18 11:20:15','2026-02-18 11:20:15',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(48,190,'Winnipeg - Audit review','Winnipeg','Audit review','2026-02-09','2026-02-11','submitted',0,'2026-02-18 11:20:15',NULL,NULL,NULL,NULL,'2026-02-18 11:20:15','2026-02-18 11:20:15',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(49,192,'Vancouver - Vendor meeting','Vancouver','Vendor meeting','2026-02-16','2026-02-18','draft',0,NULL,NULL,NULL,NULL,NULL,'2026-02-18 11:20:16','2026-02-18 11:20:16',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(50,193,'Halifax - Audit review','Halifax','Audit review','2026-02-09','2026-02-10','submitted',0,'2026-02-18 11:20:17',NULL,NULL,NULL,NULL,'2026-02-18 11:20:16','2026-02-18 11:20:16',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(51,193,'Calgary - Project kickoff','Calgary','Project kickoff','2026-02-05','2026-02-06','draft',0,NULL,NULL,NULL,NULL,NULL,'2026-02-18 11:20:17','2026-02-18 11:20:17',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(52,194,'Vancouver - Project kickoff','Vancouver','Project kickoff','2026-02-02','2026-02-03','draft',0,NULL,NULL,NULL,NULL,NULL,'2026-02-18 11:20:17','2026-02-18 11:20:17',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(53,195,'Halifax - Team building','Halifax','Team building','2026-02-02','2026-02-05','draft',0,NULL,NULL,NULL,NULL,NULL,'2026-02-18 11:20:18','2026-02-18 11:20:18',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(54,196,'Toronto - Audit review','Toronto','Audit review','2026-02-12','2026-02-16','submitted',0,'2026-02-18 11:20:18',NULL,NULL,NULL,NULL,'2026-02-18 11:20:18','2026-02-18 11:20:18',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(55,196,'Halifax - Industry conference','Halifax','Industry conference','2026-02-13','2026-02-17','draft',0,NULL,NULL,NULL,NULL,NULL,'2026-02-18 11:20:18','2026-02-18 11:20:18',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(56,198,'Toronto - Sales presentation','Toronto','Sales presentation','2026-02-10','2026-02-14','submitted',0,'2026-02-18 11:20:20',NULL,NULL,NULL,NULL,'2026-02-18 11:20:19','2026-02-18 11:20:19',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(57,6,'Audit Test Trip','Toronto','Testing expenses','2026-02-18','2026-02-19','draft',0,NULL,NULL,NULL,NULL,NULL,'2026-02-18 17:47:12','2026-02-18 17:47:12',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(58,3,'Toronto Training Trip','Toronto, ON','Training conference','2026-03-15','2026-03-17','submitted',0,'2026-02-19 04:13:50',NULL,NULL,NULL,NULL,'2026-02-19 04:12:36','2026-02-19 04:12:36',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(59,3,'Test Trip No AT','Vancouver, BC','Testing','2026-04-01','2026-04-02','draft',0,NULL,NULL,NULL,NULL,NULL,'2026-02-19 04:14:12','2026-02-19 04:14:12',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(60,6,'Phase 3 Test Trip - WITH AT','Toronto, ON','Testing trip expense workflow with Travel Authorization','2026-03-15','2026-03-17','submitted',0,'2026-02-19 04:55:18',NULL,NULL,NULL,NULL,'2026-02-19 04:54:37','2026-02-19 04:54:37',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(61,6,'Phase 3 Test Trip - NO AT','Montreal, QC','Testing trip expense workflow WITHOUT Travel Authorization','2026-04-10','2026-04-12','draft',0,NULL,NULL,NULL,NULL,NULL,'2026-02-19 04:55:23','2026-02-19 04:55:23',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(62,6,'Test Business Trip','Montreal, QC','Client meetings','2026-03-05','2026-03-07','draft',0,NULL,NULL,NULL,NULL,NULL,'2026-02-19 05:15:46','2026-02-19 05:15:46',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(63,6,'Flight Test','','','2026-03-10','2026-03-12','active',0,NULL,NULL,NULL,NULL,NULL,'2026-02-25 02:51:00','2026-02-25 02:51:00',NULL,NULL,NULL,NULL);
INSERT INTO trips VALUES(64,6,'Variance Test 2','Toronto, ON','Variance test','2026-04-01','2026-04-03','active',0,NULL,NULL,NULL,NULL,NULL,'2026-02-25 02:51:32','2026-02-25 02:51:32',NULL,NULL,NULL,NULL);
CREATE TABLE gl_accounts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            expense_type TEXT NOT NULL UNIQUE,
            gl_code TEXT NOT NULL,
            gl_name TEXT NOT NULL,
            is_active INTEGER DEFAULT 1,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
        );
INSERT INTO gl_accounts VALUES(1,'meals','5410','Travel - Meals',1,'2026-02-18 04:09:47','2026-02-18 04:09:47');
INSERT INTO gl_accounts VALUES(2,'hotel','5420','Travel - Accommodation',1,'2026-02-18 04:09:47','2026-02-18 04:09:47');
INSERT INTO gl_accounts VALUES(3,'vehicle','5430','Travel - Vehicle',1,'2026-02-18 04:09:47','2026-02-18 04:09:47');
INSERT INTO gl_accounts VALUES(4,'incidentals','5440','Travel - Incidentals',1,'2026-02-18 04:09:47','2026-02-18 04:09:47');
INSERT INTO gl_accounts VALUES(5,'other','5490','Travel - Other Expenses',1,'2026-02-18 04:09:47','2026-02-18 04:09:47');
INSERT INTO gl_accounts VALUES(101,'training','5510','Professional Development - Updated',1,'2026-02-18 17:44:57','2026-02-18 17:45:30');
CREATE TABLE department_cost_centers (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            department TEXT NOT NULL UNIQUE,
            cost_center_code TEXT NOT NULL,
            cost_center_name TEXT NOT NULL,
            is_active INTEGER DEFAULT 1,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
        );
INSERT INTO department_cost_centers VALUES(1,'Finance','100','Finance Department',1,'2026-02-18 04:09:47','2026-02-18 04:09:47');
INSERT INTO department_cost_centers VALUES(2,'Operations','200','Operations Department',1,'2026-02-18 04:09:47','2026-02-18 04:09:47');
INSERT INTO department_cost_centers VALUES(3,'Engineering','300','Engineering Department',1,'2026-02-18 04:09:47','2026-02-18 04:09:47');
INSERT INTO department_cost_centers VALUES(4,'Marketing','400','Marketing Department',1,'2026-02-18 04:09:47','2026-02-18 04:09:47');
CREATE TABLE njc_rates (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    rate_type TEXT NOT NULL,
    amount REAL NOT NULL,
    effective_date DATE NOT NULL,
    end_date DATE,
    province TEXT DEFAULT 'QC',
    notes TEXT,
    created_by TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO njc_rates VALUES(1,'breakfast',22.80000000000000071,'2023-04-01','2024-03-31','QC','Historical NJC rates pre-April 2024','system','2026-02-18 13:06:02');
INSERT INTO njc_rates VALUES(2,'lunch',28.85000000000000142,'2023-04-01','2024-03-31','QC','Historical NJC rates pre-April 2024','system','2026-02-18 13:06:02');
INSERT INTO njc_rates VALUES(3,'dinner',45.5,'2023-04-01','2024-03-31','QC','Historical NJC rates pre-April 2024','system','2026-02-18 13:06:02');
INSERT INTO njc_rates VALUES(4,'incidentals',31.05000000000000071,'2023-04-01','2024-03-31','QC','Historical NJC rates pre-April 2024','system','2026-02-18 13:06:02');
INSERT INTO njc_rates VALUES(5,'private_vehicle',0.6700000000000000399,'2023-04-01','2024-03-31','QC','Historical vehicle rate per km pre-April 2024','system','2026-02-18 13:06:02');
INSERT INTO njc_rates VALUES(6,'breakfast',23.44999999999999929,'2024-04-01',NULL,'QC','Current NJC rates effective April 1, 2024','system','2026-02-18 13:06:06');
INSERT INTO njc_rates VALUES(7,'lunch',29.75,'2024-04-01',NULL,'QC','Current NJC rates effective April 1, 2024','system','2026-02-18 13:06:06');
INSERT INTO njc_rates VALUES(8,'dinner',47.04999999999999716,'2024-04-01',NULL,'QC','Current NJC rates effective April 1, 2024','system','2026-02-18 13:06:06');
INSERT INTO njc_rates VALUES(9,'incidentals',32.0799999999999983,'2024-04-01',NULL,'QC','Current NJC rates effective April 1, 2024','system','2026-02-18 13:06:06');
INSERT INTO njc_rates VALUES(10,'private_vehicle',0.6800000000000000488,'2024-04-01',NULL,'QC','Current vehicle rate per km effective April 1, 2024','system','2026-02-18 13:06:06');
INSERT INTO njc_rates VALUES(11,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-18 22:44:16');
INSERT INTO njc_rates VALUES(12,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-18 22:44:16');
INSERT INTO njc_rates VALUES(13,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-18 22:44:16');
INSERT INTO njc_rates VALUES(14,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-18 22:44:16');
INSERT INTO njc_rates VALUES(15,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-18 22:44:16');
INSERT INTO njc_rates VALUES(16,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-18 22:44:16');
INSERT INTO njc_rates VALUES(17,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-18 22:44:16');
INSERT INTO njc_rates VALUES(18,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-18 22:44:16');
INSERT INTO njc_rates VALUES(19,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-18 22:44:16');
INSERT INTO njc_rates VALUES(20,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-18 22:44:16');
INSERT INTO njc_rates VALUES(21,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-18 23:27:01');
INSERT INTO njc_rates VALUES(22,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-18 23:27:01');
INSERT INTO njc_rates VALUES(23,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-18 23:27:01');
INSERT INTO njc_rates VALUES(24,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-18 23:27:01');
INSERT INTO njc_rates VALUES(25,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-18 23:27:01');
INSERT INTO njc_rates VALUES(26,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-18 23:27:01');
INSERT INTO njc_rates VALUES(27,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-18 23:27:01');
INSERT INTO njc_rates VALUES(28,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-18 23:27:01');
INSERT INTO njc_rates VALUES(29,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-18 23:27:01');
INSERT INTO njc_rates VALUES(30,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-18 23:27:01');
INSERT INTO njc_rates VALUES(31,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 00:34:16');
INSERT INTO njc_rates VALUES(32,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-19 00:34:16');
INSERT INTO njc_rates VALUES(33,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 00:34:16');
INSERT INTO njc_rates VALUES(34,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 00:34:16');
INSERT INTO njc_rates VALUES(35,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 00:34:16');
INSERT INTO njc_rates VALUES(36,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 00:34:16');
INSERT INTO njc_rates VALUES(37,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-19 00:34:16');
INSERT INTO njc_rates VALUES(38,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 00:34:16');
INSERT INTO njc_rates VALUES(39,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 00:34:16');
INSERT INTO njc_rates VALUES(40,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 00:34:16');
INSERT INTO njc_rates VALUES(41,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 00:35:21');
INSERT INTO njc_rates VALUES(42,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-19 00:35:21');
INSERT INTO njc_rates VALUES(43,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 00:35:21');
INSERT INTO njc_rates VALUES(44,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 00:35:21');
INSERT INTO njc_rates VALUES(45,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 00:35:21');
INSERT INTO njc_rates VALUES(46,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 00:35:21');
INSERT INTO njc_rates VALUES(47,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-19 00:35:21');
INSERT INTO njc_rates VALUES(48,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 00:35:21');
INSERT INTO njc_rates VALUES(49,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 00:35:21');
INSERT INTO njc_rates VALUES(50,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 00:35:21');
INSERT INTO njc_rates VALUES(51,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 00:57:06');
INSERT INTO njc_rates VALUES(52,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-19 00:57:06');
INSERT INTO njc_rates VALUES(53,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 00:57:06');
INSERT INTO njc_rates VALUES(54,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 00:57:06');
INSERT INTO njc_rates VALUES(55,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 00:57:06');
INSERT INTO njc_rates VALUES(56,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 00:57:06');
INSERT INTO njc_rates VALUES(57,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-19 00:57:06');
INSERT INTO njc_rates VALUES(58,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 00:57:06');
INSERT INTO njc_rates VALUES(59,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 00:57:06');
INSERT INTO njc_rates VALUES(60,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 00:57:06');
INSERT INTO njc_rates VALUES(61,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 02:19:53');
INSERT INTO njc_rates VALUES(62,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-19 02:19:53');
INSERT INTO njc_rates VALUES(63,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 02:19:53');
INSERT INTO njc_rates VALUES(64,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 02:19:53');
INSERT INTO njc_rates VALUES(65,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 02:19:53');
INSERT INTO njc_rates VALUES(66,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 02:19:53');
INSERT INTO njc_rates VALUES(67,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-19 02:19:53');
INSERT INTO njc_rates VALUES(68,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 02:19:53');
INSERT INTO njc_rates VALUES(69,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 02:19:53');
INSERT INTO njc_rates VALUES(70,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 02:19:53');
INSERT INTO njc_rates VALUES(71,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 02:47:58');
INSERT INTO njc_rates VALUES(72,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-19 02:47:58');
INSERT INTO njc_rates VALUES(73,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 02:47:58');
INSERT INTO njc_rates VALUES(74,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 02:47:58');
INSERT INTO njc_rates VALUES(75,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 02:47:58');
INSERT INTO njc_rates VALUES(76,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 02:47:58');
INSERT INTO njc_rates VALUES(77,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-19 02:47:58');
INSERT INTO njc_rates VALUES(78,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 02:47:58');
INSERT INTO njc_rates VALUES(79,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 02:47:58');
INSERT INTO njc_rates VALUES(80,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 02:47:58');
INSERT INTO njc_rates VALUES(81,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 02:58:08');
INSERT INTO njc_rates VALUES(82,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-19 02:58:08');
INSERT INTO njc_rates VALUES(83,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 02:58:08');
INSERT INTO njc_rates VALUES(84,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 02:58:08');
INSERT INTO njc_rates VALUES(85,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 02:58:08');
INSERT INTO njc_rates VALUES(86,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 02:58:08');
INSERT INTO njc_rates VALUES(87,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-19 02:58:08');
INSERT INTO njc_rates VALUES(88,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 02:58:08');
INSERT INTO njc_rates VALUES(89,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 02:58:08');
INSERT INTO njc_rates VALUES(90,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 02:58:08');
INSERT INTO njc_rates VALUES(91,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 03:02:08');
INSERT INTO njc_rates VALUES(92,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-19 03:02:08');
INSERT INTO njc_rates VALUES(93,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 03:02:08');
INSERT INTO njc_rates VALUES(94,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 03:02:08');
INSERT INTO njc_rates VALUES(95,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 03:02:08');
INSERT INTO njc_rates VALUES(96,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 03:02:08');
INSERT INTO njc_rates VALUES(97,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-19 03:02:08');
INSERT INTO njc_rates VALUES(98,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 03:02:08');
INSERT INTO njc_rates VALUES(99,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 03:02:08');
INSERT INTO njc_rates VALUES(100,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 03:02:08');
INSERT INTO njc_rates VALUES(101,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 03:08:51');
INSERT INTO njc_rates VALUES(102,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-19 03:08:51');
INSERT INTO njc_rates VALUES(103,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 03:08:51');
INSERT INTO njc_rates VALUES(104,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 03:08:51');
INSERT INTO njc_rates VALUES(105,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 03:08:51');
INSERT INTO njc_rates VALUES(106,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 03:08:51');
INSERT INTO njc_rates VALUES(107,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-19 03:08:51');
INSERT INTO njc_rates VALUES(108,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 03:08:51');
INSERT INTO njc_rates VALUES(109,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 03:08:51');
INSERT INTO njc_rates VALUES(110,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 03:08:51');
INSERT INTO njc_rates VALUES(111,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 03:36:40');
INSERT INTO njc_rates VALUES(112,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-19 03:36:40');
INSERT INTO njc_rates VALUES(113,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 03:36:40');
INSERT INTO njc_rates VALUES(114,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 03:36:40');
INSERT INTO njc_rates VALUES(115,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 03:36:40');
INSERT INTO njc_rates VALUES(116,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 03:36:40');
INSERT INTO njc_rates VALUES(117,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-19 03:36:40');
INSERT INTO njc_rates VALUES(118,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 03:36:40');
INSERT INTO njc_rates VALUES(119,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 03:36:40');
INSERT INTO njc_rates VALUES(120,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 03:36:40');
INSERT INTO njc_rates VALUES(121,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 04:11:58');
INSERT INTO njc_rates VALUES(122,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-19 04:11:58');
INSERT INTO njc_rates VALUES(123,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 04:11:58');
INSERT INTO njc_rates VALUES(124,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 04:11:58');
INSERT INTO njc_rates VALUES(125,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 04:11:58');
INSERT INTO njc_rates VALUES(126,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 04:11:58');
INSERT INTO njc_rates VALUES(127,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-19 04:11:58');
INSERT INTO njc_rates VALUES(128,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 04:11:58');
INSERT INTO njc_rates VALUES(129,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 04:11:58');
INSERT INTO njc_rates VALUES(130,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 04:11:58');
INSERT INTO njc_rates VALUES(131,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 04:13:12');
INSERT INTO njc_rates VALUES(132,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-19 04:13:12');
INSERT INTO njc_rates VALUES(133,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 04:13:12');
INSERT INTO njc_rates VALUES(134,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 04:13:12');
INSERT INTO njc_rates VALUES(135,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 04:13:12');
INSERT INTO njc_rates VALUES(136,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 04:13:12');
INSERT INTO njc_rates VALUES(137,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-19 04:13:12');
INSERT INTO njc_rates VALUES(138,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 04:13:12');
INSERT INTO njc_rates VALUES(139,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 04:13:12');
INSERT INTO njc_rates VALUES(140,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 04:13:12');
INSERT INTO njc_rates VALUES(141,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 04:42:02');
INSERT INTO njc_rates VALUES(142,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-19 04:42:02');
INSERT INTO njc_rates VALUES(143,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 04:42:02');
INSERT INTO njc_rates VALUES(144,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 04:42:02');
INSERT INTO njc_rates VALUES(145,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 04:42:02');
INSERT INTO njc_rates VALUES(146,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 04:42:02');
INSERT INTO njc_rates VALUES(147,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-19 04:42:02');
INSERT INTO njc_rates VALUES(148,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 04:42:02');
INSERT INTO njc_rates VALUES(149,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 04:42:02');
INSERT INTO njc_rates VALUES(150,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 04:42:02');
INSERT INTO njc_rates VALUES(151,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 04:50:33');
INSERT INTO njc_rates VALUES(152,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-19 04:50:33');
INSERT INTO njc_rates VALUES(153,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 04:50:33');
INSERT INTO njc_rates VALUES(154,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 04:50:33');
INSERT INTO njc_rates VALUES(155,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 04:50:33');
INSERT INTO njc_rates VALUES(156,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 04:50:33');
INSERT INTO njc_rates VALUES(157,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-19 04:50:33');
INSERT INTO njc_rates VALUES(158,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 04:50:33');
INSERT INTO njc_rates VALUES(159,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 04:50:33');
INSERT INTO njc_rates VALUES(160,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 04:50:33');
INSERT INTO njc_rates VALUES(161,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 04:51:19');
INSERT INTO njc_rates VALUES(162,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-19 04:51:19');
INSERT INTO njc_rates VALUES(163,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 04:51:19');
INSERT INTO njc_rates VALUES(164,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 04:51:19');
INSERT INTO njc_rates VALUES(165,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 04:51:19');
INSERT INTO njc_rates VALUES(166,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 04:51:19');
INSERT INTO njc_rates VALUES(167,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-19 04:51:19');
INSERT INTO njc_rates VALUES(168,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 04:51:19');
INSERT INTO njc_rates VALUES(169,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 04:51:19');
INSERT INTO njc_rates VALUES(170,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 04:51:19');
INSERT INTO njc_rates VALUES(171,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 04:52:15');
INSERT INTO njc_rates VALUES(172,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-19 04:52:15');
INSERT INTO njc_rates VALUES(173,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 04:52:15');
INSERT INTO njc_rates VALUES(174,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 04:52:15');
INSERT INTO njc_rates VALUES(175,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 04:52:15');
INSERT INTO njc_rates VALUES(176,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 04:52:15');
INSERT INTO njc_rates VALUES(177,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-19 04:52:15');
INSERT INTO njc_rates VALUES(178,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 04:52:15');
INSERT INTO njc_rates VALUES(179,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 04:52:15');
INSERT INTO njc_rates VALUES(180,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 04:52:15');
INSERT INTO njc_rates VALUES(181,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 04:59:04');
INSERT INTO njc_rates VALUES(182,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-19 04:59:04');
INSERT INTO njc_rates VALUES(183,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 04:59:04');
INSERT INTO njc_rates VALUES(184,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 04:59:04');
INSERT INTO njc_rates VALUES(185,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 04:59:04');
INSERT INTO njc_rates VALUES(186,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 04:59:04');
INSERT INTO njc_rates VALUES(187,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-19 04:59:04');
INSERT INTO njc_rates VALUES(188,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 04:59:04');
INSERT INTO njc_rates VALUES(189,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 04:59:04');
INSERT INTO njc_rates VALUES(190,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 04:59:04');
INSERT INTO njc_rates VALUES(191,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 05:05:42');
INSERT INTO njc_rates VALUES(192,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-19 05:05:42');
INSERT INTO njc_rates VALUES(193,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 05:05:42');
INSERT INTO njc_rates VALUES(194,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 05:05:42');
INSERT INTO njc_rates VALUES(195,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 05:05:42');
INSERT INTO njc_rates VALUES(196,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 05:05:42');
INSERT INTO njc_rates VALUES(197,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-19 05:05:42');
INSERT INTO njc_rates VALUES(198,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 05:05:42');
INSERT INTO njc_rates VALUES(199,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 05:05:42');
INSERT INTO njc_rates VALUES(200,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 05:05:42');
INSERT INTO njc_rates VALUES(201,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 05:12:48');
INSERT INTO njc_rates VALUES(202,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-19 05:12:48');
INSERT INTO njc_rates VALUES(203,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 05:12:48');
INSERT INTO njc_rates VALUES(204,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 05:12:48');
INSERT INTO njc_rates VALUES(205,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 05:12:48');
INSERT INTO njc_rates VALUES(206,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 05:12:48');
INSERT INTO njc_rates VALUES(207,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-19 05:12:48');
INSERT INTO njc_rates VALUES(208,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 05:12:48');
INSERT INTO njc_rates VALUES(209,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 05:12:48');
INSERT INTO njc_rates VALUES(210,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 05:12:48');
INSERT INTO njc_rates VALUES(211,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 11:59:50');
INSERT INTO njc_rates VALUES(212,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-19 11:59:50');
INSERT INTO njc_rates VALUES(213,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 11:59:50');
INSERT INTO njc_rates VALUES(214,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 11:59:50');
INSERT INTO njc_rates VALUES(215,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 11:59:50');
INSERT INTO njc_rates VALUES(216,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 11:59:50');
INSERT INTO njc_rates VALUES(217,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-19 11:59:50');
INSERT INTO njc_rates VALUES(218,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 11:59:50');
INSERT INTO njc_rates VALUES(219,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 11:59:50');
INSERT INTO njc_rates VALUES(220,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 11:59:50');
INSERT INTO njc_rates VALUES(221,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 12:08:10');
INSERT INTO njc_rates VALUES(222,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-19 12:08:10');
INSERT INTO njc_rates VALUES(223,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 12:08:10');
INSERT INTO njc_rates VALUES(224,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 12:08:10');
INSERT INTO njc_rates VALUES(225,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 12:08:10');
INSERT INTO njc_rates VALUES(226,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 12:08:10');
INSERT INTO njc_rates VALUES(227,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-19 12:08:10');
INSERT INTO njc_rates VALUES(228,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 12:08:10');
INSERT INTO njc_rates VALUES(229,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 12:08:10');
INSERT INTO njc_rates VALUES(230,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 12:08:10');
INSERT INTO njc_rates VALUES(231,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 12:08:54');
INSERT INTO njc_rates VALUES(232,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-19 12:08:54');
INSERT INTO njc_rates VALUES(233,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 12:08:54');
INSERT INTO njc_rates VALUES(234,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 12:08:54');
INSERT INTO njc_rates VALUES(235,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 12:08:54');
INSERT INTO njc_rates VALUES(236,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 12:08:54');
INSERT INTO njc_rates VALUES(237,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-19 12:08:54');
INSERT INTO njc_rates VALUES(238,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 12:08:54');
INSERT INTO njc_rates VALUES(239,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 12:08:54');
INSERT INTO njc_rates VALUES(240,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 12:08:54');
INSERT INTO njc_rates VALUES(241,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 12:57:24');
INSERT INTO njc_rates VALUES(242,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-19 12:57:24');
INSERT INTO njc_rates VALUES(243,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 12:57:24');
INSERT INTO njc_rates VALUES(244,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 12:57:24');
INSERT INTO njc_rates VALUES(245,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 12:57:24');
INSERT INTO njc_rates VALUES(246,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 12:57:24');
INSERT INTO njc_rates VALUES(247,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-19 12:57:24');
INSERT INTO njc_rates VALUES(248,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 12:57:24');
INSERT INTO njc_rates VALUES(249,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 12:57:24');
INSERT INTO njc_rates VALUES(250,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 12:57:24');
INSERT INTO njc_rates VALUES(251,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 12:58:08');
INSERT INTO njc_rates VALUES(252,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-19 12:58:08');
INSERT INTO njc_rates VALUES(253,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 12:58:08');
INSERT INTO njc_rates VALUES(254,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 12:58:08');
INSERT INTO njc_rates VALUES(255,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 12:58:08');
INSERT INTO njc_rates VALUES(256,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 12:58:08');
INSERT INTO njc_rates VALUES(257,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-19 12:58:08');
INSERT INTO njc_rates VALUES(258,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 12:58:08');
INSERT INTO njc_rates VALUES(259,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 12:58:08');
INSERT INTO njc_rates VALUES(260,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 12:58:08');
INSERT INTO njc_rates VALUES(261,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 12:58:23');
INSERT INTO njc_rates VALUES(262,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-19 12:58:23');
INSERT INTO njc_rates VALUES(263,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 12:58:23');
INSERT INTO njc_rates VALUES(264,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 12:58:23');
INSERT INTO njc_rates VALUES(265,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 12:58:23');
INSERT INTO njc_rates VALUES(266,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 12:58:23');
INSERT INTO njc_rates VALUES(267,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-19 12:58:23');
INSERT INTO njc_rates VALUES(268,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 12:58:23');
INSERT INTO njc_rates VALUES(269,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 12:58:23');
INSERT INTO njc_rates VALUES(270,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 12:58:23');
INSERT INTO njc_rates VALUES(271,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 12:58:47');
INSERT INTO njc_rates VALUES(272,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-19 12:58:47');
INSERT INTO njc_rates VALUES(273,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 12:58:47');
INSERT INTO njc_rates VALUES(274,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 12:58:47');
INSERT INTO njc_rates VALUES(275,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 12:58:47');
INSERT INTO njc_rates VALUES(276,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 12:58:47');
INSERT INTO njc_rates VALUES(277,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-19 12:58:47');
INSERT INTO njc_rates VALUES(278,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 12:58:47');
INSERT INTO njc_rates VALUES(279,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 12:58:47');
INSERT INTO njc_rates VALUES(280,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 12:58:47');
INSERT INTO njc_rates VALUES(281,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 12:59:13');
INSERT INTO njc_rates VALUES(282,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-19 12:59:13');
INSERT INTO njc_rates VALUES(283,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 12:59:13');
INSERT INTO njc_rates VALUES(284,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 12:59:13');
INSERT INTO njc_rates VALUES(285,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 12:59:13');
INSERT INTO njc_rates VALUES(286,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 12:59:13');
INSERT INTO njc_rates VALUES(287,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-19 12:59:13');
INSERT INTO njc_rates VALUES(288,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 12:59:13');
INSERT INTO njc_rates VALUES(289,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 12:59:13');
INSERT INTO njc_rates VALUES(290,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 12:59:13');
INSERT INTO njc_rates VALUES(291,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 13:02:51');
INSERT INTO njc_rates VALUES(292,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-19 13:02:51');
INSERT INTO njc_rates VALUES(293,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 13:02:51');
INSERT INTO njc_rates VALUES(294,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 13:02:51');
INSERT INTO njc_rates VALUES(295,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 13:02:51');
INSERT INTO njc_rates VALUES(296,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 13:02:51');
INSERT INTO njc_rates VALUES(297,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-19 13:02:51');
INSERT INTO njc_rates VALUES(298,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 13:02:51');
INSERT INTO njc_rates VALUES(299,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 13:02:51');
INSERT INTO njc_rates VALUES(300,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 13:02:51');
INSERT INTO njc_rates VALUES(301,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 13:06:35');
INSERT INTO njc_rates VALUES(302,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-19 13:06:35');
INSERT INTO njc_rates VALUES(303,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 13:06:35');
INSERT INTO njc_rates VALUES(304,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 13:06:35');
INSERT INTO njc_rates VALUES(305,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 13:06:35');
INSERT INTO njc_rates VALUES(306,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-19 13:06:35');
INSERT INTO njc_rates VALUES(307,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-19 13:06:35');
INSERT INTO njc_rates VALUES(308,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 13:06:35');
INSERT INTO njc_rates VALUES(309,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 13:06:35');
INSERT INTO njc_rates VALUES(310,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-19 13:06:35');
INSERT INTO njc_rates VALUES(311,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-20 17:37:01');
INSERT INTO njc_rates VALUES(312,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-20 17:37:01');
INSERT INTO njc_rates VALUES(313,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-20 17:37:01');
INSERT INTO njc_rates VALUES(314,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-20 17:37:01');
INSERT INTO njc_rates VALUES(315,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-20 17:37:01');
INSERT INTO njc_rates VALUES(316,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-20 17:37:01');
INSERT INTO njc_rates VALUES(317,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-20 17:37:01');
INSERT INTO njc_rates VALUES(318,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-20 17:37:01');
INSERT INTO njc_rates VALUES(319,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-20 17:37:01');
INSERT INTO njc_rates VALUES(320,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-20 17:37:01');
INSERT INTO njc_rates VALUES(321,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-21 00:22:14');
INSERT INTO njc_rates VALUES(322,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-21 00:22:14');
INSERT INTO njc_rates VALUES(323,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-21 00:22:14');
INSERT INTO njc_rates VALUES(324,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-21 00:22:14');
INSERT INTO njc_rates VALUES(325,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-21 00:22:14');
INSERT INTO njc_rates VALUES(326,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-21 00:22:14');
INSERT INTO njc_rates VALUES(327,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-21 00:22:14');
INSERT INTO njc_rates VALUES(328,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-21 00:22:14');
INSERT INTO njc_rates VALUES(329,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-21 00:22:14');
INSERT INTO njc_rates VALUES(330,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-21 00:22:14');
INSERT INTO njc_rates VALUES(331,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-21 14:35:41');
INSERT INTO njc_rates VALUES(332,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-21 14:35:41');
INSERT INTO njc_rates VALUES(333,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-21 14:35:41');
INSERT INTO njc_rates VALUES(334,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-21 14:35:41');
INSERT INTO njc_rates VALUES(335,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-21 14:35:41');
INSERT INTO njc_rates VALUES(336,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-21 14:35:41');
INSERT INTO njc_rates VALUES(337,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-21 14:35:41');
INSERT INTO njc_rates VALUES(338,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-21 14:35:41');
INSERT INTO njc_rates VALUES(339,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-21 14:35:41');
INSERT INTO njc_rates VALUES(340,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-21 14:35:41');
INSERT INTO njc_rates VALUES(341,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 04:37:02');
INSERT INTO njc_rates VALUES(342,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-24 04:37:02');
INSERT INTO njc_rates VALUES(343,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 04:37:02');
INSERT INTO njc_rates VALUES(344,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 04:37:02');
INSERT INTO njc_rates VALUES(345,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 04:37:02');
INSERT INTO njc_rates VALUES(346,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 04:37:02');
INSERT INTO njc_rates VALUES(347,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-24 04:37:02');
INSERT INTO njc_rates VALUES(348,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 04:37:02');
INSERT INTO njc_rates VALUES(349,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 04:37:02');
INSERT INTO njc_rates VALUES(350,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 04:37:02');
INSERT INTO njc_rates VALUES(351,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 04:37:44');
INSERT INTO njc_rates VALUES(352,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-24 04:37:44');
INSERT INTO njc_rates VALUES(353,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 04:37:44');
INSERT INTO njc_rates VALUES(354,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 04:37:44');
INSERT INTO njc_rates VALUES(355,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 04:37:44');
INSERT INTO njc_rates VALUES(356,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 04:37:44');
INSERT INTO njc_rates VALUES(357,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-24 04:37:44');
INSERT INTO njc_rates VALUES(358,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 04:37:44');
INSERT INTO njc_rates VALUES(359,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 04:37:44');
INSERT INTO njc_rates VALUES(360,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 04:37:44');
INSERT INTO njc_rates VALUES(361,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 04:38:32');
INSERT INTO njc_rates VALUES(362,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-24 04:38:32');
INSERT INTO njc_rates VALUES(363,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 04:38:32');
INSERT INTO njc_rates VALUES(364,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 04:38:32');
INSERT INTO njc_rates VALUES(365,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 04:38:32');
INSERT INTO njc_rates VALUES(366,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 04:38:32');
INSERT INTO njc_rates VALUES(367,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-24 04:38:32');
INSERT INTO njc_rates VALUES(368,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 04:38:32');
INSERT INTO njc_rates VALUES(369,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 04:38:32');
INSERT INTO njc_rates VALUES(370,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 04:38:32');
INSERT INTO njc_rates VALUES(371,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 04:39:17');
INSERT INTO njc_rates VALUES(372,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-24 04:39:17');
INSERT INTO njc_rates VALUES(373,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 04:39:17');
INSERT INTO njc_rates VALUES(374,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 04:39:17');
INSERT INTO njc_rates VALUES(375,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 04:39:17');
INSERT INTO njc_rates VALUES(376,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 04:39:17');
INSERT INTO njc_rates VALUES(377,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-24 04:39:17');
INSERT INTO njc_rates VALUES(378,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 04:39:17');
INSERT INTO njc_rates VALUES(379,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 04:39:17');
INSERT INTO njc_rates VALUES(380,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 04:39:17');
INSERT INTO njc_rates VALUES(381,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 04:39:55');
INSERT INTO njc_rates VALUES(382,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-24 04:39:55');
INSERT INTO njc_rates VALUES(383,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 04:39:55');
INSERT INTO njc_rates VALUES(384,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 04:39:55');
INSERT INTO njc_rates VALUES(385,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 04:39:55');
INSERT INTO njc_rates VALUES(386,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 04:39:55');
INSERT INTO njc_rates VALUES(387,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-24 04:39:55');
INSERT INTO njc_rates VALUES(388,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 04:39:55');
INSERT INTO njc_rates VALUES(389,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 04:39:55');
INSERT INTO njc_rates VALUES(390,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 04:39:55');
INSERT INTO njc_rates VALUES(391,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 22:34:45');
INSERT INTO njc_rates VALUES(392,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-24 22:34:45');
INSERT INTO njc_rates VALUES(393,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 22:34:45');
INSERT INTO njc_rates VALUES(394,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 22:34:45');
INSERT INTO njc_rates VALUES(395,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 22:34:45');
INSERT INTO njc_rates VALUES(396,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 22:34:45');
INSERT INTO njc_rates VALUES(397,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-24 22:34:45');
INSERT INTO njc_rates VALUES(398,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 22:34:45');
INSERT INTO njc_rates VALUES(399,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 22:34:45');
INSERT INTO njc_rates VALUES(400,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 22:34:45');
INSERT INTO njc_rates VALUES(401,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 22:35:29');
INSERT INTO njc_rates VALUES(402,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-24 22:35:29');
INSERT INTO njc_rates VALUES(403,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 22:35:29');
INSERT INTO njc_rates VALUES(404,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 22:35:29');
INSERT INTO njc_rates VALUES(405,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 22:35:29');
INSERT INTO njc_rates VALUES(406,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 22:35:29');
INSERT INTO njc_rates VALUES(407,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-24 22:35:29');
INSERT INTO njc_rates VALUES(408,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 22:35:29');
INSERT INTO njc_rates VALUES(409,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 22:35:29');
INSERT INTO njc_rates VALUES(410,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 22:35:29');
INSERT INTO njc_rates VALUES(411,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 22:36:07');
INSERT INTO njc_rates VALUES(412,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-24 22:36:07');
INSERT INTO njc_rates VALUES(413,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 22:36:07');
INSERT INTO njc_rates VALUES(414,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 22:36:07');
INSERT INTO njc_rates VALUES(415,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 22:36:07');
INSERT INTO njc_rates VALUES(416,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 22:36:07');
INSERT INTO njc_rates VALUES(417,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-24 22:36:07');
INSERT INTO njc_rates VALUES(418,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 22:36:07');
INSERT INTO njc_rates VALUES(419,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 22:36:07');
INSERT INTO njc_rates VALUES(420,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 22:36:07');
INSERT INTO njc_rates VALUES(421,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 22:38:02');
INSERT INTO njc_rates VALUES(422,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-24 22:38:02');
INSERT INTO njc_rates VALUES(423,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 22:38:02');
INSERT INTO njc_rates VALUES(424,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 22:38:02');
INSERT INTO njc_rates VALUES(425,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 22:38:02');
INSERT INTO njc_rates VALUES(426,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 22:38:02');
INSERT INTO njc_rates VALUES(427,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-24 22:38:02');
INSERT INTO njc_rates VALUES(428,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 22:38:02');
INSERT INTO njc_rates VALUES(429,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 22:38:02');
INSERT INTO njc_rates VALUES(430,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 22:38:02');
INSERT INTO njc_rates VALUES(431,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 22:40:29');
INSERT INTO njc_rates VALUES(432,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-24 22:40:29');
INSERT INTO njc_rates VALUES(433,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 22:40:29');
INSERT INTO njc_rates VALUES(434,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 22:40:29');
INSERT INTO njc_rates VALUES(435,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 22:40:29');
INSERT INTO njc_rates VALUES(436,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 22:40:29');
INSERT INTO njc_rates VALUES(437,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-24 22:40:29');
INSERT INTO njc_rates VALUES(438,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 22:40:29');
INSERT INTO njc_rates VALUES(439,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 22:40:29');
INSERT INTO njc_rates VALUES(440,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 22:40:29');
INSERT INTO njc_rates VALUES(441,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 22:40:44');
INSERT INTO njc_rates VALUES(442,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-24 22:40:44');
INSERT INTO njc_rates VALUES(443,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 22:40:44');
INSERT INTO njc_rates VALUES(444,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 22:40:44');
INSERT INTO njc_rates VALUES(445,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 22:40:44');
INSERT INTO njc_rates VALUES(446,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 22:40:44');
INSERT INTO njc_rates VALUES(447,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-24 22:40:44');
INSERT INTO njc_rates VALUES(448,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 22:40:44');
INSERT INTO njc_rates VALUES(449,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 22:40:44');
INSERT INTO njc_rates VALUES(450,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 22:40:44');
INSERT INTO njc_rates VALUES(451,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 22:44:37');
INSERT INTO njc_rates VALUES(452,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-24 22:44:37');
INSERT INTO njc_rates VALUES(453,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 22:44:37');
INSERT INTO njc_rates VALUES(454,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 22:44:37');
INSERT INTO njc_rates VALUES(455,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 22:44:37');
INSERT INTO njc_rates VALUES(456,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 22:44:37');
INSERT INTO njc_rates VALUES(457,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-24 22:44:37');
INSERT INTO njc_rates VALUES(458,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 22:44:37');
INSERT INTO njc_rates VALUES(459,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 22:44:37');
INSERT INTO njc_rates VALUES(460,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 22:44:37');
INSERT INTO njc_rates VALUES(461,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 22:45:00');
INSERT INTO njc_rates VALUES(462,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 22:45:00');
INSERT INTO njc_rates VALUES(463,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-24 22:45:00');
INSERT INTO njc_rates VALUES(464,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 22:45:00');
INSERT INTO njc_rates VALUES(465,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 22:45:00');
INSERT INTO njc_rates VALUES(466,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 22:45:00');
INSERT INTO njc_rates VALUES(467,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 22:45:00');
INSERT INTO njc_rates VALUES(468,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-24 22:45:00');
INSERT INTO njc_rates VALUES(469,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 22:45:00');
INSERT INTO njc_rates VALUES(470,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 22:45:00');
INSERT INTO njc_rates VALUES(471,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 22:48:01');
INSERT INTO njc_rates VALUES(472,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-24 22:48:01');
INSERT INTO njc_rates VALUES(473,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 22:48:01');
INSERT INTO njc_rates VALUES(474,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 22:48:01');
INSERT INTO njc_rates VALUES(475,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 22:48:01');
INSERT INTO njc_rates VALUES(476,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 22:48:01');
INSERT INTO njc_rates VALUES(477,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-24 22:48:01');
INSERT INTO njc_rates VALUES(478,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 22:48:01');
INSERT INTO njc_rates VALUES(479,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 22:48:01');
INSERT INTO njc_rates VALUES(480,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 22:48:01');
INSERT INTO njc_rates VALUES(481,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 22:49:06');
INSERT INTO njc_rates VALUES(482,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-24 22:49:06');
INSERT INTO njc_rates VALUES(483,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 22:49:06');
INSERT INTO njc_rates VALUES(484,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 22:49:06');
INSERT INTO njc_rates VALUES(485,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 22:49:06');
INSERT INTO njc_rates VALUES(486,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-24 22:49:06');
INSERT INTO njc_rates VALUES(487,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-24 22:49:06');
INSERT INTO njc_rates VALUES(488,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 22:49:06');
INSERT INTO njc_rates VALUES(489,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 22:49:06');
INSERT INTO njc_rates VALUES(490,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-24 22:49:06');
INSERT INTO njc_rates VALUES(491,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-25 01:37:44');
INSERT INTO njc_rates VALUES(492,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-25 01:37:44');
INSERT INTO njc_rates VALUES(493,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-25 01:37:44');
INSERT INTO njc_rates VALUES(494,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-25 01:37:44');
INSERT INTO njc_rates VALUES(495,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-25 01:37:44');
INSERT INTO njc_rates VALUES(496,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-25 01:37:44');
INSERT INTO njc_rates VALUES(497,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-25 01:37:44');
INSERT INTO njc_rates VALUES(498,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-25 01:37:44');
INSERT INTO njc_rates VALUES(499,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-25 01:37:44');
INSERT INTO njc_rates VALUES(500,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-25 01:37:44');
INSERT INTO njc_rates VALUES(501,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-25 01:38:18');
INSERT INTO njc_rates VALUES(502,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-25 01:38:18');
INSERT INTO njc_rates VALUES(503,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-25 01:38:18');
INSERT INTO njc_rates VALUES(504,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-25 01:38:18');
INSERT INTO njc_rates VALUES(505,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-25 01:38:18');
INSERT INTO njc_rates VALUES(506,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-25 01:38:18');
INSERT INTO njc_rates VALUES(507,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-25 01:38:18');
INSERT INTO njc_rates VALUES(508,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-25 01:38:18');
INSERT INTO njc_rates VALUES(509,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-25 01:38:18');
INSERT INTO njc_rates VALUES(510,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-25 01:38:18');
INSERT INTO njc_rates VALUES(511,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-25 02:50:37');
INSERT INTO njc_rates VALUES(512,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-25 02:50:37');
INSERT INTO njc_rates VALUES(513,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-25 02:50:37');
INSERT INTO njc_rates VALUES(514,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-25 02:50:37');
INSERT INTO njc_rates VALUES(515,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-25 02:50:37');
INSERT INTO njc_rates VALUES(516,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-25 02:50:37');
INSERT INTO njc_rates VALUES(517,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-25 02:50:37');
INSERT INTO njc_rates VALUES(518,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-25 02:50:37');
INSERT INTO njc_rates VALUES(519,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-25 02:50:37');
INSERT INTO njc_rates VALUES(520,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-25 02:50:37');
INSERT INTO njc_rates VALUES(521,'incidentals',30.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-27 01:57:43');
INSERT INTO njc_rates VALUES(522,'vehicle',0.6099999999999999867,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year km rate','system','2026-02-27 01:57:43');
INSERT INTO njc_rates VALUES(523,'breakfast',23.44999999999999929,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-27 01:57:43');
INSERT INTO njc_rates VALUES(524,'lunch',29.75,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-27 01:57:43');
INSERT INTO njc_rates VALUES(525,'dinner',47.04999999999999716,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-27 01:57:43');
INSERT INTO njc_rates VALUES(526,'incidentals',32.0799999999999983,'2024-04-01',NULL,'ALL','2024-2025 fiscal year rates','system','2026-02-27 01:57:43');
INSERT INTO njc_rates VALUES(527,'vehicle',0.6800000000000000488,'2024-04-01',NULL,'ALL','2024-2025 fiscal year km rate','system','2026-02-27 01:57:43');
INSERT INTO njc_rates VALUES(528,'breakfast',23.0,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-27 01:57:43');
INSERT INTO njc_rates VALUES(529,'lunch',28.5,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-27 01:57:43');
INSERT INTO njc_rates VALUES(530,'dinner',45.75,'2023-04-01','2024-03-31','ALL','2023-2024 fiscal year rates','system','2026-02-27 01:57:43');
CREATE TABLE expense_audit_log (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            expense_id INTEGER NOT NULL,
            action TEXT NOT NULL,
            actor_id INTEGER NOT NULL,
            actor_name TEXT NOT NULL,
            comment TEXT,
            previous_status TEXT,
            new_status TEXT,
            timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (expense_id) REFERENCES expenses (id),
            FOREIGN KEY (actor_id) REFERENCES employees (id)
        );
INSERT INTO expense_audit_log VALUES(1,87,'submitted',6,'Anna Lee','other expense submitted: $25.5 at N/A',NULL,'pending','2026-02-19 00:34:39');
INSERT INTO expense_audit_log VALUES(2,88,'submitted',6,'Anna Lee','other expense submitted: $15.99 at N/A',NULL,'pending','2026-02-19 00:34:57');
INSERT INTO expense_audit_log VALUES(3,89,'submitted',6,'Anna Lee','breakfast expense submitted: $12.5 at N/A',NULL,'pending','2026-02-19 00:35:37');
INSERT INTO expense_audit_log VALUES(4,90,'submitted',6,'Anna Lee','other expense submitted: $45.99 at Office',NULL,'pending','2026-02-19 00:57:09');
INSERT INTO expense_audit_log VALUES(5,91,'submitted',3,'Anna Lee Updated','lunch expense submitted: $29.75 at Toronto, ON',NULL,'pending','2026-02-19 04:12:45');
INSERT INTO expense_audit_log VALUES(6,92,'submitted',3,'Anna Lee Updated','lunch expense submitted: $29.75 at Vancouver, BC',NULL,'pending','2026-02-19 04:14:16');
INSERT INTO expense_audit_log VALUES(7,93,'submitted',6,'Anna Lee','lunch expense submitted: $15.5 at Ottawa, ON',NULL,'pending','2026-02-19 04:53:08');
INSERT INTO expense_audit_log VALUES(8,93,'approved',4,'Lisa Brown','Approved for test workflow',NULL,'approved','2026-02-19 04:54:07');
INSERT INTO expense_audit_log VALUES(9,94,'submitted',6,'Anna Lee','breakfast expense submitted: $23.45 at Toronto, ON',NULL,'pending','2026-02-19 04:55:06');
INSERT INTO expense_audit_log VALUES(10,95,'submitted',6,'Anna Lee','other expense submitted: $85.5 at Toronto, ON',NULL,'pending','2026-02-19 04:55:10');
INSERT INTO expense_audit_log VALUES(11,96,'submitted',6,'Anna Lee','lunch expense submitted: $29.75 at Montreal, QC',NULL,'pending','2026-02-19 04:55:32');
INSERT INTO expense_audit_log VALUES(12,97,'submitted',6,'Anna Lee','other expense submitted: $25 at Ottawa, ON',NULL,'pending','2026-02-19 04:58:17');
INSERT INTO expense_audit_log VALUES(13,98,'submitted',6,'Anna Lee','other expense submitted: $25.5 at Toronto, ON',NULL,'pending','2026-02-19 05:15:34');
CREATE TABLE login_audit_log (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT NOT NULL,
            employee_id INTEGER,
            success INTEGER NOT NULL,
            failure_reason TEXT,
            ip_address TEXT,
            user_agent TEXT,
            timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (employee_id) REFERENCES employees (id)
        );
INSERT INTO login_audit_log VALUES(1,'john.smith@company.com',1,0,'Invalid password','::1','curl/8.7.1','2026-02-18 17:41:38');
INSERT INTO login_audit_log VALUES(2,'john.smith@company.com',1,0,'Invalid password','::1','curl/8.7.1','2026-02-18 17:41:45');
INSERT INTO login_audit_log VALUES(3,'john.smith@company.com',1,1,NULL,'::1','curl/8.7.1','2026-02-18 17:41:52');
INSERT INTO login_audit_log VALUES(4,'john.smith@company.com',1,1,NULL,'::1','curl/8.7.1','2026-02-18 17:43:58');
INSERT INTO login_audit_log VALUES(5,'sarah.johnson@company.com',2,1,NULL,'::1','curl/8.7.1','2026-02-18 17:45:37');
INSERT INTO login_audit_log VALUES(6,'anna.lee@company.com',6,1,NULL,'::1','curl/8.7.1','2026-02-18 17:46:45');
INSERT INTO login_audit_log VALUES(7,'john.smith@company.com',1,1,NULL,'::1','curl/8.7.1','2026-02-18 22:44:34');
INSERT INTO login_audit_log VALUES(8,'sarah.johnson@company.com',2,1,NULL,'::1','curl/8.7.1','2026-02-18 22:44:38');
INSERT INTO login_audit_log VALUES(9,'anna.lee@company.com',6,1,NULL,'::1','curl/8.7.1','2026-02-18 22:44:43');
INSERT INTO login_audit_log VALUES(10,'anna.lee@company.com',6,1,NULL,'::1','curl/8.7.1','2026-02-19 00:34:31');
INSERT INTO login_audit_log VALUES(11,'anna.lee@company.com',6,1,NULL,'::1','curl/8.7.1','2026-02-19 00:35:34');
INSERT INTO login_audit_log VALUES(12,'anna.lee@company.com',6,1,NULL,'::1','curl/8.7.1','2026-02-19 00:57:09');
INSERT INTO login_audit_log VALUES(13,'john.smith@company.com',1,1,NULL,'::1','curl/8.7.1','2026-02-19 02:48:21');
INSERT INTO login_audit_log VALUES(14,'john.smith@company.com',1,1,NULL,'::1','curl/8.7.1','2026-02-19 02:58:16');
INSERT INTO login_audit_log VALUES(15,'john.smith@company.com',1,1,NULL,'::1','curl/8.7.1','2026-02-19 03:06:04');
INSERT INTO login_audit_log VALUES(16,'john.smith@company.com',1,1,NULL,'::1','curl/8.7.1','2026-02-19 03:08:53');
INSERT INTO login_audit_log VALUES(17,'john.smith@company.com',1,1,NULL,'::1','curl/8.7.1','2026-02-19 03:10:29');
INSERT INTO login_audit_log VALUES(18,'john.smith@company.com',1,1,NULL,'::1','axios/1.13.5','2026-02-19 03:37:31');
INSERT INTO login_audit_log VALUES(19,'john.smith@company.com',1,1,NULL,'::1','axios/1.13.5','2026-02-19 03:37:45');
INSERT INTO login_audit_log VALUES(20,'john.smith@company.com',1,1,NULL,'::1','axios/1.13.5','2026-02-19 03:38:00');
INSERT INTO login_audit_log VALUES(21,'test1771472280284@company.com',409,1,NULL,'::1','axios/1.13.5','2026-02-19 03:38:00');
INSERT INTO login_audit_log VALUES(22,'john.smith@company.com',1,1,NULL,'::1','axios/1.13.5','2026-02-19 03:38:25');
INSERT INTO login_audit_log VALUES(23,'john.smith@company.com',1,1,NULL,'::1','axios/1.13.5','2026-02-19 03:39:23');
INSERT INTO login_audit_log VALUES(24,'complete1771472363779@company.com',412,1,NULL,'::1','axios/1.13.5','2026-02-19 03:39:23');
INSERT INTO login_audit_log VALUES(25,'mike.davis@company.com',3,1,NULL,'::1','curl/8.7.1','2026-02-19 04:12:24');
INSERT INTO login_audit_log VALUES(26,'mike.davis@company.com',3,1,NULL,'::1','curl/8.7.1','2026-02-19 04:13:31');
INSERT INTO login_audit_log VALUES(27,'sarah.johnson@company.com',2,1,NULL,'::1','curl/8.7.1','2026-02-19 04:13:39');
INSERT INTO login_audit_log VALUES(28,'mike.davis@company.com',3,1,NULL,'::1','curl/8.7.1','2026-02-19 04:13:47');
INSERT INTO login_audit_log VALUES(29,'anna.lee@company.com',6,1,NULL,'::1','curl/8.7.1','2026-02-19 04:52:45');
INSERT INTO login_audit_log VALUES(30,'anna.lee@company.com',6,1,NULL,'::1','curl/8.7.1','2026-02-19 04:53:18');
INSERT INTO login_audit_log VALUES(31,'sarah.johnson@company.com',2,1,NULL,'::1','curl/8.7.1','2026-02-19 04:53:55');
INSERT INTO login_audit_log VALUES(32,'lisa.brown@company.com',4,1,NULL,'::1','curl/8.7.1','2026-02-19 04:54:04');
INSERT INTO login_audit_log VALUES(33,'anna.lee@company.com',6,1,NULL,'::1','curl/8.7.1','2026-02-19 04:54:11');
INSERT INTO login_audit_log VALUES(34,'lisa.brown@company.com',4,1,NULL,'::1','curl/8.7.1','2026-02-19 04:54:49');
INSERT INTO login_audit_log VALUES(35,'anna.lee@company.com',6,1,NULL,'::1','curl/8.7.1','2026-02-19 04:54:57');
INSERT INTO login_audit_log VALUES(36,'john.smith@company.com',1,1,NULL,'::1','curl/8.7.1','2026-02-19 04:56:04');
INSERT INTO login_audit_log VALUES(37,'anna.lee@company.com',6,1,NULL,'::1','curl/8.7.1','2026-02-19 04:57:08');
INSERT INTO login_audit_log VALUES(38,'lisa.brown@company.com',4,1,NULL,'::1','curl/8.7.1','2026-02-19 04:57:16');
INSERT INTO login_audit_log VALUES(39,'anna.lee@company.com',6,1,NULL,'::1','curl/8.7.1','2026-02-19 04:57:23');
INSERT INTO login_audit_log VALUES(40,'john.smith@company.com',1,1,NULL,'::1','curl/8.7.1','2026-02-19 05:14:56');
INSERT INTO login_audit_log VALUES(41,'anna.lee@company.com',6,1,NULL,'::1','curl/8.7.1','2026-02-19 05:15:03');
INSERT INTO login_audit_log VALUES(42,'anna.lee@company.com',6,1,NULL,'::1','curl/8.7.1','2026-02-19 05:15:19');
INSERT INTO login_audit_log VALUES(43,'anna.lee@company.com',6,1,NULL,'::1','curl/8.7.1','2026-02-19 05:15:26');
INSERT INTO login_audit_log VALUES(44,'anna.lee@company.com',6,1,NULL,'::1','curl/8.7.1','2026-02-19 05:15:30');
INSERT INTO login_audit_log VALUES(45,'anna.lee@company.com',6,1,NULL,'::1','curl/8.7.1','2026-02-19 05:15:34');
INSERT INTO login_audit_log VALUES(46,'anna.lee@company.com',6,1,NULL,'::1','curl/8.7.1','2026-02-19 05:15:39');
INSERT INTO login_audit_log VALUES(47,'anna.lee@company.com',6,1,NULL,'::1','curl/8.7.1','2026-02-19 05:15:43');
INSERT INTO login_audit_log VALUES(48,'anna.lee@company.com',6,1,NULL,'::1','curl/8.7.1','2026-02-19 05:15:46');
INSERT INTO login_audit_log VALUES(49,'anna.lee@company.com',6,1,NULL,'::1','curl/8.7.1','2026-02-19 05:15:51');
INSERT INTO login_audit_log VALUES(50,'anna.lee@company.com',6,1,NULL,'::1','curl/8.7.1','2026-02-19 05:16:12');
INSERT INTO login_audit_log VALUES(51,'john.smith@company.com',1,1,NULL,'::1','curl/8.7.1','2026-02-19 05:16:18');
INSERT INTO login_audit_log VALUES(52,'john.smith@company.com',1,1,NULL,'::1','curl/8.7.1','2026-02-19 05:16:32');
INSERT INTO login_audit_log VALUES(53,'sarah.johnson@company.com',2,1,NULL,'::1','curl/8.7.1','2026-02-19 05:16:36');
INSERT INTO login_audit_log VALUES(54,'mike.wilson@company.com',NULL,0,'User not found','::1','curl/8.7.1','2026-02-19 05:16:39');
INSERT INTO login_audit_log VALUES(55,'james.brown@company.com',NULL,0,'User not found','::1','curl/8.7.1','2026-02-19 05:16:44');
INSERT INTO login_audit_log VALUES(56,'sarah.johnson@company.com',2,1,NULL,'::1','curl/8.7.1','2026-02-19 05:16:48');
INSERT INTO login_audit_log VALUES(57,'john.smith@company.com',1,1,NULL,'::1','curl/8.7.1','2026-02-19 05:16:53');
INSERT INTO login_audit_log VALUES(58,'lisa.brown@company.com',4,1,NULL,'::1','curl/8.7.1','2026-02-19 05:16:57');
INSERT INTO login_audit_log VALUES(59,'lisa.brown@company.com',4,1,NULL,'::1','curl/8.7.1','2026-02-19 05:17:00');
INSERT INTO login_audit_log VALUES(60,'anna.lee@company.com',6,1,NULL,'::1','curl/8.7.1','2026-02-19 05:17:07');
INSERT INTO login_audit_log VALUES(61,'anna.lee@company.com',6,1,NULL,'::1','curl/8.7.1','2026-02-19 05:17:11');
INSERT INTO login_audit_log VALUES(62,'anna.lee@company.com',6,1,NULL,'::1','curl/8.7.1','2026-02-19 05:17:20');
INSERT INTO login_audit_log VALUES(63,'anna.lee@company.com',6,1,NULL,'::1','curl/8.7.1','2026-02-19 05:17:30');
INSERT INTO login_audit_log VALUES(64,'john.smith@company.com',1,1,NULL,'::1','curl/8.7.1','2026-02-19 05:17:40');
INSERT INTO login_audit_log VALUES(65,'john.smith@company.com',1,1,NULL,'::1','curl/8.7.1','2026-02-19 05:17:49');
INSERT INTO login_audit_log VALUES(66,'john.smith@company.com',1,1,NULL,'::1','curl/8.7.1','2026-02-19 05:17:58');
INSERT INTO login_audit_log VALUES(67,'john.smith@company.com',1,1,NULL,'::1','curl/8.7.1','2026-02-19 05:18:08');
INSERT INTO login_audit_log VALUES(68,'david.wilson@company.com',5,1,NULL,'::1','curl/8.7.1','2026-02-19 12:57:27');
INSERT INTO login_audit_log VALUES(69,'david.wilson@company.com',5,1,NULL,'::1','curl/8.7.1','2026-02-19 12:58:50');
INSERT INTO login_audit_log VALUES(70,'david.wilson@company.com',5,1,NULL,'::1','curl/8.7.1','2026-02-19 12:59:18');
INSERT INTO login_audit_log VALUES(71,'anna.lee@company.com',6,1,NULL,'::1','curl/8.7.1','2026-02-19 13:06:44');
INSERT INTO login_audit_log VALUES(72,'anna.lee@company.com',6,1,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','2026-02-19 13:07:20');
INSERT INTO login_audit_log VALUES(73,'lisa.brown@company.com',4,1,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','2026-02-19 13:08:10');
INSERT INTO login_audit_log VALUES(74,'anna.lee@company.com',6,1,NULL,'::1','curl/8.7.1','2026-02-20 17:37:04');
INSERT INTO login_audit_log VALUES(75,'anna.lee@company.com',6,1,NULL,'::1','curl/8.7.1','2026-02-25 01:38:32');
INSERT INTO login_audit_log VALUES(76,'anna.lee@company.com',6,1,NULL,'::1','Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36','2026-02-25 01:40:17');
INSERT INTO login_audit_log VALUES(77,'anna.lee@company.com',6,1,NULL,'::1','curl/8.7.1','2026-02-25 02:50:59');
INSERT INTO login_audit_log VALUES(78,'lisa.brown@company.com',4,1,NULL,'::1','curl/8.7.1','2026-02-25 02:51:00');
INSERT INTO login_audit_log VALUES(79,'anna.lee@company.com',6,1,NULL,'::1','curl/8.7.1','2026-02-25 02:51:05');
INSERT INTO login_audit_log VALUES(80,'anna.lee@company.com',6,1,NULL,'::1','curl/8.7.1','2026-02-25 02:51:10');
INSERT INTO login_audit_log VALUES(81,'anna.lee@company.com',6,1,NULL,'::1','curl/8.7.1','2026-02-25 02:51:17');
INSERT INTO login_audit_log VALUES(82,'anna.lee@company.com',6,1,NULL,'::1','curl/8.7.1','2026-02-25 02:51:32');
INSERT INTO login_audit_log VALUES(83,'lisa.brown@company.com',4,1,NULL,'::1','curl/8.7.1','2026-02-25 02:51:32');
CREATE TABLE employee_audit_log (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            employee_id INTEGER NOT NULL,
            action TEXT NOT NULL,
            field_changed TEXT,
            old_value TEXT,
            new_value TEXT,
            performed_by INTEGER NOT NULL,
            performed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (employee_id) REFERENCES employees (id),
            FOREIGN KEY (performed_by) REFERENCES employees (id)
        );
INSERT INTO employee_audit_log VALUES(1,381,'created','name',NULL,'Test Audit Employee',1,'2026-02-19 02:48:32');
INSERT INTO employee_audit_log VALUES(2,381,'created',NULL,NULL,'Employee record created',1,'2026-02-19 02:48:32');
INSERT INTO employee_audit_log VALUES(3,381,'created','position',NULL,'Audit Test Position',1,'2026-02-19 02:48:32');
INSERT INTO employee_audit_log VALUES(4,381,'created','department',NULL,'Audit Testing',1,'2026-02-19 02:48:32');
INSERT INTO employee_audit_log VALUES(5,381,'created','employee_number',NULL,'AUDIT001',1,'2026-02-19 02:48:32');
INSERT INTO employee_audit_log VALUES(6,381,'updated','name','Test Audit Employee','Updated Audit Employee',1,'2026-02-19 02:48:36');
INSERT INTO employee_audit_log VALUES(7,381,'updated','department','Audit Testing','Advanced Audit Testing',1,'2026-02-19 02:48:36');
INSERT INTO employee_audit_log VALUES(8,381,'updated','position','Audit Test Position','Senior Audit Test Position',1,'2026-02-19 02:48:36');
INSERT INTO employee_audit_log VALUES(9,381,'updated',NULL,NULL,'Employee record updated',1,'2026-02-19 02:48:36');
INSERT INTO employee_audit_log VALUES(10,381,'deleted','name','Updated Audit Employee',NULL,1,'2026-02-19 02:48:44');
INSERT INTO employee_audit_log VALUES(11,381,'deleted',NULL,NULL,'Employee record deleted: Updated Audit Employee (AUDIT001)',1,'2026-02-19 02:48:44');
INSERT INTO employee_audit_log VALUES(12,381,'deleted','position','Senior Audit Test Position',NULL,1,'2026-02-19 02:48:44');
INSERT INTO employee_audit_log VALUES(13,381,'deleted','employee_number','AUDIT001',NULL,1,'2026-02-19 02:48:44');
INSERT INTO employee_audit_log VALUES(14,381,'deleted','department','Advanced Audit Testing',NULL,1,'2026-02-19 02:48:44');
INSERT INTO employee_audit_log VALUES(15,3,'updated','name','Mike Davis','Anna Lee Updated',1,'2026-02-19 02:58:19');
INSERT INTO employee_audit_log VALUES(16,3,'updated','position','Accountant','Senior Developer',1,'2026-02-19 02:58:19');
INSERT INTO employee_audit_log VALUES(17,3,'updated','department','Finance','IT Updated',1,'2026-02-19 02:58:19');
INSERT INTO employee_audit_log VALUES(18,3,'updated',NULL,NULL,'Employee record updated',1,'2026-02-19 02:58:19');
INSERT INTO employee_audit_log VALUES(19,388,'created','name',NULL,'Will can',1,'2026-02-19 03:01:14');
INSERT INTO employee_audit_log VALUES(20,388,'created','supervisor_id',NULL,'186',1,'2026-02-19 03:01:14');
INSERT INTO employee_audit_log VALUES(21,388,'created',NULL,NULL,'Employee record created',1,'2026-02-19 03:01:14');
INSERT INTO employee_audit_log VALUES(22,388,'created','department',NULL,'Finance',1,'2026-02-19 03:01:14');
INSERT INTO employee_audit_log VALUES(23,388,'created','employee_number',NULL,'007',1,'2026-02-19 03:01:14');
INSERT INTO employee_audit_log VALUES(24,388,'created','position',NULL,'financial analyst',1,'2026-02-19 03:01:14');
INSERT INTO employee_audit_log VALUES(25,395,'created','name',NULL,'Jim Sam',1,'2026-02-19 03:06:08');
INSERT INTO employee_audit_log VALUES(26,395,'created','supervisor_id',NULL,'186',1,'2026-02-19 03:06:08');
INSERT INTO employee_audit_log VALUES(27,395,'created',NULL,NULL,'Employee record created',1,'2026-02-19 03:06:08');
INSERT INTO employee_audit_log VALUES(28,395,'created','department',NULL,'Finance',1,'2026-02-19 03:06:08');
INSERT INTO employee_audit_log VALUES(29,395,'created','employee_number',NULL,'223',1,'2026-02-19 03:06:08');
INSERT INTO employee_audit_log VALUES(30,395,'created','position',NULL,'Financial Analyst',1,'2026-02-19 03:06:08');
INSERT INTO employee_audit_log VALUES(31,402,'created','name',NULL,'Test Fix',1,'2026-02-19 03:08:53');
INSERT INTO employee_audit_log VALUES(32,402,'created',NULL,NULL,'Employee record created',1,'2026-02-19 03:08:53');
INSERT INTO employee_audit_log VALUES(33,402,'created','position',NULL,'Tester',1,'2026-02-19 03:08:53');
INSERT INTO employee_audit_log VALUES(34,402,'created','department',NULL,'QA',1,'2026-02-19 03:08:53');
INSERT INTO employee_audit_log VALUES(35,402,'created','employee_number',NULL,'999',1,'2026-02-19 03:08:53');
INSERT INTO employee_audit_log VALUES(36,409,'created','name',NULL,'Test Employee',1,'2026-02-19 03:38:00');
INSERT INTO employee_audit_log VALUES(37,409,'created','supervisor_id',NULL,'2',1,'2026-02-19 03:38:00');
INSERT INTO employee_audit_log VALUES(38,409,'created',NULL,NULL,'Employee record created',1,'2026-02-19 03:38:00');
INSERT INTO employee_audit_log VALUES(39,409,'created','position',NULL,'Test Position',1,'2026-02-19 03:38:00');
INSERT INTO employee_audit_log VALUES(40,409,'created','employee_number',NULL,'TEST1771472280284',1,'2026-02-19 03:38:00');
INSERT INTO employee_audit_log VALUES(41,409,'created','department',NULL,'Test Department',1,'2026-02-19 03:38:00');
INSERT INTO employee_audit_log VALUES(42,410,'created','name',NULL,'Test Employee 2',1,'2026-02-19 03:38:00');
INSERT INTO employee_audit_log VALUES(43,410,'created','supervisor_id',NULL,'2',1,'2026-02-19 03:38:00');
INSERT INTO employee_audit_log VALUES(44,410,'created',NULL,NULL,'Employee record created',1,'2026-02-19 03:38:00');
INSERT INTO employee_audit_log VALUES(45,410,'created','department',NULL,'Test Department',1,'2026-02-19 03:38:00');
INSERT INTO employee_audit_log VALUES(46,410,'created','employee_number',NULL,'TEST21771472280284',1,'2026-02-19 03:38:00');
INSERT INTO employee_audit_log VALUES(47,410,'created','position',NULL,'Test Position 2',1,'2026-02-19 03:38:00');
INSERT INTO employee_audit_log VALUES(48,411,'created','name',NULL,'Demo Employee',1,'2026-02-19 03:38:25');
INSERT INTO employee_audit_log VALUES(49,411,'created','supervisor_id',NULL,'2',1,'2026-02-19 03:38:25');
INSERT INTO employee_audit_log VALUES(50,411,'created',NULL,NULL,'Employee record created',1,'2026-02-19 03:38:25');
INSERT INTO employee_audit_log VALUES(51,411,'created','position',NULL,'Demo Position',1,'2026-02-19 03:38:25');
INSERT INTO employee_audit_log VALUES(52,411,'created','employee_number',NULL,'DEMO1771472305779',1,'2026-02-19 03:38:25');
INSERT INTO employee_audit_log VALUES(53,411,'created','department',NULL,'Demo Department',1,'2026-02-19 03:38:25');
INSERT INTO employee_audit_log VALUES(54,412,'created','name',NULL,'Complete Test Employee',1,'2026-02-19 03:39:23');
INSERT INTO employee_audit_log VALUES(55,412,'created','supervisor_id',NULL,'2',1,'2026-02-19 03:39:23');
INSERT INTO employee_audit_log VALUES(56,412,'created',NULL,NULL,'Employee record created',1,'2026-02-19 03:39:23');
INSERT INTO employee_audit_log VALUES(57,412,'created','position',NULL,'Test Position',1,'2026-02-19 03:39:23');
INSERT INTO employee_audit_log VALUES(58,412,'created','employee_number',NULL,'COMPLETE1771472363779',1,'2026-02-19 03:39:23');
INSERT INTO employee_audit_log VALUES(59,412,'created','department',NULL,'Test Department',1,'2026-02-19 03:39:23');
INSERT INTO employee_audit_log VALUES(60,449,'created','name',NULL,'Test Employee Phase3',1,'2026-02-19 04:56:08');
INSERT INTO employee_audit_log VALUES(61,449,'created','supervisor_id',NULL,'4',1,'2026-02-19 04:56:08');
INSERT INTO employee_audit_log VALUES(62,449,'created',NULL,NULL,'Employee record created',1,'2026-02-19 04:56:08');
INSERT INTO employee_audit_log VALUES(63,449,'created','department',NULL,'Testing',1,'2026-02-19 04:56:08');
INSERT INTO employee_audit_log VALUES(64,449,'created','position',NULL,'Test Coordinator',1,'2026-02-19 04:56:08');
INSERT INTO employee_audit_log VALUES(65,449,'created','employee_number',NULL,'EMP999',1,'2026-02-19 04:56:08');
INSERT INTO employee_audit_log VALUES(66,449,'updated','position','Test Coordinator','Senior Test Coordinator',1,'2026-02-19 04:56:26');
INSERT INTO employee_audit_log VALUES(67,449,'updated','department','Testing','Quality Assurance',1,'2026-02-19 04:56:26');
INSERT INTO employee_audit_log VALUES(68,449,'updated',NULL,NULL,'Employee record updated',1,'2026-02-19 04:56:26');
INSERT INTO employee_audit_log VALUES(69,449,'deleted','name','Test Employee Phase3',NULL,1,'2026-02-19 04:56:29');
INSERT INTO employee_audit_log VALUES(70,449,'deleted','supervisor_id','4',NULL,1,'2026-02-19 04:56:29');
INSERT INTO employee_audit_log VALUES(71,449,'deleted',NULL,NULL,'Employee record deleted: Test Employee Phase3 (EMP999)',1,'2026-02-19 04:56:29');
INSERT INTO employee_audit_log VALUES(72,449,'deleted','employee_number','EMP999',NULL,1,'2026-02-19 04:56:29');
INSERT INTO employee_audit_log VALUES(73,449,'deleted','position','Senior Test Coordinator',NULL,1,'2026-02-19 04:56:29');
INSERT INTO employee_audit_log VALUES(74,449,'deleted','department','Quality Assurance',NULL,1,'2026-02-19 04:56:29');
INSERT INTO employee_audit_log VALUES(75,468,'created','name',NULL,'Test Final User',1,'2026-02-19 05:17:49');
INSERT INTO employee_audit_log VALUES(76,468,'created','supervisor_id',NULL,'2',1,'2026-02-19 05:17:49');
INSERT INTO employee_audit_log VALUES(77,468,'created',NULL,NULL,'Employee record created',1,'2026-02-19 05:17:49');
INSERT INTO employee_audit_log VALUES(78,468,'created','department',NULL,'QA',1,'2026-02-19 05:17:49');
INSERT INTO employee_audit_log VALUES(79,468,'created','employee_number',NULL,'FINAL001',1,'2026-02-19 05:17:49');
INSERT INTO employee_audit_log VALUES(80,468,'created','position',NULL,'Final Tester',1,'2026-02-19 05:17:49');
CREATE TABLE signup_tokens (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            employee_id INTEGER NOT NULL,
            token TEXT UNIQUE NOT NULL,
            expires_at DATETIME NOT NULL,
            used INTEGER DEFAULT 0,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (employee_id) REFERENCES employees (id)
        );
INSERT INTO signup_tokens VALUES(1,409,'9aabf358501b80de0f3be21e966ec2759c5880f85b64e391bd1af16f3eca4d0b','2026-02-21T03:38:00.285Z',1,'2026-02-19 03:38:00');
INSERT INTO signup_tokens VALUES(2,410,'a3517c995855997a3cd14100738261f2fa5a3020761274809f476d773b83386a','2026-02-21T03:38:00.293Z',1,'2026-02-19 03:38:00');
INSERT INTO signup_tokens VALUES(3,410,'bb80dbd5a5cde4d6605be54fe61c8f53eb3188a2ffa3e8feb502e80bdc6b1757','2026-02-21T03:38:00.296Z',0,'2026-02-19 03:38:00');
INSERT INTO signup_tokens VALUES(4,411,'6be4648776bee752a7936d5bc1d636ca3b16380833f09839d93e81851690d7e2','2026-02-21T03:38:25.781Z',0,'2026-02-19 03:38:25');
INSERT INTO signup_tokens VALUES(5,412,'d5921b0aeca5d5838ec66590d268e870bb5a603aef9532db0d4c5b794e319f36','2026-02-21T03:39:23.781Z',1,'2026-02-19 03:39:23');
INSERT INTO signup_tokens VALUES(6,449,'672ff2c6e2f8d69a93fea1ddeac1f0c81a10a8b317da2d0e45dc1920e5612a0c','2026-02-21T04:56:08.399Z',1,'2026-02-19 04:56:08');
INSERT INTO signup_tokens VALUES(7,468,'03df26898429685ed26dccd8d25d311327799f1459f1f2c29dd5a084172c4bb5','2026-02-21T05:17:49.810Z',0,'2026-02-19 05:17:49');
CREATE TABLE travel_authorizations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            employee_id INTEGER NOT NULL,
            trip_id INTEGER,
            destination TEXT NOT NULL,
            start_date DATE NOT NULL,
            end_date DATE NOT NULL,
            purpose TEXT NOT NULL,
            est_transport REAL DEFAULT 0,
            est_lodging REAL DEFAULT 0,
            est_meals REAL DEFAULT 0,
            est_other REAL DEFAULT 0,
            est_total REAL DEFAULT 0,
            approver_id INTEGER,
            status TEXT DEFAULT 'pending',
            rejection_reason TEXT,
            approved_at DATETIME,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            updated_at DATETIME DEFAULT CURRENT_TIMESTAMP, details TEXT, name TEXT,
            FOREIGN KEY (employee_id) REFERENCES employees (id),
            FOREIGN KEY (trip_id) REFERENCES trips (id),
            FOREIGN KEY (approver_id) REFERENCES employees (id)
        );
INSERT INTO travel_authorizations VALUES(1,3,58,'Toronto, ON','2026-03-15','2026-03-17','Quarterly training conference',350.0,300.0,150.0,50.0,850.0,2,'approved',NULL,'2026-02-19 04:13:42','2026-02-19 04:12:29','2026-02-19 04:13:42',NULL,'Toronto, ON');
INSERT INTO travel_authorizations VALUES(2,6,60,'Toronto, ON','2026-03-15','2026-03-17','Testing trip expense workflow with Travel Authorization',150.0,400.0,120.0,50.0,720.0,4,'approved',NULL,'2026-02-19 04:54:53','2026-02-19 04:54:45','2026-02-19 04:54:53',NULL,'Toronto, ON');
INSERT INTO travel_authorizations VALUES(3,6,NULL,'Vancouver, BC','2026-05-01','2026-05-03','REVISED: Testing AT rejection workflow - detailed budget breakdown provided',650.0,450.0,200.0,75.0,1375.0,4,'pending',NULL,NULL,'2026-02-19 04:57:13','2026-02-19 04:57:33','Transport breakdown: Flight YOW-YVR return $550, Airport transfers $100. Lodging reduced to $150/night. Other costs for taxi and parking.','Vancouver, BC');
INSERT INTO travel_authorizations VALUES(4,6,NULL,'Montreal, QC','2026-03-05','2026-03-07','Client meetings',500.0,400.0,300.0,100.0,1300.0,4,'approved',NULL,'2026-02-19 05:17:00','2026-02-19 05:16:12','2026-02-19 05:17:00',NULL,'Montreal, QC');
INSERT INTO travel_authorizations VALUES(5,5,NULL,'Ottawa, ON','2026-03-01','2026-03-03','test',0.0,0.0,70.5,0.0,70.5,4,'pending',NULL,NULL,'2026-02-19 12:59:18','2026-02-19 12:59:26',NULL,'Ottawa Training');
INSERT INTO travel_authorizations VALUES(6,6,63,'','2026-03-10','2026-03-12','',0.0,0.0,0.0,0.0,0.0,4,'approved',NULL,'2026-02-25 02:51:00','2026-02-25 01:38:32','2026-02-25 02:51:00','{"transport":{"flight":{"active":true,"data":{"departure":"500","return":"400","baggage":"100","route":"YOW-YUL"},"total":1000}}}','Flight Test');
INSERT INTO travel_authorizations VALUES(7,6,NULL,'Ottawa, ON','2026-03-20','2026-03-22','Test',1000.0,0.0,0.0,0.0,1000.0,4,'draft',NULL,NULL,'2026-02-25 02:50:59','2026-02-25 02:50:59','{"transport":{"flight":{"active":true,"data":{"departure":"500","return":"400","baggage":"100","route":"YOW-YUL"},"total":1000}}}','Variance Test');
INSERT INTO travel_authorizations VALUES(8,6,64,'Toronto, ON','2026-04-01','2026-04-03','Variance test',1000.0,300.0,396.9899999999999522,0.0,1696.990000000000009,4,'approved',NULL,'2026-02-25 02:51:32','2026-02-25 02:51:32','2026-02-25 02:51:32','{"transport":{"flight":{"active":true,"data":{"departure":"500","return":"400","baggage":"100"},"total":1000}}}','Variance Test 2');
CREATE TABLE app_settings (
            key TEXT PRIMARY KEY,
            value TEXT NOT NULL,
            updated_by INTEGER,
            updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
        );
INSERT INTO app_settings VALUES('variance_pct_threshold','10',NULL,'2026-02-24 22:34:45');
INSERT INTO app_settings VALUES('variance_dollar_threshold','100',NULL,'2026-02-24 22:34:45');
CREATE TABLE settings_audit_log (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            setting_key TEXT NOT NULL,
            old_value TEXT,
            new_value TEXT NOT NULL,
            changed_by INTEGER NOT NULL,
            changed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (changed_by) REFERENCES employees(id)
        );
CREATE TABLE expense_report_sequence (
            year INTEGER PRIMARY KEY,
            last_number INTEGER DEFAULT 0
        );
CREATE TABLE email_log (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            trip_id INTEGER,
            ref_number TEXT,
            recipient_type TEXT,
            recipient_email TEXT,
            subject TEXT,
            status TEXT,
            error_message TEXT,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP
        );
INSERT INTO sqlite_sequence VALUES('employees',660);
INSERT INTO sqlite_sequence VALUES('trips',64);
INSERT INTO sqlite_sequence VALUES('expenses',115);
INSERT INTO sqlite_sequence VALUES('notifications',175);
INSERT INTO sqlite_sequence VALUES('gl_accounts',361);
INSERT INTO sqlite_sequence VALUES('department_cost_centers',288);
INSERT INTO sqlite_sequence VALUES('njc_rates',530);
INSERT INTO sqlite_sequence VALUES('login_audit_log',83);
INSERT INTO sqlite_sequence VALUES('expense_audit_log',13);
INSERT INTO sqlite_sequence VALUES('employee_audit_log',80);
INSERT INTO sqlite_sequence VALUES('signup_tokens',7);
INSERT INTO sqlite_sequence VALUES('travel_authorizations',8);
COMMIT;
