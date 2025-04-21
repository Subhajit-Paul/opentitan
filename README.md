# OpenTitan

![OpenTitan logo](https://docs.opentitan.org/doc/opentitan-logo.png)

## About the project

## This is a fork of the original OpenTitan repository with commit ID: 6202b47f26. This `src` branch has been started from this commit.
Follow these steps:
---
1. clone opentitan from this fork: `git clone https://github.com/Subhajit-Paul/opentitan.git`
2. `cd opentitan`
3. go to this branch: `git checkout src`
4. create and activate environment: `python3.8 -m venv titan-env && source titan-env/bin/activate`
5. `pip install python-requirements.txt`
6. `deactivate`
7. test quick run with: `./util/dvsim/dvsim.py ./hw/top_earlgrey/formal/top_earlgrey_fpv_ip_cfgs.hjson --select-cfgs gpio_fpv --run-timeout-mins 180 --build-timeout-mins 180`
8. Reports and Logs can be found inside `./scratch/master/gpio_fpv-formal-fpv-jaspergold/default/` folder

---

[OpenTitan](https://opentitan.org) is an open source silicon Root of Trust
(RoT) project.  OpenTitan will make the silicon RoT design and implementation
more transparent, trustworthy, and secure for enterprises, platform providers,
and chip manufacturers.  OpenTitan is administered by [lowRISC
CIC](https://www.lowrisc.org) as a collaborative project to produce high
quality, open IP for instantiation as a full-featured product. See the
[OpenTitan site](https://opentitan.org/) and [OpenTitan
docs](https://opentitan.org/book) for more information about the project.

## About this repository

This repository contains hardware, software and utilities written as part of the
OpenTitan project. It is structured as monolithic repository, or "monorepo",
where all components live in one repository. It exists to enable collaboration
across partners participating in the OpenTitan project.

## Documentation

The project contains comprehensive documentation of all IPs and tools. You can
access it [online at docs.opentitan.org](https://docs.opentitan.org/).

## How to contribute

Have a look at [CONTRIBUTING](CONTRIBUTING.md) and our [documentation on
project organization and processes](./doc/project_governance/README.md)
for guidelines on how to contribute code to this repository.

## Licensing

Unless otherwise noted, everything in this repository is covered by the Apache
License, Version 2.0 (see [LICENSE](https://github.com/lowRISC/opentitan/blob/master/LICENSE) for full text).
