#!/bin/bash
nebula -config /cert/config.yml &> nebula.log &
python client.py
