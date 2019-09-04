import argparse
import requests
import json
import os

import pdb

## don't push ids
client_id = ""
client_secret = ""

# Generator definition for iterating over pages
def list_pages(api_url, token):
    has_next = True
    page = 1
    while has_next:
        response = requests.get(api_url + '{}page={}'.format("&", page),
                                headers={'Authorization': 'Bearer ' + token}).json()
        yield response
        page += 1
        has_next = response['meta']['has_next']

# account for pagination while parsing stepik grades
## iterating over a generator
## checks the folder and create if needed
## fills in with json
def extract_pages(api_url, token, course_id):

    response = list_pages(api_url, token)

    if "course_{}".format(course_id) in os.listdir("./data/raw/stepik"):
        print("Folder already exists")
    else:
        # pdb.set_trace()
        print("Creating folder ./data/raw/stepik/course_{}".format(course_id))
        os.makedirs("./data/raw/stepik/course_{}".format(course_id))

    ## if there is no next page, when don't write
    for page in response:
        if page['meta']['has_next'] == True:
            with open('./data/raw/stepik/course_{}/course_grades_{}_page_{}.json'.format(course_id,course_id, page['meta']['page']), 'w') as outfile:
                json.dump(page, outfile)
        else:
            print("Last page is parsed (page {})".format(page['meta']['page']))

## wrap into function
def fetch_course_data(client_id, client_secret, course_id):

    # Get a token
    auth = requests.auth.HTTPBasicAuth(client_id, client_secret)
    response = requests.post('https://stepik.org/oauth2/token/',
                             data={'grant_type': 'client_credentials'},
                             auth=auth)

    token = response.json().get('access_token', None)
    if not token:
        print('Unable to authorize with provided credentials')
        exit(1)
    print(token)

    # Call API (https://stepik.org/api/docs/) using this token.
    api_url = "https://stepik.org/api/course-grades?course={}".format(course_id)

    course_grades = requests.get(api_url,
                        headers={'Authorization': 'Bearer ' + token}).json()
    
    extract_pages(api_url, token, course_id)

    ## write to file OR stream directly to R
    with open('course_grades_{}.json'.format(course_id), 'w') as outfile:
        json.dump(course_grades, outfile)


def parse_args():
    parser = argparse.ArgumentParser(description='Fetches stpeik course')
    parser.add_argument('-ci','--clientId',      help='Client ID', required=True)
    parser.add_argument('-cs','--clientSecret',  help='Client Secret', required=True)
    parser.add_argument('-id','--courseId',      help='Course ID', required=True)
    args = vars(parser.parse_args())

    return args

def main():
    fetch_course_data(client_id=parse_args()['clientId'], client_secret=parse_args()['clientSecret'], course_id=parse_args()['courseId'])


if __name__== "__main__":
    main()