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
			_sqlConnection.open( File.applicationStorageDirectory.resolvePath(DB_NAME));
			var statement:SQLStatement = new SQLStatement();
			statement.sqlConnection = _sqlConnection;
			statement.text = "CREATE TABLE IF NOT EXISTS todoList (task_id INTEGER, done BOOLEAN)";
			statement.execute();
			
			statement.text = "CREATE TABLE IF NOT EXISTS tasksList(id INTEGER PRIMARY KEY AUTOINCREMENT," +
																	"name TEXT)";
			statement.execute();
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
			statement.text = "SELECT * FROM tasksList";
			statement.execute();
			statement.itemClass = TaskVO;
			list = new ArrayCollection( statement.getResult().data );
			return list;
		}
		
		public function addTask(task:TaskVO):void
		{
			
		}
		
		public function editTask(task:TaskVO):void
		{
			
		
		}
		
		public function removeTask(task:TaskVO):void
		{
			
		}
		
		public function addTaskToToDoNowList(task:TaskVO):void
		{
			
		}
	}
}