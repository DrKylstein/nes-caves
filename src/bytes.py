'''
Raw binary export for Tiled
2014 <dr.kylstein@gmail.com>

'''
from tiled import *
from tiled.qt import *

class Bytes(Plugin):
        
    @classmethod
    def nameFilter(cls):
        return 'Byte Map (*.bin)'

    @classmethod
    def supportsFile(cls, f):
        return False
        
    @classmethod
    def read(cls, f):
        return None
          
    @classmethod
    def write(cls, m, f):
        tileLayer_ = None
        spriteLayer = None
        
        for i in range(m.layerCount()):
            if isTileLayerAt(m, i):
                tileLayer_ = tileLayerAt(m, i)
        
        if tileLayer_ is None:
            print 'Must have one TileLayer!'
            return False
            
        with open(f, 'wb') as out:
            for y in range(tileLayer_.height()):
                for x in range(tileLayer_.width()):
                    cell = tileLayer_.cellAt(x, y)
                    out.write(chr(cell.tile.id()))
        return True
