import json
import argparse
import requests
import matplotlib.pyplot as plt

import multiprocessing as mp
from joblib import Parallel, delayed

from tqdm import tqdm

import time
import copy
import pdb


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
    return(res)

def make_stepik_api_call_pk_full(name, pk):
    api_url = 'https://stepik.org/api/{}/{}'.format(name, pk)
    res = json.loads(
        requests.get(api_url,
                     headers={'Authorization': 'Bearer '+ token}).text
    )[name][0]
    return(res)


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
    return(viewed_by)

def get_ALL(course):
    sections = make_stepik_api_call_pk("courses", course, "sections") ## secitons ids, list
    sections_ls = list()
    for section in tqdm(sections):
        sections_dict = {}
        sect_local = make_stepik_api_call_pk_full("sections", section)
        sections_dict['section_id'] = sect_local['id']
        sections_dict['section_title'] = sect_local['title']
        sections_ls.append(sections_dict)
    return(sections_ls)


def gt2(dt):
    sections_ls = copy.deepcopy(dt)
    for (index, section_el) in enumerate(tqdm(sections_ls)):
        units_ls = list()
        units = make_stepik_api_call_pk("sections", section_el['section_id'], "units")
        for unit in units:
            units_dict = {}
            units_local = make_stepik_api_call_pk_full("units", unit)
            units_dict['unit_id'] = units_local['id']
            ## no Title
            # units_dict['unit_title'] = units_local['title']
            units_ls.append(units_dict)
        sections_ls[index]['units'] = units_ls
    return(sections_ls)


def gt3(dt):
    sections = copy.deepcopy(dt)
    for (index_section, section) in enumerate(tqdm(sections)):
        for (index_unit, unit) in enumerate(section['units']):
            assignments_ls = list()
            for assignment in make_stepik_api_call_pk("units", unit["unit_id"], "assignments"):
                assignments_dict = {}
                assignments_local = make_stepik_api_call_pk_full("assignments", assignment)
                assignments_dict['assignment_id'] = assignments_local['id']
                assignments_ls.append(assignments_dict)
            sections[index_section]['units'][index_unit]['assignments'] = assignments_ls
    return(sections)



def gt4(dt):
    sections = copy.deepcopy(dt)
    for (index_section, section) in enumerate(tqdm(sections)):
        for (index_unit, unit) in enumerate(section['units']):
            for (index_assignment, assignment) in enumerate(unit["assignments"]):
                steps_ls = list()
                for step in make_stepik_api_call_pk("assignments", assignment['assignment_id'], "step"):
                    steps_dict = {}
                    steps_local = make_stepik_api_call_pk_full("steps", step)
                    steps_dict['step_id'] = steps_local['id']
                    steps_dict['viewed_by'] = steps_local['viewed_by']
                    steps_dict['passed_by'] = steps_local['passed_by']
                    steps_ls.append(steps_dict)
                sections[index_section]['units'][index_unit]['assignments'][index_assignment]['steps'] = steps_ls
    return(sections)


## check whether object is a list
## if not, wraps up as a list
def check_type(x):
    if type(x) == type(list()):
        return(x)
    else:
        return([x])

## I dont want to mutate input
## meanwhile, I need to return 
def gt4_parallel(x):
    index_section = x[0]
    section = copy.deepcopy(x[1])
    for (index_unit, unit) in enumerate(section['units']):
        for (index_assignment, assignment) in enumerate(unit["assignments"]):
            steps_ls = list()
            for step in check_type(make_stepik_api_call_pk("assignments", assignment['assignment_id'], "step")):
                steps_dict = {}
                steps_local = make_stepik_api_call_pk_full("steps", step)
                steps_dict['step_id'] = steps_local['id']
                steps_dict['viewed_by'] = steps_local['viewed_by']
                steps_dict['passed_by'] = steps_local['passed_by']
                steps_ls.append(steps_dict)
            section['units'][index_unit]['assignments'][index_assignment]['steps'] = steps_ls
    return(section)


## diminish this
def aggregate_fun(dt):
    sections = copy.deepcopy(dt) ## deep copy
    for (index_section, section) in tqdm(enumerate(sections)):
        aggr = 0
        aggr1 = 0
        for (index_unit, unit) in enumerate(section['units']):
            for (index_assignment, assignment) in enumerate(unit["assignments"]):
                for (index_step, step) in enumerate(assignment["steps"]):
                    aggr += step['viewed_by']
                    aggr1 += step['passed_by']
        sections[index_section]['viewed_by'] = aggr
        sections[index_section]['passed_by'] = aggr1
    return sections


def flatten_section(dt_aggr):
    return [{'sec': dict_inst['section_id'], 'viewed': dict_inst['viewed_by'], 'passed': dict_inst['passed_by']}
     for (index, dict_inst) in enumerate(dt_aggr)]

def flatten_list(dt_aggr, variable):
    return [dict_inst[str(variable)]
            for (index, dict_inst) in enumerate(dt_aggr)]




def main():
    # This script gets view statistics for all of the steps in some course
    # and then displays it. The trend is usually (naturally) declining
    course = course_id
    num_cores = mp.cpu_count()

    dt = get_ALL(course_id)
    dt2 = gt2(dt)
    dt3 = gt3(dt2)

    with mp.Pool(processes = num_cores) as p:
        dt4 = list(tqdm(p.imap(gt4_parallel,
                               [(index_section, section) for index_section, section in enumerate(dt3)]), total = len(dt3)))

        dt_aggr = aggregate_fun(dt4)
        data_inst = flatten_section(dt_aggr)

        # viewed_by = get_all_steps_viewed_by(course)
        # return(viewed_by)

if __name__ == '__main__':
    main()
