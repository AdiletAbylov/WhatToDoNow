package views.renderers
{
	import events.DoItEvent;
	
	import flash.events.MouseEvent;
	
	import spark.components.Button;
	import spark.components.CheckBox;
	import spark.components.LabelItemRenderer;
	
	public class ToDoItemRenderer extends LabelItemRenderer
	{
		public function ToDoItemRenderer()
		{
			super();
		}
		
		private var _clickingCheckBox:Boolean;
		private var _doneCheckBox:CheckBox;
		
		override protected function createChildren():void
		{
			super.createChildren();
			createDoItButton();
		}
		
		private function createDoItButton():void
		{
			_doneCheckBox = new CheckBox();
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			addChild(_doneCheckBox);
		}
		
		override protected function set down(value:Boolean):void
		{
			if(!_clickingCheckBox)
			{
				super.down = value;
			}
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			if(_clickingCheckBox)
			{
				_clickingCheckBox = false;
				var doitEvent:DoItEvent = new DoItEvent(DoItEvent.DID_IT, true );
				doitEvent.taskID = data.id;
				doitEvent.done = _doneCheckBox.selected;
				dispatchEvent( doitEvent );
			}
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			if(event.target is CheckBox)
			{
				event.stopImmediatePropagation();
				event.preventDefault();
				_clickingCheckBox = true;
			}
		}
		
		
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void
		{
			if(_doneCheckBox)
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
				
				
				var buttonHeight:Number = getElementPreferredHeight(_doneCheckBox);
				var buttonWidth:Number = getElementPreferredWidth(_doneCheckBox)
				setElementSize(_doneCheckBox, buttonWidth, buttonHeight);    
				var buttonY:Number = Math.round(vAlign * (viewHeight - buttonHeight))  + paddingTop;
				setElementPosition(_doneCheckBox, paddingLeft, buttonY);
				_doneCheckBox.selected = data.done;
				
				if (!labelDisplay)
					return;
				
				// measure the label component
				// text should take up the rest of the space width-wise, but only let it take up
				// its measured textHeight so we can position it later based on verticalAlign
				var labelWidth:Number = Math.max(viewWidth - _doneCheckBox.width - 10, 0); 
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
				setElementPosition(labelDisplay, paddingLeft + _doneCheckBox.width + 10, labelY);
				
				// attempt to truncate the text now that we have its official width
				labelDisplay.truncateToFit();
			}
			
		}
	}
}