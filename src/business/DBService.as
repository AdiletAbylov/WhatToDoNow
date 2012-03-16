package business
{
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.events.SQLErrorEvent;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	
	import vo.TaskVO;
	import vo.ToDoTaskVO;
	
	public class DBService
	{
		public function DBService()
		{
			if(__instance)
			{
				throw new Error("There is should be only one DBService instance.");
			}
			_sqlConnection = new SQLConnection();
			_sqlConnection.addEventListener(SQLErrorEvent.ERROR, onSQLError);
		}
		
		protected function onSQLError(event:SQLErrorEvent):void
		{
			trace("SQL ERROR: " + event.toString() );
		}
		
		private static var __instance:DBService;
		public static function get instance():DBService
		{
			if(__instance == null)
			{
				__instance = new DBService();
			}
			return __instance;
		}
		
		private var _sqlConnection:SQLConnection;
		private const DB_NAME:String = "WhatToDoNow.db";
		
		public function initDatabase():void
		{
			if(!_sqlConnection.connected)
			{
				_sqlConnection.open( File.applicationStorageDirectory.resolvePath(DB_NAME));
				var statement:SQLStatement = new SQLStatement();
				statement.sqlConnection = _sqlConnection;
				statement.text = "CREATE TABLE IF NOT EXISTS todoList (task_id INTEGER, done BOOL DEFAULT FALSE)";
				statement.execute();
				
				statement.text = "CREATE TABLE IF NOT EXISTS tasksList(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT)";
				statement.execute();
			}
		}
		
		public function getToDoNowList():ArrayCollection
		{
			var list:ArrayCollection;
			var statement:SQLStatement = new SQLStatement();
			statement.sqlConnection = _sqlConnection;
			statement.text = "SELECT tasksList.id, tasksList.name, todoList.done FROM todoList, tasksList WHERE tasksList.id=todoList.task_id";
			statement.execute();
			statement.itemClass = ToDoTaskVO;
			list = new ArrayCollection( statement.getResult().data );
			return list;
		}
		
		public function getTasksList():ArrayCollection
		{
			var list:ArrayCollection;
			var statement:SQLStatement = new SQLStatement();
			statement.sqlConnection = _sqlConnection;
			statement.text = "SELECT tasksList.id, tasksList.name, ifnull(todoList.done, null) as added FROM tasksList LEFT JOIN todoList ON tasksList.id=todoList.task_id";
			statement.execute();
			statement.itemClass = TaskVO;
			list = new ArrayCollection( statement.getResult().data );
			return list;
		}
		
		public function addTask(task:TaskVO):void
		{
			var statement:SQLStatement = new SQLStatement();
			statement.sqlConnection = _sqlConnection;
			statement.text = "INSERT INTO tasksList(name) VALUES(:taskname)";
			statement.parameters[":taskname"] = task.name;
			statement.execute();
		}
		
		public function editTask(task:TaskVO):void
		{
			var statement:SQLStatement = new SQLStatement();
			statement.sqlConnection = _sqlConnection;
			statement.text = "UPDATE tasksList SET name = :taskname WHERE id=:taskid";
			statement.parameters[":taskname"] = task.name;
			statement.parameters[":taskid"] = task.id;
			statement.execute();
		}
		
		public function removeTaskByID(taskID:int):void
		{
			var statement:SQLStatement = new SQLStatement();
			statement.sqlConnection = _sqlConnection;
			statement.text = "DELETE FROM tasksList WHERE id=:taskid";
			statement.parameters[":taskid"] = taskID;
			statement.execute();
		}
		
		public function addTaskToToDoNowList(taskID:int):void
		{
			var statement:SQLStatement = new SQLStatement();
			statement.sqlConnection = _sqlConnection;
			statement.text = "INSERT INTO todoList(task_id) VALUES(:task_id)";
			statement.parameters[":task_id"] = taskID;
			statement.execute();
		}
		
		public function setToDoTaskStatus(taskID:int, done:Boolean):void
		{
			var statement:SQLStatement = new SQLStatement();
			statement.sqlConnection = _sqlConnection;
			statement.text = "UPDATE todoList SET done=:done WHERE task_id=:task_id";
			statement.parameters[":task_id"] = taskID;
			statement.parameters[":done"] = done;
			statement.execute();
		}
		
		public function clearDoneTasks():void
		{
			var statement:SQLStatement = new SQLStatement();
			statement.sqlConnection = _sqlConnection;
			statement.text = "DELETE FROM todoList WHERE done=TRUE";
			
			statement.execute();
		}
	}
}