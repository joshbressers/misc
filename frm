#!/usr/bin/env python

# $Id: frm 27 2006-05-25 13:00:36Z bress $

"""
This is a horribly simple frm command written in python.
"""

import mailbox
import os
import re
import sys

# Find a better way to do this someday.
pipe = os.popen('stty size')
col_rows = pipe.readlines()[0][0:-1]
columns = col_rows.split(' ')[0]
rows = col_rows.split(' ')[1]

subject_width = int(rows) - 22

mailbox_name = os.environ['MAIL']

if len(sys.argv) > 1:
    mailbox_name = sys.argv[-1]

mbox = mailbox.UnixMailbox(open(mailbox_name))

msg = mbox.next()

while msg is not None:
    mail_subject = msg.getheader('subject') or ''
    mail_from = msg.getheader('from')

    mail_subject = re.sub("\n", "", mail_subject)

    print '%-20.20s  %-*.*s' % (mail_from, int(subject_width),
        int(subject_width), mail_subject)

    msg = mbox.next()
