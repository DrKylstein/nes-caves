#!/usr/bin/python3

import xml.etree.ElementTree as ET
import base64
import zlib
import argparse
import sys

argparser = argparse.ArgumentParser()
argparser.add_argument('input')
argparser.add_argument('-o','--output',type=argparse.FileType('wb'),default=sys.stdout.buffer)
args = argparser.parse_args()

root = ET.parse(args.input).getroot()

base_gids = [int(e.attrib['firstgid']) for e in root.findall('tileset')]

base_gids.reverse()

layer_elements = root.findall('layer')
layers = {}
for layer_element in layer_elements:
    data_element = layer_element.find('data')
    data_bytes = zlib.decompress(base64.b64decode(data_element.text))
    gids = []
    for i in range(len(data_bytes)//4):
        gids.append((data_bytes[i*4] | (data_bytes[i*4 + 1] << 8) | 
        (data_bytes[i*4 + 2] << 16) | (data_bytes[i*4 + 3] << 32))& 0x1FFFFFFF)
        
    ids = []
    for gid in gids:
        if gid <= 0:
            ids.append(None)
        else:
            ids.append(gid - [b for b in base_gids if b <= gid][0])
    if layer_element.attrib['name'] != 'Entities':
        layers['Tiles'] = ids
    else:
        layers[layer_element.attrib['name']] = ids

for x in range(40):
    for y in range(24):
        args.output.write(bytes([layers['Tiles'][x + y*40]]))
                
for x in range(40):
    for y in range(24):
        if layers['Entities'][x + y*40] is not None:
            args.output.write(bytes([layers['Entities'][x + y*40],x,y]))

args.output.write(bytes([0xFF]))
args.output.close()