from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .utils import database
import json

@api_view(['POST', 'GET'])
def user_handler(request):
    if request.method == 'POST':
        try:
            # Deserialize the request body
            body = json.loads(request.body)

            # Call the create_user database function
            database.cur.execute('SELECT create_user(%s);', (json.dumps(body),))
            result = json.loads(json.dumps(database.cur.fetchone()[0]))
            database.con.commit()            
            return Response(                {
                    "massage": result["status"] == "failed" and "User creation failed" or "User created successfully",                    "data": result
                },                status = result["status"] == "failed" and status.HTTP_400_BAD_REQUEST or status.HTTP_201_CREATED
            )

        except(Exception, database.Error) as e:
            database.con.rollback()
            print(f"Error while processing the request:\n{e}")
            return Response(
                {'message': f'Error while processing the request:\n{e}'},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )
            
    elif request.method == 'GET':
        try:
            page = request.GET.get("page", 1)
            limit = request.GET.get("limit", 10)
            
            database.cur.execute('''
            SELECT get_users(%s, %s)                    
            ''', (page, limit))
            
            result = json.loads(json.dumps(database.cur.fetchone()[0]))
            
            database.con.commit()

            return Response(
                {
                    "massage": result["status"] == "failed" and "User retrieval failed" or "User retrieved successfully",
                    "data": result
                },
                status = result["status"] == "failed" and status.HTTP_400_BAD_REQUEST or status.HTTP_200_OK
            )
            
        except(Exception, database.Error) as e:
            database.con.rollback()
            print(f"Error while processing the request:\n{e}")
            return Response(
                {'message': f'Error while processing the request:\n{e}'},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )

    

    else:
        return Response(
            {'message': f'Invalid request method {request.method}'},
            status=status.HTTP_405_METHOD_NOT_ALLOWED
        )
    
@api_view(['PATCH','DELETE'])
def users_handler(request, user_id):
    if request.method == 'PATCH':
        try:
            # Deserialize the request body
            body = json.loads(request.body)

            # Call the update_user database function
            database.cur.execute('SELECT update_user(%s, %s);', (user_id, json.dumps(body)))
            result = json.loads(json.dumps(database.cur.fetchone()[0]))
            database.con.commit()

            return Response(
                {
                    "message": result["status"] == "failed" and "User update failed" or "User updated successfully",
                    "data": result
                },
                status=result["status"] == "failed" and status.HTTP_400_BAD_REQUEST or status.HTTP_200_OK
            )

        except(Exception, database.Error) as e:
            database.con.rollback()
            print(f"Error while processing the request:\n{e}")
            return Response(
                {'message': f'Error while processing the request:\n{e}'},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )

    elif request.method == 'DELETE':
        try:
            # Call the delete_user database function
            database.cur.execute('SELECT delete_user(%s);', (user_id,))
            result = json.loads(json.dumps(database.cur.fetchone()[0]))
            database.con.commit()

            return Response(
                {
                    "message": result["status"] == "failed" and "User deletion failed" or "User deleted successfully",
                    "data": result
                },
                status=result["status"] == "failed" and status.HTTP_400_BAD_REQUEST or status.HTTP_200_OK
            )

        except(Exception, database.Error) as e:
            database.con.rollback()
            print(f"Error while processing the request:\n{e}")
            return Response(
                {'message': f'Error while processing the request:\n{e}'},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )

@api_view(['POST', 'GET'])
def category_handler(request):
    if request.method == 'POST':
        try:
            # Deserialize the request body
            body = json.loads(request.body)

            database.cur.execute('SELECT create_category(%s);', (json.dumps(body),))
            result = json.loads(json.dumps(database.cur.fetchone()[0]))
            database.con.commit()            
            return Response(                {
                    "massage": result["status"] == "failed" and "Category creation failed" or "Category created successfully",                    "data": result
                },                status = result["status"] == "failed" and status.HTTP_400_BAD_REQUEST or status.HTTP_201_CREATED
            )

        except(Exception, database.Error) as e:
            database.con.rollback()
            print(f"Error while processing the request:\n{e}")
            return Response(
                {'message': f'Error while processing the request:\n{e}'},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )
            
    elif request.method == 'GET':
        try:
            page = request.GET.get("page", 1)
            limit = request.GET.get("limit", 10)
            
            database.cur.execute('''
            SELECT get_categories(%s, %s)                    
            ''', (page, limit))
            
            result = json.loads(json.dumps(database.cur.fetchone()[0]))
            
            database.con.commit()

            return Response(
                {
                    "massage": result["status"] == "failed" and "Category retrieval failed" or "Category retrieved successfully",
                    "data": result
                },
                status = result["status"] == "failed" and status.HTTP_400_BAD_REQUEST or status.HTTP_200_OK
            )
            
        except(Exception, database.Error) as e:
            database.con.rollback()
            print(f"Error while processing the request:\n{e}")
            return Response(
                {'message': f'Error while processing the request:\n{e}'},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )

    else:
        return Response(
            {'message': f'Invalid request method {request.method}'},
            status=status.HTTP_405_METHOD_NOT_ALLOWED
        )
        
        
@api_view(['POST', 'GET'])
def post_handler(request):
    if request.method == 'POST':
        try:
            # Deserialize the request body
            body = json.loads(request.body)

            database.cur.execute('SELECT create_post(%s);', (json.dumps(body),))
            result = json.loads(json.dumps(database.cur.fetchone()[0]))
            database.con.commit()            
            return Response(                {
                    "massage": result["status"] == "failed" and "Post creation failed" or "Post created successfully",                    "data": result
                },                status = result["status"] == "failed" and status.HTTP_400_BAD_REQUEST or status.HTTP_201_CREATED
            )

        except(Exception, database.Error) as e:
            database.con.rollback()
            print(f"Error while processing the request:\n{e}")
            return Response(
                {'message': f'Error while processing the request:\n{e}'},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )
            
    elif request.method == 'GET':
        try:
            page = request.GET.get("page", 1)
            limit = request.GET.get("limit", 10)
            
            database.cur.execute('''
            SELECT get_posts(%s, %s)                    
            ''', (page, limit))
            
            result = json.loads(json.dumps(database.cur.fetchone()[0]))
            
            database.con.commit()

            return Response(
                {
                    "massage": result["status"] == "failed" and "Post retrieval failed" or "Post retrieved successfully",
                    "data": result
                },
                status = result["status"] == "failed" and status.HTTP_400_BAD_REQUEST or status.HTTP_200_OK
            )
            
        except(Exception, database.Error) as e:
            database.con.rollback()
            print(f"Error while processing the request:\n{e}")
            return Response(
                {'message': f'Error while processing the request:\n{e}'},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )

    else:
        return Response(
            {'message': f'Invalid request method {request.method}'},
            status=status.HTTP_405_METHOD_NOT_ALLOWED
        )
        

# @api_view(['POST'])
# def create_post_category(request):
#     if request.method == 'POST':
#         try:
#             # Deserialize the request body
#             body = json.loads(request.body)

#             # Call the create_post_category database function
#             cur.execute('SELECT create_post_category(%s);', (json.dumps(body),))
#             result = json.loads(json.dumps(cur.fetchone()[0]))
#             con.commit()

#             return Response({
#                 "message": result["status"] == "failed" and "Post category creation failed" or "Post category created successfully",
#                 "data": result
#             }, status=result["status"] == "failed" and status.HTTP_400_BAD_REQUEST or status.HTTP_201_CREATED)

#         except Error as e:
#             con.rollback()
#             print(f"Error while processing the request:\n{e}")
#             return Response(
#                 {'message': f'Error while processing the request:\n{e}'},
#                 status=status.HTTP_500_INTERNAL_SERVER_ERROR
#             )

#     else:
#         return Response(
#             {'message': f'Invalid request method {request.method}'},
#             status=status.HTTP_405_METHOD_NOT_ALLOWED
#         )


@api_view(['POST'])
def create_comment(request):
    if request.method == 'POST':
        try:
            # Deserialize the request body
            body = json.loads(request.body)

            # Call the create_comment database function
            database.cur.execute('SELECT create_comment(%s);', (json.dumps(body),))
            result = json.loads(json.dumps(database.cur.fetchone()[0]))
            database.con.commit()

            return Response({
                "message": result["status"] == "failed" and "Comment creation failed" or "Comment created successfully",
                "data": result
            }, status=result["status"] == "failed" and status.HTTP_400_BAD_REQUEST or status.HTTP_201_CREATED)

        except database.Error as e:
            database.con.rollback()
            print(f"Error while processing the request:\n{e}")
            return Response(
                {'message': f'Error while processing the request:\n{e}'},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )
            
    
    else:
        return Response(
            {'message': f'Invalid request method {request.method}'},
            status=status.HTTP_405_METHOD_NOT_ALLOWED
        )

@api_view(['GET'])
def get_comments(request, post_id):    
    if request.method == 'GET':
        try:
            
            # Call the get_comments database function
            database.cur.execute('SELECT get_comments(%s);', (post_id,))
            result = json.loads(json.dumps(database.cur.fetchone()[0]))
            database.con.commit()

            return Response({
                "message": "Comments retrieved successfully",
                "data": result
            }, status=status.HTTP_200_OK)

        except database.Error as e:
            database.con.rollback()
            print(f"Error while processing the request:\n{e}")
            return Response(
                {'message': f'Error while processing the request:\n{e}'},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )

    else:
        return Response(
            {'message': f'Invalid request method {request.method}'},
            status=status.HTTP_405_METHOD_NOT_ALLOWED
        )    

@api_view(['POST'])
def create_like(request):
    if request.method == 'POST':
        try:
            # Deserialize the request body
            body = json.loads(request.body)

            # Call the create_like database function
            database.cur.execute('SELECT create_like(%s);', (json.dumps(body),))
            result = json.loads(json.dumps(database.cur.fetchone()[0]))
            database.con.commit()

            return Response({
                "message": result["status"] == "failed" and "Like creation failed" or "Like created successfully",
                "data": result
            }, status=result["status"] == "failed" and status.HTTP_400_BAD_REQUEST or status.HTTP_201_CREATED)

        except database.Error as e:
            database.con.rollback()
            print(f"Error while processing the request:\n{e}")
            return Response(
                {'message': f'Error while processing the request:\n{e}'},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )

    else:
        return Response(
            {'message': f'Invalid request method {request.method}'},
            status=status.HTTP_405_METHOD_NOT_ALLOWED
        )


# @api_view(['GET'])
# def get_comments(request, post_id):
#     if request.method == 'GET':
#         try:
#             # Call the get_comments database function
#             database.cur.execute('SELECT get_comments(%s);', (post_id,))
#             result = json.loads(json.dumps(database.cur.fetchone()[0]))
#             database.con.commit()

#             return Response({
#                 "message": "Comments retrieved successfully",
#                 "data": result
#             }, status=status.HTTP_200_OK)

#         except database.Error as e:
#             database.con.rollback()
#             print(f"Error while processing the request:\n{e}")
#             return Response(
#                 {'message': f'Error while processing the request:\n{e}'},
#                 status=status.HTTP_500_INTERNAL_SERVER_ERROR
#             )

#     else:
#         return Response(
#             {'message': f'Invalid request method {request.method}'},
#             status=status.HTTP_405_METHOD_NOT_ALLOWED
#         )

@api_view(['GET'])
def get_likes(request, post_id):
    if request.method == 'GET':
        try:
            # Call the get_likes database function
            database.cur.execute('SELECT get_likes(%s);', (post_id,))
            result = json.loads(json.dumps(database.cur.fetchone()[0]))
            database.con.commit()

            return Response({
                "message": "Likes retrieved successfully",
                "data": result
            }, status=status.HTTP_200_OK)

        except database.Error as e:
            database.con.rollback()
            print(f"Error while processing the request:\n{e}")
            return Response(
                {'message': f'Error while processing the request:\n{e}'},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )

    else:
        return Response(
            {'message': f'Invalid request method {request.method}'},
            status=status.HTTP_405_METHOD_NOT_ALLOWED
        )

