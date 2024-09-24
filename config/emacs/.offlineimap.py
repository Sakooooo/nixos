#! /usr/bin/env python
from subprocess import check_output
import re


def get_pass(account):
    return check_output("pass " + account, shell=True).splitlines()[0]


def get_user(account):
    usercmd = check_output("pass " + account, shell=True)

    return re.search(rb"login: (.*)", usercmd, flags=0).group(1).decode("utf-8")


def hydroxide(path):

    file = open(path, "r")

    pword = file.read()

    return pword


def get_client_id(account):
    cmd = check_output("pass " + account, shell=True)

    return re.search(rb"client_id: (.*)", cmd, flags=0).group(1)


def get_client_secret(account):
    cmd = check_output("pass " + account, shell=True)

    return re.search(rb"client_secret: (.*)", cmd, flags=0).group(1)


def get_client_refresh_token(account):
    cmd = check_output("pass " + account, shell=True)

    output = re.search("client_refresh_token: (.*)", cmd.decode(), flags=0).group(1)

    return output
