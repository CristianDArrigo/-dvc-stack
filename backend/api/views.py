from django.http import JsonResponse
from django.db import connection
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny
from rest_framework.response import Response


@api_view(["GET"])
@permission_classes([AllowAny])
def hello(request):
    """
    Test endpoint to verify API is working.
    """
    return Response({"message": "Hello, World!"})


@api_view(["GET"])
@permission_classes([AllowAny])
def health(request):
    """
    Health check endpoint for monitoring and container orchestration.

    Returns:
        - status: "healthy" or "unhealthy"
        - database: "connected" or "disconnected"
        - version: API version
    """
    # Check database connection
    db_status = "connected"
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT 1")
    except Exception:
        db_status = "disconnected"

    status = "healthy" if db_status == "connected" else "unhealthy"

    response_data = {
        "status": status,
        "database": db_status,
        "version": "1.0.0",
    }

    status_code = 200 if status == "healthy" else 503
    return Response(response_data, status=status_code)
