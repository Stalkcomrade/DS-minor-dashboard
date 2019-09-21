import json
import argparse
import requests
import matplotlib.pyplot as plt


def parse_args():
    parser = argparse.ArgumentParser(description='Fetches stpeik course')
    parser.add_argument('-ci','--clientId',      help='Client ID',     required=True)
    parser.add_argument('-cs','--clientSecret',  help='Client Secret', required=True)
    parser.add_argument('-id','--courseId',      help='Course ID',     required=True)
    args = vars(parser.parse_args())

    return args


client_id = parse_args()['clientId']
client_secret = parse_args()['clientSecret']
course_id = parse_args()['courseId']

auth = requests.auth.HTTPBasicAuth(client_id, client_secret)
resp = requests.post('https://stepik.org/oauth2/token/',
                     data={'grant_type': 'client_credentials'},
                     auth=auth)
token = json.loads(resp.text)["access_token"]


def make_stepik_api_call_pk(name, pk, key):
    api_url = 'https://stepik.org/api/{}/{}'.format(name, pk)
    res = json.loads(
        requests.get(api_url,
                     headers={'Authorization': 'Bearer '+ token}).text
    )[name][0][key]
    return res


def get_all_steps_viewed_by(course):
    sections = make_stepik_api_call_pk("courses", course, "sections")
    units = [unit
             for section in sections
             for unit in
             make_stepik_api_call_pk("sections", section, "units")]
    assignments = [assignment
                   for unit in units
                   for assignment in
                   make_stepik_api_call_pk("units", unit, "assignments")]
    steps = [make_stepik_api_call_pk("assignments", assignment, "step")
             for assignment in assignments]
    viewed_by = [make_stepik_api_call_pk("steps", step, "viewed_by")
                 for step in steps]
    return viewed_by



def main():
    # This script gets view statistics for all of the steps in some course
    # and then displays it. The trend is usually (naturally) declining
    # fetch_course_data(client_id=parse_args()['clientId'], client_secret=parse_args()['clientSecret'], course_id=parse_args()['courseId'])
    viewed_by = get_all_steps_viewed_by(parse_args()['courseId'])
    with open('TTTT_{}.json'.format(course_id), 'w') as outfile:
        json.dump(viewed_by, outfile)

    # plt.plot(viewed_by)
    # plt.show()


if __name__ == '__main__':
    main()
