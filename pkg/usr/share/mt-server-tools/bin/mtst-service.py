#!/usr/bin/python3

from jinja2 import Template
import re
import argparse

service_template_location = "/usr/share/mt-server-tools/resources/service.template"
service_destination = "/etc/systemd/system/%s.service"

args = argparse.ArgumentParser()
args.add_argument("")

'''
Required:
    user_name
    command_string

Optional:
    description
    after
    restart
    wanted_by
'''

def openTemplate(path):
    fh = open(path)
    lines = fh.readlines()
    fh.close()
    
    return Template( "".join(lines) )

def varify(name):
    return re.replace(name, "[^a-zA-Z0-9]+", "_")

def getServiceDestination(name):
    return service_destination % name
