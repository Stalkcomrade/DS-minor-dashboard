# /srv/store/principal/audit/r-console/
# mongo --host mongo.piterdata.ninja --username vle --password vfmke45gv9bg vle 
# db.logs.find({'entry_type': 'gist'})

import argparse
from pymongo import MongoClient

def parse_args():
    parser = argparse.ArgumentParser(description='Fetches MongoDB with logs')
    parser.add_argument('-u',   '--user',            help='username',    required=True)
    parser.add_argument('-pwd', '--password',        help='password',    required=True)
    parser.add_argument('-auth','--authSource',      help='auth source', required=True)
    args = vars(parser.parse_args())
    return args
    
username = parse_args()['user']
password = parse_args()['password']
authSource = parse_args()['authSource']

client = MongoClient('mongodb://%s:%s@mongo.piterdata.ninja' % (username, password), authSource=authSource)

db = client.vle
users = db.users.find()

## using lists as array
## dicts are objects
tempList = list()

for user in users:
    tempList.append(user)

print(client)
print(db)
print(users)
print(tempList)

#### users db

## TODO: display: 
#   group
#   programme
#   stepik_id (for matching)
#   filter by a server


#### 


## TODO: read individual jsonl files from a remote server

# if __name__== "__main__":
#     main()