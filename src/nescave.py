'''
Raw binary export for Tiled
2014 <dr.kylstein@gmail.com>

'''
from tiled import *
from tiled.qt import *

max_entities = 24

def writeColumn(out, entities, func, default):
    k = 0
    out.write(chr(default & 0xFF))
    for i in range(1,max_entities):
        while k < entities.objectCount() and (entities.objectAt(k).type() == 
        'start' or entities.objectAt(k).type().startswith('door')):
            k += 1
        if k < entities.objectCount():
            out.write(chr(int(func(entities.objectAt(k))) & 0xFF))
            k += 1
        else:
            out.write(chr(default & 0xFF))

class NesCave(Plugin):
        
    @classmethod
    def nameFilter(cls):
        return 'Nes Cave (*.bin)'

    @classmethod
    def supportsFile(cls, f):
        return False
        
    @classmethod
    def read(cls, f):
        return None
          
    @classmethod
    def write(cls, m, f):
        
        tiles = None
        entities = None
        
        doors = [0,0,0]
        
        for i in range(m.layerCount()):
            layer = m.layerAt(i)
            if isTileLayerAt(m, i):
                tiles = layer.asTileLayer()
            elif isObjectGroupAt(m, i):
                entities = layer.asObjectGroup()
        gemCount = 0
        with open(f, 'wb') as out:
            for x in range(tiles.width()):
                for y in range(tiles.height()):
                    cell = tiles.cellAt(x, y)
                    out.write(chr(cell.tile.id()))
            writeColumn(out, entities, lambda e: int(e.x()), 0xFF)
            writeColumn(out, entities, lambda e: (int(e.x())) >> 8, 0x80)
            writeColumn(out, entities, lambda e: e.y(), 0)
            writeColumn(out, entities, lambda e: (int(e.y()) >> 8) | (int(e.property('index')) << 1), 0)
            for i in range(entities.objectCount()):
                start = entities.objectAt(i)
                if start.type() == 'start':
                    out.write(chr(int(start.y()) & 0xFF))
                    out.write(chr(int(start.y()) >> 8))
                    out.write(chr(int(start.x()) & 0xFF))
                    out.write(chr(int(start.x()) >> 8))
                    
                    camX = min(max(int(start.x()) - 128,0),640-256-8)
                    camY = min(max(int(start.y()) - 104,0),384-208)
                    out.write(chr(camX & 0xFF))
                    out.write(chr(camX >> 8))
                    out.write(chr(camY & 0xFF))
                    out.write(chr(camY >> 8))
                    out.write(chr((camY + 96) % 240))
                    if camY+96 >= 240:
                        out.write(chr(0x08))
                    else:
                        out.write(chr(0x00))
                    break

            crystals = m.property('crystals')
            out.write(chr(int(crystals)))
            
            for i in range(entities.objectCount()):
                start = entities.objectAt(i)
                if start.type() == 'door1':
                    doors[0] = int((start.x()/16)*24 + start.y()/16)
                if start.type() == 'door2':
                    doors[1] = int((start.x()/16)*24 + start.y()/16)
                if start.type() == 'door3':
                    doors[2] = int((start.x()/16)*24 + start.y()/16)
            for door in doors:
                out.write(chr(door & 0xFF))
            for door in doors:
                out.write(chr(door >> 8))
        return True
