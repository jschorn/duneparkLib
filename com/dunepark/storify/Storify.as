/**
 *	AUTHOR: Joe Schorn
 *	Storify API
 *	
 */

package com.dunepark.storify
{
	import com.adobe.serialization.json.JSON;
	import com.dunepark.storify.events.StorifyEvent;
	import com.dunepark.storify.objects.AuthorVO;
	import com.dunepark.storify.objects.StorifyElementVO;
	import com.dunepark.storify.objects.StoryVO;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * @eventType com.dunepark.storify.events.StorifyEvent.COMPLETE 
	 */		
	[Event(name="complete", type="com.dunepark.storify.events.StorifyEvent")]

	/**
	 * @eventType com.dunepark.storify.events.StorifyEvent.ERROR 
	 */		
	[Event(name="error", type="com.dunepark.storify.events.StorifyEvent")]
	
	
	public class Storify extends EventDispatcher
	{		
		public static const SOURCE_STORIFY:String = "storify";
		public static const SOURCE_YOUTUBE:String = "youtube";
		public static const SOURCE_TWITTER:String = "twitter";
		public static const SOURCE_FACEBOOK:String = "facebook";
		public static const SOURCE_FLICKR:String = "flickr";
		public static const SOURCE_GOOGLE:String = "google";		
		public static const SOURCE_CNET:String = "Cnet";
		public static const SOURCE_ENGADGET:String = "Engadget";

		public static const TYPE_TWEET:String = "tweet";
		public static const TYPE_FACEBOOK:String = "fbpost";
		public static const TYPE_PHOTO:String = "photo";
		public static const TYPE_VIDEO:String = "video";
		public static const TYPE_WEBSITE:String = "website";
		
		private var urlLoader:URLLoader;
		private var rootURL:String;
		private var proxyURL:String;
	
		public function Storify( rootURL:String, proxyURL:String )
		{
			this.rootURL = rootURL;
			this.proxyURL = proxyURL;
			init();
		}
		
		public function loadStory(storyName:String):void
		{
			var storyURL:String = proxyURL + "?url=" + rootURL + storyName + ".json"
			urlLoader.addEventListener(Event.COMPLETE, onStoryLoadComplete);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			urlLoader.load( new URLRequest( storyURL ) );
			urlLoader.dataFormat = "text";
		}
	
		private function init():void
		{
			urlLoader = new URLLoader();
		}
		
		private function parseStoryElements(rawData:String):void
		{
			var elements:Vector.<StorifyElementVO> = new Vector.<StorifyElementVO>;			
			var storyObject:Object = JSON.decode( rawData ).contents;			
			for each (var obj:Object in storyObject.elements )
			{
				elements.push(new StorifyElementVO( obj, storyObject.topics ));	
			}
			var authorVO:AuthorVO = new AuthorVO( storyObject.author );
			var storyVO:StoryVO = new StoryVO( storyObject );
			dispatchEvent( new StorifyEvent (StorifyEvent.COMPLETE, storyVO, elements) );	
		}
		
		/////////// EVENT HANDLERS ///////////
		
		private function onStoryLoadComplete(event:Event):void
		{
			parseStoryElements( urlLoader.data as String );
			urlLoader.removeEventListener(Event.COMPLETE, onStoryLoadComplete);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
		}
				
		private function onError(event:IOErrorEvent):void
		{
			dispatchEvent( new StorifyEvent (StorifyEvent.ERROR) );
			urlLoader.removeEventListener(Event.COMPLETE, onStoryLoadComplete);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
		}
	}
}