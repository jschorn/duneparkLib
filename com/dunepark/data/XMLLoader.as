package com.dunepark.data
{	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
					
	public class XMLLoader extends EventDispatcher
	{
		private var _data:	XML;

		public function get data():XML
		{
			return _data;
		}

		public function set data(value:XML):void
		{
			_data = value;
		}
	
		private var _dataPath:	String = "data/data.xml";

		public function get dataPath():String
		{
			return _dataPath;
		}

		public function set dataPath(value:String):void
		{
			_dataPath = value;
		}
		
		public function XMLLoader(dataPath:String = "")
		{
			_dataPath = dataPath
		}
		
		public function load():void
		{
			var xmlLoader:URLLoader = new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE, dataLoaded, false, 0, true);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, onLoadError, false, 0, true);
			xmlLoader.load(new URLRequest(_dataPath));
		}
		
		protected function dataLoaded(e:Event):void
		{	
			trace("XMLLoader.dataLoaded :: dataLoaded from " + _dataPath)
			e.currentTarget.removeEventListener(Event.COMPLETE, dataLoaded);
			_data = new XML(e.target.data);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function onLoadError(e:IOErrorEvent):void
		{
			e.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			trace("XMLLoader.onLoadError :: Error -- failed to load xml -- " + e);
		}
			
	}
}