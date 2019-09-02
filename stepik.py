import argparse
import requests
import json


## TODO: account for pagination while parsing stepik grades

## don't push ids
client_id = ""
client_secret = ""

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

    # print(course_grades)

    ## FIXME: write to file OR stream directly to R
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