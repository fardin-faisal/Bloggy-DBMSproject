from django.urls import path
from .views import (
   user_handler, category_handler, post_handler, create_comment,
   create_like, users_handler, get_likes, get_comments
)

urlpatterns = [
    # User URLs

    path('user', user_handler),
    path('users/<int:user_id>', users_handler),
    path('category', category_handler),
    path('post', post_handler),

    path('comment', create_comment),
    path('like', create_like),
    
    path('comments/post/<int:post_id>', get_comments),
    path('likes/post/<int:post_id>', get_likes),
 
]


