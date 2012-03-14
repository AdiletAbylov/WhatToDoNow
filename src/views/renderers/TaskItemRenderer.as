package views.renderers
{
	import events.DoItEvent;
	
	import flash.events.MouseEvent;
	
	import spark.components.Button;
	import spark.components.LabelItemRenderer;
	
	public class TaskItemRenderer extends LabelItemRenderer
	{
		public function TaskItemRenderer()
		{
			super();
		}
		
		private var _clickingButton:Boolean;
		private var _doItButton:Button;
		
		override protected function createChildren():void
		{
			super.createChildren();
			createDoItButton();
		}
		
		private function createDoItButton():void
		{
			_doItButton = new Button();
			_doItButton.label = "Do It";
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			addChild(_doItButton);
		}
		
		override protected function set down(value:Boolean):void
		{
			if(!_clickingButton)
			{
				super.down = value;
			}
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			if(_clickingButton)
			{
				_clickingButton = false;
			}
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			if(event.target is Button)
			{
				event.stopImmediatePropagation();
				event.preventDefault();
				_clickingButton = true;
				var doitEvent:DoItEvent = new DoItEvent(DoItEvent.DO_IT, true );
				doitEvent.taskID = data.id;
				dispatchEvent( doitEvent );
			}
		}
		
		
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
		{
			
			if(_doItButton)
			{
				var paddingLeft:Number   = getStyle("paddingLeft"); 
				var paddingRight:Number  = getStyle("paddingRight");
				var paddingTop:Number    = getStyle("paddingTop");
				var paddingBottom:Number = getStyle("paddingBottom");
				var verticalAlign:String = getStyle("verticalAlign");
				
				var viewWidth:Number  = unscaledWidth  - paddingLeft - paddingRight;
				var viewHeight:Number = unscaledHeight - paddingTop  - paddingBottom;
				
				var vAlign:Number;
				if (verticalAlign == "top")
				{
					vAlign = 0;
				}
				else 
					if (verticalAlign == "bottom")
					{
						vAlign = 1;
					}
					else 
					{
						vAlign = 0.5;
					}
				
				
				var buttonHeight:Number = getElementPreferredHeight(_doItButton) - 10;
				setElementSize(_doItButton, 90, buttonHeight);    
				var buttonY:Number = Math.round(vAlign * (viewHeight - buttonHeight))  + paddingTop;
				setElementPosition(_doItButton, paddingLeft, buttonY);
				
				if (!labelDisplay)
					return;
				
				// measure the label component
				// text should take up the rest of the space width-wise, but only let it take up
				// its measured textHeight so we can position it later based on verticalAlign
				var labelWidth:Number = Math.max(viewWidth - _doItButton.width - 10, 0); 
				var labelHeight:Number = 0;
				
				if (label != "")
				{
					labelDisplay.commitStyles();
					
					// reset text if it was truncated before.
					if (labelDisplay.isTruncated)
						labelDisplay.text = label;
					
					labelHeight = getElementPreferredHeight(labelDisplay);
				}
				
				setElementSize(labelDisplay, labelWidth, labelHeight);    
				
				// We want to center using the "real" ascent
				var labelY:Number = Math.round(vAlign * (viewHeight - labelHeight))  + paddingTop;
				setElementPosition(labelDisplay, paddingLeft + _doItButton.width + 10, labelY);
				
				// attempt to truncate the text now that we have its official width
				labelDisplay.truncateToFit();
			}
			
		}
	}
}