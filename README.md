# API Robot Framework Automation Demo
## Introduction
Welcome to the API Automation Deno using Robot Framework. Robot Framework is a Python-based, keyword-driven automation framework designed for acceptance testing, acceptance test-driven development, and behavior-driven development.

Here, I have developed sample test cases for a API Server (https://restful-booker.herokuapp.com).


### Prerequisites
After installing *pycharm* and *python*, open terminal and install below libraries to start with robot framework to start with API testing

1. Download and Install [Python](https://www.python.org/downloads/ "Python").
2. Check Python installation
    `python3 -V`
3. Install [pip](https://pip.pypa.io/ "pip").
    `pip3 -V`
4. Install below library.
    `pip3 install robotframework`
    `pip install robotframework`
    `pip install requests`
    `pip install robotframework-requests`
    `pip install -U robotframework-jsonlibrary`
    `pip install jsonpath-rw`
    `pip install jsonpath-rw-ext`


## Usage
Starting from Robot Framework 3.0, tests are executed from the command line
using the ``robot`` script or by executing the ``robot`` module directly

The basic usage is giving a path to a test (or task) file or directory as an
argument with possible command line options before the path

    robot -d results tests/.

***-d***" refers to the test results. The location to save the test results can be specified here.


Run ``robot --help`` and ``rebot --help`` for more information about the command
line usage. For a complete reference manual see [Robot Framework User Guide](https://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html "Robot Framework User Guide").
