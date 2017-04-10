# -*- coding: utf-8 -*-
import urllib

import dateutil.parser
import datetime
# import datetime.timedelta
# from datetime import datetime
# from robot.libraries.BuiltIn import BuiltIn
from iso8601 import parse_date


def convert_datetime_to_calendar_format(isodate):
    iso_dt = parse_date(isodate)
    day_string = iso_dt.strftime("%d %b %Y %H:%M")
    return day_string


def convert_datetime_to_calendar_plus_days(isodate, dplus):
    iso_dt = parse_date(isodate)
    iso_dt = iso_dt + datetime.timedelta(days=int(dplus))
    day_string = iso_dt.strftime("%d %b %Y %H:%M")
    return day_string


def convert_datetime_to_calendar_plus_minutes(isodate, dplus):
    iso_dt = parse_date(isodate)
    iso_dt = iso_dt + datetime.timedelta(minutes=int(dplus))
    day_string = iso_dt.strftime("%d %b %Y %H:%M")
    return day_string


def get_local_id_from_url(tender_url):
    return str(tender_url[tender_url.rfind("/") + 1:])


def get_local_id_from_url_int(tender_url):
    return int(tender_url[tender_url.rfind("/") + 1:])


def assemble_viewtender_url(home_url, tender_id):
    newUrl = home_url[:home_url.rfind("/dashboard/tender-drafts")]
    return newUrl + "/tenders/" + tender_id


def convert_datetime_to_new(isodate):
    iso_dt = parse_date(isodate)
    day_string = iso_dt.strftime("%d/%m/%Y")
    return day_string


def convert_datetime_to_new_time(isodate):
    iso_dt = parse_date(isodate)
    day_string = iso_dt.strftime("%H:%M")
    return day_string


# def convert_datetime_to_new_time_ms(isodate):
#     iso_dt = parse_date(isodate)
#     day_string = iso_dt.strftime("%H:%M:%S.%mS")
#     return day_string

def parse_smth(text, count, delim):
    address = text.split(delim)
    return address[count]


def adapt_data(tender_data):
    tender_data.data.procuringEntity['name'] = u"accOwner"
    # tender_data.data.procuringEntity['identifier']['legalName'] = u"accOwner"
    # tender_data.data.procuringEntity['identifier']['id'] = u"111111111111111"
    return tender_data


def adapt_time(time):
    return time.join('.000')


def adapt_numbers(data):
    return repr(data)

def download_file(url, file_name, output_dir):
    urllib.urlretrieve(url, ('{}/{}'.format(output_dir, file_name)))

def adapt_numbers2(data):
    return float(data)


def get_numberic_part(somevalue):
    resvalue = ""
    for i in somevalue:
        if i in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."]:
            resvalue = resvalue + i
        elif i in [","]:
            resvalue = resvalue + '.'
    return resvalue


def do_strip_date(somevalue):
    resvalue = somevalue.strip()
    resvalue = resvalue.strip("\t\n")
    resvalue = resvalue.replace("\n", " ")
    resvalue = ' '.join(resvalue.split())
    resvalue = resvalue.replace("\t", "")
    resvalue = resvalue.replace("\r", "")
    return resvalue


def convert_dt(somedate):
    dt = datetime.datetime.strptime(somedate, "%d.%m.%Y %H:%M")
    return dt