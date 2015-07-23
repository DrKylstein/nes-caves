'''
Raw binary export for Tiled
2014 <dr.kylstein@gmail.com>

'''
from tiled import *
from tiled.qt import *

max_entities = 16

def writeColumn(out, entities, func, default):
    for i in range(max_entities):
        if 0 <= i-1 < entities.objectCount():
            out.write(chr(int(func(entities.objectAt(i-1))) & 0xFF))
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
        
        for i in range(m.layerCount()):
            layer = m.layerAt(i)
            if isTileLayerAt(m, i):
                tiles = layer.asTileLayer()
            elif isObjectGroupAt(m, i):
                entities = layer.asObjectGroup()
            
        with open(f, 'wb') as out:
            for x in range(tiles.width()):
                for y in range(tiles.height()):
                    cell = tiles.cellAt(x, y)
                    out.write(chr(cell.tile.id()))
            writeColumn(out, entities, lambda e: int(e.x()), 0xFF)
            writeColumn(out, entities, lambda e: (int(e.x())) >> 8, 0x7F)
            writeColumn(out, entities, lambda e: e.y(), 0)
            writeColumn(out, entities, lambda e: (int(e.y()) >> 8) | int(e.property('flags'),16), 0)
            writeColumn(out, entities, lambda e: e.property('index'), 0)
            writeColumn(out, entities, lambda e: e.property('velocity'), 0)
                                        
        return True
