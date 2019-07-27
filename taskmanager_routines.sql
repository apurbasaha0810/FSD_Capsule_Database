-- MySQL dump 10.13  Distrib 8.0.13, for Win64 (x86_64)
--
-- Host: localhost    Database: taskmanager
-- ------------------------------------------------------
-- Server version	8.0.13

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
 SET NAMES utf8 ;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping routines for database 'taskmanager'
--
/*!50003 DROP PROCEDURE IF EXISTS `addProject` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `addProject`(IN in_project_name varchar(100), IN in_start_date date, IN in_end_date date, IN in_priority int, IN in_manager_id int)
BEGIN
	INSERT project_details(project_name, start_date, end_date, priority, manager_id) VALUES (in_project_name, in_start_date, in_end_date, in_priority, in_manager_id);
    UPDATE user_details SET project_id = LAST_INSERT_ID() WHERE user_id = in_manager_id;
	SELECT project_id, project_name, start_date, end_date, priority, manager_id, no_of_tasks, no_of_tasks_completed, status FROM project_details 
	LIMIT 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `addTask` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `addTask`(IN in_task varchar(100), IN in_start_date date, 
IN in_end_date date, IN in_priority int, IN in_project_id int, IN in_parent_id int, IN in_user_id int)
BEGIN
	
    IF (in_project_id is NULL OR in_project_id = 0) THEN
		INSERT taskmanager.parent_task (parent_task)
		VALUES (in_task);
	ELSE
		INSERT into taskmanager.task (task, start_date, end_date, priority, project_id, parent_id)
		VALUES (in_task, in_start_date, in_end_date, in_priority, in_project_id, in_parent_id);
		
		UPDATE taskmanager.user_details SET task_id = LAST_INSERT_ID() WHERE user_id = in_user_id;
	END IF;
    
	SELECT 
		t.task_id,
		t.parent_id,
		t.project_id,
		t.task,
		t.start_date,
		t.end_date,
		t.priority,
		t.status,
		ud.user_id,
		(ud.first_name+' '+ud.last_name) as user_name,
		pt.parent_task,
		pd.project_name
	FROM
		task t
			LEFT JOIN
		user_details ud ON t.task_id = ud.task_id
			LEFT JOIN
		parent_task pt ON t.parent_id = pt.parent_id
			LEFT JOIN
		project_details pd ON t.project_id = pd.project_id
	LIMIT 1;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `createUser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `createUser`(IN first_name varchar(45), IN last_name varchar(45), IN employee_ID int)
BEGIN
	INSERT user_details(first_name,last_name,employee_id) VALUES (first_name,last_name,employee_ID);
	SELECT user_ID, first_name, last_name, employee_id FROM user_details 
	LIMIT 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deleteUser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteUser`(IN in_employee_id int)
BEGIN
	DELETE FROM user_details WHERE employee_id = in_employee_id;
	SELECT user_ID, first_name, last_name, employee_id FROM user_details 
	LIMIT 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `finishTask` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `finishTask`(In task_id_i varchar(10))
BEGIN
update taskmanager.task
set status='CLOSED'
where task_id=task_id_i;
SELECT t.task_id,t.parent_id,t.task,t.start_date,t.end_date,t.priority,t.status,pt.parent_task FROM task t 
left join parent_task pt on pt.parent_id=t.parent_id
left join taskmanager.task t1
on t1.task_id=pt.parent_id LIMIT 1;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getAllActiveProjects` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllActiveProjects`()
BEGIN
	SELECT project_id, project_name, start_date, end_date, priority, manager_id, status, no_of_tasks, no_of_tasks_completed
	FROM project_details
	ORDER BY priority;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getAllParentTasks` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllParentTasks`()
BEGIN
	SELECT parent_id, parent_task FROM parent_task;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getAllProjectDetails` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllProjectDetails`(IN in_sort_by varchar(50))
BEGIN
	
    IF (in_sort_by = 'start_date') THEN
		SELECT project_id, project_name, start_date, end_date, priority, manager_id, status, no_of_tasks, no_of_tasks_completed
		FROM project_details
		ORDER BY start_date;
	END IF;
    IF (in_sort_by = 'end_date') THEN
		SELECT project_id, project_name, start_date, end_date, priority, manager_id, status, no_of_tasks, no_of_tasks_completed
		FROM project_details
		ORDER BY end_date;
	END IF;
    IF (in_sort_by = 'no_of_tasks_completed') THEN
		SELECT project_id, project_name, start_date, end_date, priority, manager_id, status, no_of_tasks, no_of_tasks_completed
		FROM project_details
		ORDER BY no_of_tasks_completed;
    ELSE
		SELECT project_id, project_name, start_date, end_date, priority, manager_id, status, no_of_tasks, no_of_tasks_completed
		FROM project_details
		ORDER BY priority;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getAllUserDetails` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllUserDetails`(IN in_sort_by varchar(20), IN in_project_assigned varchar(20), IN in_task_assigned varchar(20))
BEGIN
IF (in_project_assigned = 'N') THEN
	SELECT user_id, first_name, last_name, employee_id FROM user_details WHERE employee_id IS NOT NULL AND project_id IS NULL ORDER BY first_name ASC;
END IF;
IF (in_task_assigned = 'N') THEN
	SELECT user_id, first_name, last_name, employee_id FROM user_details WHERE employee_id IS NOT NULL AND task_id IS NULL ORDER BY first_name ASC;
ELSE
	IF (in_sort_by = 'employee_id') THEN
		SELECT user_id, first_name, last_name, employee_id FROM user_details WHERE employee_id IS NOT NULL ORDER BY employee_id ASC;
	END IF;
    IF (in_sort_by = 'last_name') THEN
		SELECT user_id, first_name, last_name, employee_id FROM user_details WHERE employee_id IS NOT NULL ORDER BY last_name ASC;
    ELSE
		SELECT user_id, first_name, last_name, employee_id FROM user_details WHERE employee_id IS NOT NULL ORDER BY first_name ASC;
	END IF;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `taskDetails` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `taskDetails`(IN in_sort_by varchar(20))
BEGIN
IF (in_sort_by = 'start_date') THEN
		SELECT t.task_id,t.parent_id,t.task,t.start_date,t.end_date,t.priority,t.status,pt.parent_task,t.project_id,
		t.project_name, t.user_id, t.user_name
		FROM task t 
		left join parent_task pt on pt.parent_id=t.parent_id ORDER BY start_date;
	END IF;
    IF (in_sort_by = 'end_date') THEN
		SELECT t.task_id,t.parent_id,t.task,t.start_date,t.end_date,t.priority,t.status,pt.parent_task,t.project_id,
		t.project_name, t.user_id, t.user_name
		FROM task t 
		left join parent_task pt on pt.parent_id=t.parent_id ORDER BY end_date;
    END IF;
    IF (in_sort_by = 'priority') THEN
		SELECT t.task_id,t.parent_id,t.task,t.start_date,t.end_date,t.priority,t.status,pt.parent_task,t.project_id,
		t.project_name, t.user_id, t.user_name
		FROM task t 
		left join parent_task pt on pt.parent_id=t.parent_id ORDER BY priority;
    ELSE
		SELECT t.task_id,t.parent_id,t.task,t.start_date,t.end_date,t.priority,t.status,pt.parent_task,t.project_id,
		t.project_name, t.user_id, t.user_name
		FROM task t 
		left join parent_task pt on pt.parent_id=t.parent_id ORDER BY status;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `taskSpecificDetails` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `taskSpecificDetails`(IN task_id_i int)
BEGIN

SELECT t.task_id,t.parent_id,t.task,t.start_date,t.end_date,t.priority,t.status,
pt.parent_task,t.project_id,t.project_name,t.user_id,t.user_name FROM task t 
left join parent_task pt 
on pt.parent_id=t.parent_id
 where t.task_id=task_id_i;


END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `updateProjectStatus` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateProjectStatus`(IN in_project_id int, IN in_status varchar(20))
BEGIN
	UPDATE project_details SET status = in_status WHERE project_id = in_project_id;
    SELECT project_id, project_name, start_date, end_date, priority, manager_id, no_of_tasks, no_of_tasks_completed, status FROM project_details 
	LIMIT 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `updateSpecificTask` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateSpecificTask`(IN  task_id_i int, IN task_i varchar(100),IN start_date_i varchar(100),
IN end_date_i varchar(100),IN priority_i int,IN parent_task_i varchar(100))
BEGIN
  
  DECLARE i_parent_id INT default NULL;
  DECLARE i_parent_task_id INT default 0;
  
if(parent_task_i is null) then
update taskmanager.task
set task=task_i,
start_date=start_date_i,
end_date=end_date_i,
priority=priority_i
where task_id=task_id_i;

else
set i_parent_task_id=(select task_id 
from taskmanager.task
where upper(task)=upper(parent_task_i));

end if;

if (i_parent_task_id is NOT NULL) then
set i_parent_id=(select parent_id
from taskmanager.parent_task
where parent_task_id=i_parent_task_id);

end if;

if (i_parent_id is NULL) then
insert taskmanager.parent_task(parent_task,parent_task_id)
values(parent_task_i,i_parent_task_id);
set i_parent_id=LAST_INSERT_ID();

update taskmanager.task
set task=task_i,
parent_id=i_parent_id,
start_date=start_date_i,
end_date=end_date_i,
priority=priority_i  
where task_id=task_id_i;

else

update taskmanager.task
set task=task_i,
parent_id=i_parent_id,
start_date=start_date_i,
end_date=end_date_i,
priority=priority_i  
where task_id=task_id_i;

end if;

SELECT t.task_id,t.parent_id,t.task,t.start_date,t.end_date,t.priority,t.status,pt.parent_task FROM task t 
left join parent_task pt on t.parent_id=pt.parent_id LIMIT 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-07-27 17:10:47
