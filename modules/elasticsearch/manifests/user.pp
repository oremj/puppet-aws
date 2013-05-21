# elasticsearch user
class elasticsearch::user {
# Add a default elasticsearch user if one is not defined
  base::user{
    "${elasticsearch::user}":
        uid => '2005';
  }
}
