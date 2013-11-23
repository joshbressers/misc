#!/bin/env python

import sys
import mhlib

def link_message(message_number, current_folder):
    folder.copymessage(message_number, current_folder, message_number)
    the_message_id = folder.openmessage(message_number).getheader('message-id')
    if reply_tos.has_key(the_message_id):
        # create message folder
        reply_folder = "%s/%d-reply" % (current_folder.name, message_number)
        the_mh.makefolder(reply_folder)
        # foreach child
        for i in reply_tos[the_message_id]:
            link_message(i, the_mh.openfolder(reply_folder))

# Global Varialbes
message_ids = {}
message_ids_reverse = {}
reply_tos = {}
thread_tops = {}

the_mh = mhlib.MH()

# Open the folder
if len(sys.argv) > 1:
    context = sys.argv[1]
    if context[0] == '+':
        context = context[1:]
else:
    context = the_mh.getcontext()
folder = the_mh.openfolder(context)

# read all message ids and reply-to headers

messages = folder.listmessages()
print "1"
for i in messages:
    print i
    one_message = folder.openmessage(i)
    message_ids[one_message.getheader('message-id')] = i
    message_ids_reverse[i] = one_message.getheader('message-id')
    if (one_message.getheader('in-reply-to')):
        # Store the reply-to headers in a dictionary
        if reply_tos.has_key(one_message.getheader('in-reply-to')):
            reply_tos[one_message.getheader('in-reply-to')].append(i)
        else:
            reply_tos[one_message.getheader('in-reply-to')] = [i]
    else:
        # Find all messages without reply-to headers
        thread_tops[i] = one_message.getheader('message-id')

for i in reply_tos:
    # Also look for messages with a in-reply-to, but the reply isn't in the
    # folder
    if not message_ids.has_key(i):
        for j in reply_tos[i]:
            thread_tops[j] = reply_tos[i]

# create the thread folder
# If it exists, die (fix this later)
thread_folder_name = folder.name + '/thread'
the_mh.makefolder(thread_folder_name)
thread_folder = the_mh.openfolder(thread_folder_name)

# Put those in the thread folder
for i in thread_tops:
    # XXX: This doesn't hard link (it should)
    link_message(i, thread_folder)
