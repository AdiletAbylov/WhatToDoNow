package events
{
	import flash.events.Event;
	
	public class DoItEvent extends Event
	{
		public static const DO_IT:String = "DO_IT_EVENT";
		public static const DID_IT:String = "DID_IT_EVENT";
		
		public var taskID:int;
		public var done:Boolean;
		
		public function DoItEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
		
		override public function clone():Event
		{
			return new DoItEvent(type, bubbles, cancelable);
		}
		override public function toString():String
		{
			return formatToString("DoItEvent", "type", "bubbles", "cancelable",
				"eventPhase");
		}
	}
}