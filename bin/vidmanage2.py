#!/usr/bin/python3
# -*- coding: utf-8 -*-
'''vidmanage2

Usage:
    vidmanage2 init
    vidmanage2 update
    vidmanage2 new LIST
    vidmanage2 [--notify] add LIST FILE...
    vidmanage2 remove FILE
    vidmanage2 verify LIST
    vidmanage2 show LIST...
    vidmanage2 [--notify] showfile FILE...
    vidmanage2 lists
    vidmanage2 purge

'''
from __future__ import unicode_literals


import os
import os.path
import sqlite3
import subprocess

import gi
gi.require_version('Gtk', '3.0')

from gi.repository import Gtk
import notify2
import sys

from datetime import date, datetime

find_cmd = """ find -L /mnt/auto/1/share/Video /mnt/auto/2share2/Video -type f -size +100M  | grep -P -v "(crdownload|dtapart|fuse_hidden|volnorm)" """
icon = "/home/justin/Profile/python/vidmanage/vidmanage-128.png"


dbfile = os.path.expanduser('~/vid.db')
db = sqlite3.connect(
    dbfile,
    detect_types=sqlite3.PARSE_DECLTYPES | sqlite3.PARSE_COLNAMES)
db.execute("""
    CREATE TABLE IF NOT EXISTS
        list ( list_id INTEGER PRIMARY KEY, name TEXT,
            created DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
            updated DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL)
           """)
db.execute("""
    CREATE TABLE IF NOT EXISTS
        file ( file_id INTEGER PRIMARY KEY,
            list_id INTEGER, path TEXT, size UNSIGNED BIG INT,
            created DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
            updated DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL)
           """)

from docopt import docopt


def debug(m):
    print("DEBUG: {}".format(m))


def get_conf():
    conf = docopt(__doc__)
    return(conf)


def bytes_to_human(b):
    if b:
        for x in ['bytes', 'KB', 'MB', 'GB', 'TB']:
            if b < 1024.0:
                return("%3.1f %s" % (b, x))
            b /= 1024.0
    else:
        return('0 B')


def new_list(l):
    debug("new_list({})".format(l))
    db.execute("INSERT INTO list(list_id, name) VALUES(NULL, ?)", (l,))
    db.commit()


def get_list_name(list_id):
    cursor = db.cursor()
    cursor.execute(
        "SELECT name FROM list WHERE list_id = ? LIMIT 1", (list_id,))
    for row in cursor.fetchone():
        # debug("get_list_id({}): {}".format(list_name, row))
        return(row)
    raise Exception('No list {}'.format(list_name))


def get_list_id(list_name):
    # debug("get_list_id({})".format(list_name))
    cursor = db.cursor()
    cursor.execute(
        "SELECT list_id FROM list WHERE name = ? LIMIT 1", (list_name,))
    for row in cursor.fetchone():
        # debug("get_list_id({}): {}".format(list_name, row))
        return(row)
    raise Exception('No list {}'.format(list_name))


def get_lists():
    cursor = db.cursor()
    cursor.execute("SELECT list_id, name FROM list")
    for row in cursor.fetchall():
        list_id, list_name = row
        print("list_id({:2d}) list_name({:>8}) count({:6d}) size({:>10})".format(
                  list_id, list_name, get_list_size(list_id),
                  bytes_to_human(get_list_size_bytes(list_id))))


def get_list_size(list_id):
    cursor = db.cursor()
    cursor.execute(
        "SELECT count(*) FROM file WHERE list_id = ?", (list_id,))
    for row in cursor.fetchone():
        return(row)


def get_list_size_bytes(list_id):
    cursor = db.cursor()
    cursor.execute(
        "SELECT sum(size) FROM file WHERE list_id = ?", (list_id,))
    for row in cursor.fetchone():
        return(row)


def check_file(file_name):
    # debug("check_file({})".format(file_name))
    cursor = db.cursor()
    cursor.execute(
        "SELECT file_id FROM file WHERE path = ?", (file_name,))
    try:
        for row in cursor.fetchone():
            return(row)
    except TypeError:
        return(False)


def size_file(file_name):
    # debug("size_file({})".format(file_name))
    try:
        stat = os.stat(file_name)
        return(stat.st_size)
    except IOError:
        return(False)


def add_list(list_name, file_name):
    conf = get_conf()
    list_id = get_list_id(list_name)
    for file_path in file_name:
        file_id = check_file(file_path)
        file_size = size_file(file_path)
        now = datetime.now()
        debug(
            "add_list({},{}): file_id: {} file_size: {}".format(
                list_name, file_path, file_id, file_size))
        if conf['--notify']:
            do_notify("Adding:\nList({})\nFile({})\nId({})\nSize({})".format(
                list_name, file_path, file_id, bytes_to_human(file_size)))
        if file_id:
            db.execute("""
                UPDATE file SET
                    list_id = ?,
                    path = ?,
                    size = ?,
                    updated = datetime('now')
                WHERE
                    file_id = ?
                """, (list_id, file_path, file_size, file_id, ))
        else:
            db.execute("""
                INSERT INTO file(file_id, list_id, path, size)
                VALUES (NULL, ?, ?, ?)
                """, (list_id, file_path, file_size,))
        db.execute(
            "UPDATE list SET updated = datetime('now') WHERE list_id = ?",
            (list_id,))
        db.commit()


def show_list(list_name):
    list_id = get_list_id(list_name)
    cursor = db.cursor()
    cursor.execute("SELECT path from file WHERE list_id = ?", (list_id,))
    try:
        for row in cursor.fetchall():
            print(row[0])
    except TypeError:
        pass


def show_file(file_name):
    debug("show_file({})".format(file_name))
    conf = get_conf()
    cursor = db.cursor()
    cursor.execute(
        "SELECT file_id, list_id, size from file WHERE path = ?",
        (file_name[0],))
    try:
        for row in cursor.fetchall():
            file_id, list_id, file_size = row
            list_name = get_list_name(list_id)
            if conf['--notify']:
                do_notify("Query:\nList ({})\nFile ({})\nId ({})\nSize ({})".format(
                    list_name, file_name[0], file_id, bytes_to_human(file_size)))
    except TypeError:
        pass


def do_init():
    new_list('a')
    new_list('b')
    new_list('c')
    new_list('delete')
    new_list('new')


def do_find():
    # debug("do_find(): {}".format(find_cmd))
    for line in subprocess.Popen(
            find_cmd, shell=True, stdout=subprocess.PIPE).communicate()[0].decode(
            'utf-8').splitlines():
        # debug("do_find(): line {}".format(line))
        f = str(line)

        file_id = check_file(f)

        if not file_id:
            add_list('new', [f])


def do_deletes():
    cursor = db.cursor()
    cursor.execute("SELECT file_id, path FROM file")

    bad_ids = []
    for row in cursor.fetchall():
        file_id, path = row
        if not os.path.exists(path):
            debug(
                "do_deletes(): Removing file_id {} File not found {}".format(
                    file_id, path))
            bad_ids.append(file_id)

    for f_id in bad_ids:
        db.execute("DELETE FROM file WHERE file_id = ?", (f_id,))

    db.commit()


def do_update():
    do_find()
    do_deletes()


def do_purge():
    list_id = get_list_id('delete')
    cursor = db.cursor()
    cursor.execute(
        "SELECT file_id, path FROM file WHERE list_id = ?", (list_id, ))

    for row in cursor.fetchall():
        file_id, path = row
        debug("do_purge(): would delete {}".format(path))
    # do_deletes()


def do_notify(message):
    if not notify2.init("Vidmanage2.py", mainloop='glib'):
        sys.exit(1)

    n = notify2.Notification("Vidmanage2.py", message,
                             icon)

    n.show()


def main():
    conf = get_conf()
    # print(conf)

    if conf['init']:
        do_init()
    elif conf['update']:
        do_update()
    elif conf['show'] and conf['LIST']:
        for l in conf['LIST']:
            show_list(l)
    elif conf['showfile'] and conf['FILE']:
        show_file(conf['FILE'])
    elif conf['new'] and conf['LIST']:
        new_list(conf['LIST'])
    elif conf['lists']:
        get_lists()
    elif conf['add'] and conf['LIST'] and conf['FILE']:
        for l in conf['LIST']:
            add_list(l, conf['FILE'])
    elif conf['remove'] and conf['FILE']:
        add_list(conf['LIST'], conf['FILE'])

    db.close()


if __name__ == "__main__":
    main()
