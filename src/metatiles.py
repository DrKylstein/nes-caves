'''
Raw binary export for Tiled
2014 <dr.kylstein@gmail.com>

'''
from tiled import *
from tiled.qt import *

class Metatiles(Plugin):
        
    @classmethod
    def nameFilter(cls):
        return 'Metatiles (*.bin)'

    @classmethod
    def supportsFile(cls, f):
        return False
        
    @classmethod
    def read(cls, f):
        return None
          
    @classmethod
    def write(cls, m, f):
        
        layers = {'Names':None, "Color":None, "Behavior":None}
        
        for layer in [m.layerAt(i) for i in range(m.layerCount())]:
            for key in layers:
                if layer.name() == key:
                    layers[key] = layer.asTileLayer()

        for key, item in layers.items():
            if item is None:
                print 'Missing layer "{}"!'.format(key)
                return False
                
        with open(f, 'wb') as out:
            for offsets in ((0,0),(1,0),(0,1),(1,1)):
                for y in range(layers['Names'].height()/2):
                    for x in range(layers['Names'].width()/2):
                        cell = layers['Names'].cellAt(x*2 + offsets[0], y*2 + offsets[1])
                        out.write(chr(cell.tile.id()))
            for y in range(layers['Color'].height()/2):
                for x in range(layers['Color'].width()/2):
                    val = 0;
                    cell = layers['Color'].cellAt(x*2, y*2 + 1)
                    if cell is not None and cell.tile is not None:
                        val = cell.tile.id()
                    cell = layers['Behavior'].cellAt(x*2, y*2 + 1)
                    if cell is not None and cell.tile is not None:
                        val |= cell.tile.id() << 2
                    out.write(chr(val))
        return True
