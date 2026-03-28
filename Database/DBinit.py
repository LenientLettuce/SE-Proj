import pymongo

def initialize_marketplace_db():
    # 1. Connect to local MongoDB instance
    client = pymongo.MongoClient("mongodb://localhost:27017/")
    db_name = "SE-Marketplace"
    
    # 2. Check if Database already exists
    existing_dbs = client.list_database_names()
    if db_name in existing_dbs:
        print(f"⚠️  Database '{db_name}' already exists. Skipping creation.")
    else:
        print(f"🆕 Creating Database: {db_name}")

    db = client[db_name]

    # 3. List of collections to ensure exist
    required_collections = [
        "Artisans", 
        "Categories", 
        "Orders", 
        "Products", 
        "Reviews", 
        "Users"
    ]

    # 4. Get current collections to avoid re-defining
    current_collections = db.list_collection_names()

    for col_name in required_collections:
        if col_name in current_collections:
            print(f"✔️  Collection '{col_name}' already exists. Skipping.")
        else:
            # Create the collection safely
            # We use a placeholder insert/delete to force physical creation
            temp_doc = db[col_name].insert_one({"init": True})
            db[col_name].delete_one({"_id": temp_doc.inserted_id})
            print(f"✅ Created new collection: {col_name}")

    print("\nInitialization check complete.")

if __name__ == "__main__":
    initialize_marketplace_db()