#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import subprocess
from termcolor import colored
from PyInquirer import style_from_dict, Token, prompt
from PyInquirer import Validator, ValidationError

custom_style_3 = style_from_dict({
    Token.Separator: '#6C6C6C',
    Token.QuestionMark: '#FF9D00 bold',
    #Token.Selected: '',  # default
    Token.Selected: '#5F819D',
    Token.Pointer: '#FF9D00 bold',
    Token.Instruction: '',  # default
    Token.Answer: '#5F819D bold',
    Token.Question: '',
})

base_path = os.sep.join(os.path.realpath(__file__).split(os.sep)[:-2])

path_gen = base_path+"/generation/"
path_mapp = base_path+"/mappings/generator/"
tmp_path = base_path+"/tmp/"

try:
	os.mkdir(tmp_path)
except:
	pass


print(colored('''
   mmm mmmmmmm mmmmmm  mmmm         mmmmm  mmmmmm mm   m   mmm  m    m
 m"   "   #    #      #"   "        #    # #      #"m  # m"   " #    #
 #   mm   #    #mmmmm "#mmm         #mmmm" #mmmmm # #m # #      #mmmm#
 #    #   #    #          "#  """   #    # #      #  # # #      #    #
  "mmm"   #    #      "mmm#"        #mmmm" #mmmmm #   ##  "mmm" #    #

This script will guide in the generation of benchmarking datasets and mappings
based on the GTFS transport data format.

''', 'red'))

print('Datasets can be scaled as desired, by default we use 1, 5, 10, 50, 100, 500, 1000 and 5000 sizes but you can specify your own selection and we\'ll generate it...\n')

q1 = [
    {
        'type': 'list',
        'name': 'q',
        'message': 'So... what do you want?',
        'choices': [
			{'name':'Use pregenerated default sizes', 'value': 'default'},
			{'name':'Specify my own size(s)', 'value': 'custom'}
		],
    }
]

q2 = [
    {
        'type': 'input',
        'name': 'q',
        'message': '\nPlease, specify the size(s) separated by commas',
    }
]

q1_a = prompt(q1, style=custom_style_3)

if q1_a["q"] == 'custom':
	sizes = [int(x) for x in map(int, prompt(q2, style=custom_style_3)["q"].split(","))]

else:

	sizes = [1,5,10,50,100,500,1000,5000]

print(sizes)

#print("Starting MySQL docker image and loading data dump...")

#os.chdir(path_gen)

#debug = subprocess.run(["./prepare.sh"], capture_output=True)

for s in sizes:
	
	print("Generating dataset at scale: "+str(s))
	
	debug = subprocess.run(["./generate.sh", str(s)], capture_output=True)
	
