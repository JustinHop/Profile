#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import click

@click.group()
@click.version_option()
def cli():
    """MultiMultiMedia

    Manage multiple multimedia
    """
    pass

@cli.group()

