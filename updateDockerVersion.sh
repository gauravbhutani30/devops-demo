#!/bin/bash
sed "s/mvnVersion/$1/g" dockerfileDynamic > Dockerfile
