#!/usr/bin/env bash

date >> /tmp/pinger-cron.out
curl soroush-se.herokuapp.com >> /tmp/pinger-cron.out
