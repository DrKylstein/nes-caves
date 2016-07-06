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
                
        for i in range(m.layerCount()):
            layer = m.layerAt(i)
            if isTileLayerAt(m, i):
                if layer.name() == "Entities":
                    entities = layer.asTileLayer()
                else:
                    tiles = layer.asTileLayer()
        with open(f, 'wb') as out:
            for x in range(tiles.width()):
                for y in range(tiles.height()):
                    cell = tiles.cellAt(x, y)
                    out.write(chr(cell.tile.id()))
            for x in range(entities.width()):
                for y in range(entities.height()):
                    cell = entities.cellAt(x, y)
                    if cell.tile is not None:
                        out.write(chr(cell.tile.id()))
                        out.write(chr(x))
                        out.write(chr(y))
            out.write(chr(0xFF))
        return True
