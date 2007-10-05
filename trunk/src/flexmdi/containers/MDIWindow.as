/*
Copyright (c) 2007 FlexMDI Contributors.  See:
    http://code.google.com/p/flexmdi/wiki/ProjectContributors

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/


package flexmdi.containers
{
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import flexmdi.events.MDIWindowEvent;
	import flexmdi.managers.MDIManager;
	
	import mx.containers.Canvas;
	import mx.containers.Panel;
	import mx.controls.Button;
	import mx.controls.Image;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.managers.CursorManager;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 *  Dispatched when the minimize button is clicked.
	 *
	 *  @eventType flexmdi.events.MDIWindowEvent.MINIMIZE
	 */
	[Event(name="minimize", type="flexmdi.events.MDIWindowEvent")]
	
	/**
	 *  If the window is minimized, this event is dispatched when the titleBar is clicked. 
	 * 	If the window is maxmimized, this event is dispatched upon clicking the restore button
	 *  or double clicking the titleBar.
	 *
	 *  @eventType flexmdi.events.MDIWindowEvent.RESTORE
	 */
	[Event(name="restore", type="flexmdi.events.MDIWindowEvent")]
	
	/**
	 *  Dispatched when the maximize button is clicked or when the window is in a
	 *  normal state (not minimized or maximized) and the titleBar is double clicked.
	 *
	 *  @eventType flexmdi.events.MDIWindowEvent.MAXIMIZE
	 */
	[Event(name="maximize", type="flexmdi.events.MDIWindowEvent")]
	
	/**
	 *  Dispatched when the close button is clicked.
	 *
	 *  @eventType flexmdi.events.MDIWindowEvent.CLOSE
	 */
	[Event(name="close", type="flexmdi.events.MDIWindowEvent")]
	
	/**
	 *  Dispatched when the window gains focus and is given topmost z-index of MDIManager's children.
	 *
	 *  @eventType flexmdi.events.MDIWindowEvent.FOCUS_START
	 */
	[Event(name="focusStart", type="flexmdi.events.MDIWindowEvent")]
	
	/**
	 *  Dispatched when the window loses focus and no longer has topmost z-index of MDIManager's children.
	 *
	 *  @eventType flexmdi.events.MDIWindowEvent.FOCUS_END
	 */
	[Event(name="focusEnd", type="flexmdi.events.MDIWindowEvent")]
	
	/**
	 *  Dispatched when the window starts being dragged.
	 *
	 *  @eventType flexmdi.events.MDIWindowEvent.DRAG_START
	 */
	[Event(name="dragStart", type="flexmdi.events.MDIWindowEvent")]
	
	/**
	 *  Dispatched while the window is being dragged.
	 *
	 *  @eventType flexmdi.events.MDIWindowEvent.DRAG
	 */
	[Event(name="drag", type="flexmdi.events.MDIWindowEvent")]
	
	/**
	 *  Dispatched when the window stops being dragged.
	 *
	 *  @eventType flexmdi.events.MDIWindowEvent.DRAG_END
	 */
	[Event(name="dragEnd", type="flexmdi.events.MDIWindowEvent")]
	
	/**
	 *  Dispatched when a resize handle is pressed.
	 *
	 *  @eventType flexmdi.events.MDIWindowEvent.RESIZE_START
	 */
	[Event(name="resizeStart", type="flexmdi.events.MDIWindowEvent")]
	
	/**
	 *  Dispatched while the mouse is down on a resize handle.
	 *
	 *  @eventType flexmdi.events.MDIWindowEvent.RESIZE
	 */
	[Event(name="resize", type="flexmdi.events.MDIWindowEvent")]
	
	/**
	 *  Dispatched when the mouse is released from a resize handle.
	 *
	 *  @eventType flexmdi.events.MDIWindowEvent.RESIZE_END
	 */
	[Event(name="resizeEnd", type="flexmdi.events.MDIWindowEvent")]
	
	
	//--------------------------------------
	//  Skins
	//--------------------------------------
	
	/**
	 *  Name of the class used as cursor when resizing the window horizontally.
	 */
	[Style(name="resizeCursorHorizontalSkin", type="Class", inherit="no")]
	
	/**
	 *  Distance to horizontally offset resizeCursorHorizontalSkin.
	 */
	[Style(name="resizeCursorHorizontalSkinXOffset", type="Number", inherit="no")]
	
	/**
	 *  Distance to vertically offset resizeCursorHorizontalSkin.
	 */
	[Style(name="resizeCursorHorizontalSkinYOffset", type="Number", inherit="no")]
	
	
	/**
	 *  Name of the class used as cursor when resizing the window vertically.
	 */
	[Style(name="resizeCursorVerticalSkin", type="Class", inherit="no")]
	
	/**
	 *  Distance to horizontally offset resizeCursorVerticalSkin.
	 */
	[Style(name="resizeCursorVerticalSkinXOffset", type="Number", inherit="no")]
	
	/**
	 *  Distance to vertically offset resizeCursorVerticalSkin.
	 */
	[Style(name="resizeCursorVerticalSkinYOffset", type="Number", inherit="no")]
	
	
	/**
	 *  Name of the class used as cursor when resizing from top left or bottom right corner.
	 */
	[Style(name="resizeCursorTopLeftBottomRightSkin", type="Class", inherit="no")]
	
	/**
	 *  Distance to horizontally offset resizeCursorTopLeftBottomRightSkin.
	 */
	[Style(name="resizeCursorTopLeftBottomRightSkinXOffset", type="Number", inherit="no")]
	
	/**
	 *  Distance to vertically offset resizeCursorTopLeftBottomRightSkin.
	 */
	[Style(name="resizeCursorTopLeftBottomRightSkinYOffset", type="Number", inherit="no")]
	
	
	/**
	 *  Name of the class used as cursor when resizing from top right or bottom left corner.
	 */
	[Style(name="resizeCursorTopRightBottomLeftSkin", type="Class", inherit="no")]
	
	/**
	 *  Distance to horizontally offset resizeCursorTopRightBottomLeftSkin.
	 */
	[Style(name="resizeCursorTopRightBottomLeftSkinXOffset", type="Number", inherit="no")]
	
	/**
	 *  Distance to vertically offset resizeCursorTopRightBottomLeftSkin.
	 */
	[Style(name="resizeCursorTopRightBottomLeftSkinYOffset", type="Number", inherit="no")]
	
	/**
	 *  The source path to the image to be used for corner resize instance
	 */
	[Style(name="cornerResizeImg", type="Class", inherit="no")]
	
	/**
	 *  The corner resize image width
	 */
	[Style(name="cornerResizeWidth", type="Number", inherit="no")]
	
	/**
	 *  The corner resize image height
	 */
	[Style(name="cornerResizeHeight", type="Number", inherit="no")]
	
	/**
	 *  The corner resize image padding on right
	 */
	[Style(name="cornerResizePaddingRight", type="Number", inherit="no")]
	
	/**
	 *  The corner resize image padding on bottom
	 */
	[Style(name="cornerResizePaddingBottom", type="Number", inherit="no")]
	
	/**
	 *  The width of the control buttons
	 */
	[Style(name="controlButtonWidth", type="Number", inherit="no")]
	
	/**
	 *  The height of the control buttons
	 */
	[Style(name="controlButtonHeight", type="Number", inherit="no")]
	
	/**
	 *  The width of gap between control buttons
	 */
	[Style(name="controlButtonGap", type="Number", inherit="no")]
	
	/**
	 * Central window class used in flexmdi. Includes min/max/close buttons by default.
	 */
	public class MDIWindow extends Panel
	{		
		/**
	     * Size of edge handles. Can be adjusted to affect "sensitivity" of resize area.
	     */
	    public var edgeHandleSize:Number = 4;
	    
	    /**
	     * Size of corner handles. Can be adjusted to affect "sensitivity" of resize area.
	     */
		public var cornerHandleSize:Number = 10;
	    
	    /**
	     * @private
	     * Internal storage for windowState property.
	     */
		private var _windowState:int;
		
		/**
	     * @private
	     * Internal storage of previous state, used in min/max/restore logic.
	     */
		private var _prevWindowState:int;
		
		/**
	     * @private
	     * Parent of window controls (min, restore/max and close buttons).
	     */
		private var controlsHolder:UIComponent;
		
		/**
		 * @private
		 * Flag to determine whether or not close button is visible.
		 */
		private var _showCloseButton:Boolean = true;
		
		/**
		 * Array of controlsHolder's child components.
		 */
		public var controls:Array;
		
		/**
		 * Minimize window button.
		 */
		public var minimizeBtn:Button;
		
		/**
		 * Maximize/restore window button.
		 */
		public var maximizeRestoreBtn:Button;
		
		/**
		 * Close window button.
		 */
		public var closeBtn:Button;
		
		/**
		 * Bottom right corner resize image
		 */
		 public var cornerResizeImg:Image;
		
		/**
		 * Height of window when minimized.
		 */
		public var minimizeHeight:Number;
		
		/**
		 * Flag determining whether or not this window is resizable.
		 */
		public var resizable:Boolean;
		
		/**
		 * Flag determining whether or not this window is draggable.
		 */
		public var draggable:Boolean;
		
		/**
	     * @private
	     * Resize handle for top edge of window.
	     */
		private var resizeHandleTop:Button;
		
		/**
	     * @private
	     * Resize handle for right edge of window.
	     */
		private var resizeHandleRight:Button;
		
		/**
	     * @private
	     * Resize handle for bottom edge of window.
	     */
		private var resizeHandleBottom:Button;
		
		/**
	     * @private
	     * Resize handle for left edge of window.
	     */
		private var resizeHandleLeft:Button;
		
		/**
	     * @private
	     * Resize handle for top left corner of window.
	     */
		private var resizeHandleTL:Button;
		
		/**
	     * @private
	     * Resize handle for top right corner of window.
	     */
		private var resizeHandleTR:Button;
		
		/**
	     * @private
	     * Resize handle for bottom right corner of window.
	     */
		private var resizeHandleBR:Button;
		
		/**
	     * @private
	     * Resize handle for bottom left corner of window.
	     */
		private var resizeHandleBL:Button;		
		
		/**
		 * Resize handle currently in use.
		 */
		private var currentResizeHandle:Button;
		
		/**
		 * Style name to apply to cursors.
		 */
		public var cursorStyleName:String;
		
		/**
	     * Rectangle to represent window's size and position when resize begins
	     * or window's size/position is saved.
	     */
		public var savedWindowRect:Rectangle;
		
		/**
		 * @private
		 * Flag used to intelligently dispatch resize related events
		 */
		private var _resizing:Boolean;
		
		/**
		 * @private
		 * Invisible shape laid over titlebar to prevent funkiness from clicking in title textfield.
		 */
		private var titleOverlay:Canvas;
		
		/**
		 * @private
		 * Flag used to intelligently dispatch drag related events
		 */
		private var _dragging:Boolean;
		
		/**
		 * @private
	     * Mouse's x position when resize begins.
	     */
		private var dragStartMouseX:Number;
		
		/**
		 * @private
	     * Mouse's y position when resize begins.
	     */
		private var dragStartMouseY:Number;
		
		/**
		 * @private
	     * Maximum allowable x value for resize. Used to enforce minWidth.
	     */
		private var dragMaxX:Number;
		
		/**
		 * @private
	     * Maximum allowable x value for resize. Used to enforce minHeight.
	     */
		private var dragMaxY:Number;
		
		/**
		 * @private
	     * Amount the mouse's x position has changed during current resizing.
	     */
		private var dragAmountX:Number;
		
		/**
		 * @private
	     * Amount the mouse's y position has changed during current resizing.
	     */
		private var dragAmountY:Number;
		
		/**
	     * Window's context menu.
	     */
		public var winContextMenu:ContextMenu = null;
		
		/**
		 * Reference to MDIManager instance this window is managed by, if any.
	     */
		public var windowManager:MDIManager;
		
		
		/**
		 * @private store the backgroundAlpha when minimized.
	     */
		private var backgroundAlphaRestore:Number = 1;
		
		/**
		 * Name of style to be applied when window has focus.
		 */
		public var focusStyleName:String;
		
		/**
		 * Name of style to be applied when window does not have focus.
		 */
		public var noFocusStyleName:String;
		
		
		/**
		 * Constructor
	     */
		public function MDIWindow()
		{
			super();
			controls = new Array();
			doubleClickEnabled = true;
			minWidth = 200;
			minHeight = 200;
			windowState = MDIWindowState.NORMAL;
			resizable = draggable = true;
			
			focusStyleName = "mdiWindowFocus";
			noFocusStyleName = "mdiWindowNoFocus";
			styleName = focusStyleName;
			cursorStyleName = "mdiWindowCursorStyle";	
			addEventListener(FlexEvent.CREATION_COMPLETE, componentComplete);			
		}
		
		/**
		 * @private
		 */
		private function componentComplete(event:FlexEvent):void
		{
			minimizeHeight = this.titleBar.height;
			invalidateDisplayList();
		}
		
		/**
		 * Create resize handles and window controls.
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			if(!titleOverlay)
			{
				titleOverlay = new Canvas();
				titleOverlay.width = this.width;
				titleOverlay.height = this.titleBar.height;
				titleOverlay.alpha = 0;
				titleOverlay.setStyle("backgroundColor", 0x000000);
				rawChildren.addChild(titleOverlay);
			}
			
			// edges
			if(!resizeHandleTop)
			{
				resizeHandleTop = new Button();
				resizeHandleTop.x = cornerHandleSize * .5;
				resizeHandleTop.y = -(edgeHandleSize * .5);
				resizeHandleTop.height = edgeHandleSize;
				resizeHandleTop.alpha = 0;
				resizeHandleTop.focusEnabled = false;
				rawChildren.addChild(resizeHandleTop);
			}
			
			if(!resizeHandleRight)
			{
				resizeHandleRight = new Button();
				resizeHandleRight.y = cornerHandleSize * .5;
				resizeHandleRight.width = edgeHandleSize;
				resizeHandleRight.alpha = 0;
				resizeHandleRight.focusEnabled = false;
				rawChildren.addChild(resizeHandleRight);
			}
			
			if(!resizeHandleBottom)
			{
				resizeHandleBottom = new Button();
				resizeHandleBottom.x = cornerHandleSize * .5;
				resizeHandleBottom.height = edgeHandleSize;
				resizeHandleBottom.alpha = 0;
				resizeHandleBottom.focusEnabled = false;
				rawChildren.addChild(resizeHandleBottom);
			}
			
			if(!resizeHandleLeft)
			{
				resizeHandleLeft = new Button();
				resizeHandleLeft.x = -(edgeHandleSize * .5);
				resizeHandleLeft.y = cornerHandleSize * .5;
				resizeHandleLeft.width = edgeHandleSize;
				resizeHandleLeft.alpha = 0;
				resizeHandleLeft.focusEnabled = false;
				rawChildren.addChild(resizeHandleLeft);
			}
			
			// corners
			if(!resizeHandleTL)
			{
				resizeHandleTL = new Button();
				resizeHandleTL.x = resizeHandleTL.y = -(cornerHandleSize * .3);
				resizeHandleTL.width = resizeHandleTL.height = cornerHandleSize;
				resizeHandleTL.alpha = 0;
				resizeHandleTL.focusEnabled = false;
				rawChildren.addChild(resizeHandleTL);
			}
			
			if(!resizeHandleTR)
			{
				resizeHandleTR = new Button();
				resizeHandleTR.width = resizeHandleTR.height = cornerHandleSize;
				resizeHandleTR.alpha = 0;
				resizeHandleTR.focusEnabled = false;
				rawChildren.addChild(resizeHandleTR);
			}
			
			if(!resizeHandleBR)
			{
				resizeHandleBR = new Button();
				resizeHandleBR.width = resizeHandleBR.height = cornerHandleSize;
				resizeHandleBR.alpha = 0;
				resizeHandleBR.focusEnabled = false;
				rawChildren.addChild(resizeHandleBR);
			}
			
			if(!resizeHandleBL)
			{
				resizeHandleBL = new Button();
				resizeHandleBL.width = resizeHandleBL.height = cornerHandleSize;
				resizeHandleBL.alpha = 0;
				resizeHandleBL.focusEnabled = false;
				rawChildren.addChild(resizeHandleBL);
			}
			
			if(StyleManager.getStyleDeclaration('.mdiWindowFocus').getStyle('cornerResizeImg') != null)
			{
				cornerResizeImg = new Image();
				cornerResizeImg.source = StyleManager.getStyleDeclaration('.mdiWindowFocus').getStyle('cornerResizeImg');
				if(StyleManager.getStyleDeclaration('.mdiWindowFocus').getStyle('cornerResizeWidth') != null)
					cornerResizeImg.width = StyleManager.getStyleDeclaration('.mdiWindowFocus').getStyle('cornerResizeWidth');
					
				if(StyleManager.getStyleDeclaration('.mdiWindowFocus').getStyle('cornerResizeHeight') != null)
					cornerResizeImg.height = StyleManager.getStyleDeclaration('.mdiWindowFocus').getStyle('cornerResizeHeight');
					
				cornerResizeImg.x = this.width - cornerResizeImg.width;
				cornerResizeImg.y = this.height - cornerResizeImg.height;
				
				if(StyleManager.getStyleDeclaration('.mdiWindowFocus').getStyle('cornerResizePaddingRight') != null)
					cornerResizeImg.x -= StyleManager.getStyleDeclaration('.mdiWindowFocus').getStyle('cornerResizePaddingRight');
				
				if(StyleManager.getStyleDeclaration('.mdiWindowFocus').getStyle('cornerResizePaddingBottom') != null)
					cornerResizeImg.y -= StyleManager.getStyleDeclaration('.mdiWindowFocus').getStyle('cornerResizePaddingBottom');
					
				rawChildren.addChild(cornerResizeImg);
				
			}
			else
			{
				this.cornerResizeImg = null;
			}
			
			// controls			
			if(controls.length == 0)
			{
				closeBtn = new Button();
				closeBtn.width = this.getStyle('controlButtonWidth');
				closeBtn.height = this.getStyle('controlButtonHeight');
				(this.styleName == focusStyleName) ? closeBtn.styleName = "closeBtnFocus" : closeBtn.styleName = "closeBtnNoFocus";
				closeBtn.visible = showCloseButton;
				controls.push(closeBtn);		
				
				maximizeRestoreBtn = new Button();
				maximizeRestoreBtn.width = this.getStyle('controlButtonWidth');
				maximizeRestoreBtn.height = this.getStyle('controlButtonHeight');
				(this.styleName == focusStyleName) ? maximizeRestoreBtn.styleName = "increaseBtnFocus" : maximizeRestoreBtn.styleName = "increaseBtnNoFocus";
				controls.push(maximizeRestoreBtn);
				
				
				minimizeBtn = new Button();
				minimizeBtn.width = this.getStyle('controlButtonWidth');
				minimizeBtn.height = this.getStyle('controlButtonHeight');
				(this.styleName == focusStyleName) ? minimizeBtn.styleName = "minimizeBtnFocus" : minimizeBtn.styleName = "minimizeBtnNoFocus";
				controls.push(minimizeBtn);
						
			}
			
			
			controlsHolder = new UIComponent();
			rawChildren.addChild(controlsHolder);
			
			for(var i:int = 0; i < controls.length; i++)
			{
				var control:UIComponent = controls[i];
				control.x = this.width - ((control.width * (i+1)) + (StyleManager.getStyleDeclaration('.mdiWindowFocus').getStyle('controlButtonGap') * (i+1)));
				control.y = (titleBar.height - control.height) / 2;
				control.buttonMode = true;
				controlsHolder.addChild(control);
			}
			
			addListeners();
		}		
		
		/**
		 * Position resize handles and window controls.
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			titleOverlay.width = this.width;
			titleOverlay.height = this.titleBar.height;
			
			// edges
			resizeHandleTop.x = cornerHandleSize * .5;
			resizeHandleTop.y = -(edgeHandleSize * .5);
			resizeHandleTop.width = this.width - cornerHandleSize;
			resizeHandleTop.height = edgeHandleSize;
			
			resizeHandleRight.x = this.width - edgeHandleSize * .5;
			resizeHandleRight.y = cornerHandleSize * .5;
			resizeHandleRight.width = edgeHandleSize;
			resizeHandleRight.height = this.height - cornerHandleSize;
			
			resizeHandleBottom.x = cornerHandleSize * .5;
			resizeHandleBottom.y = this.height - edgeHandleSize * .5;
			resizeHandleBottom.width = this.width - cornerHandleSize;
			resizeHandleBottom.height = edgeHandleSize;
			
			resizeHandleLeft.x = -(edgeHandleSize * .5);
			resizeHandleLeft.y = cornerHandleSize * .5;
			resizeHandleLeft.width = edgeHandleSize;
			resizeHandleLeft.height = this.height - cornerHandleSize;
			
			// corners
			resizeHandleTL.x = resizeHandleTL.y = -(cornerHandleSize * .5);
			resizeHandleTL.width = resizeHandleTL.height = cornerHandleSize;
			
			resizeHandleTR.x = this.width - cornerHandleSize * .5;
			resizeHandleTR.y = -(cornerHandleSize * .5);
			resizeHandleTR.width = resizeHandleTR.height = cornerHandleSize;
			
			resizeHandleBR.x = this.width - cornerHandleSize * .5;
			resizeHandleBR.y = this.height - cornerHandleSize * .5;
			resizeHandleBR.width = resizeHandleBR.height = cornerHandleSize;
			
			resizeHandleBL.x = -(cornerHandleSize * .5);
			resizeHandleBL.y = this.height - cornerHandleSize * .5;
			resizeHandleBL.width = resizeHandleBL.height = cornerHandleSize;
			
			// position window controls
			var visibleControls:Array = new Array();
			
			for(var i:int = 0; i < controlsHolder.numChildren; i++)
			{
				var control:UIComponent = controlsHolder.getChildAt(i) as UIComponent;
				if(control.visible)
				{
					visibleControls.push(control);
				}
			}
			
			for(i = 0; i < visibleControls.length; i++)
			{
				control = visibleControls[i] as UIComponent;
				
				control.x = this.width - ((control.width * (i+1)) + (StyleManager.getStyleDeclaration('.mdiWindowFocus').getStyle('controlButtonGap') * (i+1)));
				control.y = (titleBar.height - control.height) / 2;
			}
			
			if(cornerResizeImg != null)
			{
				cornerResizeImg.x = this.width - cornerResizeImg.width;
				cornerResizeImg.y = this.height - cornerResizeImg.height;
				if(StyleManager.getStyleDeclaration('.mdiWindowFocus').getStyle('cornerResizePaddingRight') != null)
					cornerResizeImg.x -= StyleManager.getStyleDeclaration('.mdiWindowFocus').getStyle('cornerResizePaddingRight');
				
				if(StyleManager.getStyleDeclaration('.mdiWindowFocus').getStyle('cornerResizePaddingBottom') != null)
					cornerResizeImg.y -= StyleManager.getStyleDeclaration('.mdiWindowFocus').getStyle('cornerResizePaddingBottom');
			}
			
			
		}
		
		public function get showCloseButton():Boolean
		{
			return _showCloseButton;
		}
		
		public function set showCloseButton(value:Boolean):void
		{
			_showCloseButton = value;
			if(closeBtn)
			{
				closeBtn.visible = value;
				invalidateDisplayList();
			}
		}
		
		/**
		 * Save style settings for minimizing.
	     */
		public function saveStyle():void
		{
			//this.backgroundAlphaRestore = this.getStyle("backgroundAlpha");
		}
		
		/**
		 * Restores style settings for restore and maximize
	     */
		public function restoreStyle():void
		{
			//this.setStyle("backgroundAlpha", this.backgroundAlphaRestore);
		}
		
		/**
		 * Add listeners for resize handles and window controls.
		 */
		private function addListeners():void
		{
			// edges
			resizeHandleTop.addEventListener(MouseEvent.ROLL_OVER, onResizeButtonRollOver, false, 0, true);
			resizeHandleTop.addEventListener(MouseEvent.ROLL_OUT, onResizeButtonRollOut, false, 0, true);
			resizeHandleTop.addEventListener(MouseEvent.MOUSE_DOWN, onResizeButtonPress, false, 0, true);
			
			resizeHandleRight.addEventListener(MouseEvent.ROLL_OVER, onResizeButtonRollOver, false, 0, true);
			resizeHandleRight.addEventListener(MouseEvent.ROLL_OUT, onResizeButtonRollOut, false, 0, true);
			resizeHandleRight.addEventListener(MouseEvent.MOUSE_DOWN, onResizeButtonPress, false, 0, true);
			
			resizeHandleBottom.addEventListener(MouseEvent.ROLL_OVER, onResizeButtonRollOver, false, 0, true);
			resizeHandleBottom.addEventListener(MouseEvent.ROLL_OUT, onResizeButtonRollOut, false, 0, true);
			resizeHandleBottom.addEventListener(MouseEvent.MOUSE_DOWN, onResizeButtonPress, false, 0, true);
			
			resizeHandleLeft.addEventListener(MouseEvent.ROLL_OVER, onResizeButtonRollOver, false, 0, true);
			resizeHandleLeft.addEventListener(MouseEvent.ROLL_OUT, onResizeButtonRollOut, false, 0, true);
			resizeHandleLeft.addEventListener(MouseEvent.MOUSE_DOWN, onResizeButtonPress, false, 0, true);
			
			// corners
			resizeHandleTL.addEventListener(MouseEvent.ROLL_OVER, onResizeButtonRollOver, false, 0, true);
			resizeHandleTL.addEventListener(MouseEvent.ROLL_OUT, onResizeButtonRollOut, false, 0, true);
			resizeHandleTL.addEventListener(MouseEvent.MOUSE_DOWN, onResizeButtonPress, false, 0, true);
			
			resizeHandleTR.addEventListener(MouseEvent.ROLL_OVER, onResizeButtonRollOver, false, 0, true);
			resizeHandleTR.addEventListener(MouseEvent.ROLL_OUT, onResizeButtonRollOut, false, 0, true);
			resizeHandleTR.addEventListener(MouseEvent.MOUSE_DOWN, onResizeButtonPress, false, 0, true);
			
			resizeHandleBR.addEventListener(MouseEvent.ROLL_OVER, onResizeButtonRollOver, false, 0, true);
			resizeHandleBR.addEventListener(MouseEvent.ROLL_OUT, onResizeButtonRollOut, false, 0, true);
			resizeHandleBR.addEventListener(MouseEvent.MOUSE_DOWN, onResizeButtonPress, false, 0, true);
			
			resizeHandleBL.addEventListener(MouseEvent.ROLL_OVER, onResizeButtonRollOver, false, 0, true);
			resizeHandleBL.addEventListener(MouseEvent.ROLL_OUT, onResizeButtonRollOut, false, 0, true);
			resizeHandleBL.addEventListener(MouseEvent.MOUSE_DOWN, onResizeButtonPress, false, 0, true);
			
			// titleBar
			titleOverlay.addEventListener(MouseEvent.MOUSE_DOWN, onTitleBarPress, false, 0, true);
			titleOverlay.addEventListener(MouseEvent.MOUSE_UP, onTitleBarRelease, false, 0, true);
			titleOverlay.addEventListener(MouseEvent.DOUBLE_CLICK, maximizeRestore, false, 0, true);
			titleOverlay.addEventListener(MouseEvent.CLICK, unMinimize, false, 0, true);
			
			// window controls
			if(minimizeBtn)
			{
				minimizeBtn.addEventListener(MouseEvent.CLICK, minimize, false, 0, true);
			}
			if(maximizeRestoreBtn)
			{
				maximizeRestoreBtn.addEventListener(MouseEvent.CLICK, maximizeRestore, false, 0, true);
			}
			if(closeBtn)
			{
				closeBtn.addEventListener(MouseEvent.CLICK, close, false, 0, true);
			}
			
			// clicking anywhere brings window to front
			this.addEventListener(MouseEvent.MOUSE_DOWN, bringToFront);
		}
		
		/**
		 * Bring this window to front of parent's child list. Called automatically by clicking on window.
		 * Can be called manually by developer.
		 */
		public function bringToFront(event:Event = null):void
		{
			var indexToCheck:int;
			if(event != null && event.type == "newWindow")
			{
				indexToCheck = parent.numChildren - 2;
			}
			else
			{
				indexToCheck = parent.numChildren - 1;
			}
			
			for each(var win:MDIWindow in windowManager.windowList)
			{
				if(win != this && win.parent.getChildIndex(win) == indexToCheck)
				{
					win.dispatchEvent(new MDIWindowEvent(MDIWindowEvent.FOCUS_END, win));
				}
			}
			if(parent.getChildIndex(this) != parent.numChildren - 1)
			{
				parent.setChildIndex(this, parent.numChildren - 1);
				dispatchEvent(new MDIWindowEvent(MDIWindowEvent.FOCUS_START, this));
			}
		}
		
		/**
		 *  Minimize the window.
		 */
		public function minimize(event:MouseEvent = null):void
		{
			// if the panel is floating, save its state
			if(windowState == MDIWindowState.NORMAL)
			{
				savePanel();
			}
			_prevWindowState = windowState;
			dispatchEvent(new MDIWindowEvent(MDIWindowEvent.MINIMIZE, this));
			windowState = MDIWindowState.MINIMIZED;
			showControls = false;
		}
		
		
		/**
		 *  Called from maximize/restore button 
		 * 
		 *  @event MouseEvent (optional)
		 */
		public function maximizeRestore(event:MouseEvent = null):void
		{
			if(maximizeRestoreBtn.styleName == "increaseBtnFocus" || maximizeRestoreBtn.styleName == "increaseBtnNoFocus")
			{
				savePanel();
				maximize();
			}
			else
			{
				restore();
			}
		}
		
		/**
		 * Restores the window to its last floating position.
		 */
		public function restore():void
		{
			maximizeRestoreBtn.styleName = "increaseBtnFocus";
			windowState = MDIWindowState.NORMAL;
			dispatchEvent(new MDIWindowEvent(MDIWindowEvent.RESTORE, this));
		}
		
		/**
		 * Maximize the window.
		 */
		public function maximize():void
		{
			showControls = true;
			windowState = MDIWindowState.MAXIMIZED;
			maximizeRestoreBtn.styleName = "decreaseBtnFocus";
			dispatchEvent(new MDIWindowEvent(MDIWindowEvent.MAXIMIZE, this));
		}
		
		/**
		 * Close the window.
		 */
		public function close(event:MouseEvent = null):void
		{
			dispatchEvent(new MDIWindowEvent(MDIWindowEvent.CLOSE, this));
		}
		
		/**
		 * Save the panel's floating coordinates.
		 * 
		 * @private
		 */
		private function savePanel():void
		{
			savedWindowRect = new Rectangle(this.x, this.y, this.width, this.height);
		}
		
		/**
		 * Not fully refined yet. Should be improved asap.
		 */
		public function addControl(uic:UIComponent, index:int = -1):void
		{
			uic.buttonMode = true;
			if(index > -1)
			{
				controlsHolder.addChildAt(uic, index);
			}
			else
			{
				controlsHolder.addChild(uic);
			}
			invalidateDisplayList();
		}
		
		/**
		 * Title bar dragging.
		 * 
		 * @private
		 */
		private function onTitleBarPress(event:MouseEvent):void
		{
			// only floating windows can be dragged
			if(this.windowState == MDIWindowState.NORMAL && draggable)
			{
				this.startDrag(false, new Rectangle(0, 0, parent.width - this.width, parent.height - this.height));
				systemManager.addEventListener(MouseEvent.MOUSE_MOVE, onWindowMove);
				systemManager.addEventListener(MouseEvent.MOUSE_UP, onTitleBarRelease);
				systemManager.stage.addEventListener(Event.MOUSE_LEAVE, onTitleBarRelease);
			}
		}
		
		private function onWindowMove(event:MouseEvent):void
		{
			if(!_dragging)
			{
				_dragging = true;
				// clear styles (future versions may allow enforcing constraints on drag)
				this.clearStyle("top");
				this.clearStyle("right");
				this.clearStyle("bottom");
				this.clearStyle("left");
				dispatchEvent(new MDIWindowEvent(MDIWindowEvent.DRAG_START, this));
			}
			dispatchEvent(new MDIWindowEvent(MDIWindowEvent.DRAG, this));
		}
		
		private function onTitleBarRelease(event:Event):void
		{
			this.stopDrag();
			if(_dragging)
			{
				_dragging = false;
				dispatchEvent(new MDIWindowEvent(MDIWindowEvent.DRAG_END, this));
			}
			systemManager.removeEventListener(MouseEvent.MOUSE_MOVE, onWindowMove);
			systemManager.removeEventListener(MouseEvent.MOUSE_UP, onTitleBarRelease);
			systemManager.stage.removeEventListener(Event.MOUSE_LEAVE, onTitleBarRelease);
		}
		
		/**
		 * Mouse down on any resize handle.
		 */
		private function onResizeButtonPress(event:MouseEvent):void
		{
			if(windowState == MDIWindowState.NORMAL && resizable)
			{
				currentResizeHandle = event.target as Button;
				setCursor(currentResizeHandle);
				dragStartMouseX = parent.mouseX;
				dragStartMouseY = parent.mouseY;
				savePanel();
				
				dragMaxX = savedWindowRect.x + (savedWindowRect.width - minWidth);
				dragMaxY = savedWindowRect.y + (savedWindowRect.height - minHeight);
				
				systemManager.addEventListener(Event.ENTER_FRAME, updateWindowSize, false, 0, true);
				systemManager.addEventListener(MouseEvent.MOUSE_MOVE, onResizeButtonDrag, false, 0, true);
				systemManager.addEventListener(MouseEvent.MOUSE_UP, onResizeButtonRelease, false, 0, true);
				systemManager.stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeaveStage, false, 0, true);
			}
		}
		
		private function onResizeButtonDrag(event:MouseEvent):void
		{
			if(!_resizing)
			{
				_resizing = true;
				dispatchEvent(new MDIWindowEvent(MDIWindowEvent.RESIZE_START, this));
			}			
			dispatchEvent(new MDIWindowEvent(MDIWindowEvent.RESIZE, this));
		}
		
		/**
		 * Mouse move while mouse is down on a resize handle
		 */
		private function updateWindowSize(event:Event):void
		{
			if(windowState == MDIWindowState.NORMAL && resizable)
			{
				dragAmountX = parent.mouseX - dragStartMouseX;
				dragAmountY = parent.mouseY - dragStartMouseY;
				
				if(currentResizeHandle == resizeHandleTop && parent.mouseY > 0)
				{
					this.y = Math.min(savedWindowRect.y + dragAmountY, dragMaxY);
					this.height = Math.max(savedWindowRect.height - dragAmountY, minHeight);
				}
				else if(currentResizeHandle == resizeHandleRight && parent.mouseX < parent.width)
				{
					this.width = Math.max(savedWindowRect.width + dragAmountX, minWidth);
				}
				else if(currentResizeHandle == resizeHandleBottom && parent.mouseY < parent.height)
				{
					this.height = Math.max(savedWindowRect.height + dragAmountY, minHeight);
				}
				else if(currentResizeHandle == resizeHandleLeft && parent.mouseX > 0)
				{
					this.x = Math.min(savedWindowRect.x + dragAmountX, dragMaxX);
					this.width = Math.max(savedWindowRect.width - dragAmountX, minWidth);
				}
				else if(currentResizeHandle == resizeHandleTL && parent.mouseX > 0 && parent.mouseY > 0)
				{
					this.x = Math.min(savedWindowRect.x + dragAmountX, dragMaxX);
					this.y = Math.min(savedWindowRect.y + dragAmountY, dragMaxY);
					this.width = Math.max(savedWindowRect.width - dragAmountX, minWidth);
					this.height = Math.max(savedWindowRect.height - dragAmountY, minHeight);				
				}
				else if(currentResizeHandle == resizeHandleTR && parent.mouseX < parent.width && parent.mouseY > 0)
				{
					this.y = Math.min(savedWindowRect.y + dragAmountY, dragMaxY);
					this.width = Math.max(savedWindowRect.width + dragAmountX, minWidth);
					this.height = Math.max(savedWindowRect.height - dragAmountY, minHeight);
				}
				else if(currentResizeHandle == resizeHandleBR && parent.mouseX < parent.width && parent.mouseY < parent.height)
				{
					this.width = Math.max(savedWindowRect.width + dragAmountX, minWidth);
					this.height = Math.max(savedWindowRect.height + dragAmountY, minHeight);
				}
				else if(currentResizeHandle == resizeHandleBL && parent.mouseX > 0 && parent.mouseY < parent.height)
				{
					this.x = Math.min(savedWindowRect.x + dragAmountX, dragMaxX);
					this.width = Math.max(savedWindowRect.width - dragAmountX, minWidth);
					this.height = Math.max(savedWindowRect.height + dragAmountY, minHeight);
				}
			}
		}
		
		private function onResizeButtonRelease(event:MouseEvent = null):void
		{
			if(windowState == MDIWindowState.NORMAL && resizable)
			{
				if(_resizing)
				{
					_resizing = false;
					dispatchEvent(new MDIWindowEvent(MDIWindowEvent.RESIZE_END, this));
				}
				currentResizeHandle = null;
				systemManager.removeEventListener(Event.ENTER_FRAME, updateWindowSize);
				systemManager.removeEventListener(MouseEvent.MOUSE_MOVE, onResizeButtonDrag);
				systemManager.removeEventListener(MouseEvent.MOUSE_UP, onResizeButtonRelease);
				systemManager.stage.removeEventListener(Event.MOUSE_LEAVE, onMouseLeaveStage);
				CursorManager.removeCursor(CursorManager.currentCursorID);
			}
		}
		
		private function onMouseLeaveStage(event:Event):void
		{
			onResizeButtonRelease();
			systemManager.stage.removeEventListener(Event.MOUSE_LEAVE, onMouseLeaveStage);
		}
		
		/**
		 * Restore window to state it was in prior to being minimized.
		 */
		public function unMinimize(event:MouseEvent = null):void
		{
			if(minimized)
			{
				showControls = true;
				
				windowState = _prevWindowState;
				if(windowState == MDIWindowState.NORMAL)
				{
					dispatchEvent(new MDIWindowEvent(MDIWindowEvent.RESTORE, this));
				}
				else
				{
					dispatchEvent(new MDIWindowEvent(MDIWindowEvent.MAXIMIZE, this));
				}
			}
		}
		//DEFAULT CURSORS
		[Embed(source="/flexmdi/assets/img/resizeCursorH.gif")]
		private static var resizeCursorHorizontalSkin:Class;
		private static var resizeCursorHorizontalSkinXOffset:Number = -10;
		private static var resizeCursorHorizontalSkinYOffset:Number = -10;
		
		[Embed(source="/flexmdi/assets/img/resizeCursorV.gif")]
		private static var resizeCursorVerticalSkin:Class;
		private static var resizeCursorVerticalSkinXOffset:Number = -10;
		private static var resizeCursorVerticalSkinYOffset:Number = -10;
		
		[Embed(source="/flexmdi/assets/img/resizeCursorTLBR.gif")]
		private static var resizeCursorTopLeftBottomRightSkin:Class;
		private static var resizeCursorTopLeftBottomRightSkinXOffset:Number = -10;
		private static var resizeCursorTopLeftBottomRightSkinYOffset:Number = -10;
		
		[Embed(source="/flexmdi/assets/img/resizeCursorTRBL.gif")]
		private static var resizeCursorTopRightBottomLeftSkin:Class;
		private static var resizeCursorTopRightBottomLeftSkinXOffset:Number = -10;
		private static var resizeCursorTopRightBottomLeftSkinYOffset:Number = -10;
		
		//DEFAULT CONTROL BUTTONS
		[Embed(source="/flexmdi/assets/img/closeButton.png")]
		private static var defaultCloseButton:Class;
		
		[Embed(source="/flexmdi/assets/img/decreaseButton.png")]
		private static var defaultDecreaseButton:Class;
		
		[Embed(source="/flexmdi/assets/img/increaseButton.png")]
		private static var defaultIncreaseButton:Class;
		
		[Embed(source="/flexmdi/assets/img/minimizeButton.png")]
		private static var defaultMinimizeButton:Class;
		
		
		
		private static var classConstructed:Boolean = classConstruct();
		
		private static function classConstruct():Boolean
		{
		//CURSOR STYLES
			if(!StyleManager.getStyleDeclaration(".mdiWindowCursorStyle"))
			{
				//scope of 'this' is the cursorStyle instance
				var cursorStyle:CSSStyleDeclaration = new CSSStyleDeclaration();
				cursorStyle.defaultFactory = function():void
				{
					this.resizeCursorVerticalSkin = resizeCursorVerticalSkin;
					this.resizeCursorVerticalSkinXOffset = resizeCursorVerticalSkinXOffset;
					this.resizeCursorVerticalSkinYOffset = resizeCursorVerticalSkinYOffset;
					
					this.resizeCursorHorizontalSkin = resizeCursorHorizontalSkin;
					this.resizeCursorHorizontalSkinXOffset = resizeCursorHorizontalSkinXOffset;
					this.resizeCursorHorizontalSkinYOffset = resizeCursorHorizontalSkinYOffset;
					
					this.resizeCursorTopLeftBottomRightSkin = resizeCursorTopLeftBottomRightSkin;
					this.resizeCursorTopLeftBottomRightSkinXOffset = resizeCursorTopLeftBottomRightSkinXOffset;
					this.resizeCursorTopLeftBottomRightSkinYOffset = resizeCursorTopLeftBottomRightSkinYOffset;
					
					this.resizeCursorTopRightBottomLeftSkin = resizeCursorTopRightBottomLeftSkin;
					this.resizeCursorTopRightBottomLeftSkinXOffset = resizeCursorTopRightBottomLeftSkinXOffset;
					this.resizeCursorTopRightBottomLeftSkinYOffset = resizeCursorTopRightBottomLeftSkinYOffset;
				}
				StyleManager.setStyleDeclaration(".mdiWindowCursorStyle", cursorStyle, true);
			}
		//WINDOW STYLES
			if(!StyleManager.getStyleDeclaration(".mdiWindowFocus"))
			{
				var focusStyle:CSSStyleDeclaration = new CSSStyleDeclaration();
				StyleManager.setStyleDeclaration(".mdiWindowFocus", focusStyle, true);
			}
			
			if(!StyleManager.getStyleDeclaration('.mdiWindowFocus').getStyle('controlButtonWidth'))
				StyleManager.getStyleDeclaration('.mdiWindowFocus').setStyle('controlButtonWidth', 10);
			if(!StyleManager.getStyleDeclaration('.mdiWindowFocus').getStyle('controlButtonHeight'))
				StyleManager.getStyleDeclaration('.mdiWindowFocus').setStyle('controlButtonHeight', 10);
			if(!StyleManager.getStyleDeclaration('.mdiWindowFocus').getStyle('controlButtonGap'))
				StyleManager.getStyleDeclaration('.mdiWindowFocus').setStyle('controlButtonGap', 8);
			
			if(!StyleManager.getStyleDeclaration(".mdiWindowNoFocus"))
			{
				var noFocusStyle:CSSStyleDeclaration = new CSSStyleDeclaration();
				StyleManager.setStyleDeclaration(".mdiWindowNoFocus", noFocusStyle, true);
			}
			
			if(!StyleManager.getStyleDeclaration('.mdiWindowNoFocus').getStyle('controlButtonWidth'))
				StyleManager.getStyleDeclaration('.mdiWindowNoFocus').setStyle('controlButtonWidth', 10);
			if(!StyleManager.getStyleDeclaration('.mdiWindowNoFocus').getStyle('controlButtonHeight'))
				StyleManager.getStyleDeclaration('.mdiWindowNoFocus').setStyle('controlButtonHeight', 10);
			if(!StyleManager.getStyleDeclaration('.mdiWindowNoFocus').getStyle('controlButtonGap'))
				StyleManager.getStyleDeclaration('.mdiWindowNoFocus').setStyle('controlButtonGap', 8);
				
				
		//CLOSE BUTTON
			if(!StyleManager.getStyleDeclaration(".closeBtnFocus"))
			{
				var closeBtnFocusStyle:CSSStyleDeclaration = new CSSStyleDeclaration();
				closeBtnFocusStyle.defaultFactory = function():void
				{
					this.upSkin = defaultCloseButton;
					this.overSkin = defaultCloseButton;
					this.downSkin = defaultCloseButton;
					this.disabledSkin = defaultCloseButton;
				}
				StyleManager.setStyleDeclaration(".closeBtnFocus", closeBtnFocusStyle, true);
			}
			
			if(!StyleManager.getStyleDeclaration(".closeBtnNoFocus"))
			{
				var closeBtnNoFocusStyle:CSSStyleDeclaration = new CSSStyleDeclaration();
				closeBtnNoFocusStyle.defaultFactory = function():void
				{
					this.upSkin = defaultCloseButton;
					this.overSkin = defaultCloseButton;
					this.downSkin = defaultCloseButton;
					this.disabledSkin = defaultCloseButton;
				}
				StyleManager.setStyleDeclaration(".closeBtnNoFocus", closeBtnNoFocusStyle, true);
			}
			
		//INCREASE BUTTON
			if(!StyleManager.getStyleDeclaration(".increaseBtnFocus"))
			{
				var increaseBtnFocusStyle:CSSStyleDeclaration = new CSSStyleDeclaration();
				increaseBtnFocusStyle.defaultFactory = function():void
				{
					this.upSkin = defaultIncreaseButton;
					this.overSkin = defaultIncreaseButton;
					this.downSkin = defaultIncreaseButton;
					this.disabledSkin = defaultIncreaseButton;
				}
				StyleManager.setStyleDeclaration(".increaseBtnFocus", increaseBtnFocusStyle, true);
			}
			
			if(!StyleManager.getStyleDeclaration(".increaseBtnNoFocus"))
			{
				var increaseBtnNoFocusStyle:CSSStyleDeclaration = new CSSStyleDeclaration();
				increaseBtnNoFocusStyle.defaultFactory = function():void
				{
					this.upSkin = defaultIncreaseButton;
					this.overSkin = defaultIncreaseButton;
					this.downSkin = defaultIncreaseButton;
					this.disabledSkin = defaultIncreaseButton;
				}
				StyleManager.setStyleDeclaration(".increaseBtnNoFocus", increaseBtnNoFocusStyle, true);
			}
			
		//DECREASE BUTTON
			if(!StyleManager.getStyleDeclaration(".decreaseBtnFocus"))
			{
				var decreaseBtnFocusStyle:CSSStyleDeclaration = new CSSStyleDeclaration();
				decreaseBtnFocusStyle.defaultFactory = function():void
				{
					this.upSkin = defaultDecreaseButton;
					this.overSkin = defaultDecreaseButton;
					this.downSkin = defaultDecreaseButton;
					this.disabledSkin = defaultDecreaseButton;
				}
				StyleManager.setStyleDeclaration(".decreaseBtnFocus", decreaseBtnFocusStyle, true);
			}
			
			if(!StyleManager.getStyleDeclaration(".decreaseBtnNoFocus"))
			{
				var decreaseBtnNoFocusStyle:CSSStyleDeclaration = new CSSStyleDeclaration();
				decreaseBtnNoFocusStyle.defaultFactory = function():void
				{
					this.upSkin = defaultDecreaseButton;
					this.overSkin = defaultDecreaseButton;
					this.downSkin = defaultDecreaseButton;
					this.disabledSkin = defaultDecreaseButton;
				}
				StyleManager.setStyleDeclaration(".decreaseBtnNoFocus", decreaseBtnNoFocusStyle, true);
			}
			
		//MINIMIZE BUTTON
			var minimizeBtnFocusStyle:CSSStyleDeclaration;
				
			if(!StyleManager.getStyleDeclaration(".minimizeBtnFocus"))
			{
				minimizeBtnFocusStyle = new CSSStyleDeclaration();
				minimizeBtnFocusStyle.defaultFactory = function():void
				{
					this.upSkin = defaultMinimizeButton;
					this.overSkin = defaultMinimizeButton;
					this.downSkin = defaultMinimizeButton;
					this.disabledSkin = defaultMinimizeButton;
				}
				StyleManager.setStyleDeclaration(".minimizeBtnFocus", minimizeBtnFocusStyle, true);
			}
			
			if(!StyleManager.getStyleDeclaration(".minimizeBtnNoFocus"))
			{
				minimizeBtnFocusStyle = new CSSStyleDeclaration();
				minimizeBtnFocusStyle.defaultFactory = function():void
				{
					this.upSkin = defaultMinimizeButton;
					this.overSkin = defaultMinimizeButton;
					this.downSkin = defaultMinimizeButton;
					this.disabledSkin = defaultMinimizeButton;
				}
				StyleManager.setStyleDeclaration(".minimizeBtnNoFocus", minimizeBtnFocusStyle, true);
			}
			
			return true;
		}
		
		private function getHighestPriorityStyle(styleName:String):Object
		{
			var hierarchy:Array = new Array(this, StyleManager.getStyleDeclaration("." + cursorStyleName), StyleManager.getStyleDeclaration(".mdiWindowCursorStyle"));
			
			for(var i:int = 0, n:int = hierarchy.length; i < n; i++)
			{
				if(hierarchy[i].getStyle(styleName))
				{
					return hierarchy[i].getStyle(styleName);
				}
			}
			return MDIWindow[styleName];
		}
		
		private function setCursor(target:Button):void
		{
			var styleName:String;
			
			switch(target)
			{
				case resizeHandleRight:
				case resizeHandleLeft:
					styleName = "resizeCursorHorizontalSkin";
				break;
				
				case resizeHandleTop:
				case resizeHandleBottom:
					styleName = "resizeCursorVerticalSkin";
				break;
				
				case resizeHandleTL:
				case resizeHandleBR:
					styleName = "resizeCursorTopLeftBottomRightSkin";
				break;
				
				case resizeHandleTR:
				case resizeHandleBL:
					styleName = "resizeCursorTopRightBottomLeftSkin";
				break;
			}
			
			CursorManager.removeCursor(CursorManager.currentCursorID);
			CursorManager.setCursor(Class(getHighestPriorityStyle(styleName)), 2, Number(getHighestPriorityStyle(styleName + "XOffset")), Number(getHighestPriorityStyle(styleName + "YOffset")));
		}
		
		private function onResizeButtonRollOver(event:MouseEvent):void
		{
			// only floating windows can be resized
			// event.buttonDown is to detect being dragged over
			if(windowState == MDIWindowState.NORMAL && resizable && !event.buttonDown)
			{
				setCursor(event.target as Button);
			}
		}
		
		private function onResizeButtonRollOut(event:MouseEvent):void
		{
			if(!event.buttonDown)
			{
				CursorManager.removeCursor(CursorManager.currentCursorID);
			}
		}
		
		public function set showControls(value:Boolean):void
		{
			controlsHolder.visible = value;
			if(cornerResizeImg != null)
				cornerResizeImg.visible = value;
		}
		
		private function get windowState():int
		{
			return _windowState;
		}
		
		private function set windowState(newState:int):void
		{
			_prevWindowState = _windowState;
			_windowState = newState;
			
			updateContextMenu(_windowState);
		}
		
		public function get minimized():Boolean
		{
			return _windowState == MDIWindowState.MINIMIZED;
		}
		
		public function get maximized():Boolean
		{
			return _windowState == MDIWindowState.MAXIMIZED;
		}
		
		public function updateContextMenu(currentState:int):void
		{
			var defaultContextMenu : ContextMenu = new ContextMenu();
				defaultContextMenu.hideBuiltInItems();
			
			var minimizeItem:ContextMenuItem = new ContextMenuItem("Minimize");
		  		minimizeItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
		  		minimizeItem.enabled = currentState != MDIWindowState.MINIMIZED;
		  		defaultContextMenu.customItems.push(minimizeItem);	
			
			var maximizeItem:ContextMenuItem = new ContextMenuItem("Maximize");
		  		maximizeItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
		  		maximizeItem.enabled = currentState != MDIWindowState.MAXIMIZED;
		  		defaultContextMenu.customItems.push(maximizeItem);	
			
			var restoreItem:ContextMenuItem = new ContextMenuItem("Restore");
		  		restoreItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
		  		restoreItem.enabled = currentState != MDIWindowState.NORMAL;
		  		defaultContextMenu.customItems.push(restoreItem);	
			
			var closeItem:ContextMenuItem = new ContextMenuItem("Close");
		  		closeItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
		  		defaultContextMenu.customItems.push(closeItem);  
	

			var arrangeItem:ContextMenuItem = new ContextMenuItem("Auto Arrange");
				arrangeItem.separatorBefore = true;
		  		arrangeItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);	
		  		defaultContextMenu.customItems.push(arrangeItem);

       	 	var arrangeFillItem:ContextMenuItem = new ContextMenuItem("Auto Arrange Fill");
		  		arrangeFillItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);  	
		  		defaultContextMenu.customItems.push(arrangeFillItem);   
               	
            var cascadeItem:ContextMenuItem = new ContextMenuItem("Cascade");
		  		cascadeItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
		  		defaultContextMenu.customItems.push(cascadeItem);                     	
			
			var showAllItem:ContextMenuItem = new ContextMenuItem("Show All Windows");
		  		showAllItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
		  		defaultContextMenu.customItems.push(showAllItem);  
			
        	this.contextMenu = defaultContextMenu;
		}
		
		private function menuItemSelectHandler(event:ContextMenuEvent):void
		{
			switch(event.target.caption)
			{
				case("Minimize"):
					minimize();
				break;
				
				case("Maximize"):
					maximize();
				break;
				
				case("Restore"):
					if(this.windowState == MDIWindowState.MINIMIZED)
					{
						unMinimize();
					}
					else if(this.windowState == MDIWindowState.MAXIMIZED)
					{
						maximizeRestore();
					}	
				break;
				
				case("Close"):
					close();
				break;
				
				case("Auto Arrange"):
					this.windowManager.tile(false, this.windowManager.tilePadding);
				break;
				
				case("Auto Arrange Fill"):
					this.windowManager.tile(true, this.windowManager.tilePadding);
				break;
				
				case("Cascade"):
					this.windowManager.cascade();
				break;
				
				case("Show All Windows"):
					this.windowManager.showAllWindows();
				break;

			}
		}
	}
}