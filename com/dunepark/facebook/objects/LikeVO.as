package com.dunepark.facebook.objects
{
	public class LikeVO
	{
		public var category:String;
		public var id:String;
		public var name:String;
		
		public function LikeVO( likeObject:Object )
		{
			this.category = likeObject.category;
			this.id = likeObject.id;
			this.name = likeObject.name;
		}
	}
}