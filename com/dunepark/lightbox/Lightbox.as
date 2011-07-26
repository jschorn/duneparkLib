package com.dunepark.lightbox
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BevelFilter;
	import flash.filters.DropShadowFilter;
	import flash.net.URLRequest;
	
	public class Lightbox extends Sprite
	{
		private var displayObject:DisplayObject;
		private var loader:Loader;
		private var source:String;
		private var modalBackground:Sprite;
		private var closeButton:Sprite;
		private static var instance:Lightbox;
		private static var allowInstantiation:Boolean;

		public function Lightbox()
		{
			if (!allowInstantiation) 
			{
				throw new Error("Error: Instantiation failed: Use Lightbox.getInstance() instead of new.");
			}		
		}
		
		/**
		 * Lightbox is singleton that only gets added to the displaylist once. 
		 * Create an instance using Lightbox.getInstance().
		 * Then add that instance to the displaylist.
		 *  
		 * @return 
		 * 
		 */		
		public static function getInstance():Lightbox 
		{
			if (instance == null) 
			{
				allowInstantiation = true;
				instance = new Lightbox();
				instance.loader = new Loader();
				instance.loader.filters = [new DropShadowFilter(7, 45, 0, .6, 15, 15, 1, 3)];
				instance.addChild(instance.loader);
				instance.createModalBackground();	
				allowInstantiation = false;
			}
					
			return instance;
		}
		
		public function showDisplayObject( displayObject:DisplayObject, useDefaultCloseButton:Boolean = false):void
		{
			this.displayObject = displayObject;
			displayObject.addEventListener(Event.CLOSE, onDisplayObjectClose, false, 0, true);
			addChild(displayObject);
			modalBackground.visible = true;
			centerDisplayObject();
			if (useDefaultCloseButton)
				showCloseButton();
		}
		
		/**
		 * Use Lightbox.showImage( source, isModal) to display a lightbox image anywhere in the application. 
		 * Source is a String for the url for the jpg, png, or swf that you want to display in the lightbox. 
		 * if isModal is set to true, a 50% black opaque background will overlay the app to prevent interaction other than the close button.  
		 * @param source
		 * @param isModel
		 * 
		 */		
		public function showImage( source:String, useDefaultCloseButton:Boolean = false ):void
		{			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete, false, 0, true);
			loader.load( new URLRequest( source ) );
		}
		
		/**
		 * call Lightbox.resize(appWidth, appHeight) once when adding lightbox to display list, 
		 * and additional times for resize events.  
		 * @param appWidth
		 * @param appHeight
		 * 
		 */		
		public function resize( appWidth:Number, appHeight:Number):void
		{
			modalBackground.width = appWidth + 10;			
			modalBackground.height = appHeight + 10;
			centerLoader();
			centerDisplayObject();
		}

		private function removeImage():void
		{
			loader.unload();
		}
		
		private function removeDisplayObject():void
		{
			try
			{
				removeChild( displayObject);
			}
			catch(e:Error){}
		}
			
		private function createModalBackground():void
		{
			modalBackground = new Sprite();
			modalBackground.graphics.lineStyle(1, 0, 0, true, "none");
			modalBackground.graphics.beginFill(0x000000, .7);
			modalBackground.graphics.drawRect(0, 0, 200, 200);
			modalBackground.graphics.endFill();
			modalBackground.visible = false;
			modalBackground.addEventListener(MouseEvent.CLICK, onCloseClick, false, 0, true);
			addChildAt(modalBackground, 0);			
		}
		
		
		private function onLoaderComplete(event:Event):void
		{
			showCloseButton();
			modalBackground.visible = true;
			centerLoader();
			loader.x = this.width * .5 - loader.width * .5;
			loader.y = this.height * .5 - loader.height * .5;
		}
		
		private function centerDisplayObject():void
		{
			try
			{
				displayObject.x = this.width * .5 - displayObject.width * .5;
				displayObject.y = this.height * .5 - displayObject.height * .5;				
				closeButton.x = displayObject.x + displayObject.width;
				closeButton.y = displayObject.y;				
			}
			catch(e:Error){}
		}
		
		private function centerLoader():void
		{
			if (loader != null)
			{
				loader.x = this.width * .5 - loader.width * .5;
				loader.y = this.height * .5 - loader.height * .5;
			}
			if (closeButton != null)
			{
				closeButton.x = loader.x + loader.width;
				closeButton.y = loader.y;
			}
		}
		
		/**
		 * Override this function for a custom close button  
		 * 
		 */		
		protected function showCloseButton():void
		{
			closeButton = new Sprite();
			var shape:Shape = new Shape();
			shape.graphics.lineStyle(3, 0x333333, 1, true, "none");
			shape.graphics.beginFill(0xffffff, .9);
			shape.graphics.drawCircle(0,0, 10)
			shape.graphics.endFill();
			shape.graphics.moveTo(-4, -4);
			shape.graphics.lineTo(4, 4);
			shape.graphics.moveTo(-4, 4);
			shape.graphics.lineTo(4, -4);
			closeButton.addChild(shape);
			this.addChild( closeButton );
			closeButton.buttonMode = true;
			closeButton.addEventListener(MouseEvent.CLICK, onCloseClick, false, 0, true);
			centerLoader();
		}
		
		private function onDisplayObjectClose(event:Event):void
		{
			onCloseClick(null);
		}
		
		public function onCloseClick(event:MouseEvent):void
		{
			if (closeButton != null)
			{
				closeButton.parent.removeChild( closeButton );
				closeButton.removeEventListener(MouseEvent.CLICK, onCloseClick);
				closeButton = null;
			}
			removeImage();
			removeDisplayObject();
			this.modalBackground.visible = false;
		}
	}
}

