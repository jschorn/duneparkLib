package com.dunepark.facebook.objects
{
	import org.casalib.util.DateUtil;

	public class PostVO
	{
		public var timeCreated:String;
		public var date:Date;
		public var userName:String;
		public var userId:String;
		public var userIcon:String;
		public var postId:String;
		public var objectId:String;
		public var type:String;
		public var picture:String;
		public var name:String;
		
		public function PostVO( postObject:Object )
		{
			this.timeCreated = postObject.created_time;
			this.userName = postObject.from.name;
			this.userId = postObject.from.id;
			this.userIcon = postObject.icon;
			this.postId = postObject.id;
			this.type = postObject.type;
			
			if (postObject.object_id)
				this.objectId = postObject.object_id;
			
			if (postObject.picture)
				this.picture = postObject.picture;
			
			this.date = DateUtil.iso8601ToDate( postObject.created_time );
		}
	}
}