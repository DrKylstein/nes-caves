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
    layers[layer_element.attrib['name']] = {
        'cells':ids,
        'width':int(layer_element.attrib['width']),
        'height':int(layer_element.attrib['height'])
    }

out = args.output

def cellAt(layer, x, y):
    return layer['cells'][y*layer['width'] + x]

if 'Names' in layers:
    out.write(bytes(layers['Names']['cells']))
if 'Attributes' in layers:
    height = layers['Attributes']['height']//4
    if layers['Attributes']['height'] % 4 > 0:
        height += 1
    
    for y in range(height):
        for x in range(layers['Attributes']['width']//4):
            data = 0
            for offsets in ((2,3),(0,3),(2,1),(0,1)):
                cell = None
                if y*4 + offsets[1] < layers['Attributes']['height']:
                    cell = cellAt(layers['Attributes'],x*4 + offsets[0],y*4 + offsets[1])
                if cell is not None and cell < 4:
                    data |= cell
                data <<= 2
            data >>= 2
            out.write(bytes([data]))

args.output.close()