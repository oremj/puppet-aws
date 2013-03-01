class elasticsearch::user {
# Add a default celery user if one is not defined
  base::user{
   "${elasticsearch::user}":
      uid => '2005';
  }
}
