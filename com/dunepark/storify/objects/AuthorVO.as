package com.dunepark.storify.objects
{
	public class AuthorVO
	{
		public var avatar:String;
		public var description:String;
		public var location:String;
		public var name:String;
		public var userName:String;
		public var website:String;
		
		public function AuthorVO( authorObject:Object )
		{
			if (authorObject.avatar)
				this.avatar = authorObject.avatar;
			
			if (authorObject.avatar)
				this.description = authorObject.description;
			
			if (authorObject.location)	
				this.location = authorObject.location;
			
			if (authorObject.name)
				this.name = authorObject.name;
			
			if (authorObject.username)
				this.userName = authorObject.username;
			
			if (authorObject.website)
				this.website = authorObject.website;
			
			if (authorObject.href)
				this.website = authorObject.href;
		}
	}
}