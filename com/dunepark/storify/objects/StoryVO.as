package com.dunepark.storify.objects
{
	public class StoryVO
	{
		public var title:String
		public var description:String;
		public var link:String;
		public var thumbnail:String;
		public var publishDate:Number;
		public var date:Date;
		public var tags:Array;
		
		public function StoryVO( storyData:Object )
		{
			this.title = storyData.title;
			this.description = storyData.description;
			this.link = storyData.permalink + ".json";
			this.thumbnail = storyData.thumbnail;
			this.publishDate = storyData.published_at;
			this.date = new Date();
			this.date.setUTCDate( publishDate );	
			this.tags = storyData.topics as Array;
		}
		
	}
}