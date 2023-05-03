#!/bin/bash
nebula -config /cert/config.yml &> nebula.log  &
python server_multithread.py