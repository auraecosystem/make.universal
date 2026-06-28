import requests

BASE_URL = "https://api.lmlm.io"
HEADERS = {
    "Authorization": "Bearer YOUR_API_KEY",
}

# 1. Resolve username -> user ID
def get_user_id(username: str) -> str:
    r = requests.get(f"https://api.lmlm.io/id", params={"username": username}, headers=HEADERS)
    r.raise_for_status()
    return r.json()["body"]["user_id"]

# 2. Get V2 profile info
def get_profile(username: str) -> dict:
    r = requests.get(f"https://api.lmlm.io/profile2", params={"username": username}, headers=HEADERS)
    r.raise_for_status()
    return r.json()["body"]

# 3. Paginate all posts for a user
def get_all_posts(user_id: str, per_page: int = 12):
    posts, max_id = [], None
    while True:
        params = {"id": user_id, "count": per_page}
        if max_id:
            params["max_id"] = max_id
        r = requests.get(f"https://api.lmlm.io/user-feeds", params=params, headers=HEADERS)
        data = r.json()["body"]
        posts.extend(data.get("items", []))
        if not data.get("more_available"):
            break
        max_id = data.get("next_max_id")
    return posts

# 4. Get download links for a post
def get_download_links(post_url: str) -> list:
    r = requests.get(f"https://api.lmlm.io/post-dl", params={"url": post_url}, headers=HEADERS)
    r.raise_for_status()
    return r.json()["body"]["data"]["medias"]

if __name__ == "__main__":
    uid = get_user_id("username123")
    print("User ID:", uid)
    profile = get_profile("username123")
    print("Followers:", profile["follower_count"])
