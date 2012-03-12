package vo
{
	[Bindable]
	public class ToDoTaskVO extends TaskVO
	{
		public function ToDoTaskVO()
		{
			super();
		}
		
		public var done:Boolean;
	}
}