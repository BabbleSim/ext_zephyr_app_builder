# Copyright 2018 Oticon A/S
# SPDX-License-Identifier: Apache-2.0

#This make script is nothing else than a shortcut

default: #nothing

BSIM_BASE_PATH?=$(abspath ../ )
include ${BSIM_BASE_PATH}/common/pre.make.inc

APP_ROOT?=${ZEPHYR_BASE}
BOARD_ROOT?=${ZEPHYR_BASE}
BOARD?=nrf52_bsim
APP?=samples/hello_world
CONF_FILE?=prj.conf
CMAKE_ARGS?=
NINJA_ARGS?=
APP_s:=$(subst /,_,${APP})
EXE_NAME:=${BSIM_OUT_PATH}/bin/bs_${BOARD}_${APP_s}
MAP_FILE_NAME=${EXE_NAME}.Tsymbols

override BSIM_COMPONENTS_PATH:=$(abspath ${BSIM_COMPONENTS_PATH})
override BSIM_OUT_PATH:=$(abspath ${BSIM_OUT_PATH})

export BOARD
export BOARD_ROOT
export CONF_FILE
export BSIM_COMPONENTS_PATH
export BSIM_OUT_PATH

all: install

compile:
	@if [ -z "$$ZEPHYR_BASE" ]; then \
	  echo "ZEPHYR_BASE must be set to point the zephyr root directory" 1>&2; \
	  exit 1; \
	fi
	@cd ${ZEPHYR_BASE} && source zephyr-env.sh && \
	cd ${APP_ROOT}/${APP} && mkdir build ; \
	cd ${APP_ROOT}/${APP}/build && cmake -GNinja -DBOARD_ROOT=${BOARD_ROOT} -DBOARD=${BOARD} -DCONF_FILE=${CONF_FILE} ${CMAKE_ARGS} .. > /dev/null && ninja ${NINJA_ARGS}

${EXE_NAME}: compile
	@cp ${APP_ROOT}/${APP}/build/zephyr/zephyr.exe ${EXE_NAME}

${MAP_FILE_NAME}: ${EXE_NAME}
	@nm ${EXE_NAME} | grep -v " [U|w] " | sort | cut -d" " -f1,3 > ${MAP_FILE_NAME} ; sed -i "1i $$(wc -l ${MAP_FILE_NAME} | cut -d" " -f1)" ${MAP_FILE_NAME}

install: ${MAP_FILE_NAME} ${EXE_NAME}

clean:
	@rm ${APP_ROOT}/${APP}/build -rf ; true
	@rm ${EXE_NAME} ${MAP_FILE_NAME} ; true

help:
	@echo "Avaliable rules:"
	@echo " Compile, install & clean"
	@echo "variables you may change:"
	@echo " BOARD (nrf52_bsim)"
	@echi " BOARD_ROOT ($ZEPHYR_BASE)"
	@echo " APP (samples/hello_world)"
	@echo " APP_ROOT ($ZEPHYR_BASE)"
	@echo " CONF_FILE (prj.conf)"
	@echo " CMAKE_ARGS"
	@echo " NINJA_ARGS"
	@echo "Just open this makefile for more info"
