package com.dunepark.storify.objects
{
	import com.dunepark.storify.Storify;

	public class StorifyElementVO
	{
		public var title:String;
		public var description:String;
		public var author:AuthorVO;
		public var type:String;
		public var source:String;
		public var image:String;
		public var favicon:String;
		public var embed:String;
		public var youtubeID:String;
		public var thumbnail:String;		
		public var tags:Array;
		
		public function StorifyElementVO( elementData:Object, tags:Array = null )
		{
			if ( elementData.title )	
				this.title = elementData.title;

			if ( elementData.description )	
				this.description = elementData.description;

			if ( elementData.author )
				this.author = new AuthorVO( elementData.author );
			
			if ( elementData.elementClass )	
				this.type = elementData.elementClass;
			
			if ( elementData.favicon )	
				this.favicon = elementData.favicon;
	
			if ( elementData.image )			
				this.image = elementData.image.src;
			
			if ( elementData.source )	
				this.source = elementData.source;
	
			if ( elementData.oembed && elementData.oembed != "" )
				this.embed = elementData.oembed.html;
			
			if ( elementData.source == Storify.SOURCE_YOUTUBE)
				this.youtubeID = (elementData.permalink as String ).split("v=")[1];
				
			if ( elementData.thumbnail )	
				this.thumbnail = elementData.thumbnail;
			
			this.tags = tags;
		}
	}
}