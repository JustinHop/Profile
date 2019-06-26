#!/bin/bash

offlineimap # 2>&1 | tee >(logger -p mail.debug)
