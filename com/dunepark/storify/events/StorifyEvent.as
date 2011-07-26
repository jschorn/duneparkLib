package com.dunepark.storify.events
{
	import com.dunepark.storify.objects.AuthorVO;
	import com.dunepark.storify.objects.StorifyElementVO;
	import com.dunepark.storify.objects.StoryVO;
	
	import flash.events.Event;
	
	public class StorifyEvent extends Event
	{
		public static const COMPLETE:String = "complete";
		public static const ERROR:String = "error";

		public var elements:Vector.<StorifyElementVO>;
		public var story:StoryVO;
		public var author:AuthorVO;
		
		public function StorifyEvent(type:String, story:StoryVO = null, elements:Vector.<StorifyElementVO> = null, author:AuthorVO = null)
		{
			this.story = story;
			this.elements = elements;
			this.author = author;
			super(type, false, false);
		}
	
		public override function clone() : Event
		{
			var event:StorifyEvent = new StorifyEvent( this.type, this.story, this.elements, this.author );
			return event;
		}	
	}
}