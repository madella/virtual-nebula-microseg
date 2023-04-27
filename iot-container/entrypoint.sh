#!/bin/bash
nebula -config /cert/config.yml > nebula.log 2>&1 &
python client.py
